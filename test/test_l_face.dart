import 'package:flutter_test/flutter_test.dart';
import 'package:cubetrainer/services/cube_state.dart';

void main() {
  test('L Face Strict Analysis', () {
    final scramble =
        "B2 D2 U2 F R B F L R2 D' U R' B2 U2 D2 L R' F' D2 B' L D2 B' R D2";
    final correctMoves = "L' D2 L2 D' R F";
    final badSolverMoves = "D' L U' D2";

    // User correct solution
    final cState = CubeState();
    cState.applyScramble(scramble);
    cState.applyScramble(correctMoves);
    print("USER CORRECT SOLUTION:");
    _printFace4(cState);

    print("---------------------------------");

    // Solver bad solution
    final sState = CubeState();
    sState.applyScramble(scramble);
    sState.applyScramble(badSolverMoves);
    print("SOLVER BAD SOLUTION:");
    _printFace4(sState);
  });
}

void _printFace4(CubeState state) {
  int face = 4; // L Face
  int centerColor = state.stateList[face * 9 + 4]; // 40
  print("Face 4 (L) Center Color: \$centerColor");

  // L (4) -> edges: 37(U), 39(B), 41(F), 43(D)
  final params = [
    {'e': 37, 'adj': 3, 'cen': 4}, // U left
    {'e': 39, 'adj': 50, 'cen': 49}, // B right
    {'e': 41, 'adj': 21, 'cen': 22}, // F left
    {'e': 43, 'adj': 30, 'cen': 31}, // D left
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

  print("  Overall Solved for Face 4: " + solved.toString());
  print("  CubeState says: " + state.isCrossSolved().toString());
}
