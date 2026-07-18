# Stage A3e preregistration: nested outer regulator and inner causal germ

## Status and claim boundary

**Status:** preregistered before implementation or execution  
**Work item:** `GRAV-NESTED-GERM-001`  
**Claim grade if successful:** external finite support control only; no G2 pass,
continuum theorem, tetrad, curvature, or Einstein dynamics

Stage A3c killed the global fixed-count shell because its rapidity direction is
noncompact. Stage A3d then showed that a count-balanced compact bracket has
infrared-stable cardinality, but killed using that same bracket as both the
boundary regulator and the evaluation neighborhood. The mark was almost never
in the induced three-scale interior and every realization had zero clustered
rank-capable rate.

Stage A3e tests one genuinely different architecture. A large count-balanced
Alexandrov bracket is used only as an outer regulator. The unchanged adjacent-
scale source sets around the mark form the inner evaluation germ. Two frozen
outer-buffer rungs test whether that same germ is nonvacuous and stable before
any intrinsic eigensolver is permitted.

Coordinates may generate the oracle causal relation. After that they are
forbidden for mark sampling, endpoint selection, bracket scoring, carrier
construction, inner-germ construction, support evaluation, and nested-pair
matching. They may be reopened only after the support gate passes, for the
declared coordinate-control pairing.

## Frozen buffer derivation

Let `ell` be the supplied discreteness scale, `L` the supplied operator scale,
`r=1.25`, and

```text
s_max = r sqrt(ell L).
```

The unchanged retarded-shell upper count is `4 nu_max`, where
`nu_max=(s_max/ell)^4`. In continuum fourth-root volume scaling, the largest
admitted source separation is therefore `4^(1/4) s_max`. The smallest admitted
past-interior witness separation is `0.5^(1/4) s_max`. A collinear outer half
interval needs at least

```text
R_min = (4^(1/4) + 0.5^(1/4)) s_max
```

of proper-time clearance to make such a witness arithmetically possible. At the
frozen density used since A3b,

```text
ell = 0.10219728214404318
L = 0.18
s_max = 0.16953756398807948
R_min = 0.382325852132062
(R_min / L)^4 = 20.3537595771238.
```

The tight and refinement count-buffer ratios are frozen at

```text
B_tight = 24
B_refine = 32.
```

Thus both exceed the analytic minimum without changing the inner count bands.
The tight rung has outer proper-time target `L B_tight^(1/4) = 0.39840549`.
The refinement rung has target `L B_refine^(1/4) = 0.42811254`.

This clearance argument is necessary, not sufficient. It does not guarantee
the required two interior witnesses, a bracket, or a rank-four source set.
Those are the finite-order gates below.

## Frozen outer brackets

For `p < x < q`, let `a=C(p,x)`, `b=C(x,q)`, and `c=C(p,q)` use the same
inclusive interval-count convention as A3d. At buffer rung `B`, candidates obey

```text
0.75 B (L/ell)^4 <= a,b <= 1.25 B (L/ell)^4
```

and the unchanged count-volume rapidity-excess cap

```text
E(p,x,q) = c / (a^(1/4) + b^(1/4))^4 <= 1.5.
```

At `B=32`, retain the complete orbit attaining the minimum excess score among
all candidates. For each retained `B=32` bracket, restrict the `B=24`
candidates to genuine nested brackets

```text
p_32 < p_24 < x < q_24 < q_32
```

and retain the complete minimum-excess orbit in that restricted set. No event
label breaks a tie. The construction is undefined at a mark if either orbit is
empty. The outer carrier is the open Alexandrov interval `A(p,q)` with its
induced order. This sequential minimum-orbit rule is frozen in place of a
large score-stratified ensemble because induced interior evaluation on dozens
of 4,000--9,000-event carriers per mark would violate the resource ceiling.
The full exact tie orbit is never truncated; a realization that exceeds 64
retained orbit members at one mark is killed as a resource failure rather than
label-truncated.

For the refinement rung, the largest arithmetically admitted carrier has count

```text
1.5 * 16 * 1.25 * B_refine * (L/ell)^4
  = 9238.55116825395.
```

The frozen control diamond therefore uses `N=9600`, the first prior volume rung
strictly above that threshold. Its duration is `8^(1/4)` so density and `ell`
remain unchanged. This threshold only prevents a guaranteed arithmetic
overflow; it is not a probability-of-existence claim.

## Frozen inner germ

