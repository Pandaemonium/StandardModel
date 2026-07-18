# Null-edge atlas nerve and transition framework

Date: 2026-07-16
Status: architecture and preregistration input; no downstream gate is opened

## Central proposal

The next geometric object should be a growing, order-equivariant atlas nerve,
not a canonically selected tetrad. Protected Alexandrov cores provide chart
domains. Their nonempty intersections provide nerve simplices. Only after that
finite topology is stable should the program ask whether overlap comparisons
are compressible into bounded-dimensional transition data.

This yields the sequence

```text
bare causal order
  -> complete count-band interval family
  -> equivariant growing protected-core atlas
  -> overlap nerve
  -> finite-dimensional transition cocycle
  -> local Lorentz gauge class
  -> spin lift and connection transport
  -> area-normalized holonomy curvature
  -> continuum comparison
```

Every arrow is a separate gate. R4 measures the first growing-atlas arrow but
does not pass it: all 216 constrained selectors terminate exactly at their
multiplicity cap in a selected-family full-intersection regime. R4-D then
certifies the complete-family common event at beta `0.80`, a mixed apex/hub
regime at beta `1.00`, and empty intersections with strong hubs at beta `1.25`.
Fresh-seed R5 confirms the beta-`1.25` diagnosis and unlocks growth past the cap,
reaching `17-19` of `21` charts at cap `12`, but every paired control also
shortfalls. R5 is therefore correctly `INADMISSIBLE`; no later arrow is opened.

## Three layers that must remain distinct

### 1. Atlas topology

For selected protected cores `C_i`, define a nerve simplex by genuine common
intersection:

```text
{i_0,...,i_p} is a simplex iff there is an event x in every C_i.
```

The empirical growing-atlas gate should measure at least:

- bulk union coverage;
- nerve connectivity;
- maximum and upper-quantile chart multiplicity at an event;
- repeated coverage of bulk events;
- counts of occupied edges, triangles, and higher simplices;
- relabeling invariance of all observables.

Connectivity without bounded multiplicity is not enough. Coverage without
occupied triangles cannot support a local cocycle or curvature comparison.

### 2. Bundle gluing

Let `T_ij` compare two local representatives on an occupied overlap. Valid
transition functions obey

```text
T_ii = 1,
T_ij T_ji = 1,
T_ij T_jk = T_ik
```

on the corresponding occupied overlaps. A chart gauge `h_i` acts by

```text
T_ij -> h_i^(-1) T_ij h_j.
```

The cocycle survives this action. In particular, the transition product around
an occupied triangle is exactly trivial. A nontrivial triangular phase is
therefore not evidence that the bundle cocycle carries curvature; it is either
transition-estimation error or data belonging to a connection.

The graph-facing reconstruction question is whether overlap comparisons can be
represented by a fixed finite-dimensional group as density grows. A useful
kill condition is divergence of the number of parameters or held-out overlap
error at fixed physical scale.

### 3. Connection and curvature

Connection transports `U_ij` live on nerve edges but need not satisfy the Cech
cocycle. Their open-path product transforms only at its endpoints. A closed
loop transforms by conjugation at its base chart, so traces, characters, and
abelian phases are gauge invariant.

This is the proper home for the spiral-layer corner calculus. The Bargmann
triangle phase and its polygon decomposition are candidates for spin-connection
holonomy on nerve loops. They are not chart transition functions and do not by
themselves derive a tetrad or curvature tensor.

## Tetrad and spin reconstruction after transitions

The operator lane already identifies the correct conditional statement: a
rank-four carrier probe space with Lorentzian corrected pairing determines a
Lorentz gauge class of normalized frames, not a preferred frame. On an atlas,
the overlap task should therefore be:

1. reconstruct a basis-free Lorentzian form on each chart;
2. compare restrictions on overlaps without selecting canonical frames;
3. show that normalized representatives differ by a proper, time-oriented
   Lorentz transition plus the separately reconstructed Weyl scale;
4. verify the Cech cocycle on occupied triples;
5. compute the central sign obstruction to a spin lift;
6. only after a spin lift exists, attach connection transports and test loop
   holonomy.

The relative-count scale is a Weyl channel. It multiplies tetrads with weight
one, metrics with weight two, and area-normalized curvature with weight minus
two. Lorentz gauge and Weyl scale should not be merged into one unexplained
fit.

## What spirals can add

