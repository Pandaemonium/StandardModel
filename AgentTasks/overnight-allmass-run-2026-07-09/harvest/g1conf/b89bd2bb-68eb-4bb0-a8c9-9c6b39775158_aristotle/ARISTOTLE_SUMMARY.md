# Summary of changes for run b89bd2bb-68eb-4bb0-a8c9-9c6b39775158
Delivered `RequestProject/Main.lean` (namespace `Goal1Confinement`) and `ARISTOTLE_SUMMARY.md`, fully self-contained over ℝ with explicit rational-entry matrices. The file builds cleanly in well under three minutes with no `sorry`/`admit`/`native_decide`/new axioms.

Model (explicit rational matrices):
- `Hsing = !![7/2,9/2,0; 9/2,7/2,0; 0,0,9]` — real symmetric with exact spectrum {-1, 8, 9} (the 2×2 block 7/2±9/2 = {-1,8} via the interaction off-diagonal 9/2, plus the decoupled 9); least eigenvalue -1, threshold 1.
- `Hcol = !![11/2,7/2; 7/2,11/2]` — the colored (traceless, x0+x1+x2=0, 2-dim) channel, exact spectrum {2, 9}, both ≥ threshold 1.
- `spec M := {μ | det (M - μ•1) = 0}`, `leastEigenvalue M := sInf (spec M)`.

Headline theorems proved:
1. `singlet_bound_energy`: `IsLeast (spec Hsing) (-1) ∧ -1 < 1` (singlet bound ground state is the least eigenvalue, strictly below threshold).
2. `colored_ground_ge_threshold`: every colored eigenvalue ≥ 1, equivalently `Hcol - 1` is PSD (explicit sum of squares `(7/2)(v₀+v₁)² + v₀² + v₁²`), so no colored state below threshold, hence none below the singlet bound -1.
3. `confinement_ordering` (payload): `leastEigenvalue Hsing = -1 < 1 ≤ leastEigenvalue Hcol` — the lightest two-particle excitation is the color singlet; the deconfinement KILL does not fire.

Non-degeneracy: explicit nonzero singlet bound eigenvector (1,-1,0) at -1 (`Hsing_eigvec`/`Hsing_eigvec_ne`), colored ground eigenvector (1,-1) at 2 (`Hcol_eigvec`/`Hcol_eigvec_ne`), and `Hcol_nondegenerate` giving energy 4 ≥ 1 for the nonzero vector (1,-1), showing Hcol is genuinely gapped, not trivially 0.

Constraints: proofs use only `det_fin_two`/`det_fin_three`, `ring`, `norm_num`, `mul_eq_zero`, `fin_cases`, and a degree-2 sum of squares. In-file `#guard_msgs (whitespace := lax) in #print axioms <thm>` on all three headline theorems confirms the footprint is exactly `[propext, Classical.choice, Quot.sound]`.

# Goal I — Dynamical confinement: no colored two-particle state below the singlet bound

All results live in `RequestProject/Main.lean`, namespace `Goal1Confinement`. The
development is fully self-contained (Mathlib only), works over `ℝ` with explicit
rational-entry matrices, and builds in well under three minutes.

## Model (explicit rational matrices)

- **Singlet two-body Hamiltonian** `Hsing : Matrix (Fin 3) (Fin 3) ℝ`
  `!![7/2, 9/2, 0; 9/2, 7/2, 0; 0, 0, 9]`.
  The `2×2` block `!![7/2, 9/2; 9/2, 7/2]` has eigenvalues `7/2 ± 9/2 = {-1, 8}`
  (the off-diagonal `9/2` is the constituent interaction producing the bound state at
  `-1`); the decoupled channel gives `9`. Exact spectrum `{-1, 8, 9}`, least eigenvalue
  `-1`, threshold `1`.
- **Colored two-body channel** `Hcol : Matrix (Fin 2) (Fin 2) ℝ`
  `!![11/2, 7/2; 7/2, 11/2]`, representing the color-nonsinglet (traceless,
  `x0+x1+x2=0`, two-dimensional) subspace. Exact spectrum `{2, 9}` (eigenvalues
  `11/2 ± 7/2`), both at or above the threshold `1`.

The **spectrum** `spec M` is defined as the roots of the characteristic determinant
`μ ↦ det (M - μ • 1)` (over the field `ℝ`, exactly the eigenvalues), and
`leastEigenvalue M := sInf (spec M)`.

## Headline theorems

1. `singlet_bound_energy` : `IsLeast (spec Hsing) (-1) ∧ (-1 : ℝ) < 1`.
   The singlet bound ground state is the least element of the spectrum, at `-1`,
   strictly below the two-constituent threshold `1`.
2. `colored_ground_ge_threshold` : `(∀ μ ∈ spec Hcol, 1 ≤ μ) ∧
   (∀ v, 0 ≤ v ⬝ᵥ ((Hcol - 1).mulVec v))`.
   Every colored eigenvalue is `≥ 1`, equivalently `Hcol - 1` is positive semidefinite
   (proved by the explicit degree-2 sum of squares
   `(7/2)(v₀+v₁)² + v₀² + v₁²`). So the colored channel has no state below threshold,
   hence none below the singlet bound `-1`.
3. `confinement_ordering` (payload) : `leastEigenvalue Hsing = -1 ∧ (-1 : ℝ) < 1 ∧
   1 ≤ leastEigenvalue Hcol`.
   The lightest two-particle excitation is the color-singlet bound state; the colored
   channel is gapped above it. The dynamical-deconfinement KILL does not fire.

## Non-degeneracy (explicit nonzero vectors)

- `Hsing_eigvec` / `Hsing_eigvec_ne` : `Hsing *ᵥ (1,-1,0) = (-1) • (1,-1,0)` with
  `(1,-1,0) ≠ 0` — the explicit singlet bound eigenvector at `-1`.
- `Hcol_eigvec` / `Hcol_eigvec_ne` : `Hcol *ᵥ (1,-1) = 2 • (1,-1)` with `(1,-1) ≠ 0`.
- `Hcol_nondegenerate` : the nonzero colored vector `(1,-1)` has energy
  `⟨v, Hcol v⟩ = 4 ≥ 1`, so `Hcol` is genuinely gapped, not trivially `0`.

## Constraints satisfied

- Kernel-checked, no `sorry`/`admit`/`native_decide`/new axiom.
- Axiom footprint is exactly `[propext, Classical.choice, Quot.sound]`, checked in-file
  by `#guard_msgs (whitespace := lax) in #print axioms <thm>` on all three headline
  theorems.
- Proofs use only `det_fin_two`/`det_fin_three`, `ring`, `norm_num`, `mul_eq_zero`,
  `fin_cases`, and a degree-2 sum of squares; no `Complex`, no `Real.cos/sin/sqrt`, no
  high-degree `nlinarith`. Fully self-contained.
