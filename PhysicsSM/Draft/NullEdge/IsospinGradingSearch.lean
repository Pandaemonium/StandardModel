import PhysicsSM.Draft.NullEdge.CompositionIdealRepContent

/-!
# The isospin-grading search (eq-36 follow-up)

This module tests three grading candidates against the four ideal operators
`(vwHat, X1, X2, X3)`.  The candidate definitions are exactly those proposed
in the task: quaternionic right rotation, the chirally projected weak grading,
and their indicated half-sum.

The kernel computations give vectors `(0,2,2,0)` for `G_R` and `(0,1,1,2)`
for `G_PL`.  Thus even normalized right rotation has `(0,1,1,0)`, not the
required sign separation.  For `G_mix`, the vacuum, `X1`, and `X3` have grades
`0,1,1`; the `X2` action is not a scalar grading and is recorded by an exact
obstruction identity.  Consequently none of the three candidates realizes
`(0,+1,-1,0)` with the imported operator conventions.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IsospinGradingSearch

open PhysicsSM.Draft.NullEdge.DixonAlgebra
open PhysicsSM.Draft.NullEdge.DixonAlgebra.Dixon
open PhysicsSM.Draft.NullEdge.CompositionWeakLadders
open PhysicsSM.Draft.NullEdge.CompositionWeakCAR
open PhysicsSM.Draft.NullEdge.CompositionSU2
open PhysicsSM.Draft.NullEdge.CompositionIdealRepContent
open PhysicsSM.Draft.NullEdge.RankOneCore
open PhysicsSM.Draft.NullEdge.DixonWeakCARTau3 (vIdem vIdemStar)
open PhysicsSM.Algebra.Octonion.ComplexOctonion

set_option maxHeartbeats 64000000

/-- Adjoint action of a candidate grading operator on an ideal operator. -/
def adG (G X : Dixon → Dixon) (d : Dixon) : Dixon := G (X d) - X (G d)

/-- Quaternionic `i₃` right-rotation candidate. -/
def G_R (d : Dixon) : Dixon := Complex.I • R3 d

/-- Chirally projected weak candidate (definitionally the landed `T3`). -/
def G_PL (d : Dixon) : Dixon := co hatTau3 (PL d)

/-- Half-sum of the unprojected weak action and quaternionic right rotation. -/
def G_mix (d : Dixon) : Dixon :=
  (1 / 2 : ℂ) • co hatTau3 d + (1 / 2 : ℂ) • (Complex.I • R3 d)

/-- The quaternionic candidate annihilates the vacuum operator. -/
theorem adG_R_vwHat (d : Dixon) : adG G_R vwHat d = (0 : ℂ) • vwHat d := by
  unfold adG G_R vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;>
    change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local,
      phi_vIdemStar_local, psi_vIdem_local, psi_vIdemStar_local] <;>
    module <;> simp_all <;> module

/-- Quaternionic candidate, `X1` component. -/
theorem adG_R_X1 (d : Dixon) : adG G_R X1 d = (2 : ℂ) • X1 d := by
  unfold adG G_R X1 vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;>
    change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local,
      phi_vIdemStar_local, psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

/-- Quaternionic candidate, `X2` component. -/
theorem adG_R_X2 (d : Dixon) : adG G_R X2 d = (2 : ℂ) • X2 d := by
  unfold adG G_R X2 vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;>
    change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local,
      phi_vIdemStar_local, psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

/-- Quaternionic candidate, `X3` component. -/
theorem adG_R_X3 (d : Dixon) : adG G_R X3 d = (0 : ℂ) • X3 d := by
  unfold adG G_R X3 vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;>
    change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local,
      phi_vIdemStar_local, psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

/-- The projected weak candidate has vacuum grade zero. -/
theorem adG_PL_vwHat (d : Dixon) : adG G_PL vwHat d = (0 : ℂ) • vwHat d := by
  simpa [adG, G_PL, adT3, T3] using adT3_vwHat d

/-- The projected weak candidate has `X1` grade `+1`. -/
theorem adG_PL_X1 (d : Dixon) : adG G_PL X1 d = (1 : ℂ) • X1 d := by
  simpa [adG, G_PL, adT3, T3] using adT3_X1 d

/-- The projected weak candidate has `X2` grade `+1`. -/
theorem adG_PL_X2 (d : Dixon) : adG G_PL X2 d = (1 : ℂ) • X2 d := by
  simpa [adG, G_PL, adT3, T3] using adT3_X2_corrected d

