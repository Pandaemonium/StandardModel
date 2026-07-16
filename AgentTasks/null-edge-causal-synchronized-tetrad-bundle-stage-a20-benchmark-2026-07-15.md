# Null-edge synchronized tetrad-bundle Stage A20 benchmark

Date: 2026-07-15

## Question

Can three overlapping A17 coordinate patches support jointly fitted metrics
that preserve count-derived interval geometry while improving tensor covariance
enough to form a stable conditional tetrad bundle?

## Construction and scope

`Scripts/experiments/causal_synchronized_tetrad_bundle.py` extends each A17
patch record with its frozen interval train/holdout split, anchor scale, and
transported-chart metric prior. Candidate patches must pass coordinate-quality
and carrier-size controls, but they are not required to pass the old independent
metric gate before synchronization.

The original A17 holdout is divided equally into selector and untouched test
subsets for both causal intervals and unrelated pairs. Overlap events retain
A19's independent 60% transition-fit, 20% selector-validation, and 20%
untouched-test split.

For a triple with row-coordinate transitions

```text
z_j = z_i A_ij + b_ij,
```

the joint quadratic objective has the schematic form

```text
sum_i localIntervalLoss_i(g_i)
  + lambda sum_ij ||g_i - A_ij g_j A_ij^T||^2 / s_ij^2.
```

Each local term is exactly the dimensionless A17 training normal equation,
including its frozen metric ridge `0.1`; `s_ij` is a pre-synchronization metric
scale. The solve retains independent metrics in each coordinate gauge rather
than averaging their components. Every Lorentzian result is factored as
`g_i = e_i eta e_i^T`, and the induced internal transitions are audited for
Lorentz defect, cocycle residual, and proper/time-orientation sign gauges.

Triple selection may use only transition-fit/selector data, local training and
selector constraints, covariance, cocycles, and orientability. Unit tests
verify that changing either untouched test score cannot affect selection.
Sprinkling coordinates enter only in post-selection oracle controls.

Dimension, density, endpoints, scale, and the transported Minkowski prior remain
supplied. The transitions and cocycles are approximate, so no exact central
`Z2` obstruction class is computed.

## Development

Artifact:
`AgentTasks/causal-synchronized-tetrad-bundle-stage-a20-development-n4000-2026-07-15.json`

Five `N=4000` realizations use seed `20260860`. Synchronization weights
`0`, `0.01`, `0.1`, `1`, `10`, and `100` are compared on identical
realizations. Weight `0.1` is frozen by maximizing spin-prerequisite,
metric-bundle, and selector pass counts, then minimizing untouched interval,
covariance, and transition medians.

At the selected weight, four of five realizations pass every final bundle and
spin-prerequisite gate. Development medians are:

- constructed and coordinate-eligible patches: `8`, `6`
- minimum pair and triple overlaps: `204`, `204`
- selector and untouched transition errors: `0.207`, `0.203`
- selector and untouched interval errors: `0.101`, `0.124`
- pre/post-synchronization metric-covariance errors: `0.346`, `0.235`
- Lorentz defect: `0.244`
- affine and Lorentz cocycle residuals: `0.105`, `0.112`
- maximum metric adjustment: `0.065`
- joint normal condition: `78.0`

All selected synchronized metrics retain `(1,3,0)` inertia and every triple
admits a proper/time-oriented coframe sign gauge. The failed realization also
fails selector transition, cocycle, Lorentz, and causal-sign controls; it is not
repaired by changing only the synchronization weight.

## Held-out test

Artifact:
`AgentTasks/causal-synchronized-tetrad-bundle-stage-a20-heldout-n4000-2026-07-15.json`

Three fresh `N=4000` realizations use seed `20260870` and the frozen weight
`0.1`. No construction rule or threshold changes after development. All three
pass selector, untouched local-metric, untouched transition, metric-bundle,
orientation, and spin-prerequisite gates.

Held-out medians are:

- constructed and coordinate-eligible patches: `11`, `11`
- minimum pair and triple overlaps: `158`, `147`
- selector and untouched transition errors: `0.144`, `0.153`
- selector and untouched interval errors: `0.088`, `0.095`
- selector and untouched unrelated-pair violations: `0.075`, `0.068`
- minimum selector and untouched causal-sign fractions: `1.000`, `0.994`
- pre/post-synchronization metric-covariance errors: `0.366`, `0.280`
- Lorentz defect: `0.297`
- affine and Lorentz cocycle residuals: `0.051`, `0.071`
- maximum metric adjustment: `0.106`
- joint normal condition: `68.6`

Every selected metric has Lorentzian inertia and factors to roundoff. The
post-selection oracle medians are affine-map error `0.253`, patch-coordinate
error `0.522`, and synchronized-metric error `0.448`.

The weakest passing realization has Lorentz defect `0.346` against the frozen
`0.35` threshold. The result is therefore positive but not yet a wide-margin
convergence statement.

## Verdict

**Retain joint local metric synchronization as a successful conditional
bundle bridge.** Unlike A18 overlap maximization and A19 compatibility-only
selection, A20 changes the metric estimates through a single objective that
preserves local count-interval evidence. It passes every frozen held-out gate
in all three realizations and materially reduces overlap covariance error.

**Do not call this a graph-derived tetrad or spin structure.** Lorentzian
dimension and signature are stabilized by the transported chart prior, and
absolute scale uses supplied density. Pairwise affine transitions and internal
Lorentz maps still have nonzero cocycle residuals. The exact spin-obstruction
interfaces therefore remain unopened.

The next conditional-atlas test should synchronize all patch coordinate gauges
to one global affine atlas. Defining pair transitions from those global gauges
would make affine cocycles exact; pulling one jointly fitted metric back into
each chart would make covariance exact by construction. Local untouched
interval and transition tests must then verify that this exact bundle is not
merely algebraic. Only after that gate should proper-orthochronous transitions
be lifted and the exact finite `Z2` obstruction evaluated.

The primary bare-graph G2 target remains stable probe-covariant metric
reconstruction from the corrected causal operator.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_synchronized_tetrad_bundle.py`
- full causal experiment suite: `103 passed`
- `python -m ruff check Scripts/experiments/causal_synchronized_tetrad_bundle.py Scripts/experiments/test_causal_synchronized_tetrad_bundle.py Scripts/experiments/causal_tetrad_bundle_atlas.py`
- Development and held-out seeds, selected pivots, splits, residuals, and gates
  are retained in the JSON artifacts.

## Formal interfaces

- `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean`
- `PhysicsSM/Draft/NullEdge/GraphSpinLiftCocycle.lean`
- `PhysicsSM/Draft/NullEdge/FiniteSpinCochainObstruction.lean`
- `PhysicsSM/Draft/NullEdge/SpinLiftDefectFromTransport.lean`
