import 'package:cubetrainer/services/cube_state.dart';

void main() {
  final scramble =
      "B2 D2 U2 F R B F L R2 D' U R' B2 U2 D2 L R' F' D2 B' L D2 B' R D2";
  final solverMoves = "L' D2 L2 D' R F";

  final state = CubeState();
  state.applyScramble(scramble);
  state.applyScramble(solverMoves);

  print("USER 6-move solution (L' D2 L2 D' R F) cross evaluation:");
  bool anySolved = false;
  for (int face = 0; face < 6; face++) {
    if (state.isCrossSolved(targetFace: face)) {
      int centerColor = state.stateList[face * 9 + 4];
      print(
          "-> IT PERFECTLY SOLVES THE CROSS ON FACE \$face (Color \$centerColor)!!");
      anySolved = true;
    }
  }
  if (!anySolved) {
    print(
        "-> IT DOES NOT SOLVE ANY CROSS ON ANY FACE! User's solution may be mistyped or user's cube is non-WCA.");
  }
}
