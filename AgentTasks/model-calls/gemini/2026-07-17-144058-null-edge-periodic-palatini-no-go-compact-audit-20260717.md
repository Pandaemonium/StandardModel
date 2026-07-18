# Gemini model call log

## Metadata

- Provider: `Gemini REST API`
- Model: `gemini-3.1-pro-preview`
- Status: `completed`
- Dry run: `False`
- Started: `2026-07-17T14:39:41`
- Finished: `2026-07-17T14:40:58`
- Timeout seconds: `600`
- Max output tokens: `20000`

## Endpoint

```text
https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent
```

The API key is intentionally not logged.

## Prompt

```text
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


Ignore the failed Claude response and perform the requested review. Prioritize the exact coefficient derivation and semantic verdict; keep literature and next steps concise. Do not emit hidden reasoning, only the final audit.
```

## Extracted response text

```text
Here is the independent review and audit of the provided Lean sources.

### 1. Exact Coefficient Derivation and Verification

The discrete Palatini action is defined as $S = \sum_x \sum_{l,r} W^{lr}(x) R_{lr}(x)$, where $W^{lr}(x) = V(x) g^{lr}(x)$ is the densitized inverse metric. The raw Ricci tensor is $R_{lr} = \sum_u R^u_{lur}$, with the discrete Riemann tensor given by:
$$R^a_{bcd}(x) = \Delta_c \Gamma^a_{db}(x) - \Delta_d \Gamma^a_{cb}(x) + \sum_m \left( \Gamma^a_{cm}(x) \Gamma^m_{db}(x) - \Gamma^a_{dm}(x) \Gamma^m_{cb}(x) \right)$$

Varying the action with respect to $\delta \Gamma^a_{bc}(x)$ requires exact discrete summation by parts: $\sum_x W(x) \Delta_u f(x) = \sum_x \nabla^*_u W(x) f(x)$, where $\nabla^*_u W(x) = W(x-u) - W(x)$ is the backward difference. 

Isolating the coefficient $E^a_{bc}(x)$ of $\delta \Gamma^a_{bc}(x)$ yields six terms:
1. From $\Delta_u \delta \Gamma^u_{rl}$: matches $u=a, r=b, l=c \implies \nabla^*_a W^{cb}(x)$.
2. From $-\Delta_r \delta \Gamma^u_{ul}$: matches $u=a, u=b, l=c \implies -\delta^a_b \sum_r \nabla^*_r W^{cr}(x)$.
3. From $\delta \Gamma^u_{um} \Gamma^m_{rl}$: matches $u=a, u=b, m=c \implies \delta^a_b \sum_{l,r} W^{lr}(x) \Gamma^c_{rl}(x)$.
4. From $\Gamma^u_{um} \delta \Gamma^m_{rl}$: matches $m=a, r=b, l=c \implies W^{cb}(x) \sum_u \Gamma^u_{ua}(x)$.
5. From $-\delta \Gamma^u_{rm} \Gamma^m_{ul}$: matches $u=a, r=b, m=c \implies -\sum_l W^{lb}(x) \Gamma^c_{al}(x)$.
6. From $-\Gamma^u_{rm} \delta \Gamma^m_{ul}$: matches $m=a, u=b, l=c \implies -\sum_r W^{cr}(x) \Gamma^b_{ra}(x)$.

**Audit:** The Lean definition `explicitConnectionEulerCoefficient` exactly matches this mathematical derivation term-by-term. The index tracking is semantically correct; specifically, `metricVariationPairing` correctly evaluates to $\sum_{l,r} A_{lr} B_{lr}$, properly contracting the raw Ricci tensor with the inverse metric.

### 2. Conformal `Fin 3` Witness Audit

The witness constructs a periodic 3-site lattice with a conformal factor $\Omega(x) = r(x)^4$ where $r \in \{1, 2, 3\}$. The forward-difference Christoffel symbols are evaluated on this background. 

**Audit:** The Lean kernel computes $E^0_{00}(0) = -95$ via `norm_num`. The logical deduction is sound: for the action to be stationary under lower-index-symmetric (torsion-free) variations, the symmetric coefficient must vanish, meaning $E^a_{bc} + E^a_{cb} = 0$. For $b=c=0$, this requires $2 E^0_{00} = 0$. Since $-95 \neq 0$, the forward-difference Christoffel connection definitively fails the discrete Euler-Lagrange equations.

**Verdict:** This is a rigorous **no-go for this specific finite-difference discretization**, not a no-go for Palatini gravity. The failure stems from the discrete Leibniz rule violation ($\Delta(AB) \neq A\Delta B + B\Delta A$). In the continuum, integration by parts perfectly balances the connection derivatives against the metric derivatives. On a lattice, the algebraic shift in the summation by parts leaves a residual that prevents the discrete Levi-Civita connection from extremizing the discrete Palatini action.

### 3. Semantic and Index/Sign Flags

- **No semantic, index, or sign errors were found.** The formalization of the discrete variation, the summation by parts (`sum_weight_mul_connectionFirstJet_periodic`), and the extraction of the Euler coefficient are mathematically exact and faithfully represented in Lean.

### 4. Corrected Architectures Ranking

To resolve the Leibniz rule failure, the discretization must respect the geometric gauge structure:

1. **Link/face group-valued transport with plaquette holonomy (Highest Rank):** 
   Connections are represented as exact group elements $U \in SL(2,\mathbb{C})$ on links, and curvature as ordered plaquette products. This avoids Leibniz rule violations entirely by using exact group multiplication. (Primary literature: *Wilson 1974, PRD 10, 2445*; *Smolin 1979, Annals of Physics 119, 1*).
2. **Discrete Exterior Calculus (DEC) primal/dual adjoint:** 
   Formulates Palatini gravity using discrete differential forms (tetrads as 1-forms, curvature as 2-forms). DEC provides an exact discrete Stokes' theorem and Hodge star, preserving the variational geometry. (Primary literature: *Desbrun et al. 2005, math.DG/0508341*).
3. **Midpoint/discrete gradient (SBP operators):** 
   Summation-by-parts finite differences can restore a discrete Leibniz rule up to boundary terms, but they are highly constrained and often struggle with the non-linear connection cross-terms in gravity.

### 5. Smallest Next Lean Targets and Kill Conditions

**Next Lean Targets:**
1. Define a lattice gauge carrier with $SL(2,\mathbb{C})$ (or $SO(3,1)$) link variables and compute exact plaquette holonomies.
2. Formulate the discrete Palatini action using tetrads on sites (or dual faces) contracted with the plaquette curvatures.
3. Derive the exact discrete Euler-Lagrange equations for the link variables.

**Kill Condition:**
If the variation of the link-based action with respect to the link variables does not yield a consistent discrete torsion-free condition (e.g., geometric closure of dual faces), then the architecture cannot support a discrete Palatini formulation of General Relativity.
```

