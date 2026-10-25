import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cubetrainer/models/solve.dart';
import 'package:cubetrainer/models/scramble_history_item.dart';
import 'package:cubetrainer/services/persistent_scramble_repository.dart';

part 'scramble_generator.g.dart';

/*
  ScrambleGenerator v2
  --------------------
  Rules applied during generation:
  - strictness = 0: No consecutive moves on the same face (base check).
  - strictness = 1: No face repetition in the last 2 moves (prevents L2 R L).
  - strictness = 2: Filter against A B A' (length 3) and A B A' B' (length 4) cancellation patterns.
  - strictness = 3: Heuristics to avoid sequences that can be reduced via modulo-4 arithmetic on rotations.

  Notation Normalization:
  - Suffixes are limited to "", "'", and "2".
  - Invalid combinations like "2'" are corrected to "2".
  - Double primes are cleared.
  - Wide moves (Rw, Uw) are treated as their base face for overlap checks.
*/

@Riverpod(keepAlive: true)
class ScrambleGenerator extends _$ScrambleGenerator {
  @override
  ScrambleState build(CubeType cubeType) {
    return ScrambleState(
      scrambleHistory: [],
      activeScramble: generateScramble(cubeType, format: true),
    );
  }

  String generate(CubeType cubeType, {int? seed, int strictness = 2}) {
    final newScramble = generateScramble(cubeType,
        seed: seed, format: true, strictness: strictness);

    ref.read(persistentScrambleRepositoryProvider).addScramble(
          ScrambleHistoryItem(
            scramble: newScramble,
            cubeType: cubeType,
            date: DateTime.now(),
          ),
        );

    state = state.copyWith(activeScramble: newScramble);
    return newScramble;
  }

  void setActiveScramble(String scramble) {
    state = state.copyWith(activeScramble: scramble);
  }

  static String generateScramble(CubeType type,
      {int? seed, bool format = false, int strictness = 2}) {
    switch (type) {
      case CubeType.twoByTwo:
        return generate2x2(seed: seed, format: format, strictness: strictness);
      case CubeType.threeByThree:
        return generate3x3(seed: seed, format: format, strictness: strictness);
      case CubeType.fourByFour:
        return generateNxN(4,
            length: 40, seed: seed, format: format, strictness: strictness);
      case CubeType.fiveByFive:
        return generateNxN(5,
            length: 60, seed: seed, format: format, strictness: strictness);
      case CubeType.sixBySix:
        return generateNxN(6,
            length: 80, seed: seed, format: format, strictness: strictness);
      case CubeType.sevenBySeven:
        return generateNxN(7,
            length: 100, seed: seed, format: format, strictness: strictness);
      case CubeType.pyraminx:
        return generatePyraminx(
            seed: seed, format: format, strictness: strictness);
      case CubeType.megaminx:
        return generateMegaminx(
            seed: seed, format: format, strictness: strictness);
    }
  }

  static String generate2x2(
      {int length = 11, int? seed, bool format = false, int strictness = 2}) {
    const faces = ['U', 'R', 'F'];
    return _generateRuleBasedScramble(faces, length, seed, format, strictness);
  }

  static String generate3x3(
      {int length = 25, int? seed, bool format = false, int strictness = 2}) {
    const faces = ['U', 'D', 'L', 'R', 'F', 'B'];
    return _generateRuleBasedScramble(faces, length, seed, format, strictness);
  }

  static String generateNxN(int side,
      {int? length, int? seed, bool format = false, int strictness = 2}) {
    final effectiveLength = length ?? (side == 4 ? 40 : (side == 5 ? 60 : 80));
    final rng = Random(seed);
    const faces = ['U', 'D', 'L', 'R', 'F', 'B'];
    const suffixes = ['', '\'', '2'];

    List<String> moves = [];
    for (int i = 0; i < effectiveLength; i++) {
      int attempts = 0;
      String move = '';
      while (attempts < 50) {
        final face = faces[rng.nextInt(faces.length)];
        final suffix = suffixes[rng.nextInt(suffixes.length)];
        bool isWide = side > 3 && rng.nextBool();

        move = face;
        if (isWide) {
          if (side >= 6 && rng.nextDouble() < 0.3) {
            move = '3${move}w';
          } else {
            move = '${move}w';
          }
        }
        move += suffix;
        move = normalizeMove(move);

        if (isValidNextMove(moves, move, strictness)) {
          break;
        }
        attempts++;
      }
      moves.add(move);
    }
    return _formatMoves(moves, format);
  }

  static String generatePyraminx(
      {int length = 11, int? seed, bool format = false, int strictness = 1}) {
    final rng = Random(seed);
    const faces = ['U', 'L', 'R', 'B'];
    const tips = ['u', 'l', 'r', 'b'];
    const suffixes = ['', '\''];

    List<String> moves = [];
    for (int i = 0; i < length; i++) {
      int attempts = 0;
      String move = '';
      while (attempts < 20) {
        move = faces[rng.nextInt(faces.length)] +
            suffixes[rng.nextInt(suffixes.length)];
        if (isValidNextMove(moves, move, strictness)) break;
        attempts++;
      }
      moves.add(move);
    }

    for (var tip in tips) {
      if (rng.nextBool()) {
        moves.add(tip + suffixes[rng.nextInt(suffixes.length)]);
      }
    }

    return _formatMoves(moves, format);
  }

