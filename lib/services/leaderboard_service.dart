import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/leaderboard_entry.dart';

class LeaderboardService {
  final Box<LeaderboardEntry> _box;

  LeaderboardService(this._box);

  Future<bool> addEntry(LeaderboardEntry entry) async {
    await _box.put(entry.id, entry);
    return await _enforceLimit(entry.id, entry.mode, entry.cube);
  }

  Future<bool> _enforceLimit(String newId, String mode, String cube) async {
    final entries = getEntries(mode, cube);
    bool inTop50 = false;

    // Check if newId is in the top 50 (or list size if < 50)
    for (int i = 0; i < entries.length; i++) {
      if (entries[i].id == newId) {
        if (i < 50) {
          inTop50 = true;
        }
        break;
      }
    }

    if (entries.length > 50) {
      // Keep top 50, delete the rest
      final toDelete = entries.sublist(50);
      for (var entry in toDelete) {
        await _box.delete(entry.id);
      }
    }

    return inTop50;
  }

  List<LeaderboardEntry> getEntries(String mode, String cube) {
    return _box.values.where((e) => e.mode == mode && e.cube == cube).toList()
      ..sort((a, b) => a.timeMs.compareTo(b.timeMs));
  }

  Future<void> deleteEntry(String id) async {
    await _box.delete(id);
  }

  Stream<BoxEvent> watchEntries() => _box.watch();
}

final leaderboardServiceProvider = Provider<LeaderboardService>((ref) {
  final box = Hive.box<LeaderboardEntry>('leaderboard_box');
  return LeaderboardService(box);
});
