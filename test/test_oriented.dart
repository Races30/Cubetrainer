import 'package:cubetrainer/services/cube_state.dart';
import 'package:cubetrainer/services/cross_solver.dart';

// Scrambles the cube mapping `White` to `0` and `Green` to `2`.
// But the user scrambled with White on Bottom (3) and Green on Front (2).
// This means U was Yellow (5?), F was Green (2), D was White (0?), etc.
// Let's just create a cube state, THEN apply a Z2-like rotation so it maps to the user's hands, THEN apply the scramble!
void main() async {
  // If the user held WHITE ON BOTTOM (D) and GREEN IN FRONT (F), then:
  // U = Yellow
  // D = White
  // F = Green
  // B = Blue
  // R = Red (wait, standard: White top, Green front -> Right is Red. If White bottom, Green Front -> Right is ORANGE).
  // Yes, holding white down and green front makes the right face Orange.
  // L = Red

  // A WCA scramble is just a sequence of face turns. F always turns the front face.
  // The user turned the faces relative to *their* orientation.

  // So the user's `D` turns the White face. The user's `U` turns the Yellow face.
  // The user's `L` turns the Red face. The user's `R` turns the Orange face.

  // Let's apply those specific physical turns by translating the scramble!
  // Normal Cube: U=0, R=1, F=2, D=3, L=4, B=5.
  // User's Cube mapped to Normal:
  // Their U is our D.
  // Their D is our U.
  // Their F is our F.
  // Their B is our B.
  // Their R is our L.
  // Their L is our R.

  // This is a direct mapping of the moves they performed!
  String scramble =
      "B2 D2 U2 F R B F L R2 D' U R' B2 U2 D2 L R' F' D2 B' L D2 B' R D2";

  String translatedScramble = scramble.split(' ').map((m) {
    if (m.isEmpty) return "";
    String base = m[0];
    String mod = m.length > 1 ? m.substring(1) : "";

    if (base == 'U') return 'D' + mod;
    if (base == 'D') return 'U' + mod;
    if (base == 'R') return 'L' + mod;
    if (base == 'L') return 'R' + mod;
    if (base == 'F') return 'F' + mod; // stays F
    if (base == 'B') return 'B' + mod; // stays B

    return m;
  }).join(' ');

  print(
      "If user scrambled holding White Bottom / Green Front, they physically executed:");
  print(translatedScramble);

  // Let's check if the user's solution `L' D2 L2 D' R F` solves THIS cube's White Cross (which is on U face now!)
  final state = CubeState();
  state.applyScramble(translatedScramble);

  // Their solution also uses their orientation!
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

  state.applyScramble(translatedSolution);

  print(
      "Does translated user solution solve White cross (Face 0 because it's on top)?");
  print(state.isCrossSolved(targetFace: 0));

  // Now, what would my solver say for this translated physical cube?
  final solverState = CubeState();
  solverState.applyScramble(translatedScramble);

  // I need to search for a cross on Face 0 (White) instead of Face 3!
  // Since `solveCross` hardcodes `isCrossSolved(targetFace: 3)`, I'll manually search.
  print("I need to modify CrossSolver to let me pass targetFace.");
}
