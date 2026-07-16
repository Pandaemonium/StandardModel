# Null-edge compatibility-selected tetrad-bundle Stage A19 benchmark

Date: 2026-07-15

## Question

Can transition and metric compatibility select a stable triple of independently
reconstructed A17 patches, repairing A18 without forcing their metrics to agree?

## Construction and scope

`Scripts/experiments/causal_compatible_tetrad_bundle.py` retains the A18 patch
radius `0.40`, the A17 metric ridge `0.1`, and at most 12 candidate local
patches. Only patches passing the intrinsic A17 gate are eligible.

Every pairwise overlap is randomly divided into three disjoint parts:

1. 60% fits the affine transition;
2. 20% scores transition error for triple selection; and
3. 20% remains untouched until after selection.

The selector uses only overlap counts, selector-slice affine error, transition
conditioning, metric covariance, Lorentz defect, affine and Lorentz cocycles,
and orientation/time-orientation. Untouched test error and all sprinkling-
coordinate oracle controls are excluded. Unit tests verify that changing the
untouched test error cannot change the selected triple.

The frozen gates require minimum pair overlap `30`, triple overlap `15`, affine
errors and cocycles at most `0.25`, affine-design condition at most `50`, and
metric-covariance and Lorentz defects at most `0.35`.

This is still a conditional reconstruction. Dimension, density, endpoints,
scale, and the transported Minkowski metric prior remain supplied. Approximate
transition maps do not define an exact central `Z2` face cocycle, so no spin-
obstruction class is computed.

## Development

Artifact:
`AgentTasks/causal-compatible-tetrad-bundle-stage-a19-development-n4000-2026-07-15.json`

Five `N=4000` realizations use seed `20260840`. Four of five pass the selector,
untouched transition, metric-bundle, and spin-prerequisite gates. The remaining
realization constructs seven patches but has only one intrinsic A17 pass, so no
triple is available.

Across the four available triples, the medians are:

- selector affine error: `0.130`
- untouched test affine error: `0.153`
- maximum metric-covariance error: `0.259`
- maximum Lorentz defect: `0.275`
- affine and Lorentz cocycle residuals: `0.119`, `0.136`

Across all five realizations, the median constructed-patch count is `7`, the
median intrinsic-pass count is `5`, minimum pair overlap is `165`, and triple
overlap is `150`. The positive development result is therefore conditional on
patch availability and requires independent testing.

## Held-out test

Artifact:
`AgentTasks/causal-compatible-tetrad-bundle-stage-a19-heldout-n4000-2026-07-15.json`

Three fresh `N=4000` realizations use seed `20260850`, with all construction,
selection rules, and thresholds frozen. None passes the selector,
untouched-transition, metric-bundle, or spin-prerequisite gate.

One realization constructs 11 patches but has only two intrinsic passes, so no
triple exists. For the two available triples:

- median selector affine error: `0.229`
- median untouched test affine error: `0.250`
- median maximum metric-covariance error: `0.432`
- median maximum Lorentz defect: `0.479`
- median affine and Lorentz cocycle residuals: `0.303`, `0.345`
- median maximum selected-patch oracle metric error: `1.020`

Only two of three realizations admit an orientation/time-orientation gauge. One
available triple narrowly misses the selector affine threshold at `0.258`; the
other passes selector affine error at `0.199` but fails the untouched test at
`0.279`, metric covariance at `0.475`, Lorentz compatibility at `0.516`, and
both cocycle controls.

## Verdict

**Retain the three-way overlap protocol.** It cleanly separates transition
fitting, compatibility-based model selection, and final evaluation. It should
be reused for subsequent bundle reconstructions.

**Reject compatibility-only triple selection as a sufficient tetrad-bundle
construction.** Its `4/5` development success falls to `0/3` on the frozen
held-out sample. No threshold is relaxed after inspection. Patch availability
is marginal, and independently regressed metrics remain inconsistent even when
the selector prefers their best available triple.

Within this conditional atlas lane, the next test should jointly synchronize
metrics or coframes across overlaps, with a fidelity term for each patch's
count-derived interval regression and an independent overlap test. Selection
among unchanged local fits is exhausted by this result. The primary bare-graph
G2 target remains stable probe-covariant metric reconstruction from the
corrected causal operator. Exact spin lifting and curvature remain closed.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_compatible_tetrad_bundle.py`
- `python -m ruff check Scripts/experiments/causal_compatible_tetrad_bundle.py Scripts/experiments/test_causal_compatible_tetrad_bundle.py`
- Development and held-out commands, selected pivots, overlap counts, residuals,
  and gate outcomes are retained in the JSON artifacts.

## Formal interfaces

- `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean`
- `PhysicsSM/Draft/NullEdge/GraphSpinLiftCocycle.lean`
- `PhysicsSM/Draft/NullEdge/FiniteSpinCochainObstruction.lean`
- `PhysicsSM/Draft/NullEdge/SpinLiftDefectFromTransport.lean`
