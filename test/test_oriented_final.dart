import 'package:flutter_test/flutter_test.dart';
import 'package:cubetrainer/services/cube_state.dart';

void main() {
  test('Analyze User Orientation', () {
    String scramble =
        "B2 D2 U2 F R B F L R2 D' U R' B2 U2 D2 L R' F' D2 B' L D2 B' R D2";

    // User held White Bottom (D), Green Front (F).
    // WCA Scramble standard holds White Top (U), Green Front (F).
    // If you hold the cube z2 or basically rotate around X axis 180 (x2 rotation)?
    // U becomes D, D becomes U.
    // L becomes R, R becomes L (Wait, no, if F stays F, and White goes from Top to Bottom,
    // you are flipping the cube upside down. This is an x2 rotation? No, x2 is around the R axis, so F becomes B.
    // To keep F as Front and move U to D, you must rotate around the Z axis (Front/Back).
    // This is a z2 rotation!
    // z2: F is still F. B is still B. U becomes D, D becomes U. R becomes L, L becomes R.

    String translatedScramble = scramble.split(' ').map((m) {
      if (m.isEmpty) return "";
      String base = m[0];
      String mod = m.length > 1 ? m.substring(1) : "";

      if (base == 'U') return 'D' + mod;
      if (base == 'D') return 'U' + mod;
      if (base == 'R') return 'L' + mod; // Right side moves to Left side
      if (base == 'L') return 'R' + mod; // Left side moves to Right side
      return m; // F and B stay the same
    }).join(' ');

    print("Physical execution of scramble by user: \$translatedScramble");

    final state = CubeState();
    state.applyScramble(translatedScramble);

    // The user's solution was: "L' D2 L2 D' R F"
    // Since they held it inverted the whole time, those moves are ALSO physically inverted.
    String userSolution = "L' D2 L2 D' R F";
    String translatedSolution = userSolution.split(' ').map((m) {
      if (m.isEmpty) return "";
      String base = m[0];
      String mod = m.length > 1 ? m.substring(1) : "";
      if (base == 'U') return 'D' + mod;
      if (base == 'D') return 'U' + mod;
      if (base == 'R') return 'L' + mod;
      if (base == 'L') return 'R' + mod;
      return m;
    }).join(' ');

    print("Physical execution of solution by user: \$translatedSolution");
    state.applyScramble(translatedSolution);

    // Now, is the WHITE face (which was U = 0 before scrambling) solved?
    // Since White was on U = 0, we check targetFace 0
    bool solved = state.isCrossSolved(targetFace: 0);
    print("Does this solve the White Cross (Face 0)? \$solved");
  });
}
