import 'package:cubetrainer/services/cube_state.dart';

void main() {
  final scramble =
      "B2 D2 U2 F R B F L R2 D' U R' B2 U2 D2 L R' F' D2 B' L D2 B' R D2";

  // First, let's verify standard correct solution
  final correctMoves = "L' D2 L2 D' R F";
  final state1 = CubeState();
  state1.applyScramble(scramble);
  state1.applyScramble(correctMoves);
  print("USER CORRECT SOLUTION EVALUATES TO: " +
      state1.isCrossSolved().toString());

  // Second, solver's old "incorrect" solution
  final solverMoves = "D' L U' D2";
  final state2 = CubeState();
  state2.applyScramble(scramble);
  state2.applyScramble(solverMoves);
  print("SOLVER SHORT SOLUTION evaluates to: " +
      state2.isCrossSolved().toString());

  if (state2.isCrossSolved()) {
    print("WARNING: SOLVER BAD SOLUTION IS STILL EVALUATING TO TRUE.");
  }
}
