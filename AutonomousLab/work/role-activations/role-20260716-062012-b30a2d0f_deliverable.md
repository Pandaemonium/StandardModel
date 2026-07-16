# Accessible result: why the first causal shell was not local

Date: 2026-07-16  
Role activation: `role-20260716-062012-b30a2d0f`  
Project: `NE-GRAVITY-SCALE`  
Research result: A3c plus `RetardedShellInfraredNoGo`

## One-sentence explanation

A rule can use only nearby-looking causal counts and still collect events from
an arbitrarily large spacetime region, so the first null-edge "shell" cannot be
used as a local geometric neighborhood.

## Accessible explanation

The GR program needs a small neighborhood around an event before it can try to
reconstruct local directions, a metric, curvature, or a tetrad. The first idea
was to select past events by counting how many events lie causally between each
candidate source and the target. A bounded count sounds local: zero events in
between sounds especially close.

That intuition is reliable in an ordinary Euclidean grid, but it fails in
Lorentzian spacetime. Events can be separated by the same small proper time
while lying at ever larger coordinate distance, increasingly close to the light
cone. A fixed proper-time shell is therefore a hyperboloid, not a compact
sphere. It stretches without bound in the boost, or rapidity, direction.

The numerical experiment made this visible without changing any local input.
It enlarged the outer causal diamond while keeping the event density,
discreteness scale, operator scale, adjacent-scale ratio, and count bands fixed.
The fraction of randomized marks with enough shell events at all three scales
rose from about 2 percent to 37 percent between volume multipliers 1 and 4, and
an exploratory multiplier 8 reached about 51 percent. The shell seemed to work
better only because the larger outer diamond exposed more of its noncompact
rapidity direction.

The exact finite theorem removes any doubt that this is only a sampling
artifact. For every natural number `n`, it builds a finite three-level causal
order with exactly `n` source events in the same fixed minimal interval-count
band. Every source has zero events in its open interval to the target, and the
same nonzero two-sided abundance condition is retained. Local count data alone
therefore do not bound shell cardinality.

This is a useful failure. The program now knows that "enough source events" or
"rank at least four" cannot certify locality. The replacement must first choose
a compact causal bracket with endpoints below and above the mark, restrict all
calculations to its induced finite order, and check stability when brackets are
refined or overlap. If no individual bracket is canonical, the covariant object
must be the complete eligible-bracket ensemble rather than one preferred
choice.

That replacement is being tested. It is not yet an emergent tetrad, metric, or
derivation of Einstein's equation.

## Evidence-grade map

| Statement | Grade | What supports it | What it does not support |
|---|---|---|---|
| Fixed proper-time/count shells are noncompact in the rapidity direction in Minkowski spacetime | `T [import/derived]` under the displayed flat-spacetime assumptions | Standard Lorentzian hyperbolic coordinates and primary causal-set layer/nonlocality literature | Curved-spacetime convergence or a theorem about every possible order-only neighborhood |
| Enlarging the outer diamond strongly increases shell availability at fixed local inputs | Numerical boundary control | Frozen A3c sparse experiment, ten realizations at multipliers 1, 2, and 4; exploratory five-realization multiplier 8 | A continuum theorem, asymptotic rate, or proof that every larger volume behaves monotonically |
| The exact shell predicate admits arbitrary finite cardinality with one fixed minimal count band and nonzero abundance | `M`, program-internal; originality tag provisional pending restored full-text search | Kernel-checked theorem `arbitrarily_large_fixedInterval_shell` and standard axiom guard | Physical locality, Lorentz recovery, dimension, metric signature, or a no-go for all causal-set operators |
| The global count-band shell is unsuitable as the program's local carrier | `T|H [interp]` from the exact and numerical results | Noncompact continuum geometry plus finite arbitrary-cardinality witness plus A3c volume dependence | The claim that causal sets cannot support any local operator |
| Compact Alexandrov brackets are the correct replacement | Preregistered candidate, not established | Existing compact-germ internality/equivariance theorems and the frozen A3d protocol | Stable coverage, rank four, Lorentzian inertia, tetrad, curvature, or Einstein dynamics |

