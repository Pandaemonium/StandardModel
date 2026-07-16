import PhysicsSM.Draft.NullEdge.ExactFlowCellSampleEnergy

/-!
# Handoff target: actual intra-cell exact-multiplier L2 integral

This is the next `CONT-MULT-001` gate after the landed arbitrary-sample theorem.
It defines the continuously varying exact-flow error inside each physical
momentum cell, with the exact reciprocal-square-root-volume normalization, and
asks for the global cell-integral bound and limit.

The mathematical bound is already available pointwise from
`exactFlow_cellCenter_norm_le`; the expected blocker is the Mathlib
measurability/integrability and disjoint-cell set-integral API. Do not replace
this target by a finite sample or assumed integrability theorem: the finite
sample theorem is already landed in `ExactFlowCellSampleEnergy`.
-/

noncomputable section

open scoped BigOperators ENNReal Matrix.Norms.L2Operator
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ExactFlowCellIntegral

open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling
open ChangingMomentumCellProjectionStrongScaffold
open ChangingCellScaledLiveWalk
open ScaledChangingMomentumWalk
open Compact3Plus1DiracRate
open ExactFlowMomentumLipschitz
open ExactFlowCellSampleEnergy

/-- Exact multiplier variation at a physical point, applied to the normalized
coefficient and embedded with the reciprocal square-root cell volume. -/
def exactCellVariationAt (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) (k : Mode3) (x : Momentum3) : Spinor :=
  (cellScale (physicalSpacing N) : Complex) •
    (EuclideanSpace.equiv (Fin 4) Complex).symm
      ((exactFlow (x 0) (x 1) (x 2) m t -
          exactFlow
            (cellCenter (physicalSpacing N) k 0)
            (cellCenter (physicalSpacing N) k 1)
            (cellCenter (physicalSpacing N) k 2) m t).mulVec
        (spinorCellCoefficient N F k))

/-- Piecewise exact-multiplier variation field on the finite scheduled cell
union. Cell disjointness makes the displayed sum pointwise single-valued. -/
def exactCellVariationField (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) : Momentum3 -> Spinor := fun x =>
  ∑ k ∈ scheduledModes N,
    (momentumCell (physicalSpacing N) k).indicator
      (fun x => exactCellVariationAt m t N F k x) x

/-- Continuity of one cell's untruncated multiplier error. This is the main
measurability input; no regularity hypothesis on `F` is needed because the
cell coefficient is constant in `x`. -/
theorem exactCellVariationAt_continuous
    (m t : Real) (N : Nat) (F : Momentum3 -> Spinor) (k : Mode3) :
    Continuous (exactCellVariationAt m t N F k) := by
  letI : NormedAlgebra Rat Compact3Plus1DiracRate.Mat4 :=
    NormedAlgebra.restrictScalars Rat Complex Compact3Plus1DiracRate.Mat4
  unfold exactCellVariationAt Compact3Plus1DiracRate.exactFlow
    Compact3Plus1DiracRate.H
  apply continuous_const.smul
  apply (EuclideanSpace.equiv (Fin 4) Complex).symm.continuous.comp
  fun_prop

/-- Exact disjoint-cell decomposition of the global embedded spinor energy. -/
theorem exactCellVariationField_energy_eq
    (m t : Real) (N : Nat) (F : Momentum3 -> Spinor) :
    (∫ x, ‖exactCellVariationField m t N F x‖ ^ 2) =
      ∑ k ∈ scheduledModes N,
        ∫ x in momentumCell (physicalSpacing N) k,
          ‖exactCellVariationAt m t N F k x‖ ^ 2 := by
  sorry

/-- The actual continuously varying multiplier error obeys the same global
input-energy bound as every finite sample selection. -/
theorem exactCellVariationField_energy_le
    (m t : Real) (N : Nat) (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    (∫ x, ‖exactCellVariationField m t N F x‖ ^ 2) <=
      (exactCellSampleRate t N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2) := by
  sorry

/-- **Actual intra-cell multiplier convergence.** The full embedded L2 energy
of the continuously varying exact multiplier minus its cell-center value tends
to zero for every componentwise L2 spinor field. -/
theorem exactCellVariationField_tendsto_zero
    (m t : Real) (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    Tendsto
      (fun N => ∫ x, ‖exactCellVariationField m t N F x‖ ^ 2)
      atTop (nhds 0) := by
  sorry

end PhysicsSM.Draft.NullEdge.ExactFlowCellIntegral
