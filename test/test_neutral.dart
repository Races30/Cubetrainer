import 'package:cubetrainer/services/cube_state.dart';

void main() {
  final scramble =
      "B2 D2 U2 F R B F L R2 D' U R' B2 U2 D2 L R' F' D2 B' L D2 B' R D2";
  final solverMoves = "D' L U' D2";

  final state = CubeState();
  state.applyScramble(scramble);
  state.applyScramble(solverMoves);

  print("Solver 4-move solution (D' L U' D2) cross evaluation:");
  bool anySolved = false;
  for (int face = 0; face < 6; face++) {
    if (state._isFaceCrossSolved(face)) {
      int centerColor = state.stateList[face * 9 + 4];
      print(
          "-> IT PERFECTLY SOLVES THE CROSS ON FACE \$face (Color \$centerColor)!!");
      anySolved = true;
    }
  }
  if (!anySolved) {
    print(
        "-> IT DOES NOT SOLVE ANY CROSS ON ANY FACE! MY isCrossSolved LOGIC IS BUGGED.");
  }
}

extension on CubeState {
  bool _isFaceCrossSolved(int face) {
    final facesParams = [
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
    int centerColor = stateList[face * 9 + 4];
    for (var params in facesParams[face]) {
      if (stateList[params['e']!] != centerColor) return false;
      if (stateList[params['adj']!] != stateList[params['cen']!]) return false;
    }
    return true;
  }
}
