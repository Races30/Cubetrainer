import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cubetrainer/models/solve.dart';

/// Global provider for the selected cube type.
/// Uses standard StateProvider to avoid code generation issues for simple state.
final selectedCubeTypeProvider =
    StateProvider<CubeType>((ref) => CubeType.threeByThree);
