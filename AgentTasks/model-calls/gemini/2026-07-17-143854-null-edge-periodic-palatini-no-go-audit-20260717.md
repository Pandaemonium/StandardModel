# Gemini model call log

## Metadata

- Provider: `Gemini REST API`
- Model: `gemini-3.1-pro-preview`
- Status: `completed`
- Dry run: `False`
- Started: `2026-07-17T14:37:43`
- Finished: `2026-07-17T14:38:54`
- Timeout seconds: `600`
- Max output tokens: `10000`

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
- Started: `2026-07-17T14:37:12`
- Finished: `2026-07-17T14:37:20`
- Timeout seconds: `600`
- Max budget USD: `2.50`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 2.50 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
You are reviewing a Lean 4 finite-gravity result in the StandardModel repository. The project uses four Weyl-spinor null edges to construct a coframe, Gram metric, inverse, volume, a forward-difference Christoffel field, and a pointwise finite Palatini connection action. The exact issue is whether that forward-difference Christoffel solves the connection Euler-Lagrange equation on nonconstant periodic geometry.

Review the verbatim source carefully. Independently derive the coefficient of an ordered variation H^a_{bc}(x) in the action response, checking every index and sign. Then audit the Fin 3 conformal witness: scaled canonical spinors r=(1,2,3), metric scales s=r^4=(1,16,81), volume=(1/2)s^2, inverse=(1/s)g0^{-1}, all shifts the same three-cycle. The Lean file claims the explicit coefficient E^0_{00}(0)=-95 and uses the lower-index-symmetric projection E^a_{bc}+E^a_{cb}; because b=c=0, the torsion-free equation also fails.

Return:
1. Index/sign audit with the derived coefficient formula.
2. Semantic audit of each Lean theorem: flag vacuity, false shape, hidden assumptions, docstring overclaim, or reliance on the unresolved proof placeholder in connectionEulerCoefficient_eq_explicit.
3. Whether the counterexample, once the generic coefficient theorem is proved, genuinely shows the current pointwise forward-difference Palatini architecture does not select its null-edge Christoffel on general charts.
4. A ranked corrected architecture grounded in primary literature: link/face group-valued transport and plaquette holonomy, DEC primal/dual adjoint structure, midpoint/discrete-gradient alternatives, or another option. Distinguish an exact finite theory from a merely asymptotically consistent route.
5. The smallest next Lean theorem package and explicit kill conditions.

Do not edit files. Do not treat continuum Palatini identities as finite identities. Do not weaken the theorem. Cite primary literature with identifiers/links where possible. Be concise but technically explicit.

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

### PhysicsSM/Draft/NullEdge/CausalLeviCivita.lean (202 lines)

