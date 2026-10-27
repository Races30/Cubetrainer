import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../providers/oll_pll_provider.dart';
import '../services/oll_pll_repository.dart';
import '../models/oll_pll_case.dart';
import '../models/oll_pll_solve.dart';
import '../widgets/puzzle_grid_preview.dart';
import '../widgets/training_timer.dart';
import '../utils/formatters.dart';
import '../utils/ios_platform_helper.dart';

class OllPllTimerScreen extends ConsumerStatefulWidget {
  const OllPllTimerScreen({super.key});

  @override
  ConsumerState<OllPllTimerScreen> createState() => _OllPllTimerScreenState();
}

class _OllPllTimerScreenState extends ConsumerState<OllPllTimerScreen> {
  TimerState _timerState = TimerState.idleInspection;

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

  @override
  Widget build(BuildContext context) {
    final currentCase = ref.watch(currentOllPllCaseProvider);
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isCompact = screenHeight < 720;

    if (currentCase == null) {
      return const Scaffold(
        body: Center(child: Text('Nessun caso selezionato')),
      );
    }

    final isTimerActive = _timerState == TimerState.running ||
        _timerState == TimerState.inspection;

    final stats = ref.watch(ollPllStatsReactiveProvider(currentCase.id));
    final best = stats['best'];
    final ao5 = stats['ao5'];

    return Scaffold(
      appBar: isTimerActive
          ? null
          : AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Esci',
                onPressed: () {
                  ref.read(currentOllPllCaseProvider.notifier).unlock();
                  Navigator.pop(context);
                },
              ),
              title: Text(currentCase.name),
              actions: [
                if (!ref.read(currentOllPllCaseProvider.notifier).isLocked)
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: () {
                      IosPlatformHelper.selectionClick();
                      ref
                          .read(currentOllPllCaseProvider.notifier)
                          .nextRandomCase();
                    },
                  )
              ],
            ),
      body: SafeArea(
        top: isTimerActive,
        bottom: true,
        child: Column(
          children: [
            // Always visible Header with Case Name and Algorithm
            Padding(
              padding: EdgeInsets.fromLTRB(
                16.0,
                isTimerActive ? 16.0 : 8.0,
                16.0,
                8.0,
              ),
              child: Column(
                children: [
                  if (isTimerActive)
                    Text(
                      currentCase.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    currentCase.algorithm,
                    style: TextStyle(
                      fontSize: isCompact ? 19 : 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.4,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (!isTimerActive)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatBox(label: 'Migliore', value: best),
                    _StatBox(label: 'Ao5', value: ao5),
                  ],
                ),
              ),
            if (!isTimerActive)
              Expanded(
                flex: 2,
                child: Center(
                  child: PuzzleGridPreview(
                    ollPllCase: currentCase,
                    size: isCompact ? 128 : 152,
                  ),
                ),
              ),
            Expanded(
              flex: isTimerActive ? 5 : 3,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: isTimerActive ? 24.0 : 12.0,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: TrainingTimer(
                      useInspection: false,
                      manualInspection: false,
                      onStateChanged: (state) {
                        setState(() => _timerState = state);
                      },
                      onStart: () {},
                      onStop: (timeMs) {
                        _saveSolveAndAdvance(currentCase, timeMs);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSolveAndAdvance(OllPllCase c, int timeMs) async {
    final solve = OllPllSolve(
      caseId: c.id,
      timeMs: timeMs,
      date: DateTime.now(),
    );

    final repo = ref.read(ollPllRepositoryProvider);
    await repo.saveSolve(solve);
    ref.read(statsRefreshTriggerProvider.notifier).state++;

    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      ref.read(currentOllPllCaseProvider.notifier).nextRandomCase();
    }
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final int? value;

  const _StatBox({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value != null ? Formatters.formatTime(value!) : '--',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
