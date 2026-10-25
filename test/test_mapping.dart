import 'package:flutter_test/flutter_test.dart';
import 'package:cubetrainer/services/cube_state.dart';

void main() {
  test('Strict Cross testing', () {
    final scramble =
        "B2 D2 U2 F R B F L R2 D' U R' B2 U2 D2 L R' F' D2 B' L D2 B' R D2";

    // First, let's verify standard correct solution
    final correctMoves = "L' D2 L2 D' R F";
    final state1 = CubeState();
    state1.applyScramble(scramble);
    state1.applyScramble(correctMoves);
    print("User correct solution evaluates to: " +
        state1.isCrossSolved().toString());

    // Second, solver's old "incorrect" solution
    final solverMoves = "D' L U' D2";
    final state2 = CubeState();
    state2.applyScramble(scramble);
    state2.applyScramble(solverMoves);
    print("Solver short solution evaluates to: " +
        state2.isCrossSolved().toString());

    print("State2 details:");
    final List<List<Map<String, int>>> facesParams = [
      // U (0) Center: 4
      [
        {'e': 1, 'adj': 46, 'cen': 49}, // B top
        {'e': 3, 'adj': 37, 'cen': 40}, // L top
        {'e': 5, 'adj': 10, 'cen': 13}, // R top
        {'e': 7, 'adj': 19, 'cen': 22}, // F top
      ],
      // R (1) Center: 13
      [
        {'e': 10, 'adj': 5, 'cen': 4}, // U right
        {'e': 12, 'adj': 23, 'cen': 22}, // F right
        {'e': 14, 'adj': 48, 'cen': 49}, // B left
        {'e': 16, 'adj': 32, 'cen': 31}, // D right
      ],
      // F (2) Center: 22
      [
        {'e': 19, 'adj': 7, 'cen': 4}, // U bottom
        {'e': 21, 'adj': 41, 'cen': 40}, // L right
        {'e': 23, 'adj': 12, 'cen': 13}, // R left
        {'e': 25, 'adj': 28, 'cen': 31}, // D top
      ],
      // D (3) Center: 31
      [
        {'e': 28, 'adj': 25, 'cen': 22}, // F bottom
        {'e': 30, 'adj': 43, 'cen': 40}, // L bottom
        {'e': 32, 'adj': 16, 'cen': 13}, // R bottom
        {'e': 34, 'adj': 52, 'cen': 49}, // B bottom
      ],
      // L (4) Center: 40
      [
        {'e': 37, 'adj': 3, 'cen': 4}, // U left
        {'e': 39, 'adj': 50, 'cen': 49}, // B right
        {'e': 41, 'adj': 21, 'cen': 22}, // F left
        {'e': 43, 'adj': 30, 'cen': 31}, // D left
      ],
      // B (5) Center: 49
      [
        {'e': 46, 'adj': 1, 'cen': 4}, // U top
        {'e': 48, 'adj': 14, 'cen': 13}, // R right
        {'e': 50, 'adj': 39, 'cen': 40}, // L left
        {'e': 52, 'adj': 34, 'cen': 31}, // D bottom
      ],
    ];

    for (int face = 0; face < 6; face++) {
      int center = face * 9 + 4;
      int color = state2.stateList[center];
      print("Face " + face.toString() + " center color: " + color.toString());

      bool solved = true;
      for (var params in facesParams[face]) {
        int edgeIdx = params['e']!;
        int adjIdx = params['adj']!;
        int adjCenterIdx = params['cen']!;

        if (state2.stateList[edgeIdx] != color) {
          solved = false;
          print("  Edge " +
              edgeIdx.toString() +
              " fails: color " +
              state2.stateList[edgeIdx].toString() +
              " != " +
              color.toString());
        }
        if (state2.stateList[adjIdx] != state2.stateList[adjCenterIdx]) {
          solved = false;
          print("  Adj " +
              adjIdx.toString() +
              " fails: " +
              state2.stateList[adjIdx].toString() +
              " != " +
              state2.stateList[adjCenterIdx].toString());
        }
      }
      print("  Solved? " + solved.toString());
    }
  });
}
