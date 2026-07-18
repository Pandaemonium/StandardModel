import PhysicsSM.Draft.NullEdge.StressEnergyPhysicalControls
import PhysicsSM.Draft.NullEdge.FiniteContractedBianchi

/-!
# Finite Einstein equation from symmetric metric stationarity

This module closes a finite-dimensional variational implication needed by the
null-edge general-relativity program. Given symmetric component tensors, it
proves that stationarity of the standard first-variation pairing against every
symmetric metric variation is equivalent to

```text
G_ab + Lambda g_ab = kappa T_ab.
```

The normalization is the covariant-metric convention

```text
delta S_total
  = (1 / (2 kappa)) <G + Lambda g, delta g>
      - (1 / 2) <T, delta g>.
```

The module also composes a differentiated field equation with the existing
finite contracted Bianchi identity to obtain source conservation. These are
exact component-algebra theorems. They do not derive the tensors from a
null-edge graph, construct an Einstein-Hilbert graph action, justify
variation-limit interchange, or prove continuum convergence.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.EinsteinEquationVariation

open StressEnergyPhysicalControls

/-! ## Symmetric metric variation -/

section MetricVariation

variable {I : Type*} [Fintype I]

/-- A finite frame-component rank-two tensor. -/
abbrev Tensor := Matrix I I Real

/-- The finite Einstein combination `Ric - (R/2) g`. -/
noncomputable def finiteEinsteinTensor
    (ricci : Tensor (I := I)) (scalarCurvature : Real)
    (metric : Tensor (I := I)) : Tensor (I := I) :=
  ricci - (scalarCurvature / 2) • metric

/-- The left side of the Einstein equation, including a cosmological term. -/
noncomputable def finiteEinsteinLHS
    (ricci : Tensor (I := I)) (scalarCurvature : Real)
    (metric : Tensor (I := I)) (cosmologicalConstant : Real) :
    Tensor (I := I) :=
  finiteEinsteinTensor ricci scalarCurvature metric +
    cosmologicalConstant • metric

/-- The finite component form of
`G_ab + Lambda g_ab = kappa T_ab`. -/
def FiniteEinsteinEquation
    (kappa : Real) (ricci : Tensor (I := I)) (scalarCurvature : Real)
    (metric : Tensor (I := I)) (cosmologicalConstant : Real)
    (stress : Tensor (I := I)) : Prop :=
  finiteEinsteinLHS ricci scalarCurvature metric cosmologicalConstant =
    kappa • stress

/-- The normalized total first variation. The factored expression is exactly
`(1 / (2 kappa)) <E, variation> - (1 / 2) <T, variation>` when `kappa` is
nonzero, where `E = G + Lambda g`. -/
noncomputable def totalMetricFirstVariation
    (kappa : Real) (einstein stress variation : Tensor (I := I)) : Real :=
  (1 / (2 * kappa)) *
    (metricVariationPairing einstein variation -
      kappa * metricVariationPairing stress variation)

/-- Stationarity against every symmetric component variation. -/
def MetricStationary
    (kappa : Real) (einstein stress : Tensor (I := I)) : Prop :=
  forall variation : Tensor (I := I), variation.IsSymm ->
    totalMetricFirstVariation kappa einstein stress variation = 0

/-- An actual finite action has the Einstein-matter first variation at a base
metric when every symmetric affine line through that metric has the displayed
directional derivative. This is the explicit bridge a graph action must prove;
it is not built into `MetricStationary`. -/
def HasEinsteinMetricFirstVariation
    (action : Tensor (I := I) -> Real) (baseMetric : Tensor (I := I))
    (kappa : Real) (einstein stress : Tensor (I := I)) : Prop :=
  forall variation : Tensor (I := I), variation.IsSymm ->
    HasDerivAt
      (fun t : Real => action (baseMetric + t • variation))
      (totalMetricFirstVariation kappa einstein stress variation) 0

/-- Ordinary stationarity of an actual finite action along every symmetric
metric direction. -/
def ActionMetricStationary
    (action : Tensor (I := I) -> Real) (baseMetric : Tensor (I := I)) : Prop :=
  forall variation : Tensor (I := I), variation.IsSymm ->
    HasDerivAt (fun t : Real => action (baseMetric + t • variation)) 0 0

/-- The component pairing is linear in its tensor coefficient. -/
theorem metricVariationPairing_smul_left
    (a : Real) (T variation : Tensor (I := I)) :
    metricVariationPairing (a • T) variation =
      a * metricVariationPairing T variation := by
  classical
  unfold metricVariationPairing
  rw [Matrix.transpose_smul, Matrix.smul_mul, Matrix.trace_smul]
  rfl

