import 'package:hive/hive.dart';
import '../models/solve.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Required for Ref

part 'solve_repository.g.dart';

class SolveRepository {
  final Box<Solve> _solvesBox;

  SolveRepository(this._solvesBox);

  List<Solve> getSolves({CubeType? cubeType, String? sessionId}) {
    var solves = _solvesBox.values;
    if (cubeType != null) {
      solves = solves.where((solve) => solve.cubeType == cubeType);
    }
    if (sessionId != null) {
      solves = solves.where((solve) => solve.sessionId == sessionId);
    }
    return solves.toList();
  }

  /// Returns a list of unique session IDs for a given cube type
  List<String> getAvailableSessions({CubeType? cubeType}) {
    var solves = _solvesBox.values;
    if (cubeType != null) {
      solves = solves.where((solve) => solve.cubeType == cubeType);
    }
    final sessions = solves.map((solve) => solve.sessionId).toSet().toList();
    if (!sessions.contains('main')) {
      sessions.insert(0, 'main'); // Ensure 'main' is always available
    }
    return sessions;
  }

  Future<void> saveSolve(Solve solve) async {
    await _solvesBox.add(solve);
  }

  Future<void> updateSolve(Solve solve) async {
    final index =
        _solvesBox.values.toList().indexWhere((s) => s.id == solve.id);
    if (index != -1) {
      await _solvesBox.putAt(index, solve);
    }
  }

  Future<void> deleteSolve(String id) async {
    final Map<dynamic, Solve> solvesMap = _solvesBox.toMap();
    dynamic keyToDelete;
    solvesMap.forEach((key, value) {
      if (value.id == id) {
        keyToDelete = key;
      }
    });
    if (keyToDelete != null) {
      await _solvesBox.delete(keyToDelete);
    }
  }

  Stream<BoxEvent> watchSolves() {
    return _solvesBox.watch();
  }
}

@riverpod
SolveRepository solveRepository(Ref ref) {
  final solvesBox = Hive.box<Solve>('solves');
  return SolveRepository(solvesBox);
}

@riverpod
List<Solve> solves(Ref ref, {CubeType? cubeType, String? sessionId}) {
  final repository = ref.watch(solveRepositoryProvider);

  // Note: Hive boxes don't intrinsically trigger Riverpod updates on write.
  // We use watch() to listen for changes and invalidate this provider.
  final subscription = repository.watchSolves().listen((event) {
    ref.invalidateSelf();
  });
  ref.onDispose(subscription.cancel);

  return repository.getSolves(cubeType: cubeType, sessionId: sessionId);
}
