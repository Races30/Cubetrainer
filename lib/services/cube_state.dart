/// A lightweight 3x3 cube state simulator for validating scrambles.
///
/// Faces: U=0, R=1, F=2, D=3, L=4, B=5
/// Facelets: 0-8 (U), 9-17 (R), 18-26 (F), 27-35 (D), 36-44 (L), 45-53 (B)
///
/// Order on face:
/// 0 1 2
/// 3 4 5
/// 6 7 8
class CubeState {
  // Representation: Each integer is a color/face ID (0-5).
  late List<int> _state;

  CubeState() {
    reset();
  }

  void reset() {
    _state = List<int>.generate(54, (i) => i ~/ 9);
  }

  // Clone constructor
  CubeState._fromState(List<int> state) {
    _state = List.from(state);
  }

  // ONLY FOR TESTING
  List<int> get stateList => _state;

  CubeState clone() {
    return CubeState._fromState(_state);
  }

  void applyScramble(String scramble) {
    final moves = scramble.trim().split(RegExp(r'\s+'));
    for (var move in moves) {
      if (move.isEmpty) continue;
      applyMove(move);
    }
  }

  void applyMove(String move) {
    int face;
    int turns = 1;

    if (move.contains('2')) turns = 2;
    if (move.contains("'")) turns = 3; // 3 turns = 1 counter-clockwise

    final char = move[0];
    switch (char) {
      case 'U':
        face = 0;
        break;
      case 'R':
        face = 1;
        break;
      case 'F':
        face = 2;
        break;
      case 'D':
        face = 3;
        break;
      case 'L':
        face = 4;
        break;
      case 'B':
        face = 5;
        break;
      default:
        return; // Ignore unknown moves
    }

    for (int i = 0; i < turns; i++) {
      _rotateFace(face);
    }
  }

  bool isCrossSolved({int targetFace = 0}) {
    // Check if a cross is solved on ANY of the 6 faces.
    // Faces: U=0, R=1, F=2, D=3, L=4, B=5
    // Each face has 9 stickers. Center is at index 4 (relative to face).
    // Edges are at relative indices 1 (top), 3 (left), 5 (right), 7 (bottom).

    // Define adjacent sticker indices for each edge on each face:
    // This maps (face_index, edge_relative_index) to the adjacent sticker index on the neighboring face.
    // Also need the neighboring face center index to compare against.

    // It's easier to define the 4 edge pieces per face and their adjacent counterparts
    final facesParams = [
      // U (0) Center: 4
      [
        {'e': 1, 'adj': 46, 'cen': 49}, // U top -> B top-mid
        {'e': 3, 'adj': 37, 'cen': 40}, // U left -> L top-mid
        {'e': 5, 'adj': 10, 'cen': 13}, // U right -> R top-mid
        {'e': 7, 'adj': 19, 'cen': 22}, // U bottom -> F top-mid
      ],
      // R (1) Center: 13
      [
        {'e': 10, 'adj': 5, 'cen': 4}, // R top -> U right-mid
        {'e': 12, 'adj': 23, 'cen': 22}, // R left -> F right-mid
        {'e': 14, 'adj': 48, 'cen': 49}, // R right -> B left-mid
        {'e': 16, 'adj': 32, 'cen': 31}, // R bottom -> D right-mid
      ],
      // F (2) Center: 22
      [
        {'e': 19, 'adj': 7, 'cen': 4}, // F top -> U bottom-mid
        {'e': 21, 'adj': 41, 'cen': 40}, // F left -> L right-mid
        {'e': 23, 'adj': 12, 'cen': 13}, // F right -> R left-mid
        {'e': 25, 'adj': 28, 'cen': 31}, // F bottom -> D top-mid
      ],
      // D (3) Center: 31
      [
        {'e': 28, 'adj': 25, 'cen': 22}, // D top -> F bottom-mid
        {'e': 30, 'adj': 43, 'cen': 40}, // D left -> L bottom-mid
        {'e': 32, 'adj': 16, 'cen': 13}, // D right -> R bottom-mid
        {'e': 34, 'adj': 52, 'cen': 49}, // D bottom -> B bottom-mid
      ],
      // L (4) Center: 40
      [
        {'e': 37, 'adj': 3, 'cen': 4}, // L top -> U left-mid
        {'e': 39, 'adj': 50, 'cen': 49}, // L left -> B right-mid
        {'e': 41, 'adj': 21, 'cen': 22}, // L right -> F left-mid
        {'e': 43, 'adj': 30, 'cen': 31}, // L bottom -> D left-mid
      ],
      // B (5) Center: 49
      [
        {'e': 46, 'adj': 1, 'cen': 4}, // B top -> U top-mid
        {'e': 48, 'adj': 14, 'cen': 13}, // B left -> R right-mid
        {'e': 50, 'adj': 39, 'cen': 40}, // B right -> L left-mid
        {'e': 52, 'adj': 34, 'cen': 31}, // B bottom -> D bottom-mid
      ],
    ];

    int center = targetFace * 9 + 4;
    int color = _state[center];

    for (var params in facesParams[targetFace]) {
      // Just use absolute indices for edges mapped above
      int edgeIdx = params['e']!;
      int adjIdx = params['adj']!;
      int adjCenterIdx = params['cen']!;

      if (_state[edgeIdx] != color || _state[adjIdx] != _state[adjCenterIdx]) {
        return false;
      }
    }

    return true;
  }