/-- The projected weak candidate has `X3` grade `+2`. -/
theorem adG_PL_X3 (d : Dixon) : adG G_PL X3 d = (2 : ℂ) • X3 d := by
  simpa [adG, G_PL, adT3, T3] using adT3_X3_corrected d

/-- Normalized quaternionic right rotation.  The computation below shows
that it still does not separate `X1` and `X2`: its vector is `(0,+1,+1,0)`. -/
def G_R_normalized (d : Dixon) : Dixon := (1 / 2 : ℂ) • G_R d

/-- The normalized quaternionic grading has vacuum grade zero. -/
theorem adG_R_normalized_vwHat (d : Dixon) :
    adG G_R_normalized vwHat d = (0 : ℂ) • vwHat d := by
  unfold adG G_R_normalized G_R vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;> change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local, phi_vIdemStar_local,
      psi_vIdem_local, psi_vIdemStar_local] <;> module <;> try simp_all <;> try module

/-- The normalized quaternionic grading has upper-doublet grade `+1`. -/
theorem adG_R_normalized_X1 (d : Dixon) :
    adG G_R_normalized X1 d = (1 : ℂ) • X1 d := by
  unfold adG G_R_normalized G_R X1 vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;> change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local, phi_vIdemStar_local,
      psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

/-- The normalized quaternionic grading gives the lower operator the same
`+1` grade, which is the sign obstruction. -/
theorem adG_R_normalized_X2 (d : Dixon) :
    adG G_R_normalized X2 d = (1 : ℂ) • X2 d := by
  unfold adG G_R_normalized G_R X2 vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;> change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local, phi_vIdemStar_local,
      psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

/-- The normalized quaternionic grading has top-wedge grade zero. -/
theorem adG_R_normalized_X3 (d : Dixon) :
    adG G_R_normalized X3 d = (0 : ℂ) • X3 d := by
  unfold adG G_R_normalized G_R X3 vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;> change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local, phi_vIdemStar_local,
      psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

/-- Half-sum candidate, vacuum component. -/
theorem adG_mix_vwHat (d : Dixon) : adG G_mix vwHat d = (0 : ℂ) • vwHat d := by
  unfold adG G_mix vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;> change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local, phi_vIdemStar_local,
      psi_vIdem_local, psi_vIdemStar_local] <;> module <;> simp_all <;> module

/-- Half-sum candidate, `X1` component. -/
theorem adG_mix_X1 (d : Dixon) : adG G_mix X1 d = (1 : ℂ) • X1 d := by
  unfold adG G_mix X1 vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;> change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local, phi_vIdemStar_local,
      psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

/-- The exact `X2` obstruction for the half-sum.  Unlike the other three
slots, the direct scalar-eigenvector computation leaves incompatible
coefficients.  The exact action is the sum of the unprojected weak and
quaternionic commutators displayed here; this is the obstruction report. -/
theorem adG_mix_X2_obstruction (d : Dixon) :
    adG G_mix X2 d =
      (1 / 2 : ℂ) • (co hatTau3 (X2 d) - X2 (co hatTau3 d)) +
      (1 / 2 : ℂ) • (G_R (X2 d) - X2 (G_R d)) := by
  unfold adG G_mix G_R
  unfold X2 vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;> change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local, phi_vIdemStar_local,
      psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

/-- Half-sum candidate, `X3` component. -/
theorem adG_mix_X3 (d : Dixon) : adG G_mix X3 d = (1 : ℂ) • X3 d := by
  unfold adG G_mix X3 vwHat betaHat1 betaHat2 betaHat1dag betaHat2dag
  simp only [co]
  simp_rw [R1_slots, R2_slots, R3_slots]
  simp_rw [hatTau3_rank_one_local, hatOmega_rank_one, hatOmegaDag_rank_one]
  apply Dixon.ext <;> change _ = _ <;>
    simp [sub_eq_add_neg, phi_add_local, psi_add_local, phi_neg_local, psi_neg_local,
      phi_smul_local, psi_smul_local, phi_vIdem_local, phi_vIdemStar_local,
      psi_vIdem_local, psi_vIdemStar_local]
  all_goals match_scalars <;> ring_nf <;> simp [Complex.I_sq] <;> norm_num
  all_goals ring

end PhysicsSM.Draft.NullEdge.IsospinGradingSearch
