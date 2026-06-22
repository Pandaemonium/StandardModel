import PhysicsSM.Spinor.PluckerMass

noncomputable section

namespace NullEdgeZeroEdgeCollinearity

open PhysicsSM.Spinor.PluckerMass

/-- Every visible spinor in the finite bundle is zero. -/
def AllZero {n : Nat} (psi : Fin n -> CSpinor) : Prop :=
  ∀ i : Fin n, psi i = 0

/--
The bundle has a common nonzero projective direction: one nonzero base spinor
spans all visible spinors.
-/
def HasNonzeroCommonDirection {n : Nat} (psi : Fin n -> CSpinor) : Prop :=
  ∃ base : Fin n,
    (psi base 0 ≠ 0 ∨ psi base 1 ≠ 0) ∧
      ∃ c : Fin n -> ℂ, ∀ i : Fin n, psi i = c i • psi base

/--
Total zero-edge collinearity criterion, including the degenerate all-zero
bundle case.
-/
theorem pairwise_wedge_zero_iff_all_zero_or_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) :
    PairwiseWedgeZero psi ↔
      AllZero psi ∨ HasNonzeroCommonDirection psi := by
  sorry

/--
The finite bundle determinant vanishes exactly when the visible spinors are all
zero or share a common nonzero projective direction.
-/
theorem fin_bundle_mass_zero_iff_all_zero_or_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = 0 ↔
      AllZero psi ∨ HasNonzeroCommonDirection psi := by
  sorry

end NullEdgeZeroEdgeCollinearity

end
