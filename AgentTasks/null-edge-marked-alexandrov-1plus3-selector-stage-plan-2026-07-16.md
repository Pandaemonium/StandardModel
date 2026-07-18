# Preregistration draft: marked-Alexandrov shell-angular `1+3` selector

Date: 2026-07-16  
Work item: `GRAV-ORDER-OPERATOR-001`  
Status: design draft; no confirmatory seeds assigned or authorized  
Owner: Codex

## Decision question

Can a marked Alexandrov carrier select a local rank-four probe sector by
combining

```text
one order-derived radial/time line
+ one three-dimensional angular subspace on the null-edge shell
= one candidate local `1+3` sector,
```

with permutation equivariance, exact corrected-pairing `(+---)` inertia,
stable overlap transport, and held-out refinement persistence?

This replaces the held S1 top-spectrum run and the refuted one-mode-per-layer
shortcut. It does not ask one scalar operator spectrum to select four
undifferentiated modes.

## Why this architecture is different

For a marked evaluation event `x`, define the local interval-count layers

```text
L_n(x) = {y : y < x and |I(y,x)| = n}.
```

The project-sign local coefficient row gives signs

```text
L_0  L_1  L_2  L_3
 -    +    -    +
```

in the corrected weighted-difference form. Compressing one mode from each
layer therefore gives the exact split `(2,2)` obstruction proved in
`CorrectedPairingLayerCoherentNoGo.lean`.

The present proposal uses the layers asymmetrically:

- the spatial subspace lives entirely on `L_0(x)`, where the weight is one
  constant negative value;
- the time line is the projection of an intrinsic causal-depth field onto the
  positive radial shell space supported on `L_1(x) union L_3(x)`.

Distinct elements of `L_0(x)` are causally unrelated. If `y < z < x`, then
`z` lies in `I(y,x)`, contradicting `|I(y,x)| = 0`. Thus `L_0(x)` is an exact
order-defined antichain and a natural finite angular/null-edge shell.

If the three spatial modes are linearly independent, their corrected Gram
block is negative definite because it is a negative constant times their
Euclidean Gram matrix. The time line has positive corrected norm, and the
time-space cross terms vanish because the based-difference supports are
disjoint. The signature gate is therefore an algebraic consequence of the
selector construction. The scientific uncertainty is whether the selected
spatial subspace is stable, local, and continuum-meaningful.

## Inputs and forbidden data

### Allowed construction inputs

- a finite strict causal order;
- marked bottom and top endpoints of an outer Alexandrov interval;
- a marked evaluation event `x` in the protected core;
- interval counts and longest-chain depths;
- the raw finite causal-overlap ratio;
- a preregistered count-derived mesoscopic schedule;
- the project-local coefficient row and corrected pairing.

### Forbidden during selection

- embedding coordinates;
- target Minkowski metric or target tetrad;
- continuum proper time or spatial distance;
- oracle spacetime dimension, except in a separately labeled conditional
  comparator;
- label-based tie breaking;
- post-run tuning of shell, kernel, rank, or gap thresholds.

Coordinates and the target metric may be opened only after selection to score
affine recovery and subspace alignment.

## Candidate family and evaluation events

Use the existing protected-core carrier family and count-derived balanced
schedule. For each outer marked interval, evaluate every order-admissible
central event up to a frozen ceiling, rather than selecting a unique spatial
origin by labels.

An evaluation event is admissible when:

1. it is in the protected core;
2. both endpoint chain depths exceed the frozen depth floor;
3. `L_0(x)` has enough events to support a three-dimensional nonconstant
   subspace plus one excluded control mode;
4. at least one of `L_1(x)` and `L_3(x)` is nonempty;
5. the overlap graph below is connected after the frozen affinity rule.

Ties in any order statistic are retained as a set. If a resource ceiling
requires a strict subset and the boundary is tied, the cell is
`INADMISSIBLE`; labels never break the tie.

## Time line

For each carrier event `y`, let

```text
tau_raw(y) = chainDepth(bottom,y) - chainDepth(y,top).
```

Center this field on the carrier. Restrict its based-difference coordinates at
`x` to `L_1(x) union L_3(x)`, the positive local layers, and set every other
based-difference coordinate to zero. Euclidean-normalize the resulting
zero-sum lift. Call the line `T_x`.

The line is inadmissible if this projection vanishes. Its sign is oriented by
positive correlation with `tau_raw`; the marked endpoints therefore supply
the future convention. This is an order-derived positive radial line, not yet
a theorem that `T_x` converges to continuum proper time.

Required diagnostics:

- corrected norm is positive;
- endpoint/depth orientation is nonzero and relabeling invariant;
- held-out oracle correlation with continuum `t` is recorded;
- support fractions on `L_1` and `L_3` are archived, so coefficient sorting is
  visible rather than hidden.

## Spatial shell graph

Let `S_x = L_0(x)`. For distinct `a,b in S_x`, use the outer marked bottom as
a common-past anchor and compute the finite causal overlap

