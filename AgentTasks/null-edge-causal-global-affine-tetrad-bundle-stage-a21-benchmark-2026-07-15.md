# Null-edge global-affine tetrad-bundle Stage A21 benchmark

Date: 2026-07-15

## Question

Can overlapping reconstructed patches be synchronized to one exact affine
atlas and one exact pulled-back tetrad while preserving independently tested
flat count geometry?

## Construction and scope

`Scripts/experiments/causal_global_affine_tetrad_bundle.py` is an explicit
Minkowski control. Three chart-to-global affine maps (H_i) are fitted jointly
from the transition-fit events, with patch zero fixing the global gauge. Pair
transitions are then defined by

```text
T_ij = H_i H_j^{-1}.
```

Their affine cocycle is exact by construction. A single constant global metric
is fitted by pooling the three patches' count-derived interval training normal
equations after transporting them into the common gauge. If (C_i) is the
linear part of (H_i), local metrics and coframes are defined by

```text
g_i = C_i g C_i^T,
e_i = C_i e,
g = e eta e^T.
```

Metric covariance, internal Lorentz compatibility, and both affine and
internal cocycles are consequently exact up to floating-point roundoff. The
internal transitions reduce to the identity in this chosen global coframe
gauge.

That algebraic exactness is not itself evidence. Triple selection separately
requires selector-slice affine transitions, local interval error, causal signs,
unrelated-pair signs, Lorentzian signature, map conditioning, and exact-
residual controls. Local and overlap test slices remain unopened until after
selection. Unit tests verify global-gauge recovery, pooled metric recovery,
exact pullback identities, and selector blinding.

This construction cannot represent curvature because it uses one constant
global metric and one global coframe. Dimension, density, endpoints, scale, and
the Lorentz prior remain supplied. No exact graph spin-obstruction class is
computed.

## Development

Artifact:
`AgentTasks/causal-global-affine-tetrad-bundle-stage-a21-development-n4000-2026-07-15.json`

Five `N=4000` realizations use seed `20260880`, with the A20/A19 local and
overlap thresholds unchanged. Four of five pass every selector, untouched,
exact-flat-bundle, and trivial flat-spin-control gate.

Development medians are:

- constructed and coordinate-eligible patches: `10`, `8`
- minimum pair and triple overlaps: `175`, `163`
- global-gauge and global-metric conditions: `27.2`, `61.3`
- maximum global-map linear condition: `1.85`
- selector and untouched transition errors: `0.233`, `0.238`
- selector and untouched interval errors: `0.108`, `0.119`
- selector and untouched unrelated-pair violations: `0.071`, `0.061`
- minimum selector and untouched causal-sign fractions: `0.992`, `0.990`
- maximum metric adjustment from independent fits: `0.261`

Affine cocycle, metric covariance, Lorentz defect, internal cocycle, and
internal-identity residuals all have medians between `1e-16` and `5e-16`.
The failed realization has selector/test transition errors `0.287`/`0.304` and
causal-sign fractions near `0.935`, so exact algebra does not conceal its poor
geometry.

## Held-out test

Artifact:
`AgentTasks/causal-global-affine-tetrad-bundle-stage-a21-heldout-n4000-2026-07-15.json`

Three fresh `N=4000` realizations use seed `20260890` with the construction and
thresholds frozen. Every realization passes selector, untouched local-metric,
untouched transition, exact-flat-bundle, and trivial flat-spin-control gates.

Held-out medians are:

- constructed and coordinate-eligible patches: `8`, `7`
- minimum pair and triple overlaps: `206`, `193`
- global-gauge and global-metric conditions: `22.4`, `56.4`
- maximum global-map linear condition: `1.44`
- selector and untouched transition errors: `0.170`, `0.188`
- selector and untouched interval errors: `0.125`, `0.115`
- selector and untouched unrelated-pair violations: `0.058`, `0.047`
- minimum selector and untouched causal-sign fractions: `0.982`, `0.993`
- maximum metric adjustment: `0.149`
- exact affine cocycle, metric covariance, Lorentz defect, internal cocycle,
  and identity residuals: all below `4e-16` in the median

Post-selection oracle medians are affine-transition error `0.207`, patch-
coordinate error `0.407`, and pulled-back metric error `0.359`.

## Verdict

**Retain A21 as the exact flat tetrad-bundle baseline.** Exact chart cocycles,
metric pullbacks, Lorentz transitions, and internal cocycles coexist with
independent local and overlap test accuracy in all three held-out realizations.
This is stronger than an algebraic construction alone because the exact bundle
is selected and tested against data it did not fit.

**Do not interpret the identity internal transitions as a derived nontrivial
spin structure.** They are forced by pulling one global coframe into all three
patches. The resulting identity lift is only the correct trivial flat control
on this contractible atlas triangle. It says nothing about a global graph,
nontrivial topology, the central `Z2` obstruction, or curved spin transport.

**Do not extend the one-metric architecture to gravity.** A constant global
metric has zero connection and curvature by construction. The next stage must
replace it with a globally registered position-dependent metric model, starting
with affine first jets on weakly curved static and de Sitter/FLRW controls.
Exact transition cocycles can be retained, while held-out interval data test
metric-jet consistency and independent connection/operator/holonomy estimators
test curvature.

The primary bare-graph G2 target remains stable probe-covariant metric
reconstruction from the corrected causal operator.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_global_affine_tetrad_bundle.py`
- full causal experiment suite: `107 passed`
- `python -m ruff check Scripts/experiments/causal_global_affine_tetrad_bundle.py Scripts/experiments/test_causal_global_affine_tetrad_bundle.py Scripts/experiments/causal_compatible_tetrad_bundle.py`
- Development and held-out seeds, selected pivots, splits, residuals, and gates
  are retained in the JSON artifacts.

## Formal interfaces

- `AgentTasks/null-edge-synchronized-tetrad-bundle-aristotle-2026-07-15.md`
- `PhysicsSM/Draft/NullEdge/TetradSpinReconstructionBoundary.lean`
- `PhysicsSM/Draft/NullEdge/GraphSpinLiftCocycle.lean`
- `PhysicsSM/Draft/NullEdge/FiniteSpinCochainObstruction.lean`
