import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cubetrainer/models/training_session.dart';
import 'package:cubetrainer/models/exercise_type.dart';
import 'dart:io';

void main() {
  group('TrainingSession Model & Persistence', () {
    setUpAll(() async {
      // Setup temporary hive for testing
      final tempDir = Directory.systemTemp.createTempSync();
      Hive.init(tempDir.path);
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(TrainingSessionAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(ExerciseTypeAdapter());
      }
      if (!Hive.isAdapterRegistered(5)) {
        Hive.registerAdapter(EvaluationModeAdapter());
      }
    });

    test('Should preserve targetMs and evaluationMode when stored in Hive',
        () async {
      final box = await Hive.openBox<TrainingSession>('test_sessions');

      final session = TrainingSession(
        sessionId: 'test-123',
        type: ExerciseType.cross,
        date: DateTime.now(),
        totalSolves: 12,
        targetMs: 15000, // 15s
        evaluationMode: EvaluationMode.best,
      );

      await box.put(session.sessionId, session);

      final retrieved = box.get('test-123');
      expect(retrieved?.targetMs, equals(15000));
      expect(retrieved?.evaluationMode, equals(EvaluationMode.best));

      await box.close();
    });

    test('Evaluation Logic Simulation', () {
      final targetMs = 20000.0; // 20s

      // Case 1: Average below target (Green)
      final solves1 = [18000, 19000, 20000]; // Avg: 19.0
      double avg1 = solves1.reduce((a, b) => a + b) / solves1.length;
      expect(avg1 <= targetMs, isTrue);

      // Case 2: Average slightly above (+5%) (Orange)
      final solves2 = [21000, 21000]; // Avg: 21.0
      double avg2 = solves2.reduce((a, b) => a + b) / solves2.length;
      expect(avg2 > targetMs && avg2 <= targetMs * 1.1, isTrue);

      // Case 3: Average way above (+15%) (Red)
      final solves3 = [24000, 25000]; // Avg: 24.5
      double avg3 = solves3.reduce((a, b) => a + b) / solves3.length;
      expect(avg3 > targetMs * 1.1, isTrue);
    });
  });
}