/-- The factored variation has the standard gravity and matter coefficients. -/
theorem totalMetricFirstVariation_eq_standard
    (kappa : Real) (einstein stress variation : Tensor (I := I))
    (hkappa : Not (kappa = 0)) :
    totalMetricFirstVariation kappa einstein stress variation =
      (1 / (2 * kappa)) * metricVariationPairing einstein variation -
        (1 / 2) * metricVariationPairing stress variation := by
  unfold totalMetricFirstVariation
  field_simp [hkappa]

omit [Fintype I] in
/-- Scalar multiplication preserves symmetry. -/
theorem smul_isSymm
    (a : Real) (T : Tensor (I := I)) (hT : T.IsSymm) :
    (a • T).IsSymm := by
  exact hT.smul a

omit [Fintype I] in
/-- The Einstein left side is symmetric when Ricci and the metric are. -/
theorem finiteEinsteinLHS_isSymm
    (ricci : Tensor (I := I)) (scalarCurvature : Real)
    (metric : Tensor (I := I)) (cosmologicalConstant : Real)
    (hRicci : ricci.IsSymm) (hMetric : metric.IsSymm) :
    (finiteEinsteinLHS ricci scalarCurvature metric
      cosmologicalConstant).IsSymm := by
  unfold finiteEinsteinLHS finiteEinsteinTensor
  exact (hRicci.sub (hMetric.smul (scalarCurvature / 2))).add
    (hMetric.smul cosmologicalConstant)

/-- **Full finite variational equation.** For nonzero coupling and symmetric
coefficient tensors, stationarity against all symmetric variations is
equivalent to equality of the tensor coefficients. -/
theorem metricStationary_iff_coefficientEquation
    (kappa : Real) (einstein stress : Tensor (I := I))
    (hEinstein : einstein.IsSymm) (hStress : stress.IsSymm)
    (hkappa : Not (kappa = 0)) :
    MetricStationary kappa einstein stress <-> einstein = kappa • stress := by
  constructor
  · intro hStationary
    apply symmetricStress_unique_of_fullMetricVariation
      einstein (kappa • stress) hEinstein (smul_isSymm kappa stress hStress)
    intro variation hVariation
    rw [metricVariationPairing_smul_left]
    have hVariationZero := hStationary variation hVariation
    unfold totalMetricFirstVariation at hVariationZero
    have hCoefficient : Not ((1 / (2 * kappa) : Real) = 0) := by
      exact one_div_ne_zero (mul_ne_zero (by norm_num) hkappa)
    exact sub_eq_zero.mp
      ((mul_eq_zero.mp hVariationZero).resolve_left hCoefficient)
  · intro hEquation variation _
    unfold totalMetricFirstVariation
    rw [hEquation, metricVariationPairing_smul_left]
    ring

/-- **Finite Einstein equation from stationarity.** This theorem supplies the
exact last variational implication, conditional on the finite Ricci, scalar,
metric, stress tensor, and nonzero coupling already having been constructed. -/
theorem metricStationary_iff_finiteEinsteinEquation
    (kappa : Real) (ricci : Tensor (I := I)) (scalarCurvature : Real)
    (metric : Tensor (I := I)) (cosmologicalConstant : Real)
    (stress : Tensor (I := I))
    (hRicci : ricci.IsSymm) (hMetric : metric.IsSymm)
    (hStress : stress.IsSymm) (hkappa : Not (kappa = 0)) :
    MetricStationary kappa
        (finiteEinsteinLHS ricci scalarCurvature metric
          cosmologicalConstant) stress <->
      FiniteEinsteinEquation kappa ricci scalarCurvature metric
        cosmologicalConstant stress := by
  exact metricStationary_iff_coefficientEquation kappa
    (finiteEinsteinLHS ricci scalarCurvature metric cosmologicalConstant)
    stress
    (finiteEinsteinLHS_isSymm ricci scalarCurvature metric
      cosmologicalConstant hRicci hMetric)
    hStress hkappa

/-- If an actual action has the displayed Einstein-matter first variation,
its ordinary stationarity is exactly `MetricStationary`. The proof uses
uniqueness of the derivative, so the action-level premise cannot be replaced
by merely naming the desired residual a variation. -/
theorem actionMetricStationary_iff_metricStationary
    (action : Tensor (I := I) -> Real) (baseMetric : Tensor (I := I))
    (kappa : Real) (einstein stress : Tensor (I := I))
    (hFirstVariation : HasEinsteinMetricFirstVariation action baseMetric
      kappa einstein stress) :
    ActionMetricStationary action baseMetric <->
      MetricStationary kappa einstein stress := by
  constructor
  · intro hAction variation hVariation
    exact (hFirstVariation variation hVariation).unique
      (hAction variation hVariation)
  · intro hMetric variation hVariation
    have hDerivative := hFirstVariation variation hVariation
    rw [hMetric variation hVariation] at hDerivative
    exact hDerivative

