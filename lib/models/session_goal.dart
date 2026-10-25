import 'package:hive/hive.dart';
import 'solve.dart';

part 'session_goal.g.dart';

@HiveType(typeId: 11)
enum GoalType {
  @HiveField(0)
  ao5,
  @HiveField(1)
  ao12,
  @HiveField(2)
  bestTime,
  @HiveField(3)
  solveCount,
}

@HiveType(typeId: 12)
class SessionGoal {
  @HiveField(0)
  final String sessionId;
  @HiveField(1)
  final GoalType type;

  /// Target value: either time in milliseconds (double) or solve count
  @HiveField(2)
  final double targetValue;

  SessionGoal({
    required this.sessionId,
    required this.type,
    required this.targetValue,
  });
}

@HiveType(typeId: 13)
class GoalAchievement {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final GoalType type;
  @HiveField(3)
  final double targetValue;
  @HiveField(4)
  final double actualValue;
  @HiveField(5)
  final String sessionId;
  @HiveField(6)
  final CubeType cubeType;

  GoalAchievement({
    required this.id,
    required this.date,
    required this.type,
    required this.targetValue,
    required this.actualValue,
    required this.sessionId,
    required this.cubeType,
  });
}
