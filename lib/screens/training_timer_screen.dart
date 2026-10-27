import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/exercise_type.dart';
import '../models/solve.dart';
import '../models/training_solve.dart';
import '../models/training_session.dart';
import '../services/training_repository.dart';
import '../services/training_scrambler.dart';
import '../services/goal_repository.dart';
import '../utils/ios_platform_helper.dart';
import '../widgets/goal_banner.dart';
import '../widgets/goal_setup_sheet.dart';
import 'training_report_screen.dart';
import '../widgets/training_timer.dart';
import 'package:uuid/uuid.dart';

class TrainingTimerScreen extends ConsumerStatefulWidget {
  final ExerciseType initialType;
  final bool useInspection;
  final bool manualInspection;
  final double targetTime;
  final CubeType cubeType;

  const TrainingTimerScreen({
    super.key,
    required this.initialType,
    required this.useInspection,
    required this.manualInspection,
    required this.targetTime,
    required this.cubeType,
  });

  @override
  ConsumerState<TrainingTimerScreen> createState() =>
      _TrainingTimerScreenState();
}

class _TrainingTimerScreenState extends ConsumerState<TrainingTimerScreen> {
  final String _sessionId = const Uuid().v4();
  ExerciseType _currentType = ExerciseType.cross;

  final List<TrainingSolve> _sessionSolves = [];
  String _currentScramble = '';

  Map<String, int> _currentPhases = {};
  int _lastPhaseTime = 0;
  List<String> _phaseLabels = [];

  final GlobalKey<TrainingTimerState> _timerKey = GlobalKey();
  TimerState _timerState = TimerState.stopped;
  late bool _useInspection;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _useInspection = widget.useInspection;
    _currentType = widget.initialType;
    _setupPhases();
    _generateNextScramble();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void _onTypeChanged(ExerciseType? newType) {
    if (newType == null || newType == _currentType) return;
    IosPlatformHelper.selectionClick();
    setState(() {
      _currentType = newType;
      _setupPhases();
      _generateNextScramble();
    });
  }

  void _setupPhases() {
    switch (_currentType) {
      case ExerciseType.cross:
        _phaseLabels = ['Cross'];
        break;
      case ExerciseType.f2l:
        _phaseLabels = ['F2L'];
        break;
      case ExerciseType.oll:
        _phaseLabels = ['OLL'];
        break;
      case ExerciseType.pll:
        _phaseLabels = ['PLL'];
        break;
      case ExerciseType.recognition:
        _phaseLabels = ['Recognition'];
        break;
      case ExerciseType.lookahead:
        _phaseLabels = ['Lookahead'];
        break;
      default:
        _phaseLabels = ['Solve'];
    }
  }

  void _generateNextScramble() {
    final scramble =
        TrainingScrambler.generateScrambleFor(widget.cubeType, _currentType);
    _currentScramble = scramble;
    setState(() {});
  }

  void _onStart() {
    setState(() {
      _currentPhases = {};
      _lastPhaseTime = 0;
    });
  }

  void _onPhaseComplete() {
    if (_currentPhases.length >= _phaseLabels.length) return;

    final label = _phaseLabels[_currentPhases.length];
    final now = _timerKey.currentState?.stopwatch.elapsedMilliseconds ?? 0;

    setState(() {
      _currentPhases[label] = now - _lastPhaseTime;
      _lastPhaseTime = now;
    });

    if (_currentPhases.length >= _phaseLabels.length) {
      _timerKey.currentState?.forceStop();
    } else {
      IosPlatformHelper.mediumImpact();
    }
  }

  void _onStop(int totalTimeMs) {
    if (_currentPhases.length < _phaseLabels.length) {
      final label = _phaseLabels[_currentPhases.length];
      _currentPhases[label] = totalTimeMs - _lastPhaseTime;
    }

    _saveSolve(totalTimeMs);
  }