```lean
import PhysicsSM.Draft.NullEdge.CausalMetricFirstJet

/-!
# Levi-Civita connection from an operator-reconstructed metric first jet

This module isolates the finite coordinate-algebra bridge from the corrected
causal-operator pairing to a Levi-Civita connection candidate. First, it applies
`CausalMetricFirstJet.recoveredFirstJet_eq` componentwise to a supplied metric
field. It then defines the standard Christoffel coefficients of the first and
second kind and proves that an exact metric-inverse relation plus symmetry of
the metric first jet imply:

* lowering the raised Christoffel coefficient recovers the first-kind symbol;
* symmetry in the two derivative directions (zero coordinate torsion);
* vanishing covariant derivative of the covariant metric.

These are guarded finite identities, not a construction of probes, metric
components, first derivatives, a chart, a manifold, or a continuum limit. In
particular, the difficult convergence premise remains that corrected operator
pairings recover the principal symbol on every metric component. Claim grade:
`M [comp]`.

Conventions: coordinate indices are ordered as `upper, derivativeLeft,
derivativeRight`; the metric signature is not used by these algebraic proofs;
and `gCov * gInv = 1` is the displayed lowering/raising convention.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.CausalLeviCivita

open PhysicsSM.Draft.NullEdge.CausalMetricFirstJet

variable {K ι : Type*} [Field K]

/-- Apply the operator-recovered scalar first jet to every component of a
supplied covariant metric field. -/
def recoveredMetricFirstJet
    [Fintype ι] [DecidableEq ι]
    (probeCov : Matrix ι ι K) (L : K -> K) (X : ι -> K)
    (metricComponents : Matrix ι ι K) : ι -> Matrix ι ι K :=
  fun derivative left right =>
    recoveredFirstJet probeCov L X (metricComponents left right) derivative

/-- Componentwise metric version of the finite coordinate derivative identity.
Every corrected pairing premise is explicit; this theorem does not establish
that the causal operator satisfies those premises. -/
theorem recoveredMetricFirstJet_eq
    [Fintype ι] [DecidableEq ι]
    (probeCov probeInv : Matrix ι ι K)
    (L : K -> K) (X : ι -> K) (metricComponents : Matrix ι ι K)
    (metricDerivative : ι -> Matrix ι ι K)
    (hProbeInverse : probeCov * probeInv = 1)
    (hPrincipalSymbol : forall left right,
      operatorPairingVector L X (metricComponents left right) =
        Matrix.mulVec probeInv (fun derivative =>
          metricDerivative derivative left right)) :
    recoveredMetricFirstJet probeCov L X metricComponents = metricDerivative := by
  funext derivative left right
  exact recoveredFirstJet_apply_eq
    probeCov probeInv L X (metricComponents left right)
      (fun coordinate => metricDerivative coordinate left right)
      hProbeInverse (hPrincipalSymbol left right) derivative

/-- Symmetry of every covariant-metric first jet in its two metric indices. -/
def MetricFirstJetSymmetric (dg : ι -> Matrix ι ι K) : Prop :=
  forall derivative left right,
    dg derivative left right = dg derivative right left

/-- Christoffel coefficient of the first kind formed from a metric first jet. -/
def christoffelFirstKind
    (dg : ι -> Matrix ι ι K) (lower derivativeLeft derivativeRight : ι) : K :=
  (dg derivativeLeft lower derivativeRight
      + dg derivativeRight lower derivativeLeft
      - dg lower derivativeLeft derivativeRight) / 2

/-- The first-kind Christoffel coefficient is symmetric in its two derivative
directions when the metric first jet is symmetric. -/
theorem christoffelFirstKind_swap
    (dg : ι -> Matrix ι ι K)
    (hSymmetric : MetricFirstJetSymmetric dg)
    (lower derivativeLeft derivativeRight : ι) :
    christoffelFirstKind dg lower derivativeLeft derivativeRight =
      christoffelFirstKind dg lower derivativeRight derivativeLeft := by
  unfold christoffelFirstKind
  rw [hSymmetric lower derivativeLeft derivativeRight]
  ring

section FiniteCoordinates

variable [Fintype ι] [DecidableEq ι]

/-- Christoffel coefficient of the second kind, obtained by raising the first
index of `christoffelFirstKind`. -/
def christoffelSecondKind
    (gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (upper derivativeLeft derivativeRight : ι) : K :=
  Finset.sum Finset.univ fun lower =>
    gInv upper lower
      * christoffelFirstKind dg lower derivativeLeft derivativeRight

/-- Lower the upper index of a supplied connection coefficient. -/
def loweredConnection
    (gCov : Matrix ι ι K) (connection : ι -> ι -> ι -> K)
    (lower derivativeLeft derivativeRight : ι) : K :=
  Finset.sum Finset.univ fun upper =>
    gCov lower upper * connection upper derivativeLeft derivativeRight

/-- Coordinate covariant derivative of the reconstructed covariant metric. -/
def covariantMetricDerivative
    (gCov : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (connection : ι -> ι -> ι -> K)
    (derivative left right : ι) : K :=
  dg derivative left right
    - loweredConnection gCov connection left derivative right
    - loweredConnection gCov connection right derivative left

omit [DecidableEq ι] in
/-- The reconstructed second-kind connection has zero coordinate torsion. -/
theorem christoffelSecondKind_swap
    (gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (hSymmetric : MetricFirstJetSymmetric dg)
    (upper derivativeLeft derivativeRight : ι) :
    christoffelSecondKind gInv dg upper derivativeLeft derivativeRight =
      christoffelSecondKind gInv dg upper derivativeRight derivativeLeft := by
  unfold christoffelSecondKind
  apply Finset.sum_congr rfl
  intro lower _
  rw [christoffelFirstKind_swap dg hSymmetric lower]

/-- Lowering the raised Christoffel coefficient recovers the first-kind symbol
under the displayed exact metric-inverse relation. -/
theorem lowered_christoffelSecondKind_eq_firstKind
    (gCov gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (hInverse : gCov * gInv = 1)
    (lower derivativeLeft derivativeRight : ι) :
    loweredConnection gCov (christoffelSecondKind gInv dg)
        lower derivativeLeft derivativeRight =
      christoffelFirstKind dg lower derivativeLeft derivativeRight := by
  unfold loweredConnection christoffelSecondKind
  simp_rw [Finset.mul_sum]
  rw [Finset.sum_comm]
  simp_rw [← mul_assoc, ← Finset.sum_mul]
  change
    (Finset.sum Finset.univ fun raised =>
        (gCov * gInv) lower raised
          * christoffelFirstKind dg raised derivativeLeft derivativeRight) = _
  rw [hInverse]
  simp [Matrix.one_apply]

/-- The Christoffel connection built from symmetric metric first jets is
compatible with the supplied covariant metric. -/
theorem covariantMetricDerivative_christoffel_eq_zero
    [CharZero K]
    (gCov gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (hInverse : gCov * gInv = 1)
    (hSymmetric : MetricFirstJetSymmetric dg)
    (derivative left right : ι) :
    covariantMetricDerivative gCov dg (christoffelSecondKind gInv dg)
        derivative left right = 0 := by
  unfold covariantMetricDerivative
  rw [lowered_christoffelSecondKind_eq_firstKind gCov gInv dg hInverse,
    lowered_christoffelSecondKind_eq_firstKind gCov gInv dg hInverse]
  unfold christoffelFirstKind
  rw [hSymmetric derivative right left,
    hSymmetric right left derivative,
    hSymmetric left right derivative]
  ring

/-- Guarded finite Levi-Civita package: coordinate torsion vanishes and the
covariant metric derivative is zero under the exact reconstruction premises. -/
theorem finiteLeviCivitaPackage
    [CharZero K]
    (gCov gInv : Matrix ι ι K) (dg : ι -> Matrix ι ι K)
    (hInverse : gCov * gInv = 1)
    (hSymmetric : MetricFirstJetSymmetric dg)
    (upper derivative left right : ι) :
    christoffelSecondKind gInv dg upper derivative left =
        christoffelSecondKind gInv dg upper left derivative
      /\ covariantMetricDerivative gCov dg (christoffelSecondKind gInv dg)
        derivative left right = 0 := by
  exact
    ⟨christoffelSecondKind_swap gInv dg hSymmetric upper derivative left,
      covariantMetricDerivative_christoffel_eq_zero
        gCov gInv dg hInverse hSymmetric derivative left right⟩

end FiniteCoordinates

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CausalLeviCivita.recoveredMetricFirstJet_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms recoveredMetricFirstJet_eq

/-- info: 'PhysicsSM.Draft.NullEdge.CausalLeviCivita.finiteLeviCivitaPackage' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteLeviCivitaPackage

end PhysicsSM.Draft.NullEdge.CausalLeviCivita

```

### PhysicsSM/Draft/NullEdge/DirectedNullEdgeLeviCivitaEinstein.lean (359 lines)

