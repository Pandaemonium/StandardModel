import PhysicsSM.Spinor.PluckerMass

/-!
# Zero-edge collinearity completion

This draft module closes the degenerate case of the finite massless-collinearity
criterion from `PhysicsSM.Spinor.PluckerMass`.

The trusted theorem `fin_bundle_mass_zero_iff_common_direction` assumes a chosen
nonzero base spinor. The wrappers here remove that external choice: a vanishing
bundle determinant means either every visible spinor is zero, or the visible
spinors share a common nonzero projective direction.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeZeroEdgeCollinearity

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
  constructor
  · by_cases h : AllZero psi
    · exact fun _ => Or.inl h
    · obtain ⟨base, hbase⟩ : ∃ base : Fin n, psi base 0 ≠ 0 ∨ psi base 1 ≠ 0 := by
        contrapose! h
        exact fun i => by
          ext j
          fin_cases j <;> simp +decide [h i]
      exact fun h' =>
        Or.inr <|
          (pairwise_wedge_zero_iff_common_direction psi base hbase).1 h'
            |> fun ⟨c, hc⟩ => ⟨base, hbase, c, hc⟩
  · rintro (h | ⟨base, hbase, c, hc⟩)
    · intro i j
      simp +decide [h i, h j, spinorWedge]
    · exact all_smul_implies_pairwise_wedge_zero psi base c hc

/--
The finite bundle determinant vanishes exactly when the visible spinors are all
zero or share a common nonzero projective direction.
-/
theorem fin_bundle_mass_zero_iff_all_zero_or_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = 0 ↔
      AllZero psi ∨ HasNonzeroCommonDirection psi := by
  rw [fin_bundle_plucker_mass_identity,
    finPairwisePluckerMass_eq_zero_iff_pair_terms_zero,
    pair_terms_zero_iff_pairwise,
    pairwise_wedge_zero_iff_all_zero_or_common_direction]

end PhysicsSM.Draft.NullEdgeZeroEdgeCollinearity

end