  Future<void> _saveSolve(int totalTimeMs) async {
    final solve = TrainingSolve(
      id: const Uuid().v4(),
      cube: widget.cubeType.label,
      scramble: _currentScramble,
      totalTimeMs: totalTimeMs,
      phaseTimes: Map.from(_currentPhases),
      sessionId: _sessionId,
      sessionType: _currentType,
      date: DateTime.now(),
    );

    setState(() {
      _sessionSolves.add(solve);
    });

    final isNewRecord =
        await ref.read(trainingRepositoryProvider).saveSolve(solve);

    if (isNewRecord && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Nuovo Record! Entrato in Top 50 🏆',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    // Check goals
    final achievement =
        ref.read(sessionGoalProvider.notifier).checkGoalAchievement(
              currentAo5: _currentAvg5,
              currentAo12: _currentAvg12,
              currentBest: _currentBest.toDouble(),
              currentSolveCount: _sessionSolves.length,
              cubeType: widget.cubeType,
            );

    if (achievement != null && mounted) {
      ref.read(goalRepositoryProvider).saveAchievement(achievement);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🎯 OBIETTIVO RAGGIUNTO! ${achievement.type.name} = ${achievement.actualValue.toStringAsFixed(2)}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _generateNextScramble();
      });
    }
  }

  void _finishSession() {
    if (_sessionSolves.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final avg =
        _sessionSolves.map((s) => s.totalTimeMs).reduce((a, b) => a + b) /
            _sessionSolves.length;

    final firstType = _sessionSolves.first.sessionType;
    final isMixed = _sessionSolves.any((s) => s.sessionType != firstType);
    final finalType = isMixed ? ExerciseType.mixed : firstType;

    final session = TrainingSession(
      sessionId: _sessionId,
      type: finalType,
      date: DateTime.now(),
      totalSolves: _sessionSolves.length,
      targetMs: (widget.targetTime * 1000).toInt(),
      evaluationMode: EvaluationMode.avg,
      metadata: {
        'average': avg.toStringAsFixed(2),
        'mode': 'free_training',
        'cubeType': widget.cubeType.label,
      },
    );

    ref.read(trainingRepositoryProvider).saveSession(session);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TrainingReportScreen(
          solves: _sessionSolves,
          sessionId: _sessionId,
          type: finalType,
          cubeType: widget.cubeType,
        ),
      ),
    );
  }

  double get _currentAvg {
    if (_sessionSolves.isEmpty) return 0.0;
    return _sessionSolves.map((s) => s.totalTimeMs).reduce((a, b) => a + b) /
        _sessionSolves.length;
  }

  double get _currentAvg5 {
    if (_sessionSolves.length < 5) return 0.0;
    final recent =
        _sessionSolves.reversed.take(5).map((s) => s.totalTimeMs).toList();
    recent.sort();
    final valid = recent.sublist(1, 4);
    return (valid.reduce((a, b) => a + b) / 3) / 1000.0;
  }

  double get _currentAvg12 {
    if (_sessionSolves.length < 12) return 0.0;
    final recent =
        _sessionSolves.reversed.take(12).map((s) => s.totalTimeMs).toList();
    recent.sort();
    final valid = recent.sublist(1, 11);
    return (valid.reduce((a, b) => a + b) / 10) / 1000.0;
  }

  int get _currentBest {
    if (_sessionSolves.isEmpty) return 0;
    return _sessionSolves
        .map((s) => s.totalTimeMs)
        .reduce((a, b) => a < b ? a : b);
  }

  Color _getTargetColor() {
    final targetMs = widget.targetTime * 1000;
    final value = _currentAvg;
    if (value == 0) return Colors.grey;
    if (value <= targetMs) return Colors.green;
    if (value <= targetMs * 1.1) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final targetColor = _getTargetColor();
    final bool isTimerActive = _timerState == TimerState.running ||
        _timerState == TimerState.ready ||
        _timerState == TimerState.inspection;

    return Scaffold(
      appBar: isTimerActive
          ? null
          : AppBar(
              title: DropdownButton<ExerciseType>(
                value: _currentType,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                dropdownColor: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                onChanged: _onTypeChanged,
                items: ExerciseType.values
                    .where((e) =>
                        e != ExerciseType.beautifulPatterns &&
                        e != ExerciseType.randomCube &&
                        e != ExerciseType.mixed)
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.toString().split('.').last.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.flag_outlined),
                  onPressed: () {
                    IosPlatformHelper.lightImpact();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => GoalSetupSheet(sessionId: _sessionId),
                    );
                  },
                  tooltip: 'Imposta Obiettivo',
                ),
                IconButton(
                  icon: const Icon(Icons.stop_circle_outlined),
                  onPressed: _finishSession,
                  tooltip: 'Termina Sessione',
                ),
              ],
            ),
      body: SafeArea(
        top: isTimerActive,
        bottom: true,
        child: Column(
          children: [
            if (!isTimerActive)
              GoalBanner(
                currentAo5: _currentAvg5,
                currentAo12: _currentAvg12,
                currentBest: _currentBest / 1000.0,
                currentSolveCount: _sessionSolves.length,
              ),
            if (!isTimerActive) _buildSessionHeader(theme, targetColor),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 110),
                    child: SingleChildScrollView(
                      child: Text(
                        _currentScramble,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFamily: 'monospace',
                          color: Colors.white70,
                          fontSize: _currentScramble.length > 160 ? 13.5 : 16,
                        ),
                      ),
                    ),
                  ),
                  if (!isTimerActive) ...[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Ispezione 15s',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 28,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Switch(
                              value: _useInspection,
                              activeThumbColor: targetColor,
                              onChanged: (val) {
                                IosPlatformHelper.selectionClick();
                                setState(() => _useInspection = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: TrainingTimer(
                key: _timerKey,
                useInspection: _useInspection,
                manualInspection: widget.manualInspection,
                currentPhaseLabel: _currentPhases.length < _phaseLabels.length
                    ? _phaseLabels[_currentPhases.length]
                    : null,
                onStart: _onStart,
                onStop: _onStop,
                onPhaseComplete: _onPhaseComplete,
                onStateChanged: (state) {
                  if (mounted && _timerState != state) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _timerState = state);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionHeader(ThemeData theme, Color targetColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHeaderStat('SOLVES', '${_sessionSolves.length}', Colors.white),
          _buildHeaderStat('AVG', '${(_currentAvg / 1000).toStringAsFixed(2)}s',
              targetColor),
          _buildHeaderStat('BEST',
              '${(_currentBest / 1000).toStringAsFixed(2)}s', Colors.white),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: color)),
      ],
    );
  }
}
