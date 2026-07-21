# Task: exponentiated U(1)_Y phases on 5* (+) Lambda^2(5) (item-3 group slice)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge SM-derivation lane.
Self-contained three-file package: the PROVEN Cartan-level
`SU5HyperchargeUnification`, the PROVEN Lie-level
`SU5RepresentationAction` (landed tonight), and the target.

## Target

`PhysicsSM/Draft/NullEdge/SU5GroupAction.lean` - three theorems ending in
a hole:

1. `exp_YGen_diagonal` - `NormedSpace.exp` of a diagonal matrix is the
   diagonal of exponentials (Mathlib has the diagonal-exp lemma family:
   `Matrix.exp_diagonal` or derive via the power series on diagonals).
2. `exp_dual_phase` - apply 1 (transposed/negated diagonal is still
   diagonal) + diagonal `mulVec` on `Pi.single`; the phase is
   `exp (t * Y5bar i)` with `Y5bar = -Y5` absorbing the dual minus sign.
3. `exp_lambda2_phase` - two-sided diagonal conjugation of
   `wedgeBasis i j = single i j 1 - single j i 1`: entrywise the left
   factor contributes `exp (t Y5 i)`, the right transpose factor
   `exp (t Y5 j)`, giving the `Y10 i j = Y5 i + Y5 j` phase via
   `Complex.exp_add`.

## Pre-registered honesty license

If the natural dual transport differs (sign placement on the transpose),
fix the convention ONCE consistently with the landed Lie-level `dualAct`,
record it prominently, and keep the phase payloads exact.

## Constraints

- Do not modify included modules. No new axioms/escapes; standard axioms
  only ([propext, Classical.choice, Quot.sound]).
- Verify with `lake env lean PhysicsSM/Draft/NullEdge/SU5GroupAction.lean`.

## Success criteria

All three theorems (or honestly convention-corrected versions) proven,
zero holes, completion report with axioms used.
