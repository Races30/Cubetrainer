import 'package:flutter_test/flutter_test.dart';
import 'package:cubetrainer/services/cube_state.dart';

void main() {
  test('Analyze visual cross', () {
    final scramble =
        "B F2 L2 R' F L U2 R2 D2 U2 F2 R L F2 U2 R2 L B' F' L2 U D B2 R2 F2";
    final state = CubeState();
    state.applyScramble(scramble);

    print("SCRAMBLE: \$scramble");

    int whiteFace = -1;
    for (int i = 0; i < 6; i++) {
      if (state.stateList[i * 9 + 4] == 0) {
        whiteFace = i;
        break;
      }
    }
    print("White Center is on Face: \$whiteFace");

    final alg = "L2 F' R' F B' D'";
    final s2 = state.clone();
    s2.applyScramble(alg);
    print("\\nAfter Algorithm: \$alg");

    for (int face = 0; face < 6; face++) {
      if (s2.isCrossSolved(targetFace: face)) {
        print(
            "=> SOLVES CROSS ON FACE \$face (Center Color: \${s2.stateList[face*9+4]})");
      }
    }
  });
}