```lean
import PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge
import PhysicsSM.Draft.NullEdge.CausalLeviCivita

/-!
# Directed null-edge Levi-Civita curvature and Einstein action

This module closes the next shared-data gap in the finite GR lane.  A
`DirectedNullEdgeChart` contains, at every site, four independent Weyl-spinor
null edges and the target site of each edge.  The same data now determines:

1. the null coframe, Gram metric, inverse metric, and volume;
2. forward differences of that metric along the four graph edges;
3. the finite Levi-Civita Christoffel coefficients;
4. coordinate Riemann curvature and its Ricci contraction;
5. the symmetric Ricci response seen by symmetric metric variations;
6. the nonlinear Palatini chart action and its finite Einstein equation.

Thus the final action theorem no longer accepts an independently supplied
coframe, metric, inverse metric, volume, or Ricci tensor.  It accepts a
decorated directed null-edge chart, stress, and couplings.

The remaining caveats are substantial and explicit.  Direction labels are
globally synchronized; the forward-difference curvature has not yet been
proved locally Lorentz covariant or equivalent to plaquette holonomy; the
Ricci tensor used by the metric variation is the symmetric projection of the
raw discrete contraction; connection stationarity is not yet derived; and no
refinement or continuum convergence theorem is claimed.  The action parameter
is still an unrestricted coframe generator around the null-edge base.  By
`zeroDiagonalMetricDerivative_not_full`, a tangent that preserves all four
null columns cannot alone supply the full stationarity theorem.  Signature is
mostly-minus `(+,-,-,-)`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein

open scoped BigOperators

open Matrix
open CausalLeviCivita
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open LocalEinsteinEquationVariation
open RelaxedCausalMetricVariationBridge
open NullEdgeCoframeEinsteinBridge

/-- A four-direction decorated carrier chart.  `target site direction` is the
endpoint of the selected null edge with that direction label. -/
structure DirectedNullEdgeChart (Site : Type*) extends
    NondegenerateNullEdgeFrame Site where
  target : Site -> Fin 4 -> Site

/-- Forward difference of a scalar field along one selected graph edge. -/
def edgeDifference {Site : Type*}
    (target : Site -> Fin 4 -> Site) (field : Site -> Real)
    (site : Site) (direction : Fin 4) : Real :=
  field (target site direction) - field site

/-- Forward graph differences annihilate constant fields exactly. -/
theorem edgeDifference_const {Site : Type*}
    (target : Site -> Fin 4 -> Site) (value : Real)
    (site : Site) (direction : Fin 4) :
    edgeDifference target (fun _ => value) site direction = 0 := by
  simp [edgeDifference]

/-- First graph jet of the null-edge Gram metric. -/
def nullEdgeMetricFirstJet {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    Fin 4 -> Matrix (Fin 4) (Fin 4) Real :=
  fun direction left right =>
    edgeDifference chart.target
      (fun next => nullEdgeMetric chart.edges next left right)
      site direction

/-- The graph metric first jet remains symmetric in its metric indices. -/
theorem nullEdgeMetricFirstJet_symmetric {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    MetricFirstJetSymmetric (nullEdgeMetricFirstJet chart site) := by
  intro direction left right
  have hTarget :
      nullEdgeMetric chart.edges (chart.target site direction) left right =
        nullEdgeMetric chart.edges (chart.target site direction) right left := by
    have h := congrFun
      (congrFun
        (nullEdgeMetric_symmetric chart.toNondegenerateNullEdgeFrame
          (chart.target site direction)).eq left) right
    simpa using h.symm
  have hSource :
      nullEdgeMetric chart.edges site left right =
        nullEdgeMetric chart.edges site right left := by
    have h := congrFun
      (congrFun
        (nullEdgeMetric_symmetric chart.toNondegenerateNullEdgeFrame site).eq
          left) right
    simpa using h.symm
  unfold nullEdgeMetricFirstJet edgeDifference
  change
    nullEdgeMetric chart.edges (chart.target site direction) left right -
        nullEdgeMetric chart.edges site left right =
      nullEdgeMetric chart.edges (chart.target site direction) right left -
        nullEdgeMetric chart.edges site right left
  rw [hTarget, hSource]

/-- Levi-Civita connection constructed from the null-edge metric and its
forward graph first jet. -/
def nullEdgeChristoffel {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    Fin 4 -> Fin 4 -> Fin 4 -> Real :=
  christoffelSecondKind
    (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site)
    (nullEdgeMetricFirstJet chart site)

/-- The reconstructed connection has zero coordinate torsion. -/
theorem nullEdgeChristoffel_torsion_free {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site)
    (upper left right : Fin 4) :
    nullEdgeChristoffel chart site upper left right =
      nullEdgeChristoffel chart site upper right left := by
  exact christoffelSecondKind_swap
    (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site)
    (nullEdgeMetricFirstJet chart site)
    (nullEdgeMetricFirstJet_symmetric chart site) upper left right

/-- The reconstructed connection is compatible with the null-edge Gram
metric at the finite first-jet level. -/
theorem nullEdgeChristoffel_metric_compatible {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site)
    (direction left right : Fin 4) :
    covariantMetricDerivative
        (nullEdgeMetric chart.edges site)
        (nullEdgeMetricFirstJet chart site)
        (nullEdgeChristoffel chart site) direction left right = 0 := by
  exact covariantMetricDerivative_christoffel_eq_zero
    (nullEdgeMetric chart.edges site)
    (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site)
    (nullEdgeMetricFirstJet chart site)
    (nullEdgeMetric_mul_inverseMetric
      chart.toNondegenerateNullEdgeFrame site)
    (nullEdgeMetricFirstJet_symmetric chart site)
    direction left right

/-- Forward graph derivative of the reconstructed connection. -/
def nullEdgeConnectionFirstJet {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site)
    (direction upper left right : Fin 4) : Real :=
  edgeDifference chart.target
    (fun next => nullEdgeChristoffel chart next upper left right)
    site direction

/-- Coordinate curvature of the graph-derived Levi-Civita connection. -/
def nullEdgeRiemann {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site)
    (upper lower directionLeft directionRight : Fin 4) : Real :=
  nullEdgeConnectionFirstJet chart site directionLeft upper directionRight lower
    - nullEdgeConnectionFirstJet chart site directionRight upper directionLeft lower
    + Finset.sum Finset.univ (fun middle =>
        nullEdgeChristoffel chart site upper directionLeft middle *
            nullEdgeChristoffel chart site middle directionRight lower
          - nullEdgeChristoffel chart site upper directionRight middle *
            nullEdgeChristoffel chart site middle directionLeft lower)

/-- The discrete coordinate curvature is antisymmetric in its two curvature
directions by construction. -/
theorem nullEdgeRiemann_antisymm {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site)
    (upper lower left right : Fin 4) :
    nullEdgeRiemann chart site upper lower left right =
      -nullEdgeRiemann chart site upper lower right left := by
  unfold nullEdgeRiemann
  simp only [Finset.sum_sub_distrib]
  ring

/-- Raw Ricci contraction `R_{lower,right} = sum_upper
R^upper_{lower,upper,right}` of the graph curvature. -/
def nullEdgeRawRicci {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    Matrix (Fin 4) (Fin 4) Real :=
  fun lower right => Finset.sum Finset.univ (fun upper =>
    nullEdgeRiemann chart site upper lower upper right)

/-- Symmetric projection of a covariant rank-two tensor. -/
def symmetricPart (tensor : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 4) (Fin 4) Real :=
  (1 / 2 : Real) • (tensor + tensor.transpose)

/-- The symmetric projection is symmetric. -/
theorem symmetricPart_isSymm
    (tensor : Matrix (Fin 4) (Fin 4) Real) :
    (symmetricPart tensor).IsSymm := by
  unfold symmetricPart Matrix.IsSymm
  simp only [Matrix.transpose_smul, Matrix.transpose_add,
    Matrix.transpose_transpose]
  rw [add_comm]

/-- Symmetric projection preserves the Frobenius pairing against every
symmetric metric variation. -/
theorem metricVariationPairing_symmetricPart
    (tensor variation : Matrix (Fin 4) (Fin 4) Real)
    (hVariation : variation.IsSymm) :
    metricVariationPairing (symmetricPart tensor) variation =
      metricVariationPairing tensor variation := by
  have hTrace :
      Matrix.trace (tensor * variation) =
        Matrix.trace (tensor.transpose * variation) := by
    calc
      Matrix.trace (tensor * variation) =
          Matrix.trace (tensor * variation).transpose :=
        (Matrix.trace_transpose _).symm
      _ = Matrix.trace (variation.transpose * tensor.transpose) := by
        rw [Matrix.transpose_mul]
      _ = Matrix.trace (variation * tensor.transpose) := by
        rw [hVariation.eq]
      _ = Matrix.trace (tensor.transpose * variation) :=
        Matrix.trace_mul_comm _ _
  unfold metricVariationPairing symmetricPart
  rw [Matrix.transpose_smul, Matrix.transpose_add,
    Matrix.transpose_transpose, Matrix.smul_mul, Matrix.trace_smul,
    Matrix.add_mul, Matrix.trace_add, hTrace]
  change (1 / 2 : Real) *
      (Matrix.trace (tensor.transpose * variation) +
        Matrix.trace (tensor.transpose * variation)) =
    Matrix.trace (tensor.transpose * variation)
  ring

/-- Symmetric Ricci response derived from the directed null-edge chart.  This
is the part of the raw Ricci contraction visible to symmetric metric
variations. -/
def nullEdgeSymmetricRicci {Site : Type*}
    (chart : DirectedNullEdgeChart Site) : LocalTensor (Site := Site) :=
  fun site => symmetricPart (nullEdgeRawRicci chart site)

/-- The derived Ricci response is locally symmetric. -/
theorem nullEdgeSymmetricRicci_symmetric {Site : Type*}
    (chart : DirectedNullEdgeChart Site) :
    LocalSymmetric (nullEdgeSymmetricRicci chart) := by
  intro site
  exact symmetricPart_isSymm _

/-- Contracting the symmetric Ricci response with the derived inverse metric
is exactly the contraction of the raw graph Ricci tensor. -/
theorem nullEdgeSymmetricRicci_pairing_eq_raw {Site : Type*}
    (chart : DirectedNullEdgeChart Site) (site : Site) :
    metricVariationPairing (nullEdgeSymmetricRicci chart site)
        (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site) =
      metricVariationPairing (nullEdgeRawRicci chart site)
        (nullEdgeInverseMetric chart.toNondegenerateNullEdgeFrame site) := by
  exact metricVariationPairing_symmetricPart _ _
    (nullEdgeInverseMetric_symmetric
      chart.toNondegenerateNullEdgeFrame site)

/-! ## Flat canonical control -/

/-- Constant canonical null frames on any directed carrier. -/
def canonicalDirectedChart (Site : Type*)
    (target : Site -> Fin 4 -> Site) : DirectedNullEdgeChart Site where
  edges := (canonicalFrame Site).edges
  det_ne_zero := (canonicalFrame Site).det_ne_zero
  target := target

/-- A constant canonical null frame has zero metric first jet. -/
theorem canonicalDirectedChart_metricFirstJet_zero {Site : Type*}
    (target : Site -> Fin 4 -> Site) (site : Site) :
    nullEdgeMetricFirstJet (canonicalDirectedChart Site target) site = 0 := by
  funext direction left right
  simp [nullEdgeMetricFirstJet, edgeDifference, canonicalDirectedChart,
    nullEdgeMetric, canonicalFrame]

/-- Consequently its reconstructed Levi-Civita connection vanishes. -/
theorem canonicalDirectedChart_christoffel_zero {Site : Type*}
    (target : Site -> Fin 4 -> Site) (site : Site) :
    nullEdgeChristoffel (canonicalDirectedChart Site target) site = 0 := by
  rw [nullEdgeChristoffel,
    canonicalDirectedChart_metricFirstJet_zero target site]
  funext upper left right
  simp [christoffelSecondKind, christoffelFirstKind]

/-- The constant canonical chart is an exact zero-curvature control. -/
theorem canonicalDirectedChart_riemann_zero {Site : Type*}
    (target : Site -> Fin 4 -> Site) (site : Site) :
    nullEdgeRiemann (canonicalDirectedChart Site target) site = 0 := by
  funext upper lower left right
  unfold nullEdgeRiemann nullEdgeConnectionFirstJet edgeDifference
  simp_rw [canonicalDirectedChart_christoffel_zero target]
  simp

/-- The constant canonical chart also has zero derived Ricci response. -/
theorem canonicalDirectedChart_ricci_zero {Site : Type*}
    (target : Site -> Fin 4 -> Site) :
    nullEdgeSymmetricRicci (canonicalDirectedChart Site target) = 0 := by
  funext site left right
  simp [nullEdgeSymmetricRicci, symmetricPart, nullEdgeRawRicci,
    canonicalDirectedChart_riemann_zero target site]

/-! ## Action endpoint with graph-derived Ricci -/

variable {Site : Type*} [Fintype Site]

/-- Nonlinear Palatini chart action whose geometric coefficients are derived
from a single directed null-edge chart. -/
def directedNullEdgeChartAction
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) :
    LocalTensor (Site := Site) -> Real :=
  nullEdgeChartTotalAction kappa chart.toNondegenerateNullEdgeFrame
    (nullEdgeSymmetricRicci chart) stress cosmologicalConstant

/-- Scalar curvature obtained by contracting graph-derived symmetric Ricci
with the inverse metric derived from the same null edges. -/
def directedNullEdgeScalarCurvature
    (chart : DirectedNullEdgeChart Site) : Site -> Real :=
  nullEdgeScalarCurvature chart.toNondegenerateNullEdgeFrame
    (nullEdgeSymmetricRicci chart)

/-- **Directed-null-edge Einstein-action theorem.**  Stationarity of the
explicit nonlinear action is equivalent to the finite Einstein equation in
which coframe, metric, inverse metric, volume, connection, curvature, Ricci,
and scalar curvature all come from one directed null-edge chart.  The
variation itself is the larger coframe chart, not yet a proved lift of
null-edge-preserving spinor variations. -/
theorem directedNullEdgeChartAction_stationary_iff_einstein
    (kappa : Real) (chart : DirectedNullEdgeChart Site)
    (stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hStress : LocalSymmetric stress)
    (hKappa : Not (kappa = 0)) :
    ParameterStationary
        (directedNullEdgeChartAction kappa chart stress
          cosmologicalConstant) 0 <->
      LocalFiniteEinsteinEquation kappa
        (nullEdgeSymmetricRicci chart)
        (directedNullEdgeScalarCurvature chart)
        (nullEdgeMetric chart.edges) cosmologicalConstant stress := by
  exact nullEdgeChartTotalAction_stationary_iff_localFiniteEinsteinEquation
    kappa chart.toNondegenerateNullEdgeFrame
    (nullEdgeSymmetricRicci chart) stress cosmologicalConstant
    (nullEdgeSymmetricRicci_symmetric chart) hStress hKappa

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein.nullEdgeChristoffel_metric_compatible' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgeChristoffel_metric_compatible

/-- info: 'PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein.nullEdgeRiemann_antisymm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgeRiemann_antisymm

/-- info: 'PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein.canonicalDirectedChart_riemann_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalDirectedChart_riemann_zero

/-- info: 'PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein.directedNullEdgeChartAction_stationary_iff_einstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms directedNullEdgeChartAction_stationary_iff_einstein

end PhysicsSM.Draft.NullEdge.DirectedNullEdgeLeviCivitaEinstein

```

