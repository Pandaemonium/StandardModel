import PhysicsSM.Draft.NullEdge.HNUChangingCellL2
import PhysicsSM.Draft.NullEdge.HNUExactFlowCellIntegral
import PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry

/-!
# HNU changing-lattice position-space continuum capstone

This module composes the three actual errors in the refining HNU momentum-cell
scheme:

1. the live many-step endpoint minus the exact Weyl flow at each cell center;
2. the exact Weyl flow at a cell center minus the exact flow at the running
   momentum (the negative of `exactCellVariationLp`);
3. the exact Weyl evolution of the cell-projection error.

Their sum is the error between the live, cell-projected HNU approximation and
the exact continuum Weyl evolution.  Each term converges strongly in `L2`, and
the complete sum is transported to position space through Mathlib's
vector-valued inverse Fourier isometry.

This is a changing-lattice, full-`L2` theorem for the actual live HNU endpoint,
not a fixed-momentum or finite-sample statement.  It does not yet identify the
unbounded position-space Weyl generator or prove convergence of derivatives.

Provenance: clean-room composition of `HNUChangingCellL2`,
`HNUExactFlowCellIntegral`, `HNUChangingCellProjectionL2`, and Mathlib's
pointwise-unitary and Plancherel APIs, July 20, 2026.
-/

noncomputable section

open scoped BigOperators ENNReal Matrix.Norms.L2Operator
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.HNUChangingLatticeContinuumCapstone

open HNUManyStepContinuum
open ChangingMomentumCellIsometry
open HNUChangingCellProjectionL2
open HNUChangingCellL2
open HNUExactFlowCellIntegral
open VariablePointwiseL2Isometry

/-- Exact Weyl evolution as a continuous-linear operator on the two-component
Euclidean spinor. -/
def exactWeylOperator (t : Real) (q : Momentum3) :
    WeylSpinor →L[Complex] WeylSpinor :=
  Matrix.toEuclideanCLM (n := Fin 2) (𝕜 := Complex) (Eflow q t)

/-- Matrix-to-operator transport, viewed as a real continuous-linear map. -/
def matrixToWeylOperator :
    Mat →L[Real] (WeylSpinor →L[Complex] WeylSpinor) :=
  (((Matrix.toEuclideanCLM (𝕜 := Complex)).toAlgEquiv.toLinearMap).restrictScalars
    Real).mkContinuous 1
      (by
        intro A
        rw [one_mul]
        exact le_of_eq (Matrix.l2_opNorm_toEuclideanCLM A))

@[simp] theorem matrixToWeylOperator_apply (A : Mat) :
    matrixToWeylOperator A =
      Matrix.toEuclideanCLM (𝕜 := Complex) A := rfl

/-- The exact Weyl operator varies continuously with momentum. -/
theorem exactWeylOperator_continuous (t : Real) :
    Continuous (exactWeylOperator t) := by
  letI : NormedAlgebra Rat Mat :=
    NormedAlgebra.restrictScalars Rat Complex Mat
  have hmat : Continuous (fun q : Momentum3 => Eflow q t) := by
    unfold Eflow Hw
    fun_prop
  simpa [exactWeylOperator] using matrixToWeylOperator.continuous.comp hmat

/-- The exact Weyl operator is pointwise norm preserving. -/
theorem exactWeylOperator_norm (t : Real) (q : Momentum3)
    (v : WeylSpinor) :
    norm (exactWeylOperator t q v) = norm v := by
  have hu : exactWeylOperator t q ∈
      unitary (WeylSpinor →L[Complex] WeylSpinor) := by
    exact Unitary.map_mem
      (Matrix.toEuclideanCLM (𝕜 := Complex) (n := Fin 2))
      (Eflow_mem_unitary q t)
  exact ContinuousLinearMap.norm_map_of_mem_unitary hu v

