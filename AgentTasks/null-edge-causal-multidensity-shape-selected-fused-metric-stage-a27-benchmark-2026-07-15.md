# Null-edge multi-density shape-selected metric Stage A27 benchmark

Date: 2026-07-15

## Question

Can A26's shape-first regulator selection be made density-stable by choosing one
setting against independent flat `N=4000` and `N=8000` development ensembles
before opening any new curved samples?

## Selection protocol

The original A23 flat `N=4000` development artifact is combined with a new
four-realization flat `N=8000` development artifact:

- `AgentTasks/causal-conformal-multirow-metric-stage-a23-development-n4000-2026-07-15.json`
- `AgentTasks/causal-conformal-multirow-metric-stage-a27-development-flat-n8000-2026-07-15.json`

`Scripts/experiments/causal_multidensity_shape_selected_fused_metric.py`
requires a common setting and minimizes the worst density's median unit-volume
shape error after first maximizing the minimum Lorentzian signature rate. No
curved sample enters selection.

The selected setting is

```text
cL = 0.65, cS = 1.2, cA = 0.7.
```

Its minimum development signature rate is `1.0`; its worst median, ensemble,
and maximum unit-volume shape errors are `0.377`, `0.327`, and `0.572`.

## Fresh `N=4000`

Artifact:
`AgentTasks/causal-multidensity-shape-selected-fused-metric-stage-a27-heldout-n4000-2026-07-15.json`

Four realizations per background use seed `20261150`.

| `H` | signature rate | median fused metric error | ensemble metric error | oracle-volume error | count-volume mismatch | first-jet error | median rows |
|---:|---:|---:|---:|---:|---:|---:|---:|
| `0.0` | `0.75` | `0.343` | `0.486` | `0.033` | `0.124` | `14.343` | `34` |
| `0.1` | `1.00` | `0.281` | `0.149` | `0.044` | `0.228` | `10.050` | `32` |
| `0.2` | `0.50` | `1.069` | `0.848` | `0.070` | `0.142` | `54.925` | `30` |

The setting fails the signature and tensor gates. Its smaller averaging ball
also leaves far fewer regression rows than A26's `cA=0.9` setting, and the
first-jet tail becomes catastrophic.

## Fresh `N=8000`

Artifact:
`AgentTasks/causal-multidensity-shape-selected-fused-metric-stage-a27-heldout-n8000-2026-07-15.json`

Three realizations per background use seed `20261160`.

| `H` | signature rate | median fused metric error | ensemble metric error | oracle-volume error | count-volume mismatch | first-jet error | median rows |
|---:|---:|---:|---:|---:|---:|---:|---:|
| `0.0` | `1.00` | `0.379` | `0.448` | `0.026` | `0.053` | `7.272` | `49` |
| `0.1` | `1.00` | `0.210` | `0.077` | `0.060` | `0.109` | `8.176` | `48` |
| `0.2` | `1.00` | `0.159` | `0.058` | `0.067` | `0.065` | `10.197` | `46` |

The higher-density tensor scores are encouraging, especially in curved cells,
but they do not repair the lower-density held-out failures or the first jet.

## Verdict

**Kill median-only multi-density selection.** Development medians did not
control signature tails, and the selected smaller averaging radius supplied too
few rows for a stable local field fit.

**Retain the A26 shape-first objective, count-volume fusion, and explicit
failure recording.** The next flat selector must preregister lower-tail
signature reliability, worst-realization shape error, minimum row support, and
design conditioning before comparing central errors. It must again be frozen
before curved scores are opened.

**Keep first-jet, connection, and curvature gates closed.** A27 strengthens the
negative derivative result: density-aware metric selection alone does not make
the local affine derivative stable.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_multidensity_shape_selected_fused_metric.py Scripts/experiments/test_causal_shape_selected_fused_metric.py Scripts/experiments/test_causal_operator_count_fused_metric.py`
- `python -m ruff check Scripts/experiments/causal_multidensity_shape_selected_fused_metric.py Scripts/experiments/test_causal_multidensity_shape_selected_fused_metric.py`
- All three new JSONs retain development or held-out seeds, selection scores,
  individual matrices, signatures, row counts, volume checks, and derivatives.

## Provenance

- A23/A26 for the shrinking-scale flat development family and shape objective.
- A24/A25 for count-volume scale and determinant fusion.
- Minimax selection is a program-internal preregistered audit, not a continuum
  theorem.
