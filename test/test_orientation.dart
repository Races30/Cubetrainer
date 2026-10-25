import 'package:cubetrainer/services/cube_state.dart';

// Simulates scrambling with White on Bottom (z2 orientation).
// WCA notation U becomes D. D becomes U.
String invertScrambleZ2(String scramble) {
  return scramble.split(' ').map((move) {
    if (move.isEmpty) return move;
    if (move.startsWith('U')) return 'D' + move.substring(1);
    if (move.startsWith('D')) return 'U' + move.substring(1);
    if (move.startsWith('R'))
      return 'L' +
          move.substring(1); // Wait, z2 means R becomes L, L becomes R!
    if (move.startsWith('L')) return 'R' + move.substring(1);
    // F stays F, B stays B (Wait, z2: F becomes B, B becomes F!)
    // If White is on Top and Green is Front.
    // If user holds White on Bottom and Green Front: That is a x2 rotation.
    // x2 rotation (rotate around R/L axis):
    // U becomes D, D becomes U.
    // F becomes B, B becomes F.
    // R stays R, L stays L.
    // Let's assume user did x2.
    return move; // we will write a better function
  }).join(' ');
}

void main() {
  final rawScramble =
      "B2 D2 U2 F R B F L R2 D' U R' B2 U2 D2 L R' F' D2 B' L D2 B' R D2";
  print("Raw Scramble: \$rawScramble");

  // WCA Scrambling applies moves to a White-Top, Green-Front cube.
  // If the user held White-Bottom, Green-Front, they effectively applied a rotation `x2` to every move!
  // Wait, if White is bottom and Green is front...
  // Looking at front (Green), Top was White, now is Yellow.
  // Right was Red, is STILL Red. (Wait, White Top Green Front = Right is Red. White Bottom Green Front = Right is Red. Yes, rotating around the Z cross section (Front-Back axis). No, that's z2).
  // Standard: U=White, F=Green, R=Red, D=Yellow, B=Blue, L=Orange.
  // User holds: U=Yellow, F=Green, R=Red, D=White, B=Blue, L=Orange. -> This is an x2?
  // Wait, F=Green, R=Red, U=Yellow implies D=White. Yes, R is Red, L is Orange. F is Green, B is Blue.
  // This is a rotation around the X-axis by 180 degrees (x2 rotation)? No, x2 is (R) axis rotation.
  // If you rotate around X (R axis) 180 deg: F becomes B. U becomes D.
  // But user said "White on Bottom, Green on Front".
  // If F=Green and D=White, then U=Yellow (opposite white).
  // If F=Green and U=Yellow, then R must be Orange! (Standard is White Top Green Front Right Red).
  // Let's assume user just did the moves as written on a cube oriented White Bottom Green Front.

  // Let's see if the user's solution `L' D2 L2 D' R F` solves the cross if they scrambled it like that.
  final state = CubeState();
  // Instead of translating the scramble, let's translate the CUBE.
  // We can just redefine what isCrossSolved outputs.

  for (int face = 0; face < 6; face++) {
    print("Face \$face : \${state.stateList[face*9+4]}");
  }
}
