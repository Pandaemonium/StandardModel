import PhysicsSM.Draft.NullEdge.CompactSupportL2Generator
import PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowGenerator

/-!
# Complex Pluecker-mass HNU flow on momentum-space L2

This module begins the analytic lift of the live massive HNU continuum flow.
It first identifies the HNU Hamiltonian with the existing complex Pluecker
Dirac symbol, then packages its exact pointwise unitary evolution as a
representative-safe linear isometry on momentum-space `L2`.

The main theorem transports the compact-support generator result from the
real-mass flow through the constant chiral conjugacy.  Nothing here asserts
that the unbounded full-space generator is closed or self-adjoint on a maximal
domain.

Provenance: clean-room composition of `HNUMassiveContinuumReduction`,
`HNUMassiveExactFlowMomentumLipschitz`, `ComplexPlueckerRateTransfer`, and
`VariablePointwiseL2Isometry`; Lean 4.28.0.  Claim grade `M`, `[comp]`.
-/

noncomputable section

open Matrix Complex MeasureTheory
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator

open ChangingCellScaledLiveWalk
open ChangingCellFourierL2
open ChangingCellFourierPDE
open VariablePointwiseL2Isometry
open HNUPlueckerMassiveStay
open HNUMassiveContinuumReduction
open HNUMassiveExactFlowMomentumLipschitz
open HNUMassiveExactFlowGenerator
open Pluecker3Plus1ComplexMass
open CompactSupportL2Generator

abbrev FourierMomentum3 := ChangingCellFourierL2.FourierMomentum3
abbrev Spinor := EuclideanSpace Complex (Fin 4)

/-- The live HNU generator is definitionally the complex Pluecker Dirac
Hamiltonian used by the earlier rate theorem. -/
theorem massiveGenerator_eq_H4 (z : Complex) (q : FourierMomentum3) :
    massiveGenerator z q = H4 (q 0) (q 1) (q 2) z := by
  rfl

/-- The exact HNU comparison flow is the already-landed complex Pluecker
Dirac flow, now expressed in the changing-cell momentum type. -/
theorem massiveEflow_eq_complexExactFlow
    (z : Complex) (q : FourierMomentum3) (t : Real) :
    massiveEflow z q t =
      ComplexPlueckerRateTransfer.complexExactFlow
        (q 0) (q 1) (q 2) z t := by
  rw [ComplexPlueckerRateTransfer.complexExactFlow_eq_exp_H4]
  simp only [massiveEflow, massiveGenerator_eq_H4]

/-- A unitary `4 x 4` matrix acts isometrically on the Euclidean spinor
fibre.  This local helper keeps the subsequent `L2` lifts independent of a
chosen matrix exponential representation. -/
theorem unitaryMatrixCLM_isometry (A : Matrix (Fin 4) (Fin 4) Complex)
    (hA : A ∈ Matrix.unitaryGroup (Fin 4) Complex) (v : Spinor) :
    norm (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) A v) = norm v := by
  have hInner : forall u w : Spinor,
      inner Complex
          (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) A u)
          (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) A w) =
        inner Complex u w := by
    intro u w
    have hMatrix : Matrix.conjTranspose A * A = 1 := hA.1
    convert congr_arg
      (fun B : Matrix (Fin 4) (Fin 4) Complex =>
        dotProduct (star u) (B.mulVec w)) hMatrix using 1 <;>
      simp +decide [Matrix.mulVec, dotProduct, mul_comm, Fin.sum_univ_four]
    · simp +decide [Fin.sum_univ_four, inner]
      simp +decide [Matrix.mulVec, dotProduct, Fin.sum_univ_four,
        Matrix.mul_apply, Matrix.conjTranspose_apply]
      ring
    · simp +decide [inner, Fin.sum_univ_four]
  simp_all +decide [EuclideanSpace.norm_eq, Complex.normSq, Complex.sq_norm,
    Complex.ext_iff, inner]

/-- Pointwise exact massive HNU evolution as a bounded operator on the spinor
fibre. -/
def massiveMomMult (z : Complex) (t : Real) (q : FourierMomentum3) :
    Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) (massiveEflow z q t)

/-- The live complex-mass multiplier preserves the spinor norm pointwise. -/
theorem massiveMomMult_isometry (z : Complex) (t : Real)
    (q : FourierMomentum3) (v : Spinor) :
    norm (massiveMomMult z t q v) = norm v := by
  exact unitaryMatrixCLM_isometry (massiveEflow z q t)
    (massiveEflow_mem_unitary z q t) v

