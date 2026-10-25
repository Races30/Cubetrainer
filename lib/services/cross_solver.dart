import 'package:flutter/foundation.dart';
import 'package:cubetrainer/services/cube_state.dart';

class CrossSolver {
  static const List<String> _allMoves = [
    'U',
    "U'",
    'U2',
    'D',
    "D'",
    'D2',
    'L',
    "L'",
    'L2',
    'R',
    "R'",
    'R2',
    'F',
    "F'",
    'F2',
    'B',
    "B'",
    'B2',
  ];

  static String _oppositeMove(String move) {
    if (move.endsWith('2')) return move;
    if (move.endsWith("'")) return move[0];
    return "$move'";
  }

  static bool _isRedundantOpposite(String lastFace, String face) {
    if (lastFace == 'D' && face == 'U') return true;
    if (lastFace == 'R' && face == 'L') return true;
    if (lastFace == 'B' && face == 'F') return true;
    return false;
  }

  static List<String>? _search(CubeState state, int depth, List<String> path,
      String lastFace, int targetFace) {
    if (depth == 0) {
      if (state.isCrossSolved(targetFace: targetFace)) {
        return List.from(path);
      }
      return null;
    }

    for (String move in _allMoves) {
      String face = move[0];
      if (face == lastFace) continue;
      if (_isRedundantOpposite(lastFace, face)) continue;

      state.applyMove(move);
      path.add(move);

      final result = _search(state, depth - 1, path, face, targetFace);
      if (result != null) {
        return result;
      }

      path.removeLast();
      state.applyMove(_oppositeMove(move));
    }

    return null;
  }

  static Future<List<String>?> solveCross(String scramble) async {
    return compute(_solveIsolate, scramble);
  }

  static List<String>? _solveIsolate(String scramble) {
    final state = CubeState();
    state.applyScramble(scramble);

    // Find which face has the white center (color 0)
    int whiteFace = 0;
    for (int i = 0; i < 6; i++) {
      if (state.stateList[i * 9 + 4] == 0) {
        whiteFace = i;
        break;
      }
    }

    // We now search for a resolved Cross on the white face
    for (int depth = 0; depth <= 8; depth++) {
      final solution = _search(state, depth, [], '', whiteFace);
      if (solution != null) {
        return solution;
      }
    }

    return null;
  }
}
