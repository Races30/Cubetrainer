import 'package:cubetrainer/services/cube_state.dart';

void main() {
  final state = CubeState();

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
  print("=== FACE " + face.toString() + " (" + move + ") ===");

  for (int i = 0; i < 54; i++) {
    if (i >= face * 9 && i < face * 9 + 9) continue;
    if (state.stateList[i] != i) {
      print("  Sticker " +
          i.toString() +
          " changed to receive piece from " +
          state.stateList[i].toString());
    }
  }
}
