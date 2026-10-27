import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/oll_pll_provider.dart';
import '../utils/formatters.dart';
import '../utils/ios_platform_helper.dart';
import '../providers/selected_cube_type.dart';
import '../services/oll_pll_data.dart';
import '../services/oll_pll_classifier.dart';
import '../models/oll_pll_case.dart';
import 'oll_pll_timer_screen.dart';
import '../widgets/puzzle_grid_preview.dart';

class OllPllSelectionScreen extends ConsumerStatefulWidget {
  const OllPllSelectionScreen({super.key});

  @override
  ConsumerState<OllPllSelectionScreen> createState() =>
      _OllPllSelectionScreenState();
}

class _OllPllSelectionScreenState extends ConsumerState<OllPllSelectionScreen> {
  String _currentFilter = 'Tutti';

  @override
  Widget build(BuildContext context) {
    final activeCube = ref.watch(selectedCubeTypeProvider);
    List<OllPllCase> cases = allCasesByPuzzle[activeCube] ?? [];

    if (_currentFilter != 'Tutti') {
      cases = cases.where((c) => c.category == _currentFilter).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Allenamento ${OllPllClassifier.getLabelForPuzzle(activeCube)}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Allenamento Misto',
            onPressed: () {
              if (cases.isNotEmpty) {
                IosPlatformHelper.lightImpact();
                ref.read(currentOllPllCaseProvider.notifier).unlock();
                ref.read(currentOllPllCaseProvider.notifier).nextRandomCase();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OllPllTimerScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            _buildDynamicFilterTabs(context, activeCube),
            Expanded(
              child: CustomScrollView(
                slivers: _buildGroupedSlivers(context, ref, cases),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFilterTabs(BuildContext context, dynamic activeCube) {
    final categories = OllPllClassifier.getAlgSetsForPuzzle(activeCube);
    if (categories.isEmpty) return const SizedBox.shrink();

    // Reset filter if active cube changed and current filter is invalid
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
                return Theme.of(context).colorScheme.primary;
              }
              return Theme.of(context).colorScheme.surfaceContainerHighest;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).colorScheme.onPrimary;
              }
              return Theme.of(context).colorScheme.onSurface;
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGroupedSlivers(
      BuildContext context, WidgetRef ref, List<OllPllCase> allCases) {
    if (allCases.isEmpty) {
      return [
        const SliverFillRemaining(
          child: Center(child: Text('Nessun caso trovato')),
        )
      ];
    }

    final easyCases = allCases
        .where((c) => OllPllClassifier.classify(c) == AlgorithmDifficulty.easy)
        .toList();
    final mediumCases = allCases
        .where(
            (c) => OllPllClassifier.classify(c) == AlgorithmDifficulty.medium)
        .toList();
    final hardCases = allCases
        .where((c) => OllPllClassifier.classify(c) == AlgorithmDifficulty.hard)
        .toList();
    final unclassifiedCases = allCases
        .where((c) =>
            OllPllClassifier.classify(c) == AlgorithmDifficulty.unclassified)
        .toList();

    return [
      if (easyCases.isNotEmpty) ..._buildSection('Facili', easyCases, ref),
      if (mediumCases.isNotEmpty) ..._buildSection('Medi', mediumCases, ref),
      if (hardCases.isNotEmpty) ..._buildSection('Difficili', hardCases, ref),
      if (unclassifiedCases.isNotEmpty)
        ..._buildSection('Tutti', unclassifiedCases, ref),
      const SliverToBoxAdapter(child: SizedBox(height: 32)),
    ];
  }

  List<Widget> _buildSection(
      String title, List<OllPllCase> cases, WidgetRef ref) {
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        sliver: SliverToBoxAdapter(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final c = cases[index];
              final stats = ref.watch(ollPllStatsReactiveProvider(c.id));
              final count = stats['count'] ?? 0;
              final best = stats['best'];
              final ao5 = stats['ao5'];

              return InkWell(
                onTap: () {
                  IosPlatformHelper.lightImpact();
                  ref.read(currentOllPllCaseProvider.notifier).setCase(c);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OllPllTimerScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PuzzleGridPreview(ollPllCase: c, size: 58),
                        const SizedBox(height: 10),
                        Text(
                          c.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Solves: $count',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        if (ao5 != null)
                          Text(
                            'Ao5: ${Formatters.formatTime(ao5)}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.blueAccent),
                          ),
                        if (best != null)
                          Text(
                            'Best: ${Formatters.formatTime(best)}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.green),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: cases.length,
          ),
        ),
      ),
    ];
  }
}
