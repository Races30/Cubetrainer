import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cubetrainer/models/solve.dart';
import 'package:cubetrainer/models/solving_method.dart';
import 'package:cubetrainer/models/exercise_type.dart';

class TrainingScrambleRepository {
  final Map<CubeType, Map<SolvingMethod, Map<ExerciseType, List<String>>>>
      _scrambles = {};

  List<String> getScrambles({
    required CubeType cubeType,
    required SolvingMethod solvingMethod,
    required ExerciseType exerciseType,
  }) {
    return _scrambles[cubeType]?[solvingMethod]?[exerciseType] ?? [];
  }
}

final trainingScrambleRepositoryProvider = Provider((ref) => TrainingScrambleRepository());