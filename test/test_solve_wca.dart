import 'package:flutter_test/flutter_test.dart';
import 'package:cubetrainer/services/cube_state.dart';
import 'package:cubetrainer/services/cross_solver.dart';

void main() {
  test('Analyze White Cross output', () async {
    final scramble =
        "B F2 L2 R' F L U2 R2 D2 U2 F2 R L F2 U2 R2 L B' F' L2 U D B2 R2 F2";
    final state = CubeState();
    state.applyScramble(scramble);
    print("Is Face 0 (White) solved right now? " +
        state.isCrossSolved(targetFace: 0).toString());

    // Test the internal method synchronously since we are in test environment
    final solution = await CrossSolver.solveCross(scramble);
    print("White Cross Optimal Solution (Face 0): " +
        (solution?.join(' ') ?? "null"));

    if (solution != null && solution.isNotEmpty) {
      state.applyScramble(solution.join(' '));
      print("After algorithm, is Face 0 solved? " +
          state.isCrossSolved(targetFace: 0).toString());
      // Verify cross is oriented
      int center = state.stateList[4]; // White
      int f0top = state.stateList[1];
      int f0left = state.stateList[3];
      int f0right = state.stateList[5];
      int f0bottom = state.stateList[7];
      print("Face 0 edges: " +
          f0top.toString() +
          " " +
          f0left.toString() +
          " " +
          f0right.toString() +
          " " +
          f0bottom.toString() +
          " (all should be " +
          center.toString() +
          ")");
    }
  });
}
