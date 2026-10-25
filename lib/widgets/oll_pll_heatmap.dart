import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/oll_pll_timer_screen.dart';
import '../providers/selected_cube_type.dart';
import '../models/oll_pll_case.dart';
import '../services/oll_pll_data.dart';
import '../providers/oll_pll_provider.dart';
import '../services/oll_pll_classifier.dart';
import 'puzzle_grid_preview.dart';

class OllPllHeatmap extends ConsumerStatefulWidget {
  const OllPllHeatmap({super.key});

  @override
  ConsumerState<OllPllHeatmap> createState() => _OllPllHeatmapState();
}

class _OllPllHeatmapState extends ConsumerState<OllPllHeatmap> {
  String _currentFilter = 'Tutti';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCube = ref.watch(selectedCubeTypeProvider);

    List<OllPllCase> cases = allCasesByPuzzle[activeCube] ?? [];

    // Add 3x3 cases if the cube is a bigger NxN cube and the filter isn't strict parity.
    // Wait, per user instruction: 4x4-7x7 only show Parity. They don't show 3x3 cases here!
    // So we just use allCasesByPuzzle[activeCube].

    // Apply local filter based on the dynamic tabs
    if (_currentFilter != 'Tutti') {
      cases = cases.where((c) => c.category == _currentFilter).toList();
    }

    int minMs = 999999;
    int maxMs = 0;
    final Map<String, int?> caseTimes = {};

    for (var c in cases) {
      final stats = ref.watch(ollPllStatsReactiveProvider(c.id));
      final val = stats['ao5'] ?? stats['best'];
      caseTimes[c.id] = val;

      if (val != null) {
        if (val < minMs) minMs = val;
        if (val > maxMs) maxMs = val;
      }
    }

    Color getColorForTime(int? timeMs) {
      if (timeMs == null) return Colors.grey.withOpacity(0.3);
      if (maxMs == minMs) return Colors.greenAccent;
      final ratio = ((timeMs - minMs) / (maxMs - minMs)).clamp(0.0, 1.0);
      return Color.lerp(Colors.greenAccent, Colors.redAccent, ratio)!;
    }

    final easyCases = cases
        .where((c) => OllPllClassifier.classify(c) == AlgorithmDifficulty.easy)
        .toList();
    final mediumCases = cases
        .where(
            (c) => OllPllClassifier.classify(c) == AlgorithmDifficulty.medium)
        .toList();
    final hardCases = cases
        .where((c) => OllPllClassifier.classify(c) == AlgorithmDifficulty.hard)
        .toList();
    final unclassifiedCases = cases
        .where((c) =>
            OllPllClassifier.classify(c) == AlgorithmDifficulty.unclassified)
        .toList();

    return Column(
      children: [
        _buildDynamicFilterTabs(theme, activeCube),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomScrollView(
              slivers: [
                if (easyCases.isNotEmpty)
                  ..._buildSection('Facili', easyCases, caseTimes,
                      getColorForTime, theme, ref),
                if (mediumCases.isNotEmpty)
                  ..._buildSection('Medi', mediumCases, caseTimes,
                      getColorForTime, theme, ref),
                if (hardCases.isNotEmpty)
                  ..._buildSection('Difficili', hardCases, caseTimes,
                      getColorForTime, theme, ref),
                if (unclassifiedCases.isNotEmpty)
                  ..._buildSection('Tutti', unclassifiedCases, caseTimes,
                      getColorForTime, theme, ref),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicFilterTabs(ThemeData theme, dynamic activeCube) {
    final categories = OllPllClassifier.getAlgSetsForPuzzle(activeCube);
    if (categories.isEmpty) return const SizedBox.shrink();

    // Reset filter if active cube changed and current filter is invalid
    if (_currentFilter != 'Tutti' && !categories.contains(_currentFilter)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _currentFilter = 'Tutti');
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SegmentedButton<String>(
        segments: [
          const ButtonSegment(value: 'Tutti', label: Text('Tutti')),
          ...categories.map((c) => ButtonSegment(value: c, label: Text(c))),
        ],
        selected: {_currentFilter},
        onSelectionChanged: (Set<String> newSelection) {
          setState(() {
            _currentFilter = newSelection.first;
          });
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return theme.colorScheme.primary;
              }
              return theme.colorScheme.surfaceContainerHighest;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return theme.colorScheme.onPrimary;
              }
              return theme.colorScheme.onSurface;
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSection(
      String title,
      List<OllPllCase> cases,
      Map<String, int?> caseTimes,
      Color Function(int?) colorFn,
      ThemeData theme,
      WidgetRef ref) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            final c = cases[i];
            final time = caseTimes[c.id];
            // Main card has neutral background. Opacity 1
            final cardColor = theme.colorScheme.surfaceBright;

            return GestureDetector(
              onTap: () =>
                  _showCaseDetails(context, ref, c, time, colorFn(time)),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: theme.colorScheme.surface, width: 2),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Visual Algorithm
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Opacity(
                        opacity: 0.9,
                        child: PuzzleGridPreview(ollPllCase: c),
                      ),
                    ),
                    // Small Text Label at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(6)),
                        ),
                        child: Text(
                          c.name.split(' ').first,
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: cases.length,
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
    ];
  }

  void _showCaseDetails(BuildContext context, WidgetRef ref, OllPllCase c,
      int? timeMs, Color heatColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          heatColor.withOpacity(0.9), // The real heatmap color is here
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(c.name,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: 140,
                height: 140,
                child: PuzzleGridPreview(ollPllCase: c),
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(c.algorithm,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.orangeAccent),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(24)),
                child: Text(
                  timeMs == null
                      ? 'Non ancora allenato'
                      : 'Miglior indicatore: ${(timeMs / 1000).toStringAsFixed(2)}s',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: () {
                    ref.read(currentOllPllCaseProvider.notifier).setCase(c);
                    Navigator.pop(context); // close sheet

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OllPllTimerScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('ALLENA QUESTO CASO',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
