import PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.MeasureTheory.Function.L2Space
import Mathlib.MeasureTheory.Function.LpSeminorm.LpNorm
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import Mathlib.MeasureTheory.SpecificCodomains.Pi
import Mathlib.MeasureTheory.SpecificCodomains.WithLp

/-!
# Representative-safe inverse-Fourier transport for changing-cell errors

This module packages the landed componentwise changing-cell error
as a four-component `L2` function and transports its convergence through
Mathlib's vector-valued inverse Fourier isometry.

The target intentionally does not identify a position-space PDE generator.
Mathlib's Fourier convention inserts a `2 * pi` factor in derivative symbols;
that normalization and the unbounded-generator domain belong to later F2/F3
targets.

Provenance: clean-room composition of the project's changing-cell convergence
modules with Mathlib's `Lp` and vector-valued Plancherel APIs, July 12, 2026.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingCellFourierL2

open ChangingMomentumCellIsometry
open ChangingCellScaledLiveWalk
open ChangingMomentumCellProjectionStrongScaffold
open ScaledChangingMomentumWalk

/-- Mathlib's Fourier transform requires the Euclidean `L2` norm on momentum
coordinates. The repository's `Momentum3` is the same coordinate space with
the product sup norm, so the bridge must be explicit. -/
abbrev FourierMomentum3 := EuclideanSpace Real (Fin 3)

/-- A normalized scalar cell packet is square-integrable. -/
theorem cellPacket_memLp (h : Real) (k : Mode3) (c : Complex) :
    MemLp (cellPacket h k c) 2 volume := by
  simpa [cellPacket] using
    (memLp_indicator_const (2 : ENNReal)
      (momentumCell_measurable h k) ((cellScale h : Complex) * c)
      (Or.inr (volume_momentumCell_ne_top h k)))

/-- Every finitely supported normalized cell embedding is square-integrable. -/
theorem embedFinite_memLp (h : Real) (s : Finset Mode3)
    (c : Mode3 -> Complex) :
    MemLp (embedFinite h s c) 2 volume := by
  change MemLp (fun x => ∑ k ∈ s, cellPacket h k (c k) x) 2 volume
  exact memLp_finset_sum s fun k _ => cellPacket_memLp h k (c k)

/-- Bundle the four scalar representatives into the repository's Euclidean
spinor, rather than identifying componentwise convergence verbally. -/
def embeddedErrorSpinor (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) : Momentum3 -> Spinor :=
  fun x => (EuclideanSpace.equiv (Fin 4) Complex).symm
    (fun j => embeddedErrorComponent m t M N F j x)

/-- The bundled representative has exactly the expected pointwise Euclidean
norm. -/
theorem embeddedErrorSpinor_norm_sq (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) (x : Momentum3) :
    ‖embeddedErrorSpinor m t M N F x‖ ^ 2 =
      ∑ j : Fin 4, ‖embeddedErrorComponent m t M N F j x‖ ^ 2 := by
  rw [spinor_norm_sq_eq_sum]
  rfl

/-- The actual bundled representative is in `L2`; this is not an assumed
quotient-space element. -/
theorem embeddedErrorSpinor_memLp (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) :
    MemLp (embeddedErrorSpinor m t M N F) 2 volume := by
  apply MemLp.of_eval_piLp
  intro j
  simpa [embeddedErrorSpinor, embeddedErrorComponent] using
    embedFinite_memLp (physicalSpacing N) (scheduledModes N)
      (fun k => scaledCellModeError m t M N F k j)

/-- Integration commutes with the finite coordinate sum, giving the exact
representative-level energy identity. -/
theorem embeddedErrorSpinor_energy_eq (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) :
    (∫ x, ‖embeddedErrorSpinor m t M N F x‖ ^ 2) =
      ∑ j : Fin 4,
        ∫ x, ‖embeddedErrorComponent m t M N F j x‖ ^ 2 := by
  rw [integral_congr_ae (Filter.Eventually.of_forall fun x =>
    embeddedErrorSpinor_norm_sq m t M N F x)]
  rw [integral_finset_sum]
  intro j hj
  exact (embedFinite_memLp (physicalSpacing N) (scheduledModes N)
    (fun k => scaledCellModeError m t M N F k j)).integrable_norm_pow
      (by norm_num)

/-- The canonical `Lp` class of the actual bundled representative. -/
def embeddedErrorLp (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) :
    Lp Spinor 2 (volume : Measure Momentum3) :=
  (embeddedErrorSpinor_memLp m t M N F).toLp
    (embeddedErrorSpinor m t M N F)

