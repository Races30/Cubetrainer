import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/oll_pll_solve.dart';

final ollPllRepositoryProvider = Provider((ref) => OllPllRepository());

class OllPllRepository {
  Box<OllPllSolve> get _box => Hive.box<OllPllSolve>('oll_pll_solves');

  Future<void> saveSolve(OllPllSolve solve) async {
    await _box.add(solve);
  }

  Future<void> deleteSolve(OllPllSolve solve) async {
    await solve.delete();
  }

  Future<void> clearSolvesForCase(String caseId) async {
    final keys =
        _box.values.where((s) => s.caseId == caseId).map((s) => s.key).toList();
    await _box.deleteAll(keys);
  }

  List<OllPllSolve> getSolvesForCase(String caseId) {
    return _box.values.where((s) => s.caseId == caseId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  int getSolveCount(String caseId) {
    return _box.values.where((s) => s.caseId == caseId).length;
  }

  int? getBestTime(String caseId) {
    final solves = getSolvesForCase(caseId);
    if (solves.isEmpty) return null;
    return solves.map((s) => s.timeMs).reduce((a, b) => a < b ? a : b);
  }

  int? getAo5(String caseId) {
    final solves = getSolvesForCase(caseId);
    if (solves.length < 5) return null;

    final recent5 = solves.take(5).map((s) => s.timeMs).toList();
    recent5.sort();

    // remove best and worst
    recent5.removeAt(0);
    recent5.removeLast();

    return (recent5.reduce((a, b) => a + b) / 3).round();
  }
}