### PhysicsSM/Draft/NullEdge/NullEdgeCoframeEinsteinBridge.lean (496 lines)

```lean
import PhysicsSM.Draft.NullEdge.NullEdgeSpinorSolderingAristotle
import PhysicsSM.Draft.NullEdge.FinitePalatiniCoframeChartAction

/-!
# Null-edge coframes and the finite Einstein-action bridge

This module removes the coframe, metric, inverse metric, and volume from the
list of independently supplied inputs in the finite Palatini action theorem.
At each carrier site, four Weyl-spinor null edges are soldered to four
future-null Minkowski vectors and assembled as the columns of a real coframe.
When that coframe has nonzero determinant, its nonsingular matrix inverse
constructs the inverse metric.  Consequently:

* every coframe column is future-null;
* the induced Gram metric has zero diagonal in the null-edge basis;
* the metric, inverse metric, and oriented volume are all functions of the
  same four null edges;
* stationarity of the displayed nonlinear Palatini chart action is equivalent
  to the sitewise finite Einstein equation with this derived geometry.

The explicit canonical family proves nonvacuity: four concrete spinors give a
positively oriented coframe of determinant `1 / 2`.

This is a decorated-null-edge reconstruction theorem, not a bare-graph
reconstruction.  The selection of four independent spinors at each site,
Ricci curvature, stress, and the continuum/refinement interpretation remain
separate obligations.  Moreover, the action theorem uses unrestricted
coframe-generator variations around the null-edge base.  A guarded no-go below
shows that variations preserving four null columns have zero Gram diagonal and
cannot by themselves reach all ten symmetric metric components.  A gauge or
Bianchi completion, or a larger aggregate variation space, is still required
before calling the stationarity condition a null-edge-only variation.
Signature is mostly minus `(+,-,-,-)`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge

open Matrix
open NullEdgeSpinorSoldering
open EinsteinEquationVariation
open StressEnergyPhysicalControls
open LocalEinsteinEquationVariation
open RelaxedCausalMetricVariationBridge
open CoframeVolumeMetricVariation
open FinitePalatiniCoframeChartAction

/-- Four selected Weyl-spinor null edges at every carrier site. -/
abbrev NullEdgeDecoration (Site : Type*) := Site -> Fin 4 -> Spinor

/-- Assemble four soldered null vectors as the columns of a real coframe. -/
def nullEdgeCoframeAt (edges : Fin 4 -> Spinor) :
    RealCoframe (I := Fin 4) :=
  fun mu a => nullEdgeVector (edges a) mu

/-- Sitewise null-edge coframe. -/
def nullEdgeCoframe {Site : Type*} (edges : NullEdgeDecoration Site) :
    Site -> RealCoframe (I := Fin 4) :=
  fun site => nullEdgeCoframeAt (edges site)

/-- Mostly-minus Minkowski metric in the soldered vector coordinates. -/
def minkowskiMetric : Matrix (Fin 4) (Fin 4) Real :=
  !![1, 0, 0, 0;
     0, -1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, -1]

/-- The mostly-minus metric is symmetric. -/
theorem minkowskiMetric_isSymm : minkowskiMetric.IsSymm := by
  unfold Matrix.IsSymm
  ext i j
  fin_cases i <;> fin_cases j <;> simp [minkowskiMetric]

/-- The mostly-minus metric is its own matrix inverse. -/
theorem minkowskiMetric_mul_self : minkowskiMetric * minkowskiMetric = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [minkowskiMetric, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The determinant records one timelike and three spacelike directions. -/
theorem minkowskiMetric_det : minkowskiMetric.det = (-1 : Real) := by
  simp (maxSteps := 8000000) [minkowskiMetric,
    Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove,
    Matrix.submatrix_apply, Matrix.of_apply]

/-- Every column of the assembled coframe is a null vector. -/
theorem nullEdgeCoframeAt_column_null
    (edges : Fin 4 -> Spinor) (a : Fin 4) :
    minkowskiSq (fun mu => nullEdgeCoframeAt edges mu a) = 0 := by
  simpa [nullEdgeCoframeAt] using nullEdgeVector_minkowskiSq (edges a)

/-- Every column is future-directed, and a column has zero energy exactly
when its underlying spinor vanishes. -/
theorem nullEdgeCoframeAt_column_future
    (edges : Fin 4 -> Spinor) (a : Fin 4) :
    0 <= nullEdgeCoframeAt edges 0 a /\
      (nullEdgeCoframeAt edges 0 a = 0 <-> edges a = 0) := by
  simpa [nullEdgeCoframeAt] using nullEdgeVector_time_nonneg (edges a)

/-- Covariant Gram metric derived from one site's four null edges. -/
def nullEdgeMetricAt (edges : Fin 4 -> Spinor) : Tensor (I := Fin 4) :=
  inducedCovariantMetric minkowskiMetric (nullEdgeCoframeAt edges)

/-- Sitewise covariant metric derived from the same null-edge decoration. -/
def nullEdgeMetric {Site : Type*} (edges : NullEdgeDecoration Site) :
    LocalTensor (Site := Site) :=
  fun site => nullEdgeMetricAt (edges site)

/-- In the edge-labelled basis, every diagonal Gram entry vanishes because
the corresponding coframe column is null. -/
theorem nullEdgeMetricAt_diagonal_zero
    (edges : Fin 4 -> Spinor) (a : Fin 4) :
    nullEdgeMetricAt edges a a = 0 := by
  have hNull := nullEdgeCoframeAt_column_null edges a
  simpa [nullEdgeMetricAt, inducedCovariantMetric, minkowskiMetric,
    nullEdgeCoframeAt, minkowskiSq, Matrix.mul_apply, Fin.sum_univ_succ,
    pow_two, sub_eq_add_neg, add_assoc] using hNull

/-- The determinant of the null-edge Gram metric is minus the square of the
null-edge coframe determinant. -/
theorem nullEdgeMetricAt_det (edges : Fin 4 -> Spinor) :
    (nullEdgeMetricAt edges).det = -(nullEdgeCoframeAt edges).det ^ 2 := by
  unfold nullEdgeMetricAt inducedCovariantMetric
  rw [Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose,
    minkowskiMetric_det]
  ring

/-- A tangent to the space of null Gram matrices has zero diagonal. -/
def HasZeroDiagonal (variation : Tensor (I := Fin 4)) : Prop :=
  forall direction, variation direction direction = 0

/-- Any differentiable path whose Gram diagonal stays null has a
zero-diagonal tangent. -/
theorem nullGramPath_tangent_hasZeroDiagonal
    (metricPath : Real -> Tensor (I := Fin 4))
    (variation : Tensor (I := Fin 4))
    (hNull : forall t direction,
      metricPath t direction direction = 0)
    (hDerivative : forall direction,
      HasDerivAt (fun t => metricPath t direction direction)
        (variation direction direction) 0) :
    HasZeroDiagonal variation := by
  intro direction
  have hFunction :
      (fun t : Real => metricPath t direction direction) =
        (fun _ : Real => 0) := by
    funext t
    exact hNull t direction
  have hVariation := hDerivative direction
  rw [hFunction] at hVariation
  exact hVariation.unique (hasDerivAt_const 0 0)

/-- **Null-column tangent no-go.** A parameter derivative whose image always
has zero diagonal cannot reach every symmetric `4 x 4` metric variation. -/
theorem zeroDiagonalMetricDerivative_not_full
    {Parameter : Type*} [AddCommGroup Parameter] [Module Real Parameter]
    (metricDerivative :
      Parameter →ₗ[Real] Tensor (I := Fin 4))
    (hDiagonal : forall parameter,
      HasZeroDiagonal (metricDerivative parameter)) :
    Not (IsFullSymmetricMetricDerivative metricDerivative) := by
  intro hFull
  have hOne : (1 : Tensor (I := Fin 4)).IsSymm := by
    unfold Matrix.IsSymm
    simp
  obtain ⟨parameter, hParameter⟩ := hFull.2 1 hOne
  have hZero := hDiagonal parameter 0
  rw [hParameter] at hZero
  norm_num at hZero

/-- Diagonal part of a metric variation. -/
def diagonalPart (variation : Tensor (I := Fin 4)) : Tensor (I := Fin 4) :=
  Matrix.diagonal (fun direction => variation direction direction)

/-- Zero-diagonal part of a metric variation. -/
def zeroDiagonalPart
    (variation : Tensor (I := Fin 4)) : Tensor (I := Fin 4) :=
  variation - diagonalPart variation

/-- The diagonal part is symmetric. -/
theorem diagonalPart_isSymm (variation : Tensor (I := Fin 4)) :
    (diagonalPart variation).IsSymm := by
  unfold diagonalPart Matrix.IsSymm
  exact Matrix.diagonal_transpose _

/-- Removing the diagonal preserves symmetry. -/
theorem zeroDiagonalPart_isSymm
    (variation : Tensor (I := Fin 4)) (hVariation : variation.IsSymm) :
    (zeroDiagonalPart variation).IsSymm := by
  exact hVariation.sub (diagonalPart_isSymm variation)

/-- The off-diagonal projection has zero diagonal. -/
theorem zeroDiagonalPart_hasZeroDiagonal
    (variation : Tensor (I := Fin 4)) :
    HasZeroDiagonal (zeroDiagonalPart variation) := by
  intro direction
  simp [zeroDiagonalPart, diagonalPart]

/-- Every metric variation is the sum of its zero-diagonal and diagonal
parts. -/
theorem zeroDiagonalPart_add_diagonalPart
    (variation : Tensor (I := Fin 4)) :
    zeroDiagonalPart variation + diagonalPart variation = variation := by
  unfold zeroDiagonalPart
  abel

/-- **Six-plus-four completion theorem.** If one parameter derivative reaches
every symmetric zero-diagonal variation and every diagonal variation, then it
reaches every symmetric metric variation.  This is the exact algebraic target
for completing null-column variations by gauge or aggregate directions. -/
theorem full_of_zeroDiagonal_and_diagonal_reach
    {Parameter : Type*} [AddCommGroup Parameter] [Module Real Parameter]
    (metricDerivative : Parameter →ₗ[Real] Tensor (I := Fin 4))
    (hSymmetric : forall parameter,
      (metricDerivative parameter).IsSymm)
    (hZeroDiagonalReach : forall variation,
      variation.IsSymm -> HasZeroDiagonal variation ->
        ∃ parameter, metricDerivative parameter = variation)
    (hDiagonalReach : forall diagonal : Fin 4 -> Real,
      ∃ parameter,
        metricDerivative parameter = Matrix.diagonal diagonal) :
    IsFullSymmetricMetricDerivative metricDerivative := by
  constructor
  · exact hSymmetric
  · intro variation hVariation
    obtain ⟨offParameter, hOffParameter⟩ :=
      hZeroDiagonalReach (zeroDiagonalPart variation)
        (zeroDiagonalPart_isSymm variation hVariation)
        (zeroDiagonalPart_hasZeroDiagonal variation)
    obtain ⟨diagonalParameter, hDiagonalParameter⟩ :=
      hDiagonalReach (fun direction => variation direction direction)
    refine ⟨offParameter + diagonalParameter, ?_⟩
    rw [map_add, hOffParameter, hDiagonalParameter]
    exact zeroDiagonalPart_add_diagonalPart variation

/-- A nondegenerate decorated null-edge frame.  Nondegeneracy is exactly the
requirement that the four soldered null directions span four dimensions. -/
structure NondegenerateNullEdgeFrame (Site : Type*) where
  edges : NullEdgeDecoration Site
  det_ne_zero : forall site, (nullEdgeCoframe edges site).det ≠ 0

/-- The inverse coframe is constructed from the null-edge coframe rather than
supplied as independent geometry. -/
def inverseCoframe {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    RealCoframe (I := Fin 4) :=
  (nullEdgeCoframe frame.edges site)⁻¹

/-- The constructed inverse coframe is a left inverse. -/
theorem inverseCoframe_mul {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    inverseCoframe frame site * nullEdgeCoframe frame.edges site = 1 := by
  exact Matrix.nonsing_inv_mul _
    (isUnit_iff_ne_zero.mpr (frame.det_ne_zero site))

/-- The constructed inverse coframe is a right inverse. -/
theorem mul_inverseCoframe {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    nullEdgeCoframe frame.edges site * inverseCoframe frame site = 1 := by
  exact Matrix.mul_nonsing_inv _
    (isUnit_iff_ne_zero.mpr (frame.det_ne_zero site))

/-- Inverse metric derived from the inverse of the null-edge coframe. -/
def nullEdgeInverseMetric {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) :
    LocalTensor (Site := Site) :=
  fun site => inducedCovariantMetric minkowskiMetric
    (inverseCoframe frame site).transpose

/-- The null-edge Gram metric is symmetric. -/
theorem nullEdgeMetric_symmetric {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) :
    LocalSymmetric (nullEdgeMetric frame.edges) := by
  intro site
  exact inducedCovariantMetric_isSymm _ _ minkowskiMetric_isSymm

/-- The derived inverse metric is symmetric. -/
theorem nullEdgeInverseMetric_symmetric {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) :
    LocalSymmetric (nullEdgeInverseMetric frame) := by
  intro site
  exact inducedCovariantMetric_isSymm _ _ minkowskiMetric_isSymm

/-- The metric reconstructed from a nondegenerate null-edge frame is itself
nondegenerate. -/
theorem nullEdgeMetric_det_ne_zero {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    (nullEdgeMetric frame.edges site).det ≠ 0 := by
  have hCoframe : (nullEdgeCoframeAt (frame.edges site)).det ≠ 0 := by
    simpa [nullEdgeCoframe] using frame.det_ne_zero site
  change (nullEdgeMetricAt (frame.edges site)).det ≠ 0
  rw [nullEdgeMetricAt_det]
  exact neg_ne_zero.mpr (pow_ne_zero 2 hCoframe)

/-- The metric built from the inverse null-edge coframe is a left inverse of
the null-edge Gram metric. -/
theorem nullEdgeInverseMetric_mul_metric {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    nullEdgeInverseMetric frame site * nullEdgeMetric frame.edges site = 1 := by
  let E := nullEdgeCoframe frame.edges site
  let F := inverseCoframe frame site
  have hFE : F * E = 1 := inverseCoframe_mul frame site
  have hEF : E * F = 1 := mul_inverseCoframe frame site
  have hTranspose : F.transpose * E.transpose = 1 := by
    rw [<- Matrix.transpose_mul, hEF, Matrix.transpose_one]
  change (F * minkowskiMetric * F.transpose) *
      (E.transpose * minkowskiMetric * E) = 1
  calc
    (F * minkowskiMetric * F.transpose) *
        (E.transpose * minkowskiMetric * E) =
        F * minkowskiMetric * (F.transpose * E.transpose) *
          minkowskiMetric * E := by noncomm_ring
    _ = F * minkowskiMetric * 1 * minkowskiMetric * E := by rw [hTranspose]
    _ = F * (minkowskiMetric * minkowskiMetric) * E := by noncomm_ring
    _ = F * E := by rw [minkowskiMetric_mul_self, Matrix.mul_one]
    _ = 1 := hFE

/-- The null-edge Gram metric is also a left inverse of its derived inverse
metric. -/
theorem nullEdgeMetric_mul_inverseMetric {Site : Type*}
    (frame : NondegenerateNullEdgeFrame Site) (site : Site) :
    nullEdgeMetric frame.edges site * nullEdgeInverseMetric frame site = 1 := by
  let E := nullEdgeCoframe frame.edges site
  let F := inverseCoframe frame site
  have hFE : F * E = 1 := inverseCoframe_mul frame site
  have hEF : E * F = 1 := mul_inverseCoframe frame site
  have hTranspose : E.transpose * F.transpose = 1 := by
    rw [<- Matrix.transpose_mul, hFE, Matrix.transpose_one]
  change (E.transpose * minkowskiMetric * E) *
      (F * minkowskiMetric * F.transpose) = 1
  calc
    (E.transpose * minkowskiMetric * E) *
        (F * minkowskiMetric * F.transpose) =
        E.transpose * minkowskiMetric * (E * F) *
          minkowskiMetric * F.transpose := by noncomm_ring
    _ = E.transpose * minkowskiMetric * 1 * minkowskiMetric * F.transpose := by
      rw [hEF]
    _ = E.transpose * (minkowskiMetric * minkowskiMetric) * F.transpose := by
      noncomm_ring
    _ = E.transpose * F.transpose := by
      rw [minkowskiMetric_mul_self, Matrix.mul_one]
    _ = 1 := hTranspose

/-! ## An explicit nondegenerate four-null-edge witness -/

/-- Four concrete future-null spinors.  The first two are the opposite
`z`-directions, followed by the positive `x`- and `y`-directions. -/
def canonicalNullEdges : Fin 4 -> Spinor :=
  ![![0, 1], ![1, 0], ![1, 1], ![1, Complex.I]]

/-- The exact coframe soldered from `canonicalNullEdges`. -/
def canonicalCoframe : RealCoframe (I := Fin 4) :=
  !![1 / 2, 1 / 2, 1, 1;
     0, 0, 1, 0;
     0, 0, 0, 1;
     -1 / 2, 1 / 2, 0, 0]

/-- Soldering the four canonical spinors gives the displayed coframe. -/
theorem canonicalNullEdgeCoframe_eq :
    nullEdgeCoframeAt canonicalNullEdges = canonicalCoframe := by
  ext mu a
  fin_cases mu <;> fin_cases a <;>
    norm_num [nullEdgeCoframeAt, canonicalNullEdges, canonicalCoframe,
      nullEdgeVector, vecOfHerm, rankOne]

/-- The canonical null-edge coframe has positive oriented volume `1 / 2`. -/
theorem canonicalCoframe_det : canonicalCoframe.det = (1 / 2 : Real) := by
  simp (maxSteps := 8000000) [canonicalCoframe,
    Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove,
    Matrix.submatrix_apply, Matrix.of_apply]
  all_goals norm_num

/-- The canonical four-spinor decoration is a nondegenerate null-edge frame
at every site. -/
def canonicalFrame (Site : Type*) : NondegenerateNullEdgeFrame Site where
  edges := fun _ => canonicalNullEdges
  det_ne_zero site := by
    rw [nullEdgeCoframe, canonicalNullEdgeCoframe_eq, canonicalCoframe_det]
    norm_num

/-! ## Null-edge-derived Einstein-action endpoint -/

variable {Site : Type*} [Fintype Site]

/-- The Palatini chart action with coframe, inverse metric, metric, and volume
all derived from one nondegenerate null-edge decoration. -/
def nullEdgeChartTotalAction
    (kappa : Real) (frame : NondegenerateNullEdgeFrame Site)
    (ricci stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real) :
    LocalTensor (Site := Site) -> Real :=
  chartTotalAction kappa (nullEdgeCoframe frame.edges) ricci
    (nullEdgeInverseMetric frame) stress cosmologicalConstant

/-- Scalar curvature obtained by contracting supplied Ricci curvature with
the inverse metric reconstructed from the null edges. -/
def nullEdgeScalarCurvature
    (frame : NondegenerateNullEdgeFrame Site)
    (ricci : LocalTensor (Site := Site)) : Site -> Real :=
  chartBaseScalarCurvature ricci (nullEdgeInverseMetric frame)

omit [Fintype Site] in
/-- The explicit canonical decoration has positive oriented volume `1 / 2` at
every site. -/
theorem canonicalFrame_volume (site : Site) :
    chartBaseVolume
        (nullEdgeCoframe (canonicalFrame Site).edges) site = (1 / 2 : Real) := by
  simp [chartBaseVolume, coframeVolume, canonicalFrame, nullEdgeCoframe,
    canonicalNullEdgeCoframe_eq, canonicalCoframe_det]

/-- **Null-edge coframe Einstein-action theorem.**  Once four independent
spinor null edges are selected at every site, the coframe, Gram metric,
inverse metric, scalar curvature contraction, and volume in the action are
derived from those edges.  Stationarity of the explicit nonlinear action is
equivalent to the pointwise finite Einstein equation under unrestricted local
coframe-generator variations.  The theorem above shows that this full
variation space is larger than the null-column-preserving tangent space. -/
theorem nullEdgeChartTotalAction_stationary_iff_localFiniteEinsteinEquation
    (kappa : Real) (frame : NondegenerateNullEdgeFrame Site)
    (ricci stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hRicci : LocalSymmetric ricci)
    (hStress : LocalSymmetric stress)
    (hKappa : Not (kappa = 0)) :
    ParameterStationary
        (nullEdgeChartTotalAction kappa frame ricci stress
          cosmologicalConstant) 0 <->
      LocalFiniteEinsteinEquation kappa ricci
        (nullEdgeScalarCurvature frame ricci)
        (nullEdgeMetric frame.edges) cosmologicalConstant stress := by
  apply chartTotalAction_stationary_iff_localFiniteEinsteinEquation
    kappa (nullEdgeCoframe frame.edges) ricci (nullEdgeMetric frame.edges)
    (nullEdgeInverseMetric frame) stress cosmologicalConstant
  · intro site
    simpa [chartBaseVolume, coframeVolume] using frame.det_ne_zero site
  · exact hRicci
  · exact nullEdgeMetric_symmetric frame
  · exact nullEdgeInverseMetric_symmetric frame
  · exact hStress
  · exact nullEdgeInverseMetric_mul_metric frame
  · exact nullEdgeMetric_mul_inverseMetric frame
  · exact hKappa

/-- **Explicit nonvacuity corollary.**  The four displayed canonical spinors
provide a concrete null-edge action whose stationary points are exactly the
finite Einstein solutions for the resulting null-tetrad metric. -/
theorem canonicalNullEdgeChartTotalAction_stationary_iff
    (kappa : Real) (ricci stress : LocalTensor (Site := Site))
    (cosmologicalConstant : Real)
    (hRicci : LocalSymmetric ricci)
    (hStress : LocalSymmetric stress)
    (hKappa : Not (kappa = 0)) :
    ParameterStationary
        (nullEdgeChartTotalAction kappa (canonicalFrame Site) ricci stress
          cosmologicalConstant) 0 <->
      LocalFiniteEinsteinEquation kappa ricci
        (nullEdgeScalarCurvature (canonicalFrame Site) ricci)
        (nullEdgeMetric (canonicalFrame Site).edges)
        cosmologicalConstant stress :=
  nullEdgeChartTotalAction_stationary_iff_localFiniteEinsteinEquation
    kappa (canonicalFrame Site) ricci stress cosmologicalConstant
      hRicci hStress hKappa

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.nullEdgeMetricAt_diagonal_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgeMetricAt_diagonal_zero

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.zeroDiagonalMetricDerivative_not_full' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zeroDiagonalMetricDerivative_not_full

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.full_of_zeroDiagonal_and_diagonal_reach' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms full_of_zeroDiagonal_and_diagonal_reach

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.nullEdgeInverseMetric_mul_metric' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgeInverseMetric_mul_metric

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.canonicalCoframe_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalCoframe_det

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.canonicalNullEdgeChartTotalAction_stationary_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms canonicalNullEdgeChartTotalAction_stationary_iff

/-- info: 'PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge.nullEdgeChartTotalAction_stationary_iff_localFiniteEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullEdgeChartTotalAction_stationary_iff_localFiniteEinsteinEquation

end PhysicsSM.Draft.NullEdge.NullEdgeCoframeEinsteinBridge

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


Ignore the prior failed response line and perform the requested independent review now. Do not edit files.
```

