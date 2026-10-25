import 'dart:io';
import 'package:csv/csv.dart';
import '../models/solve.dart';
import 'storage_utils.dart';

class CsvExporter {
  static Future<String> exportSolves(List<Solve> solves) async {
    final rows = [
      ['id', 'date', 'cube', 'timeMs', 'timeFormatted', 'scramble', 'penalty']
    ];
    for (var s in solves) {
      rows.add([
        s.id,
        s.date.toIso8601String(),
        s.cube,
        s.timeMs.toString(),
        _formatMs(s.timeMs),
        s.scramble,
        s.penalty
      ]);
    }
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await StorageUtils.getExportDirectory();
    final file = File(
        '${dir.path}/cubetrainer_export_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csv);
    return file.path;
  }

  static String _formatMs(int ms) {
    // ignore: unused_local_variable
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    // ignore: unused_local_variable
    final seconds = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    // ignore: unused_local_variable
    final hundredths = ((ms % 1000) ~/ 10).toString().padLeft(2, '0');
    return '\$minutes:\$seconds.\$hundredths';
  }
}