Spirals are useful at the connection layer. A sequence of changing null or
spin directions can accumulate a geometric phase even when each primitive
step is null. The exact Bargmann identities now provide a finite composition
law and a solid-angle dictionary for such phases. This makes a chiral spiral a
candidate microscopic representative of spin transport and corner curvature.

Spirals do not replace the zig-zag mechanism for timelike coarse displacement.
Direction reversal/mixing controls the timelike norm and hence the kinematic
mass/proper-time channel. Spiral ordering can add chirality and holonomy to
that motion. The current defensible breakdown is therefore qualitative:

- zig-zag or direction mixing: timelike coarse displacement and Dirac mass
  channel;
- spiral orientation: spin phase, chirality, and possible connection holonomy;
- no established quantitative fraction of physical mass belongs to either
  channel.

## Why the atlas size scales as `N^(1/4)`

The growing-cardinality exponent is now constrained from both sides under
explicit finite hypotheses. If each core has at most `B_N` events, covering a
target proportional to `N` requires

```text
K_N B_N >= target.
```

For `B_N=O(N^(3/4))`, this gives `K_N=Omega(N^(1/4))`. Conversely, if every
selected core has at least `b_N` events and eventwise atlas multiplicity is
bounded by a fixed `m`, double counting chart-event incidences gives

```text
K_N b_N <= m N.
```

For `b_N=Omega(N^(3/4))`, this gives `K_N=O(N^(1/4))`. The kernel-checked
`ProtectedCoreAtlasNerve.growingAtlas_cardinality_sandwich` packages both
finite inequalities. Thus two-sided core-size control plus nonvanishing
coverage and bounded multiplicity pin the only compatible schedule to
`K_N=Theta(N^(1/4))`. The theorem does not prove that such an atlas exists;
R4 is designed precisely to test that existence question.

## Falsifiable gate ladder

| Gate | Required result | Kill condition |
|---|---|---|
| Atlas | Growing `K_N` atlas with stable coverage | Held-out coverage or resources fail |
| Nerve | Connected, bounded-multiplicity overlap complex | Fragmentation, divergent multiplicity, or no triangle abundance |
| Transition | Fixed-dimensional equivariant overlap model | Parameter count or held-out error grows without bound |
| Lorentz | Basis-free rank four and `(+---)` inertia | Rank/signature fails to concentrate |
| Cech | Proper, time-oriented transitions with triple cocycle | Cocycle residual does not shrink |
| Spin | Consistent double-cover lift | Persistent central sign obstruction |
| Connection | Gauge-covariant edge transport with loop observables | Observable depends on chart gauge |
| Curvature | Holonomy divided by reconstructed area converges | Shape/scale dependence or disagreement with operator curvature |

Passing this ladder would still leave stress-energy and Einstein dynamics open.
It would, however, replace a postulated tetrad with a precise gauge-relative
reconstruction program and give chiral spirals one mathematically correct role.

## Claim ledger

- Exact transition/connection algebra: `M [orig/comp]`; the focused Aristotle
  result is integrated with build-enforced axiom guards in
  `AtlasTransitionHolonomy.lean`.
- Actual protected-core pair transition: `M [orig/comp]`; on the literal
  `coreAt` overlap used by the active atlas, a supplied shared idempotent
  projector, two intertwining squares, shared-range liftability, and explicit
  restricted injectivity derive equal selected images and hence a unique
  basis-free rank-four transition. Equal images are not assumed. Any overlap
  with fewer than four events fails the injectivity gate exactly. The graph
  still owes all projectors, their gap/rank, liftability, Lorentzian inertia,
  and refinement compatibility.
- Growing-atlas and nerve scaling: R4 measured an audited complete-nerve cap
  wall. R4-D certificates a true complete-family apex at beta `0.80`, a mixed
  apex/near-apex regime at beta `1.00`, and empty global intersections but
  strong hubs at beta `1.25`. R5 confirms the beta-`1.25` facts on fresh seeds
  and turns the cap wall into a `2-4` chart margin at `N=12000`, but all 18
  result cells remain inadmissible because every comparator shortfalls. The
  frozen R5 architecture and the empty-certificate-suffices hypothesis are
  ruled out; atlas existence remains open under a redesigned family, growth
  law, or fractional-dual route.
- Lorentz/tetrad reconstruction: conditional on the operator signature and
  overlap gates.
- Spiral holonomy interpretation: `C [interp]`, with the curvature convergence
  and gauge-independence gates displayed above.
- Continuum GR, physical sources, and Einstein dynamics: open.
