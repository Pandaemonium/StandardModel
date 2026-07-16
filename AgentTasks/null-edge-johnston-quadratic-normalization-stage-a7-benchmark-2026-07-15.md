# Stage A7: Johnston quadratic validation and trace normalization

## Objective

Replace the killed Stage A6 pointwise interval quadratic with a mesoscopically
regressed, basis-gauge-invariant quadratic from the Johnston lightcone chart.
Validate that scalar field independently of the causal operator, freeze its
support, then test trace normalization on development and held-out metric
controls.

Dimension, density, interval endpoints, and spatial rank three remain supplied.
This is a conditional numerical reconstruction study, not continuum GR from a
bare order.

## Quadratic construction

For the compact Johnston probes `P=(t_J,x_J^1,x_J^2,x_J^3)`, define

~~~text
q_J = t_J^2 - (x_J^1)^2 - (x_J^2)^2 - (x_J^3)^2.
~~~

The scalar is invariant under the unresolved spatial orthogonal gauge of the
SVD. It is also event-relabeling equivariant. No operator row is needed to
construct it.

The independent target is the same quadratic formed from compact embedded
coordinate probes. The frozen probe gate requires relative error at most
`0.25` both over the full retarded support and over the inner region where the
cutoff is one.

Implementation and tests:

~~~text
Scripts/experiments/causal_johnston_quadratic_probe.py
Scripts/experiments/test_causal_johnston_quadratic_probe.py
Scripts/experiments/causal_johnston_probe_metric.py
Scripts/experiments/test_causal_johnston_probe_metric.py
~~~

## Independent development result

Twenty `N=5000` realizations with seed `20260723` compared support radii
`0.36`, `0.50`, and `0.65`. Operator scores were not computed.

| support | Johnston median error | Johnston inner error | correlation | norm ratio | probe passes |
|---:|---:|---:|---:|---:|---:|
| 0.36 | 0.587 | 0.835 | 0.770 | 1.002 | 0% |
| 0.50 | 0.336 | 0.472 | 0.911 | 1.012 | 10% |
| 0.65 | 0.208 | 0.294 | 0.958 | 0.978 | 20% |

The frozen selection rule chose support `0.65`. Its overall quadratic is
already better than the single-interval estimator, whose median error is
`0.243` at this support, but the inner Johnston error still misses the
development gate.

## Independent held-out probe result

The selected support was carried to ten independent `N=10000` realizations
with seed `20260724`. Operator scores remained closed.

| held-out quantity | result |
|---|---:|
| Johnston median error | 0.095 |
| Johnston median inner error | 0.121 |
| Johnston median correlation | 0.991 |
| Johnston median norm ratio | 0.987 |
| probe-gate pass rate | 100% |
| single-interval median error | 0.149 |
| single-interval inner error | 0.221 |

The Johnston quadratic therefore passes its independent prerequisite and
improves rapidly with density in this test.

Machine-readable probe artifacts:

~~~text
AgentTasks/causal-johnston-quadratic-probe-stage-a7-development-n5000-2026-07-15.json
AgentTasks/causal-johnston-quadratic-probe-stage-a7-heldout-n10000-2026-07-15.json
~~~

## Operator-scale development

After the probe pass, support `0.65` was frozen. Ten new `N=10000`
realizations with seed `20260725` evaluated

~~~text
L in {0.12, 0.14, 0.16, 0.18, 0.20}.
~~~

The normalization factor `a_J=8/Bq_J` was computed whenever `Bq_J>0` and
applied to coordinate-control pairings. Johnston metric scores were not opened.

| L | raw median error | median `a_J` | normalized passes | normalized median error | aggregate normalized error |
|---:|---:|---:|---:|---:|---:|
| 0.12 | 2.486 | 3.263 | 0% | 8.041 | 2.281 |
| 0.14 | 1.156 | 2.551 | 0% | 2.441 | 0.833 |
| 0.16 | 0.689 | 2.012 | 10% | 0.915 | 0.253 |
| 0.18 | 0.642 | 2.612 | 20% | 0.610 | 0.190 |
| 0.20 | 0.763 | 4.262 | 20% | 0.626 | 0.286 |

The frozen rule selected `L=0.18` by gate rate, median error, and aggregate
error in that order.

## Final held-out metric result

The selected support and scale were evaluated on ten fresh `N=10000`
realizations with seed `20260726`. Johnston metric scores were opened only in
this final stage.

| held-out quantity | raw | Johnston-quadratic normalized |
|---|---:|---:|
| coordinate-oracle median error | 0.661 | 0.743 |
| coordinate-oracle gate passes | 0% | 20% |
| Johnston pulled median error | 0.683 | 0.799 |
| Johnston conditional gate passes | 0% | 0% |
| Johnston direct median error | 0.704 | 0.804 |
| median normalization factor | not applicable | 2.682 |

The Johnston chart itself remains strong: median affine-fit error is `0.078`
and median Jacobian condition number is `1.137`. The dominant spatial gap,
however, selects rank five in nine samples and rank four in one, never rank
three. The strict prototype gate is therefore zero independently of
normalization.

Machine-readable operator artifacts:

~~~text
AgentTasks/causal-johnston-quadratic-normalization-stage-a7-development-n10000-2026-07-15.json
AgentTasks/causal-johnston-quadratic-normalization-stage-a7-heldout-metric-n10000-2026-07-15.json
~~~

## Verdict

**Retain the Johnston quadratic probe.** It is a genuine positive result: an
order-derived, gauge-invariant scalar quadratic reaches 100% held-out probe
passes and approximately 10% relative error once dimension, density, endpoints,
and spatial rank are supplied.

**Kill single-row trace normalization as a scale reconstruction.** Even with an
accurate `q_J`, forcing `Bq_J=8` does not correct anisotropy and off-diagonal
fluctuations. It worsens both held-out median errors and produces no Johnston
conditional pass. A trace condition can fix scale only after conformal shape is
already controlled.

This does not derive absolute scale from a bare graph. It clarifies the required
order of gates:

1. independently validate the quadratic probe;
2. establish a scale-free conformal-shape and concentration gate;
3. only then impose quadratic trace normalization;
4. compare the resulting metric volume with counts.

## Next decision

The next experiment should average multiple nearby operator rows or fit their
common conformal metric before applying trace normalization. The averaging
neighborhood and weights must be selected from order-side quantities, and the
held-out score must report both bias and eventwise concentration. Dimension
selection remains separate and unresolved.

Weak-curvature and curvature-triangle tests remain premature until the flat
conformal-shape gate passes.

## Verification commands

~~~text
cd Scripts/experiments
python -m unittest test_causal_johnston_quadratic_probe.py test_causal_johnston_probe_metric.py test_causal_johnston_operator_control_scan.py
python -m ruff check causal_johnston_quadratic_probe.py causal_johnston_probe_metric.py causal_johnston_operator_control_scan.py test_causal_johnston_quadratic_probe.py test_causal_johnston_probe_metric.py test_causal_johnston_operator_control_scan.py
python causal_johnston_quadratic_probe.py --events 5000 --realizations 20 --include-samples
python causal_johnston_quadratic_probe.py --events 10000 --realizations 10 --support-radii 0.65 --seed 20260724 --include-samples
python causal_johnston_operator_control_scan.py --events 10000 --realizations 10 --support-radii 0.65 --selection-mode johnston_quadratic --seed 20260725 --include-samples
python causal_johnston_probe_metric.py --events 10000 --realizations 10 --nonlocality-scale 0.18 --support-radius 0.65 --seed 20260726 --include-samples
~~~
