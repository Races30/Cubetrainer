import 'package:flutter_test/flutter_test.dart';
import 'package:cubetrainer/models/exercise_type.dart';
import 'package:cubetrainer/models/training_solve.dart';
import 'package:cubetrainer/models/training_session.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('TrainingSession Logic Tests', () {
    test(
        'Should create a TrainingSession and multiple TrainingSolves with matching sessionId',
        () {
      final sessionId = const Uuid().v4();
      final session = TrainingSession(
        sessionId: sessionId,
        type: ExerciseType.cross,
        date: DateTime.now(),
        totalSolves: 12,
      );

      final solves = List.generate(
          12,
          (i) => TrainingSolve(
                id: const Uuid().v4(),
                scramble: 'R U R\' U\'',
                totalTimeMs: 10000 + i * 100,
                phaseTimes: {'cross': 2000, 'f2l': 8000},
                sessionId: sessionId,
                sessionType: ExerciseType.cross,
                date: DateTime.now(),
              ));

      expect(session.sessionId, equals(sessionId));
      expect(solves.length, 12);
      expect(solves.every((s) => s.sessionId == sessionId), isTrue);
    });

    test('Should record phase times correctly', () {
      final solve = TrainingSolve(
        id: '1',
        scramble: 'U',
        totalTimeMs: 5000,
        phaseTimes: {'recognition': 1000, 'execution': 4000},
        sessionId: 'session-1',
        sessionType: ExerciseType.oll,
        date: DateTime.now(),
      );

      expect(solve.phaseTimes['recognition'], 1000);
      expect(solve.phaseTimes['execution'], 4000);
      expect(solve.phaseTimes.values.reduce((a, b) => a + b),
          equals(solve.totalTimeMs));
    });
  });
}
