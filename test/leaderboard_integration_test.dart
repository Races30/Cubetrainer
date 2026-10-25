import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cubetrainer/models/leaderboard_entry.dart';
import 'package:cubetrainer/services/leaderboard_service.dart';
import 'dart:io';

void main() {
  group('Leaderboard Integration Tests', () {
    late Box<LeaderboardEntry> box;
    late LeaderboardService service;
    late Directory tempDir;

    setUp(() async {
      tempDir = Directory.systemTemp.createTempSync();
      Hive.init(tempDir.path);
      if (!Hive.isAdapterRegistered(6)) {
        Hive.registerAdapter(LeaderboardEntryAdapter());
      }
      box = await Hive.openBox<LeaderboardEntry>('leaderboard_integration_box');
      service = LeaderboardService(box);
    });

    tearDown(() async {
      await box.close();
      await tempDir.delete(recursive: true);
    });

    test('addEntry should return true when entry is in top 50', () async {
      final entry = LeaderboardEntry(
        id: '1',
        mode: 'cross',
        timeMs: 5000,
        date: DateTime.now(),
      );

      final result = await service.addEntry(entry);
      expect(result, isTrue);
    });

    test('addEntry should return false when entry is bumped out of top 50',
        () async {
      // improvements: fill with 50 specific entries
      for (int i = 0; i < 50; i++) {
        await service.addEntry(LeaderboardEntry(
          id: 'id_$i',
          mode: 'f2l',
          timeMs: 1000 + i, // 1000..1049
          date: DateTime.now(),
        ));
      }

      // Add a slow one (2000ms), should be rejected (false)
      final slowEntry = LeaderboardEntry(
        id: 'slow',
        mode: 'f2l',
        timeMs: 2000,
        date: DateTime.now(),
      );
      final resultSlow = await service.addEntry(slowEntry);
      expect(resultSlow, isFalse);

      // Verify it's not in the box
      final entries = service.getEntries('f2l', '3x3');
      expect(entries.any((e) => e.id == 'slow'), isFalse);
      expect(entries.length, 50);

      // Add a fast one (500ms), should be accepted (true)
      final fastEntry = LeaderboardEntry(
        id: 'fast',
        mode: 'f2l',
        timeMs: 500,
        date: DateTime.now(),
      );
      final resultFast = await service.addEntry(fastEntry);
      expect(resultFast, isTrue);

      // Verify it is in the box
      final updatedEntries = service.getEntries('f2l', '3x3');
      expect(updatedEntries.any((e) => e.id == 'fast'), isTrue);
      expect(updatedEntries.first.id, 'fast');
    });
  });
}
