import PhysicsSM.Draft.NullEdge.HNUMassiveChangingCellL2
import PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowCellIntegral
import PhysicsSM.Draft.NullEdge.VariablePointwiseL2Isometry

/-!
# Massive HNU changing-lattice position-space continuum capstone

This module composes the three actual errors in the refining HNU momentum-cell
scheme:

1. the live many-step endpoint minus the exact massive Dirac flow at each cell center;
2. the exact massive Dirac flow at a cell center minus the exact flow at the running
   momentum (the negative of `exactCellVariationLp`);
3. the exact massive Dirac evolution of the cell-projection error.

Their sum is the error between the live, cell-projected HNU approximation and
the exact continuum massive Dirac evolution.  Each term converges strongly in `L2`, and
the complete sum is transported to position space through Mathlib's
vector-valued inverse Fourier isometry.

This is a changing-lattice, full-`L2` theorem for the actual live HNU endpoint,
not a fixed-momentum or finite-sample statement.  It does not yet identify the
unbounded position-space massive Dirac generator or prove convergence of derivatives.

Provenance: clean-room composition of `HNUMassiveChangingCellL2`,
`HNUMassiveExactFlowCellIntegral`, `HNUMassiveChangingCellProjectionL2`, and Mathlib's
pointwise-unitary and Plancherel APIs, July 20, 2026.
-/

noncomputable section

open scoped BigOperators ENNReal Matrix.Norms.L2Operator
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.HNUMassiveChangingLatticeContinuumCapstone

open HNUManyStepContinuum
open HNUPlueckerMassiveStay
open HNUMassiveContinuumReduction
open ChangingMomentumCellIsometry
open HNUMassiveChangingCellProjectionL2
open HNUMassiveChangingCellL2
open HNUMassiveExactFlowCellIntegral
open VariablePointwiseL2Isometry

/-- Exact massive Dirac evolution as a continuous-linear operator on the four-component
Euclidean spinor. -/
def exactDiracOperator (z : Complex) (t : Real) (q : Momentum3) :
    DiracSpinor →L[Complex] DiracSpinor :=
  Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) (massiveEflow z q t)

/-- Matrix-to-operator transport, viewed as a real continuous-linear map. -/
def matrixToDiracOperator :
    Mat4 →L[Real] (DiracSpinor →L[Complex] DiracSpinor) :=
  (((Matrix.toEuclideanCLM (𝕜 := Complex)).toAlgEquiv.toLinearMap).restrictScalars
    Real).mkContinuous 1
      (by
        intro A
        rw [one_mul]
        exact le_of_eq (Matrix.l2_opNorm_toEuclideanCLM A))

@[simp] theorem matrixToDiracOperator_apply (A : Mat4) :
    matrixToDiracOperator A =
      Matrix.toEuclideanCLM (𝕜 := Complex) A := rfl

/-- The exact massive Dirac operator varies continuously with momentum. -/
theorem exactDiracOperator_continuous (z : Complex) (t : Real) :
    Continuous (exactDiracOperator z t) := by
  letI : NormedAlgebra Rat Mat4 :=
    NormedAlgebra.restrictScalars Rat Complex Mat4
  have hmat : Continuous (fun q : Momentum3 => massiveEflow z q t) := by
    unfold massiveEflow massiveGenerator kinetic4
    fun_prop
  simpa [exactDiracOperator] using matrixToDiracOperator.continuous.comp hmat

/-- The exact massive Dirac operator is pointwise norm preserving. -/
theorem exactDiracOperator_norm (z : Complex) (t : Real) (q : Momentum3)
    (v : DiracSpinor) :
    norm (exactDiracOperator z t q v) = norm v := by
  have hu : exactDiracOperator z t q ∈
      unitary (DiracSpinor →L[Complex] DiracSpinor) := by
    exact Unitary.map_mem
      (Matrix.toEuclideanCLM (𝕜 := Complex) (n := Fin 4))
      (massiveEflow_mem_unitary z q t)
  exact ContinuousLinearMap.norm_map_of_mem_unitary hu v

