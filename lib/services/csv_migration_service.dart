import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'storage_utils.dart';

import '../models/solve.dart';
import '../models/coach_message.dart';
import '../models/scramble_history_item.dart';
import 'solve_repository.dart';
import 'coach_repository.dart';
import 'persistent_scramble_repository.dart';

class CsvMigrationService {
  final Ref ref;

  CsvMigrationService(this.ref);

  Future<String?> exportAll() async {
    final solves = ref.read(solveRepositoryProvider).getSolves();
    final scrambles =
        ref.read(persistentScrambleRepositoryProvider).getHistory();
    final messages = ref.read(coachRepositoryProvider).getMessages();

    final List<List<dynamic>> rows = [];

    // Header
    rows.add([
      'type',
      'field1',
      'field2',
      'field3',
      'field4',
      'field5',
      'field6',
      'field7'
    ]);

    // Solves
    for (var s in solves) {
      rows.add([
        'solve',
        s.id,
        s.cube,
        s.scramble,
        s.timeMs,
        s.penalty,
        s.date.toIso8601String(),
        s.cubeType.toString().split('.').last,
      ]);
    }

    // Scrambles
    for (var sc in scrambles) {
      rows.add([
        'scramble',
        sc.scramble,
        sc.cubeType.toString().split('.').last,
        sc.date.toIso8601String(),
        '',
        '',
        '',
        ''
      ]);
    }

    // Coach Messages
    for (var m in messages) {
      rows.add([
        'coach',
        m.role,
        m.content,
        m.date.toIso8601String(),
        '',
        '',
        '',
        ''
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    final fileName =
        'scramble_backup_${DateTime.now().millisecondsSinceEpoch}.csv';

    if (kIsWeb) {
      final bytes = Uint8List.fromList(utf8.encode(csv));
      await Share.shareXFiles(
        [XFile.fromData(bytes, mimeType: 'text/csv', name: fileName)],
        text: 'Backup CSV CubeTrainer',
      );
      return fileName;
    }

    final dir = await StorageUtils.getExportDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(csv);
    return file.path;
  }

  Future<bool> importAll() async {
    String? initialDir;
    if (!kIsWeb) {
      final exportDir = await StorageUtils.getExportDirectory();
      initialDir = exportDir.path;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      initialDirectory: initialDir,
      withData: kIsWeb,
    );

    if (result == null) return false;

    String csvString;
    if (kIsWeb || result.files.single.path == null) {
      final bytes = result.files.single.bytes;
      if (bytes == null) return false;
      csvString = utf8.decode(bytes);
    } else {
      final file = File(result.files.single.path!);
      csvString = await file.readAsString();
    }

    final List<List<dynamic>> rows =
        const CsvToListConverter().convert(csvString);

    if (rows.isEmpty) return false;

    final solveRepo = ref.read(solveRepositoryProvider);
    final coachRepo = ref.read(coachRepositoryProvider);
    final scrambleRepo = ref.read(persistentScrambleRepositoryProvider);

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      final type = row[0].toString();
      try {
        switch (type) {
          case 'solve':
            await solveRepo.saveSolve(Solve(
              id: _get(
                  row, 1, DateTime.now().millisecondsSinceEpoch.toString()),
              cube: _get(row, 2, '3x3'),
              scramble: _get(row, 3, ''),
              timeMs: _get(row, 4, 0),
              penalty: _get(row, 5, ''),
              date: _get(row, 6, DateTime.now()),
              cubeType: CubeType.values.firstWhere(
                (e) =>
                    e.toString().split('.').last ==
                    _get(row, 7, 'threeByThree'),
                orElse: () => CubeType.threeByThree,
              ),
            ));
            break;
          case 'scramble':
            await scrambleRepo.addScramble(ScrambleHistoryItem(
              scramble: _get(row, 1, ''),
              cubeType: CubeType.values.firstWhere(
                (e) =>
                    e.toString().split('.').last ==
                    _get(row, 2, 'threeByThree'),
                orElse: () => CubeType.threeByThree,
              ),
              date: _get(row, 3, DateTime.now()),
            ));
            break;
          case 'coach':
            await coachRepo.addMessage(CoachMessage(
              role: _get(row, 1, 'system'),
              content: _get(row, 2, ''),
              date: _get(row, 3, DateTime.now()),
            ));
            break;
        }
      } catch (e) {
        // Skip malformed rows safely
        continue;
      }
    }
    return true;
  }

  /// Helper to safely retrieve values from a CSV row with defaults and type parsing.
  T _get<T>(List<dynamic> row, int index, T defaultValue) {
    if (index >= row.length) return defaultValue;
    final val = row[index];
    if (val == null || val.toString().trim().isEmpty) return defaultValue;

    try {
      if (defaultValue is int) {
        return (int.tryParse(val.toString()) ?? defaultValue) as T;
      }
      if (defaultValue is DateTime) {
        return (DateTime.tryParse(val.toString()) ?? defaultValue) as T;
      }
      return val as T;
    } catch (_) {
      return defaultValue;
    }
  }
}

final csvMigrationServiceProvider = Provider((ref) => CsvMigrationService(ref));
