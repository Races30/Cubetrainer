import 'package:hive/hive.dart';
import 'exercise_type.dart';

part 'training_solve.g.dart';

@HiveType(typeId: 8)
class TrainingSolve {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String cube;
  @HiveField(2)
  final String scramble;
  @HiveField(3)
  final int totalTimeMs;
  @HiveField(4)
  final Map<String, int> phaseTimes; // e.g., {'cross': 2000, 'f2l': 8000}
  @HiveField(5)
  final Map<String, int>? movesCount; // e.g., {'cross': 7}
  @HiveField(6)
  final String penalty; // '', '+2', 'DNF'
  @HiveField(7)
  final List<String> tags;
  @HiveField(8)
  final String sessionId;
  @HiveField(9)
  final ExerciseType sessionType;
  @HiveField(10)
  final DateTime date;

  TrainingSolve({
    required this.id,
    this.cube = '3x3',
    required this.scramble,
    required this.totalTimeMs,
    required this.phaseTimes,
    this.movesCount,
    this.penalty = '',
    this.tags = const [],
    required this.sessionId,
    required this.sessionType,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cube': cube,
      'scramble': scramble,
      'totalTimeMs': totalTimeMs,
      'phaseTimes': phaseTimes,
      'movesCount': movesCount,
      'penalty': penalty,
      'tags': tags,
      'sessionId': sessionId,
      'sessionType': sessionType.toString().split('.').last,
      'date': date.toIso8601String(),
    };
  }
}
