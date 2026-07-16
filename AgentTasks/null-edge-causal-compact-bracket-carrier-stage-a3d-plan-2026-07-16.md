# Stage A3d preregistration: compact count-balanced bracket carriers

## Status and claim boundary

**Status:** preregistered before implementation or execution  
**Work item:** `GRAV-LOCAL-CARRIER-001`  
**Claim grade if successful:** external finite control only; no G2 pass and no
continuum theorem

Stage A3c killed the global count-band shell as a locality construction. A
fixed interval-count band leaves a noncompact rapidity direction, so its
cardinality grows with the infrared diamond. Stage A3d tests one replacement:
compact Alexandrov brackets selected entirely from order and count data.

Coordinates may generate the oracle causal relation. After that, they are
forbidden for mark selection, endpoint selection, bracket scoring, carrier
construction, and support evaluation. They may be reopened only for the
post-selection coordinate-control pairing.

## Frozen bracket rule

Let `C(u,v)` be the inclusive interval count on a comparable pair: the open
interval cardinality plus one. For a marked event `x`, candidate endpoints
satisfy `p < x < q` and

```text
0.75 h <= C(p,x), C(x,q) <= 1.25 h,
h = (L / ell)^4.
```

For every candidate pair define the dimensionless excess

```text
E(p,x,q) = C(p,q) / (C(p,x)^(1/4) + C(x,q)^(1/4))^4.
```

In continuum four-volume scaling the denominator is the collinear minimum
volume for the two half intervals. Thus `E = 1` is the aligned limit and
larger `E` records relative endpoint rapidity without a frame or coordinates.

The tight ensemble requires `E <= 1.5`; the loose refinement ensemble requires
`E <= 2.0`. If an ensemble has more than 32 brackets, retain the 16 smallest
and 16 largest scores within its cap, together with every exact tie at either
cutoff. This score-stratified rule tests both the aligned core and the declared
compactness boundary. If fewer exist, retain all. No event label breaks a tie.
Each carrier is the open bracket

```text
A(p,q) = {z | p < z < q}.
```

The order, inclusive counts, three two-sided interiors, retarded shells, and
operator row are restricted to this induced finite order. No global interior
predicate is reused inside the bracket.

## Frozen ensemble and scales

- Baseline random events: `N = 1200`.
- Four-volume multipliers: `1, 2, 4`.
- Duration: `T_m = m^(1/4)` and events: `N_m = 1200 m`.
- Realizations: five at each multiplier.
- Seed: `2026071605`.
- Supplied operator scale: `L = 0.18`.
- Adjacent ratio: `r = 1.25`.
- Selector scales: the existing max-clearance triple
  `(sqrt(ell*L)/r, sqrt(ell*L), r*sqrt(ell*L))`.
- Interior band and abundance: `[0.5,2.0]` and `0.25 nu`.
- Retarded shell band: `[0.5,4.0]`.
- Marks: eight uniform RNG samples without replacement from the order-defined
  common three-scale interior in each realization, or all marks if fewer.
- Brackets: 16 smallest plus 16 largest scores per tight/loose ensemble when
  more than 32 exist, plus exact cutoff ties.

The primary unit of inference is a realization. Per-bracket pooling is always
reported but cannot pass a gate.

## Frozen gates

### Exact implementation gates

1. Inclusive sparse counts agree with the dense reference on a chain and a
   genuine partial order.
2. Induced interval counts on every bracket equal the corresponding global
   counts for pairs inside that bracket.
3. Relabeling maps the complete bracket ensemble and every carrier exactly.
4. Score-cutoff ties are retained without label-based truncation.
5. Coordinates are absent from every selector API.

Any failure kills the run before sprinkling.

### Availability and rank gates

At multiplier four, at least four of five realizations must have:

- at least 80% of sampled marks with eight or more tight brackets; and
- realization-median tight-bracket all-three-shell rank-capable rate at least
  `0.80`.

### Infrared-boundary gate

Between multipliers two and four:

- the absolute change in median realization-clustered rank-capable rate is at
  most `0.10`; and
- median tight-carrier cardinality changes by at most `15%`.

This is the direct test that compact brackets have replaced the global
diamond as the support cutoff.

### Refinement, overlap, and coordinate-control gates

At least 80% of multiplier-four qualifying marks must have a pair of tight
carriers with Jaccard overlap at least `0.25`. On qualifying marks:

- median metric disagreement across those overlap pairs is at most `0.25`;
- median tight-versus-loose metric disagreement is at most `0.25`;
- median post-selection coordinate-control metric error is at most `0.50`;
- at least 80% of tight brackets have signature `(1,3,0)`.

The coordinate control tests the carrier and operator normalization. It does
not supply an intrinsic probe basis and cannot close G2.

## Kill and next-decision rules

Kill this compact-bracket construction before any intrinsic eigensolver if an
exact gate fails, fewer than four multiplier-four realizations pass the
availability/rank requirements, the multiplier-two to multiplier-four drift
exceeds either bound, or overlap/refinement/coordinate controls fail.

Do not tune endpoint bands, rapidity caps, mark sampling, bracket cap, or any
threshold after the frozen output is visible. A failed run may motivate a new
mechanism only after a claim-graded report and independent review.

If every gate passes, the next stage may evaluate an intrinsic, basis-free
probe cluster separately inside each retained carrier and require its metric
to descend consistently on overlaps. Passing A3d alone is not permission to
claim a tetrad, spin structure, curvature, or continuum GR.
