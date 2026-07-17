import PhysicsSM.Draft.NullEdge.HiggsCurvatureMassIdentifiability

/-!
# Higgs curvature-coupling convention bridge

Suppose a supplied retarded scalar operator has continuum convention

```text
B_beta -> Box - beta * R.
```

Adding an explicit discrete term `-countertermXi * R` gives the physical
continuum coefficient

```text
physicalXi = beta + countertermXi.
```

For the four-dimensional Benincasa--Dowker value `beta = 1/2`, using the raw
operator with no curvature counterterm therefore corresponds to `xi = 1/2`,
not minimal coupling. In this sign convention, minimal coupling requires
`countertermXi = -1/2`, while conformal coupling `xi = 1/6` requires
`countertermXi = -1/3`.

The split between built-in operator curvature and an explicit counterterm is
not identifiable from scalar propagation: only their sum enters the effective
profile, even on nonconstant curvature. This differs from the separate
bare-mass/curvature-coupling identifiability boundary, which can be resolved by
two distinct curvature values.

This is finite convention and identifiability algebra conditional on the
displayed continuum operator convention. It does not prove that the present
null-edge kernel converges to the Benincasa--Dowker operator or select a
physical Higgs curvature coupling.

Provenance: the value `beta = 1/2` is motivated by D. M. T. Benincasa and
F. Dowker, "The Scalar Curvature of a Causal Set," arXiv:1001.2725. No source
implementation or proof text was copied. Claim grade: `M [orig/comp]` for the
finite algebra and `T|H [import]` for its continuum reading.

The base-to-target scattering convention is also compared with N. X,
F. Dowker, and S. Surya, "Scalar Field Green Functions on Causal Sets,"
arXiv:1701.07212. Relative to a base pair `(baseMassSq, baseXi)`, only the
difference of the target and base effective mass-squared values is inserted.
In four dimensions this distinguishes a minimal massless base from a
conformal massless base with `baseXi = 1/6`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsCurvatureConventionBridge

open PhysicsSM.Draft.NullEdge.HiggsCurvatureMassIdentifiability

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Physical continuum curvature coefficient in the displayed sign
convention. -/
def physicalCurvatureCoupling
    (operatorBeta countertermXi : Real) : Real :=
  operatorBeta + countertermXi

/-- The counterterm required to obtain a target physical curvature coupling. -/
def countertermForTarget
    (operatorBeta targetXi : Real) : Real :=
  targetXi - operatorBeta

/-- Residual constant-curvature insertion required to pass from one calibrated
scalar kernel to another. -/
def residualEffectiveMassSq
    (baseMassSq baseXi targetMassSq targetXi curvatureValue : Real) : Real :=
  (targetMassSq + targetXi * curvatureValue) -
    (baseMassSq + baseXi * curvatureValue)

/-- Adding the residual insertion to the base effective mass gives the target
effective mass exactly. -/
theorem baseEffectiveMass_add_residual_eq_target
    (baseMassSq baseXi targetMassSq targetXi curvatureValue : Real) :
    baseMassSq + baseXi * curvatureValue +
        residualEffectiveMassSq baseMassSq baseXi
          targetMassSq targetXi curvatureValue =
      targetMassSq + targetXi * curvatureValue := by
  unfold residualEffectiveMassSq
  ring

/-- Relative to a minimally coupled massless base, the residual coefficient is
`targetMassSq + targetXi * R`. -/
theorem residual_from_minimal_massless
    (targetMassSq targetXi curvatureValue : Real) :
    residualEffectiveMassSq 0 0 targetMassSq targetXi curvatureValue =
      targetMassSq + targetXi * curvatureValue := by
  unfold residualEffectiveMassSq
  ring

/-- Relative to the four-dimensional conformally coupled massless base, the
residual coefficient is `targetMassSq + (targetXi - 1/6) * R`. -/
theorem residual_from_fourDimensional_conformal_massless
    (targetMassSq targetXi curvatureValue : Real) :
    residualEffectiveMassSq 0 (1 / 6) targetMassSq targetXi curvatureValue =
      targetMassSq + (targetXi - 1 / 6) * curvatureValue := by
  unfold residualEffectiveMassSq
  ring

/-- The target counterterm produces exactly the requested physical coupling. -/
theorem physicalCurvatureCoupling_countertermForTarget
    (operatorBeta targetXi : Real) :
    physicalCurvatureCoupling operatorBeta
        (countertermForTarget operatorBeta targetXi) = targetXi := by
  unfold physicalCurvatureCoupling countertermForTarget
  ring

/-- A raw four-dimensional Benincasa--Dowker operator carries coefficient
`1/2` in the displayed convention. -/
theorem benincasaDowker_raw_coupling :
    physicalCurvatureCoupling (1 / 2) 0 = (1 / 2 : Real) := by
  norm_num [physicalCurvatureCoupling]

