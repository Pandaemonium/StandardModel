# Summary of changes for run 3a6f3266-e377-40e6-95c6-83c3901007e0
Delivered `RequestProject/Main.lean` (namespace `MinkowskiConvention`) plus `ARISTOTLE_SUMMARY.md`, a clean-room port of the PhysLean `minkowskiMatrix` convention (mostly-minus `(+,-,-,-)`) grounded directly on the Mathlib declaration `LieAlgebra.Orthogonal.indefiniteDiagonal` — no PhysLean import.

Provenance line (in the summary and file docstring): clean-room port of the PhysLean `minkowskiMatrix` convention (Physlib/.../Lorentz, Tooby-Smith) built on Mathlib `indefiniteDiagonal`, convention (+,-,-,-).

Contents, all proved kernel-checked with no sorry/admit/native_decide/new axioms (each headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms ...`, footprint within [propext, Classical.choice, Quot.sound]):
- `eta : Matrix (Fin 4) (Fin 4) R := !![1,0,0,0; 0,-1,0,0; 0,0,-1,0; 0,0,0,-1]` over a generic `CommRing R`.
- `eta_eq_indefiniteDiagonal`: `eta` equals the reindexing of `LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin 3) R` under the standard `Fin 1 ⊕ Fin 3 ≃ Fin 4` equiv (`finSumFinEquiv`) — the full convention check, not just the fallback.
- Supporting matrix facts: `eta_diagonal`, `eta_symm`, `eta_mul_eta` (involutive), `eta_det = -1`, `eta_trace = -2`, and `eta_diag_match` (diagonal-entry match with `indefiniteDiagonal`).
- `mink u v := u ⬝ᵥ (eta.mulVec v)` with `mink_self` (signature `u₀²−u₁²−u₂²−u₃²`) and full bilinearity (`mink_add_left/right`, `mink_smul_left/right`).
- `null_iff`: `mink u u = 0 ↔ u₀² = u₁²+u₂²+u₃²`.
- Mandatory non-degeneracy witnesses over ℚ, in-theorem: `mink_null_witness` ((1,1,0,0) → 0) and `mink_timelike_witness` ((5,3,0,0) → 16).
- `convention_note`: `eta 0 0 = 1 ∧ eta 1 1 = -1`.

`lean_build` on `RequestProject.Main` completes successfully with no warnings; grep confirms no sorry/admit/native_decide/axiom. All changes committed and pushed.

# Minkowski convention grounded in Mathlib's `indefiniteDiagonal`

**Provenance:** clean-room port of the PhysLean `minkowskiMatrix` convention
(`Physlib`/`.../Lorentz`, Tooby-Smith), built directly on the Mathlib declaration
`LieAlgebra.Orthogonal.indefiniteDiagonal`, mostly-minus convention `(+,-,-,-)`.
No PhysLean is imported: `indefiniteDiagonal` is a Mathlib declaration, so our
hand-rolled `eta = diag(1,-1,-1,-1)` is grounded against it directly.

## Deliverable

`RequestProject/Main.lean`, namespace `MinkowskiConvention`. All results are proved
kernel-checked with no `sorry`/`admit`/`native_decide`/new axioms. Each headline theorem
carries an in-file `#guard_msgs (whitespace := lax) in #print axioms ...` confirming the
axiom footprint (subset of `[propext, Classical.choice, Quot.sound]`).

## Contents

- `eta` : `Matrix (Fin 4) (Fin 4) R := !![1,0,0,0; 0,-1,0,0; 0,0,-1,0; 0,0,0,-1]`
  over a generic `CommRing R`.
- `eta_eq_indefiniteDiagonal` : `eta` equals the reindexing of
  `LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin 3) R` under the standard
  `Fin 1 ⊕ Fin 3 ≃ Fin 4` equivalence (`finSumFinEquiv`) — i.e. our `eta` IS the
  Mathlib/PhysLean Minkowski matrix, convention-checked.
- `eta_diagonal`, `eta_symm`, `eta_mul_eta` (`eta * eta = 1`), `eta_det` (`= -1`),
  `eta_trace` (`= -2`), and `eta_diag_match` (diagonal-entry match with
  `indefiniteDiagonal`).
- `mink u v := u ⬝ᵥ (eta.mulVec v)` (the Minkowski inner product), with
  `mink_self` (`= u₀² - u₁² - u₂² - u₃²`) and full bilinearity
  (`mink_add_left`, `mink_add_right`, `mink_smul_left`, `mink_smul_right`).
- `null_iff` : `mink u u = 0 ↔ u₀² = u₁² + u₂² + u₃²` (the null-cone condition).
- Non-degeneracy witnesses over `ℚ`: `mink_null_witness` (`(1,1,0,0)`, value `0`)
  and `mink_timelike_witness` (`(5,3,0,0)`, value `16`).
- `convention_note` : provenance anchor `eta 0 0 = 1 ∧ eta 1 1 = -1`, recording the
  mostly-minus `(+,-,-,-)` convention shared with PhysLean `minkowskiMatrix` and
  Mathlib `indefiniteDiagonal`.