## Raw response JSON

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "Here is the independent review and audit of the provided Lean sources.\n\n### 1. Exact Coefficient Derivation and Verification\n\nThe discrete Palatini action is defined as $S = \\sum_x \\sum_{l,r} W^{lr}(x) R_{lr}(x)$, where $W^{lr}(x) = V(x) g^{lr}(x)$ is the densitized inverse metric. The raw Ricci tensor is $R_{lr} = \\sum_u R^u_{lur}$, with the discrete Riemann tensor given by:\n$$R^a_{bcd}(x) = \\Delta_c \\Gamma^a_{db}(x) - \\Delta_d \\Gamma^a_{cb}(x) + \\sum_m \\left( \\Gamma^a_{cm}(x) \\Gamma^m_{db}(x) - \\Gamma^a_{dm}(x) \\Gamma^m_{cb}(x) \\right)$$\n\nVarying the action with respect to $\\delta \\Gamma^a_{bc}(x)$ requires exact discrete summation by parts: $\\sum_x W(x) \\Delta_u f(x) = \\sum_x \\nabla^*_u W(x) f(x)$, where $\\nabla^*_u W(x) = W(x-u) - W(x)$ is the backward difference. \n\nIsolating the coefficient $E^a_{bc}(x)$ of $\\delta \\Gamma^a_{bc}(x)$ yields six terms:\n1. From $\\Delta_u \\delta \\Gamma^u_{rl}$: matches $u=a, r=b, l=c \\implies \\nabla^*_a W^{cb}(x)$.\n2. From $-\\Delta_r \\delta \\Gamma^u_{ul}$: matches $u=a, u=b, l=c \\implies -\\delta^a_b \\sum_r \\nabla^*_r W^{cr}(x)$.\n3. From $\\delta \\Gamma^u_{um} \\Gamma^m_{rl}$: matches $u=a, u=b, m=c \\implies \\delta^a_b \\sum_{l,r} W^{lr}(x) \\Gamma^c_{rl}(x)$.\n4. From $\\Gamma^u_{um} \\delta \\Gamma^m_{rl}$: matches $m=a, r=b, l=c \\implies W^{cb}(x) \\sum_u \\Gamma^u_{ua}(x)$.\n5. From $-\\delta \\Gamma^u_{rm} \\Gamma^m_{ul}$: matches $u=a, r=b, m=c \\implies -\\sum_l W^{lb}(x) \\Gamma^c_{al}(x)$.\n6. From $-\\Gamma^u_{rm} \\delta \\Gamma^m_{ul}$: matches $m=a, u=b, l=c \\implies -\\sum_r W^{cr}(x) \\Gamma^b_{ra}(x)$.\n\n**Audit:** The Lean definition `explicitConnectionEulerCoefficient` exactly matches this mathematical derivation term-by-term. The index tracking is semantically correct; specifically, `metricVariationPairing` correctly evaluates to $\\sum_{l,r} A_{lr} B_{lr}$, properly contracting the raw Ricci tensor with the inverse metric.\n\n### 2. Conformal `Fin 3` Witness Audit\n\nThe witness constructs a periodic 3-site lattice with a conformal factor $\\Omega(x) = r(x)^4$ where $r \\in \\{1, 2, 3\\}$. The forward-difference Christoffel symbols are evaluated on this background. \n\n**Audit:** The Lean kernel computes $E^0_{00}(0) = -95$ via `norm_num`. The logical deduction is sound: for the action to be stationary under lower-index-symmetric (torsion-free) variations, the symmetric coefficient must vanish, meaning $E^a_{bc} + E^a_{cb} = 0$. For $b=c=0$, this requires $2 E^0_{00} = 0$. Since $-95 \\neq 0$, the forward-difference Christoffel connection definitively fails the discrete Euler-Lagrange equations.\n\n**Verdict:** This is a rigorous **no-go for this specific finite-difference discretization**, not a no-go for Palatini gravity. The failure stems from the discrete Leibniz rule violation ($\\Delta(AB) \\neq A\\Delta B + B\\Delta A$). In the continuum, integration by parts perfectly balances the connection derivatives against the metric derivatives. On a lattice, the algebraic shift in the summation by parts leaves a residual that prevents the discrete Levi-Civita connection from extremizing the discrete Palatini action.\n\n### 3. Semantic and Index/Sign Flags\n\n- **No semantic, index, or sign errors were found.** The formalization of the discrete variation, the summation by parts (`sum_weight_mul_connectionFirstJet_periodic`), and the extraction of the Euler coefficient are mathematically exact and faithfully represented in Lean.\n\n### 4. Corrected Architectures Ranking\n\nTo resolve the Leibniz rule failure, the discretization must respect the geometric gauge structure:\n\n1. **Link/face group-valued transport with plaquette holonomy (Highest Rank):** \n   Connections are represented as exact group elements $U \\in SL(2,\\mathbb{C})$ on links, and curvature as ordered plaquette products. This avoids Leibniz rule violations entirely by using exact group multiplication. (Primary literature: *Wilson 1974, PRD 10, 2445*; *Smolin 1979, Annals of Physics 119, 1*).\n2. **Discrete Exterior Calculus (DEC) primal/dual adjoint:** \n   Formulates Palatini gravity using discrete differential forms (tetrads as 1-forms, curvature as 2-forms). DEC provides an exact discrete Stokes' theorem and Hodge star, preserving the variational geometry. (Primary literature: *Desbrun et al. 2005, math.DG/0508341*).\n3. **Midpoint/discrete gradient (SBP operators):** \n   Summation-by-parts finite differences can restore a discrete Leibniz rule up to boundary terms, but they are highly constrained and often struggle with the non-linear connection cross-terms in gravity.\n\n### 5. Smallest Next Lean Targets and Kill Conditions\n\n**Next Lean Targets:**\n1. Define a lattice gauge carrier with $SL(2,\\mathbb{C})$ (or $SO(3,1)$) link variables and compute exact plaquette holonomies.\n2. Formulate the discrete Palatini action using tetrads on sites (or dual faces) contracted with the plaquette curvatures.\n3. Derive the exact discrete Euler-Lagrange equations for the link variables.\n\n**Kill Condition:**\nIf the variation of the link-based action with respect to the link variables does not yield a consistent discrete torsion-free condition (e.g., geometric closure of dual faces), then the architecture cannot support a discrete Palatini formulation of General Relativity.",
            "thoughtSignature": "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"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP",
      "index": 0
    }
  ],
  "usageMetadata": {
    "promptTokenCount": 17611,
    "candidatesTokenCount": 1521,
    "totalTokenCount": 28104,
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 17611
      }
    ],
    "thoughtsTokenCount": 8972,
    "serviceTier": "standard"
  },
  "modelVersion": "gemini-3.1-pro-preview",
  "responseId": "HKFaasioDN2m1MkPwa76mAY"
}
```

## Error

```text

```
