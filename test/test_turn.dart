import 'package:cubetrainer/services/cube_state.dart';

void main() {
  // Let's test a simple known scramble that has a very obvious visual effect on the edges.
  // Specifically: R U R' U'
  final state = CubeState();
  for (int i = 0; i < 54; i++)
    state.stateList[i] = i ~/ 9; // Fill with face colors 0-5

  // What does R do to U?
  print("Initial U Right Edge (Index 5): \${state.stateList[5]}");
  print("Initial F Right Edge (Index 23): \${state.stateList[23]}");
  print("Initial D Right Edge (Index 32): \${state.stateList[32]}");
  print("Initial B Left Edge (Index 48): \${state.stateList[48]}");

  state.applyMove("R");
  print("--- After R ---");
  print("U Right Edge (Index 5): \${state.stateList[5]} (Expected 2/F)");
  print("B Left Edge (Index 48): \${state.stateList[48]} (Expected 0/U)");
  print("D Right Edge (Index 32): \${state.stateList[32]} (Expected 5/B)");
  print("F Right Edge (Index 23): \${state.stateList[23]} (Expected 3/D)");
}
