# Null-edge carrier probe overlap-transition gate

Date: 2026-07-16

Work item: `GRAV-GROWING-ATLAS-001`

Status: kernel-checked; physical overlap hypotheses open

## Finite bridge

For two marked Alexandrov carriers `A` and `B`, define their overlap as the
ambient events lying in both closed carriers. A selected rank-four probe sector
on either chart restricts to a scalar field on this common finite event type.

The pair transition is derivable with no frame choice when:

1. the left restriction is injective;
2. the right restriction is injective;
3. the two restriction maps have the same image.

The resulting linear equivalence is unique and preserves every overlap
observation. This is the correct basis-free precursor of a local coframe
transition.

Equal observation images alone do not make the transition Lorentzian. The
module therefore displays a second, separate hypothesis: both local corrected
pairings must be pullbacks of one bilinear form on the overlap observation
space. Under that metric-gluing condition, the transition is an exact
isometry, its pushforward preserves the selected-sector Gram matrix, and
Lorentzian inertia propagates from one verified chart to its neighbor.

If both charts then choose Lorentz-normalized frames, the matrix comparing the
transported source frame with the target frame is exactly `eta`-orthogonal.
This reaches `O(1,3)` at the finite matrix-identity level. Determinant sign and
time orientation remain explicit gates before restricting to `SO^+(1,3)`;
only after that restriction is it appropriate to connect these transitions to
the existing `SL(2,C)` spin-lift obstruction layer.

The determinant theorem makes the first split exact: every such transition has
determinant `+1` or `-1`, but the metric identity does not choose between them.
The proper-component gate is therefore genuine rather than a notational
repackaging.

## Triple-overlap gate

Pairwise equal-image conditions alone do not automatically establish a Cech
cocycle when the three pair overlaps are different observation spaces. The
additional finite condition used here is sharp and inspectable: the common
triple overlap must separate the target rank-four sector.

Under that condition, equality can be checked by restricting both composites
to the triple overlap. Pairwise transition specifications reduce both sides to
the same source probe values, and target injectivity reflects equality back to
the sector. Therefore

```text
T_BD o T_AB = T_AD.
```

The same separation hypothesis forces the triple overlap to contain at least
four events. This is a concrete nerve-density obstruction: a combinatorial
triangle with fewer than four common events cannot support this scalar-probe
gluing mechanism.

## Relation to curvature

The exact transition cocycle is bundle-gluing data, not curvature. Curvature
must enter through a separately derived connection whose loop transport may be
nontrivial. A Bargmann or spiral phase may contribute to connection holonomy;
it must not be represented as failure of the chart transition cocycle.

## Next empirical observables

Once a candidate four-mode projector is available on the R4 atlas, measure for
every retained pair and triangle:

1. minimum singular value of each sector-to-overlap restriction;
2. principal-angle distance between the two pairwise restriction images;
3. condition number of the induced transition;
4. target-sector minimum singular value on every triple overlap;
5. norm of the finite cocycle defect after composing measured transitions.

The comparison must include randomized rank-four sectors and label-dependent
mode selections. A graph-native selector should outperform both on nested
stability and overlap image agreement.

## Claim boundary

- Conditional pair transition and triple cocycle: finite `M` statements.
- Existence of sectors satisfying the overlap hypotheses: open.
- Lorentz reduction of the transition class: conditional on stable Lorentzian
  inertia of the selected-sector pairing.
- Spin lift, connection, curvature convergence, and Einstein dynamics: closed.

## Verification record

- Module SHA-256:
  `057e040545ed76a89e1710e94de52de8b2699de6989e08081fb683149177f6cf`.
- `lake env lean PhysicsSM/Draft/NullEdge/CarrierProbeOverlapTransition.lean`
  passed with no diagnostics.
- `lake build PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition` passed
  (`8039` jobs), rebuilding both selected-sector dependencies.
- Build-enforced guards report only `propext`, `Classical.choice`, and
  `Quot.sound` for pair-transition specification, Lorentzian-inertia
  propagation, the triple-separation Cech cocycle, and the four-event
  triple-overlap bound.
