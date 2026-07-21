import PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density

/-!
# Point sampling does not descend to `L2`

The landed center sampler is correct on compact-support Lipschitz functions,
but point evaluation is not an operation on an `L2` equivalence class.  A unit
spike at a cell center is zero almost everywhere and is nevertheless sampled
with value one.  The module also supplies the first exact controls for the
normalized cell-average replacement.

Provenance: theorem architecture by Codex; proofs completed by Aristotle
project `2bd9af0c-e60b-4e09-97ac-884eab04976c`, task
`9b1be343-b604-4d1d-b972-779d730c4892`, and independently integrated on
July 12, 2026.  This proves the representative-level obstruction and one-cell
average controls, not yet an `L2` contraction or strong projection limit.
-/

noncomputable section

open scoped ENNReal
open MeasureTheory Set

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumPointSamplerNoGo

open ChangingMomentumCellIsometry ChangingMomentumCellSampling

/-- A unit spike supported at one momentum point. -/
def pointSpike (c : Momentum3) : Momentum3 → Complex :=
  ({c} : Set Momentum3).indicator (fun _ => 1)

theorem pointSpike_ae_zero (c : Momentum3) :
    pointSpike c =ᵐ[volume] (0 : Momentum3 → Complex) := by
  unfold pointSpike
  apply Set.indicator_ae_eq_zero.2
  exact measure_mono_null Set.inter_subset_left (measure_singleton c)

/-- Center sampling sees the measure-zero spike with full amplitude. -/
theorem sampleFinite_pointSpike_center {h : Real} (hh : 0 < h) (k : Mode3) :
    sampleFinite h {k} (pointSpike (cellCenter h k)) (cellCenter h k) = 1 := by
  rw [sampleFinite_eq_center hh {k} _ (Finset.mem_singleton_self k) (cellCenter_mem hh k)]
  simp [pointSpike, Set.indicator_of_mem]

theorem sampleFinite_zero_center {h : Real} (hh : 0 < h) (k : Mode3) :
    sampleFinite h {k} (0 : Momentum3 → Complex) (cellCenter h k) = 0 := by
  rw [sampleFinite_eq_center hh {k} _ (Finset.mem_singleton_self k) (cellCenter_mem hh k)]
  rfl

/-- The point sampler is not invariant under almost-everywhere equality and
therefore cannot define an operator on `L2` equivalence classes. -/
theorem sampleFinite_not_ae_invariant {h : Real} (hh : 0 < h) (k : Mode3) :
    ∃ f g : Momentum3 → Complex,
      f =ᵐ[volume] g ∧
      sampleFinite h {k} f (cellCenter h k) ≠
        sampleFinite h {k} g (cellCenter h k) := by
  refine ⟨pointSpike (cellCenter h k), 0, pointSpike_ae_zero _, ?_⟩
  rw [sampleFinite_pointSpike_center hh, sampleFinite_zero_center hh]
  norm_num

/-- Normalized average over one momentum cell. -/
def cellAverage (h : Real) (k : Mode3)
    (f : Momentum3 → Complex) : Complex :=
  (volume (momentumCell h k)).toReal⁻¹ •
    ∫ x in momentumCell h k, f x

/-- Cell averaging, unlike point sampling, respects `L2` representatives. -/
theorem cellAverage_congr_ae {h : Real} {k : Mode3}
    {f g : Momentum3 → Complex} (hfg : f =ᵐ[volume] g) :
    cellAverage h k f = cellAverage h k g := by
  unfold cellAverage
  rw [MeasureTheory.integral_congr_ae (ae_restrict_of_ae hfg)]

theorem cellAverage_pointSpike_zero {h : Real} (k : Mode3) :
    cellAverage h k (pointSpike (cellCenter h k)) = 0 := by
  rw [cellAverage_congr_ae (pointSpike_ae_zero _)]
  simp [cellAverage]

/-- Nondegenerate normalization control for positive cell size. -/
theorem cellAverage_const_one {h : Real} (hh : 0 < h) (k : Mode3) :
    cellAverage h k (fun _ => (1 : Complex)) = 1 := by
  unfold cellAverage
  rw [MeasureTheory.setIntegral_const, MeasureTheory.measureReal_def, smul_smul,
    volume_momentumCell_toReal hh k, inv_mul_cancel₀ (by positivity), one_smul]

/-! ## Assumption-footprint audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumPointSamplerNoGo.sampleFinite_not_ae_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sampleFinite_not_ae_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumPointSamplerNoGo.cellAverage_congr_ae' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cellAverage_congr_ae

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumPointSamplerNoGo.cellAverage_const_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cellAverage_const_one

end PhysicsSM.Draft.NullEdge.ChangingMomentumPointSamplerNoGo
