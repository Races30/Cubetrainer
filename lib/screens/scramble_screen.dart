import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cubetrainer/services/scramble_generator.dart';
import 'package:cubetrainer/services/persistent_scramble_repository.dart';
import 'package:cubetrainer/providers/selected_cube_type.dart';
import 'package:cubetrainer/models/scramble_history_item.dart';

import 'scramble_training_tab.dart';

class ScrambleScreen extends ConsumerStatefulWidget {
  const ScrambleScreen({super.key});

  @override
  ConsumerState<ScrambleScreen> createState() => _ScrambleScreenState();
}

class _ScrambleScreenState extends ConsumerState<ScrambleScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            tabs: const [
              Tab(text: 'CASUALE'),
              Tab(text: 'ALLENAMENTO'),
            ],
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 1.1),
          ),
        ),
        body: TabBarView(
          children: [
            _buildRandomTab(),
            const ScrambleTrainingTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildRandomTab() {
    final selectedCubeType = ref.watch(selectedCubeTypeProvider);
    final scrambleState =
        ref.watch(scrambleGeneratorProvider(selectedCubeType));
    final history =
        ref.watch(scrambleHistoryProvider(cubeType: selectedCubeType));
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Active Scramble Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1)),
            ),
            child: SelectableText(
              scrambleState.activeScramble ?? 'Nessuno scramble generato',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                        text: scrambleState.activeScramble ?? ''));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Scramble copiato!')));
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text('Copia'),
                  style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => ref
                      .read(
                          scrambleGeneratorProvider(selectedCubeType).notifier)
                      .generate(selectedCubeType),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Nuovo'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('CRONOLOGIA SCRAMBLE',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.grey)),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildHistoryList(history, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<ScrambleHistoryItem> history, ThemeData theme) {
    if (history.isEmpty) {
      return Center(
          child: Text('Nessuna cronologia',
              style: TextStyle(color: Colors.grey.withValues(alpha: 0.5))));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(item.scramble,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () {
                ref
                    .read(persistentScrambleRepositoryProvider)
                    .deleteScramble(index);
              },
            ),
            onTap: () {
              ref
                  .read(scrambleGeneratorProvider(
                          ref.read(selectedCubeTypeProvider))
                      .notifier)
                  .setActiveScramble(item.scramble);
            },
          ),
        );
      },
    );
  }
}
