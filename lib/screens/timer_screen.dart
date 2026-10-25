import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/solve.dart';
import '../services/solve_repository.dart';
import '../services/scramble_generator.dart';
import '../services/statistics_repository.dart';
import '../providers/session_provider.dart';
import '../services/cross_solver.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/services.dart';

import '../widgets/training_timer.dart';

class TimerScreen extends ConsumerStatefulWidget {
  final CubeType cubeType;
  const TimerScreen({super.key, required this.cubeType});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  TimerState _timerState = TimerState.stopped;
  final GlobalKey<TrainingTimerState> _timerKey = GlobalKey();
  bool _useInspection = true;
  bool _isSolvingCross = false;
  List<String>? _crossSolution;

  final Map<String, int> _currentSplits = {};
  int _lastSplitTime = 0;
  final List<String> _splitLabels = [
    'Cross',
    'F2L1',
    'F2L2',
    'F2L3',
    'F2L4',
    'OLL',
    'PLL'
  ];

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void _onStart() {
    // Optional: generate next scramble on start
    if (_crossSolution != null) {
      setState(() => _crossSolution = null);
    }
    _currentSplits.clear();
    _lastSplitTime = 0;
  }

  Future<void> _onStop(int ms) async {
    final activeScramble =
        ref.read(scrambleGeneratorProvider(widget.cubeType)).activeScramble;
    final activeSession = ref.read(activeSessionProvider);

    if (_currentSplits.isNotEmpty &&
        _currentSplits.length < _splitLabels.length) {
      final label = _splitLabels[_currentSplits.length];
      _currentSplits[label] = ms - _lastSplitTime;
    }

    final solve = Solve(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cube: widget.cubeType.label,
      scramble: activeScramble ?? '',
      timeMs: ms,
      penalty: '',
      date: DateTime.now(),
      cubeType: widget.cubeType,
      sessionId: activeSession,
      splits: _currentSplits.isEmpty ? null : Map.from(_currentSplits),
    );
    await ref.read(solveRepositoryProvider).saveSolve(solve);

    // Generate new scramble for next solve
    ref
        .read(scrambleGeneratorProvider(widget.cubeType).notifier)
        .generate(widget.cubeType);
  }

