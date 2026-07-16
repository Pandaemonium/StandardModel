# Stage A5: order-selected operator control and held-out Johnston test

## Objective

Determine whether the Stage A4 miss comes from the Johnston interval-volume
probe chart or from the finite causal operator at the same order-selected
events. Select one nonlocality-scale/support-radius setting using coordinate
controls only, then open Johnston scores on an independent high-density seed.

This is an external numerical oracle, not a proof. Dimension, density, interval
endpoints, and the target Minkowski embedding remain supplied.

## Blinded development scan

`Scripts/experiments/causal_johnston_operator_control_scan.py` uses the same
intrinsic endpoint-volume time, radius, causal-abundance pivot selector, and
Benincasa-Dowker row as Stage A4. It does not construct or score Johnston
spatial probes. Embedding coordinates enter only through compact coordinate
probes used to calibrate the operator.

The frozen development protocol used 20 realizations at `N=5000`, seed
`20260720`, and the full grid

~~~text
L in {0.12, 0.14, 0.16, 0.18, 0.20}
support radius in {0.36, 0.50, 0.65}
per-realization metric-error gate = 0.50
required signature = (+---)
~~~

Selection priority was fixed as:

1. maximum joint gate rate;
2. minimum median per-realization metric error;
3. minimum ensemble-mean metric error;
4. smaller `L` and support radius as deterministic final tie-breakers.

Every one of the 15 settings had zero joint gate passes. The rule therefore
selected `L=0.18` and support radius `0.65` by its lowest median error:

| quantity | development result |
|---|---:|
| Lorentzian-signature rate | 80% |
| median per-realization error | 0.741 |
| ensemble-mean error | 0.647 |
| gate-pass rate | 0% |

The selection is a best failed control, not a passing window.

## Held-out result

The selected setting was frozen and evaluated on 10 independent `N=10000`
realizations with seed `20260721`. The coordinate-only control and Johnston
pipeline were written to separate artifacts and agree sample-by-sample on the
coordinate-oracle signature and error.

| quantity | coordinate control | Johnston probes |
|---|---:|---:|
| Lorentzian-signature rate | 90% | 100% |
| median raw metric error | 0.665 | 0.729 |
| mean raw metric error | 0.682 | 0.730 |
| median local affine-fit error | not applicable | 0.075 |
| joint gate-pass rate | 0% | 0% |

The Johnston chart again tracks the coordinate control closely. Its Jacobian
has median condition number `1.136`, relabeling errors remain at floating-point
roundoff, and the SVD scale-balance residual has median `0.060`. The dominant
spatial gap occurs after rank five in eight samples and rank four in two; it
never selects rank three. The strict prototype gate therefore also remains
zero.

Machine-readable outputs are:

~~~text
AgentTasks/causal-johnston-operator-control-stage-a5-development-n5000-2026-07-15.json
AgentTasks/causal-johnston-operator-control-stage-a5-heldout-n10000-2026-07-15.json
AgentTasks/causal-johnston-probe-stage-a5-heldout-n10000-2026-07-15.json
~~~

## Scale-versus-shape diagnostic

For each coordinate-control pairing `G`, the scanner also computes the best
positive scalar `a` minimizing the Frobenius distance from `aG` to the target
inverse metric. This is a diagnostic only: fitting `a` from the target metric
is not an admissible reconstruction of absolute scale.

| ensemble | raw ensemble error | best positive `a` | rescaled ensemble error | median rescaled sample error |
|---|---:|---:|---:|---:|
| development `N=5000` | 0.647 | 2.788 | 0.109 | 0.714 |
| held-out `N=10000` | 0.615 | 2.427 | 0.224 | 0.570 |

The ensemble mean therefore contains a recognizable Lorentzian conformal shape
after one global positive rescaling. The unfitted operator normalization is
substantially too small, however, and individual-event fluctuations remain
above the `0.50` gate even after target-fitted rescaling. This is evidence for a
shape signal, not a solution of scale reconstruction.

## Verdict

**The Johnston probe sector survives its held-out comparison.** Once dimension
and density are supplied, it reconstructs a well-conditioned,
relabeling-covariant local chart whose error remains close to the coordinate
oracle.

**The flat operator control fails.** No development setting or held-out sample
passes the frozen per-realization metric gate. Ensemble averaging reveals a
good conformal shape only after an inadmissible target-fitted scale correction.
Absolute normalization, concentration, dimension selection, and count-volume
agreement are all unresolved.

Do not proceed to weakly curved or curvature-triangle claims under this
operator calibration. Flat-space bias would be inseparable from curvature.

## Next decision

The next operator study should test a mathematically motivated normalization or
asymptotic scaling law, not widen the error threshold. In particular:

1. compare the observed positive scale deficit with the known finite-
   nonlocality expectation of the smeared four-dimensional operator;
2. test whether a count-derived normalization, fixed without target metric
   access, converges across `N` and `L/ell`;
3. require the same normalization to pass count-volume agreement;
4. retain per-event concentration as a hard gate after ensemble bias is
   corrected.

Dimension selection remains a separate negative-control program across known
sprinkling dimensions and nonmanifoldlike orders.

## Verification commands

~~~text
cd Scripts/experiments
python -m unittest test_causal_johnston_operator_control_scan.py
python -m ruff check causal_johnston_operator_control_scan.py test_causal_johnston_operator_control_scan.py
python causal_johnston_operator_control_scan.py --events 5000 --realizations 20 --include-samples
python causal_johnston_operator_control_scan.py --events 10000 --realizations 10 --nonlocality-scales 0.18 --support-radii 0.65 --seed 20260721 --include-samples
python causal_johnston_probe_metric.py --events 10000 --realizations 10 --nonlocality-scale 0.18 --support-radius 0.65 --seed 20260721 --include-samples
~~~