/-- The live complex-mass multiplier varies continuously with momentum. -/
theorem massiveMomMult_continuous (z : Complex) (t : Real) :
    Continuous (massiveMomMult z t) := by
  unfold massiveMomMult
  have hToCLM : Isometry
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)) := by
    apply Isometry.of_dist_eq
    intro A B
    simpa [dist_eq_norm, map_sub] using
      Matrix.l2_opNorm_toEuclideanCLM (A - B)
  apply hToCLM.continuous.comp
  let K : NNReal :=
    ⟨3 * |t|, mul_nonneg (by norm_num) (abs_nonneg t)⟩
  exact (LipschitzWith.of_dist_le_mul fun q p => by
    have h0 : |q 0 - p 0| <= norm (q - p) := by
      simpa [Real.norm_eq_abs] using PiLp.norm_apply_le (q - p) 0
    have h1 : |q 1 - p 1| <= norm (q - p) := by
      simpa [Real.norm_eq_abs] using PiLp.norm_apply_le (q - p) 1
    have h2 : |q 2 - p 2| <= norm (q - p) := by
      simpa [Real.norm_eq_abs] using PiLp.norm_apply_le (q - p) 2
    rw [dist_eq_norm]
    refine (massiveEflow_momentum_lipschitz z q p t).trans ?_
    change |t| * (|q 0 - p 0| + |q 1 - p 1| + |q 2 - p 2|) <=
      (K : Real) * norm (q - p)
    simp only [K, NNReal.coe_mk]
    nlinarith [abs_nonneg t, norm_nonneg (q - p)]).continuous

/-- The live exact multiplier family is almost-everywhere strongly
measurable. -/
theorem massiveMomMult_aestronglyMeasurable (z : Complex) (t : Real) :
    AEStronglyMeasurable (massiveMomMult z t)
      (volume : Measure FourierMomentum3) :=
  (massiveMomMult_continuous z t).aestronglyMeasurable

/-- Representative-safe exact complex-mass HNU evolution on momentum-space
`L2`. -/
def massiveMomMultL2Isometry (z : Complex) (t : Real) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) →ₗᵢ[Complex]
      Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  variablePointwiseL2Isometry (volume : Measure FourierMomentum3)
    (massiveMomMult z t) (massiveMomMult_aestronglyMeasurable z t)
    (massiveMomMult_isometry z t)

/-- The `L2` lift agrees almost everywhere with pointwise application of the
actual complex-mass HNU flow. -/
theorem massiveMomMultL2Isometry_coeFn (z : Complex) (t : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    massiveMomMultL2Isometry z t f =ᵐ[volume]
      fun q => massiveMomMult z t q (f q) := by
  exact variablePointwiseL2Isometry_coeFn
    (volume : Measure FourierMomentum3) (massiveMomMult z t)
    (massiveMomMult_aestronglyMeasurable z t)
    (massiveMomMult_isometry z t) f

/-- The complex-mass HNU `L2` flow preserves the full momentum-space norm. -/
theorem massiveMomMultL2Isometry_norm (z : Complex) (t : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    norm (massiveMomMultL2Isometry z t f) = norm f :=
  (massiveMomMultL2Isometry z t).norm_map f

/-! ## Constant chiral conjugacy on L2 -/

/-- Constant chiral phase acting on one spinor fibre. -/
def phaseOperator (z : Complex) : Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
    (ComplexPlueckerRateTransfer.phase z)

/-- Inverse chiral phase acting on one spinor fibre. -/
def phaseStarOperator (z : Complex) : Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
    (ComplexPlueckerRateTransfer.phase z)ᴴ

theorem phaseOperator_isometry (z : Complex) (v : Spinor) :
    norm (phaseOperator z v) = norm v := by
  exact unitaryMatrixCLM_isometry _
    (ComplexPlueckerRateTransfer.phase_mem_unitary z) v

theorem phaseStarOperator_isometry (z : Complex) (v : Spinor) :
    norm (phaseStarOperator z v) = norm v := by
  apply unitaryMatrixCLM_isometry
  rw [Matrix.mem_unitaryGroup_iff]
  change (ComplexPlueckerRateTransfer.phase z)ᴴ *
      (ComplexPlueckerRateTransfer.phase z)ᴴᴴ = 1
  rw [Matrix.conjTranspose_conjTranspose]
  exact ComplexPlueckerRateTransfer.phase_star_mul z

theorem phaseOperator_aestronglyMeasurable (z : Complex) :
    AEStronglyMeasurable (fun _ : FourierMomentum3 => phaseOperator z)
      (volume : Measure FourierMomentum3) :=
  aestronglyMeasurable_const

theorem phaseStarOperator_aestronglyMeasurable (z : Complex) :
    AEStronglyMeasurable (fun _ : FourierMomentum3 => phaseStarOperator z)
      (volume : Measure FourierMomentum3) :=
  aestronglyMeasurable_const

/-- Constant chiral phase lifted safely to momentum-space `L2`. -/
def phaseL2Isometry (z : Complex) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) →ₗᵢ[Complex]
      Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  variablePointwiseL2Isometry (volume : Measure FourierMomentum3)
    (fun _ => phaseOperator z) (phaseOperator_aestronglyMeasurable z)
    (fun _ => phaseOperator_isometry z)

/-- Inverse constant chiral phase lifted safely to momentum-space `L2`. -/
def phaseStarL2Isometry (z : Complex) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) →ₗᵢ[Complex]
      Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  variablePointwiseL2Isometry (volume : Measure FourierMomentum3)
    (fun _ => phaseStarOperator z)
    (phaseStarOperator_aestronglyMeasurable z)
    (fun _ => phaseStarOperator_isometry z)

