# Aristotle proof job: finite-group unitarizability (unitary matrix model for every FDRep)

Standalone Mathlib-only Lean 4 target. Repo pinned toolchain:
leanprover/lean4:v4.28.0. Target file:
`YmGapUnitarizability/UnitaryModel.lean`. Run
`lake env lean YmGapUnitarizability/UnitaryModel.lean` first (fast,
Mathlib-only); do not attempt a full project build (this package
intentionally has no dependencies beyond Mathlib).

## Context (assume you are blind to the source repository)

The parent repository has a kernel-checked finite-group 2D lattice
Yang-Mills Wilson-loop area law and a vacuum-dominance bound
`|gamma| <= 1` (nonnegative string tension) that is currently CONDITIONAL
on an explicit hypothesis: the observable character admits a unitary matrix
model. This package's one theorem discharges that hypothesis
unconditionally. It is classical mathematics (Weyl's unitarian trick for
finite groups), absent from Mathlib in this packaged matrix form.

## What to do

1. Replace the single `s o r r y` (spelled normally in the file) in
   `fdRep_exists_unitary_matrix_model` with a proof. The target file's
   docstring contains a complete suggested proof route in pure matrix
   algebra: basis matrices via `LinearMap.toMatrix` + `Module.finBasis`,
   Weyl-averaged Gram `P = sum_g (M g)^H * (M g)` with the intertwining
   identity `(M h)^H * P * (M h) = P` (reindex `g -> g * h`), conjugation
   by `Q = CFC.sqrt P`, trace cyclicity. Alternative routes (invariant
   inner product + orthonormal basis) are acceptable if easier in
   practice.
2. Keep the statement EXACTLY as written: same existential shape, same
   literal unitarity equation `(rho g)^H * rho g = 1`, `Matrix.trace` in
   the conclusion, no added hypotheses (in particular NO `[Simple R]` -
   the theorem holds for every `FDRep`).
3. Helper lemmas are welcome in the same file, above the target, each with
   a docstring. Note `Matrix.PosDef` / `Matrix.PosSemidef` API and the
   `CFC.sqrt` square-root lemmas (`CFC.sqrt_mul_sqrt_self`,
   `CFC.sqrt_nonneg`, `CFC.isUnit_sqrt_iff`) exist in this Mathlib pin;
   the older `Matrix.PosSemidef.sqrt` names are deprecated aliases.
4. Sanity self-check before finishing: for the trivial one-dimensional
   representation, the theorem must produce `n` and `rho` with
   `Matrix.trace (rho g) = 1` for all `g` - e.g. `n = 1`, `rho = 1` works;
   your construction need not produce that literal witness but must not
   contradict it.

## Success criteria

- `lake env lean YmGapUnitarizability/UnitaryModel.lean` passes with zero
  `s o r r y` / `a d m i t` / new `a x i o m` and no
  `n a t i v e _ d e c i d e`.
- `#print axioms YmGapUnitarizability.fdRep_exists_unitary_matrix_model`
  reports at most `[propext, Classical.choice, Quot.sound]`.

## Output format

Return the completed `YmGapUnitarizability/UnitaryModel.lean`. If the
proof cannot be completed, return the file with a failure note at the
bottom of the module docstring: exact failing goal, what was tried,
suspected missing Mathlib lemma.