## Formal anchors

- `PhysicsSM/Draft/NullEdge/RetardedShellInfraredNoGo.lean`
  - `fixedIntervalShell_card`
  - `fixedIntervalShell_openIntervalCount_eq_zero`
  - `arbitrarily_large_fixedInterval_shell`
  - build-enforced standard-three axiom guard
- `Scripts/experiments/causal_larger_diamond_support.py`
- `Scripts/experiments/test_causal_larger_diamond_support.py`
- `AgentTasks/causal-larger-diamond-support-stage-a3c-2026-07-16.json`
- `AgentTasks/null-edge-causal-larger-diamond-support-stage-a3c-benchmark-2026-07-16.md`
- Successor interfaces:
  - `PhysicsSM/Draft/NullEdge/AlexandrovGermPacking.lean`
  - `PhysicsSM/Draft/NullEdge/AlexandrovGermInternalOperator.lean`
  - `GRAV-LOCAL-CARRIER-001`

## Visual plan

### Panel A: why a Lorentzian shell is not a sphere

Draw a `1+1` spacetime diagram with the target event at the origin and its past
light cone. Show three points on one constant-proper-time hyperbola. Move the
points outward toward the cone while preserving their proper time to the
target. Label the unbounded direction "rapidity," not ordinary radius.

Caption: "Equal causal interval size does not imply compact coordinate
distance."

### Panel B: the outer-diamond control

Show nested finite causal diamonds at volume multipliers 1, 2, and 4 around the
same target. Use the same shell color and local scale marker in every diamond.
Reveal progressively more shell points as the outer boundary expands.

Caption: "The local rule is unchanged; only the infrared window grows."

Place the three primary rank-capable rates below the panels: `1.93%`, `17.19%`,
and `36.97%`. Mark the multiplier-8 value as exploratory, visually distinct
from the preregistered ladder.

### Panel C: the exact finite family

Draw the three-level causal order used by the Lean theorem: private bottom
events, `n` shell sources, and one common mark. Emphasize that each shell-source
to mark interval is empty while the shell cardinality is exactly `n`.

Caption: "The same minimal interval count permits any finite shell size."

### Panel D: the compact successor

Draw marked endpoints `p < x < q` and shade only the closed Alexandrov carrier
between `p` and `q`. Show two overlapping or nested brackets, with all operator
arrows staying inside each induced carrier.

Caption: "Compactness is supplied by an order-derived bracket and then tested
under refinement and overlap."

## Analogy boundaries

**Useful analogy:** A Euclidean ring suggests why one might expect a fixed
distance band to be local.

**Where it breaks:** Lorentzian equal-proper-time sets are hyperboloids, not
compact spheres. A picture of a circular ring must not be used after this
point.

**Useful analogy:** The outer diamond acts like a camera frame revealing more
of an already extended object.

**Where it breaks:** The causal diamond is part of the finite sample and changes
which events exist; it is not merely a passive crop of one fixed realization.
The fixed-density ensemble comparison is statistical.

**Useful analogy:** A compact bracket resembles choosing a laboratory region.

**Where it breaks:** The bracket must be selected from causal order and counts,
not from coordinates, and no unique bracket is assumed. Averaging the complete
eligible ensemble is different from choosing one convenient laboratory box.

**Forbidden analogy:** Do not say the exact finite family proves that every
causal-set neighborhood has infinite valency. It proves arbitrary finite
cardinality for one precise abundance-conditioned shell predicate.

## Reader checks

A reader has understood the result if they can answer all four questions:

1. Why can a zero-event open interval fail to mean compact locality?
2. Which inputs were fixed while the A3c outer volume changed?
3. What does the exact theorem make arbitrarily large?
4. Why does the compact-bracket successor remain a hypothesis rather than a GR
   result?

The explanation fails its education gate if a reader concludes that Lorentz
invariance, four dimensions, a tetrad, curvature, or Einstein dynamics has
already been recovered.
