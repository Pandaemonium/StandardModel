import PhysicsSM.Draft.NullEdge.FourChannelRigidityCapstone
import PhysicsSM.Draft.NullEdge.ChannelPositiveComplementDisk
import PhysicsSM.Draft.NullEdge.ChannelPositiveSectorModuli
import PhysicsSM.Draft.NullEdge.ChannelRefinementTorsor
import PhysicsSM.Draft.NullEdge.ChannelNaturalityNoGo
import PhysicsSM.Draft.NullEdge.ChannelSolderDegreeNoGo
import PhysicsSM.Draft.NullEdge.ChannelTraceSelectorNoGo
import PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily
import PhysicsSM.Draft.NullEdge.ChannelCommutatorSelectorClassification

/-!
# Channel-decomposition moduli capstone

This module composes the Paper F classification results into a single honest
boundary statement. The explicit four matrices in the landed carrier square
are linearly independent, so their coefficients are rigid once those matrices
and their coordinate readers have been chosen. That does not make the
decomposition canonical under the weaker retained structure.

The positive complements orthogonal to the three named even channels are
classified by the rational points of an open disk, and distinct disk points
give distinct strictly positive sectors containing the same named channels.
The complete fixed-total type-only refinement fibre is a torsor for zero-sum
shifts. Fully shift-invariant, raw solder-degree, componentwise-trace, finite-
valued additive, and commutator-blind scalar selectors each fail under their
displayed hypotheses. Positive quadratic costs do select unique refinements,
but different positive metrics select different points.

This is not a theorem that no physical or information-theoretic selector can
exist. It identifies exactly which extra structure a successful selector must
use and separates rigidity after a choice from canonicity of the choice.

Provenance: composition of the kernel-checked Paper F modules named in the
imports. No external implementation text is used. Lean 4.28.0.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelDecompositionModuliCapstone

open CarrierRigidity.Concrete
open ChannelKreinMetricNoGo
open ChannelKreinSectorSignature
open ChannelPositiveComplementDisk
open ChannelRefinementTorsor

