import 'package:cubetrainer/services/cube_state.dart';

void main() {
  // Let's print out the completed cube to see what colors actually belong where.
  final state = CubeState();

  final scramble =
      "B2 D2 U2 F R B F L R2 D' U R' B2 U2 D2 L R' F' D2 B' L D2 B' R D2";
  state.applyScramble(scramble);

  print(
      "SCRAMBLED STATE FACE COLORS (Centers should be U=0, R=1, F=2, D=3, L=4, B=5):");

  for (int face = 0; face < 6; face++) {
    int center = face * 9 + 4;
    print("FACE \$face (Center Color: \${state.stateList[center]})");

    // Top, Left, Right, Bottom edges on this face itself
    int eTop = face * 9 + 1;
    int eLeft = face * 9 + 3;
    int eRight = face * 9 + 5;
    int eBottom = face * 9 + 7;

    print(
        "  Local Edges: Top(\$eTop)=\${state.stateList[eTop]}, Left(\$eLeft)=\${state.stateList[eLeft]}, Right(\$eRight)=\${state.stateList[eRight]}, Bottom(\$eBottom)=\${state.stateList[eBottom]}");
  }

  // After this check, let's see why the user's manual solution doesn't work.
  final correctMoves = "L' D2 L2 D' R F";
  final state2 = state.clone();
  state2.applyScramble(correctMoves);
  print("\\nAFTER USER SOLUTION (L' D2 L2 D' R F) ON FACE 3 (WHITE):");
  int face = 3;
  int eTop = face * 9 + 1;
  int eLeft = face * 9 + 3;
  int eRight = face * 9 + 5;
  int eBottom = face * 9 + 7;
  print(
      "  Face 3 Edges: Top=\${state2.stateList[eTop]}, Left=\${state2.stateList[eLeft]}, Right=\${state2.stateList[eRight]}, Bottom=\${state2.stateList[eBottom]}");
  // Also check D face adjacencies
  final params = [
    {'e': 28, 'adj': 25, 'cen': 22}, // D top -> F bottom-mid
    {'e': 30, 'adj': 43, 'cen': 40}, // D left -> L bottom-mid
    {'e': 32, 'adj': 16, 'cen': 13}, // D right -> R bottom-mid
    {'e': 34, 'adj': 52, 'cen': 49}, // D bottom -> B bottom-mid
  ];
  for (var p in params) {
    int e = p['e']!;
    int adj = p['adj']!;
    int cen = p['cen']!;
    print(
        "  Edge \$e (\${state2.stateList[e]}). Adj \$adj (\${state2.stateList[adj]}). Center \$cen (\${state2.stateList[cen]})");
  }
}
