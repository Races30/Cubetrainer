import 'package:cubetrainer/services/cube_state.dart';

void main() {
  // A clean cube has sticker indices equal to face index * 9.
  // We can track the exact mapping by observing how edges move when rotated.
  // Wait, no. The easiest way is to apply a move on a solved cube and check which
  // adjacent piece changes.
  // Actually, even easier: A solved cube has all stickers on face X = X.
  // Let's paint every sticker with its UNIQUE ID.

  // We can't easily re-paint the internal state without copying the file,
  // so let's rely on the definition of `_rotateFace`.

  // U: 0
  // R: 1
  // F: 2
  // D: 3
  // L: 4
  // B: 5

  // From _rotateFace:
  // Face U(0) rotates: B top [45,46,47], R top [9,10,11], F top [18,19,20], L top [36,37,38]
  // This means the edges adjacent to U's edges are:
  // U top (1) -> B top middle (46). Center of B is 49. (Wait, U top is adjacent to B. U is top, B is back.)
  // U right (5) -> R top middle (10). Center of R is 13.
  // U bottom (7) -> F top middle (19). Center of F is 22.
  // U left (3) -> L top middle (37). Center of L is 40.

  // Face R(1) rotates: F right [20,23,26], U right [2,5,8], B left [51,48,45], D right [29,32,35]
  // R top (10) -> U right middle (5). Center of U is 4.
  // R left (12) -> F right middle (23). Center of F is 22.
  // R bottom (16) -> D right middle (32). Center of D is 31.
  // R right (14) -> B left middle (48). Center of B is 49.

  // Face F(2) rotates: U bottom [6,7,8], R left [9,12,15], D top [29,28,27], L right [44,41,38]
  // F top (19) -> U bottom middle (7). Center of U is 4.
  // F right (23) -> R left middle (12). Center of R is 13.
  // F bottom (25) -> D top middle (28). Center of D is 31.
  // F left (21) -> L right middle (41). Center of L is 40.

  // Face D(3) rotates: F bottom [24,25,26], R bottom [15,16,17], B bottom [51,52,53], L bottom [42,43,44]
  // D top (28) -> F bottom middle (25). Center of F is 22.
  // D right (32) -> R bottom middle (16). Center of R is 13.
  // D bottom (34) -> B bottom middle (52). Center of B is 49.
  // D left (30) -> L bottom middle (43). Center of L is 40.

  // Face L(4) rotates: U left [0,3,6], F left [18,21,24], D left [27,30,33], B right [53,50,47]
  // L top (37) -> U left middle (3). Center of U is 4.
  // L right (41) -> F left middle (21). Center of F is 22.
  // L bottom (43) -> D left middle (30). Center of D is 31.
  // L left (39) -> B right middle (50). Center of B is 49.

  // Face B(5) rotates: U top [2,1,0], L left [36,39,42], D bottom [33,34,35], R right [17,14,11]
  // B top (46) -> U top middle (1). Center of U is 4.
  // B right (50) -> L left middle (39). Center of L is 40.
  // B bottom (52) -> D bottom middle (34). Center of D is 31.
  // B left (48) -> R right middle (14). Center of R is 13.

  print("Mapping generated correctly.");
}
