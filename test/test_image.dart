import 'package:cubetrainer/services/cube_state.dart';
import 'package:cubetrainer/services/cross_solver.dart';

void main() async {
  final scramble =
      "B F2 L2 R' F L U2 R2 D2 U2 F2 R L F2 U2 R2 L B' F' L2 U D B2 R2 F2";

  final state = CubeState();
  state.applyScramble(scramble);

  // WCA Standard: U=0(White), R=1(Red), F=2(Green), D=3(Yellow), L=4(Orange), B=5(Blue)
  print("SCRAMBLE: \$scramble");

  // Print White Face (Face 0)
  print("Face 0 (White Center):");
  int f0 = 0 * 9;
  print(
      "  \${state.stateList[f0]} | \${state.stateList[f0+1]} | \${state.stateList[f0+2]}");
  print(
      "  \${state.stateList[f0+3]} | \${state.stateList[f0+4]} | \${state.stateList[f0+5]}");
  print(
      "  \${state.stateList[f0+6]} | \${state.stateList[f0+7]} | \${state.stateList[f0+8]}");

  // Print Yellow Face (Face 3)
  print("Face 3 (Yellow Center):");
  int f3 = 3 * 9;
  print(
      "  \${state.stateList[f3]} | \${state.stateList[f3+1]} | \${state.stateList[f3+2]}");
  print(
      "  \${state.stateList[f3+3]} | \${state.stateList[f3+4]} | \${state.stateList[f3+5]}");
  print(
      "  \${state.stateList[f3+6]} | \${state.stateList[f3+7]} | \${state.stateList[f3+8]}");

  // Print what the algorithm solves
  final alg = "L2 F' R' F B' D'";
  final s2 = state.clone();
  s2.applyScramble(alg);
  print("\\nAfter Algorithm: \$alg");
  print("Is Face 0 (White) cross solved? \${s2.isCrossSolved(targetFace: 0)}");
  print("Is Face 1 (Red) cross solved? \${s2.isCrossSolved(targetFace: 1)}");
  print("Is Face 2 (Green) cross solved? \${s2.isCrossSolved(targetFace: 2)}");
  print("Is Face 3 (Yellow) cross solved? \${s2.isCrossSolved(targetFace: 3)}");
  print("Is Face 4 (Orange) cross solved? \${s2.isCrossSolved(targetFace: 4)}");
  print("Is Face 5 (Blue) cross solved? \${s2.isCrossSolved(targetFace: 5)}");

  for (int face = 0; face < 6; face++) {
    if (s2.isCrossSolved(targetFace: face)) {
      print(
          "=> SOLVES CROSS ON FACE \$face (Color \${s2.stateList[face*9+4]})");
    }
  }

  // Double check if algorithm finds white cross
  // We need to write a standalone solve that targets 0 (white) if the WCA standard says U=0 is White.
  // Wait, standard WCA representation:
  // Is White D or U?
  // WCA standard scramble orientation: White on Top, Green on Front.
  // This means U face (0) is White. F face (2) is Green.
  // Therefore D face (3) is Yellow.
  //
  // Wait, speedcubers build the WHITE cross on the BOTTOM (D face) during the solve.
  // So the solved state we are looking for is a White cross on the D face?
  // No! The White center is on the U face! The centers don't move.
  // If the White center is on the U face, you must build the White cross on the U face!
  // OR you must rotate the cube (x2) so White is on the D face, THEN build it.
  // But algorithms are given relative to the CURRENT centers.
  // If White is on U, then the White cross must be built on U.
  // If my `isCrossSolved` defaults to `targetFace: 3` (D face), it is building the YELLOW cross!
}
