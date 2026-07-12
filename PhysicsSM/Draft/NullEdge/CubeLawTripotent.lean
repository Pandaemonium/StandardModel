/-
# The cube-closure law as a common tripotent corollary

Provenance: harvested from Aristotle job `f8753b41-79d5-494d-b4b6-3d4fea76a686`
(`fable-24h-cubelaw-project`, 2026-07-12). Reviewed for semantic alignment before
integration; the only edit from the returned file is the import path
(`context.PlueckerRestOperatorGeneral` -> the in-repo module) and this note.

This file isolates the *abstract algebraic pattern* shared by two independently
landed results, and records -- as two honest, independent cross-checks -- that each
of those results instantiates the pattern.

The two landed theorems are:

* `PhysicsSM/Draft/NullEdge/PlueckerRestOperatorGeneral.lean` :
  `restOp_cube : restOp u v ^ 3 = budget u v • restOp u v`,
  i.e. the generalized Pluecker rest operator `B_w` satisfies `B_w^3 = budget * B_w`
  with `budget` a real, nonnegative scalar (a Gram determinant).

* `PhysicsSM/Draft/NullEdge/PlueckerPairGenerator.lean` :
  `generator_cubed : Kop z (Kop z (Kop z psi)) = (z * conj z) • Kop z psi`,
  i.e. the pair-transfer generator `K` satisfies `K^3 = |z|^2 * K`.

## What is (and is NOT) claimed here

The ONLY thing these two operators share is a *shape*: both are elements `X` of a
ring (a matrix / linear endomorphism ring over `C`) obeying

  `X ^ 3 = c * X`  with `c` a nonnegative real scalar.

This file proves, once and abstractly, that any such `X` normalizes to a **tripotent**
`Y` (`Y^3 = Y`), that `Y^2` is then an idempotent (a projector), that `Y^2` commutes
with `Y`, and that `Y` is a *partial involution* supported on that projector.  We then
observe that `B_w` and `K` each satisfy the hypothesis `X^3 = c*X`, so each *separately*
yields a tripotent.

**This is a common corollary, not a unification.**  `B_w` and `K` are different
operators built for different purposes (a rest sector versus a supplied interaction).
There is *no* lemma in this file relating `B_w` to `K`, and none is possible from the
material here: the coincidence is one of algebraic shape only.  In particular, the
2x2 form used below for the pair generator and the block form of `B_w` are distinct
objects; their common cube-closure shape is a coincidence, not an identity.

Cross-check A instantiates the abstract pattern on the *actual* landed `restOp_cube`.
Cross-check B is a self-contained, Mathlib-only reconstruction of the *same algebraic
fact* `K^3 = |z|^2 * K` on the pair generator's active 2x2 sector; anchoring it to the
landed `generator_cubed` directly would require lifting that pointwise `Fock`-space
identity to an operator (`Module.End`) cube law, which is left as a follow-up.

Everything is kernel-checked and uses only the standard axioms.
-/
import Mathlib
import PhysicsSM.Draft.NullEdge.PlueckerRestOperatorGeneral

namespace CubeLawTripotent

/-! ## 1. The abstract pattern -/

section Abstract

variable {𝕜 R : Type*} [CommRing 𝕜] [Ring R] [Algebra 𝕜 R]

/-- **Normalization to a tripotent (general scalar).**
If `X ^ 3 = c • X` and a scalar `r` satisfies `r ^ 2 * c = 1`, then the normalized
element `Y := r • X` is a tripotent: `Y ^ 3 = Y`. -/
theorem cube_normalize_tripotent (X : R) (c r : 𝕜)
    (hcube : X ^ 3 = c • X) (hr : r ^ 2 * c = 1) :
    (r • X) ^ 3 = r • X := by
  rw [smul_pow, hcube, smul_smul]
  have h3 : r ^ 3 * c = r := by
    have : r ^ 3 * c = r * (r ^ 2 * c) := by ring
    rw [this, hr, mul_one]
  rw [h3]

end Abstract

section AbstractReal

variable {R : Type*} [Ring R] [Algebra ℝ R]

/-- **`cube_to_tripotent` — normalization to a tripotent (real coefficient `c > 0`).**
If `X ^ 3 = c • X` for a strictly positive real `c`, then `Y := (Real.sqrt c)⁻¹ • X`
is a tripotent: `Y ^ 3 = Y`. -/
theorem cube_to_tripotent (X : R) (c : ℝ) (hc : 0 < c) (hcube : X ^ 3 = c • X) :
    ((Real.sqrt c)⁻¹ • X) ^ 3 = (Real.sqrt c)⁻¹ • X := by
  apply cube_normalize_tripotent X c (Real.sqrt c)⁻¹ hcube
  have hs : Real.sqrt c ^ 2 = c := Real.sq_sqrt hc.le
  have hne : Real.sqrt c ≠ 0 := by positivity
  field_simp
  exact hs.symm

