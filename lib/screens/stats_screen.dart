import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cubetrainer/models/solve.dart';
import 'package:cubetrainer/services/solve_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cubetrainer/services/statistics_repository.dart';
import 'package:cubetrainer/providers/selected_cube_type.dart';
import 'package:cubetrainer/services/csv_migration_service.dart';
import 'package:cubetrainer/providers/session_provider.dart';
import '../services/deepseek_service.dart';
import '../providers/oll_pll_provider.dart';
import '../services/oll_pll_data.dart';
import '../services/oll_pll_classifier.dart';
import '../widgets/oll_pll_heatmap.dart';
import '../widgets/qr_export_dialog.dart';
import 'qr_scanner_screen.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  String? _compareSessionId;

  @override
  Widget build(BuildContext context) {
    final selectedCubeType = ref.watch(selectedCubeTypeProvider);
    final activeSession = ref.watch(activeSessionProvider);
    final statsRepo = ref.watch(statisticsRepositoryProvider(
        cubeType: selectedCubeType, sessionId: activeSession));
    final solves = ref
        .watch(solvesProvider(
            cubeType: selectedCubeType, sessionId: activeSession))
        .reversed
        .toList();

    final compareSolves = _compareSessionId != null
        ? ref
            .watch(solvesProvider(
                cubeType: selectedCubeType, sessionId: _compareSessionId!))
            .reversed
            .toList()
        : <Solve>[];

    final theme = Theme.of(context);
    final migrationService = ref.read(csvMigrationServiceProvider);

    final best = statsRepo.calculateBestTime(
        cubeType: selectedCubeType, sessionId: activeSession);
    final worst = statsRepo.calculateWorstTime(
        cubeType: selectedCubeType, sessionId: activeSession);
    final avg = statsRepo.calculateMean(
        cubeType: selectedCubeType, sessionId: activeSession);
    final ao5 = statsRepo.calculateAverageOfN(5,
        cubeType: selectedCubeType, sessionId: activeSession);
    final ao12 = statsRepo.calculateAverageOfN(12,
        cubeType: selectedCubeType, sessionId: activeSession);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _runAutoAnalysis(context, ref, solves, avg ?? 0),
          icon: const Icon(Icons.analytics),
          label: const Text('Analisi Automatica'),
        ),
        appBar: AppBar(
          title: const Text('STATISTICHE',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 16)),
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            tabs: [
              const Tab(text: 'Generali'),
              Tab(text: 'Heatmap ${OllPllClassifier.getLabelForPuzzle(selectedCubeType)}'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (solves.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Confronta con:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        DropdownButton<String>(
                          value: _compareSessionId,
                          hint: const Text('Nessuna'),
                          items: [
                            const DropdownMenuItem<String>(
                                value: null, child: Text('Nessuna')),
                            ...ref
                                .read(solveRepositoryProvider)
                                .getAvailableSessions(
                                    cubeType: selectedCubeType)
                                .where((s) => s != activeSession)
                                .map((s) =>
                                    DropdownMenuItem(value: s, child: Text(s))),
                          ],
                          onChanged: (val) =>
                              setState(() => _compareSessionId = val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Container(
                    height: 200,
                    padding:
                        const EdgeInsets.only(right: 16, top: 12, bottom: 8),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1)),
                    ),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        minX: solves.length <= 1 ? -0.5 : 0,
                        maxX: solves.length <= 1
                            ? 0.5
                            : (solves.length - 1).toDouble(),
                        lineBarsData: [
                          LineChartBarData(
                            spots: solves
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(),
                                    e.value.effectiveTimeMs().toDouble()))
                                .toList(),
                            isCurved: true,
                            color: theme.colorScheme.primary,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                radius: 4,
                                color: theme.colorScheme.primary,
                                strokeWidth: 2,
                                strokeColor: theme.cardTheme.color!,
                              ),
                            ),
                            belowBarData: BarAreaData(
                                show: true,
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.1)),
                          ),
                          if (compareSolves.isNotEmpty)
                            LineChartBarData(
                              spots: compareSolves
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(e.key.toDouble(),
                                      e.value.effectiveTimeMs().toDouble()))
                                  .toList(),
                              isCurved: true,
                              color: Colors.purpleAccent,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.2,
                    children: [
                      _buildStatCard(
                          'MIGLIORE',
                          best != null
                              ? statsRepo.formatMs(best.round().toInt())
                              : '--',
                          Icons.emoji_events_rounded,
                          theme.colorScheme.primary),
                      _buildStatCard(
                          'PEGGIORE',
                          worst != null
                              ? statsRepo.formatMs(worst.round().toInt())
                              : '--',
                          Icons.trending_down_rounded,
                          Colors.redAccent),
                      _buildStatCard(
                          'Ao5',
                          ao5 != null ? statsRepo.formatMs(ao5.round()) : '--',
                          Icons.history_rounded,
                          Colors.orangeAccent),
                      _buildStatCard(
                          'Ao12',
                          ao12 != null
                              ? statsRepo.formatMs(ao12.round())
                              : '--',
                          Icons.layers_rounded,
                          Colors.purpleAccent),
                      _buildStatCard(
                          'MEDIA',
                          avg != null ? statsRepo.formatMs(avg.round()) : '--',
                          Icons.functions_rounded,
                          theme.colorScheme.secondary),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('DATI E BACKUP',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.grey)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final path = await migrationService.exportAll();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('CSV salvato: $path')));
                          },
                          icon: const Icon(Icons.description, size: 18),
                          label: const Text('Esporta CSV',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final success = await migrationService.importAll();
                            if (!context.mounted) return;
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Dati importati con successo!')));
                            }
                          },
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: const Text('Importa CSV',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => QrExportDialog(
                                solves: solves,
                                cubeTypeLabel: selectedCubeType.label,
                              ),
                            );
                          },
                          icon: const Icon(Icons.qr_code, size: 18),
                          label: const Text('QR Export',
                              style: TextStyle(fontSize: 12)),
                          style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const QrScannerScreen()));
                          },
                          icon: const Icon(Icons.qr_code_scanner, size: 18),
                          label: const Text('QR Import',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('SOLVE RECENTI',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.grey)),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: solves.length,
                    itemBuilder: (context, i) {
                      final s = solves[i];
                      final isDnf = s.penalty == 'DNF';
                      final isPlus2 = s.penalty == '+2';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          dense: true,
                          onTap: () => _showPenaltyDialog(context, s),
                          title: Row(
                            children: [
                              Text(
                                statsRepo.formatMs(s.timeMs),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration:
                                      isDnf ? TextDecoration.lineThrough : null,
                                  color: isDnf ? Colors.grey : null,
                                ),
                              ),
                              if (isPlus2)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    '(+2)',
                                    style: TextStyle(
                                        color: Colors.red[400],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              if (isDnf)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    'DNF',
                                    style: TextStyle(
                                        color: Colors.red[400],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(s.scramble,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                          trailing: Text(
                              s.date.toLocal().toString().split(' ')[0],
                              style: const TextStyle(fontSize: 10)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            const OllPllHeatmap(), // Tab 2
          ],
        ),
      ),
    );
  }

  Future<void> _runAutoAnalysis(BuildContext context, WidgetRef ref,
      List<Solve> currentSolves, double currentAvg) async {
    if (currentSolves.isEmpty) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
                content: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Il Coach sta analizzando i dati..."),
            ])));

    String splitsStr = '';
    final splitSolves = currentSolves
        .where((s) => s.splits != null && s.splits!.isNotEmpty)
        .toList();
    if (splitSolves.isNotEmpty) {
      final List<String> labels = [
        'Cross',
        'F2L1',
        'F2L2',
        'F2L3',
        'F2L4',
        'OLL',
        'PLL'
      ];
      Map<String, double> avgs = {};
      for (var l in labels) {
        final valid = splitSolves
            .where((s) => s.splits!.containsKey(l))
            .map((s) => s.splits![l]!)
            .toList();
        if (valid.isNotEmpty)
          avgs[l] = (valid.reduce((a, b) => a + b) / valid.length) / 1000.0;
      }
      splitsStr = avgs.entries
          .map((e) => '${e.key}: ${e.value.toStringAsFixed(2)}s')
          .join(', ');
    }

    String worstCasesStr = '';
    final allCases = allCasesByPuzzle[CubeType.threeByThree] ?? [];
    List<Map<String, dynamic>> caseStats = [];
    for (var c in allCases) {
      final stats = ref.read(ollPllStatsReactiveProvider(c.id));
      final time = stats['ao5'] ?? stats['best'];
      if (time != null) caseStats.add({'name': c.name, 'time': time});
    }
    caseStats.sort((a, b) => (b['time'] as int).compareTo(a['time'] as int));
    if (caseStats.isNotEmpty) {
      worstCasesStr = caseStats
          .take(3)
          .map(
              (c) => '${c['name']} (${(c['time'] / 1000).toStringAsFixed(2)}s)')
          .join(', ');
    }

    String trendStr = '';
    if (_compareSessionId != null) {
      final compareSolves = ref.read(solvesProvider(
          cubeType: ref.read(selectedCubeTypeProvider),
          sessionId: _compareSessionId!));
      if (compareSolves.isNotEmpty) {
        final compAvg = compareSolves
                .map((s) => s.effectiveTimeMs())
                .reduce((a, b) => a + b) /
            compareSolves.length;
        final diff = currentAvg - compAvg;
        final perc = (diff / compAvg) * 100;
        trendStr =
            '${perc > 0 ? "+" : ""}${perc.toStringAsFixed(1)}% vs $_compareSessionId';
      }
    }

    final baseStats = {
      'totalSolves': currentSolves.length,
      'bestTime': (currentSolves
                  .map((s) => s.effectiveTimeMs())
                  .reduce((a, b) => a < b ? a : b) /
              1000)
          .toStringAsFixed(2),
      'averageTime': (currentAvg / 1000).toStringAsFixed(2),
      'ao5': 'Vedi fasi',
      'ao12': 'N/A',
      'splits': splitsStr.isNotEmpty ? splitsStr : null,
      'worstCases': worstCasesStr.isNotEmpty ? worstCasesStr : null,
      'sessionTrend': trendStr.isNotEmpty ? trendStr : null,
    };

    final prompt =
        "Analizza questa sessione nel dettaglio. Evidenzia i miei punti deboli e dimmi esattamente cosa devo allenare. Sii pratico e vai dritto al punto.";
    final response = await ref
        .read(deepSeekServiceProvider)
        .getCoachResponse(prompt, baseStats);

    if (!context.mounted) return;
    Navigator.pop(context); // Close loading dialog

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text('Analisi del Coach AI'),
                content: SingleChildScrollView(child: Text(response)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Chiudi'))
                ]));
  }

  void _showPenaltyDialog(BuildContext context, Solve solve) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifica Solve'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Nessuna Penalità'),
                leading: const Icon(Icons.check_circle_outline),
                onTap: () {
                  _updatePenalty(solve, '');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('+2 Secondi'),
                leading:
                    const Icon(Icons.timer_off_outlined, color: Colors.orange),
                onTap: () {
                  _updatePenalty(solve, '+2');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('DNF (Did Not Finish)'),
                leading: const Icon(Icons.cancel_outlined, color: Colors.red),
                onTap: () {
                  _updatePenalty(solve, 'DNF');
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Elimina Solve',
                    style: TextStyle(color: Colors.red)),
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                onTap: () {
                  ref.read(solveRepositoryProvider).deleteSolve(solve.id);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updatePenalty(Solve solve, String newPenalty) {
    // Generate a new Solve instance with the updated penalty.
    final updatedSolve = Solve(
      id: solve.id,
      cube: solve.cube,
      scramble: solve.scramble,
      timeMs: solve.timeMs,
      penalty: newPenalty,
      date: solve.date,
      cubeType: solve.cubeType,
    );
    ref.read(solveRepositoryProvider).updateSolve(updatedSolve);
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: Colors.grey)),
            ],
          ),
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
