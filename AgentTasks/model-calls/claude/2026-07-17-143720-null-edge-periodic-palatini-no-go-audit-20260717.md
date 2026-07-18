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
