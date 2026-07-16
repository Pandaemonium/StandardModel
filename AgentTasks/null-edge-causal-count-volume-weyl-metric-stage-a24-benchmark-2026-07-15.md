# Null-edge count-volume Weyl metric Stage A24 benchmark

Date: 2026-07-15

## Question

Can the local inverse-metric Weyl factor be reconstructed from event counts,
independently of the biased determinant of the Stage A23 causal-operator
metric?

## Construction and scope

`Scripts/experiments/causal_count_volume_weyl_metric.py` isolates the scale
half of the Malament split on the conformal de Sitter controls

```text
g = a(t)^2 eta,   a(t) = 1 / (1 - H t).
```

At an interior `t=0.5T` pivot, synthetic coordinate Alexandrov windows have
coordinate half-duration

```text
W_coord = cW sqrt(ell_coord T_coord).
```

Here `ell_coord` is computed from the coordinate diamond volume and event
count; it does not use the unknown local Weyl factor. Fit centers lie within
`C = cC W_coord`. Both coordinate scales shrink,
`ell_coord/W_coord -> 0`, and the expected count per window grows under density
refinement. If a window has coordinate volume `V_coord`, supplied physical
sprinkling density `rho`, and event count `n`, then

```text
a^4 ~= n / (rho V_coord),
a^-2 ~= sqrt(rho V_coord / n).
```

A random Poisson thinning separates fit counts from the independent pivot
validation count. The fitted affine intercept reconstructs `a^-2`; its
gradient is a conditional first-scale-jet estimate. The supplied conformal
class then gives `g^-1 = a^-2 eta`.

Coordinates place the synthetic windows and centers, dimension and density are
supplied, and `eta` is not reconstructed. This is a conditional Weyl-scale
oracle, not a bare-order construction or a complete metric reconstruction.

## Development selection

Five `N=4000`, `H=0` controls scan

```text
cW in {0.45, 0.55, 0.65},
cC in {1.2, 1.5}.
```

Settings within `0.03` of the best flat ensemble factor error are ranked by
independent count-versus-metric volume mismatch and flat zero-gradient noise.
Curved targets do not enter selection. The frozen choice is

```text
cW = 0.65,   cC = 1.2.
```

Development ensemble Weyl-factor errors are `0.7%`, `1.6%`, and `2.2%` for
`H=0`, `0.1`, and `0.2`. Median oracle volume errors are `9.5%`, `3.6%`, and
`7.4%`. Median disagreement with the disjoint pivot count volume is `7.1%`,
`24.1%`, and `17.2%`.

## Held-out `N=4000`

Artifact:
`AgentTasks/causal-count-volume-weyl-metric-stage-a24-heldout-n4000-2026-07-15.json`

Five fresh realizations per background use seed `20260970`. Every fit uses the
maximum `96` centers. Median fit-window counts are `35`, `34.5`, and `35`;
median independent pivot counts are `36`, `31`, and `26`.

| `H` | ensemble factor error | median sample error | median oracle volume error | median independent volume mismatch |
|---:|---:|---:|---:|---:|
| `0.0` | `<0.1%` | `1.9%` | `4.0%` | `17.3%` |
| `0.1` | `0.9%` | `2.6%` | `5.1%` | `14.9%` |
| `0.2` | `0.4%` | `1.6%` | `3.2%` | `31.1%` |

Relative curved-response errors are below `0.9%`. Because the conformal factor
is positive, every reconstructed conditional metric has signature `(1,3,0)`.

The factor gradient is less stable. Ensemble temporal-gradient errors are
`24%` and `19%`, while median full-gradient errors remain `0.57` and `0.86` in
dimensionless metric units.

## `N=8000` refinement

Artifact:
`AgentTasks/causal-count-volume-weyl-metric-stage-a24-refinement-n8000-2026-07-15.json`

Three fresh realizations per background use seed `20260980`. The coordinate
window shrinks from approximately `0.179` to `0.164`; centers grow
from `96` to `192`, and median window counts grow to `35-43` despite the
shrinking windows.

Ensemble factor errors are `3.4%`, `2.3%`, and `4.5%`; median sample errors are
`5.1%`, `1.7%`, and `3.7%`. Median oracle volume errors are `9.5%`, `3.4%`, and
`7.0%`. Most importantly, median disagreement with the independent pivot count
volume reaches `12.0%`, `10.0%`, and `15.2%`.

The first gradient still does not converge uniformly: the `H=0.2` temporal
error falls to `8.5%`, but the `H=0.1` control rises to `191%`. Do not promote
the scale derivative from this result.

## Verdict

**Retain A24 as a positive conditional absolute-scale reconstruction.** With
the conformal class supplied, event counts recover the local inverse-metric
Weyl factor and absolute metric volume on fresh curved samples. The scale
result is much stronger than the flat-normalized operator response: no target-
fitted multiplicative renormalization is applied.

**Retain the independent-thinning volume gate.** It prevents the same count
from defining and validating the scale. Its mismatch reaches about `10-15%`
at doubled density, providing initial refinement evidence.

**Do not claim a bare-graph scale construction yet.** Synthetic coordinate
window
endpoints and center neighborhoods use embedding coordinates. An intrinsic
version must derive suitable local Alexandrov windows from order, retain
relabeling covariance, and reproduce this refinement behavior.

**Fail the first-scale-jet gate.** The factor itself is stable; its affine
gradient is not uniformly stable. The next stage should first fuse the A24
factor with A23's concentrated operator conformal shape and test absolute
metric-volume agreement. Derivatives and Levi-Civita reconstruction remain
closed until that fused metric passes.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_count_volume_weyl_metric.py`
- `python -m ruff check Scripts/experiments/causal_count_volume_weyl_metric.py Scripts/experiments/test_causal_count_volume_weyl_metric.py`
- Development, held-out, and refinement JSONs retain the Poisson split,
  window counts, scale schedule, fits, gradients, seeds, and all samples.

## Provenance

- Hawking-King-McCarthy and Malament for the causal/conformal split.
- Bombelli-Lee-Meyer-Sorkin for order plus number as spacetime data.
- The supplied Pro analysis prioritized count-volume agreement as part of the
  metric reconstruction gate.
