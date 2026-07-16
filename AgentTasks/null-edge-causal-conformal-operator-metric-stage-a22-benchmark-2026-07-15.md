# Null-edge conformal causal-operator metric Stage A22 benchmark

Date: 2026-07-15

## Question

Does the corrected order/count causal-operator pairing respond to a known
curved conformal metric without fitting its regulator on curved targets?

## Construction and claim boundary

`Scripts/experiments/causal_conformal_operator_metric.py` conditionally samples
four-dimensional conformal-coordinate diamonds with

```text
g = a(t)^2 diag(1,-1,-1,-1),   a(t) = 1 / (1 - H t),
```

where `H * duration < 1`. This is a translated conformal-time patch of
spatially flat de Sitter spacetime. The causal relation remains the Minkowski
relation, while events are sampled with physical-volume weight `a(t)^4`.
The physical diamond volume fixes the supplied discreteness scale.

The smeared four-dimensional Benincasa-Dowker row uses only causal precedence,
open-interval counts, the supplied density scale, and a supplied mesoscopic
nonlocality scale. The corrected pairing is evaluated on compact coordinate
probes. At the top event its target is

```text
g^{-1} = a(T)^-2 diag(1,-1,-1,-1).
```

Embedding coordinates enter the sampler, probes, support ball, and target.
The experiment therefore tests a curved operator response, not intrinsic
metric reconstruction from a bare order. It computes no metric first jet,
connection, curvature, tetrad, or spin structure.

## Selection protocol

Development scans physical nonlocality scales `0.14`, `0.16`, `0.18` and
physical support radii `0.45`, `0.55`. The setting is selected using only five
`N=4000`, `H=0` controls. Curved summaries do not enter the selection key.
The selected setting is

```text
L = 0.18,   support radius = 0.55.
```

Fresh `N=4000` seeds then test `H=0`, `0.1`, and `0.2`. A separate `N=8000`
refinement retains the same setting.

## Development result

At the selected setting, ensemble mean metric errors for `H=0`, `0.1`, and
`0.2` are `0.495`, `0.505`, and `0.494`. Per-realization Lorentz-signature
rates are `100%`, `60%`, and `80%`.

The estimated conformal coefficients `a(T)^-2` have a common absolute bias,
but their ratios to the flat estimate track the target response. Relative
response errors are `2%` at `H=0.1` and `8%` at `H=0.2`. This curved response
was not used for regulator selection.

Determinant volume does not pass: median relative errors are `2.468`, `4.547`,
and `1.790`. Exact affine probe covariance remains at approximately `1e-13`.

## Held-out result

Artifact:
`AgentTasks/causal-conformal-operator-metric-stage-a22-heldout-n4000-2026-07-15.json`

On five fresh realizations per background, ensemble mean metric errors are
`0.713`, `0.439`, and `0.599`. Signature rates are `80%`, `60%`, and `80%`.
After normalizing to the flat estimate, the conformal-response errors are
`15%` at `H=0.1` and `19%` at `H=0.2`.

Median determinant-volume errors are `1.423`, `3.524`, and `1.820`. Thus the
held-out operator detects the direction and approximate size of the conformal
change at ensemble level, but neither its absolute metric normalization nor
its metric volume is reliable per realization.

## Density refinement

Artifact:
`AgentTasks/causal-conformal-operator-metric-stage-a22-refinement-n8000-2026-07-15.json`

Three fresh `N=8000` realizations per background use the frozen regulator. All
nine recover signature `(1,3,0)`. Ensemble mean metric errors are `0.624`,
`0.455`, and `0.484`; relative conformal-response errors are `18%` and `9%`.
Median volume errors remain `1.730`, `1.973`, and `1.905`.

Increasing density therefore suppresses the observed signature failures but
does not remove the absolute normalization and determinant-volume bias at this
fixed support/nonlocality scale.

## Verdict

**Retain the conformal-response result as a positive curved calibration.** A
flat-selected order/count operator responds on unopened de Sitter controls in
the expected direction and approximately the expected relative magnitude.
This is stronger than applying an embedding-derived tetrad to a known curved
metric because the metric estimate still comes from the corrected causal
operator pairing.

**Fail the absolute G2 metric-and-volume gate.** Per-realization concentration
is weak at `N=4000`; absolute metric errors remain order one; determinant
volume is unstable; and density refinement does not eliminate the bias. A
flat-normalized response cannot substitute for scale reconstruction.

The next operator stage should attack the common normalization/support bias
with a pre-registered refinement schedule and multiple retarded rows or local
probe germs. Only after absolute metric and volume agreement should the
position-dependent first-jet, Levi-Civita, and curvature-triangle interfaces
be opened on this background.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_conformal_operator_metric.py`
- `python -m ruff check Scripts/experiments/causal_conformal_operator_metric.py Scripts/experiments/test_causal_conformal_operator_metric.py`
- Development, held-out, and density-refinement seeds, samples, settings, and
  summaries are retained in the three Stage A22 JSON artifacts.

## Provenance

- Benincasa and Dowker, arXiv:1001.2725, for the four-dimensional causal-set
  operator.
- Belenchia, Benincasa, and Dowker, arXiv:1510.04656, for the curved continuum
  operator convention and source signature.
- The supplied Pro analysis prioritized the operator-metric and count-volume
  bridge before further tetrad or GR-shaped finite constructions.