/-- Minimal physical coupling requires counterterm `-1/2` for the raw
Benincasa--Dowker coefficient. -/
theorem benincasaDowker_minimal_counterterm :
    countertermForTarget (1 / 2) 0 = (-1 / 2 : Real) ∧
      physicalCurvatureCoupling (1 / 2) (-1 / 2) = 0 := by
  norm_num [countertermForTarget, physicalCurvatureCoupling]

/-- Four-dimensional conformal coupling `1/6` requires counterterm `-1/3`
for the raw Benincasa--Dowker coefficient. -/
theorem benincasaDowker_conformal_counterterm :
    countertermForTarget (1 / 2) (1 / 6) = (-1 / 3 : Real) ∧
      physicalCurvatureCoupling (1 / 2) (-1 / 3) = (1 / 6 : Real) := by
  norm_num [countertermForTarget, physicalCurvatureCoupling]

omit [Fintype V] [DecidableEq V] in
/-- Substituting the target counterterm makes the effective local profile use
the requested physical curvature coupling. -/
theorem effectiveLocalMassSq_countertermForTarget
    (bareMassSq operatorBeta targetXi : Real) (curvature : V -> Real) :
    effectiveLocalMassSq bareMassSq
        (physicalCurvatureCoupling operatorBeta
          (countertermForTarget operatorBeta targetXi)) curvature =
      effectiveLocalMassSq bareMassSq targetXi curvature := by
  rw [physicalCurvatureCoupling_countertermForTarget]

/-- Trading curvature coefficient between the supplied operator and explicit
counterterm preserves the total physical coefficient exactly. -/
theorem curvatureSplit_parameter_shift
    (operatorBeta countertermXi delta : Real) :
    physicalCurvatureCoupling (operatorBeta + delta)
        (countertermXi - delta) =
      physicalCurvatureCoupling operatorBeta countertermXi := by
  unfold physicalCurvatureCoupling
  ring

/-- The built-in/counterterm split is not identifiable from any finite
measured scalar response: a nonzero affine trade changes both displayed
parameters while preserving every curvature profile, insertion matrix, and
retarded series. -/
theorem curvatureSplit_nontrivial_propagator_degeneracy
    (K : Matrix V V Real) (H : Nat)
    (bareMassSq operatorBeta countertermXi delta : Real)
    (curvature vertexMeasure : V -> Real) (hDelta : delta ≠ 0) :
    operatorBeta + delta ≠ operatorBeta ∧
      countertermXi - delta ≠ countertermXi ∧
      effectiveMassMatrix bareMassSq
          (physicalCurvatureCoupling (operatorBeta + delta)
            (countertermXi - delta)) curvature vertexMeasure =
        effectiveMassMatrix bareMassSq
          (physicalCurvatureCoupling operatorBeta countertermXi)
          curvature vertexMeasure ∧
      measuredMassRetardedSeries K
          (effectiveMassMatrix bareMassSq
            (physicalCurvatureCoupling (operatorBeta + delta)
              (countertermXi - delta)) curvature vertexMeasure) H =
        measuredMassRetardedSeries K
          (effectiveMassMatrix bareMassSq
            (physicalCurvatureCoupling operatorBeta countertermXi)
            curvature vertexMeasure) H := by
  have hTotal := curvatureSplit_parameter_shift
    operatorBeta countertermXi delta
  have hProfile :
      effectiveLocalMassSq bareMassSq
          (physicalCurvatureCoupling (operatorBeta + delta)
            (countertermXi - delta)) curvature =
        effectiveLocalMassSq bareMassSq
          (physicalCurvatureCoupling operatorBeta countertermXi) curvature := by
    rw [hTotal]
  have hMatrix := effectiveMassMatrix_eq_of_profile_eq
    bareMassSq
    (physicalCurvatureCoupling (operatorBeta + delta)
      (countertermXi - delta))
    bareMassSq (physicalCurvatureCoupling operatorBeta countertermXi)
    curvature vertexMeasure hProfile
  have hSeries := measuredMassRetardedSeries_eq_of_profile_eq
    K H bareMassSq
    (physicalCurvatureCoupling (operatorBeta + delta)
      (countertermXi - delta))
    bareMassSq (physicalCurvatureCoupling operatorBeta countertermXi)
    curvature vertexMeasure hProfile
  refine ⟨?_, ?_, hMatrix, hSeries⟩
  · intro hEqual
    apply hDelta
    linarith
  · intro hEqual
    apply hDelta
    linarith

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCurvatureConventionBridge.benincasaDowker_conformal_counterterm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms benincasaDowker_conformal_counterterm

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCurvatureConventionBridge.residual_from_fourDimensional_conformal_massless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms residual_from_fourDimensional_conformal_massless

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsCurvatureConventionBridge.curvatureSplit_nontrivial_propagator_degeneracy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms curvatureSplit_nontrivial_propagator_degeneracy

end PhysicsSM.Draft.NullEdge.HiggsCurvatureConventionBridge

end