/-- The `L2` norm squared of the quotient-space element is exactly the landed
componentwise energy, with no representative gap. -/
theorem embeddedErrorLp_norm_sq_eq (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) :
    ‖embeddedErrorLp m t M N F‖ ^ 2 =
      ∑ j : Fin 4,
        ∫ x, ‖embeddedErrorComponent m t M N F j x‖ ^ 2 := by
  rw [← embeddedErrorSpinor_energy_eq]
  let hf := embeddedErrorSpinor_memLp m t M N F
  rw [show embeddedErrorLp m t M N F =
      hf.toLp (embeddedErrorSpinor m t M N F) by rfl]
  rw [Lp.norm_toLp]
  rw [hf.eLpNorm_eq_integral_rpow_norm (by norm_num) (by norm_num)]
  simp only [ENNReal.toReal_ofNat]
  have henergy : 0 <=
      ∫ x, ‖embeddedErrorSpinor m t M N F x‖ ^ 2
        ∂(volume : Measure Momentum3) :=
    integral_nonneg fun x => sq_nonneg ‖embeddedErrorSpinor m t M N F x‖
  rw [ENNReal.toReal_ofReal']
  rw [max_eq_left (by positivity)]
  have hrpow_energy :
      (∫ x, ‖embeddedErrorSpinor m t M N F x‖ ^ (2 : Real)) =
        ∫ x, ‖embeddedErrorSpinor m t M N F x‖ ^ (2 : Nat) := by
    apply integral_congr_ae
    exact Filter.Eventually.of_forall fun x => Real.rpow_two _
  rw [hrpow_energy]
  exact Real.rpow_inv_natCast_pow (n := 2)
    henergy (by norm_num)

/-- The landed componentwise estimate therefore gives genuine strong
convergence in the vector-valued momentum-space `L2`. -/
theorem embeddedErrorLp_norm_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    Tendsto (fun N => ‖embeddedErrorLp m t M N F‖) atTop (nhds 0) := by
  have hsq : Tendsto (fun N => ‖embeddedErrorLp m t M N F‖ ^ 2)
      atTop (nhds 0) := by
    apply (embeddedScaledLiveError_tendsto_zero m t M hm F hF).congr'
    exact Filter.Eventually.of_forall fun N =>
      (embeddedErrorLp_norm_sq_eq m t M N F).symm
  have hsqrt := hsq.sqrt
  simpa [Real.sqrt_sq_eq_abs, abs_of_nonneg] using hsqrt

/-- Transport the repository-domain `Lp` error across the canonical
volume-preserving identity from Euclidean momentum coordinates to the plain
coordinate function space. This resolves the domain-norm mismatch explicitly. -/
def euclideanErrorLp (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  MeasureTheory.Lp.compMeasurePreserving
    (fun x : FourierMomentum3 => WithLp.ofLp x)
    (PiLp.volume_preserving_ofLp (ι := Fin 3))
    (embeddedErrorLp m t M N F)

/-- The explicit measure-preserving domain bridge is an `L2` isometry. -/
theorem euclideanErrorLp_norm_eq (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) :
    ‖euclideanErrorLp m t M N F‖ = ‖embeddedErrorLp m t M N F‖ := by
  exact Lp.norm_compMeasurePreserving _ _

/-- Reconstruct the Euclidean-domain error in position space with Mathlib's
vector-valued inverse Fourier linear isometry. -/
def positionErrorLp (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor).symm
    (euclideanErrorLp m t M N F)

/-- Plancherel preserves the error norm exactly under reconstruction. -/
theorem positionErrorLp_norm_eq (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) :
    ‖positionErrorLp m t M N F‖ = ‖euclideanErrorLp m t M N F‖ := by
  exact
    (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor).symm.norm_map
      (euclideanErrorLp m t M N F)

/-- **F1 capstone.** The inverse-Fourier reconstructed error converges strongly
to zero in vector-valued position-space `L2`. This is unitary transport of the
landed momentum theorem, not yet a PDE identification. -/
theorem positionErrorLp_norm_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    Tendsto (fun N => ‖positionErrorLp m t M N F‖) atTop (nhds 0) := by
  apply (embeddedErrorLp_norm_tendsto_zero m t M hm F hF).congr'
  exact Filter.Eventually.of_forall fun N =>
    ((positionErrorLp_norm_eq m t M N F).trans
      (euclideanErrorLp_norm_eq m t M N F)).symm

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellFourierL2.positionErrorLp_norm_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positionErrorLp_norm_tendsto_zero

end PhysicsSM.Draft.NullEdge.ChangingCellFourierL2
