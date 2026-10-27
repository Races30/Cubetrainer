import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/ios_platform_helper.dart';

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
  bool _isArmed = false;
  DateTime? _holdStartTime;
  Timer? _armTimer;

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
    _armTimer?.cancel();
    _isHolding = false;
    _isArmed = false;
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
        if (!mounted) return;
        setState(() {
          _inspectionSeconds--;
          _displayTime = _inspectionSeconds.toString();
        });
        if (_inspectionSeconds <= 3 && _inspectionSeconds > 0) {
          IosPlatformHelper.mediumImpact();
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
    IosPlatformHelper.lightImpact();
  }

  void _arm() {
    if (_state != TimerState.ready) return;
    _armTimer?.cancel();
    setState(() {
      _isHolding = true;
      _isArmed = false;
    });
    _holdStartTime = DateTime.now();
    IosPlatformHelper.selectionClick();

    _armTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted && _isHolding && _state == TimerState.ready) {
        setState(() {
          _isArmed = true;
        });
        IosPlatformHelper.mediumImpact();
      }
    });
  }

  void _startTimer() {
    // Allow start from ready OR inspection (auto-start)
    if (_state != TimerState.ready && _state != TimerState.inspection) return;

    _armTimer?.cancel();
    _stopwatch.reset();
    _stopwatch.start();
    setState(() {
      _isHolding = false;
      _isArmed = false;
    });
    _updateState(TimerState.running);
    IosPlatformHelper.lightImpact();

    widget.onStart();

    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!mounted) return;
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
    IosPlatformHelper.heavyImpact();
  }

  void _handleTapDown() {
    if (_state == TimerState.ready) {
      _arm();
    } else if (_state == TimerState.running) {
      // Stop immediately on finger touch down for authentic WCA speedcubing responsiveness
      if (widget.onPhaseComplete != null) {
        widget.onPhaseComplete!();
      } else {
        _stopTimer();
      }
    }
  }

  void _handleTapUp() {
    _armTimer?.cancel();
    if (_state == TimerState.idleInspection) {
      _startInspection();
    } else if (_state == TimerState.inspection) {
      // Tap during inspection skips to ready
      _skipInspection();
    } else if (_state == TimerState.ready && _isHolding) {
      final holdDuration = _holdStartTime != null
          ? DateTime.now().difference(_holdStartTime!)
          : Duration.zero;
      if (_isArmed || holdDuration.inMilliseconds >= 300) {
        _startTimer();
      } else {
        setState(() {
          _isHolding = false;
          _isArmed = false;
        });
      }
    } else if (_state == TimerState.stopped) {
      _resetToStart();
    }
  }

  void _handleTapCancel() {
    _armTimer?.cancel();
    if (_isHolding || _isArmed) {
      if (mounted) {
        setState(() {
          _isHolding = false;
          _isArmed = false;
        });
      }
    }
  }

  // Public method to stop if controlled externally (e.g. training logic)
  void forceStop() => _stopTimer();

  @override
  void dispose() {
    _armTimer?.cancel();
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
        if (_isArmed) return Colors.greenAccent;
        if (_isHolding) return Colors.amberAccent;
        return Colors.white70;
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxH = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height * 0.45;
        final isCompact = maxH < 220;
        final verticalPad = (maxH * 0.06).clamp(8.0, 32.0);
        final timerFontSize = isCompact ? 56.0 : 80.0;

        return GestureDetector(
          onTapDown: (_) => _handleTapDown(),
          onTapUp: (_) => _handleTapUp(),
          onTapCancel: _handleTapCancel,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              vertical: verticalPad,
              horizontal: 16,
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_state == TimerState.idleInspection) ...[
                    Text(
                      'ISPEZIONE',
                      style: TextStyle(
                        color: color.withValues(alpha: 0.7),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: isCompact ? 11 : 13,
                      ),
                    ),
                    SizedBox(height: isCompact ? 4 : 8),
                    TextButton.icon(
                      onPressed: _startInspection,
                      icon: const Icon(Icons.timer_outlined),
                      label: const Text('AVVIA TIMER ISPEZIONE'),
                      style: TextButton.styleFrom(
                        foregroundColor: color,
                        minimumSize: const Size(48, 44),
                      ),
                    ),
                  ],
                  if (_state == TimerState.inspection) ...[
                    Text(
                      'ISPEZIONE IN CORSO',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: isCompact ? 11 : 13,
                      ),
                    ),
                    SizedBox(height: isCompact ? 4 : 8),
                    TextButton.icon(
                      onPressed: _skipInspection,
                      icon: const Icon(Icons.skip_next),
                      label: const Text('SALTA (PRONTO)'),
                      style: TextButton.styleFrom(
                        foregroundColor: color,
                        minimumSize: const Size(48, 44),
                      ),
                    ),
                  ],
                  if (_state == TimerState.ready && !_isArmed)
                    Text(
                      'TIENI PREMUTO PER INIZIARE',
                      style: TextStyle(
                        color: _isHolding ? Colors.amberAccent : Colors.white54,
                        fontSize: 12,
                        fontWeight:
                            _isHolding ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  if (_state == TimerState.ready && _isArmed)
                    const Text(
                      'RILASCIA PER PARTIRE',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: isCompact ? 8 : 16),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _displayTime,
                      style: TextStyle(
                        fontSize: timerFontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        fontFeatures: const [FontFeature.tabularFigures()],
                        color: color,
                      ),
                    ),
                  ),
                  if (_state == TimerState.running &&
                      widget.currentPhaseLabel != null)
                    Padding(
                      padding: EdgeInsets.only(top: isCompact ? 8 : 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: color.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          widget.currentPhaseLabel!.toUpperCase(),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (_state == TimerState.stopped)
                    Padding(
                      padding: EdgeInsets.only(top: isCompact ? 8 : 16),
                      child: Text(
                        'TOCCA PER RESET',
                        style: TextStyle(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
