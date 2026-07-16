# Null-edge fused operator/count metric Stage A25 benchmark

Date: 2026-07-15

## Question

Does combining A23's operator-derived conformal ray with A24's independent
count-volume scale produce one absolute metric that passes signature, tensor,
and volume checks on the same curved sprinkling?

## Fusion rule and scope

`Scripts/experiments/causal_fused_operator_count_metric.py` initializes A23 and
A24 from the same child seed, so both estimators act on the same point cloud and
the same `t=0.7T` pivot. Their regulator multipliers were frozen by predecessor
flat controls.

Let `G` be the A23 inverse-metric estimate and `v_count` the A24 fitted metric
volume density. The fusion chooses the unique positive scalar

```text
alpha = sqrt(v_op / v_count),
v_op = 1 / sqrt(abs(det G)),
G_fused = alpha G.
```

Equivalently, `G` is normalized to a unit-determinant conformal representative
and multiplied by A24's inverse-metric Weyl factor. This rule uses no target
metric or Minkowski trace. Its derivative is computed exactly from

```text
d log(abs(det G)) = tr(G^-1 dG)
```

and the A24 factor gradient.

Coordinates, density, dimension, pivot, probe germs, count windows, and both
schedule families remain supplied. This is a conditional same-data fusion,
not a bare-graph metric theorem.

## Held-out `N=4000`

Artifact:
`AgentTasks/causal-fused-operator-count-metric-stage-a25-heldout-n4000-2026-07-15.json`

Four fresh realizations per background use seed `20261000`. Every fused metric
has signature `(1,3,0)`.

| `H` | operator median volume error | fused median volume error | fused/count mismatch | fused median tensor error |
|---:|---:|---:|---:|---:|
| `0.0` | `1.568` | `0.071` | `0.040` | `0.632` |
| `0.1` | `1.428` | `0.044` | `0.145` | `0.554` |
| `0.2` | `1.399` | `0.037` | `0.139` | `0.506` |

The volume improvement is decisive: determinant fusion reduces order-one
operator-volume errors to `3.7-7.1%` and agrees with the disjoint pivot count
volume to `4.0-14.5%`.

The tensor metric does not pass. Unit-volume operator-shape errors are `0.51`
to `0.62`, and ensemble fused metric errors are `0.48` to `0.63`. Correct scale
cannot repair anisotropy and off-diagonal noise in the conformal representative.

The derivative also fails. Median fused first-jet errors are `6.4-6.9`, worse
than the already failed A23 operator jets. The determinant derivative amplifies
noisy shape directions even though its scalar volume is correct.

## `N=8000` refinement

Artifact:
`AgentTasks/causal-fused-operator-count-metric-stage-a25-refinement-n8000-2026-07-15.json`

Three fresh realizations per background use seed `20261010`, up to `192`
operator rows, and up to `192` count centers. Every fused metric remains
Lorentzian.

Median fused oracle-volume errors are `15.8%`, `5.1%`, and `6.5%`; count-volume
mismatches are `19.0%`, `19.6%`, and `10.1%`. These remain far below the raw
operator determinant errors, although the small ensemble does not improve
monotonically in every background.

Tensor shape does not refine uniformly: median shape errors are `0.354`,
`0.562`, and `0.615`, and fused tensor errors are `0.427`, `0.571`, and `0.644`.
Fused first-jet errors remain between `4.9` and `8.0`.

## Verdict

**Retain the determinant/volume fusion rule.** It is the correct way to combine
a conformal inverse-metric ray with an independently reconstructed volume form,
and it closes the held-out metric-volume consistency check to the `4-15%`
level without target normalization.

**Do not claim full metric reconstruction.** A25 isolates the surviving debt:
the operator conformal representative is Lorentzian and concentrated but still
has order-one tensor-shape error. Scale reconstruction is no longer the reason
the component metric fails.

**Keep the first-jet and Levi-Civita gates closed.** Differentiating a noisy
shape is unstable even after scale is corrected. The next metric stage should
improve the operator conformal projector itself, using basis-free probe-sector
averaging or a constrained Lorentzian shape estimator, while preserving the
A24/A25 independent volume validation.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_operator_count_fused_metric.py`
- `python -m ruff check Scripts/experiments/causal_fused_operator_count_metric.py Scripts/experiments/test_causal_operator_count_fused_metric.py`
- Both JSONs retain the paired operator/count inputs, fused matrices and jets,
  determinant volumes, independent validation volumes, seeds, and samples.

## Provenance

- Hawking-King-McCarthy and Malament for conformal geometry plus scale.
- Standard determinant variation for the volume normalization and derivative.
- A23 and A24 for the two independently tested numerical inputs.