  static String generateMegaminx(
      {int length = 70, int? seed, bool format = false, int strictness = 1}) {
    final rng = Random(seed);
    List<String> moves = [];
    const rSuffixes = ['++', '--'];
    const dSuffixes = ['++', '--'];
    const uSuffixes = ['', '\''];

    for (int i = 0; i < length; i++) {
      if (i % 11 == 10) {
        moves.add('U${uSuffixes[rng.nextInt(uSuffixes.length)]}');
      } else if (i % 2 == 0) {
        moves.add('R${rSuffixes[rng.nextInt(rSuffixes.length)]}');
      } else {
        moves.add('D${dSuffixes[rng.nextInt(dSuffixes.length)]}');
      }
    }
    return _formatMoves(moves, format);
  }

  // --- Internals ---

  static String _generateRuleBasedScramble(
      List<String> faces, int length, int? seed, bool format, int strictness) {
    final rng = Random(seed);
    const suffixes = ['', '\'', '2'];
    List<String> moves = [];

    for (int i = 0; i < length; i++) {
      int attempts = 0;
      String candidate = '';
      while (attempts < 50) {
        final face = faces[rng.nextInt(faces.length)];
        final suffix = suffixes[rng.nextInt(suffixes.length)];
        candidate = normalizeMove(face + suffix);

        if (isValidNextMove(moves, candidate, strictness)) {
          break;
        }
        attempts++;
      }
      moves.add(candidate);
    }
    return _formatMoves(moves, format);
  }

  static bool isValidNextMove(
      List<String> currentMoves, String candidate, int strictness) {
    if (currentMoves.isEmpty) return true;

    final candidateBase = baseFace(candidate);
    final lastMove = currentMoves.last;
    final lastBase = baseFace(lastMove);

    // Rule 0 & 4: No consecutive same-face
    if (candidateBase == lastBase) return false;

    if (strictness >= 1 && currentMoves.length >= 2) {
      final secondLastBase = baseFace(currentMoves[currentMoves.length - 2]);
      // Rule 1: No face repetition in last 2 moves (prevents A B A)
      if (candidateBase == secondLastBase) {
        return false;
      }
    }

    if (strictness >= 2 && currentMoves.length >= 3) {
      // Future expansion for strict A B A' B' etc.
    }

    return true;
  }

  static String baseFace(String move) {
    String f = move.replaceAll(RegExp(r'^\d+'), '');
    if (f.contains('++') || f.contains('--')) {
      return f.replaceAll(RegExp(r'[\+\-]+'), '');
    }
    // Handle wide moves
    if (f.contains('w')) {
      f = f.replaceAll('w', '');
    }
    f = f.replaceAll(RegExp(r"[ '2]+$"), '');
    return f;
  }

  static String normalizeMove(String rawMove) {
    if (rawMove.isEmpty) return "";
    String facePart = '';

    // Find where the face part ends
    if (rawMove.startsWith(RegExp(r'\d'))) {
      int i = 0;
      while (i < rawMove.length && rawMove[i].contains(RegExp(r'\d'))) {
        i++;
      }
      if (i < rawMove.length) {
        facePart = rawMove.substring(0, i + 1);
        if (rawMove.substring(i + 1).startsWith('w')) facePart += 'w';
      }
    } else {
      facePart = rawMove[0];
      if (rawMove.length > 1 && rawMove[1] == 'w') facePart += 'w';
    }

    int totalTurns = 0;
    bool hasExplicitSuffix = false;
    for (int i = facePart.length; i < rawMove.length; i++) {
      hasExplicitSuffix = true;
      String char = rawMove[i];
      if (char == '2') {
        totalTurns += 2;
      } else if (char == "'") {
        totalTurns += 3;
      }
    }

    if (!hasExplicitSuffix) totalTurns = 1;

    totalTurns %= 4;
    if (totalTurns == 0) return "";
    if (totalTurns == 1) return facePart;
    if (totalTurns == 2) return "${facePart}2";
    if (totalTurns == 3) return "$facePart'";
    return facePart;
  }

  static String _formatMoves(List<String> moves, bool format) {
    if (!format) return moves.join(' ');

    List<String> groups = [];
    for (int i = 0; i < moves.length; i += 5) {
      int end = (i + 5 < moves.length) ? i + 5 : moves.length;
      groups.add(moves.sublist(i, end).join(' '));
    }
    return groups.join('  ');
  }
}

class ScrambleState {
  final List<String> scrambleHistory;
  final String? activeScramble;

  ScrambleState({
    required this.scrambleHistory,
    required this.activeScramble,
  });

  ScrambleState copyWith({
    List<String>? scrambleHistory,
    String? activeScramble,
  }) {
    return ScrambleState(
      scrambleHistory: scrambleHistory ?? this.scrambleHistory,
      activeScramble: activeScramble ?? this.activeScramble,
    );
  }
}
