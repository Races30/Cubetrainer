# Scramble Generator Fix Notes

## Improvements Implemented

### 1. Advanced Overlap Rules

I have implemented a `strictness` parameter that controls how aggressively the generator filters candidates:

- **Level 1 (Default for UI)**: Prevents the same face from appearing again within the last 2 moves. This solves the reported `L2 ... L` issue where a face would "flicker" back too soon.
- **Level 2**: Includes Level 1 and adds infrastructure for anti-cancellation (A B A').
- **Wide Move Awareness**: Moves like `Rw` or `3Rw` are now correctly mapped to their base face `R` during overlap checks.

### 2. Notation Normalization

The function `_normalizeMove` ensures that:

- Suffixes are restricted to `""`, `'`, and `2`.
- Redundant or invalid sequences like `R2'` are automatically simplified to `R2`.
- Accidental double primes `''` are removed or simplified.

### 3. Determinism and Seeding

All generation functions now accept a `seed`. Providing the same seed will always produce the exact same scramble string, which is essential for consistent behavior and debugging.

### 4. Performance

The generator uses a simple rejection-sampling approach. For 3x3 and NxN, it tries up to 50 candidates per slot. This is extremely fast (well under 1ms for a standard scramble) while still allowing the strict rules to be satisfied.

## Limitations

- This is a **Random Move** generator, not a **Random State** generator (like TNoodle). While it produces high-quality sequences that look "professional", it doesn't guarantee a uniform distribution over the entire state space of the puzzle.
- For Megaminx and Pyraminx, strictness is defaulted to 1 because their move sets are more constrained, and higher strictness can lead to excessive rejections in random-move generation.
