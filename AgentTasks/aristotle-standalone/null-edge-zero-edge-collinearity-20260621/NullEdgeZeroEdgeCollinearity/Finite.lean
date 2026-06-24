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
  constructor
  · intro h
    by_cases hz : AllZero psi
    · left; exact hz
    · right
      unfold AllZero at hz
      push_neg at hz
      obtain ⟨base, hbase_ne⟩ := hz
      have hbase : psi base 0 ≠ 0 ∨ psi base 1 ≠ 0 := by
        by_contra hc
        push_neg at hc
        apply hbase_ne
        ext i
        fin_cases i
        · exact hc.1
        · exact hc.2
      refine ⟨base, hbase, ?_⟩
      exact (pairwise_wedge_zero_iff_common_direction psi base hbase).mp h
  · rintro (hz | hdir)
    · intro i j
      have h1 := hz i
      have h2 := hz j
      rw [h1, h2]
      simp [spinorWedge]
    · obtain ⟨base, hbase, c, hc⟩ := hdir
      exact all_smul_implies_pairwise_wedge_zero psi base c hc

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
    pair_terms_zero_iff_pairwise]
  exact pairwise_wedge_zero_iff_all_zero_or_common_direction psi


end NullEdgeZeroEdgeCollinearity

end
