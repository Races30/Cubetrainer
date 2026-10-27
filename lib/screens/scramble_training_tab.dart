import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise_type.dart';
import '../models/solve.dart';
import '../providers/selected_cube_type.dart';
import 'training_timer_screen.dart';
import 'leaderboard_screen.dart';
import 'oll_pll_selection_screen.dart';
import '../services/oll_pll_classifier.dart';
import '../utils/ios_platform_helper.dart';

class ScrambleTrainingTab extends ConsumerStatefulWidget {
  const ScrambleTrainingTab({super.key});

  @override
  ConsumerState<ScrambleTrainingTab> createState() =>
      _ScrambleTrainingTabState();
}

class _ScrambleTrainingTabState extends ConsumerState<ScrambleTrainingTab> {
  // Free Training defaults
  ExerciseType _selectedType = ExerciseType.cross;
  bool _useInspection = true;
  bool _manualInspection = true;
  final double _targetTime = 30.0; // Default target

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCubeType = ref.watch(selectedCubeTypeProvider);

    // Dynamic available exercises based on cube
    List<ExerciseType> availableExercises = ExerciseType.values.where((e) {
      if (e == ExerciseType.beautifulPatterns ||
          e == ExerciseType.randomCube ||
          e == ExerciseType.mixed) {
        return false;
      }

      // Filter logic per cube
      if (activeCubeType == CubeType.twoByTwo) {
        if (e == ExerciseType.f2l) return false;
      } else if (activeCubeType == CubeType.pyraminx) {
        if (e == ExerciseType.f2l || e == ExerciseType.oll) return false;
      }
      return true;
    }).toList();

    // Ensure selected type is still valid
    if (!availableExercises.contains(_selectedType)) {
      _selectedType = availableExercises.first;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ALLENAMENTO LIBERO',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              TextButton.icon(
                onPressed: _openLeaderboard,
                icon: const Icon(Icons.leaderboard, size: 18),
                label: const Text('Classifica'),
                style: TextButton.styleFrom(
                  minimumSize: const Size(44, 40),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCard(
            theme,
            child: Column(
              children: [
                _buildInfoRow(
                    theme,
                    "Modalità Iniziale",
                    DropdownButton<ExerciseType>(
                      value: _selectedType,
                      underline: const SizedBox(),
                      dropdownColor: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(14),
                      onChanged: (val) {
                        if (val != null) {
                          IosPlatformHelper.selectionClick();
                          setState(() => _selectedType = val);
                        }
                      },
                      items: availableExercises
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child:
                                    Text(_getExerciseLabel(activeCubeType, e)),
                              ))
                          .toList(),
                    )),
                const Divider(),
                SwitchListTile(
                  title: const Text('Ispezione (15s)'),
                  value: _useInspection,
                  onChanged: (val) {
                    IosPlatformHelper.selectionClick();
                    setState(() => _useInspection = val);
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                if (_useInspection)
                  SwitchListTile(
                    title: const Text('Avvio Manuale Ispezione'),
                    subtitle: const Text('Richiede tocco per iniziare i 15s'),
                    value: _manualInspection,
                    onChanged: (val) {
                      IosPlatformHelper.selectionClick();
                      setState(() => _manualInspection = val);
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: _startSession,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('INIZIA ALLENAMENTO LIBERO',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoBox(theme),
          const SizedBox(height: 24),
          _buildOllPllSection(theme, activeCubeType),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 8),
          child,
        ],
      ),
    );
  }

  void _openLeaderboard() {
    IosPlatformHelper.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
    );
  }

  Widget _buildCard(ThemeData theme, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: child,
    );
  }

  Widget _buildInfoBox(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'In questa modalità puoi cambiare esercizio mentre ti alleni. Non ci sono limiti di ripetizioni.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  String _getExerciseLabel(CubeType activeCube, ExerciseType type) {
    if (activeCube == CubeType.twoByTwo) {
      if (type == ExerciseType.cross) return 'First Face';
      if (type == ExerciseType.oll) return 'OLL / Ortega';
      if (type == ExerciseType.pll) return 'PBL / CLL';
    } else if (activeCube == CubeType.pyraminx) {
      if (type == ExerciseType.cross) return 'V-Shape';
      if (type == ExerciseType.pll) return 'L4E / Last Layer';
    } else if (activeCube == CubeType.megaminx) {
      if (type == ExerciseType.cross) return 'Star';
      if (type == ExerciseType.f2l) return 'F2L / S2L';
      if (type == ExerciseType.oll) return 'LL Edges/Corners (OLL)';
      if (type == ExerciseType.pll) return 'LL Edges/Corners (PLL)';
    } else if (activeCube == CubeType.fourByFour ||
        activeCube == CubeType.fiveByFive ||
        activeCube == CubeType.sixBySix ||
        activeCube == CubeType.sevenBySeven) {
      if (type == ExerciseType.cross) return 'Centers + Edges';
      if (type == ExerciseType.f2l) return '3x3 Stage (F2L)';
      if (type == ExerciseType.oll) return '3x3 Stage (OLL / Parity)';
      if (type == ExerciseType.pll) return '3x3 Stage (PLL / Parity)';
    }

    // Default 3x3 Labels
    switch (type) {
      case ExerciseType.cross:
        return 'Cross Only';
      case ExerciseType.f2l:
        return 'F2L Focus';
      case ExerciseType.oll:
        return 'OLL Drills';
      case ExerciseType.pll:
        return 'PLL Drills';
      case ExerciseType.recognition:
        return 'Recognition';
      case ExerciseType.lookahead:
        return 'Lookahead/TPS';
      default:
        return type.toString().split('.').last;
    }
  }

  void _startSession() {
    IosPlatformHelper.mediumImpact();
    final activeCubeType = ref.read(selectedCubeTypeProvider);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrainingTimerScreen(
          initialType: _selectedType,
          useInspection: _useInspection,
          manualInspection: _manualInspection,
          targetTime: _targetTime,
          cubeType: activeCubeType,
        ),
      ),
    );
  }

  Widget _buildOllPllSection(ThemeData theme, CubeType activeCube) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ALGORITMI SPECIFICI',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildCard(
          theme,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.grid_on, color: theme.colorScheme.primary),
            title: Text(
                'Allenamento ${OllPllClassifier.getLabelForPuzzle(activeCube)}'),
            subtitle: const Text('Spaced repetition per algoritmi completi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              IosPlatformHelper.lightImpact();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const OllPllSelectionScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}
