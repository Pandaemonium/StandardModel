import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
import PhysicsSM.Draft.NullEdge.MasslessBlochCrossingClassification
import PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner

/-!
# Scalar `Z2^3` flavour-cover intertwiner

For the live successive-axis `3+1` split symbol, translating any momentum axis
by `pi` multiplies the complete step by `-1`.  The eight-sheet pullback
therefore acts only through the scalar parity character of the flavour label.
Even sheets preserve zero quasienergy; odd sheets exchange zero and pi.

This is an exact diagnosis, not a de-aliasing theorem.  The cover relabels all
eight corner copies and removes no physical multiplicity.  The half-period
negative control proves that the deck period is load-bearing.

Provenance: clean-room specialization of the covering strategy discussed by
Bakircioglu, Arnault, and Arrighi (arXiv:2505.07900).  Proofs completed by
Aristotle project `fddb28cc-3bb4-4cb3-a5e3-8b504fc91f29`, task
`15a4a58a-92f0-4fbf-87f6-4f0c373c49cc`; no external code was copied.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine

open PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
open PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner

/-- Translation by the pi-sheet selected by a flavour label. -/
def tau (f : Flavour) (q : Fin 3 → ℝ) : Fin 3 → ℝ :=
  fun j => q j + Real.pi * (f j).val

theorem factor_pi_shift (q : ℝ) (g : Mat4) :
    factor (q + Real.pi) g = -factor q g := by
  ext i j
  simp +decide [factor, Real.cos_add, Real.sin_add]
  ring

theorem splitStep_pi_shift_axis0 (qx qy qz : ℝ) :
    splitStep (qx + Real.pi) qy qz 0 1 = -splitStep qx qy qz 0 1 := by
  simp [splitStep, factor_pi_shift]

theorem splitStep_pi_shift_axis1 (qx qy qz : ℝ) :
    splitStep qx (qy + Real.pi) qz 0 1 = -splitStep qx qy qz 0 1 := by
  unfold splitStep
  simp +decide [mul_assoc, factor_pi_shift]

theorem splitStep_pi_shift_axis2 (qx qy qz : ℝ) :
    splitStep qx qy (qz + Real.pi) 0 1 = -splitStep qx qy qz 0 1 := by
  unfold splitStep
  simp +decide [mul_assoc]
  simp +decide [factor_pi_shift]

/-- Pullback to every sheet is only a scalar parity copy. -/
theorem splitStep_cover_intertwines (q : Fin 3 → ℝ) (f : Flavour) :
    splitStep (tau f q 0) (tau f q 1) (tau f q 2) 0 1 =
      (chi f : ℂ) • splitStep (q 0) (q 1) (q 2) 0 1 := by
  unfold chi tau splitStep
  fin_cases f <;> simp +decide
  all_goals simp +decide [List.Pi.cons, Multiset.Pi.cons]
  all_goals simp +decide [ZMod.cast, ZMod.val]
  all_goals simp +decide [factor_pi_shift, mul_assoc]

/-- Even sheets preserve the zero determinant and odd sheets exchange zero
with pi quasienergy. -/
theorem cover_det_alias (q : Fin 3 → ℝ) (f : Flavour) :
    (splitStep (tau f q 0) (tau f q 1) (tau f q 2) 0 1 - 1).det =
      (if Even (f 0 + f 1 + f 2).val
        then (splitStep (q 0) (q 1) (q 2) 0 1 - 1).det
        else (splitStep (q 0) (q 1) (q 2) 0 1 + 1).det) := by
  split_ifs
  · rw [splitStep_cover_intertwines]
    rw [show (chi f : ℂ) = 1 by
      have hchi : (chi f : ℤ) = 1 := by
        apply Even.neg_one_pow ‹Even (f 0 + f 1 + f 2).val›
      rw [hchi]
      norm_num]
    rw [one_smul]
  · convert congr_arg Matrix.det
      (show splitStep (tau f q 0) (tau f q 1) (tau f q 2) 0 1 - 1 =
          -(splitStep (q 0) (q 1) (q 2) 0 1 + 1) from ?_) using 1
    · rw [Matrix.det_neg]
      norm_num
    · have := splitStep_cover_intertwines q f
      simp_all +decide [chi]
      abel1

/-- A one-axis pi translation is a genuine nonidentity sheet move. -/
theorem deck_nonidentity_witness :
    (splitStep Real.pi 0 0 0 1 - 1).det ≠ 0 ∧
      (splitStep 0 0 0 0 1 - 1).det = 0 := by
  unfold splitStep
  norm_num
  unfold factor
  norm_num [Matrix.det_succ_row_zero]
  erw [show (2 : Matrix (Fin 4) (Fin 4) ℂ) =
      fun i j => if i = j then 2 else 0 by
    ext i j
    fin_cases i <;> fin_cases j <;> rfl]
  simp +decide [Fin.sum_univ_succ]

/-- Pi/2 is not a valid scalar deck period. -/
theorem wrongCover_halfperiod_not_scalar :
    ¬ ∃ c : ℂ, splitStep (Real.pi / 2) 0 0 0 1 =
      c • splitStep 0 0 0 0 1 := by
  unfold splitStep
  norm_num [← Matrix.ext_iff, Fin.forall_fin_succ, alpha1, alpha2, alpha3, beta, factor]

/-! ## Assumption-footprint audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine.splitStep_cover_intertwines' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms splitStep_cover_intertwines

/-- info: 'PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine.cover_det_alias' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cover_det_alias

/-- info: 'PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine.wrongCover_halfperiod_not_scalar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wrongCover_halfperiod_not_scalar

end PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine
