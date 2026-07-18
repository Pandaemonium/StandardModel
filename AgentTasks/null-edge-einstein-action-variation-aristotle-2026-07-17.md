# Aristotle job: null-edge Einstein action variation audit

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`

```yaml
aristotle:
  project_id: 8800eed1-b87b-464b-b28e-89c21ce9c8a0
  task_id: f23379db-f9f1-41d5-8122-856c19774c44
  target_file: ARISTOTLE_ACTION_VARIATION_AUDIT.md
  expected_module: none-strategy-audit
  submission_project: AgentTasks/aristotle-standalone/null-edge-einstein-action-variation-20260717
  output_dir: AgentTasks/aristotle-output/8800eed1-b87b-464b-b28e-89c21ce9c8a0
  status: integrated
```

## Question

What is the smallest noncircular theorem architecture that can derive the
first-variation premise of
`EinsteinEquationVariation.actionMetricStationary_iff_finiteEinsteinEquation`
from a graph-native interval-count action?

The job must keep three debts separate: the exact finite derivative, continuum
convergence of the action, and interchange of first variation with the
refinement limit. It must not promote `EinsteinHilbertTerm.lean` or the imported
FLRW action beyond their documented avatar/control status.

## Inputs

- `AgentTasks/context-packs/null-edge-einstein-action-variation-20260717-094211.md`
- `PhysicsSM/Draft/NullEdge/EinsteinEquationVariation.lean`
- `PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean`
- `PhysicsSM/Draft/NullEdge/StressEnergyPhysicalControls.lean`
- `PhysicsSM/Draft/NullEdge/FiniteContractedBianchi.lean`
- `PhysicsSM/Draft/NullEdge/EinsteinHilbertTerm.lean`
- `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md`

The semantic document-index refresh was attempted twice after the new Lean and
documentation edits but exceeded five minutes on the current shared worktree.
The focused context-pack query itself completed successfully using the local
index and produced the cited pack.

## Integration rule

This is a strategy audit. Do not integrate returned Lean or prose directly.
First compare every proposed theorem against the one-metric, one-curvature, and
one-action contracts in the GR foundations spine. Any proposed theorem whose
premise already contains the desired Einstein coefficient must be classified
as an interface theorem rather than a derivation.

## Submission

Submitted 2026-07-17. Aristotle project
`8800eed1-b87b-464b-b28e-89c21ce9c8a0`, task
`f23379db-f9f1-41d5-8122-856c19774c44`, entered `QUEUED` and then
`IN_PROGRESS`. The CLI warned that
the audit packet has no Lean toolchain or dependency cache. This is intentional
for this prose/statement audit; the packet requests no remote build or proof
claim, and all proposed Lean statements must be typechecked locally before any
later proof submission.

## Harvest and integration

Harvested 2026-07-17 from
`AgentTasks/aristotle-output/8800eed1-b87b-464b-b28e-89c21ce9c8a0/`.
The audit independently confirmed that no existing action discharges
`HasEinsteinMetricFirstVariation`. It identified the bare finite-order
variation as discrete and selected an affine layer-weight deformation as the
first noncircular action derivative.

The recommendation was implemented locally rather than copied from returned
code:

- `DiscreteCausalActionVariationNoGo.lean` proves that continuous paths in the
  unweighted graph space make every graph action stationary, so that notion is
  vacuous.
- `RelaxedCausalMetricVariationBridge.lean` proves that relaxed-parameter
  stationarity gives only a projected response unless the metric derivative
  reaches every symmetric variation.
- `WeightedIntervalActionVariation.lean` proves the exact affine layer-weight
  derivative, order-isomorphism covariance, and a nonzero two-event witness.
- `LayerWeightMetricRankNoGo.lean` constructs ten independent symmetric
  four-dimensional metric directions, proves that fewer than ten independent
  weights cannot have one-site full metric reach, and proves the stronger
  `10N` lower bound for unrestricted local metric reach on `N` sites. A fixed
  global list of layer weights therefore cannot survive unbounded refinement.
- `LocalizedIntervalActionMetric.lean` implements the event-local successor.
  Its action derivative and same-operator corrected metric are exact. An
  eleven-event supplied-probe witness has full rank ten, an explicit inverse,
  trivial metric fibers, and exact action descent; full row reach conditionally
  composes across distinct selected bulk centers.
- `LocalEinsteinEquationVariation.lean` lifts the variational endpoint to a
  finite field: site-supported symmetric variations make local stationarity
  equivalent to the pointwise finite Einstein equation, and the same endpoint
  pulls back through any full local metric Jacobian.
- `LocalizedIntervalAffineActionNoGo.lean` proves that the positive rank and
  fiber tests do not close dynamics. The fixed-measure action is affine, and
  the rank-ten chain has an explicit symmetric direction with derivative `10`,
  so neither the coefficient action nor its descended metric action is
  stationary at any base.
- `FiniteEinsteinHilbertActionResponse.lean` records the minimal supplied
  nonlinear replacement: the finite `volume * (R - 2 Lambda)` response splits
  into volume and curvature channels and has the expected quadratic cross
  term. It does not derive either channel from the graph.
- `CoframeVolumeMetricVariation.lean` derives the volume channel from the
  coframe determinant and proves that coframe generators reach every symmetric
  inverse-metric variation for a symmetric nondegenerate metric.
- `FinitePalatiniEinsteinHilbertVariation.lean` composes that determinant
  identity with a Ricci-plus-boundary Palatini response to obtain the weighted
  Einstein tensor, proves nonzero local volumes cancel from the field equation,
  and adds the full parameter-pullback endpoint.
- `FinitePalatiniBoundaryCancellation.lean` proves exact finite incidence
  summation by parts and derives the zero-boundary Palatini identity from a
  local Ricci-plus-divergence formula. A two-vertex unit-flux witness has local
  residuals `-1` and `+1`.
- `FinitePalatiniCoframeChartAction.lean` defines an actual nonlinear finite
  action from `det(e(1+X))`, a fixed-connection Ricci contraction, cosmological
  term, and matter response. Its calculated derivative and full coframe metric
  reach make stationarity equivalent to the pointwise finite Einstein equation.
- `NullEdgeCoframeEinsteinBridge.lean` solders four Weyl-spinor null edges into
  a nondegenerate coframe and derives the Gram metric, inverse metric, volume,
  and action endpoint from those same edges. A canonical four-edge witness has
  positive determinant `1/2`. It also proves that null-column-preserving
  tangents have zero Gram diagonal and cannot reach all ten symmetric metric
  variations; the full action endpoint currently uses a larger coframe chart.
  Its six-plus-four completion theorem shows that zero-diagonal reach plus all
  four diagonal directions is sufficient for full metric reach.
- `DirectedNullEdgeLeviCivitaEinstein.lean` adds the directed targets of those
  four edges, derives forward metric differences, Levi-Civita coefficients,
  coordinate Riemann curvature, raw and symmetric Ricci response, and an action
  endpoint with no independently supplied coframe, metric, inverse, volume, or
  Ricci tensor. The symmetric projection is proved variationally faithful, and
  the constant canonical chart is an exact flat control.
- `NullEdgeAggregateCoframeEinstein.lean` resolves the finite variation-space
  obstruction by treating physical coframes as aggregates `E A` of a primitive
  nondegenerate null frame. The weight-to-coframe map is bijective, any
  symmetric inverse-metric variation has the explicit generator
  `X=-(1/2) h g`, skew frame generators are metric-invisible, and stationarity
  at identity absolute weights is equivalent to the finite Einstein equation.
  Its one-metric bridge proves that any operator-metric coframe factor has the
  unique weights `A=E^{-1}e` and is reproduced exactly.
- `FiniteDirectedPalatiniConnectionVariation.lean` separates the directed
  curvature formula from the Levi-Civita substitution and differentiates an
  arbitrary connection line exactly. The resulting Ricci and weighted-action
  response is `Delta H + Gamma H + H Gamma`; stationarity is equivalent to
  vanishing of that derived functional. On a periodic carrier the canonical
  flat null-edge connection is stationary using its own reconstructed volume
  and inverse metric.
- `NullEdgePalatiniJointAction.lean` combines aggregate coframe generators and
  the independent directed connection in one displayed two-field action. Its
  metric partial is the finite Einstein equation and its connection partial is
  the explicit finite connection Euler-Lagrange equation.

The next hard gate is no longer the abstract nonlinear variational algebra or
the existence of a decorated null-edge Ricci construction. It is to derive the
four-direction frame and its synchronization from the causal/operator sector,
identify its Gram metric with the corrected operator metric, prove that the
derived connection equation selects the metric-compatible null-edge
Levi-Civita connection and has the required local Palatini-divergence form, and show
that forward-difference, plaquette, and Dirac-square curvature agree. Stress,
the order/operator derivation and gauge law of the aggregate weights, physical
boundaries, normalization, refinement, and variation-limit interchange then
remain.
