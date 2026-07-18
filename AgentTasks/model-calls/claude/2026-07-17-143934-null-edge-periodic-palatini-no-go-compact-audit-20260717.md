# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-17T14:39:33`
- Finished: `2026-07-17T14:39:34`
- Timeout seconds: `60`
- Max budget USD: `1.50`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 1.50 --output-format text --add-dir 'C:\Projects\StandardModel' --tools ''
```

## Prompt

```text
Review the exact Lean sources below. Independently derive and check the ordered coefficient E^a_bc of the periodic finite Palatini connection response. Audit the conformal Fin 3 null-edge witness and the claim that E^0_00(0)=-95 implies failure even for lower-index-symmetric variations. Flag every semantic or index/sign problem. Then rank corrected architectures (link/face group-valued transport with plaquette holonomy; DEC primal/dual adjoint; midpoint/discrete gradient) and state the smallest next Lean targets and kill conditions. Do not edit files, do not assume continuum product rules, and distinguish a no-go for this discretization from a no-go for Palatini gravity. Use primary literature identifiers where possible.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/FinitePeriodicPalatiniEulerEquation.lean (949 lines)

```lean
import PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation

/-!
# Local finite Palatini equation on periodic directed carriers

The independent-connection action has an exact global directional response.
This module localizes that response on a finite carrier whose four directed
shifts are equivalences.  It supplies:

1. an exact backward-difference summation-by-parts identity;
2. a linear functional of the connection variation;
3. site-and-component probes forming a complete stationarity test;
4. the resulting local Euler coefficient.

The next layer computes that coefficient in densitized inverse-metric and
connection components and compares its unrestricted and torsion-free
projections.  No claim of continuum convergence or general Levi-Civita
uniqueness is made.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation

open scoped BigOperators

open Matrix
open StressEnergyPhysicalControls
open CoframeVolumeMetricVariation
open FinitePalatiniCoframeChartAction
open NullEdgeCoframeEinsteinBridge
open NullEdgeSpinorSoldering
open FiniteDirectedPalatiniConnectionVariation
open DirectedNullEdgeLeviCivitaEinstein
open CausalLeviCivita

variable {Site : Type*} [Fintype Site] [DecidableEq Site]

/-- Backward difference dual to the forward edge difference on a periodic
carrier. -/
def backwardDifference
    (shift : Fin 4 -> Equiv Site Site)
    (field : Site -> Real) (site : Site) (direction : Fin 4) : Real :=
  field ((shift direction).symm site) - field site

omit [DecidableEq Site] in
/-- Exact periodic summation by parts for one connection component. -/
theorem sum_weight_mul_connectionFirstJet_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (weight : Site -> Real)
    (variation : DirectedConnection Site)
    (direction upper left right : Fin 4) :
    (Finset.sum Finset.univ (fun site =>
      weight site *
        connectionFirstJet (periodicTarget shift) variation site direction
          upper left right)) =
      Finset.sum Finset.univ (fun site =>
        backwardDifference shift weight site direction *
          variation site upper left right) := by
  unfold connectionFirstJet edgeDifference periodicTarget backwardDifference
  rw [show (Finset.sum Finset.univ (fun site =>
      weight site *
        (variation (shift direction site) upper left right -
          variation site upper left right))) =
      Finset.sum Finset.univ (fun site =>
          weight site * variation (shift direction site) upper left right) -
        Finset.sum Finset.univ (fun site =>
          weight site * variation site upper left right) by
    simp only [mul_sub, Finset.sum_sub_distrib]]
  have hReindex := Equiv.sum_comp (shift direction)
    (fun site =>
      weight ((shift direction).symm site) *
        variation site upper left right)
  have hShifted :
      (Finset.sum Finset.univ (fun site =>
        weight site * variation (shift direction site) upper left right)) =
        Finset.sum Finset.univ (fun site =>
          weight ((shift direction).symm site) *
            variation site upper left right) := by
    simpa using hReindex
  rw [hShifted]
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro site _
  ring

/-- A connection variation supported at one site and one ordered component. -/
def connectionComponentProbe
    (site : Site) (upper left right : Fin 4) : DirectedConnection Site :=
  Pi.single site
    (Pi.single upper (Pi.single left (Pi.single right (1 : Real))))

omit [Fintype Site] [DecidableEq Site] in
/-- A directed connection first jet is additive in its connection field. -/
theorem connectionFirstJet_add
    (target : Site -> Fin 4 -> Site)
    (variation variation' : DirectedConnection Site)
    (site : Site) (direction upper left right : Fin 4) :
    connectionFirstJet target (variation + variation') site direction upper
        left right =
      connectionFirstJet target variation site direction upper left right +
        connectionFirstJet target variation' site direction upper left right := by
  simp [connectionFirstJet, edgeDifference]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- A directed connection first jet is homogeneous in its connection field. -/
theorem connectionFirstJet_smul
    (target : Site -> Fin 4 -> Site)
    (variation : DirectedConnection Site) (scalar : Real)
    (site : Site) (direction upper left right : Fin 4) :
    connectionFirstJet target (scalar • variation) site direction upper left
        right =
      scalar * connectionFirstJet target variation site direction upper left
        right := by
  simp [connectionFirstJet, edgeDifference]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- The Riemann first response is additive in the connection variation. -/
theorem connectionRiemannFirstVariation_add
    (target : Site -> Fin 4 -> Site)
    (connection variation variation' : DirectedConnection Site)
    (site : Site) (upper lower left right : Fin 4) :
    connectionRiemannFirstVariation target connection
        (variation + variation') site upper lower left right =
      connectionRiemannFirstVariation target connection variation site upper
          lower left right +
        connectionRiemannFirstVariation target connection variation' site upper
          lower left right := by
  unfold connectionRiemannFirstVariation
  rw [connectionFirstJet_add, connectionFirstJet_add]
  rw [show Finset.sum Finset.univ (fun middle =>
      (variation + variation') site upper left middle *
              connection site middle right lower
          + connection site upper left middle *
              (variation + variation') site middle right lower
          - (variation + variation') site upper right middle *
              connection site middle left lower
          - connection site upper right middle *
              (variation + variation') site middle left lower) =
      Finset.sum Finset.univ (fun middle =>
        variation site upper left middle * connection site middle right lower +
          connection site upper left middle * variation site middle right lower -
          variation site upper right middle * connection site middle left lower -
          connection site upper right middle * variation site middle left lower) +
      Finset.sum Finset.univ (fun middle =>
        variation' site upper left middle * connection site middle right lower +
          connection site upper left middle * variation' site middle right lower -
          variation' site upper right middle * connection site middle left lower -
          connection site upper right middle * variation' site middle left lower) by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro middle _
    simp only [Pi.add_apply]
    ring]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- The Riemann first response is homogeneous in the connection variation. -/
theorem connectionRiemannFirstVariation_smul
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site) (scalar : Real)
    (site : Site) (upper lower left right : Fin 4) :
    connectionRiemannFirstVariation target connection (scalar • variation)
        site upper lower left right =
      scalar * connectionRiemannFirstVariation target connection variation site
        upper lower left right := by
  unfold connectionRiemannFirstVariation
  rw [connectionFirstJet_smul, connectionFirstJet_smul]
  rw [show Finset.sum Finset.univ (fun middle =>
      (scalar • variation) site upper left middle *
              connection site middle right lower
          + connection site upper left middle *
              (scalar • variation) site middle right lower
          - (scalar • variation) site upper right middle *
              connection site middle left lower
          - connection site upper right middle *
              (scalar • variation) site middle left lower) =
      scalar * Finset.sum Finset.univ (fun middle =>
        variation site upper left middle * connection site middle right lower +
          connection site upper left middle * variation site middle right lower -
          variation site upper right middle * connection site middle left lower -
          connection site upper right middle * variation site middle left lower) by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro middle _
    simp only [Pi.smul_apply, smul_eq_mul]
    ring]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- The raw Ricci first response is additive in the connection variation. -/
theorem connectionRawRicciFirstVariation_add
    (target : Site -> Fin 4 -> Site)
    (connection variation variation' : DirectedConnection Site)
    (site : Site) :
    connectionRawRicciFirstVariation target connection
        (variation + variation') site =
      connectionRawRicciFirstVariation target connection variation site +
        connectionRawRicciFirstVariation target connection variation' site := by
  ext lower right
  unfold connectionRawRicciFirstVariation
  simp only [Matrix.add_apply]
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro upper _
  exact connectionRiemannFirstVariation_add target connection variation
    variation' site upper lower upper right

omit [Fintype Site] [DecidableEq Site] in
/-- The raw Ricci first response is homogeneous in the connection variation. -/
theorem connectionRawRicciFirstVariation_smul
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site) (scalar : Real)
    (site : Site) :
    connectionRawRicciFirstVariation target connection
        (scalar • variation) site =
      scalar • connectionRawRicciFirstVariation target connection variation
        site := by
  ext lower right
  unfold connectionRawRicciFirstVariation
  simp only [Matrix.smul_apply, smul_eq_mul]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro upper _
  exact connectionRiemannFirstVariation_smul target connection variation scalar
    site upper lower upper right

omit [Fintype Site] [DecidableEq Site] in
/-- The Frobenius pairing is additive in its tensor argument. -/
theorem metricVariationPairing_add_left
    (tensor tensor' variation : Matrix (Fin 4) (Fin 4) Real) :
    metricVariationPairing (tensor + tensor') variation =
      metricVariationPairing tensor variation +
        metricVariationPairing tensor' variation := by
  unfold metricVariationPairing
  rw [Matrix.transpose_add, Matrix.add_mul, Matrix.trace_add]

omit [Fintype Site] [DecidableEq Site] in
/-- The Frobenius pairing is homogeneous in its tensor argument. -/
theorem metricVariationPairing_smul_left
    (tensor variation : Matrix (Fin 4) (Fin 4) Real) (scalar : Real) :
    metricVariationPairing (scalar • tensor) variation =
      scalar * metricVariationPairing tensor variation := by
  unfold metricVariationPairing
  rw [Matrix.transpose_smul, Matrix.smul_mul, Matrix.trace_smul]
  rfl

omit [DecidableEq Site] in
/-- The finite Palatini response is additive in the connection variation. -/
theorem directedPalatiniConnectionResponse_add
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation variation' : DirectedConnection Site) :
    directedPalatiniConnectionResponse (periodicTarget shift) volume
        inverseMetric connection (variation + variation') =
      directedPalatiniConnectionResponse (periodicTarget shift) volume
        inverseMetric connection variation +
      directedPalatiniConnectionResponse (periodicTarget shift) volume
        inverseMetric connection variation' := by
  classical
  unfold directedPalatiniConnectionResponse
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro site _
  rw [connectionRawRicciFirstVariation_add,
    metricVariationPairing_add_left]
  ring

omit [DecidableEq Site] in
/-- The finite Palatini response is homogeneous in the connection variation.
-/
theorem directedPalatiniConnectionResponse_smul
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation : DirectedConnection Site) (scalar : Real) :
    directedPalatiniConnectionResponse (periodicTarget shift) volume
        inverseMetric connection (scalar • variation) =
      scalar *
        directedPalatiniConnectionResponse (periodicTarget shift) volume
          inverseMetric connection variation := by
  classical
  unfold directedPalatiniConnectionResponse
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro site _
  rw [connectionRawRicciFirstVariation_smul,
    metricVariationPairing_smul_left]
  ring

/-- The connection response bundled as a real linear functional. -/
def directedPalatiniConnectionResponseLinear
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) :
    DirectedConnection Site →ₗ[Real] Real where
  toFun := directedPalatiniConnectionResponse (periodicTarget shift) volume
    inverseMetric connection
  map_add' := directedPalatiniConnectionResponse_add shift volume inverseMetric
    connection
  map_smul' scalar variation := by
    rw [directedPalatiniConnectionResponse_smul shift volume inverseMetric
      connection variation scalar]
    rfl

/-- The volume-weighted inverse metric that is natural in the Palatini
connection equation. -/
def densitizedInverseMetric
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (site : Site) (left right : Fin 4) : Real :=
  volume site * inverseMetric site left right

/-- Closed local coefficient of an ordered connection variation
`H^upper_left right`.  The first two terms are the periodic backward-divergence
response and the remaining four are the connection cross terms. -/
def explicitConnectionEulerCoefficient
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) : Real :=
  backwardDifference shift
      (fun nextSite =>
        densitizedInverseMetric volume inverseMetric nextSite right left)
      site upper
    - (if upper = left then
        Finset.sum Finset.univ (fun direction =>
          backwardDifference shift
            (fun nextSite =>
              densitizedInverseMetric volume inverseMetric nextSite right
                direction)
            site direction)
      else 0)
    + (if upper = left then
        Finset.sum Finset.univ (fun metricLeft =>
          Finset.sum Finset.univ (fun metricRight =>
            densitizedInverseMetric volume inverseMetric site metricLeft
                metricRight *
              connection site right metricRight metricLeft))
      else 0)
    + densitizedInverseMetric volume inverseMetric site right left *
        Finset.sum Finset.univ (fun traced =>
          connection site traced traced upper)
    - Finset.sum Finset.univ (fun metricLeft =>
        densitizedInverseMetric volume inverseMetric site metricLeft left *
          connection site right upper metricLeft)
    - Finset.sum Finset.univ (fun metricRight =>
        densitizedInverseMetric volume inverseMetric site right metricRight *
          connection site left metricRight upper)

/-- Sitewise ordered-component Euler coefficient, defined by evaluating the
derived response on the corresponding unit connection probe. -/
def connectionEulerCoefficient
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) : Real :=
  directedPalatiniConnectionResponse (periodicTarget shift) volume
    inverseMetric connection (connectionComponentProbe site upper left right)

/-- The probe-defined Euler coefficient equals its local
densitized-inverse-metric formula. -/
theorem connectionEulerCoefficient_eq_explicit
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) :
    connectionEulerCoefficient shift volume inverseMetric connection site
        upper left right =
      explicitConnectionEulerCoefficient shift volume inverseMetric connection
        site upper left right := by
  classical
  sorry

/-- Vanishing of all local ordered-component coefficients is equivalent to
the full independent-connection Euler-Lagrange equation. -/
theorem connectionEulerLagrange_iff_coefficients
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) :
    ConnectionEulerLagrange (periodicTarget shift) volume inverseMetric
        connection <->
      forall site upper left right,
        connectionEulerCoefficient shift volume inverseMetric connection site
          upper left right = 0 := by
  constructor
  · intro hEuler site upper left right
    exact hEuler (connectionComponentProbe site upper left right)
  · intro hCoefficient variation
    let response := directedPalatiniConnectionResponseLinear shift volume
      inverseMetric connection
    have hResponse : response = 0 := by
      apply LinearMap.pi_ext'
      intro site
      change response.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site) = 0
      apply LinearMap.pi_ext'
      intro upper
      change (response.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper) = 0
      apply LinearMap.pi_ext'
      intro left
      change ((response.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Fin 4 → Real) left) = 0
      apply LinearMap.pi_ext'
      intro right
      change (((response.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Fin 4 → Real) left)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Real) right) = 0
      apply LinearMap.ext
      intro scalar
      change response
        (Pi.single site
          (Pi.single upper (Pi.single left (Pi.single right scalar)))) = 0
      have hProbe :
          Pi.single site
              (Pi.single upper (Pi.single left (Pi.single right scalar))) =
            scalar • connectionComponentProbe site upper left right := by
        ext nextSite nextUpper nextLeft nextRight
        by_cases hSite : nextSite = site <;>
          by_cases hUpper : nextUpper = upper <;>
          by_cases hLeft : nextLeft = left <;>
          by_cases hRight : nextRight = right <;>
          simp [connectionComponentProbe, hSite, hUpper,
            hLeft, hRight]
      rw [hProbe, map_smul]
      change scalar * connectionEulerCoefficient shift volume inverseMetric
        connection site upper left right = 0
      rw [hCoefficient]
      simp
    change response variation = 0
    rw [hResponse]
    rfl

/-! ## Torsion-free variation sector -/

/-- Symmetry of the two lower indices of a connection variation. -/
def LowerIndexSymmetric (variation : DirectedConnection Site) : Prop :=
  forall site upper left right,
    variation site upper left right = variation site upper right left

/-- Projection of an arbitrary ordered connection variation onto its
lower-index-symmetric part. -/
def lowerIndexSymmetrize (variation : DirectedConnection Site) :
    DirectedConnection Site :=
  fun site upper left right =>
    (variation site upper left right + variation site upper right left) / 2

omit [Fintype Site] [DecidableEq Site] in
/-- Lower-index symmetrization produces a torsion-free variation. -/
theorem lowerIndexSymmetrize_symmetric (variation : DirectedConnection Site) :
    LowerIndexSymmetric (lowerIndexSymmetrize variation) := by
  intro site upper left right
  simp only [lowerIndexSymmetrize]
  ring

omit [Fintype Site] [DecidableEq Site] in
/-- Symmetrization fixes every lower-index-symmetric variation. -/
theorem lowerIndexSymmetrize_eq_of_symmetric
    (variation : DirectedConnection Site)
    (hSymmetric : LowerIndexSymmetric variation) :
    lowerIndexSymmetrize variation = variation := by
  funext site upper left right
  rw [lowerIndexSymmetrize, hSymmetric site upper right left]
  ring

/-- Lower-index symmetrization as a real linear map. -/
def lowerIndexSymmetrizeLinear :
    DirectedConnection Site →ₗ[Real] DirectedConnection Site where
  toFun := lowerIndexSymmetrize
  map_add' variation variation' := by
    ext site upper left right
    simp only [lowerIndexSymmetrize, Pi.add_apply]
    ring
  map_smul' scalar variation := by
    ext site upper left right
    simp only [lowerIndexSymmetrize, Pi.smul_apply, smul_eq_mul,
      RingHom.id_apply]
    ring

omit [Fintype Site] in
/-- Symmetrizing a component probe adds its lower-index transpose with the
standard factor `1 / 2`. -/
theorem lowerIndexSymmetrize_componentProbe
    (site : Site) (upper left right : Fin 4) :
    lowerIndexSymmetrize (connectionComponentProbe site upper left right) =
      (1 / 2 : Real) •
        (connectionComponentProbe site upper left right +
          connectionComponentProbe site upper right left) := by
  ext nextSite nextUpper nextLeft nextRight
  by_cases hSame : left = right <;>
    by_cases hSite : nextSite = site <;>
    by_cases hUpper : nextUpper = upper <;>
    by_cases hLeftLeft : nextLeft = left <;>
    by_cases hRightRight : nextRight = right <;>
    by_cases hLeftRight : nextLeft = right <;>
    by_cases hRightLeft : nextRight = left <;>
    simp_all [lowerIndexSymmetrize, connectionComponentProbe]
  all_goals ring

/-- Stationarity under all torsion-free (lower-index-symmetric) connection
variations. -/
def TorsionFreeConnectionEulerLagrange
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) : Prop :=
  forall variation : DirectedConnection Site,
    LowerIndexSymmetric variation ->
      directedPalatiniConnectionResponse (periodicTarget shift) volume
        inverseMetric connection variation = 0

omit [DecidableEq Site] in
/-- Testing all torsion-free variations is equivalent to testing the
symmetrization of every ordered variation. -/
theorem torsionFreeConnectionEulerLagrange_iff_symmetrized
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) :
    TorsionFreeConnectionEulerLagrange shift volume inverseMetric connection <->
      forall variation : DirectedConnection Site,
        directedPalatiniConnectionResponse (periodicTarget shift) volume
          inverseMetric connection (lowerIndexSymmetrize variation) = 0 := by
  constructor
  · intro hEuler variation
    exact hEuler (lowerIndexSymmetrize variation)
      (lowerIndexSymmetrize_symmetric variation)
  · intro hEuler variation hSymmetric
    rw [← lowerIndexSymmetrize_eq_of_symmetric variation hSymmetric]
    exact hEuler variation

/-- A linear functional on directed connections vanishes identically exactly
when it vanishes on every site-and-component probe. -/
theorem linearFunctional_eq_zero_iff_componentProbes
    (functional : DirectedConnection Site →ₗ[Real] Real) :
    (forall variation, functional variation = 0) <->
      forall site upper left right,
        functional (connectionComponentProbe site upper left right) = 0 := by
  constructor
  · intro hFunctional site upper left right
    exact hFunctional (connectionComponentProbe site upper left right)
  · intro hProbe variation
    have hFunctional : functional = 0 := by
      apply LinearMap.pi_ext'
      intro site
      change functional.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site) = 0
      apply LinearMap.pi_ext'
      intro upper
      change (functional.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper) = 0
      apply LinearMap.pi_ext'
      intro left
      change ((functional.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Fin 4 → Real) left) = 0
      apply LinearMap.pi_ext'
      intro right
      change (((functional.comp (LinearMap.single Real
        (fun _ : Site => Fin 4 → Fin 4 → Fin 4 → Real) site)).comp
          (LinearMap.single Real
            (fun _ : Fin 4 => Fin 4 → Fin 4 → Real) upper)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Fin 4 → Real) left)).comp
          (LinearMap.single Real (fun _ : Fin 4 => Real) right) = 0
      apply LinearMap.ext
      intro scalar
      change functional
        (Pi.single site
          (Pi.single upper (Pi.single left (Pi.single right scalar)))) = 0
      have hScaledProbe :
          Pi.single site
              (Pi.single upper (Pi.single left (Pi.single right scalar))) =
            scalar • connectionComponentProbe site upper left right := by
        ext nextSite nextUpper nextLeft nextRight
        by_cases hSite : nextSite = site <;>
          by_cases hUpper : nextUpper = upper <;>
          by_cases hLeft : nextLeft = left <;>
          by_cases hRight : nextRight = right <;>
          simp [connectionComponentProbe, hSite, hUpper, hLeft, hRight]
      rw [hScaledProbe, map_smul, hProbe]
      simp
    rw [hFunctional]
    rfl

/-- The torsion-free connection equation is the lower-index-symmetric
projection of the unrestricted local Euler coefficient. -/
theorem torsionFreeConnectionEulerLagrange_iff_symmetricCoefficients
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) :
    TorsionFreeConnectionEulerLagrange shift volume inverseMetric connection <->
      forall site upper left right,
        connectionEulerCoefficient shift volume inverseMetric connection site
              upper left right +
            connectionEulerCoefficient shift volume inverseMetric connection
              site upper right left = 0 := by
  rw [torsionFreeConnectionEulerLagrange_iff_symmetrized]
  let response := directedPalatiniConnectionResponseLinear shift volume
    inverseMetric connection
  let symmetrizedResponse := response.comp lowerIndexSymmetrizeLinear
  change (forall variation, symmetrizedResponse variation = 0) <-> _
  rw [linearFunctional_eq_zero_iff_componentProbes]
  constructor
  · intro hProbe site upper left right
    have h := hProbe site upper left right
    change response
      (lowerIndexSymmetrize
        (connectionComponentProbe site upper left right)) = 0 at h
    rw [lowerIndexSymmetrize_componentProbe, map_smul, map_add] at h
    change (1 / 2 : Real) *
      (connectionEulerCoefficient shift volume inverseMetric connection site
          upper left right +
        connectionEulerCoefficient shift volume inverseMetric connection site
          upper right left) = 0 at h
    linarith
  · intro hCoefficient site upper left right
    change response
      (lowerIndexSymmetrize
        (connectionComponentProbe site upper left right)) = 0
    rw [lowerIndexSymmetrize_componentProbe, map_smul, map_add]
    change (1 / 2 : Real) *
      (connectionEulerCoefficient shift volume inverseMetric connection site
          upper left right +
        connectionEulerCoefficient shift volume inverseMetric connection site
          upper right left) = 0
    rw [hCoefficient]
    norm_num

/-! ## Exact finite conformal obstruction -/

/-- The forward three-cycle used by the finite conformal witness. -/
def conformalCycle3 : Equiv (Fin 3) (Fin 3) where
  toFun := ![1, 2, 0]
  invFun := ![2, 0, 1]
  left_inv site := by fin_cases site <;> rfl
  right_inv site := by fin_cases site <;> rfl

/-- Every coordinate direction uses the same periodic shift in the minimal
three-site witness. -/
def conformalTestShift (_ : Fin 4) : Equiv (Fin 3) (Fin 3) :=
  conformalCycle3

/-- Sitewise conformal factors induced by real spinor scales `1`, `2`, and
`3`: a spinor scale `r` gives the metric scale `r^4`. -/
def conformalTestScale : Fin 3 -> Real := ![1, 16, 81]

/-- Real sitewise scale of each canonical Weyl spinor. -/
def conformalTestSpinorScale : Fin 3 -> Real := ![1, 2, 3]

/-- Sitewise scaled canonical Weyl-spinor null edges underlying the conformal
witness. -/
def conformalTestEdges : NullEdgeDecoration (Fin 3) :=
  fun site edge component =>
    (conformalTestSpinorScale site : Complex) * canonicalNullEdges edge component

/-- Gram metric of the canonical four-null-edge coframe. -/
def canonicalNullEdgeMetricMatrix : Matrix (Fin 4) (Fin 4) Real :=
  !![0, 1 / 2, 1 / 2, 1 / 2;
     1 / 2, 0, 1 / 2, 1 / 2;
     1 / 2, 1 / 2, 0, 1;
     1 / 2, 1 / 2, 1, 0]

/-- Inverse of `canonicalNullEdgeMetricMatrix`. -/
def canonicalNullEdgeInverseMetricMatrix : Matrix (Fin 4) (Fin 4) Real :=
  !![-2, 0, 1, 1;
     0, -2, 1, 1;
     1, 1, -1, 0;
     1, 1, 0, -1]

/-- The displayed covariant matrix is exactly the Gram metric soldered from
the canonical four Weyl-spinor null edges. -/
theorem canonicalNullEdgeMetricMatrix_eq :
    nullEdgeMetricAt canonicalNullEdges = canonicalNullEdgeMetricMatrix := by
  rw [nullEdgeMetricAt, inducedCovariantMetric,
    canonicalNullEdgeCoframe_eq]
  ext left right
  fin_cases left <;> fin_cases right <;>
    norm_num [canonicalNullEdgeMetricMatrix, canonicalCoframe,
      minkowskiMetric, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The soldered coframe scales quadratically under the real spinor scales in
the conformal witness. -/
theorem conformalTestCoframe_eq (site : Fin 3) :
    nullEdgeCoframeAt (conformalTestEdges site) =
      (conformalTestSpinorScale site ^ 2) • canonicalCoframe := by
  ext coordinate edge
  change
    nullEdgeVector
        (fun component =>
          (conformalTestSpinorScale site : Complex) *
            canonicalNullEdges edge component)
        coordinate = _
  rw [nullEdgeVector_smul]
  change Complex.normSq (conformalTestSpinorScale site : Complex) *
      nullEdgeCoframeAt canonicalNullEdges coordinate edge =
    conformalTestSpinorScale site ^ 2 * canonicalCoframe coordinate edge
  rw [canonicalNullEdgeCoframe_eq]
  fin_cases site <;>
    norm_num [conformalTestSpinorScale, Complex.normSq_apply]

/-- The metric scale is the fourth power of the underlying real spinor scale.
-/
theorem conformalTestScale_eq_spinorScale_fourth (site : Fin 3) :
    conformalTestScale site = conformalTestSpinorScale site ^ 4 := by
  fin_cases site <;>
    norm_num [conformalTestScale, conformalTestSpinorScale]

/-- Conformally varying covariant metric in the three-site witness. -/
def conformalTestMetric (site : Fin 3) : Matrix (Fin 4) (Fin 4) Real :=
  conformalTestScale site • canonicalNullEdgeMetricMatrix

/-- The covariant metric in the obstruction is derived from the displayed
sitewise scaled null edges. -/
theorem conformalTestMetric_eq_nullEdgeMetric (site : Fin 3) :
    conformalTestMetric site = nullEdgeMetricAt (conformalTestEdges site) := by
  rw [nullEdgeMetricAt, conformalTestCoframe_eq, conformalTestMetric,
    conformalTestScale_eq_spinorScale_fourth,
    ← canonicalNullEdgeMetricMatrix_eq]
  simp only [nullEdgeMetricAt, inducedCovariantMetric]
  rw [canonicalNullEdgeCoframe_eq]
  ext left right
  simp only [Matrix.transpose_smul, Matrix.smul_mul, Matrix.mul_smul,
    Matrix.smul_apply, smul_eq_mul]
  ring

/-- Exact inverse metric of the conformal witness. -/
def conformalTestInverseMetric (site : Fin 3) :
    Matrix (Fin 4) (Fin 4) Real :=
  (conformalTestScale site)⁻¹ • canonicalNullEdgeInverseMetricMatrix

/-- The displayed canonical matrices are exact two-sided inverses. -/
theorem canonicalNullEdgeMetricMatrix_mul_inverse :
    canonicalNullEdgeMetricMatrix * canonicalNullEdgeInverseMetricMatrix = 1 := by
  ext left right
  fin_cases left <;> fin_cases right <;>
    norm_num [canonicalNullEdgeMetricMatrix,
      canonicalNullEdgeInverseMetricMatrix, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- The conformally scaled inverse is an exact inverse of the conformal Gram
metric at every site. -/
theorem conformalTestMetric_mul_inverse (site : Fin 3) :
    conformalTestMetric site * conformalTestInverseMetric site = 1 := by
  fin_cases site <;>
    ext left right <;>
    fin_cases left <;> fin_cases right <;>
    norm_num [conformalTestMetric, conformalTestInverseMetric,
      conformalTestScale, canonicalNullEdgeMetricMatrix,
      canonicalNullEdgeInverseMetricMatrix, Matrix.mul_apply,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Fin.sum_univ_succ]

/-- The scaled canonical spinors remain a nondegenerate null-edge frame. -/
def conformalTestFrame : NondegenerateNullEdgeFrame (Fin 3) where
  edges := conformalTestEdges
  det_ne_zero site := by
    change (nullEdgeCoframeAt (conformalTestEdges site)).det ≠ 0
    rw [conformalTestCoframe_eq, Matrix.det_smul, canonicalCoframe_det]
    fin_cases site <;>
      norm_num [conformalTestSpinorScale]

/-- Oriented coframe volume of the conformal witness. -/
def conformalTestVolume (site : Fin 3) : Real :=
  (1 / 2) * (conformalTestScale site) ^ 2

/-- The displayed volume is exactly the oriented volume reconstructed from
the scaled null-edge coframe. -/
theorem conformalTestVolume_eq_chartBaseVolume (site : Fin 3) :
    conformalTestVolume site =
      chartBaseVolume (nullEdgeCoframe conformalTestFrame.edges) site := by
  unfold conformalTestVolume chartBaseVolume coframeVolume nullEdgeCoframe
    conformalTestFrame
  rw [conformalTestCoframe_eq, Matrix.det_smul, canonicalCoframe_det]
  fin_cases site <;>
    norm_num [conformalTestScale, conformalTestSpinorScale]

/-- The displayed inverse is the inverse metric reconstructed by the
nondegenerate null-edge-frame API. -/
theorem conformalTestInverseMetric_eq_nullEdgeInverseMetric (site : Fin 3) :
    conformalTestInverseMetric site =
      nullEdgeInverseMetric conformalTestFrame site := by
  have hMetricInverse := conformalTestMetric_mul_inverse site
  have hInverseMetric :=
    nullEdgeInverseMetric_mul_metric conformalTestFrame site
  change nullEdgeInverseMetric conformalTestFrame site *
      nullEdgeMetricAt (conformalTestEdges site) = 1 at hInverseMetric
  rw [← conformalTestMetric_eq_nullEdgeMetric] at hInverseMetric
  calc
    conformalTestInverseMetric site =
        1 * conformalTestInverseMetric site := by rw [Matrix.one_mul]
    _ = (nullEdgeInverseMetric conformalTestFrame site *
          conformalTestMetric site) * conformalTestInverseMetric site := by
      rw [hInverseMetric]
    _ = nullEdgeInverseMetric conformalTestFrame site *
          (conformalTestMetric site * conformalTestInverseMetric site) := by
      rw [Matrix.mul_assoc]
    _ = nullEdgeInverseMetric conformalTestFrame site * 1 := by
      rw [hMetricInverse]
    _ = nullEdgeInverseMetric conformalTestFrame site := by rw [Matrix.mul_one]

/-- Directed null-edge chart underlying the conformal witness. -/
def conformalTestChart : DirectedNullEdgeChart (Fin 3) where
  toNondegenerateNullEdgeFrame := conformalTestFrame
  target := periodicTarget conformalTestShift

/-- Forward metric jet used by the current finite Christoffel construction. -/
def conformalTestMetricFirstJet (site : Fin 3) :
    Fin 4 -> Matrix (Fin 4) (Fin 4) Real :=
  fun direction left right =>
    edgeDifference (periodicTarget conformalTestShift)
      (fun nextSite => conformalTestMetric nextSite left right) site direction

/-- The displayed forward metric jet is the jet reconstructed by the directed
null-edge chart. -/
theorem conformalTestMetricFirstJet_eq_nullEdgeMetricFirstJet (site : Fin 3) :
    conformalTestMetricFirstJet site =
      nullEdgeMetricFirstJet conformalTestChart site := by
  funext direction left right
  unfold conformalTestMetricFirstJet nullEdgeMetricFirstJet edgeDifference
    conformalTestChart conformalTestFrame
  change
    conformalTestMetric
          (periodicTarget conformalTestShift site direction) left right -
        conformalTestMetric site left right =
      nullEdgeMetricAt
          (conformalTestEdges
            (periodicTarget conformalTestShift site direction)) left right -
        nullEdgeMetricAt (conformalTestEdges site) left right
  rw [conformalTestMetric_eq_nullEdgeMetric,
    conformalTestMetric_eq_nullEdgeMetric]

/-- Forward-difference Levi-Civita candidate of the conformal witness. -/
def conformalTestChristoffel : DirectedConnection (Fin 3) :=
  fun site => christoffelSecondKind (conformalTestInverseMetric site)
    (conformalTestMetricFirstJet site)

/-- The displayed connection is exactly the current forward-difference
Christoffel field reconstructed by the directed null-edge chart. -/
theorem conformalTestChristoffel_eq_nullEdgeChristoffel :
    conformalTestChristoffel = nullEdgeChristoffel conformalTestChart := by
  funext site upper left right
  unfold conformalTestChristoffel nullEdgeChristoffel
  change christoffelSecondKind (conformalTestInverseMetric site)
      (conformalTestMetricFirstJet site) upper left right =
    christoffelSecondKind (nullEdgeInverseMetric conformalTestFrame site)
      (nullEdgeMetricFirstJet conformalTestChart site) upper left right
  rw [conformalTestInverseMetric_eq_nullEdgeInverseMetric,
    conformalTestMetricFirstJet_eq_nullEdgeMetricFirstJet]

/-- **Exact finite obstruction.**  The ordered local Palatini coefficient of
the current forward-difference Christoffel candidate is nonzero on a simple
three-site conformal geometry. -/
theorem conformalTest_explicitCoefficient_0000 :
    explicitConnectionEulerCoefficient conformalTestShift conformalTestVolume
      conformalTestInverseMetric conformalTestChristoffel 0 0 0 0 = -95 := by
  norm_num [explicitConnectionEulerCoefficient, backwardDifference,
    densitizedInverseMetric, conformalTestShift, conformalCycle3,
    conformalTestScale, conformalTestVolume, conformalTestInverseMetric,
    conformalTestChristoffel, conformalTestMetricFirstJet,
    conformalTestMetric, canonicalNullEdgeMetricMatrix,
    canonicalNullEdgeInverseMetricMatrix, periodicTarget, edgeDifference,
    christoffelSecondKind, christoffelFirstKind, Matrix.of_apply,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Fin.sum_univ_succ]

/-- The forward-difference Christoffel candidate fails even the torsion-free
connection equation on the conformal witness. -/
theorem conformalTestChristoffel_not_torsionFreeEuler :
    ¬ TorsionFreeConnectionEulerLagrange conformalTestShift
      conformalTestVolume conformalTestInverseMetric
      conformalTestChristoffel := by
  intro hEuler
  have hLocal :=
    (torsionFreeConnectionEulerLagrange_iff_symmetricCoefficients
      conformalTestShift conformalTestVolume conformalTestInverseMetric
      conformalTestChristoffel).mp hEuler 0 0 0 0
  have hCoefficient :
      connectionEulerCoefficient conformalTestShift conformalTestVolume
        conformalTestInverseMetric conformalTestChristoffel 0 0 0 0 = -95 := by
    rw [connectionEulerCoefficient_eq_explicit]
    exact conformalTest_explicitCoefficient_0000
  rw [hCoefficient] at hLocal
  norm_num at hLocal

/-- **Null-edge Palatini no-go for the current finite difference.**  The
Christoffel field reconstructed from a nondegenerate directed null-edge chart
is not stationary under torsion-free connection variations on this exact
three-site conformal witness. -/
theorem conformalNullEdgeChristoffel_not_torsionFreeEuler :
    ¬ TorsionFreeConnectionEulerLagrange conformalTestShift
      (chartBaseVolume (nullEdgeCoframe conformalTestFrame.edges))
      (nullEdgeInverseMetric conformalTestFrame)
      (nullEdgeChristoffel conformalTestChart) := by
  intro hEuler
  have hVolume :
      chartBaseVolume (nullEdgeCoframe conformalTestFrame.edges) =
        conformalTestVolume := by
    funext site
    exact (conformalTestVolume_eq_chartBaseVolume site).symm
  have hInverseMetric :
      nullEdgeInverseMetric conformalTestFrame =
        conformalTestInverseMetric := by
    funext site
    exact (conformalTestInverseMetric_eq_nullEdgeInverseMetric site).symm
  have hConnection :
      nullEdgeChristoffel conformalTestChart =
        conformalTestChristoffel :=
    conformalTestChristoffel_eq_nullEdgeChristoffel.symm
  rw [hVolume, hInverseMetric, hConnection] at hEuler
  exact conformalTestChristoffel_not_torsionFreeEuler hEuler

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation.sum_weight_mul_connectionFirstJet_periodic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sum_weight_mul_connectionFirstJet_periodic

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation.connectionEulerLagrange_iff_coefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms connectionEulerLagrange_iff_coefficients

/-- info: 'PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation.conformalTest_explicitCoefficient_0000' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conformalTest_explicitCoefficient_0000

end PhysicsSM.Draft.NullEdge.FinitePeriodicPalatiniEulerEquation

```