Inside each already-selected outer carrier, recompute the induced inclusive
counts and the unchanged A3b predicates at

```text
(sqrt(ell L)/r, sqrt(ell L), r sqrt(ell L)).
```

The interior band remains `[0.5,2]`, the abundance threshold remains
`0.25 nu`, the retarded-shell band remains `[0.5,4]`, and the minimum shell
count remains four. For a mark `x`, the inner germ is `x` together with its
three induced retarded source sets. A bracket is rank-capable exactly when `x`
is in all three induced interiors and every one of the three induced shells has
at least four sources.

The inner germ is not itself used as an outer carrier. No source is imported
from the global order after restriction. The implementation must assert once
per realization that induced interval counts agree with global counts on one
selected outer bracket. It must also expose a non-tautological source-closure
diagnostic: at each scale, first form every raw induced count-band shell
candidate and then report the fraction that survives the same-scale induced
source-interior predicate. A retained source is not counted in the denominator
only after it has already passed the predicate.

## Frozen ensemble and execution order

- Random events: `N=9600`.
- Duration: `8^(1/4)`.
- Realizations: five.
- Seed: `2026071606`.
- Marks: eight uniform samples without replacement from the global order-only
  common three-scale interior, or all marks if fewer.
- Randomness hygiene: sprinkling and mark sampling use separate spawned child
  seed streams.
- Outer buffers: `B=24` and `B=32`.
- Endpoint band, excess cap, complete minimum-score orbits, inner bands, and
  rank threshold are exactly those displayed above.
- Primary inference unit: realization. Pooled brackets are diagnostic only.

Execution is two-phase but all thresholds are frozen now. Phase 1 evaluates
only exact properties and order-side availability. Coordinate controls are
computed only if Phase 1 passes. An intrinsic eigensolver is forbidden in both
phases.

## Frozen exact gates

1. Dense and sparse inclusive counts agree on a chain and a branching order.
2. Every open outer carrier is order-convex, and induced interval counts equal
   global counts for every pair in a tested carrier.
3. Restricting further to any inner germ does not change the interval count of
   a comparable pair whose full interval lies in that germ.
4. Relabeling maps the complete two-rung minimum-score orbits, outer carriers,
   inner germs, and genuine nested-pair relation exactly.
5. Minimum-score ties are retained in full at both rungs.
6. Selector and matching APIs have no coordinate argument.
7. Sprinkling and mark selection consume distinct child seed streams.

Any exact failure kills the run before sprinkling.

## Frozen Phase 1 gates

At least four of five realizations must have:

- at least 80% of sampled marks with a nonempty `B=32` orbit and a nonempty
  genuinely nested `B=24` orbit;
- realization-median rank-capable bracket rate at least `0.80`; and
- realization-median retained-source closure rate at least `0.80`.

Every qualifying mark already has at least one genuine nested pair

```text
A(p_24,q_24) subset A(p_32,q_32)
```

and at least 80% must have one with carrier Jaccard overlap at least `0.40`.
Across matched nested pairs, the
median absolute disagreement of each of the three shell counts, normalized by
the larger count and clustered first by mark then realization, must be at most
`0.25`.

Every stability Boolean is explicitly false unless both compared rungs have a
positive rank-capable median and the required matched-pair denominator. Zero
versus zero is not a stability pass.

## Frozen Phase 2 controls

Phase 2 runs only if every Phase 1 gate passes. On the same archived selection:

- median nested-pair coordinate-metric disagreement is at most `0.25`;
- median post-selection coordinate-control metric error is at most `0.50`; and
- at least 80% of rank-capable brackets have signature `(1,3,0)`.

Coordinates cannot change membership, matching, or any order-side gate. These
controls do not supply an intrinsic basis and cannot close G2.

## Kill and next-decision rules

Kill this `B=24/32` nested-buffer construction if an exact gate fails, Phase 1
fails, a complete minimum orbit exceeds 64 members, or a reached Phase 2
control fails. Do not change the endpoint band, rapidity cap, minimum-orbit
rule, inner bands, minimum shell count, buffer ratios,
mark sampling, thresholds, or global volume after seeing output. Do not rescue
a failure by running a larger diamond, choosing capable marks, lowering a gate,
or launching an eigensolver.

If Phase 1 passes but Phase 2 fails, retain only the support-locality result and
kill the metric interpretation. If both phases pass, the next separately
preregistered stage may test global-volume stability of the same frozen nested
mechanism and only then construct an intrinsic basis-free probe cluster.