  // Primitive face rotation
  void _rotateFace(int face) {
    final offset = face * 9;

    // Rotate face surface (sticker 0->2->8->6, 1->5->7->3)
    _cycle(offset + 0, offset + 2, offset + 8, offset + 6);
    _cycle(offset + 1, offset + 5, offset + 7, offset + 3);

    // Rotate adjacent layers
    switch (face) {
      case 0: // U -> B R F L (top row)
        _cycleLayer(
            [45, 46, 47], // B top
            [9, 10, 11], // R top
            [18, 19, 20], // F top
            [36, 37, 38] // L top
            );
        break;
      case 1: // R -> U B D F (right col)
        // careful with orientation and indices
        // U right: 2, 5, 8
        // B left (inverted): 51, 48, 45 ? No, R adjacent to B is B's LEFT col (due to wrap).
        // Standard definition:
        // U(2,5,8) -> B(45,48,51) (actually B's left side 0,3,6 mirrored? No, indices 45,48,51 is left col if 45 is top-left)
        // Let's standardise indices:
        // U: 0-8. R:9-17. F:18-26. D:27-35. L:36-44. B:45-53.
        // U right: 2,5,8
        // F right: 20,23,26
        // D right: 29,32,35
        // B left: 51,48,45 ( indices 6,3,0 on B face? B face indices 45..53. Left col is 45,48,51)

        // Cycle U->B->D->F->U ? No. R turn moves F->U.
        // F right -> U right
        // U right -> B left (inverted?)
        // B left -> D right
        // D right -> F right

        _cycleLayer(
            [20, 23, 26], // F right
            [2, 5, 8], // U right
            [51, 48, 45], // B left (reversed vertical)
            [29, 32, 35] // D right
            );
        break;
      case 2: // F -> U R D L
        // F top adjacent to U bottom (6,7,8)
        // F right adjacent to R left (9,12,15)
        // F bottom adjacent to D top (27,28,29)
        // F left adjacent to L right (38,41,44)

        // Clockwise F moves:
        // U bottom -> R left
        // R left -> D top (reversed?)
        // ...

        // Let's use standard cycle:
        // U(6,7,8) -> R(9,12,15)
        // R(9,12,15) -> D(29,28,27) (reversed)
        // D(29,28,27) -> L(44,41,38) (reversed)
        // L(44,41,38) -> U(6,7,8)

        // Wait, standard cycle A->B->C->D implies A content moves to B.
        // U bottom (6,7,8) moves to R left (9,12,15).
        // L right (38,41,44) moves to U bottom (6,7,8).
        // D top (27,28,29) moves to L right? No wait.

        // F turn:
        // U6,7,8 get L44,41,38 content.
        // R9,12,15 get U6,7,8 content.
        // D27,28,29 get R15,12,9 content?

        // Let's stick to: A->B->C->D. Content of D moves to C, C to B, B to A, A to D.
        // My _cycle function does: tmp=D, D=C, C=B, B=A, A=tmp. This moves A->B, B->C, C->D, D->A.
        // So I define the order of FLOW.

        // FLOW for F: U(6,7,8) -> R(9,12,15) -> D(29,28,27) -> L(44,41,38) -> U...

        _cycleLayer(
            [6, 7, 8], // U bottom
            [9, 12, 15], // R left
            [29, 28, 27], // D top (reversed)
            [44, 41, 38] // L right (reversed)
            );
        break;
      case 3: // D -> F R B L (bottom row)
        // Move F bottom -> R bottom -> B bottom -> L bottom
        _cycleLayer(
            [24, 25, 26], // F bottom
            [15, 16, 17], // R bottom
            [51, 52, 53], // B bottom
            [42, 43, 44] // L bottom
            );
        break;
      case 4: // L -> U F D B (left col)
        // U left (0,3,6) -> F left (18,21,24) -> D left (27,30,33) -> B right (53,50,47) -> U
        _cycleLayer(
            [0, 3, 6], // U left
            [18, 21, 24], // F left
            [27, 30, 33], // D left
            [53, 50, 47] // B right (reversed)
            );
        break;
      case 5: // B -> U L D R
        // U top (0,1,2) -> L left (36,39,42) (inverted order?)
        // Let's trace back. B is opposite F. Use F logic but opposite indices.

        // Flow: U(2,1,0) -> L(36,39,42) -> D(33,34,35) -> R(17,14,11) -> U...

        _cycleLayer(
            [2, 1, 0], // U top (reversed)
            [36, 39, 42], // L left
            [33, 34, 35], // D bottom
            [17, 14, 11] // R right (reversed)
            );
        break;
    }
  }

  void _cycle(int i1, int i2, int i3, int i4) {
    final tmp = _state[i4];
    _state[i4] = _state[i3];
    _state[i3] = _state[i2];
    _state[i2] = _state[i1];
    _state[i1] = tmp;
  }

  void _cycleLayer(List<int> s1, List<int> s2, List<int> s3, List<int> s4) {
    for (int i = 0; i < s1.length; i++) {
      _cycle(s1[i], s2[i], s3[i], s4[i]);
    }
  }
}
