import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cubetrainer/services/scramble_generator.dart';
import 'package:cubetrainer/services/persistent_scramble_repository.dart';
import 'package:cubetrainer/providers/selected_cube_type.dart';
import 'package:cubetrainer/models/scramble_history_item.dart';
import '../utils/ios_platform_helper.dart';

import 'scramble_training_tab.dart';

class ScrambleScreen extends ConsumerStatefulWidget {
  const ScrambleScreen({super.key});

  @override
  ConsumerState<ScrambleScreen> createState() => _ScrambleScreenState();
}

class _ScrambleScreenState extends ConsumerState<ScrambleScreen> {
  double _adaptiveScrambleSize(String? scramble) {
    final len = scramble?.length ?? 0;
    if (len > 240) return 14.5;
    if (len > 140) return 17.0;
    return 21.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: TabBar(
            onTap: (_) => IosPlatformHelper.selectionClick(),
            tabs: const [
              Tab(height: 42, text: 'CASUALE'),
              Tab(height: 42, text: 'ALLENAMENTO'),
            ],
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.bold, letterSpacing: 1.1, fontSize: 13),
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
    final activeScramble = scrambleState.activeScramble;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 14),
          // Active Scramble Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.14)),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: SingleChildScrollView(
                child: SelectableText(
                  activeScramble ?? 'Nessuno scramble generato',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _adaptiveScrambleSize(activeScramble),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    IosPlatformHelper.lightImpact();
                    Clipboard.setData(
                        ClipboardData(text: activeScramble ?? ''));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Scramble copiato!'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text('Copia',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    IosPlatformHelper.lightImpact();
                    ref
                        .read(scrambleGeneratorProvider(selectedCubeType)
                            .notifier)
                        .generate(selectedCubeType);
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Nuovo',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('CRONOLOGIA SCRAMBLE',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.grey)),
          ),
          const SizedBox(height: 10),
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
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            title: Text(item.scramble,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13.5)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () {
                IosPlatformHelper.lightImpact();
                ref
                    .read(persistentScrambleRepositoryProvider)
                    .deleteScramble(index);
              },
            ),
            onTap: () {
              IosPlatformHelper.selectionClick();
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
