import 'dart:io';
import 'lib/services/cube_state.dart';
import 'lib/services/cross_solver.dart';

void main() async {
  final scramble =
      "B2 D2 U2 F R B F L R2 D' U R' B2 U2 D2 L R' F' D2 B' L D2 B' R D2";
  print("Scramble: $scramble");

  final state = CubeState();
  state.applyScramble(scramble);

  print("Is solved already: ${state.isCrossSolved()}");

  // Try the user's correct solution
  final correctMoves = "L' D2 L2 D' R F";
  final testState = state.clone();
  testState.applyScramble(correctMoves);
  print("User solution works: ${testState.isCrossSolved()}");

  // Try what the solver says
  final solverSolutionStr = "D' L U' D2";
  final solverState = state.clone();
  solverState.applyScramble(solverSolutionStr);
  print("Solver original solution works: ${solverState.isCrossSolved()}");

  // Run the solver
  final solution = await CrossSolver.solveCross(scramble);
  print("Solver returns: $solution");
  if (solution != null) {
    final finalState = state.clone();
    for (var m in solution) {
      finalState.applyMove(m);
    }
    print("Solver found solution works: ${finalState.isCrossSolved()}");
  }
}