## Extracted response text

```text
### 1. Index/Sign Audit and Derived Coefficient Formula

The finite Palatini action is $S = \sum_x \tilde{g}^{bd}(x) R_{bd}(x)$, where $\tilde{g}^{bd}(x) = V(x) g^{bd}(x)$ is the densitized inverse metric. The raw Ricci tensor is:
$$ R_{bd}(x) = \sum_a \left[ \Delta_a \Gamma^a_{db}(x) - \Delta_d \Gamma^a_{ab}(x) + \sum_m \left( \Gamma^a_{am}(x) \Gamma^m_{db}(x) - \Gamma^a_{dm}(x) \Gamma^m_{ab}(x) \right) \right] $$
Varying the connection $\delta \Gamma^u_{lr}(y) = H^u_{lr}(y)$ and applying exact periodic summation by parts $\sum_x f(x) \Delta_c h(x) = \sum_x (\nabla^*_c f(x)) h(x)$ (where $\nabla^*_c f(x) = f(x-c) - f(x)$ is the backward difference), we isolate the coefficient of $H^u_{lr}(x)$ in $\delta S$:

1. $\nabla^*_a \tilde{g}^{bd} H^a_{db} \implies \nabla^*_u \tilde{g}^{rl}(x)$
2. $-\nabla^*_d \tilde{g}^{bd} H^a_{ab} \implies -\delta^u_l \sum_d \nabla^*_d \tilde{g}^{rd}(x)$
3. $\tilde{g}^{bd} H^a_{am} \Gamma^m_{db} \implies \delta^u_l \
```

