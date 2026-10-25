import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cubetrainer/models/leaderboard_entry.dart';
import 'package:cubetrainer/services/leaderboard_service.dart';
import 'dart:io';

void main() {
  group('LeaderboardService Tests', () {
    late Box<LeaderboardEntry> box;
    late LeaderboardService service;
    late Directory tempDir;

    setUp(() async {
      tempDir = Directory.systemTemp.createTempSync();
      Hive.init(tempDir.path);
      if (!Hive.isAdapterRegistered(6)) {
        Hive.registerAdapter(LeaderboardEntryAdapter());
      }
      box = await Hive.openBox<LeaderboardEntry>('leaderboard_test_box');
      service = LeaderboardService(box);
    });

    tearDown(() async {
      await box.close();
      await tempDir.delete(recursive: true);
    });

    test('Should add entry and sort by time ascending', () async {
      final entry1 = LeaderboardEntry(
        id: '1',
        mode: 'cross',
        timeMs: 5000,
        date: DateTime.now(),
      );
      final entry2 = LeaderboardEntry(
        id: '2',
        mode: 'cross',
        timeMs: 3000,
        date: DateTime.now(),
      );

      await service.addEntry(entry1);
      await service.addEntry(entry2);

      final entries = service.getEntries('cross', '3x3');
      expect(entries.length, 2);
      expect(entries[0].id, '2'); // 3000ms should be first
      expect(entries[1].id, '1'); // 5000ms should be second
    });

    test('Should enforce 50 entry limit per mode/cube', () async {
      // Add 60 entries with decreasing times (so strictly they should all be kept if no limit)
      // keeping only the fastest 50.
      // Wait, if I add them in order of "slower first", the faster ones added later should displace them?
      // No, list logic is: get all, sort, if > 50, delete sublist(50).
      // Since 'delete' is async and triggered after add, let's verify.

      // Let's add 55 entries.
      // 5 worse ones (10000ms + i)
      // 50 better ones (1000 + i)

      for (int i = 0; i < 55; i++) {
        await service.addEntry(LeaderboardEntry(
          id: 'id_$i',
          mode: 'f2l',
          timeMs: 1000 + i, // 1000..1054
          date: DateTime.now(),
        ));
      }

      final entries = service.getEntries('f2l', '3x3');
      expect(entries.length, 50);
      expect(entries.first.timeMs, 1000);
      expect(entries.last.timeMs, 1049);

      // Now add a super fast one
      await service.addEntry(LeaderboardEntry(
        id: 'fast_one',
        mode: 'f2l',
        timeMs: 500,
        date: DateTime.now(),
      ));

      final updatedEntries = service.getEntries('f2l', '3x3');
      expect(updatedEntries.length, 50);
      expect(updatedEntries.first.timeMs, 500); // New fast one is first
      expect(updatedEntries.last.timeMs,
          1048); // The previous slowest (1049) should be gone
    });

    test('Should filter by mode', () async {
      await service.addEntry(LeaderboardEntry(
        id: '1',
        mode: 'cross',
        timeMs: 5000,
        date: DateTime.now(),
      ));
      await service.addEntry(LeaderboardEntry(
        id: '2',
        mode: 'pll',
        timeMs: 4000,
        date: DateTime.now(),
      ));

      final crossEntries = service.getEntries('cross', '3x3');
      final pllEntries = service.getEntries('pll', '3x3');

      expect(crossEntries.length, 1);
      expect(crossEntries.first.mode, 'cross');
      expect(pllEntries.length, 1);
      expect(pllEntries.first.mode, 'pll');
    });

    test('Should delete entry', () async {
      await service.addEntry(LeaderboardEntry(
        id: '1',
        mode: 'cross',
        timeMs: 5000,
        date: DateTime.now(),
      ));

      await service.deleteEntry('1');
      final entries = service.getEntries('cross', '3x3');
      expect(entries.isEmpty, isTrue);
    });
  });
}
