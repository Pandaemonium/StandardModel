import PhysicsSM.Draft.NullEdge.CommutatorRegulator
import PhysicsSM.Draft.NullEdge.ChiralityMixingNecessity
import PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge

/-!
# Chirality of the group-commutator Lie coefficient

This target identifies the algebraic coefficient expected at mixed second
order in a group commutator. It does not prove the analytic Taylor expansion.
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
  sorry

theorem perpPart_eq_self_of_anticommutes
    (Xi U : M4) (hXi : Xi * Xi = 1)
    (hanti : Xi * U = -(U * Xi)) :
    PhysicsSM.Draft.NullEdge.ChiralityMixingNecessity.perpPart Xi U = U := by
  sorry

noncomputable def liveXi : M4 :=
  PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge.Xi

def liveA : M4 :=
  PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.alpha1

def liveG : M4 :=
  PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.beta

theorem liveA_even : liveXi * liveA = liveA * liveXi := by
  sorry

theorem liveG_odd : liveXi * liveG = -(liveG * liveXi) := by
  sorry

theorem live_lieCoefficient_odd :
    liveXi * lieCoefficient liveA liveG =
      -(lieCoefficient liveA liveG * liveXi) := by
  sorry

/-- Nondegeneracy: the live even/odd Clifford pair has a genuinely nonzero Lie
coefficient. -/
theorem live_lieCoefficient_ne_zero : lieCoefficient liveA liveG ≠ 0 := by
  sorry

theorem live_lieCoefficient_is_full_perp :
    PhysicsSM.Draft.NullEdge.ChiralityMixingNecessity.perpPart
      liveXi (lieCoefficient liveA liveG) = lieCoefficient liveA liveG := by
  sorry

/-- Negative control: commuting generators have zero Lie coefficient. -/
theorem lieCoefficient_eq_zero_of_commutes
    (A G : M4) (h : A * G = G * A) :
    lieCoefficient A G = 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.CommutatorChiralityCoefficient
