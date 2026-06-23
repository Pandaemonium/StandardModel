import Mathlib.Tactic

/-!
# Higgs Mexican-hat potential: positivity and the symmetry-breaking minimum

The real Higgs potential `V(phi) = lambda (phi^2 - v^2)^2` is nonnegative for
`lambda >= 0` and attains its minimum exactly on the symmetry-breaking vacuum
manifold `phi^2 = v^2`. The kernel-checked anchor for electroweak symmetry
breaking on the Standard-Model side of the program.

Standalone (Mathlib only).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeHiggsPotential

/-- Real Higgs (Mexican-hat) potential. -/
def V (lam v phi : Real) : Real := lam * (phi ^ 2 - v ^ 2) ^ 2

/-- The potential is nonnegative for nonnegative coupling. -/
theorem V_nonneg (lam v phi : Real) (hl : 0 ≤ lam) : 0 ≤ V lam v phi := by
  exact mul_nonneg hl (sq_nonneg _)

/-- For positive coupling, the potential vanishes exactly on the
symmetry-breaking vacuum manifold `phi^2 = v^2`. -/
theorem V_zero_iff (lam v phi : Real) (hl : 0 < lam) :
    V lam v phi = 0 ↔ phi ^ 2 = v ^ 2 := by
  unfold V
  grind +qlia

end PhysicsSM.Draft.NullEdgeHiggsPotential
