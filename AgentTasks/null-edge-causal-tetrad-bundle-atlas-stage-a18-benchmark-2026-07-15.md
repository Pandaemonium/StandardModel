# Null-edge tetrad-bundle atlas Stage A18 benchmark

Date: 2026-07-15

## Question

Do several independently reconstructed A17 metric/coframe patches form a
compatible local tetrad bundle, with affine transition cocycles, covariant
metrics, Lorentz coframe transitions, and the prerequisites for a spin lift?

## Construction and scope

`Scripts/experiments/causal_tetrad_bundle_atlas.py` starts from one deep
order-derived root chart and considers the 12 nearest events having at least
20 strict predecessors and successors. At every viable center it independently
reruns the A16 anchor selector and the A17 shared-coordinate, metric-regression,
and coframe-factorization pipeline with frozen metric ridge `0.1`.

For each candidate patch radius `0.30`, `0.35`, or `0.40`, it selects three
patches by:

1. number of patches passing the intrinsic A17 patch gate;
2. common triple-overlap cardinality;
3. minimum and total pairwise overlap; and
4. proximity to the deep root.

No transition, metric-covariance, coframe, or oracle score enters that
selection. Seventy percent of each pairwise overlap fits an affine transition;
the other 30% scores it. For a row-coordinate transition

```text
z_j = z_i A_ij + b_ij,
```

metric covariance requires

```text
g_i = A_ij g_j A_ij^T.
```

Writing `g_i = e_i eta e_i^T`, the induced internal map is

```text
L_ij = e_i^{-1} A_ij e_j.
```

The audit measures `L_ij eta L_ij^T - eta`, affine and internal cocycle
residuals, and searches all diagonal coframe sign gauges for transitions with
positive determinant and positive time component.

The overlap gate requires three intrinsic A17 passes, minimum pair overlap 30,
and triple overlap 15. Transition errors and cocycles must be at most `0.25`,
transition-design condition at most `50`, and metric/Lorentz defects at most
`0.35`.

This is only a spin-prerequisite test. The fitted transitions are approximate,
so the script does not invent an exact central `Z2` face defect or claim a
finite spin-obstruction class. Dimension, density, endpoints, scale, and the
chart-transported Lorentz prior remain supplied.

## Development

Artifact:
`AgentTasks/causal-tetrad-bundle-atlas-stage-a18-development-n2500-2026-07-15.json`

Five `N=2500` realizations use seed `20260830`. All radii have zero transition,
metric-bundle, and spin-prerequisite passes. Radius `0.40` is frozen because it
has the largest overlap after the tied failed gates.

At radius `0.40`, development medians are:

- constructed patches: `7`
- intrinsic patch passes: `2`
- minimum pair overlap: `171`
- triple overlap: `150`
- maximum held-out affine transition error: `0.312`
- maximum metric-covariance error: `0.756`
- maximum Lorentz defect: `1.026`
- affine and Lorentz cocycle residuals: `0.193`, `0.456`
- orientation/time-orientation success: `60%`
- overlap gate success: `20%`

Thus finite-density patch availability, not overlap cardinality, is the first
development limitation; even selected triples with large overlap can have
incompatible fitted metrics.

## Held-out test

Artifact:
`AgentTasks/causal-tetrad-bundle-atlas-stage-a18-heldout-n4000-2026-07-15.json`

Three fresh `N=4000` realizations use seed `20260835` and frozen radius `0.40`.
Patch construction and overlap improve sharply:

- median constructed patches: `11`
- median intrinsic patch passes: `7`
- median minimum pair overlap: `268`
- median triple overlap: `255`
- overlap gate success: `100%`
- orientation/time-orientation sign-gauge success: `100%`

Transition and bundle controls are mixed:

- median maximum affine transition error: `0.174`
- median maximum transition-design condition: `17.3`
- median maximum metric-covariance error: `0.714`
- median maximum Lorentz defect: `0.573`
- median affine cocycle residual: `0.095`
- median Lorentz cocycle residual: `0.104`
- transition gate success: `2/3`
- metric-bundle gate success: `1/3`
- spin-prerequisite gate success: `1/3`

The fully passing realization has minimum pair overlap `364`, triple overlap
`343`, maximum affine error `0.167`, metric error `0.312`, Lorentz defect
`0.322`, and cocycle residuals `0.095` and `0.104`. The other realizations fail
metric covariance at `0.714` and `0.753`; one also fails affine transition and
cocycle thresholds.

Post-selection oracle medians remain recognizable but do not repair the
intrinsic failures: maximum affine-map error is `0.593`, maximum selected-patch
coordinate error `0.450`, and maximum selected-patch metric error `0.530`.

## Verdict

**Retain viable overlapping patches, large shared carriers, and coframe sign
orientability.** At higher density the order-side pipeline regularly produces
many intrinsically passing A17 patches, and every selected triple admits
proper/time-oriented diagonal coframe gauges. Affine and Lorentz cocycles are
also near `0.10` in the median realization.

**Reject overlap maximization as a sufficient tetrad-bundle selector.** Large
overlap and individually passing local patches do not force their independently
regressed metrics to agree. The metric-bundle gate passes only one held-out
realization, so no global tetrad field or spin structure has been derived.

The next test should keep a minimum-overlap floor but jointly synchronize the
patch metrics/coframes, or select triples by intrinsic metric-covariance and
Lorentz-defect controls frozen on development. Only after proper-orthochronous
transitions satisfy a stable cocycle should their local `SL(2,C)` lifts feed the
kernel-checked `Z2` cochain obstruction. Connection and curvature remain
closed.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_tetrad_bundle_atlas.py`
- `python -m ruff check Scripts/experiments/causal_tetrad_bundle_atlas.py Scripts/experiments/test_causal_tetrad_bundle_atlas.py`
- Development and held-out commands, selected pivots, overlap counts, and all
  gates are retained in the JSON artifacts.

## Formal interfaces

- `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean`
- `PhysicsSM/Draft/NullEdge/GraphSpinLiftCocycle.lean`
- `PhysicsSM/Draft/NullEdge/FiniteSpinCochainObstruction.lean`
- `PhysicsSM/Draft/NullEdge/SpinLiftDefectFromTransport.lean`
