import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/solve.dart';

class SplitsStackedBar extends StatelessWidget {
  final List<Solve> solves;
  final List<String> phaseLabels = [
    'Cross',
    'F2L1',
    'F2L2',
    'F2L3',
    'F2L4',
    'OLL',
    'PLL'
  ];

  SplitsStackedBar({super.key, required this.solves});

  @override
  Widget build(BuildContext context) {
    if (solves.isEmpty) return const SizedBox.shrink();

    // Filter solves that actually have full or partial splits
    final splitSolves =
        solves.where((s) => s.splits != null && s.splits!.isNotEmpty).toList();
    if (splitSolves.isEmpty) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Nessun dato Split registrato per questa sessione.',
            style: TextStyle(color: Colors.grey)),
      ));
    }

    final theme = Theme.of(context);
    List<Color> colors = [
      Colors.white, // Cross
      Colors.blueAccent, // F2L1
      Colors.cyanAccent, // F2L2
      Colors.indigoAccent, // F2L3
      Colors.deepPurpleAccent, // F2L4
      Colors.yellowAccent, // OLL
      Colors.redAccent, // PLL
    ];

    return Container(
      height: 250,
      padding: const EdgeInsets.only(right: 16, top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(phaseLabels.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Container(
                        width: 8, height: 8, color: colors[i % colors.length]),
                    const SizedBox(width: 4),
                    Text(phaseLabels[i], style: const TextStyle(fontSize: 10)),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.black87,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      // Rod is a single stacked rod... we need to find which phase we are touching
                      return BarTooltipItem(
                        '${(rod.toY - rod.fromY) / 1000.0}s',
                        const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        int i = val.toInt();
                        if (i < 0 || i >= splitSolves.length)
                          return const SizedBox.shrink();
                        // Just show a small dot or ID for x-axis
                        return const Text('•',
                            style: TextStyle(color: Colors.grey));
                      },
                      reservedSize: 16,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (val, meta) => Text(
                          '${val.toInt() / 1000}s',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.grey)),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: splitSolves.asMap().entries.map((e) {
                  final idx = e.key;
                  final solve = e.value;
                  final splits = solve.splits!;

                  List<BarChartRodStackItem> stackItems = [];
                  double currentY = 0;

                  for (int i = 0; i < phaseLabels.length; i++) {
                    final phase = phaseLabels[i];
                    final phaseMs = splits[phase] ?? 0;
                    if (phaseMs > 0) {
                      stackItems.add(
                        BarChartRodStackItem(currentY, currentY + phaseMs,
                            colors[i % colors.length]),
                      );
                      currentY += phaseMs;
                    }
                  }

                  return BarChartGroupData(
                    x: idx,
                    barRods: [
                      BarChartRodData(
                        toY: currentY,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                        rodStackItems: stackItems,
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