/-- **The degenerate case `c = 0`.**  If `X ^ 3 = 0 • X` then `X` is cube-nilpotent
(`X ^ 3 = 0`).  There is no nonzero rescaling turning such an `X` into a tripotent
(a nonzero tripotent has `Y ^ 3 = Y ≠ 0`), so the `c = 0` boundary is genuinely
outside the tripotent regime and is recorded separately. -/
theorem cube_zero_nilpotent (X : R) (hcube : X ^ 3 = (0 : ℝ) • X) : X ^ 3 = 0 := by
  simpa using hcube

end AbstractReal

/-! ## 2. Consequences for a tripotent -/

section Tripotent

variable {R : Type*} [Ring R]

/-- **`tripotent_sq_idempotent`.**  If `Y ^ 3 = Y` then `Y ^ 2` is idempotent, i.e.
`(Y ^ 2) ^ 2 = Y ^ 2`: the square of a tripotent is a projector. -/
theorem tripotent_sq_idempotent (Y : R) (h : Y ^ 3 = Y) : (Y ^ 2) ^ 2 = Y ^ 2 := by
  have e : (Y ^ 2) ^ 2 = Y ^ 3 * Y := by rw [← pow_mul, ← pow_succ]
  rw [e, h, ← pow_two]

/-- `Y ^ 2` commutes with `Y` (this needs no hypothesis; powers of one element
commute).  Combined with `tripotent_sq_idempotent`, the projector `Y ^ 2` commutes
with the tripotent `Y`. -/
theorem tripotent_sq_comm (Y : R) : Y ^ 2 * Y = Y * Y ^ 2 := by
  rw [← pow_succ, ← pow_succ']

/-- **`tripotent_partial_involution`.**  If `Y ^ 3 = Y` then the projector `P := Y ^ 2`
acts as a two-sided identity on `Y` (`P * Y = Y` and `Y * P = Y`).  Equivalently, `Y`
is supported on the range of `P`, and its restriction there squares to `P` (i.e. `Y`
is a partial involution: `Y ∘ Y = P` on `range P`). -/
theorem tripotent_partial_involution (Y : R) (h : Y ^ 3 = Y) :
    Y ^ 2 * Y = Y ∧ Y * Y ^ 2 = Y := by
  refine ⟨?_, ?_⟩
  · rw [← pow_succ]; exact h
  · rw [← pow_succ']; exact h

end Tripotent

/-! ## 3. Cross-check A — the generalized Pluecker rest operator `B_w`

This is a genuine instantiation of the abstract pattern on the *actual* landed
operator, imported from `PhysicsSM/Draft/NullEdge/PlueckerRestOperatorGeneral.lean`.
It is included purely as an independent illustration; nothing here connects `B_w` to
the pair generator `K` of Cross-check B. -/

section CrossCheckB

open PhysicsSM.Draft.NullEdge.PlueckerRestOperatorGeneral

variable {n : ℕ}

/-
The area budget is a *real* scalar (its imaginary part vanishes): the complex
number `budget u v` equals the coercion of its own real part.
-/
theorem budget_ofReal_re (u v : Fin n → ℂ) :
    ((budget u v).re : ℂ) = budget u v := by
  convert Complex.conj_eq_iff_re.mp _;
  convert budget_star u v using 1

/-
The area budget is nonnegative (it is `½·∑|z_ij|²`, a total squared area).
-/
theorem budget_re_nonneg (u v : Fin n → ℂ) : 0 ≤ (budget u v).re := by
  have hsum : (0 : ℝ) ≤ (∑ i, ∑ j, star (areaMatrix u v i j) * areaMatrix u v i j).re := by
    rw [Complex.re_sum]
    refine Finset.sum_nonneg fun i _ => ?_
    rw [Complex.re_sum]
    refine Finset.sum_nonneg fun j _ => ?_
    have : star (areaMatrix u v i j) * areaMatrix u v i j
        = ((Complex.normSq (areaMatrix u v i j) : ℝ) : ℂ) := by
      simp [Complex.mul_conj, mul_comm]
    rw [this]; simp [Complex.normSq_nonneg]
  rw [sum_sq_areaMatrix] at hsum
  simpa using hsum

/-- **`B_w` yields a tripotent.**  When the budget is nonzero, normalizing the rest
operator by `r := (√(budget.re))⁻¹` produces a tripotent `(r • B_w) ^ 3 = r • B_w`.

This is exactly the abstract `cube_normalize_tripotent` applied to the landed
`restOp_cube`.  It is an *independent* consequence for `B_w` alone; it makes no
reference to and no claim about the pair generator `K`. -/
theorem restOp_normalized_tripotent (u v : Fin n → ℂ) (h : budget u v ≠ 0) :
    let r : ℂ := ((Real.sqrt (budget u v).re : ℂ))⁻¹
    (r • restOp u v) ^ 3 = r • restOp u v := by
  intro r
  refine cube_normalize_tripotent (restOp u v) (budget u v) r (restOp_cube u v) ?_
  have hre : ((budget u v).re : ℂ) = budget u v := budget_ofReal_re u v
  have hpos : 0 < (budget u v).re := by
    rcases (budget_re_nonneg u v).lt_or_eq with hlt | heq
    · exact hlt
    · exfalso; apply h; rw [← hre, ← heq]; simp
  have hsne : Real.sqrt (budget u v).re ≠ 0 := by positivity
  have hsq : (Real.sqrt (budget u v).re : ℂ) ^ 2 = (budget u v).re := by
    have : Real.sqrt (budget u v).re ^ 2 = (budget u v).re := Real.sq_sqrt hpos.le
    exact_mod_cast this
  show (((Real.sqrt (budget u v).re : ℂ))⁻¹) ^ 2 * budget u v = 1
  rw [inv_pow, hsq, hre, inv_mul_cancel₀ h]

end CrossCheckB

/-! ## 4. Cross-check B — the pair-transfer generator `K`

The pair generator `Kop z` of `PlueckerPairGenerator.lean` acts nontrivially
only on its two-element pair sector `{lowPair, highPair}`, where (by `Kop_apply`) it
sends the `lowPair` amplitude to `z ·(highPair amplitude)` and the `highPair`
amplitude to `conj z ·(lowPair amplitude)`.  On that active sector it is faithfully
represented by the `2×2` Hermitian off-diagonal matrix below.  (The landed module is
not imported here; this is a self-contained, Mathlib-only reconstruction of the *same
algebraic fact* `K^3 = |z|^2 · K`, namely the landed `generator_cubed`.)

**No identity with `B_w` is claimed or provable here.**  This 2×2 operator and the
block operator `restOp` of Cross-check A are different objects; they merely share the
cube-closure shape. -/

section CrossCheckK

open Matrix

/-- The pair-transfer generator on its active `{lowPair, highPair}` sector:
`K z = [[0, z], [conj z, 0]]`. -/
def pairGenSector (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, z; star z, 0]

/-
`K^2 = |z|^2 • 1` on the pair sector.
-/
theorem pairGenSector_sq (z : ℂ) :
    (pairGenSector z) ^ 2 = (z * star z) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  unfold pairGenSector;
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ sq, Matrix.mul_apply ];
  ring

/-
**The pair-generator cube law** `K^3 = |z|^2 • K`, faithful to the landed
`generator_cubed`.
-/
theorem pairGenSector_cube (z : ℂ) :
    (pairGenSector z) ^ 3 = (z * star z) • pairGenSector z := by
  rw [ pow_succ, pairGenSector_sq ];
  rw [ Matrix.smul_mul, Matrix.one_mul ]

/-- **`K` yields a tripotent.**  For `z ≠ 0`, normalizing by `r := (√‖z‖²)⁻¹`
produces a tripotent, via the abstract `cube_to_tripotent` applied to
`pairGenSector_cube`.  This is an *independent* consequence for `K` alone. -/
theorem pairGenSector_normalized_tripotent (z : ℂ) (hz : z ≠ 0) :
    ((Real.sqrt (Complex.normSq z))⁻¹ • pairGenSector z) ^ 3
      = (Real.sqrt (Complex.normSq z))⁻¹ • pairGenSector z := by
  have hc : (0 : ℝ) < Complex.normSq z := Complex.normSq_pos.mpr hz
  have hcube : (pairGenSector z) ^ 3 = (Complex.normSq z : ℝ) • pairGenSector z := by
    rw [pairGenSector_cube]
    have : z * star z = ((Complex.normSq z : ℝ) : ℂ) := by
      simp [Complex.mul_conj]
    rw [this]
    exact (Complex.coe_smul (Complex.normSq z) (pairGenSector z))
  exact cube_to_tripotent (pairGenSector z) (Complex.normSq z) hc hcube

end CrossCheckK

end CubeLawTripotent