## Raw response JSON

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "### 1. Index/Sign Audit and Derived Coefficient Formula\n\nThe finite Palatini action is $S = \\sum_x \\tilde{g}^{bd}(x) R_{bd}(x)$, where $\\tilde{g}^{bd}(x) = V(x) g^{bd}(x)$ is the densitized inverse metric. The raw Ricci tensor is:\n$$ R_{bd}(x) = \\sum_a \\left[ \\Delta_a \\Gamma^a_{db}(x) - \\Delta_d \\Gamma^a_{ab}(x) + \\sum_m \\left( \\Gamma^a_{am}(x) \\Gamma^m_{db}(x) - \\Gamma^a_{dm}(x) \\Gamma^m_{ab}(x) \\right) \\right] $$\nVarying the connection $\\delta \\Gamma^u_{lr}(y) = H^u_{lr}(y)$ and applying exact periodic summation by parts $\\sum_x f(x) \\Delta_c h(x) = \\sum_x (\\nabla^*_c f(x)) h(x)$ (where $\\nabla^*_c f(x) = f(x-c) - f(x)$ is the backward difference), we isolate the coefficient of $H^u_{lr}(x)$ in $\\delta S$:\n\n1. $\\nabla^*_a \\tilde{g}^{bd} H^a_{db} \\implies \\nabla^*_u \\tilde{g}^{rl}(x)$\n2. $-\\nabla^*_d \\tilde{g}^{bd} H^a_{ab} \\implies -\\delta^u_l \\sum_d \\nabla^*_d \\tilde{g}^{rd}(x)$\n3. $\\tilde{g}^{bd} H^a_{am} \\Gamma^m_{db} \\implies \\delta^u_l \\",
            "thoughtSignature": "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"
          }
        ],
        "role": "model"
      },
      "finishReason": "MAX_TOKENS",
      "index": 0
    }
  ],
  "usageMetadata": {
    "promptTokenCount": 30778,
    "candidatesTokenCount": 400,
    "totalTokenCount": 40774,
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 30778
      }
    ],
    "thoughtsTokenCount": 9596,
    "serviceTier": "standard"
  },
  "modelVersion": "gemini-3.1-pro-preview",
  "responseId": "pqBaata9Gr6C-8YP75-yiAI"
}
```

## Error

```text

```
