import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// States for the timer state machine
enum TimerState {
  idleInspection, // Waiting to start inspection
  inspection, // 15s countdown
  ready, // Armed, waiting for long-press release
  running, // Timing in progress
  stopped, // Solve finished
}

class TrainingTimer extends StatefulWidget {
  final VoidCallback onStart;
  final Function(int timeMs) onStop;
  final VoidCallback? onPhaseComplete;
  final Function(TimerState)? onStateChanged;
  final bool useInspection;
  final bool manualInspection;
  final String? currentPhaseLabel;

  const TrainingTimer({
    super.key,
    required this.onStart,
    required this.onStop,
    this.onPhaseComplete,
    this.onStateChanged,
    this.useInspection = true,
    this.manualInspection = true,
    this.currentPhaseLabel,
  });

  @override
  State<TrainingTimer> createState() => TrainingTimerState();
}

class TrainingTimerState extends State<TrainingTimer>
    with SingleTickerProviderStateMixin {
  TimerState _state = TimerState.stopped;
  final Stopwatch _stopwatch = Stopwatch();
  Stopwatch get stopwatch => _stopwatch;
  Timer? _tickTimer;

  // Inspection logic
  int _inspectionSeconds = 15;
  Timer? _inspectionTimer;

  // High-precision display
  String _displayTime = '0.00';

  // Long-press arming logic
  bool _isHolding = false;
  DateTime? _holdStartTime;

  void _updateState(TimerState newState) {
    if (_state != newState) {
      if (mounted) {
        setState(() {
          _state = newState;
        });
      }
      if (widget.onStateChanged != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) widget.onStateChanged!(newState);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _resetToStart();
  }

  @override
  void didUpdateWidget(TrainingTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.useInspection != oldWidget.useInspection ||
        widget.manualInspection != oldWidget.manualInspection) {
      if (_state == TimerState.stopped ||
          _state == TimerState.idleInspection ||
          _state == TimerState.ready) {
        _resetToStart();
      }
    }
  }

  void _resetToStart() {
    if (widget.useInspection) {
      if (widget.manualInspection) {
        _displayTime = "15";
        _updateState(TimerState.idleInspection);
      } else {
        _startInspection();
      }
    } else {
      _displayTime = "0.00";
      _updateState(TimerState.ready);
    }
  }

  void _startInspection() {
    _displayTime = "15";
    _inspectionSeconds = 15;
    _updateState(TimerState.inspection);

    _inspectionTimer?.cancel();
    _inspectionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_inspectionSeconds > 0) {
        setState(() {
          _inspectionSeconds--;
          _displayTime = _inspectionSeconds.toString();
        });
        if (_inspectionSeconds <= 3 && _inspectionSeconds > 0) {
          HapticFeedback.vibrate();
        }
      } else {
        // Auto-start at 0
        _inspectionTimer?.cancel();
        _startTimer();
      }
    });
  }

  void _skipInspection() {
    _inspectionTimer?.cancel();
    _displayTime = "0.00";
    _updateState(TimerState.ready);
    HapticFeedback.lightImpact();
  }

  void _arm() {
    if (_state != TimerState.ready) return;
    setState(() => _isHolding = true);
    _holdStartTime = DateTime.now();
  }

  void _startTimer() {
    // Allow start from ready OR inspection (auto-start)
    if (_state != TimerState.ready && _state != TimerState.inspection) return;

    _stopwatch.reset();
    _stopwatch.start();
    setState(() {
      _isHolding = false;
    });
    _updateState(TimerState.running);

    widget.onStart();

    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() {
        _displayTime =
            (_stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(2);
      });
    });
  }

  void _stopTimer() {
    if (_state != TimerState.running) return;

    _stopwatch.stop();
    _tickTimer?.cancel();
    final finalTime = _stopwatch.elapsedMilliseconds;

    _displayTime = (finalTime / 1000).toStringAsFixed(2);
    _updateState(TimerState.stopped);

    widget.onStop(finalTime);
    HapticFeedback.mediumImpact();
  }

  void _handleTapDown() {
    if (_state == TimerState.ready) {
      _arm();
    }
  }

  void _handleTapUp() {
    if (_state == TimerState.idleInspection) {
      _startInspection();
    } else if (_state == TimerState.inspection) {
      // Tap during inspection skips to ready
      _skipInspection();
    } else if (_state == TimerState.ready && _isHolding) {
      final holdDuration = DateTime.now().difference(_holdStartTime!);
      if (holdDuration.inMilliseconds >= 300) {
        _startTimer();
      } else {
        setState(() => _isHolding = false);
      }
    } else if (_state == TimerState.running) {
      if (widget.onPhaseComplete != null) {
        widget.onPhaseComplete!();
      } else {
        _stopTimer();
      }
    } else if (_state == TimerState.stopped) {
      _resetToStart();
    }
  }

  // Public method to stop if controlled externally (e.g. training logic)
  void forceStop() => _stopTimer();

  @override
  void dispose() {
    _tickTimer?.cancel();
    _inspectionTimer?.cancel();
    super.dispose();
  }

  Color _getStateColor() {
    switch (_state) {
      case TimerState.idleInspection:
        return Colors.orangeAccent;
      case TimerState.inspection:
        return Colors.orange;
      case TimerState.ready:
        return _isHolding ? Colors.green : Colors.white70;
      case TimerState.running:
        return Colors.blueAccent;
      case TimerState.stopped:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getStateColor();

    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_state == TimerState.idleInspection) ...[
              Text('ISPEZIONE',
                  style: TextStyle(
                      color: color.withValues(alpha: 0.7),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5)),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _startInspection,
                icon: const Icon(Icons.timer_outlined),
                label: const Text('AVVIA TIMER ISPEZIONE'),
                style: TextButton.styleFrom(foregroundColor: color),
              ),
            ],
            if (_state == TimerState.inspection) ...[
              Text('ISPEZIONE IN CORSO',
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5)),
              const SizedBox(height: 10),
              // Optional: Keep skip button or remove it based on preference
              TextButton.icon(
                onPressed: _skipInspection,
                icon: const Icon(Icons.skip_next),
                label: const Text('SALTA (PRONTO)'),
                style: TextButton.styleFrom(foregroundColor: color),
              ),
            ],
            if (_state == TimerState.ready && !_isHolding)
              const Text('TIENI PREMUTO PER INIZIARE',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
            if (_state == TimerState.ready && _isHolding)
              const Text('RILASCIA PER PARTIRE',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(
              _displayTime,
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: color,
              ),
            ),
            if (_state == TimerState.running &&
                widget.currentPhaseLabel != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    widget.currentPhaseLabel!.toUpperCase(),
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (_state == TimerState.stopped)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('TOCCA PER RESET',
                    style: TextStyle(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.5))),
              ),
          ],
        ),
      ),
    );
  }
}