### PhysicsSM/Draft/NullEdge/FiniteDirectedPalatiniConnectionVariation.lean (562 lines)

```lean
import PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein

/-!
# Finite directed Palatini connection variation

The directed-null-edge curvature module constructs a Levi-Civita connection
from four decorated null directions and then evaluates its coordinate
curvature.  This module separates the curvature formula from that particular
connection so that the connection can be varied independently, as required by
the Palatini architecture.

For a directed carrier map `target`, a connection field `connection`, and an
arbitrary connection variation `variation`, the module proves directly from
the displayed finite formulas that

```text
d R(connection + t variation) / dt at t = 0
  = Delta variation + connection * variation + variation * connection.
```

The same calculation is contracted to Ricci and then to a genuine finite
weighted action.  Thus its connection Euler-Lagrange functional is derived,
not postulated.  Substitution of the null-edge Levi-Civita connection recovers
the earlier directed-null-edge Riemann and Ricci tensors exactly.

This is a finite decorated-chart theorem with globally synchronized direction
labels.  It does not yet prove that connection stationarity is equivalent to
metric compatibility, that the directed difference is locally Lorentz
covariant, or that this curvature converges to continuum curvature.  Signature
conventions enter only through a supplied inverse metric; the null-edge chart
uses mostly-minus `(+,-,-,-)` elsewhere in the program.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation

open scoped BigOperators

open Matrix
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open CoframeVolumeMetricVariation
open FinitePalatiniCoframeChartAction
open NullEdgeCoframeEinsteinBridge
open DirectedNullEdgeLeviCivitaEinstein

/-- A real coordinate connection field on a finite directed carrier.  The
indices are ordered as `Gamma^upper_(left,right)`. -/
abbrev DirectedConnection (Site : Type*) :=
  Site -> Fin 4 -> Fin 4 -> Fin 4 -> Real

/-- Forward directed difference of an independently supplied connection. -/
def connectionFirstJet {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection : DirectedConnection Site)
    (site : Site) (direction upper left right : Fin 4) : Real :=
  edgeDifference target
    (fun next => connection next upper left right) site direction

/-- Coordinate Riemann curvature of an arbitrary directed connection. -/
def connectionRiemann {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection : DirectedConnection Site)
    (site : Site)
    (upper lower directionLeft directionRight : Fin 4) : Real :=
  connectionFirstJet target connection site directionLeft upper
      directionRight lower
    - connectionFirstJet target connection site directionRight upper
        directionLeft lower
    + Finset.sum Finset.univ (fun middle =>
        connection site upper directionLeft middle *
            connection site middle directionRight lower
          - connection site upper directionRight middle *
            connection site middle directionLeft lower)

/-- Raw Ricci contraction of an arbitrary directed connection. -/
def connectionRawRicci {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection : DirectedConnection Site) (site : Site) :
    Matrix (Fin 4) (Fin 4) Real :=
  fun lower right => Finset.sum Finset.univ (fun upper =>
    connectionRiemann target connection site upper lower upper right)

/-- Symmetric Ricci response visible to symmetric inverse-metric variations. -/
def connectionSymmetricRicci {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection : DirectedConnection Site) (site : Site) :
    Matrix (Fin 4) (Fin 4) Real :=
  symmetricPart (connectionRawRicci target connection site)

/-! ## Exact specialization to the null-edge Levi-Civita connection -/

/-- Generic connection differences specialize to the existing null-edge
Levi-Civita first jet. -/
theorem connectionFirstJet_nullEdgeChristoffel {Site : Type*}
    (chart : DirectedNullEdgeChart Site)
    (site : Site) (direction upper left right : Fin 4) :
    connectionFirstJet chart.target (nullEdgeChristoffel chart) site direction
        upper left right =
      nullEdgeConnectionFirstJet chart site direction upper left right := by
  rfl

/-- Generic connection curvature specializes exactly to the existing
directed-null-edge curvature. -/
theorem connectionRiemann_nullEdgeChristoffel {Site : Type*}
    (chart : DirectedNullEdgeChart Site)
    (site : Site) (upper lower left right : Fin 4) :
    connectionRiemann chart.target (nullEdgeChristoffel chart) site upper lower
        left right =
      nullEdgeRiemann chart site upper lower left right := by
  rfl

/-- The generic raw Ricci contraction specializes exactly to the existing raw
null-edge Ricci tensor. -/
theorem connectionRawRicci_nullEdgeChristoffel {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    connectionRawRicci chart.target (nullEdgeChristoffel chart) site =
      nullEdgeRawRicci chart site := by
  rfl

/-- The generic symmetric Ricci response specializes exactly to the existing
null-edge symmetric Ricci response. -/
theorem connectionSymmetricRicci_nullEdgeChristoffel {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    connectionSymmetricRicci chart.target (nullEdgeChristoffel chart) site =
      nullEdgeSymmetricRicci chart site := by
  rfl

/-! ## Independent connection variation -/

/-- Affine line through a connection in an arbitrary connection direction. -/
def connectionLine {Site : Type*}
    (connection variation : DirectedConnection Site) (t : Real) :
    DirectedConnection Site :=
  fun site upper left right =>
    connection site upper left right + t * variation site upper left right

/-- First variation of coordinate Riemann curvature.  It contains the
directed difference of the connection variation and the four cross terms from
the quadratic connection contribution. -/
def connectionRiemannFirstVariation {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site)
    (site : Site)
    (upper lower directionLeft directionRight : Fin 4) : Real :=
  connectionFirstJet target variation site directionLeft upper
      directionRight lower
    - connectionFirstJet target variation site directionRight upper
        directionLeft lower
    + Finset.sum Finset.univ (fun middle =>
        variation site upper directionLeft middle *
              connection site middle directionRight lower
          + connection site upper directionLeft middle *
              variation site middle directionRight lower
          - variation site upper directionRight middle *
              connection site middle directionLeft lower
          - connection site upper directionRight middle *
              variation site middle directionLeft lower)

/-- First variation of the raw Ricci contraction. -/
def connectionRawRicciFirstVariation {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site) (site : Site) :
    Matrix (Fin 4) (Fin 4) Real :=
  fun lower right => Finset.sum Finset.univ (fun upper =>
    connectionRiemannFirstVariation target connection variation site upper
      lower upper right)

/-- Each component of the affine connection line has the expected
derivative. -/
theorem hasDerivAt_connectionLine_component {Site : Type*}
    (connection variation : DirectedConnection Site)
    (site : Site) (upper left right : Fin 4) :
    HasDerivAt
      (fun t : Real => connectionLine connection variation t site upper left right)
      (variation site upper left right) 0 := by
  simpa [connectionLine] using
    (((hasDerivAt_id (𝕜 := Real) 0).mul_const
      (variation site upper left right)).const_add
        (connection site upper left right))

/-- The derivative of a directed connection difference is the corresponding
directed difference of the variation. -/
theorem hasDerivAt_connectionFirstJet_line {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site)
    (site : Site) (direction upper left right : Fin 4) :
    HasDerivAt
      (fun t : Real =>
        connectionFirstJet target (connectionLine connection variation t)
          site direction upper left right)
      (connectionFirstJet target variation site direction upper left right) 0 := by
  unfold connectionFirstJet edgeDifference
  exact
    (hasDerivAt_connectionLine_component connection variation
      (target site direction) upper left right).sub
      (hasDerivAt_connectionLine_component connection variation
        site upper left right)

/-- **Exact finite Palatini curvature variation.**  Differentiating the
displayed directed coordinate-curvature formula gives precisely the linear
response `Delta variation + connection * variation + variation * connection`.
-/
theorem hasDerivAt_connectionRiemann_line {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site)
    (site : Site) (upper lower left right : Fin 4) :
    HasDerivAt
      (fun t : Real =>
        connectionRiemann target (connectionLine connection variation t)
          site upper lower left right)
      (connectionRiemannFirstVariation target connection variation site upper
        lower left right) 0 := by
  unfold connectionRiemann connectionRiemannFirstVariation
  apply HasDerivAt.add
  · exact
      (hasDerivAt_connectionFirstJet_line target connection variation site left
        upper right lower).sub
        (hasDerivAt_connectionFirstJet_line target connection variation site
          right upper left lower)
  · apply HasDerivAt.fun_sum
    intro middle _
    convert
      ((hasDerivAt_connectionLine_component connection variation site upper
          left middle).mul
        (hasDerivAt_connectionLine_component connection variation site middle
          right lower)).sub
        ((hasDerivAt_connectionLine_component connection variation site upper
            right middle).mul
          (hasDerivAt_connectionLine_component connection variation site middle
            left lower)) using 1
    all_goals simp [connectionLine]
    all_goals ring

/-- Differentiation commutes with the finite Ricci contraction. -/
theorem hasDerivAt_connectionRawRicci_line {Site : Type*}
    (target : Site -> Fin 4 -> Site)
    (connection variation : DirectedConnection Site)
    (site : Site) (lower right : Fin 4) :
    HasDerivAt
      (fun t : Real =>
        connectionRawRicci target (connectionLine connection variation t)
          site lower right)
      (connectionRawRicciFirstVariation target connection variation site lower
        right) 0 := by
  unfold connectionRawRicci connectionRawRicciFirstVariation
  apply HasDerivAt.fun_sum
  intro upper _
  exact hasDerivAt_connectionRiemann_line target connection variation site
    upper lower upper right

/-! ## Finite weighted Palatini connection action -/

variable {Site : Type*} [Fintype Site]

/-- Finite Palatini curvature action with fixed volume and inverse metric but
an independently variable directed connection. -/
def directedPalatiniConnectionAction
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) : Real :=
  Finset.sum Finset.univ (fun site =>
    volume site *
      metricVariationPairing (connectionRawRicci target connection site)
        (inverseMetric site))

/-- Explicit first-variation functional of the finite Palatini connection
action. -/
def directedPalatiniConnectionResponse
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation : DirectedConnection Site) : Real :=
  Finset.sum Finset.univ (fun site =>
    volume site *
      metricVariationPairing
        (connectionRawRicciFirstVariation target connection variation site)
        (inverseMetric site))

omit [Fintype Site] in
/-- Pairing the varying Ricci contraction with a fixed inverse metric has the
expected derivative. -/
theorem hasDerivAt_connectionRawRicciPairing_line
    (target : Site -> Fin 4 -> Site)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation : DirectedConnection Site) (site : Site) :
    HasDerivAt
      (fun t : Real =>
        metricVariationPairing
          (connectionRawRicci target (connectionLine connection variation t)
            site)
          (inverseMetric site))
      (metricVariationPairing
        (connectionRawRicciFirstVariation target connection variation site)
        (inverseMetric site)) 0 := by
  unfold metricVariationPairing Matrix.trace
  apply HasDerivAt.fun_sum
  intro right _
  change HasDerivAt
    (fun t : Real => Finset.sum Finset.univ (fun lower =>
      connectionRawRicci target (connectionLine connection variation t) site
          lower right * inverseMetric site lower right))
    (Finset.sum Finset.univ (fun lower =>
      connectionRawRicciFirstVariation target connection variation site
          lower right * inverseMetric site lower right)) 0
  apply HasDerivAt.fun_sum
  intro lower _
  exact
    (hasDerivAt_connectionRawRicci_line target connection variation site lower
      right).mul_const (inverseMetric site lower right)

/-- **Exact derivative of the finite Palatini connection action.** -/
theorem directedPalatiniConnectionAction_directionalDerivative
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection variation : DirectedConnection Site) :
    HasDerivAt
      (fun t : Real =>
        directedPalatiniConnectionAction target volume inverseMetric
          (connectionLine connection variation t))
      (directedPalatiniConnectionResponse target volume inverseMetric connection
        variation) 0 := by
  unfold directedPalatiniConnectionAction directedPalatiniConnectionResponse
  apply HasDerivAt.fun_sum
  intro site _
  exact (hasDerivAt_connectionRawRicciPairing_line target inverseMetric
    connection variation site).const_mul (volume site)

/-- Stationarity of the finite action under all independent connection
variations. -/
def ConnectionStationary
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) : Prop :=
  forall variation : DirectedConnection Site,
    HasDerivAt
      (fun t : Real =>
        directedPalatiniConnectionAction target volume inverseMetric
          (connectionLine connection variation t)) 0 0

/-- Vanishing of the explicit connection Euler-Lagrange functional. -/
def ConnectionEulerLagrange
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) : Prop :=
  forall variation : DirectedConnection Site,
    directedPalatiniConnectionResponse target volume inverseMetric connection
      variation = 0

/-- Stationarity is equivalent to vanishing of the derived finite connection
Euler-Lagrange functional. -/
theorem connectionStationary_iff_eulerLagrange
    (target : Site -> Fin 4 -> Site)
    (volume : Site -> Real)
    (inverseMetric : Site -> Matrix (Fin 4) (Fin 4) Real)
    (connection : DirectedConnection Site) :
    ConnectionStationary target volume inverseMetric connection <->
      ConnectionEulerLagrange target volume inverseMetric connection := by
  constructor
  · intro hStationary variation
    exact
      (directedPalatiniConnectionAction_directionalDerivative target volume
        inverseMetric connection variation).unique (hStationary variation)
  · intro hEuler variation
    simpa [hEuler variation] using
      directedPalatiniConnectionAction_directionalDerivative target volume
        inverseMetric connection variation

/-! ## Closed periodic flat control -/

/-- Target map induced by four invertible shifts of a finite carrier. -/
def periodicTarget
    (shift : Fin 4 -> Equiv Site Site) : Site -> Fin 4 -> Site :=
  fun site direction => shift direction site

/-- Every forward difference sums to zero on a finite periodic carrier. -/
theorem sum_edgeDifference_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (field : Site -> Real) (direction : Fin 4) :
    (Finset.sum Finset.univ (fun site =>
      edgeDifference (periodicTarget shift) field site direction)) = 0 := by
  unfold edgeDifference periodicTarget
  rw [Finset.sum_sub_distrib]
  have hShift := Equiv.sum_comp (shift direction) field
  rw [hShift]
  exact sub_self _

/-- Consequently every independently supplied connection component has zero
total first directed difference on a periodic carrier. -/
theorem sum_connectionFirstJet_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (connection : DirectedConnection Site)
    (direction upper left right : Fin 4) :
    (Finset.sum Finset.univ (fun site =>
      connectionFirstJet (periodicTarget shift) connection site direction
        upper left right)) = 0 := by
  exact sum_edgeDifference_periodic shift
    (fun site => connection site upper left right) direction

/-- At the zero connection, every component of the first Ricci response sums
to zero on a periodic carrier. -/
theorem sum_connectionRawRicciFirstVariation_zero_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (variation : DirectedConnection Site) (lower right : Fin 4) :
    (Finset.sum Finset.univ (fun site =>
      connectionRawRicciFirstVariation (periodicTarget shift) 0 variation site
        lower right)) = 0 := by
  unfold connectionRawRicciFirstVariation
  rw [Finset.sum_comm]
  apply Finset.sum_eq_zero
  intro upper _
  simp only [connectionRiemannFirstVariation, Pi.zero_apply, zero_mul, mul_zero,
    add_zero, sub_zero, Finset.sum_const_zero]
  rw [Finset.sum_sub_distrib,
    sum_connectionFirstJet_periodic shift variation upper upper right lower,
    sum_connectionFirstJet_periodic shift variation right upper upper lower]
  exact sub_self 0

/-- The Frobenius pairing commutes with a finite sum in its tensor argument. -/
theorem sum_metricVariationPairing_left
    (tensor : Site -> Matrix (Fin 4) (Fin 4) Real)
    (variation : Matrix (Fin 4) (Fin 4) Real) :
    (Finset.sum Finset.univ (fun site =>
      metricVariationPairing (tensor site) variation)) =
      metricVariationPairing (Finset.sum Finset.univ tensor) variation := by
  unfold metricVariationPairing
  rw [Matrix.transpose_sum, Finset.sum_mul, Matrix.trace_sum]

/-- With constant volume and inverse metric, the zero connection satisfies the
derived connection Euler-Lagrange equation on every finite periodic carrier.
-/
theorem zeroConnection_eulerLagrange_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Real) (inverseMetric : Matrix (Fin 4) (Fin 4) Real) :
    ConnectionEulerLagrange (periodicTarget shift) (fun _ => volume)
      (fun _ => inverseMetric) 0 := by
  intro variation
  unfold directedPalatiniConnectionResponse
  rw [← Finset.mul_sum]
  rw [sum_metricVariationPairing_left]
  have hRicciSum :
      Finset.sum Finset.univ (fun site =>
        connectionRawRicciFirstVariation (periodicTarget shift) 0 variation
          site) = 0 := by
    ext lower right
    rw [Matrix.sum_apply]
    simp only [Matrix.zero_apply]
    exact sum_connectionRawRicciFirstVariation_zero_periodic shift variation
      lower right
  rw [hRicciSum]
  simp [metricVariationPairing]

/-- The zero connection is therefore an actual stationary point of the finite
Palatini connection action on a periodic constant background. -/
theorem zeroConnection_stationary_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Real) (inverseMetric : Matrix (Fin 4) (Fin 4) Real) :
    ConnectionStationary (periodicTarget shift) (fun _ => volume)
      (fun _ => inverseMetric) 0 := by
  exact (connectionStationary_iff_eulerLagrange
    (periodicTarget shift) (fun _ => volume) (fun _ => inverseMetric) 0).2
      (zeroConnection_eulerLagrange_periodic shift volume inverseMetric)

/-- The Levi-Civita connection of the constant canonical null-edge chart is
stationary on every periodic carrier with constant Palatini coefficients. -/
theorem canonicalNullEdgeChristoffel_stationary_periodic
    (shift : Fin 4 -> Equiv Site Site)
    (volume : Real) (inverseMetric : Matrix (Fin 4) (Fin 4) Real) :
    ConnectionStationary (periodicTarget shift) (fun _ => volume)
      (fun _ => inverseMetric)
      (nullEdgeChristoffel
        (canonicalDirectedChart Site (periodicTarget shift))) := by
  have hConnection :
      nullEdgeChristoffel
          (canonicalDirectedChart Site (periodicTarget shift)) = 0 := by
    funext site
    exact canonicalDirectedChart_christoffel_zero (periodicTarget shift) site
  rw [hConnection]
  exact zeroConnection_stationary_periodic shift volume inverseMetric

/-- Constant inverse metric reconstructed from the canonical null-edge
coframe. -/
def canonicalNullEdgeInverseMetric : Matrix (Fin 4) (Fin 4) Real :=
  inducedCovariantMetric minkowskiMetric canonicalCoframe⁻¹.transpose

omit [Fintype Site] in
/-- The canonical null-edge chart has constant oriented volume `1 / 2`. -/
theorem canonicalFrame_chartBaseVolume
    (site : Site) :
    chartBaseVolume (nullEdgeCoframe (canonicalFrame Site).edges) site =
      (1 / 2 : Real) := by
  unfold chartBaseVolume coframeVolume nullEdgeCoframe canonicalFrame
  rw [canonicalNullEdgeCoframe_eq, canonicalCoframe_det]

omit [Fintype Site] in
/-- The canonical null-edge chart reconstructs the same constant inverse
metric at every site. -/
theorem canonicalFrame_inverseMetric
    (site : Site) :
    nullEdgeInverseMetric (canonicalFrame Site) site =
      canonicalNullEdgeInverseMetric := by
  unfold nullEdgeInverseMetric inverseCoframe nullEdgeCoframe canonicalFrame
    canonicalNullEdgeInverseMetric
  rw [canonicalNullEdgeCoframe_eq]

/-- **Geometric flat control.**  The Levi-Civita connection reconstructed from
the canonical null edges is stationary for the connection partial action with
the volume and inverse metric reconstructed from those same null edges. -/
theorem canonicalNullEdgeGeometry_stationary_periodic
    (shift : Fin 4 -> Equiv Site Site) :
    ConnectionStationary (periodicTarget shift)
      (chartBaseVolume (nullEdgeCoframe (canonicalFrame Site).edges))
      (nullEdgeInverseMetric (canonicalFrame Site))
      (nullEdgeChristoffel
        (canonicalDirectedChart Site (periodicTarget shift))) := by
  have hVolume :
      chartBaseVolume (nullEdgeCoframe (canonicalFrame Site).edges) =
        (fun _ => (1 / 2 : Real)) := by
    funext site
    exact canonicalFrame_chartBaseVolume site
  have hInverseMetric :
      nullEdgeInverseMetric (canonicalFrame Site) =
        (fun _ => canonicalNullEdgeInverseMetric) := by
    funext site
    exact canonicalFrame_inverseMetric site
  rw [hVolume, hInverseMetric]
  exact canonicalNullEdgeChristoffel_stationary_periodic shift (1 / 2)
    canonicalNullEdgeInverseMetric

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.connectionRiemann_nullEdgeChristoffel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms connectionRiemann_nullEdgeChristoffel

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.hasDerivAt_connectionRiemann_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_connectionRiemann_line

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.directedPalatiniConnectionAction_directionalDerivative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms directedPalatiniConnectionAction_directionalDerivative

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.connectionStationary_iff_eulerLagrange' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms connectionStationary_iff_eulerLagrange

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.canonicalNullEdgeChristoffel_stationary_periodic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalNullEdgeChristoffel_stationary_periodic

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation.canonicalNullEdgeGeometry_stationary_periodic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalNullEdgeGeometry_stationary_periodic

end PhysicsSM.Draft.NullEdge.FiniteDirectedPalatiniConnectionVariation

```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
Credit balance is too low

```

## Response stderr

```text

```
