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
open scoped ComplexOrder

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
  by_cases h : spaceNormSq p = 0
  · -- Spatial part vanishes: split the energy along a fixed axis (0,0,1).
    have h1 : p 1 = 0 ∧ p 2 = 0 ∧ p 3 = 0 := by
      unfold spaceNormSq at h
      refine ⟨?_, ?_, ?_⟩ <;>
        nlinarith [sq_nonneg (p 1), sq_nonneg (p 2), sq_nonneg (p 3)]
    obtain ⟨hp1, hp2, hp3⟩ := h1
    refine ⟨![p 0/2, 0, 0, p 0/2], ![p 0/2, 0, 0, -p 0/2], ?_, ?_, ?_, ?_, ?_⟩
    · simp only [massSq, mink, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.tail_cons]; ring
    · simp only [massSq, mink, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.tail_cons]; ring
    · simp; linarith
    · simp; linarith
    · intro i; fin_cases i <;> (simp [hp1, hp2, hp3]; try ring)
  · -- Spatial part nonzero: r = √(spaceNormSq p) > 0 and, being timelike, p 0 > r.
    have hsn : 0 < spaceNormSq p :=
      lt_of_le_of_ne (by unfold spaceNormSq; positivity) (Ne.symm h)
    set r := Real.sqrt (spaceNormSq p) with hr
    have hr2 : r ^ 2 = spaceNormSq p := Real.sq_sqrt (le_of_lt hsn)
    have hrpos : 0 < r := Real.sqrt_pos.mpr hsn
    have hrne : r ≠ 0 := ne_of_gt hrpos
    have hms : massSq p = p 0 ^ 2 - spaceNormSq p := by
      unfold massSq mink spaceNormSq; ring
    have hlt : spaceNormSq p < p 0 ^ 2 := by linarith [hms, hpos]
    have hEr : r < p 0 := by nlinarith [hr2, hrpos, hp0, hlt]
    have hsum2 : (p 1) ^ 2 + (p 2) ^ 2 + (p 3) ^ 2 = r ^ 2 := by
      rw [hr2]; unfold spaceNormSq; ring
    refine ⟨![(p 0+r)/2, (p 0+r)/2*(p 1)/r, (p 0+r)/2*(p 2)/r, (p 0+r)/2*(p 3)/r],
            ![(p 0-r)/2, -((p 0-r)/2*(p 1)/r), -((p 0-r)/2*(p 2)/r), -((p 0-r)/2*(p 3)/r)],
            ?_, ?_, ?_, ?_, ?_⟩
    · simp only [massSq, mink, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.tail_cons]
      field_simp
      nlinarith [hsum2, sq_nonneg (p 0+r)]
    · simp only [massSq, mink, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
        Matrix.cons_val_two, Matrix.cons_val_three, Matrix.tail_cons]
      field_simp
      nlinarith [hsum2, sq_nonneg (p 0-r)]
    · simp; linarith
    · simp; linarith
    · intro i; fin_cases i <;> (simp; field_simp; ring)

/-- **CONVERSE, Level A — mass = disagreement (TARGET).** Consequently every
future-timelike momentum is a two-null sum whose mass square equals twice the
disagreement of its null constituents. -/
theorem massSq_eq_two_null_disagreement (p : Four) (hp0 : 0 < p 0)
    (hpos : 0 < massSq p) :
    ∃ k1 k2 : Four, massSq k1 = 0 ∧ massSq k2 = 0 ∧
      (∀ i, p i = k1 i + k2 i) ∧ massSq p = 2 * mink k1 k2 := by
  obtain ⟨k1, k2, hk1, hk2, _, _, hsum⟩ := massive_eq_two_null p hp0 hpos
  refine ⟨k1, k2, hk1, hk2, hsum, ?_⟩
  have : p = (fun i => k1 i + k2 i) := funext hsum
  rw [this, two_null_sum_massSq k1 k2 hk1 hk2]

/-! ## Level B — momentum matrix (`det P` mass) -/

/-- **CONVERSE, Level B (TARGET, central).** Every positive-semidefinite Hermitian
momentum matrix decomposes into null-edge dyads `P = M Mᴴ` (columns of `M` are the
null spinors `ψᵢ`, so `P = Σᵢ ψᵢ ψᵢᴴ`). -/
theorem posSemidef_eq_null_edge_sum {n : ℕ} (P : Matrix (Fin n) (Fin n) ℂ)
    (hP : P.PosSemidef) : ∃ M : Matrix (Fin n) (Fin n) ℂ, P = M * Mᴴ := by
  obtain ⟨B, hB⟩ := Matrix.posSemidef_iff_eq_conjTranspose_mul_self.mp hP
  exact ⟨Bᴴ, by rw [conjTranspose_conjTranspose]; exact hB⟩

/-- **CONVERSE, Level B — mass = disagreement (TARGET).** The Plücker mass of any
momentum matrix is the disagreement of its null-edge decomposition:
`det P = normSq(det M) = |ψ₁ ∧ … ∧ ψₙ|²`. -/
theorem det_eq_null_edge_disagreement {n : ℕ} (P : Matrix (Fin n) (Fin n) ℂ)
    (hP : P.PosSemidef) :
    ∃ M : Matrix (Fin n) (Fin n) ℂ, P = M * Mᴴ ∧
      P.det = (Complex.normSq M.det : ℂ) := by
  obtain ⟨B, hB⟩ := Matrix.posSemidef_iff_eq_conjTranspose_mul_self.mp hP
  refine ⟨Bᴴ, ?_, ?_⟩
  · rw [conjTranspose_conjTranspose]; exact hB
  · rw [hB, Matrix.det_mul, Matrix.det_conjTranspose]
    rw [show (star B.det) = (starRingEnd ℂ) B.det from rfl, Complex.normSq_conj]
    exact (Complex.normSq_eq_conj_mul_self).symm

/-! ## Axiom footprint guards — each landed theorem uses only the standard trusted axioms. -/

/-- info: 'PhysicsSM.Draft.NullEdge.MassNullDecomposition.massive_eq_two_null' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs in
#print axioms massive_eq_two_null

/-- info: 'PhysicsSM.Draft.NullEdge.MassNullDecomposition.massSq_eq_two_null_disagreement' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs in
#print axioms massSq_eq_two_null_disagreement

/-- info: 'PhysicsSM.Draft.NullEdge.MassNullDecomposition.posSemidef_eq_null_edge_sum' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs in
#print axioms posSemidef_eq_null_edge_sum

/-- info: 'PhysicsSM.Draft.NullEdge.MassNullDecomposition.det_eq_null_edge_disagreement' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs in
#print axioms det_eq_null_edge_disagreement

end PhysicsSM.Draft.NullEdge.MassNullDecomposition
