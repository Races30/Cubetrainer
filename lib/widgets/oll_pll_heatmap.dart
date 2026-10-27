import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/oll_pll_timer_screen.dart';
import '../providers/selected_cube_type.dart';
import '../models/oll_pll_case.dart';
import '../services/oll_pll_data.dart';
import '../providers/oll_pll_provider.dart';
import '../services/oll_pll_classifier.dart';
import '../utils/ios_platform_helper.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 390 ? 5 : 6;
    final activeCube = ref.watch(selectedCubeTypeProvider);

    List<OllPllCase> cases = allCasesByPuzzle[activeCube] ?? [];

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
      if (timeMs == null) return Colors.grey.withValues(alpha: 0.3);
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CustomScrollView(
              slivers: [
                if (easyCases.isNotEmpty)
                  ..._buildSection('Facili', easyCases, caseTimes,
                      getColorForTime, theme, ref, crossAxisCount),
                if (mediumCases.isNotEmpty)
                  ..._buildSection('Medi', mediumCases, caseTimes,
                      getColorForTime, theme, ref, crossAxisCount),
                if (hardCases.isNotEmpty)
                  ..._buildSection('Difficili', hardCases, caseTimes,
                      getColorForTime, theme, ref, crossAxisCount),
                if (unclassifiedCases.isNotEmpty)
                  ..._buildSection('Tutti', unclassifiedCases, caseTimes,
                      getColorForTime, theme, ref, crossAxisCount),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
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

    if (_currentFilter != 'Tutti' && !categories.contains(_currentFilter)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _currentFilter = 'Tutti');
      });
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SegmentedButton<String>(
        showSelectedIcon: false,
        segments: [
          const ButtonSegment(value: 'Tutti', label: Text('Tutti')),
          ...categories.map((c) => ButtonSegment(value: c, label: Text(c))),
        ],
        selected: {_currentFilter},
        onSelectionChanged: (Set<String> newSelection) {
          IosPlatformHelper.selectionClick();
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
      WidgetRef ref,
      int crossAxisCount) {
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            final c = cases[i];
            final time = caseTimes[c.id];
            final cardColor = theme.colorScheme.surfaceBright;
            final borderColor =
                time != null ? colorFn(time) : theme.colorScheme.surface;

            return GestureDetector(
              onTap: () {
                IosPlatformHelper.lightImpact();
                _showCaseDetails(context, ref, c, time, colorFn(time));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Opacity(
                        opacity: 0.9,
                        child: PuzzleGridPreview(ollPllCase: c),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(6)),
                        ),
                        child: Text(
                          c.name.split(' ').first,
                          style: const TextStyle(
                            fontSize: 9,
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
      isScrollControlled: true,
      backgroundColor: Color.alphaBlend(
        heatColor.withValues(alpha: 0.25),
        const Color(0xFF1E293B),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
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
                  width: 136,
                  height: 136,
                  child: PuzzleGridPreview(ollPllCase: c),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(c.algorithm,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.orangeAccent),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: 18),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(24)),
                  child: Text(
                    timeMs == null
                        ? 'Non ancora allenato'
                        : 'Miglior indicatore: ${(timeMs / 1000).toStringAsFixed(2)}s',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: () {
                      IosPlatformHelper.mediumImpact();
                      ref.read(currentOllPllCaseProvider.notifier).setCase(c);
                      Navigator.pop(sheetCtx);

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
              ],
            ),
          ),
        );
      },
    );
  }
}
