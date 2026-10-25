import 'package:test/test.dart';
import 'package:cubetrainer/services/scramble_generator.dart';

void main() {
  group('ScrambleGenerator Normalization', () {
    test('Should normalize redundant notations based on modulo 4 turns', () {
      // R2' is 2 + 3 = 5 turns = 1 turn (R)
      expect(ScrambleGenerator.normalizeMove("R2'"), equals("R"));
      // R'' is 3 + 3 = 6 turns = 2 turns (R2)
      expect(ScrambleGenerator.normalizeMove("R''"), equals("R2"));
      // U'2 is 3 + 2 = 5 turns = 1 turn (U)
      expect(ScrambleGenerator.normalizeMove("U'2"), equals("U"));
    });
  });

  group('ScrambleGenerator Logic', () {
    test('Should not have same-face repetitions in last 2 moves (Strictness 1)',
        () {
      for (int i = 0; i < 100; i++) {
        final scramble =
            ScrambleGenerator.generate3x3(length: 30, seed: i, strictness: 1);
        final moves = scramble.split(RegExp(r'\s+'));

        for (int j = 2; j < moves.length; j++) {
          if (moves[j].isEmpty) continue;
          final m1 = ScrambleGenerator.baseFace(moves[j]);

          // Find previous non-empty moves
          int prev1Idx = j - 1;
          while (prev1Idx >= 0 && moves[prev1Idx].isEmpty) {
            prev1Idx--;
          }

          int prev2Idx = prev1Idx - 1;
          while (prev2Idx >= 0 && moves[prev2Idx].isEmpty) {
            prev2Idx--;
          }

          if (prev1Idx >= 0) {
            final m2 = ScrambleGenerator.baseFace(moves[prev1Idx]);
            expect(m1, isNot(equals(m2)),
                reason:
                    "Consecutive same face at index $j in seed $i: $scramble");
          }

          if (prev2Idx >= 0) {
            final m3 = ScrambleGenerator.baseFace(moves[prev2Idx]);
            expect(m1, isNot(equals(m3)),
                reason:
                    "Repetition in last 2 moves at index $j in seed $i: $scramble");
          }
        }
      }
    });

    test('Seed should be deterministic', () {
      final s1 = ScrambleGenerator.generate3x3(seed: 12345);
      final s2 = ScrambleGenerator.generate3x3(seed: 12345);
      final s3 = ScrambleGenerator.generate3x3(seed: 54321);

      expect(s1, equals(s2));
      expect(s1, isNot(equals(s3)));
    });

    test('NxN Wide moves should be tracked as base faces', () {
      final scramble =
          ScrambleGenerator.generateNxN(4, length: 50, seed: 42, strictness: 1);
      final moves = scramble.split(RegExp(r'\s+'));

      for (int j = 2; j < moves.length; j++) {
        if (moves[j].isEmpty) continue;
        final m1 = ScrambleGenerator.baseFace(moves[j]);

        int prev2Idx = j - 2;
        while (prev2Idx >= 0 && moves[prev2Idx].isEmpty) {
          prev2Idx--;
        }

        if (prev2Idx >= 0) {
          final m3 = ScrambleGenerator.baseFace(moves[prev2Idx]);
          expect(m1, isNot(equals(m3)),
              reason: "Repetition with wide moves at index $j: $scramble");
        }
      }
    });
  });
}
