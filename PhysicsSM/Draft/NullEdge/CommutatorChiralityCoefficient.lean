import PhysicsSM.Draft.NullEdge.CommutatorRegulator
import PhysicsSM.Draft.NullEdge.ChiralityMixingNecessity
import PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge

/-!
# Chirality of the group-commutator Lie coefficient

This module identifies the algebraic coefficient expected at mixed second
order in a group commutator. It does not prove the analytic Taylor expansion.

Provenance: theorem statements prepared locally; proofs completed without
statement changes by Aristotle project
`88d35131-fb77-4e3b-9c83-03c26f907b6f`, task
`125bcd8d-3b1c-46d7-b8e7-09f3c1df8a57`.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.CommutatorChiralityCoefficient

abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

noncomputable def lieCoefficient (A G : M4) : M4 := G * A - A * G

theorem Xi_anticommutes_lieCoefficient
    (Xi A G : M4)
    (hA : Xi * A = A * Xi)
    (hG : Xi * G = -(G * Xi)) :
    Xi * lieCoefficient A G = -(lieCoefficient A G * Xi) := by
  unfold lieCoefficient
  have e1 : Xi * (G * A) = -((G * A) * Xi) := by
    rw [← Matrix.mul_assoc, hG, neg_mul, Matrix.mul_assoc, hA, ← Matrix.mul_assoc]
  have e2 : Xi * (A * G) = -((A * G) * Xi) := by
    rw [← Matrix.mul_assoc, hA, Matrix.mul_assoc, hG, Matrix.mul_neg, ← Matrix.mul_assoc]
  rw [Matrix.mul_sub, e1, e2, Matrix.sub_mul]
  abel

theorem perpPart_eq_self_of_anticommutes
    (Xi U : M4) (hXi : Xi * Xi = 1)
    (hanti : Xi * U = -(U * Xi)) :
    PhysicsSM.Draft.NullEdge.ChiralityMixingNecessity.perpPart Xi U = U := by
  unfold PhysicsSM.Draft.NullEdge.ChiralityMixingNecessity.perpPart
  have hfix : Xi * U * Xi = -U := by
    rw [hanti, neg_mul, Matrix.mul_assoc, hXi, Matrix.mul_one]
  rw [hfix]
  have hdbl : U - (-U) = (2 : Complex) • U := by module
  rw [hdbl, smul_smul]
  norm_num

noncomputable def liveXi : M4 :=
  PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge.Xi

def liveA : M4 :=
  PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.alpha1

def liveG : M4 :=
  PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.beta

theorem liveA_even : liveXi * liveA = liveA * liveXi := by
  unfold liveXi liveA
  exact PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge.Xi_commutes_alpha 0

theorem liveG_odd : liveXi * liveG = -(liveG * liveXi) := by
  unfold liveXi liveG
  rw [eq_neg_iff_add_eq_zero]
  exact PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge.Xi_anticommutes_beta

theorem live_lieCoefficient_odd :
    liveXi * lieCoefficient liveA liveG =
      -(lieCoefficient liveA liveG * liveXi) :=
  Xi_anticommutes_lieCoefficient liveXi liveA liveG liveA_even liveG_odd

/-- Nondegeneracy: the live even/odd Clifford pair has a genuinely nonzero Lie
coefficient. -/
theorem live_lieCoefficient_ne_zero : lieCoefficient liveA liveG ≠ 0 := by
  unfold lieCoefficient liveA liveG
  intro h
  have h03 := congrFun (congrFun h 0) 3
  simp [PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.beta,
    PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.alpha1,
    Matrix.sub_apply] at h03

theorem live_lieCoefficient_is_full_perp :
    PhysicsSM.Draft.NullEdge.ChiralityMixingNecessity.perpPart
      liveXi (lieCoefficient liveA liveG) = lieCoefficient liveA liveG :=
  perpPart_eq_self_of_anticommutes liveXi (lieCoefficient liveA liveG)
    (by unfold liveXi; exact PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge.Xi_sq)
    live_lieCoefficient_odd

/-- Negative control: commuting generators have zero Lie coefficient. -/
theorem lieCoefficient_eq_zero_of_commutes
    (A G : M4) (h : A * G = G * A) :
    lieCoefficient A G = 0 := by
  unfold lieCoefficient
  rw [h, sub_self]

end PhysicsSM.Draft.NullEdge.CommutatorChiralityCoefficient