```text
O_bottom(a,b)
  = |I(bottom,a) intersect I(bottom,b)|
    / min(|I(bottom,a)|, |I(bottom,b)|).
```

This ratio is order/count intrinsic, symmetric, bounded in `[0,1]`, and
relabeling invariant. It is used only as a dimensionless affinity input. The
experiment does not convert it to physical distance and therefore does not
claim to have derived dimension, proper time, or absolute scale.

Set

```text
delta(a,b) = -log(max(O_bottom(a,b), epsilon_floor)).
K(a,b) = exp(-(delta(a,b)/sigma)^2)
```

for unrelated distinct shell events, with zero diagonal. Freeze
`epsilon_floor` numerically and choose `sigma` from a preregistered quantile of
the nonzero `delta` multiset. Quantile ties are included. Form the symmetric
normalized graph Laplacian

```text
L_sym = I - D^(-1/2) K D^(-1/2).
```

The primary spatial output is the projector onto the first three nonconstant
modes, not three individually named eigenvectors. Internal `O(3)` basis
rotations are gauge. Require a gap between this three-dimensional cluster and
the next mode; do not require gaps inside the triplet.

Lift any orthonormal basis of this subspace to carrier based-difference fields
supported only on `L_0(x)`. The resulting rank-three carrier subspace is basis
independent.

## Exact algebraic tripwires

These are implementation gates, not empirical physics gates.

1. `L_0(x)` is an antichain.
2. The time based-difference support is contained in `L_1 union L_3`.
3. The spatial based-difference support is contained in `L_0`.
4. The time-space corrected cross block is zero to construction tolerance and
   symbolically zero in the clean finite model.
5. The time corrected norm is positive.
6. The spatial corrected Gram block is negative definite and has rank three.
7. The full corrected Gram has signature `(1 positive, 3 negative, 0 zero)`.
8. Event relabeling preserves the time line and spatial projector after
   pullback.
9. Replaying every cell from recorded RNG states reproduces all summary
   quantities.

Any violation is `INADMISSIBLE`, not evidence against the physical selector.

## Scientific gates

The development phase sets resource envelopes only. A later frozen held-out
phase should require all of the following with thresholds fixed before seeds
are named:

1. **Availability:** an admissible `1+3` sector exists on a frozen fraction of
   protected-core evaluation events at every density.
2. **Triplet isolation:** the relative gap after the third nonconstant shell
   mode exceeds the frozen floor while no internal triplet split is required.
3. **Oracle spatial alignment:** after selection, principal-angle distance to
   the three-dimensional oracle spatial-coordinate subspace decreases with
   density. Score subspaces, not individual axes.
4. **Time alignment:** the intrinsic time line has positive and improving
   correlation with the oracle local time coordinate.
5. **Affine rank:** the combined four probes have local oracle Jacobian rank
   four, with frozen fit and condition-number ceilings.
6. **Refinement persistence:** on nested or coupled refinements, the pulled-back
   time line and spatial projector converge on the common protected core.
7. **Overlap transport:** neighboring marked carriers have full-rank common
   restrictions; spatial Procrustes transitions have decreasing residuals,
   and triangle cocycle residuals decrease with density.
8. **Ensemble isotropy:** oracle spatial orientation is isotropic across the
   ensemble after quotienting by internal `O(3)` gauge.

The same mesoscopic schedule must pass availability, alignment, refinement,
and overlap gates. A schedule tuned separately for each diagnostic fails.

## Comparators and negative controls

### Comparators

1. Coordinate-oracle time plus spatial coordinates, evaluation only.
2. Existing causal-profile PCA selector.
3. Existing Johnston lightcone/atlas selector, with its supplied dimension and
   density debt displayed.
4. A heat-kernel landmark feature subspace on the same shell graph. This is a
   theorem-aligned diagnostic because Riemannian heat-kernel coordinate
   results use suitably selected features; it is not assumed that the first
   three eigenvectors are always coordinates.

### Negative controls

1. Degree-preserving edge rewiring of the shell affinity graph. Simple vertex
   permutation is forbidden as a null because it is isospectral.
2. Layer-coherent four-mode sector, whose exact `(2,2)` sign obstruction is
   already kernel-checked.
3. Removal of the marked bottom anchor, replacing it by a fully unmarked
   all-common-pasts construction. No stable finite frame is expected in the
   full homogeneous-sprinkling limit.
4. Randomly rotated spatial bases with the projector fixed. Any diagnostic
   that changes under this control is basis-dependent and invalid.
5. Density-shuffled overlap weights that preserve the shell cardinality but
   destroy pair geometry.

## Lorentz-invariance boundary

Bombelli, Henson, and Sorkin prove that a full Minkowski Poisson sprinkling
admits no measurable Lorentz-equivariant map to one direction, a finite set of
directions, a finite frame, or a finite-valency graph. The present selector
does not evade that theorem by word choice. It is explicitly relative to
marked finite Alexandrov data: outer endpoints, a protected core, an
evaluation event, and a boundary common-past anchor. Finite regions may carry
directional information through their boundaries.

