import PhysicsSM.Draft.NullEdge.CommutatorRegulator
import PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge

/-!
# Mixed second derivative of the exact unitary commutator

The exact trigonometric group commutator has identity value and zero complete
first derivative at the origin. Its first nontrivial mixed derivative is the
Lie coefficient `G*A-A*G`. This target makes that analytic statement exact.
-/

open Matrix Complex

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CommutatorMixedDerivative

open PhysicsSM.Draft.NullEdge.CommutatorRegulator

abbrev M4 := Matrix (Fin 4) (Fin 4) Complex
abbrev V2 := Real × Real

def trigRegulator (A G : M4) (x : V2) : M4 :=
  regulator (Real.cos x.1) (Real.sin x.1)
    (Real.cos x.2) (Real.sin x.2) A G

def eP : V2 := (1, 0)
def eQ : V2 := (0, 1)

noncomputable def lieCoefficient (A G : M4) : M4 := G * A - A * G

theorem trigRegulator_origin (A G : M4) :
    trigRegulator A G (0, 0) = 1 := by
  sorry

/-- The complete Frechet first derivative vanishes, not merely two selected
entrywise derivatives. -/
theorem trigRegulator_fderiv_origin (A G : M4) :
    fderiv Real (trigRegulator A G) (0, 0) = 0 := by
  sorry

/-- The q-derivative of the p-directional derivative is the Lie coefficient. -/
theorem trigRegulator_mixed_fderiv_origin (A G : M4) :
    fderiv Real
      (fun x : V2 => fderiv Real (trigRegulator A G) x eP)
      (0, 0) eQ = lieCoefficient A G := by
  sorry

noncomputable def liveA : M4 :=
  PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.alpha1

noncomputable def liveG : M4 :=
  PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.beta

/-- Mandatory nondegenerate live fixture. -/
theorem live_mixed_fderiv_ne_zero :
    fderiv Real
      (fun x : V2 => fderiv Real (trigRegulator liveA liveG) x eP)
      (0, 0) eQ ≠ 0 := by
  sorry

/-- Negative control: repeated generators have zero mixed coefficient. -/
theorem repeated_generator_mixed_fderiv_zero (A : M4) :
    fderiv Real
      (fun x : V2 => fderiv Real (trigRegulator A A) x eP)
      (0, 0) eQ = 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.CommutatorMixedDerivative