/-- **Action-level finite Einstein equation.** Once the directional derivative
of a genuine finite action has been identified with the standard normalized
pairing, stationarity of that action is equivalent to the full finite Einstein
equation. Deriving `hFirstVariation` from a null-edge action remains the open
dynamical gate. -/
theorem actionMetricStationary_iff_finiteEinsteinEquation
    (action : Tensor (I := I) -> Real) (baseMetric : Tensor (I := I))
    (kappa : Real) (ricci : Tensor (I := I)) (scalarCurvature : Real)
    (metric : Tensor (I := I)) (cosmologicalConstant : Real)
    (stress : Tensor (I := I))
    (hFirstVariation : HasEinsteinMetricFirstVariation action baseMetric kappa
      (finiteEinsteinLHS ricci scalarCurvature metric cosmologicalConstant)
      stress)
    (hRicci : ricci.IsSymm) (hMetric : metric.IsSymm)
    (hStress : stress.IsSymm) (hkappa : Not (kappa = 0)) :
    ActionMetricStationary action baseMetric <->
      FiniteEinsteinEquation kappa ricci scalarCurvature metric
        cosmologicalConstant stress :=
  (actionMetricStationary_iff_metricStationary action baseMetric kappa
    (finiteEinsteinLHS ricci scalarCurvature metric cosmologicalConstant)
    stress hFirstVariation).trans
      (metricStationary_iff_finiteEinsteinEquation kappa ricci
        scalarCurvature metric cosmologicalConstant stress hRicci hMetric
        hStress hkappa)

end MetricVariation

/-! ## Contracted Bianchi identity implies source conservation -/

section Conservation

open FiniteContractedBianchi

variable {I R : Type*} [Fintype I] [DecidableEq I] [Field R] [CharZero R]

/-- Derivative of a covariant rank-two tensor in a fixed frame. -/
abbrev TensorDerivative := I -> I -> I -> R

/-- Divergence of a tensor derivative in the diagonal orthonormal frame used
by `FiniteContractedBianchi`. -/
def tensorDivergence
    (weight : I -> R) (dT : TensorDerivative (I := I) (R := R))
    (d : I) : R :=
  Finset.univ.sum fun b => weight b * dT b b d

omit [CharZero R] in
/-- A differentiated component field equation contracts to the corresponding
divergence equation. -/
theorem divEinstein_eq_coupling_mul_tensorDivergence
    (weight : I -> R) (dR : CurvatureDerivative (I := I) (R := R))
    (kappa : R) (dStress : TensorDerivative (I := I) (R := R))
    (hFieldEquation : forall e b d,
      dEinstein weight dR e b d = kappa * dStress e b d)
    (d : I) :
    divEinstein weight dR d =
      kappa * tensorDivergence weight dStress d := by
  unfold divEinstein tensorDivergence
  calc
    (Finset.univ.sum fun b => weight b * dEinstein weight dR b b d) =
        Finset.univ.sum (fun b => weight b * (kappa * dStress b b d)) := by
      apply Finset.sum_congr rfl
      intro b _
      rw [hFieldEquation b b d]
    _ = kappa * Finset.univ.sum (fun b => weight b * dStress b b d) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro b _
      ring

/-- **Finite source conservation.** The explicit finite contracted Bianchi
identity and a differentiated Einstein equation force zero source divergence
for nonzero coupling. A constant cosmological term is compatible with this
statement when metric compatibility makes its covariant derivative vanish. -/
theorem tensorDivergence_eq_zero_of_bianchi_and_fieldEquation
    (weight : I -> R) (dR : CurvatureDerivative (I := I) (R := R))
    (kappa : R) (dStress : TensorDerivative (I := I) (R := R))
    (hkappa : Not (kappa = 0))
    (hWeight : forall i, weight i * weight i = 1)
    (hFirst : forall e a b c d, dR e a b c d = -dR e b a c d)
    (hLast : forall e a b c d, dR e a b c d = -dR e a b d c)
    (hBianchi : forall e a b c d,
      dR e a b c d + dR c a b d e + dR d a b e c = 0)
    (hFieldEquation : forall e b d,
      dEinstein weight dR e b d = kappa * dStress e b d)
    (d : I) :
    tensorDivergence weight dStress d = 0 := by
  have hEinsteinZero :=
    divEinstein_eq_zero weight dR hWeight hFirst hLast hBianchi d
  have hDivergenceEquation :=
    divEinstein_eq_coupling_mul_tensorDivergence
      weight dR kappa dStress hFieldEquation d
  rw [hEinsteinZero] at hDivergenceEquation
  have hProduct : kappa * tensorDivergence weight dStress d = 0 :=
    hDivergenceEquation.symm
  exact (mul_eq_zero.mp hProduct).resolve_left hkappa

