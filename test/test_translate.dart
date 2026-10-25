import 'package:flutter_test/flutter_test.dart';
import 'package:cubetrainer/services/cube_state.dart';

String translateZ2(String moves) {
  return moves.split(' ').map((m) {
    if (m.isEmpty) return "";
    String base = m[0];
    String rest = m.substring(1);
    if (base == 'U') return 'D' + rest;
    if (base == 'D') return 'U' + rest;
    if (base == 'R') return 'L' + rest;
    if (base == 'L') return 'R' + rest;
    return m;
  }).join(' ');
}

String translateX2(String moves) {
  return moves.split(' ').map((m) {
    if (m.isEmpty) return "";
    String base = m[0];
    String rest = m.substring(1);
    if (base == 'U') return 'D' + rest;
    if (base == 'D') return 'U' + rest;
    if (base == 'F') return 'B' + rest;
    if (base == 'B') return 'F' + rest;
    return m;
  }).join(' ');
}

void main() {
  test('Analyze rotation string replacements', () {
    final scramble =
        "B F2 L2 R' F L U2 R2 D2 U2 F2 R L F2 U2 R2 L B' F' L2 U D B2 R2 F2";
    final algWCA = "U' D' R F' B'";

    final stateZ2 = CubeState();
    stateZ2.applyScramble(translateZ2(scramble));
    stateZ2.applyScramble(translateZ2(algWCA));
    print("With Z2 mapping, solves White on Bottom (Face 3)? " +
        stateZ2.isCrossSolved(targetFace: 3).toString());

    final stateX2 = CubeState();
    stateX2.applyScramble(translateX2(scramble));
    stateX2.applyScramble(translateX2(algWCA));
    print("With X2 mapping, solves White on Bottom (Face 3)? " +
        stateX2.isCrossSolved(targetFace: 3).toString());
  });
}