/-- Evolve the actual projection error by the exact momentum-dependent Weyl
flow.  The representative-safe lift is an `L2` linear isometry. -/
def evolvedProjectionErrorLp (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    Lp DiracSpinor 2 (volume : Measure Momentum3) :=
  variablePointwiseL2Isometry volume (exactDiracOperator z t)
    (exactDiracOperator_continuous z t).aestronglyMeasurable
    (exactDiracOperator_norm z t) (projectionErrorLp N F hF)

/-- Exact massive Dirac evolution preserves the projection-error norm. -/
theorem evolvedProjectionErrorLp_norm_eq (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    norm (evolvedProjectionErrorLp z t N F hF) =
      norm (projectionErrorLp N F hF) := by
  exact (variablePointwiseL2Isometry volume (exactDiracOperator z t)
    (exactDiracOperator_continuous z t).aestronglyMeasurable
    (exactDiracOperator_norm z t)).norm_map (projectionErrorLp N F hF)

/-- The evolved projection tail converges strongly to zero. -/
theorem evolvedProjectionErrorLp_norm_tendsto_zero (z : Complex) (t : Real)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    Tendsto (fun N => norm (evolvedProjectionErrorLp z t N F hF))
      atTop (nhds 0) := by
  apply (projectionErrorLp_norm_tendsto_zero F hF).congr'
  exact Filter.Eventually.of_forall fun N =>
    (evolvedProjectionErrorLp_norm_eq z t N F hF).symm

/-! ## Representative-level semantic identity -/

/-- Exact massive Dirac evolution of the concrete cell-projected input. -/
def exactProjectedField (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) : Momentum3 -> DiracSpinor :=
  fun q => exactDiracOperator z t q (diracProjectAt N F q)

/-- Exact continuum massive Dirac evolution of the supplied momentum field. -/
def exactContinuumField (z : Complex) (t : Real)
    (F : Momentum3 -> DiracSpinor) :
    Momentum3 -> DiracSpinor :=
  fun q => exactDiracOperator z t q (F q)

/-- Concrete representative of the exactly evolved projection tail. -/
def evolvedProjectionErrorField (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) : Momentum3 -> DiracSpinor :=
  fun q => exactDiracOperator z t q (projectionError N F q)

/-- The live cell approximation reconstructed from its proved
live-versus-center error, the exact projected flow, and the proved
center-versus-running-momentum variation. -/
def liveCellApproximationField (z : Complex) (M t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) : Momentum3 -> DiracSpinor :=
  fun q => embeddedErrorSpinor z M t N F q + exactProjectedField z t N F q -
    exactCellVariationField z t N F q

/-- Concrete representative of the three-term total error. -/
def totalMomentumErrorField (z : Complex) (M t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) : Momentum3 -> DiracSpinor :=
  fun q => embeddedErrorSpinor z M t N F q -
    exactCellVariationField z t N F q +
    evolvedProjectionErrorField z t N F q

/-- The evolved projection tail is exactly the difference between evolving
the projected input and evolving the original input. -/
theorem evolvedProjectionErrorField_eq (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) (q : Momentum3) :
    evolvedProjectionErrorField z t N F q =
      exactProjectedField z t N F q - exactContinuumField z t F q := by
  simp only [evolvedProjectionErrorField, projectionError,
    exactProjectedField, exactContinuumField, map_sub]

/-- **Semantic three-term identity.** Pointwise, the error representative is
the live changing-cell approximation minus the exact continuum massive Dirac flow. -/
theorem totalMomentumErrorField_eq_live_sub_exact
    (z : Complex) (M t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) (q : Momentum3) :
    totalMomentumErrorField z M t N F q =
      liveCellApproximationField z M t N F q - exactContinuumField z t F q := by
  rw [totalMomentumErrorField, liveCellApproximationField,
    evolvedProjectionErrorField_eq]
  abel

/-- Complete momentum-space error of the changing-cell HNU approximation.
The sign of the middle term reflects that `exactCellVariationLp` is defined as
`(E(q)-E(q_center)) P_N F`. -/
def totalMomentumErrorLp (z : Complex) (M t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    Lp DiracSpinor 2 (volume : Measure Momentum3) :=
  embeddedErrorLp z M t N F - exactCellVariationLp z t N F +
    evolvedProjectionErrorLp z t N F hF

/-- The exact-flow lift of the projection error has the advertised concrete
representative almost everywhere. -/
theorem evolvedProjectionErrorLp_coeFn (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    evolvedProjectionErrorLp z t N F hF =ᵐ[volume]
      evolvedProjectionErrorField z t N F := by
  have hE := variablePointwiseL2Isometry_coeFn volume (exactDiracOperator z t)
    (exactDiracOperator_continuous z t).aestronglyMeasurable
    (exactDiracOperator_norm z t) (projectionErrorLp N F hF)
  have hP := (projectionError_memLp N F hF).coeFn_toLp
  filter_upwards [hE, hP] with q hEq hPq
  unfold evolvedProjectionErrorLp
  rw [hEq]
  simp only [appliedRepresentative]
  unfold projectionErrorLp evolvedProjectionErrorField
  rw [hPq]

/-- The quotient-space total error has exactly the concrete three-term
representative almost everywhere. -/
theorem totalMomentumErrorLp_coeFn (z : Complex) (M t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    totalMomentumErrorLp z M t N F hF =ᵐ[volume]
      totalMomentumErrorField z M t N F := by
  have hAdd := Lp.coeFn_add
    (embeddedErrorLp z M t N F - exactCellVariationLp z t N F)
    (evolvedProjectionErrorLp z t N F hF)
  have hSub := Lp.coeFn_sub (embeddedErrorLp z M t N F)
    (exactCellVariationLp z t N F)
  have hLive := (embeddedErrorSpinor_memLp z M t N F).coeFn_toLp
  have hCell := (exactCellVariationField_memLp z t N F).coeFn_toLp
  have hProjection := evolvedProjectionErrorLp_coeFn z t N F hF
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
theorem totalMomentumErrorLp_eq_live_sub_exact_ae
    (z : Complex) (M t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    totalMomentumErrorLp z M t N F hF =ᵐ[volume]
      fun q => liveCellApproximationField z M t N F q -
        exactContinuumField z t F q := by
  filter_upwards [totalMomentumErrorLp_coeFn z M t N F hF] with q hq
  rw [hq, totalMomentumErrorField_eq_live_sub_exact]

/-- Generic three-term triangle estimate, kept separate so the HNU `Lp`
definitions remain folded during elaboration. -/
theorem norm_sub_add_le {E : Type*} [SeminormedAddCommGroup E]
    (a b c : E) :
    norm (a - b + c) <= (norm a + norm b) + norm c := by
  have hab : norm (a - b) <= norm a + norm b := norm_sub_le a b
  calc
    _ <= norm (a - b) + norm c := norm_add_le _ _
    _ <= (norm a + norm b) + norm c := add_le_add hab le_rfl

/-- Triangle bound exposing all three independently controlled errors. -/
theorem totalMomentumErrorLp_norm_le
    (z : Complex) (M t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    norm (totalMomentumErrorLp z M t N F hF) <=
      (norm (embeddedErrorLp z M t N F) +
        norm (exactCellVariationLp z t N F)) +
      norm (evolvedProjectionErrorLp z t N F hF) := by
  exact norm_sub_add_le (embeddedErrorLp z M t N F)
    (exactCellVariationLp z t N F) (evolvedProjectionErrorLp z t N F hF)

/-- The full actual momentum-space HNU error converges strongly to zero. -/
theorem totalMomentumErrorLp_norm_tendsto_zero
    (z : Complex) (hz0 : Not (z = 0)) (M t : Real)
    (F : Momentum3 -> DiracSpinor) (hM : 0 <= M) (hz : norm z <= M)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    Tendsto (fun N => norm (totalMomentumErrorLp z M t N F hF))
      atTop (nhds 0) := by
  refine squeeze_zero (fun N => norm_nonneg _) (fun N =>
    totalMomentumErrorLp_norm_le z M t N F hF) ?_
  have hLive := embeddedErrorLp_norm_tendsto_zero z hz0 M t F hM hz hF
  have hCell := exactCellVariationLp_norm_tendsto_zero z t F hF
  have hProjection := evolvedProjectionErrorLp_norm_tendsto_zero z t F hF
  simpa using (hLive.add hCell).add hProjection

/-- Euclidean momentum domain used by Mathlib's Fourier transform. -/
abbrev FourierDomain3 := HNUMassiveChangingCellProjectionL2.FourierMomentum3

/-- Explicit measure-preserving bridge from the cell-coordinate normed space
to Mathlib's Euclidean Fourier domain. -/
def euclideanTotalMomentumErrorLp (z : Complex) (M t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    Lp DiracSpinor 2 (volume : Measure FourierDomain3) :=
  MeasureTheory.Lp.compMeasurePreserving
    (fun q : FourierDomain3 => WithLp.ofLp q)
    (PiLp.volume_preserving_ofLp (ι := Fin 3))
    (totalMomentumErrorLp z M t N F hF)

/-- The domain bridge preserves the complete error norm. -/
theorem euclideanTotalMomentumErrorLp_norm_eq
    (z : Complex) (M t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    norm (euclideanTotalMomentumErrorLp z M t N F hF) =
      norm (totalMomentumErrorLp z M t N F hF) := by
  exact Lp.norm_compMeasurePreserving _ _

/-- Position-space reconstruction of the complete changing-lattice error. -/
def positionTotalErrorLp (z : Complex) (M t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    Lp DiracSpinor 2 (volume : Measure FourierDomain3) :=
  (MeasureTheory.Lp.fourierTransformₗᵢ FourierDomain3 DiracSpinor).symm
    (euclideanTotalMomentumErrorLp z M t N F hF)

/-- Plancherel preserves the complete changing-lattice error norm. -/
theorem positionTotalErrorLp_norm_eq
    (z : Complex) (M t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    norm (positionTotalErrorLp z M t N F hF) =
      norm (euclideanTotalMomentumErrorLp z M t N F hF) := by
  exact
    (MeasureTheory.Lp.fourierTransformₗᵢ FourierDomain3 DiracSpinor).symm.norm_map
      (euclideanTotalMomentumErrorLp z M t N F hF)

/-- **Changing-lattice HNU continuum theorem.** For every componentwise
square-integrable four-component momentum field and every fixed time, the live
cell-projected HNU evolution converges strongly in position-space `L2` to the
exact continuum massive Dirac evolution. -/
theorem positionTotalErrorLp_norm_tendsto_zero
    (z : Complex) (hz0 : Not (z = 0)) (M t : Real)
    (F : Momentum3 -> DiracSpinor) (hM : 0 <= M) (hz : norm z <= M)
    (hF : forall j : Fin 4, MemLp (fun q => F q j) 2 volume) :
    Tendsto (fun N => norm (positionTotalErrorLp z M t N F hF))
      atTop (nhds 0) := by
  apply (totalMomentumErrorLp_norm_tendsto_zero z hz0 M t F hM hz hF).congr'
  exact Filter.Eventually.of_forall fun N =>
    ((positionTotalErrorLp_norm_eq z M t N F hF).trans
      (euclideanTotalMomentumErrorLp_norm_eq z M t N F hF)).symm

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveChangingLatticeContinuumCapstone.evolvedProjectionErrorLp_norm_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms evolvedProjectionErrorLp_norm_eq

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveChangingLatticeContinuumCapstone.totalMomentumErrorLp_eq_live_sub_exact_ae' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms totalMomentumErrorLp_eq_live_sub_exact_ae

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveChangingLatticeContinuumCapstone.positionTotalErrorLp_norm_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positionTotalErrorLp_norm_tendsto_zero

end PhysicsSM.Draft.NullEdge.HNUMassiveChangingLatticeContinuumCapstone