/-- Distinct rational points of the open disk determine distinct strictly
positive sectors, while all three named even channels remain in both sectors.
The displayed `diskVector` is the nondegenerate separating witness. -/
theorem distinct_positive_named_sectors
    {u v u' v' : ℚ}
    (hDisk : u ^ 2 + v ^ 2 < 1)
    (hDisk' : u' ^ 2 + v' ^ 2 < 1)
    (hne : u ≠ u' ∨ v ≠ v') :
    (InTiltedSector u v apertureC ∧
      InTiltedSector u v closureC ∧
      InTiltedSector u v turnC) ∧
    (InTiltedSector u' v' apertureC ∧
      InTiltedSector u' v' closureC ∧
      InTiltedSector u' v' turnC) ∧
    (∀ m x e g : ℚ, m ≠ 0 ∨ x ≠ 0 ∨ e ≠ 0 ∨ g ≠ 0 →
      0 < kreinGram (tiltedPositive u v m x e g)
        (tiltedPositive u v m x e g)) ∧
    (∀ m x e g : ℚ, m ≠ 0 ∨ x ≠ 0 ∨ e ≠ 0 ∨ g ≠ 0 →
      0 < kreinGram (tiltedPositive u' v' m x e g)
        (tiltedPositive u' v' m x e g)) ∧
    ∃ X : N,
      InTiltedSector u v X ∧
      ¬ InTiltedSector u' v' X ∧
      0 < kreinGram X X := by
  refine ⟨named_channels_in_every_tiltedSector u v,
    named_channels_in_every_tiltedSector u' v', ?_, ?_, diskVector u v,
    diskVector_mem_tiltedSector u v, ?_, ?_⟩
  · intro m x e g hnz
    exact tiltedPositive_strict hDisk hnz
  · intro m x e g hnz
    exact tiltedPositive_strict hDisk' hnz
  · rintro ⟨m, x, e, g, hEq⟩
    rw [diskVector, tiltedPositive] at hEq
    obtain ⟨h1, h2, _h3, _h4, h5, h6⟩ :=
      normalForm_coordinates_unique hEq
    have hx : x = 1 := by linarith
    rw [hx, mul_one] at h5 h6
    rcases hne with hu | hv
    · exact hu h5
    · exact hv h6
  · rw [diskVector, normalForm_gram]
    nlinarith

/-- Complete classification of positive even self-adjoint complement rays
orthogonal to the three named channels by a unique open-disk point and nonzero
rational scale. -/
theorem positive_complement_rays_classified_by_open_disk
    (X : N) (hself : kadj X = X) (heven : Gam * X = X * Gam)
    (hA : kreinGram X apertureC = 0)
    (hC : kreinGram X closureC = 0)
    (hT : kreinGram X turnC = 0)
    (hpos : 0 < kreinGram X X) :
    ∃! q : (ℚ × ℚ) × ℚ,
      q.1.1 ^ 2 + q.1.2 ^ 2 < 1 ∧
      q.2 ≠ 0 ∧ X = q.2 • diskVector q.1.1 q.1.2 :=
  positive_named_orthogonal_normal_form X hself heven hA hC hT hpos

/-- On the live represented carrier, every fixed-total type-only refinement is
reached from every other by a unique zero-sum shift, and the fibre is never a
singleton. -/
theorem live_refinement_fibre_is_nontrivial_torsor :
    (∀ {S : N} (base target : Refinement S),
      ∃! h : ZeroSumShift N, translate h base = target) ∧
    (∀ {S : N} (base : Refinement S),
      ∃ target : Refinement S, target ≠ base) := by
  constructor
  · intro S base target
    exact existsUnique_translate base target
  · intro S base
    exact refinement_not_unique_of_nonzero base
      ChannelTraceSelectorNoGo.traceZeroDirection
      ChannelTraceSelectorNoGo.traceZeroDirection_nonzero

/-- The raw represented solder-degree requirements tested by
`ChannelSolderDegreeNoGo`. -/
def RawSolderDegreeSelectorExists : Prop :=
  ∃ S : N →+ N,
    S ChannelSolderDegreeNoGo.solderProjector =
        (2 : ℚ) • ChannelSolderDegreeNoGo.solderProjector ∧
    S (ChannelSolderDegreeNoGo.solderProjector *
        ChannelSolderDegreeNoGo.solderProjector) =
      (4 : ℚ) • (ChannelSolderDegreeNoGo.solderProjector *
        ChannelSolderDegreeNoGo.solderProjector)

/-- Three represented linear selector obstructions, stated only for the
classes actually classified by the source modules. -/
theorem represented_selector_obstruction_suite :
    ¬ RawSolderDegreeSelectorExists ∧
    (∀ {S : N},
      ¬ (∀ b c : Refinement S,
        ChannelTraceSelectorNoGo.traceProfile (difference b c) = 0 → b = c)) ∧
    (∀ f : N →ₗ[ℚ] ℚ,
      ChannelCommutatorSelectorClassification.CommutatorBlind f →
      ¬ Function.Injective f) := by
  refine ⟨ChannelSolderDegreeNoGo.no_additive_solder_degree_selector, ?_, ?_⟩
  · intro S
    exact ChannelTraceSelectorNoGo.traceProfile_does_not_rigidify
  · intro f hf
    exact ChannelCommutatorSelectorClassification.no_commutatorBlind_selector_injective f hf

/-- Strict convexity selects a unique scalar refinement after a positive
channel metric is supplied, but the result depends on that metric. -/
theorem positive_quadratic_selection_is_metric_dependent :
    (ChannelQuadraticSelectorFamily.selectedX 1 1 1 1,
        ChannelQuadraticSelectorFamily.selectedY 1 1 1 1,
        ChannelQuadraticSelectorFamily.selectedZ 1 1 1 1) =
      ((1 : ℝ) / 3, 1 / 3, 1 / 3) ∧
    (ChannelQuadraticSelectorFamily.selectedX 1 2 3 1,
        ChannelQuadraticSelectorFamily.selectedY 1 2 3 1,
        ChannelQuadraticSelectorFamily.selectedZ 1 2 3 1) =
      ((6 : ℝ) / 11, 3 / 11, 2 / 11) ∧
    (ChannelQuadraticSelectorFamily.selectedX 1 1 1 1,
        ChannelQuadraticSelectorFamily.selectedY 1 1 1 1,
        ChannelQuadraticSelectorFamily.selectedZ 1 1 1 1) ≠
      (ChannelQuadraticSelectorFamily.selectedX 1 2 3 1,
        ChannelQuadraticSelectorFamily.selectedY 1 2 3 1,
        ChannelQuadraticSelectorFamily.selectedZ 1 2 3 1) := by
  refine ⟨?_, ?_,
    ChannelQuadraticSelectorFamily.positive_quadratic_selectors_disagree⟩
  · rcases ChannelQuadraticSelectorFamily.equalWeight_selector with ⟨hx, hy, hz⟩
    simp [hx, hy, hz]
  · rcases ChannelQuadraticSelectorFamily.unequalWeight_selector with ⟨hx, hy, hz⟩
    simp [hx, hy, hz]

/-- Publication-facing classification verdict: the explicit four-channel
coordinate presentation is rigid, but its weaker positive/type-only envelope
has genuine moduli and the tested intrinsic selectors do not remove them. -/
theorem channel_decomposition_classification_verdict :
    Function.Injective
      (fun q : ℚ × ℚ × ℚ × ℚ =>
        FourChannelRigidity.channelCombination q.1 q.2.1 q.2.2.1 q.2.2.2) ∧
    (∃ X : N,
      InTiltedSector 0 0 X ∧
      ¬ InTiltedSector (1 / 2) 0 X ∧
      0 < kreinGram X X) ∧
    (∀ {S : N} (base target : Refinement S),
      ∃! h : ZeroSumShift N, translate h base = target) ∧
    ¬ RawSolderDegreeSelectorExists ∧
    (∀ {S : N},
      ¬ (∀ b c : Refinement S,
        ChannelTraceSelectorNoGo.traceProfile (difference b c) = 0 → b = c)) ∧
    (∀ f : N →ₗ[ℚ] ℚ,
      ChannelCommutatorSelectorClassification.CommutatorBlind f →
      ¬ Function.Injective f) ∧
    (ChannelQuadraticSelectorFamily.selectedX 1 1 1 1,
        ChannelQuadraticSelectorFamily.selectedY 1 1 1 1,
        ChannelQuadraticSelectorFamily.selectedZ 1 1 1 1) ≠
      (ChannelQuadraticSelectorFamily.selectedX 1 2 3 1,
        ChannelQuadraticSelectorFamily.selectedY 1 2 3 1,
        ChannelQuadraticSelectorFamily.selectedZ 1 2 3 1) := by
  have hsectors := distinct_positive_named_sectors
    (u := (0 : ℚ)) (v := 0) (u' := 1 / 2) (v' := 0)
    (by norm_num) (by norm_num) (by norm_num)
  refine ⟨FourChannelRigidity.channelCombination_injective,
    hsectors.2.2.2.2, live_refinement_fibre_is_nontrivial_torsor.1,
    represented_selector_obstruction_suite.1,
    represented_selector_obstruction_suite.2.1,
    represented_selector_obstruction_suite.2.2,
    ChannelQuadraticSelectorFamily.positive_quadratic_selectors_disagree⟩

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelDecompositionModuliCapstone.distinct_positive_named_sectors' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms distinct_positive_named_sectors

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelDecompositionModuliCapstone.positive_complement_rays_classified_by_open_disk' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_complement_rays_classified_by_open_disk

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelDecompositionModuliCapstone.channel_decomposition_classification_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms channel_decomposition_classification_verdict

end PhysicsSM.Draft.NullEdge.ChannelDecompositionModuliCapstone
