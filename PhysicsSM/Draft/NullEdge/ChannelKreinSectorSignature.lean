import PhysicsSM.Draft.NullEdge.ChannelKreinMetricNoGo

/-!
# Exact normal form and signature of the live even Krein sector

This module classifies every chirality-even, Krein-self-adjoint matrix in the
live concrete rational `4 x 4` carrier. Each such matrix has a unique
six-coordinate normal form, and the adjoint-induced self-pairing is exactly

`a^2 + d^2 + e^2 + g^2 - 2*b^2 - 2*f^2`.

Thus the complete sector has signature `(4,2)`: four positive square directions
and two negative directions with coefficient `-2`.
The diagonal four-coordinate subspace is positive definite, while the remaining
two-coordinate plane is strictly negative away from zero. This is a signature
classification of the supplied live form. It does not derive the diagonal
subspace as physical, place the named mass channels inside it, or produce a
positive selector without an independently justified sector principle.

Provenance: all theorem statements and proofs from Aristotle project
`ed445871-8aca-48a9-a150-4193a2972df6`, integrated against the live carrier
definitions and rebuilt under Lean 4.28.0.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelKreinSectorSignature

open CarrierRigidity.Concrete
open ChannelKreinMetricNoGo

/-- Unique coordinate model for the complete even Krein-self-adjoint sector. -/
def normalForm (a d e g b f : ℚ) : N :=
  !![a,b,0,0; -b,d,0,0; 0,0,e,f; 0,0,-f,g]

set_option maxRecDepth 4000 in
theorem normalForm_selfadjoint (a d e g b f : ℚ) :
    kadj (normalForm a d e g b f) = normalForm a d e g b f := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [kadj, normalForm, eta, Matrix.mul_apply, Fin.sum_univ_four,
      Matrix.transpose_apply, Matrix.vecHead, Matrix.vecTail]

set_option maxRecDepth 4000 in
theorem normalForm_even (a d e g b f : ℚ) :
    Gam * normalForm a d e g b f = normalForm a d e g b f * Gam := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Gam, normalForm, Matrix.mul_apply, Fin.sum_univ_four]

/-- Every even Krein-self-adjoint represented matrix has the displayed
six-coordinate normal form. -/
theorem even_selfadjoint_exists_normalForm (X : N)
    (hself : kadj X = X) (heven : Gam * X = X * Gam) :
    ∃ a d e g b f : ℚ, X = normalForm a d e g b f := by
  unfold kadj at hself
  unfold eta Gam normalForm at *
  simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_succ]
  simp_all +decide [Matrix.vecMul, Matrix.mul_apply, Fin.sum_univ_succ]
  norm_num [Matrix.vecHead, Matrix.vecTail] at *
  exact ⟨⟨by linarith !, by linarith !⟩,
    ⟨by linarith !, by linarith !, by linarith !⟩,
    ⟨by linarith !, by linarith !⟩,
    by linarith !, by linarith !, by linarith !⟩

theorem normalForm_coordinates_unique
    {a d e g b f a' d' e' g' b' f' : ℚ}
    (h : normalForm a d e g b f = normalForm a' d' e' g' b' f') :
    a = a' ∧ d = d' ∧ e = e' ∧ g = g' ∧ b = b' ∧ f = f' := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · have hentry := congrFun (congrFun h 0) 0
    simpa [normalForm] using hentry
  · have hentry := congrFun (congrFun h 1) 1
    simpa [normalForm] using hentry
  · have hentry := congrFun (congrFun h 2) 2
    simpa [normalForm] using hentry
  · have hentry := congrFun (congrFun h 3) 3
    simpa [normalForm] using hentry
  · have hentry := congrFun (congrFun h 0) 1
    simpa [normalForm] using hentry
  · have hentry := congrFun (congrFun h 2) 3
    simpa [normalForm] using hentry

set_option maxRecDepth 4000 in
/-- Exact diagonalization of the adjoint-induced quadratic form into four
positive square directions and two negative directions weighted by `-2`. -/
theorem normalForm_gram (a d e g b f : ℚ) :
    kreinGram (normalForm a d e g b f) (normalForm a d e g b f)
      = a ^ 2 + d ^ 2 + e ^ 2 + g ^ 2 - 2 * b ^ 2 - 2 * f ^ 2 := by
  simp only [kreinGram, kadj, normalForm, eta, Matrix.trace, Matrix.diag,
    Matrix.mul_apply, Fin.sum_univ_four, Matrix.transpose_apply,
    Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val]
  ring

theorem diagonal_sector_nonnegative (a d e g : ℚ) :
    0 ≤ kreinGram (normalForm a d e g 0 0) (normalForm a d e g 0 0) := by
  rw [normalForm_gram]
  nlinarith [sq_nonneg a, sq_nonneg d, sq_nonneg e, sq_nonneg g]

theorem diagonal_sector_zero_iff (a d e g : ℚ) :
    kreinGram (normalForm a d e g 0 0) (normalForm a d e g 0 0) = 0 ↔
      a = 0 ∧ d = 0 ∧ e = 0 ∧ g = 0 := by
  rw [normalForm_gram]
  constructor
  · intro h
    refine ⟨?_, ?_, ?_, ?_⟩ <;>
      nlinarith [sq_nonneg a, sq_nonneg d, sq_nonneg e, sq_nonneg g]
  · rintro ⟨rfl, rfl, rfl, rfl⟩
    ring

theorem negative_plane_gram (b f : ℚ) :
    kreinGram (normalForm 0 0 0 0 b f) (normalForm 0 0 0 0 b f) =
      -2 * (b ^ 2 + f ^ 2) := by
  rw [normalForm_gram]
  ring

theorem negative_plane_strict {b f : ℚ} (h : b ≠ 0 ∨ f ≠ 0) :
    kreinGram (normalForm 0 0 0 0 b f) (normalForm 0 0 0 0 b f) < 0 := by
  rw [negative_plane_gram]
  rcases h with hb | hf
  · have hsquare : 0 < b ^ 2 := by positivity
    nlinarith [sq_nonneg f]
  · have hsquare : 0 < f ^ 2 := by positivity
    nlinarith [sq_nonneg b]

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelKreinSectorSignature.even_selfadjoint_exists_normalForm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms even_selfadjoint_exists_normalForm

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelKreinSectorSignature.normalForm_coordinates_unique' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalForm_coordinates_unique

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelKreinSectorSignature.normalForm_gram' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalForm_gram

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelKreinSectorSignature.diagonal_sector_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms diagonal_sector_zero_iff

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelKreinSectorSignature.negative_plane_strict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms negative_plane_strict

end PhysicsSM.Draft.NullEdge.ChannelKreinSectorSignature
