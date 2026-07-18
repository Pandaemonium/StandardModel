# Aristotle semantic context pack

Generated: 2026-07-16T21:42:27
Query: `exact reciprocal square-root normalization of a real Fin 4 bilinear Gram matrix diag positive negative negative negative to Minkowski eta`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `PhysicsSM/NullStrand/Conventions.lean` [Herm2]

Score: `0.842`

```text
abbrev Herm2 := Matrix (Fin 2) (Fin 2) Complex

/-- Bilinear form `eta = diag(1,-1,-1,-1)` on `Fin 4 -> Real`. -/
```

### 2. `AgentTasks/overnight-allmass-run-2026-07-09/harvest/minkport/3a6f3266-e377-40e6-95c6-83c3901007e0_aristotle/ARISTOTLE_SUMMARY.md` [Contents]

Score: `0.839`

```text
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
```

### 3. `AgentTasks/overnight-allmass-run-2026-07-09/jobs/minkowski-physlean-port.md` [Targets (Mathlib only; explicit)]

Score: `0.830`

```text
## Targets (Mathlib only; explicit)

1. `eta_def` / `eta_eq_indefiniteDiagonal`: define `eta : Matrix (Fin 4) (Fin 4) R := !![1,0,0,0;
   0,-1,0,0; 0,0,-1,0; 0,0,0,-1]` and prove it equals the reindexing of
   `LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin 3) R` under the standard
   `Fin 4 ~= Fin 1 (+) Fin 3` equiv (`finSumFinEquiv`/`finCongr`) -- i.e. our hand `eta` IS the
   Mathlib/PhysLean Minkowski matrix, convention-checked. If the reindexing is heavy, at minimum
   prove `eta` is symmetric, `eta * eta = 1` (involutive), `eta.det = -1`, `trace eta = -2`, and
   `indefiniteDiagonal (Fin 1) (Fin 3) R` has the SAME diagonal entries (a diagonal-entry match).
2. `minkowskiForm`: `mink u v := u^T eta v` (the Minkowski inner product); prove bilinearity and
   `mink u u = u0^2 - u1^2 - u2^2 - u3^2` (the signature).
3. `null_iff`: `mink u u = 0 <-> u0^2 = u1^2 + u2^2 + u3^2` -- the null-cone condition our
   photon/boost modules use; instantiate on the null witness `u = (1,1,0,0)` (`mink u u = 0`) and
   the timelike witness `u = (5,3,0,0)` (`mink u u = 16`).
4. `convention_note`: a theorem-let recording the mostly-minus convention `(+,-,-,-)` matches
   PhysLean `minkowskiMatrix` and Mathlib `indefiniteDiagonal` -- e.g. `eta 0 0 = 1 AND eta 1 1 =
   -1` stated explicitly (provenance anchor).

MANDATORY non-degeneracy: the null witness `(1,1,0,0)` and timelike `(5,3,0,0)` with their `mink`
values (0 and 16) explicit in-theorem.
```

### 4. `PhysicsSM/Draft/NullEdge/DiracGammaPhysLean.lean` [gamma]

Score: `0.830`

```text
def gamma : Fin 4 → Matrix (Fin 4) (Fin 4) ℂ
  | 0 => g0
  | 1 => g1
  | 2 => g2
  | 3 => g3

/-- The mostly-minus Minkowski metric `η = diag(1,-1,-1,-1)` as a complex-valued
diagonal form, signature `(+,-,-,-)`. -/
```

### 5. `PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean` [gamma]

Score: `0.824`

```text
def gamma : Fin 4 → CMat4 := ![gamma0, gamma1, gamma2, gamma3]

/-- The mostly-minus Minkowski metric `η = diag(+,-,-,-)`. -/
```

### 6. `PhysicsSM/Draft/NullEdge/CarrierRigidity.lean` [N]

Score: `0.820`

```text
abbrev N := Matrix (Fin 4) (Fin 4) ℚ

/-- Indefinite Krein metric `η = diag(1,−1,1,−1)` (signature (2,2)). -/
```

### 7. `PhysicsSM/Coding/E8Basis.lean` [e8CodeBasisGram_det_pos]

Score: `0.813`

```text
theorem e8CodeBasisGram_det_pos : 0 < e8CodeBasisGram.det := by
  rw [e8CodeBasisGram_det]; norm_num

/-- All diagonal entries of the Gram matrix are 4, confirming each
basis vector has squared norm 4. -/
```

### 8. `AgentTasks/overnight-allmass-run-2026-07-09/harvest/minkport/3a6f3266-e377-40e6-95c6-83c3901007e0_aristotle/ARISTOTLE_SUMMARY.md` [Summary of changes for run 3a6f3266-e377-40e6-95c6-83c3901007e0]

Score: `0.812`

```text
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

`lean_build` on `RequestProject.Main` completes successful
```

## Scoped paper hits

### 1. An analysis of completely-positive trace-preserving maps on M2

Score: `0.728`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

### 2. On Noncommutative and semi-Riemannian Geometry

Score: `0.722`
Zotero key: `F877GT5B`
arXiv: `math-ph/0110001`
DOI: `10.48550/arXiv.math-ph/0110001`
URL: https://arxiv.org/abs/math-ph/0110001

Abstract:

Introduces semi-Riemannian spectral triples using Krein spaces and Krein-selfadjoint Dirac operators, with recovery of signature data from spectral data.

### 3. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.720`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548
