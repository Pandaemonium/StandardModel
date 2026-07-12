import Mathlib.Analysis.Fourier.AddCircleMulti
import PhysicsSM.Draft.NullEdge.FullLiveCoefficientConvergence

/-!
# Aristotle target: transport the full live coefficient theorem to torus L2

The live theorem now controls the complete square-summable four-spinor error
over `Z^3`, including omitted ultraviolet modes. Mathlib already identifies
scalar `L2(UnitAddTorus (Fin 3))` isometrically with square-summable Fourier
coefficients indexed by `Fin 3 -> Z`.

Close the bridge below without weakening any statement. The final target is
strong convergence in the finite product of four scalar torus-L2 spaces.

Claim boundary: this is a fixed unit-torus Fourier transport. It is not the
changing-lattice sampling/interpolation theorem on `R^3`, and it does not by
itself identify the limit with a position-space Dirac PDE solution.
-/

noncomputable section

set_option maxHeartbeats 600000

open Filter Topology MeasureTheory

namespace PhysicsSM.Draft.NullEdge.TorusL2LiveWalk

open ChangingModeEmbedding
open FullLiveCoefficientConvergence
open LiveWeighted3Plus1Walk

local instance unitAddCircleMeasureSpace : MeasureSpace UnitAddCircle :=
  instMeasureSpaceUnitAddCircle

/-- Scalar L2 space on the three-dimensional unit torus. -/
abbrev TorusL2 :=
  MeasureTheory.Lp Complex 2
    (MeasureTheory.MeasureSpace.volume : Measure (UnitAddTorus (Fin 3)))

/-- Reindex the repository's product presentation of `Z^3` by Mathlib's
three-coordinate Fourier index. -/
def latticeIndexModeEquiv : (Fin 3 -> Int) ≃ Mode where
  toFun k := ((k 0, k 1), k 2)
  invFun k := ![k.1.1, k.1.2, k.2]
  left_inv k := by
    funext i
    fin_cases i <;> rfl
  right_inv k := rfl

/-- One spinor coordinate of the full live error, reindexed by the torus
Fourier lattice. -/
def scalarFullErrorSequence
    (m t : Real) (M N : Nat) (f : Mode -> ModeSpinor) (j : Fin 4) :
    (Fin 3 -> Int) -> Complex :=
  fun k => fullModeError m t M N f (latticeIndexModeEquiv k) j

/-- Each scalar-coordinate error is square summable. -/
theorem scalarFullErrorSequence_meml2
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> ModeSpinor) (hf : Summable (fun k => ‖f k‖ ^ 2))
    (j : Fin 4) :
    Memℓp (scalarFullErrorSequence m t M N f j) 2 := by
  rw [memℓp_gen_iff] <;> norm_num
  have hscaled := hf.mul_left ((2 * t ^ 2 * Real.exp |t| + 1) ^ 2)
  have henv : Summable
      (fun k : Mode => (fullErrorEnvelope t f k) ^ 2) := by
    convert hscaled using 1
    funext k
    simp [fullErrorEnvelope, mul_pow]
  have hcoord : Summable
      (fun k : Mode => ‖fullModeError m t M N f k j‖ ^ 2) := by
    apply henv.of_nonneg_of_le
    · intro k
      positivity
    · intro k
      calc
        ‖fullModeError m t M N f k j‖ ^ 2 <=
            ‖fullModeError m t M N f k‖ ^ 2 := by
          exact pow_le_pow_left₀ (norm_nonneg _)
            (PiLp.norm_apply_le (fullModeError m t M N f k) j) 2
        _ <= (fullErrorEnvelope t f k) ^ 2 := by
          exact pow_le_pow_left₀ (norm_nonneg _)
            (fullModeError_norm_le_envelope m t M N hm f k) 2
  exact (latticeIndexModeEquiv.summable_iff).2 hcoord

/-- Package a scalar error coordinate as an element of Fourier coefficient
space. -/
def scalarFullErrorLp
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> ModeSpinor) (hf : Summable (fun k => ‖f k‖ ^ 2))
    (j : Fin 4) : lp (fun _ : (Fin 3 -> Int) => Complex) 2 :=
  ⟨scalarFullErrorSequence m t M N f j,
    scalarFullErrorSequence_meml2 m t M N hm f hf j⟩

/-- Reconstruct one scalar physical-space error coordinate by the inverse
Mathlib Fourier-basis isometry. -/
def scalarFullErrorTorus
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> ModeSpinor) (hf : Summable (fun k => ‖f k‖ ^ 2))
    (j : Fin 4) : TorusL2 :=
  (UnitAddTorus.mFourierBasis (d := Fin 3)).repr.symm
    (scalarFullErrorLp m t M N hm f hf j)

