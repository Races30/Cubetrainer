import 'package:hive/hive.dart';
import 'exercise_type.dart';

part 'training_session.g.dart';

@HiveType(typeId: 5)
enum EvaluationMode {
  @HiveField(0)
  avg,
  @HiveField(1)
  best,
}

@HiveType(typeId: 4)
class TrainingSession {
  @HiveField(0)
  final String sessionId;
  @HiveField(1)
  final ExerciseType type;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final int totalSolves;
  @HiveField(4)
  final double successPercentage;
  @HiveField(5)
  final Map<String, String> metadata; // e.g., repetition count
  @HiveField(6)
  final int targetMs;
  @HiveField(7)
  final EvaluationMode evaluationMode;

  TrainingSession({
    required this.sessionId,
    required this.type,
    required this.date,
    required this.totalSolves,
    this.successPercentage = 0.0,
    this.metadata = const {},
    this.targetMs = 0,
    this.evaluationMode = EvaluationMode.avg,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'type': type.toString().split('.').last,
      'date': date.toIso8601String(),
      'totalSolves': totalSolves,
      'successPercentage': successPercentage,
      'metadata': metadata,
      'targetMs': targetMs,
      'evaluationMode': evaluationMode.name,
    };
  }
}
