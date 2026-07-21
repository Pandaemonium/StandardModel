import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongL2
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.MeasureTheory.Function.L2Space
import Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import Mathlib.MeasureTheory.SpecificCodomains.Pi
import Mathlib.MeasureTheory.SpecificCodomains.WithLp

/-!
# Two-component changing-cell projection and Plancherel transport

The scalar changing-cell theorem proves strong `L2(R^3)` convergence of the
explicit normalized cell-average projection. This module lifts that theorem
to the actual two-component Weyl field used by the HNU continuum program and
then transports the projection error through Mathlib's vector-valued inverse
Fourier isometry.

This closes only the projection term in the HNU three-term continuum estimate.
It does not compare the live HNU walk with the exact Weyl multiplier, estimate
the variation of that multiplier inside a cell, or identify the position-space
Weyl PDE generator.

Provenance: clean-room finite-coordinate composition of
`ChangingMomentumCellProjectionStrongL2` with Mathlib's `Lp` and Plancherel
APIs, July 20, 2026.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.HNUChangingCellProjectionL2

open ChangingMomentumCellIsometry
open ChangingMomentumCellProjectionStrongScaffold
open ChangingMomentumCellProjectionStrongL2

/-- The two-component Euclidean spinor carried by the HNU Weyl limit. -/
abbrev WeylSpinor := EuclideanSpace Complex (Fin 2)

/-- Mathlib's Fourier transform uses the Euclidean norm on the momentum
domain. The cell code uses the same coordinates with the product sup norm, so
the measure-preserving bridge is kept explicit below. -/
abbrev FourierMomentum3 := EuclideanSpace Real (Fin 3)

/-- Apply the landed scalar cell-average projection to both Weyl coordinates. -/
def spinorProjectAt (N : Nat) (F : Momentum3 -> WeylSpinor) :
    Momentum3 -> WeylSpinor := fun x =>
  (EuclideanSpace.equiv (Fin 2) Complex).symm
    (fun j => projectAt N (fun y => F y j) x)

/-- Euclidean Weyl-spinor norm squared is the sum of its two coordinate norm
squares. -/
theorem weylSpinor_norm_sq_eq_sum (v : WeylSpinor) :
    ‖v‖ ^ 2 = ∑ j : Fin 2, ‖v j‖ ^ 2 := by
  rw [EuclideanSpace.norm_eq]
  exact Real.sq_sqrt (Finset.sum_nonneg fun _ _ => sq_nonneg _)

/-- The pointwise projection error has exactly the sum of the two scalar
coordinate energies. -/
theorem spinorProjectAt_norm_sq (N : Nat) (F : Momentum3 -> WeylSpinor)
    (x : Momentum3) :
    ‖spinorProjectAt N F x - F x‖ ^ 2 =
      ∑ j : Fin 2, ‖projectAt N (fun y => F y j) x - F x j‖ ^ 2 := by
  rw [weylSpinor_norm_sq_eq_sum]
  rfl

/-- The bundled projected representative is square-integrable whenever both
input coordinates are square-integrable. -/
theorem spinorProjectAt_memLp (N : Nat) (F : Momentum3 -> WeylSpinor) :
    MemLp (spinorProjectAt N F) 2 volume := by
  apply MemLp.of_eval_piLp
  intro j
  simpa [spinorProjectAt] using
    projectAt_memLp N (fun x => F x j)