/-- Parseval plus the explicit reindexing: the physical scalar L2 norm is
exactly the corresponding coefficient-square sum. -/
theorem scalarFullErrorTorus_norm_sq_eq
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> ModeSpinor) (hf : Summable (fun k => ‖f k‖ ^ 2))
    (j : Fin 4) :
    ‖scalarFullErrorTorus m t M N hm f hf j‖ ^ 2 =
      ∑' k : Mode, ‖fullModeError m t M N f k j‖ ^ 2 := by
  rw [show ‖scalarFullErrorTorus m t M N hm f hf j‖ =
      ‖scalarFullErrorLp m t M N hm f hf j‖ by
    exact (UnitAddTorus.mFourierBasis (d := Fin 3)).repr.symm.norm_map _]
  have hnorm := lp.norm_rpow_eq_tsum (p := (2 : ENNReal)) (by norm_num)
    (scalarFullErrorLp m t M N hm f hf j)
  norm_num at hnorm
  rw [hnorm]
  calc
    (∑' i : Fin 3 -> Int,
        ‖(scalarFullErrorLp m t M N hm f hf j) i‖ ^ 2) =
        ∑' i : Fin 3 -> Int,
          ‖scalarFullErrorSequence m t M N f j i‖ ^ 2 := by rfl
    _ = ∑' k : Mode, ‖fullModeError m t M N f k j‖ ^ 2 := by
      simpa [scalarFullErrorSequence] using
        (latticeIndexModeEquiv.tsum_eq
          (fun k : Mode => ‖fullModeError m t M N f k j‖ ^ 2))

/-- A scalar coordinate's square sum is bounded by the full four-spinor
coefficient error. -/
theorem scalar_tsum_le_spinor_tsum
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> ModeSpinor) (hf : Summable (fun k => ‖f k‖ ^ 2))
    (j : Fin 4) :
    (∑' k : Mode, ‖fullModeError m t M N f k j‖ ^ 2) <=
      ∑' k : Mode, ‖fullModeError m t M N f k‖ ^ 2 := by
  have hscaled := hf.mul_left ((2 * t ^ 2 * Real.exp |t| + 1) ^ 2)
  have henv : Summable
      (fun k : Mode => (fullErrorEnvelope t f k) ^ 2) := by
    convert hscaled using 1
    funext k
    simp [fullErrorEnvelope, mul_pow]
  have hspin : Summable
      (fun k : Mode => ‖fullModeError m t M N f k‖ ^ 2) := by
    apply henv.of_nonneg_of_le
    · intro k
      positivity
    · intro k
      exact pow_le_pow_left₀ (norm_nonneg _)
        (fullModeError_norm_le_envelope m t M N hm f k) 2
  have hcoord : Summable
      (fun k : Mode => ‖fullModeError m t M N f k j‖ ^ 2) := by
    apply hspin.of_nonneg_of_le
    · intro k
      positivity
    · intro k
      exact pow_le_pow_left₀ (norm_nonneg _)
        (PiLp.norm_apply_le (fullModeError m t M N f k) j) 2
  exact Summable.tsum_le_tsum
    (fun k => pow_le_pow_left₀ (norm_nonneg _)
      (PiLp.norm_apply_le (fullModeError m t M N f k) j) 2)
    hcoord hspin

/-- Strong fixed-torus L2 convergence for each of the four spinor
coordinates. -/
theorem scalarFullErrorTorus_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> ModeSpinor) (hf : Summable (fun k => ‖f k‖ ^ 2))
    (j : Fin 4) :
    Tendsto (fun N : Nat => scalarFullErrorTorus m t M N hm f hf j)
      atTop (nhds 0) := by
  have hsum := fullModeError_tendsto_zero m t M hm f hf
  have hsq : Tendsto
      (fun N : Nat => ‖scalarFullErrorTorus m t M N hm f hf j‖ ^ 2)
      atTop (nhds 0) := by
    refine squeeze_zero (fun N => sq_nonneg _) (fun N => ?_) hsum
    calc
      ‖scalarFullErrorTorus m t M N hm f hf j‖ ^ 2 =
          ∑' k : Mode, ‖fullModeError m t M N f k j‖ ^ 2 :=
        scalarFullErrorTorus_norm_sq_eq m t M N hm f hf j
      _ <= ∑' k : Mode, ‖fullModeError m t M N f k‖ ^ 2 :=
        scalar_tsum_le_spinor_tsum m t M N hm f hf j
  rw [tendsto_zero_iff_norm_tendsto_zero]
  have hsqrt := (Real.continuous_sqrt.tendsto 0).comp hsq
  have heq :
      ((fun x : Real => Real.sqrt x) ∘
        fun N : Nat => ‖scalarFullErrorTorus m t M N hm f hf j‖ ^ 2) =
      (fun N : Nat => ‖scalarFullErrorTorus m t M N hm f hf j‖) := by
    funext N
    exact Real.sqrt_sq (norm_nonneg _)
  rw [heq] at hsqrt
  simpa using hsqrt

/-- The four scalar reconstructions, viewed as the finite product of torus L2
spaces. This product is topologically equivalent to the usual finite
four-component Hilbert norm, but is not asserted here to be a vector-valued
Bochner-L2 space. -/
def fullSpinorErrorTorus
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> ModeSpinor) (hf : Summable (fun k => ‖f k‖ ^ 2)) :
    Fin 4 -> TorusL2 :=
  fun j => scalarFullErrorTorus m t M N hm f hf j

/-- Strong convergence in the finite product of four scalar torus-L2 spaces. -/
theorem fullSpinorErrorTorus_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> ModeSpinor) (hf : Summable (fun k => ‖f k‖ ^ 2)) :
    Tendsto (fun N : Nat => fullSpinorErrorTorus m t M N hm f hf)
      atTop (nhds 0) := by
  rw [tendsto_pi_nhds]
  intro j
  exact scalarFullErrorTorus_tendsto_zero m t M hm f hf j

end PhysicsSM.Draft.NullEdge.TorusL2LiveWalk