end Conservation

/-! ## Nonzero Lorentz-signature witness -/

section Witness

abbrev Fin2 := Fin 2

/-- A `(+,-)` metric used by the finite variation witness. -/
def witnessMetric : Matrix Fin2 Fin2 Real := !![1, 0; 0, -1]

/-- A symmetric Ricci tensor whose contraction by `witnessMetric` is `2`. -/
def witnessRicci : Matrix Fin2 Fin2 Real := !![3, 0; 0, 1]

/-- A nonzero symmetric source. -/
def witnessStress : Matrix Fin2 Fin2 Real := !![1, 0; 0, 1]

theorem witnessMetric_isSymm : witnessMetric.IsSymm := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [witnessMetric]

theorem witnessRicci_isSymm : witnessRicci.IsSymm := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [witnessRicci]

theorem witnessStress_isSymm : witnessStress.IsSymm := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [witnessStress]

/-- The Lorentz metric used by the witness is its own inverse. -/
theorem witnessMetric_selfInverse : witnessMetric * witnessMetric = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [witnessMetric, Matrix.mul_apply, Fin.sum_univ_two]

/-- The displayed scalar-curvature parameter is the contraction of the
witness inverse metric and Ricci tensor. -/
theorem witness_scalar_contraction :
    Matrix.trace (witnessMetric * witnessRicci) = 2 := by
  norm_num [Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two, witnessMetric,
    witnessRicci]

/-- The witness satisfies `G_ab = 2 T_ab` with scalar curvature `2` and
zero cosmological constant. -/
theorem witness_finiteEinsteinEquation :
    FiniteEinsteinEquation 2 witnessRicci 2 witnessMetric 0
      witnessStress := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [FiniteEinsteinEquation, finiteEinsteinLHS,
      finiteEinsteinTensor, witnessRicci, witnessMetric, witnessStress]

/-- The variational theorem has a nonzero Lorentz-signature model: both the
Einstein coefficient and source are nonzero, the field equation holds, and
the total first variation vanishes for every symmetric probe. -/
theorem nonzero_stationary_einstein_witness :
    Not (finiteEinsteinLHS witnessRicci 2 witnessMetric 0 = 0) /\
      Not (witnessStress = 0) /\
      FiniteEinsteinEquation 2 witnessRicci 2 witnessMetric 0 witnessStress /\
      MetricStationary 2
        (finiteEinsteinLHS witnessRicci 2 witnessMetric 0) witnessStress := by
  refine ⟨?_, ?_, witness_finiteEinsteinEquation, ?_⟩
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    norm_num [finiteEinsteinLHS, finiteEinsteinTensor, witnessRicci,
      witnessMetric] at h00
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    norm_num [witnessStress] at h00
  · exact (metricStationary_iff_finiteEinsteinEquation 2 witnessRicci 2
      witnessMetric 0 witnessStress witnessRicci_isSymm witnessMetric_isSymm
      witnessStress_isSymm (by norm_num)).2 witness_finiteEinsteinEquation

end Witness

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.EinsteinEquationVariation.metricStationary_iff_finiteEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EinsteinEquationVariation.metricStationary_iff_finiteEinsteinEquation

/-- info: 'PhysicsSM.Draft.NullEdge.EinsteinEquationVariation.actionMetricStationary_iff_finiteEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EinsteinEquationVariation.actionMetricStationary_iff_finiteEinsteinEquation

/-- info: 'PhysicsSM.Draft.NullEdge.EinsteinEquationVariation.tensorDivergence_eq_zero_of_bianchi_and_fieldEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EinsteinEquationVariation.tensorDivergence_eq_zero_of_bianchi_and_fieldEquation

/-- info: 'PhysicsSM.Draft.NullEdge.EinsteinEquationVariation.nonzero_stationary_einstein_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EinsteinEquationVariation.nonzero_stationary_einstein_witness

end PhysicsSM.Draft.NullEdge.EinsteinEquationVariation