theorem phaseL2Isometry_coeFn (z : Complex)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    phaseL2Isometry z f =ᵐ[volume]
      fun q => phaseOperator z (f q) := by
  exact variablePointwiseL2Isometry_coeFn
    (volume : Measure FourierMomentum3) (fun _ => phaseOperator z)
    (phaseOperator_aestronglyMeasurable z)
    (fun _ => phaseOperator_isometry z) f

theorem phaseStarL2Isometry_coeFn (z : Complex)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    phaseStarL2Isometry z f =ᵐ[volume]
      fun q => phaseStarOperator z (f q) := by
  exact variablePointwiseL2Isometry_coeFn
    (volume : Measure FourierMomentum3) (fun _ => phaseStarOperator z)
    (phaseStarOperator_aestronglyMeasurable z)
    (fun _ => phaseStarOperator_isometry z) f

/-- The HNU exact flow is pointwise the chiral conjugate of the real-mass
Dirac flow at mass `|z|`. -/
theorem massiveEflow_eq_phase_realExactFlow
    (z : Complex) (q : FourierMomentum3) (t : Real) :
    massiveEflow z q t =
      ComplexPlueckerRateTransfer.phase z *
        Compact3Plus1DiracRate.exactFlow
          (q 0) (q 1) (q 2) ‖z‖ t *
        (ComplexPlueckerRateTransfer.phase z)ᴴ := by
  rw [massiveEflow_eq_complexExactFlow]
  rfl

/-- Pointwise operator form of the exact chiral conjugacy. -/
theorem massiveMomMult_eq_phase_real
    (z : Complex) (q : FourierMomentum3) (t : Real) (v : Spinor) :
    massiveMomMult z t q v =
      phaseOperator z
        (momMult ‖z‖ t q (phaseStarOperator z v)) := by
  rw [massiveMomMult, phaseOperator, phaseStarOperator, momMult,
    massiveEflow_eq_phase_realExactFlow]
  apply WithLp.ofLp_injective 2
  simp only [Matrix.ofLp_toEuclideanCLM, Matrix.mulVec_mulVec]
  rw [Matrix.mul_assoc]

