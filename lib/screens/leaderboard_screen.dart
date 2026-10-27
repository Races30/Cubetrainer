import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise_type.dart';
import '../models/solve.dart';
import '../services/leaderboard_service.dart';
import '../models/leaderboard_entry.dart';
import '../providers/selected_cube_type.dart';
import '../utils/ios_platform_helper.dart';
import 'package:intl/intl.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  String _selectedMode = 'cross';
  final DateFormat _dateFormat = DateFormat('dd/MM HH:mm');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leaderboardService = ref.watch(leaderboardServiceProvider);
    final selectedCubeLabel = ref.watch(selectedCubeTypeProvider).label;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard Locale'),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: StreamBuilder(
          stream: leaderboardService.watchEntries(),
          builder: (context, snapshot) {
            final entries =
                leaderboardService.getEntries(_selectedMode, selectedCubeLabel);

            return Column(
              children: [
                _buildFilters(theme, selectedCubeLabel),
                const Divider(height: 1),
                _buildHeader(theme),
                Expanded(
                  child: entries.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'Nessun tempo registrato per questa categoria.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: entries.length,
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            return _buildEntryItem(context, entry, index);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilters(ThemeData theme, String activeCubeLabel) {
    final modes = ExerciseType.values
        .where((e) =>
            e != ExerciseType.beautifulPatterns && e != ExerciseType.randomCube)
        .map((e) => e.toString().split('.').last)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: _selectedMode,
            dropdownColor: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            items: modes.map((m) {
              return DropdownMenuItem(
                value: m,
                child: Text(m.toUpperCase()),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                IosPlatformHelper.selectionClick();
                setState(() => _selectedMode = val);
              }
            },
            underline: Container(
              height: 2,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              activeCubeLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: const Row(
        children: [
          SizedBox(
              width: 40,
              child: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child:
                  Text('TEMPO', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text('DATA',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget _buildEntryItem(
      BuildContext context, LeaderboardEntry entry, int index) {
    final isTop3 = index < 3;
    final color = isTop3 ? Colors.orange : null;

    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        IosPlatformHelper.lightImpact();
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Eliminare tempo?'),
            content: const Text(
                'Questa azione rimuoverà il tempo dalla leaderboard locale, ma il solve originale rimarrà nella cronologia sessione.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('ANNULLA'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('ELIMINA'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(leaderboardServiceProvider).deleteEntry(entry.id);
      },
      child: ListTile(
        leading: SizedBox(
          width: 24,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
        ),
        title: Text(
          (entry.timeMs / 1000).toStringAsFixed(2),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
            fontFamily: 'monospace',
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        trailing: Text(
          _dateFormat.format(entry.date),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