/-- Evolve the actual projection error by the exact momentum-dependent Weyl
flow.  The representative-safe lift is an `L2` linear isometry. -/
def evolvedProjectionErrorLp (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    Lp WeylSpinor 2 (volume : Measure Momentum3) :=
  variablePointwiseL2Isometry volume (exactWeylOperator t)
    (exactWeylOperator_continuous t).aestronglyMeasurable
    (exactWeylOperator_norm t) (projectionErrorLp N F hF)

/-- Exact Weyl evolution preserves the projection-error norm. -/
theorem evolvedProjectionErrorLp_norm_eq (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    norm (evolvedProjectionErrorLp t N F hF) =
      norm (projectionErrorLp N F hF) := by
  exact (variablePointwiseL2Isometry volume (exactWeylOperator t)
    (exactWeylOperator_continuous t).aestronglyMeasurable
    (exactWeylOperator_norm t)).norm_map (projectionErrorLp N F hF)

/-- The evolved projection tail converges strongly to zero. -/
theorem evolvedProjectionErrorLp_norm_tendsto_zero (t : Real)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    Tendsto (fun N => norm (evolvedProjectionErrorLp t N F hF))
      atTop (nhds 0) := by
  apply (projectionErrorLp_norm_tendsto_zero F hF).congr'
  exact Filter.Eventually.of_forall fun N =>
    (evolvedProjectionErrorLp_norm_eq t N F hF).symm

/-! ## Representative-level semantic identity -/

/-- Exact Weyl evolution of the concrete cell-projected input. -/
def exactProjectedField (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor) : Momentum3 -> WeylSpinor :=
  fun q => exactWeylOperator t q (spinorProjectAt N F q)

/-- Exact continuum Weyl evolution of the supplied momentum field. -/
def exactContinuumField (t : Real) (F : Momentum3 -> WeylSpinor) :
    Momentum3 -> WeylSpinor :=
  fun q => exactWeylOperator t q (F q)

/-- Concrete representative of the exactly evolved projection tail. -/
def evolvedProjectionErrorField (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor) : Momentum3 -> WeylSpinor :=
  fun q => exactWeylOperator t q (projectionError N F q)

/-- The live cell approximation reconstructed from its proved
live-versus-center error, the exact projected flow, and the proved
center-versus-running-momentum variation. -/
def liveCellApproximationField (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor) : Momentum3 -> WeylSpinor :=
  fun q => embeddedErrorSpinor t N F q + exactProjectedField t N F q -
    exactCellVariationField t N F q

/-- Concrete representative of the three-term total error. -/
def totalMomentumErrorField (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor) : Momentum3 -> WeylSpinor :=
  fun q => embeddedErrorSpinor t N F q - exactCellVariationField t N F q +
    evolvedProjectionErrorField t N F q

/-- The evolved projection tail is exactly the difference between evolving
the projected input and evolving the original input. -/
theorem evolvedProjectionErrorField_eq (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor) (q : Momentum3) :
    evolvedProjectionErrorField t N F q =
      exactProjectedField t N F q - exactContinuumField t F q := by
  simp only [evolvedProjectionErrorField, projectionError,
    exactProjectedField, exactContinuumField, map_sub]

/-- **Semantic three-term identity.** Pointwise, the error representative is
the live changing-cell approximation minus the exact continuum Weyl flow. -/
theorem totalMomentumErrorField_eq_live_sub_exact (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor) (q : Momentum3) :
    totalMomentumErrorField t N F q =
      liveCellApproximationField t N F q - exactContinuumField t F q := by
  rw [totalMomentumErrorField, liveCellApproximationField,
    evolvedProjectionErrorField_eq]
  abel

/-- Complete momentum-space error of the changing-cell HNU approximation.
The sign of the middle term reflects that `exactCellVariationLp` is defined as
`(E(q)-E(q_center)) P_N F`. -/
def totalMomentumErrorLp (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    Lp WeylSpinor 2 (volume : Measure Momentum3) :=
  embeddedErrorLp t N F - exactCellVariationLp t N F +
    evolvedProjectionErrorLp t N F hF

/-- The exact-flow lift of the projection error has the advertised concrete
representative almost everywhere. -/
theorem evolvedProjectionErrorLp_coeFn (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    evolvedProjectionErrorLp t N F hF =ᵐ[volume]
      evolvedProjectionErrorField t N F := by
  have hE := variablePointwiseL2Isometry_coeFn volume (exactWeylOperator t)
    (exactWeylOperator_continuous t).aestronglyMeasurable
    (exactWeylOperator_norm t) (projectionErrorLp N F hF)
  have hP := (projectionError_memLp N F hF).coeFn_toLp
  filter_upwards [hE, hP] with q hEq hPq
  unfold evolvedProjectionErrorLp
  rw [hEq]
  simp only [appliedRepresentative]
  unfold projectionErrorLp evolvedProjectionErrorField
  rw [hPq]

/-- The quotient-space total error has exactly the concrete three-term
representative almost everywhere. -/
theorem totalMomentumErrorLp_coeFn (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    totalMomentumErrorLp t N F hF =ᵐ[volume]
      totalMomentumErrorField t N F := by
  have hAdd := Lp.coeFn_add
    (embeddedErrorLp t N F - exactCellVariationLp t N F)
    (evolvedProjectionErrorLp t N F hF)
  have hSub := Lp.coeFn_sub (embeddedErrorLp t N F)
    (exactCellVariationLp t N F)
  have hLive := (embeddedErrorSpinor_memLp t N F).coeFn_toLp
  have hCell := (exactCellVariationField_memLp t N F).coeFn_toLp
  have hProjection := evolvedProjectionErrorLp_coeFn t N F hF
  filter_upwards [hAdd, hSub, hLive, hCell, hProjection] with q
      hAddq hSubq hLiveq hCellq hProjectionq
  unfold totalMomentumErrorLp
  rw [hAddq]
  simp only [Pi.add_apply]
  rw [hSubq]
  simp only [Pi.sub_apply]
  unfold embeddedErrorLp exactCellVariationLp
  rw [hLiveq, hCellq, hProjectionq]
  rfl

/-- The bundled total error is almost everywhere the actual live
approximation minus the exact continuum flow. -/
theorem totalMomentumErrorLp_eq_live_sub_exact_ae (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    totalMomentumErrorLp t N F hF =ᵐ[volume]
      fun q => liveCellApproximationField t N F q - exactContinuumField t F q := by
  filter_upwards [totalMomentumErrorLp_coeFn t N F hF] with q hq
  rw [hq, totalMomentumErrorField_eq_live_sub_exact]

/-- Generic three-term triangle estimate, kept separate so the HNU `Lp`
definitions remain opaque during elaboration. -/
theorem norm_sub_add_le {E : Type*} [SeminormedAddCommGroup E]
    (a b c : E) :
    norm (a - b + c) <= (norm a + norm b) + norm c := by
  have hab : norm (a - b) <= norm a + norm b := norm_sub_le a b
  calc
    _ <= norm (a - b) + norm c := norm_add_le _ _
    _ <= (norm a + norm b) + norm c := add_le_add hab le_rfl

/-- Triangle bound exposing all three independently controlled errors. -/
theorem totalMomentumErrorLp_norm_le (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    norm (totalMomentumErrorLp t N F hF) <=
      (norm (embeddedErrorLp t N F) +
        norm (exactCellVariationLp t N F)) +
      norm (evolvedProjectionErrorLp t N F hF) := by
  exact norm_sub_add_le (embeddedErrorLp t N F)
    (exactCellVariationLp t N F) (evolvedProjectionErrorLp t N F hF)

/-- The full actual momentum-space HNU error converges strongly to zero. -/
theorem totalMomentumErrorLp_norm_tendsto_zero (t : Real)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    Tendsto (fun N => norm (totalMomentumErrorLp t N F hF))
      atTop (nhds 0) := by
  refine squeeze_zero (fun N => norm_nonneg _) (fun N =>
    totalMomentumErrorLp_norm_le t N F hF) ?_
  have hLive := embeddedErrorLp_norm_tendsto_zero t F hF
  have hCell := exactCellVariationLp_norm_tendsto_zero t F hF
  have hProjection := evolvedProjectionErrorLp_norm_tendsto_zero t F hF
  simpa using (hLive.add hCell).add hProjection

/-- Euclidean momentum domain used by Mathlib's Fourier transform. -/
abbrev FourierDomain3 := HNUChangingCellProjectionL2.FourierMomentum3

/-- Explicit measure-preserving bridge from the cell-coordinate normed space
to Mathlib's Euclidean Fourier domain. -/
def euclideanTotalMomentumErrorLp (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    Lp WeylSpinor 2 (volume : Measure FourierDomain3) :=
  MeasureTheory.Lp.compMeasurePreserving
    (fun q : FourierDomain3 => WithLp.ofLp q)
    (PiLp.volume_preserving_ofLp (ι := Fin 3))
    (totalMomentumErrorLp t N F hF)

/-- The domain bridge preserves the complete error norm. -/
theorem euclideanTotalMomentumErrorLp_norm_eq (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    norm (euclideanTotalMomentumErrorLp t N F hF) =
      norm (totalMomentumErrorLp t N F hF) := by
  exact Lp.norm_compMeasurePreserving _ _

/-- Position-space reconstruction of the complete changing-lattice error. -/
def positionTotalErrorLp (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    Lp WeylSpinor 2 (volume : Measure FourierDomain3) :=
  (MeasureTheory.Lp.fourierTransformₗᵢ FourierDomain3 WeylSpinor).symm
    (euclideanTotalMomentumErrorLp t N F hF)

/-- Plancherel preserves the complete changing-lattice error norm. -/
theorem positionTotalErrorLp_norm_eq (t : Real) (N : Nat)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    norm (positionTotalErrorLp t N F hF) =
      norm (euclideanTotalMomentumErrorLp t N F hF) := by
  exact
    (MeasureTheory.Lp.fourierTransformₗᵢ FourierDomain3 WeylSpinor).symm.norm_map
      (euclideanTotalMomentumErrorLp t N F hF)

/-- **Changing-lattice HNU continuum theorem.** For every componentwise
square-integrable two-component momentum field and every fixed time, the live
cell-projected HNU evolution converges strongly in position-space `L2` to the
exact continuum Weyl evolution. -/
theorem positionTotalErrorLp_norm_tendsto_zero (t : Real)
    (F : Momentum3 -> WeylSpinor)
    (hF : forall j : Fin 2, MemLp (fun q => F q j) 2 volume) :
    Tendsto (fun N => norm (positionTotalErrorLp t N F hF))
      atTop (nhds 0) := by
  apply (totalMomentumErrorLp_norm_tendsto_zero t F hF).congr'
  exact Filter.Eventually.of_forall fun N =>
    ((positionTotalErrorLp_norm_eq t N F hF).trans
      (euclideanTotalMomentumErrorLp_norm_eq t N F hF)).symm

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUChangingLatticeContinuumCapstone.evolvedProjectionErrorLp_norm_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms evolvedProjectionErrorLp_norm_eq

/-- info: 'PhysicsSM.Draft.NullEdge.HNUChangingLatticeContinuumCapstone.totalMomentumErrorLp_eq_live_sub_exact_ae' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms totalMomentumErrorLp_eq_live_sub_exact_ae

/-- info: 'PhysicsSM.Draft.NullEdge.HNUChangingLatticeContinuumCapstone.positionTotalErrorLp_norm_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positionTotalErrorLp_norm_tendsto_zero

end PhysicsSM.Draft.NullEdge.HNUChangingLatticeContinuumCapstone