/-- Exact `L2` chiral conjugacy: the live complex-mass HNU flow is the real
mass flow at `|z|`, sandwiched between constant phase isometries. -/
theorem massiveMomMultL2Isometry_eq_phase_real
    (z : Complex) (t : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    massiveMomMultL2Isometry z t f =
      phaseL2Isometry z
        (momMultL2Isometry ‖z‖ t (phaseStarL2Isometry z f)) := by
  refine Lp.ext ?_
  filter_upwards
    [massiveMomMultL2Isometry_coeFn z t f,
      phaseL2Isometry_coeFn z
        (momMultL2Isometry ‖z‖ t (phaseStarL2Isometry z f)),
      momMultL2Isometry_coeFn ‖z‖ t (phaseStarL2Isometry z f),
      phaseStarL2Isometry_coeFn z f] with q hMass hPhase hReal hStar
  rw [hMass, hPhase, hReal, hStar, massiveMomMult_eq_phase_real]

/-! ## Compact-support generator transfer -/

/-- A constant chiral phase does not enlarge momentum support. -/
theorem boundedSupport_phaseStarL2Isometry (z : Complex) (R : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (hf : BoundedSupport R f) :
    BoundedSupport R (phaseStarL2Isometry z f) := by
  filter_upwards [hf, phaseStarL2Isometry_coeFn z f] with q hSupport hPhase
  intro hq
  rw [hPhase, hSupport hq]
  exact map_zero (phaseStarOperator z)

/-- The live complex-mass fibre generator is the chiral conjugate of the
real-mass generator at mass `|z|`. -/
theorem massiveFibreGenerator_eq_phase_realFibreGenerator
    (z : Complex) (q : FourierMomentum3) :
    massiveFibreGenerator z q =
      ComplexPlueckerRateTransfer.phase z *
        ExactFlowGenerator.fibreGenerator (q 0) (q 1) (q 2) ‖z‖ *
        (ComplexPlueckerRateTransfer.phase z)ᴴ := by
  rw [massiveFibreGenerator, ExactFlowGenerator.fibreGenerator]
  simp only [Matrix.mul_smul, Matrix.smul_mul]
  rw [ComplexPlueckerRateTransfer.conjugates_H]
  rw [massiveGenerator_eq_H4]

/-- Pointwise action form of the generator conjugacy. -/
theorem massiveGeneratorAction_eq_phase_real
    (z : Complex) (q : FourierMomentum3) (v : Spinor) :
    Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
        (massiveFibreGenerator z q) v =
      phaseOperator z
        (genMult ‖z‖ q (phaseStarOperator z v)) := by
  rw [genMult, phaseOperator, phaseStarOperator,
    massiveFibreGenerator_eq_phase_realFibreGenerator]
  apply WithLp.ofLp_injective 2
  simp only [Matrix.ofLp_toEuclideanCLM, Matrix.mulVec_mulVec]
  rw [Matrix.mul_assoc]

/-- The compact-support `L2` representative of the actual complex Pluecker
generator.  Its definition exposes the exact unitary transport from the landed
real-mass generator theorem. -/
def massiveGenRepr (z : Complex) (R : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (hf : BoundedSupport R f) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  phaseL2Isometry z
    (genRepr ‖z‖ R (phaseStarL2Isometry z f)
      (boundedSupport_phaseStarL2Isometry z R f hf))

/-- The packaged generator is represented almost everywhere by the live
matrix action `-i (kinetic4 q + mass4 z)`. -/
theorem massiveGenRepr_coeFn (z : Complex) (R : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (hf : BoundedSupport R f) :
    massiveGenRepr z R f hf =ᵐ[volume]
      fun q => Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
        (massiveFibreGenerator z q) (f q) := by
  filter_upwards
    [phaseL2Isometry_coeFn z
      (genRepr ‖z‖ R (phaseStarL2Isometry z f)
        (boundedSupport_phaseStarL2Isometry z R f hf)),
      genRepr_coeFn ‖z‖ R (phaseStarL2Isometry z f)
        (boundedSupport_phaseStarL2Isometry z R f hf),
      phaseStarL2Isometry_coeFn z f] with q hPhase hGen hStar
  rw [massiveGenRepr, hPhase, hGen, hStar]
  exact (massiveGeneratorAction_eq_phase_real z q (f q)).symm

/-- **Compact-support live complex-mass generator theorem.**  On bounded
momentum support, the exact HNU comparison orbit has a strong `L2` derivative
at zero equal to the actual complex Pluecker generator action. -/
theorem massiveMomMultL2Isometry_hasDerivAt_zero
    (z : Complex) (R : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (hf : BoundedSupport R f) :
    HasDerivAt
      (fun t : Real => massiveMomMultL2Isometry z t f)
      (massiveGenRepr z R f hf) 0 := by
  have hReal := momMultL2Isometry_hasDerivAt_zero ‖z‖ R
    (phaseStarL2Isometry z f)
    (boundedSupport_phaseStarL2Isometry z R f hf)
  let P :
      Lp Spinor 2 (volume : Measure FourierMomentum3) →L[Real]
        Lp Spinor 2 (volume : Measure FourierMomentum3) :=
    (phaseL2Isometry z).toContinuousLinearMap.restrictScalars Real
  have hComp := (P.hasFDerivAt).comp_hasDerivAt (0 : Real) hReal
  convert hComp using 1
  · funext t
    exact massiveMomMultL2Isometry_eq_phase_real z t f

end PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator.massiveGenerator_eq_H4' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator.massiveGenerator_eq_H4

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator.massiveMomMult_isometry' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator.massiveMomMult_isometry

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator.massiveMomMultL2Isometry_coeFn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator.massiveMomMultL2Isometry_coeFn

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator.massiveGenRepr_coeFn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator.massiveGenRepr_coeFn

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator.massiveMomMultL2Isometry_hasDerivAt_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveCompactSupportL2Generator.massiveMomMultL2Isometry_hasDerivAt_zero
