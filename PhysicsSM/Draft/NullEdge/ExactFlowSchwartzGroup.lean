import PhysicsSM.Draft.NullEdge.ChangingCellFourierTemperate
import PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup

/-!
# Exact Dirac flow on Schwartz spinors

Focused Aristotle target. The harvested temperate-growth theorem supplies the
analytic hypothesis needed to lift the exact momentum multiplier from pointwise
spinors to Schwartz spinors. The target then asks for the exact zero-time and
time-addition laws at this stronger domain level.

This is a Schwartz-domain preservation and one-parameter-group theorem. It does
not identify the infinitesimal generator, transport the result through Fourier
transform, prove a position-space PDE, or establish a changing-lattice limit.

Provenance: the immutable definitions and theorem statements were prepared
in-project. Aristotle project `debcfc09-3a35-4091-be59-97335fa521bd`
returned the proofs on 2026-07-13; the exact file was replayed locally under
Lean 4.28 before this draft integration. Cross-family semantic review remains
required before manuscript promotion.
-/

noncomputable section

open Matrix Complex
open scoped SchwartzMap

namespace PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGroup

open ChangingCellScaledLiveWalk
open ChangingCellFourierL2
open ChangingCellFourierTemperate
open ExactFlowTimeGroup

/-- Four-component Schwartz spinors on momentum space. -/
abbrev SpinorSchwartz := SchwartzMap FourierMomentum3 Spinor

/-- Pointwise exact Dirac evolution, lifted continuously to Schwartz space by
the proved temperate growth of the operator-valued multiplier. -/
def exactFlowSchwartzCLM (m t : Real) :
    SpinorSchwartz →L[Complex] SpinorSchwartz :=
  SchwartzMap.bilinLeftCLM
    (ContinuousLinearMap.apply Complex Spinor)
    (momMultForGrowth_hasTemperateGrowth m t)

@[simp]
theorem exactFlowSchwartzCLM_apply_apply (m t : Real)
    (f : SpinorSchwartz) (k : FourierMomentum3) :
    exactFlowSchwartzCLM m t f k = momMultForGrowth m t k (f k) := by
  rfl

/-- At zero time, the lifted exact flow is the identity on every Schwartz
spinor, not merely pointwise on an isolated momentum fibre. -/
theorem exactFlowSchwartzCLM_zero_time (m : Real) :
    exactFlowSchwartzCLM m 0 = ContinuousLinearMap.id Complex SpinorSchwartz := by
  ext f k
  simp only [exactFlowSchwartzCLM_apply_apply, momMultForGrowth_zero_time,
    ContinuousLinearMap.id_apply]

/-- The exact Schwartz-space flow is a time-additive one-parameter group. -/
theorem exactFlowSchwartzCLM_add_time (m s t : Real) :
    exactFlowSchwartzCLM m (s + t) =
      (exactFlowSchwartzCLM m s).comp (exactFlowSchwartzCLM m t) := by
  ext f k
  have hmul : momMultForGrowth m (s + t) k
      = (momMultForGrowth m s k).comp (momMultForGrowth m t k) := by
    unfold momMultForGrowth
    rw [exactFlow_add_time, map_mul]
    rfl
  simp only [exactFlowSchwartzCLM_apply_apply, ContinuousLinearMap.comp_apply, hmul]

/-- Both elapsed-time orders cancel on Schwartz spinors. -/
theorem exactFlowSchwartzCLM_mul_neg_time (m t : Real) :
    (exactFlowSchwartzCLM m t).comp (exactFlowSchwartzCLM m (-t)) =
      ContinuousLinearMap.id Complex SpinorSchwartz := by
  rw [← exactFlowSchwartzCLM_add_time, add_neg_cancel]
  exact exactFlowSchwartzCLM_zero_time m

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGroup.exactFlowSchwartzCLM_zero_time' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlowSchwartzCLM_zero_time

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGroup.exactFlowSchwartzCLM_add_time' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlowSchwartzCLM_add_time

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGroup.exactFlowSchwartzCLM_mul_neg_time' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlowSchwartzCLM_mul_neg_time

end PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGroup
