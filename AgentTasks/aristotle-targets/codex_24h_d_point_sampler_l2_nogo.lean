import PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density

/-!
# D-R3 no-go: point sampling does not descend to `L2`

The landed center sampler is correct on compact-support Lipschitz functions,
but point evaluation is not an operation on an `L2` equivalence class.  This
target proves the exact obstruction and supplies the normalized cell-average
replacement control.

Preserve every statement.  The point spike must remain zero almost everywhere
while sampling to one.  The cell average must remain AE-invariant and normalize
the constant-one function exactly.
-/

noncomputable section

open scoped ENNReal
open MeasureTheory Set

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumPointSamplerNoGo

open ChangingMomentumCellIsometry ChangingMomentumCellSampling

/-- A unit spike supported at one momentum point. -/
def pointSpike (c : Momentum3) : Momentum3 -> Complex :=
  ({c} : Set Momentum3).indicator (fun _ => 1)

theorem pointSpike_ae_zero (c : Momentum3) :
    pointSpike c =ᵐ[volume] (0 : Momentum3 -> Complex) := by
  sorry

/-- Center sampling sees the measure-zero spike with full amplitude. -/
theorem sampleFinite_pointSpike_center {h : Real} (hh : 0 < h) (k : Mode3) :
    sampleFinite h {k} (pointSpike (cellCenter h k)) (cellCenter h k) = 1 := by
  sorry

theorem sampleFinite_zero_center {h : Real} (hh : 0 < h) (k : Mode3) :
    sampleFinite h {k} (0 : Momentum3 -> Complex) (cellCenter h k) = 0 := by
  sorry

/-- The point sampler is not invariant under almost-everywhere equality and
therefore cannot define an operator on `L2` equivalence classes. -/
theorem sampleFinite_not_ae_invariant {h : Real} (hh : 0 < h) (k : Mode3) :
    ∃ f g : Momentum3 -> Complex,
      f =ᵐ[volume] g ∧
      sampleFinite h {k} f (cellCenter h k) ≠
        sampleFinite h {k} g (cellCenter h k) := by
  sorry

/-- Normalized average over one momentum cell. -/
def cellAverage (h : Real) (k : Mode3)
    (f : Momentum3 -> Complex) : Complex :=
  (volume (momentumCell h k)).toReal⁻¹ •
    ∫ x in momentumCell h k, f x

/-- Cell averaging, unlike point sampling, respects `L2` representatives. -/
theorem cellAverage_congr_ae {h : Real} {k : Mode3}
    {f g : Momentum3 -> Complex} (hfg : f =ᵐ[volume] g) :
    cellAverage h k f = cellAverage h k g := by
  sorry

theorem cellAverage_pointSpike_zero {h : Real} (k : Mode3) :
    cellAverage h k (pointSpike (cellCenter h k)) = 0 := by
  sorry

/-- Nondegenerate normalization control for positive cell size. -/
theorem cellAverage_const_one {h : Real} (hh : 0 < h) (k : Mode3) :
    cellAverage h k (fun _ => (1 : Complex)) = 1 := by
  sorry

end PhysicsSM.Draft.NullEdge.ChangingMomentumPointSamplerNoGo