  void _onSplitTapped() {
    if (_currentSplits.length >= _splitLabels.length) return;

    final now = _timerKey.currentState?.stopwatch.elapsedMilliseconds ?? 0;
    final label = _splitLabels[_currentSplits.length];

    setState(() {
      _currentSplits[label] = now - _lastSplitTime;
      _lastSplitTime = now;
    });

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeScramble =
        ref.watch(scrambleGeneratorProvider(widget.cubeType)).activeScramble;
    final activeSession = ref.watch(activeSessionProvider);
    final availableSessions = ref
        .read(solveRepositoryProvider)
        .getAvailableSessions(cubeType: widget.cubeType);

    final solves = ref
        .watch(
            solvesProvider(cubeType: widget.cubeType, sessionId: activeSession))
        .reversed
        .toList();

    final statsRepo = ref.read(statisticsRepositoryProvider(
        cubeType: widget.cubeType, sessionId: activeSession));

    final bool isTimerActive = _timerState == TimerState.running ||
        _timerState == TimerState.ready ||
        _timerState == TimerState.inspection;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SCRAMBLE',
                          style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2)),
                      if (!isTimerActive)
                        _buildSessionSwitcher(
                            context, activeSession, availableSessions),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(activeScramble ?? 'Pronto per iniziare...',
                      style: const TextStyle(
                          fontSize: 18,
                          height: 1.4,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                  if (!isTimerActive) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (widget.cubeType == CubeType.threeByThree)
                          TextButton.icon(
                            onPressed: _isSolvingCross || activeScramble == null
                                ? null
                                : () async {
                                    setState(() {
                                      _isSolvingCross = true;
                                      _crossSolution = null;
                                    });
                                    final solution =
                                        await CrossSolver.solveCross(
                                            activeScramble);
                                    if (mounted) {
                                      setState(() {
                                        _crossSolution = solution ?? ['Errore'];
                                        _isSolvingCross = false;
                                      });
                                    }
                                  },
                            icon: _isSolvingCross
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Icon(Icons.lightbulb_outline, size: 16),
                            label: const Text('Svela Croce'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.orangeAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        const Spacer(),
                        const Text('Ispezione 15s',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 24,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Switch(
                              value: _useInspection,
                              activeThumbColor: theme.colorScheme.primary,
                              onChanged: (val) {
                                setState(() => _useInspection = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_crossSolution != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color:
                                    Colors.orangeAccent.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('CROCE OTTIMALE',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2)),
                              const SizedBox(height: 4),
                              Text(_crossSolution!.join(' '),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: TrainingTimer(
                      key: _timerKey,
                      useInspection: _useInspection,
                      onStart: _onStart,
                      onStop: _onStop,
                      onStateChanged: (state) {
                        if (mounted && _timerState != state) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) setState(() => _timerState = state);
                          });
                        }
                      },
                    ),
                  ),
                  if (_timerState == TimerState.running &&
                      widget.cubeType == CubeType.threeByThree)
                    Positioned(
                      bottom: 32,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _onSplitTapped,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: theme.colorScheme.primary, width: 2),
                            ),
                            child: Text(
                              _currentSplits.length < _splitLabels.length
                                  ? 'SPLIT: ${_splitLabels[_currentSplits.length]}'
                                  : 'SPLITS FATTI',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!isTimerActive && solves.isNotEmpty) ...[
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('RECENT SOLVES',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.grey))),
              const SizedBox(height: 8),
              ...solves.take(3).map((solve) {
                final isDnf = solve.penalty == 'DNF';
                final isPlus2 = solve.penalty == '+2';

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          statsRepo.formatMs(solve.timeMs),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            decoration:
                                isDnf ? TextDecoration.lineThrough : null,
                            color: isDnf ? Colors.grey : null,
                          ),
                        ),
                        if (isPlus2)
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              '(+2)',
                              style: TextStyle(
                                  color: Colors.red[400],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        if (isDnf)
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              'DNF',
                              style: TextStyle(
                                  color: Colors.red[400],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(solve.cubeType?.label ?? solve.cube,
                        style: TextStyle(color: theme.colorScheme.primary)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // +2 Button
                        IconButton(
                          icon: const Text('+2',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          color: isPlus2 ? Colors.orange : Colors.grey,
                          onPressed: () {
                            final newPenalty = isPlus2 ? '' : '+2';
                            _quickUpdatePenalty(solve, newPenalty);
                          },
                        ),
                        // DNF Button
                        IconButton(
                          icon: const Text('DNF',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                          color: isDnf ? Colors.red : Colors.grey,
                          onPressed: () {
                            final newPenalty = isDnf ? '' : 'DNF';
                            _quickUpdatePenalty(solve, newPenalty);
                          },
                        ),
                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent),
                          onPressed: () => ref
                              .read(solveRepositoryProvider)
                              .deleteSolve(solve.id),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
            if (!isTimerActive) const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _quickUpdatePenalty(Solve solve, String penalty) async {
    final updated = Solve(
      id: solve.id,
      cube: solve.cube,
      scramble: solve.scramble,
      timeMs: solve.timeMs,
      penalty: penalty,
      date: solve.date,
      cubeType: solve.cubeType,
    );
    await ref.read(solveRepositoryProvider).updateSolve(updated);
  }

  Widget _buildSessionSwitcher(BuildContext context, String activeSession,
      List<String> availableSessions) {
    if (!availableSessions.contains(activeSession)) {
      availableSessions.add(activeSession);
    }

    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            value: activeSession,
            isDense: true,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 13,
                fontWeight: FontWeight.bold),
            icon: Icon(Icons.keyboard_arrow_down,
                size: 16, color: Theme.of(context).colorScheme.primary),
            items: [
              ...availableSessions.map((s) =>
                  DropdownMenuItem(value: s, child: Text(s.toUpperCase()))),
              const DropdownMenuItem(
                  value: '_new_',
                  child:
                      Text('+ NUOVA', style: TextStyle(color: Colors.green))),
            ],
            onChanged: (val) {
              if (val == '_new_') {
                _showNewSessionDialog();
              } else if (val != null) {
                ref.read(activeSessionProvider.notifier).setSession(val);
              }
            }));
  }

  void _showNewSessionDialog() {
    final tc = TextEditingController();
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: const Text('Nuova Sessione'),
                content: TextField(
                  controller: tc,
                  decoration: const InputDecoration(
                      labelText: 'Nome Sessione', hintText: 'es. One-Handed'),
                  autofocus: true,
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('ANNULLA')),
                  ElevatedButton(
                      onPressed: () {
                        final name = tc.text.trim().toLowerCase();
                        if (name.isNotEmpty) {
                          ref
                              .read(activeSessionProvider.notifier)
                              .setSession(name);
                        }
                        Navigator.pop(ctx);
                      },
                      child: const Text('CREA')),
                ]));
  }
}
