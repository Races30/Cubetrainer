import 'package:hive/hive.dart';
import '../models/training_session.dart';
import '../models/training_solve.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'leaderboard_service.dart';
import '../models/leaderboard_entry.dart';

part 'training_repository.g.dart';

class TrainingRepository {
  final Box<TrainingSession> _sessionBox;
  final Box<TrainingSolve> _solveBox;
  final LeaderboardService _leaderboardService;

  TrainingRepository(
      this._sessionBox, this._solveBox, this._leaderboardService);

  // --- Sessions ---
  Future<void> saveSession(TrainingSession session) async {
    await _sessionBox.put(session.sessionId, session);
  }

  List<TrainingSession> getSessions() {
    return _sessionBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // --- Solves ---
  Future<bool> saveSolve(TrainingSolve solve) async {
    await _solveBox.add(solve);

    // Add to leaderboard
    final entry = LeaderboardEntry(
      id: solve.id,
      cube: solve.cube,
      mode: solve.sessionType.toString().split('.').last, // e.g., 'cross'
      timeMs: solve.totalTimeMs,
      sessionId: solve.sessionId,
      date: solve.date,
    );
    return await _leaderboardService.addEntry(entry);
  }

  List<TrainingSolve> getSolvesForSession(String sessionId) {
    return _solveBox.values.where((s) => s.sessionId == sessionId).toList();
  }

  Stream<BoxEvent> watchSessions() => _sessionBox.watch();
  Stream<BoxEvent> watchSolves() => _solveBox.watch();
}

@riverpod
TrainingRepository trainingRepository(TrainingRepositoryRef ref) {
  final sessionBox = Hive.box<TrainingSession>('training_sessions');
  final solveBox = Hive.box<TrainingSolve>('training_solves');
  final leaderboardService = ref.read(leaderboardServiceProvider);
  return TrainingRepository(sessionBox, solveBox, leaderboardService);
}