Therefore:

- the finite marked selector may define a gauge frame on one carrier;
- removing the marked data is a required negative control;
- continuum Lorentz recovery must be stated as covariance of the ensemble and
  compatibility of overlap gauge transformations, not exact symmetry of one
  finite realization;
- no bare homogeneous sprinkling is claimed to canonically supply a tetrad.

## Source boundary

1. Boguna and Krioukov, arXiv:2401.17376, provide the causal-overlap spatial
   distance construction and continuum scaling in their stated Minkowski
   setting. This stage imports only the raw overlap ratio as an affinity. Their
   physical distance conversion still requires dimension and proper-time or
   scale input.
2. Boguna and Krioukov, arXiv:2506.18745, use causal-overlap neighborhoods in a
   local causal-set d'Alembertian and prove an analytic Minkowski convergence
   statement under displayed scaling assumptions. Their numerical evidence is
   lower-dimensional and does not prove this shell projector converges.
3. Jones, Maggioni, and Schul, arXiv:0709.1975, prove local coordinate results
   for suitably chosen heat kernels or Laplacian eigenfunctions on Riemannian
   spaces. This is motivation for a spatial comparator only. It is not a
   Lorentzian theorem and does not guarantee that the first three shell modes
   are coordinates.
4. Singer and Wu, arXiv:1306.1587, prove spectral convergence for connection
   Laplacians from random samples in a Riemannian setting. Their results guide
   later overlap-transport diagnostics but do not transfer automatically to
   this indefinite reconstructed geometry.
5. Bombelli, Henson, and Sorkin, arXiv:gr-qc/0605006, supply the no-preferred-
   direction/frame boundary and the finite-region boundary caveat.

The Jones-Maggioni-Schul paper was added to the null-edge Zotero/Neo4j corpus
as key `JTCP5BN6` and full-text indexed in 17 chunks on 2026-07-16.

## Lean-first subgates

Before any frozen run:

1. prove `L_0(x)` is an antichain for every finite strict causal order;
2. define the shell-support and positive-radial-support subspaces;
3. prove disjoint support makes the corrected cross block zero;
4. prove constant negative `L_0` weight makes every independent spatial
   triple negative definite;
5. package the conditional shell-angular sector as a
   `RankFourCarrierProbeSector` with `HasLorentzianInertia` under explicit
   availability and rank hypotheses;
6. prove relabeling equivariance of the layer sets and support subspaces.

Only after those exact gates and a hostile implementation review should fresh
development seeds be assigned. Confirmatory seeds remain unnamed.

## Implementation status at 2026-07-16 23:45 PDT

The exact finite order/sign gates are now landed in
`PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellWeights.lean` and
`PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellInertia.lean`. They prove the
layer-zero antichain and relabeling law, shell/radial disjointness, project-row
signs, conditional positive-time/negative-space split, and normalization of a
supplied orthogonal selected frame to the exact project Minkowski matrix.

`Scripts/experiments/causal_marked_shell_selector.py` now implements the
deterministic construction tripwires without opening coordinates or assigning
random seeds:

- interval-count shell and positive-radial layers;
- longest-chain depth-asymmetry time projection;
- marked-bottom common-past overlap matrix and frozen-form affinity;
- first three nonconstant shell modes as a basis-independent projector;
- exact-support corrected Gram and numerical `(1,0,3)` inertia audit;
- fail-closed shell-size, constant-mode, triplet-gap, and cross-block checks.

`test_causal_marked_shell_selector.py` supplies four deterministic
synthetic-poset tests, including full projector equivariance under relabeling.
All pass. This is an implementation control only: the synthetic witness does
not count toward availability, oracle alignment, refinement, overlap
transport, or continuum gates. No development or confirmatory seed has been
named or consumed. The hostile review requested in
`msg-20260716-205541-f7194375` remains blocking before any seeded run.

## Kill condition and pivot

Kill the shell-angular selector if no single count-derived schedule yields a
stable three-dimensional shell projector with improving oracle alignment,
refinement persistence, and overlap transport, or if availability vanishes
with density. Do not rescue it by opening coordinates, changing rank, or
tuning per diagnostic.

The honest pivot is a decorated tetrad/spin-frame on the causal carrier. The
program would then retain exact corrected-pairing algebra, overlap gauge
transport, and matter propagation while stating that bare order plus marked
boundaries does not derive the local frame.

## Claim boundary

This document preregisters a candidate mechanism and exact subgates. It proves
no continuum tetrad, Lorentz invariance, curvature, Einstein equation, or
general relativity. The Higgs/matter sector remains downstream: a Higgs vacuum
is vertex-local internal data, its kinetic variation is edge-supported, and it
can source gravity only after variation with respect to a successfully
reconstructed or supplied frame.
