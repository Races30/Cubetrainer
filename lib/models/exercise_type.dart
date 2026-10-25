import 'package:hive/hive.dart';

part 'exercise_type.g.dart';

@HiveType(typeId: 2)
enum ExerciseType {
  @HiveField(0)
  cross,
  @HiveField(1)
  f2l,
  @HiveField(2)
  oll,
  @HiveField(3)
  pll,
  @HiveField(4)
  recognition,
  @HiveField(5)
  lookahead,
  @HiveField(6)
  beautifulPatterns,
  @HiveField(7)
  randomCube,
  @HiveField(8)
  mixed,
}
