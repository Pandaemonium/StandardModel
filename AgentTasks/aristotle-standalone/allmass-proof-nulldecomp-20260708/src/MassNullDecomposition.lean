/-
# The CONVERSE: every mass decomposes into massless edges (universal null decomposition)

The null-edge mass thesis has two directions. The FORWARD direction is proved
elsewhere: a bundle of null (massless) momenta has invariant mass = their total
pairwise disagreement (`det P = Σ|ψᵢ ∧ ψⱼ|²`; and for two 4-momenta,
`massSq(k₁+k₂) = 2 k₁·k₂` for null `k₁,k₂`). The FORWARD direction says "null edges
*give* mass."

This file targets the CONVERSE — the universal-quantifier ("**all** mass") direction:
**every** massive (timelike) state *decomposes into* null edges realizing its mass as
disagreement. Proving it upgrades "null edges give mass" to "all mass *is* null-edge
disagreement," a kinematic constitution claim (not a derivation of mass values).

Two levels; prove as many as land cleanly.

## Level A — 4-momentum (physically transparent)

Every future-timelike 4-momentum is a sum of two future-null 4-momenta.
Construction (a hint, not a constraint): with `E = p 0`, `r = √(spaceNormSq p)`,
take `k₁ = ((E+r)/2)·(1, p⃗/r)` and `k₂ = ((E−r)/2)·(1, −p⃗/r)` (both null, both
future-pointing since `E > r` for timelike `p`); for `p⃗ = 0` pick any spatial unit
direction. Then `massSq k₁ = massSq k₂ = 0`, `p = k₁ + k₂`, and (with the forward
identity) `massSq p = 2·(k₁·k₂)` — the mass is exactly the disagreement of its two
null constituents.

## Level B — momentum matrix (the paper's `det P` mass; central)

Every positive-semidefinite Hermitian momentum matrix `P` decomposes into null-edge
dyads `P = Σᵢ ψᵢ ψᵢᴴ = M Mᴴ` (columns of `M` = the null spinors), and its Plücker
mass is the disagreement: `det P = normSq(det M) = |ψ₁ ∧ … ∧ ψₙ|²`. The factorization
`P = M Mᴴ` for PSD `P` should be available in Mathlib (e.g. via the PSD square root);
`det(M Mᴴ) = normSq(det M)` is a `det_mul` + `det_conjTranspose` + `mul_conj`
identity. So *every* momentum matrix — hence every massive state's invariant mass —
is a null-edge sum, universally.
-/

import Mathlib

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.MassNullDecomposition

/-! ## Level A — 4-momentum conventions (matching `NullEdgeTwoNullMassive`) -/

abbrev Four := Fin 4 → ℝ

/-- Minkowski inner product, signature `(+,−,−,−)`. -/
def mink (p q : Four) : ℝ := p 0 * q 0 - p 1 * q 1 - p 2 * q 2 - p 3 * q 3

/-- Mass square. -/
def massSq (p : Four) : ℝ := mink p p

/-- Spatial squared norm. -/
def spaceNormSq (p : Four) : ℝ := p 1 ^ 2 + p 2 ^ 2 + p 3 ^ 2

/-- FORWARD (already known; included for the disagreement identity): the mass square
of a sum of two null momenta is twice their Minkowski product. -/
theorem two_null_sum_massSq (p q : Four)
    (hp : massSq p = 0) (hq : massSq q = 0) :
    massSq (fun i => p i + q i) = 2 * mink p q := by
  unfold massSq mink at *
  linarith

/-- **CONVERSE, Level A (TARGET).** Every future-timelike 4-momentum is a sum of two
future-pointing null 4-momenta. -/
theorem massive_eq_two_null (p : Four) (hp0 : 0 < p 0) (hpos : 0 < massSq p) :
    ∃ k1 k2 : Four, massSq k1 = 0 ∧ massSq k2 = 0 ∧ 0 < k1 0 ∧ 0 < k2 0 ∧
      (∀ i, p i = k1 i + k2 i) := by
  sorry

/-- **CONVERSE, Level A — mass = disagreement (TARGET).** Consequently every
future-timelike momentum is a two-null sum whose mass square equals twice the
disagreement of its null constituents. -/
theorem massSq_eq_two_null_disagreement (p : Four) (hp0 : 0 < p 0)
    (hpos : 0 < massSq p) :
    ∃ k1 k2 : Four, massSq k1 = 0 ∧ massSq k2 = 0 ∧
      (∀ i, p i = k1 i + k2 i) ∧ massSq p = 2 * mink k1 k2 := by
  sorry

/-! ## Level B — momentum matrix (`det P` mass) -/

/-- **CONVERSE, Level B (TARGET, central).** Every positive-semidefinite Hermitian
momentum matrix decomposes into null-edge dyads `P = M Mᴴ` (columns of `M` are the
null spinors `ψᵢ`, so `P = Σᵢ ψᵢ ψᵢᴴ`). -/
theorem posSemidef_eq_null_edge_sum {n : ℕ} (P : Matrix (Fin n) (Fin n) ℂ)
    (hP : P.PosSemidef) : ∃ M : Matrix (Fin n) (Fin n) ℂ, P = M * Mᴴ := by
  sorry

/-- **CONVERSE, Level B — mass = disagreement (TARGET).** The Plücker mass of any
momentum matrix is the disagreement of its null-edge decomposition:
`det P = normSq(det M) = |ψ₁ ∧ … ∧ ψₙ|²`. -/
theorem det_eq_null_edge_disagreement {n : ℕ} (P : Matrix (Fin n) (Fin n) ℂ)
    (hP : P.PosSemidef) :
    ∃ M : Matrix (Fin n) (Fin n) ℂ, P = M * Mᴴ ∧
      P.det = (Complex.normSq M.det : ℂ) := by
  sorry

end PhysicsSM.Draft.NullEdge.MassNullDecomposition
