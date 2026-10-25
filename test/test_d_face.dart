import 'package:flutter_test/flutter_test.dart';
import 'package:cubetrainer/services/cube_state.dart';

void main() {
  test('D Face Strict Analysis', () {
    final scramble =
        "B2 D2 U2 F R B F L R2 D' U R' B2 U2 D2 L R' F' D2 B' L D2 B' R D2";
    final correctMoves = "L' D2 L2 D' R F";

    // User correct solution
    final state = CubeState();
    state.applyScramble(scramble);
    state.applyScramble(correctMoves);
    print("USER CORRECT SOLUTION:");

    int face = 3; // D Face
    int centerColor = state.stateList[face * 9 + 4]; // 31
    print("Face 3 (D) Center Color: " + centerColor.toString());

    // D (3) -> edges: 28(F), 30(L), 32(R), 34(B)
    final params = [
      {'e': 28, 'adj': 25, 'cen': 22}, // F bottom
      {'e': 30, 'adj': 43, 'cen': 40}, // L bottom
      {'e': 32, 'adj': 16, 'cen': 13}, // R bottom
      {'e': 34, 'adj': 52, 'cen': 49}, // B bottom
    ];

    bool solved = true;
    for (var p in params) {
      int e = p['e']!;
      int adj = p['adj']!;
      int cen = p['cen']!;

      int eColor = state.stateList[e];
      int adjColor = state.stateList[adj];
      int adjCenColor = state.stateList[cen];

      print("  Edge " +
          e.toString() +
          " (color " +
          eColor.toString() +
          "). Expect " +
          centerColor.toString());
      print("    Adj " +
          adj.toString() +
          " (color " +
          adjColor.toString() +
          "). Expect " +
          adjCenColor.toString() +
          " (Center " +
          cen.toString() +
          ")");

      if (eColor != centerColor) solved = false;
      if (adjColor != adjCenColor) solved = false;
    }

    print("  Overall Solved for Face 3: " + solved.toString());
    print(
        "  CubeState isCrossSolved says: " + state.isCrossSolved().toString());
  });
}