/-- Integration commutes with the finite coordinate sum, yielding the exact
spinor projection-energy identity. -/
theorem spinorProjectAt_energy_eq (N : Nat) (F : Momentum3 -> WeylSpinor)
    (hF : ∀ j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    (∫ x, ‖spinorProjectAt N F x - F x‖ ^ 2) =
      ∑ j : Fin 2,
        ∫ x, ‖projectAt N (fun y => F y j) x - F x j‖ ^ 2 := by
  rw [integral_congr_ae (Filter.Eventually.of_forall fun x =>
    spinorProjectAt_norm_sq N F x)]
  rw [integral_finset_sum]
  intro j hj
  exact ((projectAt_memLp N (fun x => F x j)).sub (hF j)).integrable_norm_pow
    (by norm_num)

/-- **Two-component projection convergence.** The concrete refining and
exhausting cell-average projections converge strongly in squared
`L2(R^3; C^2)` error for every componentwise square-integrable Weyl field. -/
theorem spinorProjectAt_energy_tendsto_zero
    (F : Momentum3 -> WeylSpinor)
    (hF : ∀ j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    Tendsto
      (fun N => ∫ x, ‖spinorProjectAt N F x - F x‖ ^ 2)
      atTop (nhds 0) := by
  have hsum : Tendsto
      (fun N => ∑ j : Fin 2,
        ∫ x, ‖projectAt N (fun y => F y j) x - F x j‖ ^ 2)
      atTop (nhds (∑ _j : Fin 2, (0 : Real))) := by
    exact tendsto_finset_sum Finset.univ fun j _ =>
      projectAt_tendsto_strong_L2 (fun x => F x j) (hF j)
  have hsum_zero : Tendsto
      (fun N => ∑ j : Fin 2,
        ∫ x, ‖projectAt N (fun y => F y j) x - F x j‖ ^ 2)
      atTop (nhds 0) := by
    simpa using hsum
  apply hsum_zero.congr'
  exact Filter.Eventually.of_forall fun N =>
    (spinorProjectAt_energy_eq N F hF).symm

/-- The actual projection-error representative. -/
def projectionError (N : Nat) (F : Momentum3 -> WeylSpinor) :
    Momentum3 -> WeylSpinor := fun x => spinorProjectAt N F x - F x

/-- The projection error is an actual `L2` representative. -/
theorem projectionError_memLp (N : Nat) (F : Momentum3 -> WeylSpinor)
    (hF : ∀ j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    MemLp (projectionError N F) 2 volume := by
  exact (spinorProjectAt_memLp N F).sub (MemLp.of_eval_piLp hF)

/-- Bundle the projection error in momentum-space `L2`. -/
def projectionErrorLp (N : Nat) (F : Momentum3 -> WeylSpinor)
    (hF : ∀ j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    Lp WeylSpinor 2 (volume : Measure Momentum3) :=
  (projectionError_memLp N F hF).toLp (projectionError N F)

/-- The quotient-space norm squared equals the representative-level spinor
projection energy. -/
theorem projectionErrorLp_norm_sq_eq (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : ∀ j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    ‖projectionErrorLp N F hF‖ ^ 2 =
      ∫ x, ‖spinorProjectAt N F x - F x‖ ^ 2 := by
  let hf := projectionError_memLp N F hF
  rw [show projectionErrorLp N F hF = hf.toLp (projectionError N F) by rfl]
  rw [Lp.norm_toLp]
  rw [hf.eLpNorm_eq_integral_rpow_norm (by norm_num) (by norm_num)]
  simp only [ENNReal.toReal_ofNat]
  have henergy : 0 <= ∫ x, ‖projectionError N F x‖ ^ 2 :=
    integral_nonneg fun x => sq_nonneg _
  rw [ENNReal.toReal_ofReal']
  rw [max_eq_left (by positivity)]
  have hrpow_energy :
      (∫ x, ‖projectionError N F x‖ ^ (2 : Real)) =
        ∫ x, ‖projectionError N F x‖ ^ (2 : Nat) := by
    apply integral_congr_ae
    exact Filter.Eventually.of_forall fun x => Real.rpow_two _
  rw [hrpow_energy]
  exact Real.rpow_inv_natCast_pow (n := 2)
    henergy (by norm_num)

/-- Strong convergence of the genuine two-component momentum-space `L2`
projection error. -/
theorem projectionErrorLp_norm_tendsto_zero
    (F : Momentum3 -> WeylSpinor)
    (hF : ∀ j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    Tendsto (fun N => ‖projectionErrorLp N F hF‖) atTop (nhds 0) := by
  have hsq : Tendsto (fun N => ‖projectionErrorLp N F hF‖ ^ 2)
      atTop (nhds 0) := by
    apply (spinorProjectAt_energy_tendsto_zero F hF).congr'
    exact Filter.Eventually.of_forall fun N =>
      (projectionErrorLp_norm_sq_eq N F hF).symm
  have hsqrt := hsq.sqrt
  simpa [Real.sqrt_sq_eq_abs, abs_of_nonneg] using hsqrt

/-- Move the projection error to Euclidean momentum coordinates with the
explicit volume-preserving identity map. -/
def euclideanProjectionErrorLp (N : Nat) (F : Momentum3 -> WeylSpinor)
    (hF : ∀ j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    Lp WeylSpinor 2 (volume : Measure FourierMomentum3) :=
  MeasureTheory.Lp.compMeasurePreserving
    (fun x : FourierMomentum3 => WithLp.ofLp x)
    (PiLp.volume_preserving_ofLp (ι := Fin 3))
    (projectionErrorLp N F hF)

/-- The domain bridge preserves the projection-error norm. -/
theorem euclideanProjectionErrorLp_norm_eq (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : ∀ j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    ‖euclideanProjectionErrorLp N F hF‖ = ‖projectionErrorLp N F hF‖ := by
  exact Lp.norm_compMeasurePreserving _ _

/-- Reconstruct the projection error in position space with Mathlib's
vector-valued inverse Fourier isometry. -/
def positionProjectionErrorLp (N : Nat) (F : Momentum3 -> WeylSpinor)
    (hF : ∀ j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    Lp WeylSpinor 2 (volume : Measure FourierMomentum3) :=
  (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 WeylSpinor).symm
    (euclideanProjectionErrorLp N F hF)

/-- Plancherel preserves the projection-error norm exactly. -/
theorem positionProjectionErrorLp_norm_eq (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : ∀ j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    ‖positionProjectionErrorLp N F hF‖ =
      ‖euclideanProjectionErrorLp N F hF‖ := by
  exact
    (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 WeylSpinor).symm.norm_map
      (euclideanProjectionErrorLp N F hF)

/-- **Projection-term position-space capstone.** The inverse-Fourier
reconstructed two-component projection error tends strongly to zero. -/
theorem positionProjectionErrorLp_norm_tendsto_zero
    (F : Momentum3 -> WeylSpinor)
    (hF : ∀ j : Fin 2, MemLp (fun x => F x j) 2 volume) :
    Tendsto (fun N => ‖positionProjectionErrorLp N F hF‖)
      atTop (nhds 0) := by
  apply (projectionErrorLp_norm_tendsto_zero F hF).congr'
  exact Filter.Eventually.of_forall fun N =>
    ((positionProjectionErrorLp_norm_eq N F hF).trans
      (euclideanProjectionErrorLp_norm_eq N F hF)).symm

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUChangingCellProjectionL2.spinorProjectAt_energy_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spinorProjectAt_energy_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.HNUChangingCellProjectionL2.positionProjectionErrorLp_norm_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positionProjectionErrorLp_norm_tendsto_zero

end PhysicsSM.Draft.NullEdge.HNUChangingCellProjectionL2
