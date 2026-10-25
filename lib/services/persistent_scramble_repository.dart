import 'package:hive/hive.dart';
import '../models/scramble_history_item.dart';
import '../models/solve.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'persistent_scramble_repository.g.dart';

class PersistentScrambleRepository {
  final Box<ScrambleHistoryItem> _box;

  PersistentScrambleRepository(this._box);

  List<ScrambleHistoryItem> getHistory({CubeType? cubeType}) {
    if (cubeType == null) {
      return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
    } else {
      return _box.values.where((e) => e.cubeType == cubeType).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    }
  }

  Future<void> addScramble(ScrambleHistoryItem item) async {
    await _box.add(item);
  }

  Future<void> deleteScramble(int index) async {
    await _box.deleteAt(index);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  Stream<BoxEvent> watchHistory() {
    return _box.watch();
  }
}

@riverpod
PersistentScrambleRepository persistentScrambleRepository(
    PersistentScrambleRepositoryRef ref) {
  final box = Hive.box<ScrambleHistoryItem>('scramble_history');
  return PersistentScrambleRepository(box);
}

@riverpod
List<ScrambleHistoryItem> scrambleHistory(ScrambleHistoryRef ref,
    {CubeType? cubeType}) {
  final repository = ref.watch(persistentScrambleRepositoryProvider);
  final subscription = repository.watchHistory().listen((_) {
    ref.invalidateSelf();
  });
  ref.onDispose(subscription.cancel);
  return repository.getHistory(cubeType: cubeType);
}
