import 'package:cubetrainer/services/cube_state.dart';

void main() {
  final scramble =
      "B F2 L2 R' F L U2 R2 D2 U2 F2 R L F2 U2 R2 L B' F' L2 U D B2 R2 F2";
  final state = CubeState();
  state.applyScramble(scramble);

  print("SCRAMBLE: " + scramble);

  int whiteFace = -1;
  for (int i = 0; i < 6; i++) {
    if (state.stateList[i * 9 + 4] == 0) {
      whiteFace = i;
      break;
    }
  }
  print("White Center is on Face: " + whiteFace.toString());

  int f0 = 0 * 9;
  print("Face 0:");
  print("  " +
      state.stateList[f0].toString() +
      " | " +
      state.stateList[f0 + 1].toString() +
      " | " +
      state.stateList[f0 + 2].toString());
  print("  " +
      state.stateList[f0 + 3].toString() +
      " | " +
      state.stateList[f0 + 4].toString() +
      " | " +
      state.stateList[f0 + 5].toString());
  print("  " +
      state.stateList[f0 + 6].toString() +
      " | " +
      state.stateList[f0 + 7].toString() +
      " | " +
      state.stateList[f0 + 8].toString());

  final alg = "L2 F' R' F B' D'";
  final s2 = state.clone();
  s2.applyScramble(alg);
  print("");
  print("After Algorithm: " + alg);

  for (int face = 0; face < 6; face++) {
    if (s2.isCrossSolved(targetFace: face)) {
      print("=> SOLVES CROSS ON FACE " +
          face.toString() +
          " (Center Color: " +
          s2.stateList[face * 9 + 4].toString() +
          ")");
    }
  }
}
