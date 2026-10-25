import 'package:cubetrainer/services/cube_state.dart';

void main() {
  final state = CubeState();
  for (int i = 0; i < 54; i++) state.stateList[i] = i ~/ 9;

  print("Initial U Right Edge (Index 5): " + state.stateList[5].toString());
  print("Initial F Right Edge (Index 23): " + state.stateList[23].toString());
  print("Initial D Right Edge (Index 32): " + state.stateList[32].toString());
  print("Initial B Left Edge (Index 48): " + state.stateList[48].toString());

  state.applyMove("R");
  print("--- After R ---");
  print("U Right Edge (Index 5): " +
      state.stateList[5].toString() +
      " (Expected 2/F)");
  print("B Left Edge (Index 48): " +
      state.stateList[48].toString() +
      " (Expected 0/U)");
  print("D Right Edge (Index 32): " +
      state.stateList[32].toString() +
      " (Expected 5/B)");
  print("F Right Edge (Index 23): " +
      state.stateList[23].toString() +
      " (Expected 3/D)");
}
