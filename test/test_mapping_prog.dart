import 'package:cubetrainer/services/cube_state.dart';

void main() {
  final state = CubeState();
  // We want to know exactly what index holds what Edge relative to a Center.
  // U(0), R(1), F(2), D(3), L(4), B(5)
  // Let's paint the cube so every sticker index = its own color/id
  for (int i = 0; i < 54; i++) {
    state.stateList[i] = i;
  }

  // Now if we do a single U move, we can see exactly which edges moved where.
  // This tells us exactly the adjacency!
  _printAdjacencies(state, "U", 0);
  _printAdjacencies(state, "R", 1);
  _printAdjacencies(state, "F", 2);
  _printAdjacencies(state, "D", 3);
  _printAdjacencies(state, "L", 4);
  _printAdjacencies(state, "B", 5);
}

void _printAdjacencies(CubeState original, String move, int face) {
  final state = CubeState();
  for (int i = 0; i < 54; i++) {
    state.stateList[i] = i;
  }

  state.applyMove(move);
  print("");
  print("=== FACE \$face (\${move}) ===");
  int faceCenter = face * 9 + 4;

  // We know the "edges" of this face are at face*9 + 1, 3, 5, 7.
  // Let's see which external pieces MOVED onto this face!
  // Oh wait! If we rotate Face X, its adjacent edges move ALONG WITH the face's edges.
  // For example, if I rotate U, the U edges move, and the adjacent B/R/F/L edges move.
  // We just need to pair them up.
  // The U edges are at indices: T=1, L=3, R=5, B=7
  // Let's track where the original T(1) piece went. It went to index X. The adjacent B piece that went with it must be adjacent to X!

  int topE = face * 9 + 1;
  int leftE = face * 9 + 3;
  int rightE = face * 9 + 5;
  int bottomE = face * 9 + 7;

  for (int i = 0; i < 54; i++) {
    if (i >= face * 9 && i < face * 9 + 9) continue; // skip the face itself
    // Did this sticker move?
    if (state.stateList[i] != i) {
      // It's an adjacent piece that revolves around face!
      print("  Sticker \$i changed to \${state.stateList[i]}");
    }
  }
}
