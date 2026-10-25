# Scrambler Notes - CubeTrainer

## Algorithm Documentation

The `ScrambleGenerator` implements a **Random-Move** algorithm optimized for quality and variety, following standard WCA notations.

### Key Features

- **3x3 / 2x2**: Standard face rotation notation (`U D L R F B`) with prime (`'`) and double (`2`) suffixes.
- **NxN (4x4-7x7)**: Support for 2-layer and 3-layer wide moves (e.g., `Rw`, `3Uw`).
- **Pyraminx**: Standard notation with random insertion of small tips (`u l r b`).
- **Megaminx**: WCA standard `R++/R--` and `D++/D--` notation with terminal `U` moves.
- **Deterministic Seeding**: Optional `seed` parameter for reproducible scrambles.
- **Readability Grouping**: Grouping moves by 5 with double spaces for easier scanning.

### Technical Approach

- **Face Separation**: The algorithm strictly prevents consecutive moves on the same face (e.g., it will never generate `R R'` or `R R2`).
- **Orientation Control**: For 2x2, only 3 faces (`U`, `R`, `F`) are used to provide high-quality state scrambles without redundant cube rotations.
- **Complexity Guarantee**: Moves are picked uniformly from available actions to approximate random-state distributions.

### Limitations vs TNoodle

**TNoodle** (the official WCA scrambler) uses a **Random-State** algorithm. It calculates a random legal permutation and then finds an optimal (short) solution to reached that state.
Our **Random-Move** algorithm is:

1. Faster (instantaneous on mobile).
2. Excellent for training and daily practice.
3. Not recommended for official competitions as it may have slight statistical biases (though barely noticeable for human practice).

## Examples

| Puzzle   | Sample Scramble                                                                         |
| -------- | --------------------------------------------------------------------------------------- |
| 2x2      | `U F2 R U2 F  R' F' U' F2 R  U`                                                         |
| 3x3      | `R U' B2 D' F2  D' R L2 F' U  B2 R2 D' F L  B' U D L2 F  D2 R2 D' F2 L2`                |
| Megaminx | `R++ D-- R++ D++ R-- D++ R++ D++ R-- D-- U'  R-- D-- R++ D++ R++ D-- R-- D-- R++ D++ U` |

## How to Enable Extra Validation

Currently, basic validation is built-in. If you need stricter checks (e.g., ensure no trivial Cross/F2L skips), you can wrap the call in a loop that checks the scramble's "complexity" before returning.
