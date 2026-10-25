# Training Scrambler Implementation Notes

This document outlines the technical implementation of the targeted training scrambles for the CubeTrainer application.

## Overview

The `TrainingScrambler` service provides specialized scrambles for different 3x3 stages:

- **Cross**: Ensures the cross is not accidentally solved.
- **F2L**: Standard scramble (future: easy cross).
- **OLL**: Generates cases where F2L is solved but OLL is not (using inverse algs).
- **PLL**: Generates cases where F2L+OLL are solved but PLL is not.

## Lightweight Cube State Engine

To validate generated scrambles without a heavy dependency like a Kociemba solver, we implemented a lightweight `CubeState` simulator in `lib/services/cube_state.dart`.

### Features

- **Representation**: 54-integer array representing facelet colors.
- **Moves**: Supports basic face rotations (U, R, F, D, L, B) and modifiers (', 2).
- **Validation**:
  - `isCrossSolved()`: Checks position and orientation of the 4 white (D-face) edges relative to their centers.

### Heuristics & Logic

#### Cross Scrambles

We generate random scrambles and simulate them using `CubeState`. If `isCrossSolved()` returns true (highly unlikely but possible), we discard and regenerate. This ensures the user always has a cross to solve.

#### OLL/PLL Scrambles

Instead of solving a scrambled cube (which requires a complex solver), we approach this by **reverse engineering**:

1.  Start with a Solved State.
2.  Reverse an OLL or PLL algorithm (Inverse + Reverse Order) to "setup" the case.
3.  Apply random AUF (Adjust U Face) before and after to add variety.

## Future Improvements

### Integrating a Full Solver

To generate "Easy Cross" scrambles (e.g., cross solvable in < 5 moves), we would need a proper search algorithm or a Kociemba solver (e.g., `kociemba` package or compiling C++ code via FFI).

If integrated:

1.  Generate random scramble.
2.  Solve for Cross.
3.  If solution length > desired_max, regenerate.

### Database Expansion

Currently, `TrainingScrambler` uses a hardcoded subset of algorithms. This should be moved to a JSON asset or database to cover all 57 OLL and 21 PLL cases.
