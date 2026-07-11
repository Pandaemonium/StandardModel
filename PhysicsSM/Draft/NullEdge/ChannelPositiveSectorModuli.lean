import PhysicsSM.Draft.NullEdge.ChannelKreinSectorSignature

/-!
# Distinct positive-sector choices in the live even Krein carrier

Publication-grade Paper F target. The live even
Krein-self-adjoint sector has signature `(4,2)`. This module asks for the next
classification rung: an explicit rational Krein isometry carries the diagonal
four-coordinate positive family to a different positive four-coordinate
family, with the quadratic form preserved exactly.

The result would prove nonuniqueness of positive-sector choices in the concrete
carrier. It would not make either family physical, prove maximality among all
positive subspaces, or classify the full positive Grassmannian.

Provenance: theorem design and proofs from the overnight publication run, using
the exact normal form and signature in `ChannelKreinSectorSignature`. An
independent Aristotle proof route was also requested; the live source is the
locally audited proof and remains authoritative after the guard build.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelPositiveSectorModuli

open CarrierRigidity.Concrete
open ChannelKreinMetricNoGo
open ChannelKreinSectorSignature

/-- A noncompact rational isometry in the first `(1,1)` Krein block. -/
def boost : N :=
  !![(5 : ℚ) / 3, 4 / 3, 0, 0;
     4 / 3, 5 / 3, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, 1]

/-- The exact rational inverse of `boost`. -/
def boostInv : N :=
  !![(5 : ℚ) / 3, -4 / 3, 0, 0;
     -4 / 3, 5 / 3, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, 1]

/-- Conjugation by the explicit rational Krein isometry. -/
def boostConj (X : N) : N := boost * X * boostInv

/-- The image of the diagonal positive family under the boost. -/
def boostedPositive (a d e g : ℚ) : N :=
  boostConj (normalForm a d e g 0 0)

theorem boost_mul_boostInv : boost * boostInv = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [boost, boostInv, Matrix.mul_apply, Fin.sum_univ_four,
      Matrix.vecHead, Matrix.vecTail, Matrix.of_apply, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three,
      Matrix.cons_val]

theorem boostInv_mul_boost : boostInv * boost = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [boost, boostInv, Matrix.mul_apply, Fin.sum_univ_four,
      Matrix.vecHead, Matrix.vecTail, Matrix.of_apply, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three,
      Matrix.cons_val]

theorem boost_preserves_eta : Matrix.transpose boost * eta * boost = eta := by
  have hsymm : Matrix.transpose boost = boost := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [boost, Matrix.transpose_apply, Matrix.vecHead, Matrix.vecTail,
        Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
        Matrix.cons_val_three]
  rw [hsymm]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [boost, eta, Matrix.mul_apply, Fin.sum_univ_four,
      Matrix.vecHead, Matrix.vecTail, Matrix.of_apply, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three,
      Matrix.cons_val]

theorem boost_commutes_chirality : Gam * boost = boost * Gam := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [boost, Gam, Matrix.mul_apply, Fin.sum_univ_four,
      Matrix.vecHead, Matrix.vecTail, Matrix.of_apply, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three,
      Matrix.cons_val]

/-- Exact coordinates of the boosted positive family. -/
theorem boostedPositive_eq_normalForm (a d e g : ℚ) :
    boostedPositive a d e g =
      normalForm ((25 * a - 16 * d) / 9) ((-16 * a + 25 * d) / 9)
        e g (20 * (d - a) / 9) 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [boostedPositive, boostConj, boost, boostInv, normalForm,
      Matrix.mul_apply, Fin.sum_univ_four]
  all_goals ring

theorem boostedPositive_selfadjoint (a d e g : ℚ) :
    kadj (boostedPositive a d e g) = boostedPositive a d e g := by
  rw [boostedPositive_eq_normalForm]
  exact normalForm_selfadjoint _ _ _ _ _ _

theorem boostedPositive_even (a d e g : ℚ) :
    Gam * boostedPositive a d e g = boostedPositive a d e g * Gam := by
  rw [boostedPositive_eq_normalForm]
  exact normalForm_even _ _ _ _ _ _

/-- The boost preserves the positive quadratic form exactly on the family. -/
theorem boostedPositive_gram (a d e g : ℚ) :
    kreinGram (boostedPositive a d e g) (boostedPositive a d e g) =
      a ^ 2 + d ^ 2 + e ^ 2 + g ^ 2 := by
  rw [boostedPositive_eq_normalForm, normalForm_gram]
  ring

/-- The boosted family is positive definite, not merely nonnegative. -/
theorem boostedPositive_strict {a d e g : ℚ}
    (h : a ≠ 0 ∨ d ≠ 0 ∨ e ≠ 0 ∨ g ≠ 0) :
    0 < kreinGram (boostedPositive a d e g) (boostedPositive a d e g) := by
  rw [boostedPositive_gram]
  rcases h with ha | hd | he | hg
  · have hs : 0 < a ^ 2 := by positivity
    nlinarith [sq_nonneg d, sq_nonneg e, sq_nonneg g]
  · have hs : 0 < d ^ 2 := by positivity
    nlinarith [sq_nonneg a, sq_nonneg e, sq_nonneg g]
  · have hs : 0 < e ^ 2 := by positivity
    nlinarith [sq_nonneg a, sq_nonneg d, sq_nonneg g]
  · have hs : 0 < g ^ 2 := by positivity
    nlinarith [sq_nonneg a, sq_nonneg d, sq_nonneg e]

/-- The boosted family has unique values of all four coordinates. -/
theorem boostedPositive_coordinates_unique
    {a d e g a' d' e' g' : ℚ}
    (h : boostedPositive a d e g = boostedPositive a' d' e' g') :
    a = a' ∧ d = d' ∧ e = e' ∧ g = g' := by
  rw [boostedPositive_eq_normalForm, boostedPositive_eq_normalForm] at h
  rcases normalForm_coordinates_unique h with ⟨ha, hd, he, hg, _, _⟩
  refine ⟨?_, ?_, he, hg⟩ <;> linarith

/-- A nonzero positive vector in the boosted family lies outside the original
diagonal positive family. This is the required nondegeneracy witness. -/
theorem boosted_witness_not_diagonal :
    ¬ (∃ a d e g : ℚ, boostedPositive 1 0 0 0 = normalForm a d e g 0 0) := by
  rintro ⟨a, d, e, g, h⟩
  rw [boostedPositive_eq_normalForm] at h
  have hc := normalForm_coordinates_unique h
  norm_num at hc

/-- The same witness has exact positive norm one. -/
theorem boosted_witness_gram :
    kreinGram (boostedPositive 1 0 0 0) (boostedPositive 1 0 0 0) = 1 := by
  norm_num [boostedPositive_gram]

/-! ## Build-enforced assumption-footprint audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPositiveSectorModuli.boost_preserves_eta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms boost_preserves_eta

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPositiveSectorModuli.boostedPositive_eq_normalForm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms boostedPositive_eq_normalForm

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPositiveSectorModuli.boostedPositive_gram' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms boostedPositive_gram

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPositiveSectorModuli.boostedPositive_coordinates_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms boostedPositive_coordinates_unique

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelPositiveSectorModuli.boosted_witness_not_diagonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms boosted_witness_not_diagonal

end PhysicsSM.Draft.NullEdge.ChannelPositiveSectorModuli
