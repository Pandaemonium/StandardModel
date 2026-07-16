import Mathlib

open Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry

abbrev Coframe (n : Type*) := Matrix n n ℚ

def Nondegenerate {n : Type*} [Fintype n] [DecidableEq n]
    (e : Coframe n) : Prop :=
  e.det ≠ 0

def inducedMetric {n : Type*} [Fintype n]
    (eta e : Matrix n n ℚ) : Matrix n n ℚ :=
  eᵀ * eta * e

def transformCoframe {n : Type*} [Fintype n]
    (g e : Matrix n n ℚ) : Matrix n n ℚ :=
  g * e

theorem inducedMetric_frame_invariant {n : Type*} [Fintype n]
    (eta g e : Matrix n n ℚ) (hLorentz : gᵀ * eta * g = eta) :
    inducedMetric eta (transformCoframe g e) = inducedMetric eta e := by
  unfold inducedMetric transformCoframe
  rw [transpose_mul,
    show eᵀ * gᵀ * eta * (g * e) = eᵀ * (gᵀ * eta * g) * e by
      noncomm_ring,
    hLorentz]

end PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry

namespace PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary

def eta4 : Matrix (Fin 4) (Fin 4) ℚ :=
  !![1, 0, 0, 0;
     0, -1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, -1]

def boost4 : Matrix (Fin 4) (Fin 4) ℚ :=
  !![5 / 3, 4 / 3, 0, 0;
     4 / 3, 5 / 3, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, 1]

def boost4Inv : Matrix (Fin 4) (Fin 4) ℚ :=
  !![5 / 3, -4 / 3, 0, 0;
     -4 / 3, 5 / 3, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, 1]

theorem boost4_inverse :
    boost4Inv * boost4 = 1 ∧ boost4 * boost4Inv = 1 := by
  constructor <;>
    ext i j <;>
    fin_cases i <;> fin_cases j <;>
    simp [boost4Inv, boost4, Matrix.mul_apply, Fin.sum_univ_four] <;>
    norm_num

theorem boost4_lorentz : boost4ᵀ * eta4 * boost4 = eta4 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [boost4, eta4, Matrix.mul_apply, Fin.sum_univ_four] <;>
    norm_num

theorem boost4_ne_one : boost4 ≠ 1 := by
  intro h
  have h01 := congrFun (congrFun h 0) 1
  simp [boost4] at h01

theorem boost4_nondegenerate :
    PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate boost4 := by
  unfold PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate
  have hdet : boost4Inv.det * boost4.det = 1 := by
    rw [← Matrix.det_mul, boost4_inverse.1, Matrix.det_one]
  exact right_ne_zero_of_mul_eq_one hdet

theorem metric_does_not_fix_coframe_witness :
    ∃ (eta e e' : Matrix (Fin 4) (Fin 4) ℚ),
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate e ∧
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate e' ∧
      e' ≠ e ∧
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.inducedMetric eta e' =
        PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.inducedMetric eta e := by
  refine ⟨eta4, 1, boost4, ?_, boost4_nondegenerate, boost4_ne_one, ?_⟩
  · simp [PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.Nondegenerate]
  · simpa [PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.transformCoframe] using
      PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.inducedMetric_frame_invariant
        eta4 boost4 (1 : Matrix (Fin 4) (Fin 4) ℚ) boost4_lorentz

def vectorConjugation
    (S SInv X : Matrix (Fin 2) (Fin 2) ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  S * X * SInv

def spinorAction
    (S : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ) : Fin 2 -> ℂ :=
  S *ᵥ psi

theorem vectorConjugation_neg
    (S SInv X : Matrix (Fin 2) (Fin 2) ℂ) :
    vectorConjugation (-S) (-SInv) X = vectorConjugation S SInv X := by
  unfold vectorConjugation
  noncomm_ring

theorem spinorAction_neg
    (S : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ) :
    spinorAction (-S) psi = -spinorAction S psi := by
  ext i
  simp [spinorAction, Matrix.mulVec]
  ring

def spinIdentity : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, 1]

def up : Fin 2 -> ℂ := ![1, 0]

theorem spinIdentity_and_neg_det :
    spinIdentity.det = 1 ∧ (-spinIdentity).det = 1 := by
  constructor
  · simp [spinIdentity, Matrix.det_fin_two]
  · rw [Matrix.det_neg]
    simp [spinIdentity, Matrix.det_fin_two]

theorem spinIdentity_inverse : spinIdentity * spinIdentity = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [spinIdentity, Matrix.mul_apply, Fin.sum_univ_two]

theorem negSpinIdentity_inverse : (-spinIdentity) * (-spinIdentity) = 1 := by
  rw [neg_mul_neg, spinIdentity_inverse]

theorem spinIdentity_action_up : spinorAction spinIdentity up = up := by
  ext i
  fin_cases i <;>
    norm_num [spinorAction, spinIdentity, up, Matrix.mulVec, Fin.sum_univ_two]

theorem negSpinIdentity_action_up : spinorAction (-spinIdentity) up = -up := by
  rw [spinorAction_neg, spinIdentity_action_up]

theorem spinIdentity_actions_ne :
    spinorAction (-spinIdentity) up ≠ spinorAction spinIdentity up := by
  rw [negSpinIdentity_action_up, spinIdentity_action_up]
  intro h
  have h0 := congrFun h 0
  change -(up 0) = up 0 at h0
  norm_num [up] at h0

theorem spinLift_sign_witness :
    ∃ (S SInv : Matrix (Fin 2) (Fin 2) ℂ) (psi : Fin 2 -> ℂ),
      S.det = 1 ∧
      (-S).det = 1 ∧
      SInv * S = 1 ∧
      S * SInv = 1 ∧
      (-SInv) * (-S) = 1 ∧
      (-S) * (-SInv) = 1 ∧
      (∀ X, vectorConjugation (-S) (-SInv) X =
        vectorConjugation S SInv X) ∧
      spinorAction (-S) psi ≠ spinorAction S psi := by
  exact ⟨spinIdentity, spinIdentity, up,
    spinIdentity_and_neg_det.1, spinIdentity_and_neg_det.2,
    spinIdentity_inverse, spinIdentity_inverse,
    negSpinIdentity_inverse, negSpinIdentity_inverse,
    fun X => vectorConjugation_neg spinIdentity spinIdentity X,
    spinIdentity_actions_ne⟩

end PhysicsSM.Draft.NullEdge.TetradSpinReconstructionBoundary
