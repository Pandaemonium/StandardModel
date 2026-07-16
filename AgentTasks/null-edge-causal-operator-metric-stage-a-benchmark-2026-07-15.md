# Stage A causal-operator metric benchmark

Date: 2026-07-15

## Claim boundary

This is an external numerical calibration oracle, not a proof and not an
intrinsic reconstruction from an unlabeled order. It tests whether a
four-dimensional order/count d'Alembertian can recover the inverse Minkowski
metric from known calibration probes. The sprinkling coordinates define the
order and the probes; the operator row itself uses only causal precedence,
open-interval counts, density, and a supplied nonlocality scale.

## Source and convention lock

- The local and smeared rows implement equations (2), (8), and (9) of
  Benincasa and Dowker, arXiv:1001.2725.
- The continuum analysis arXiv:1510.04656 adopts the Hawking-Ellis `(-+++)`
  convention. The source row is multiplied by `-1` before comparison with the
  project's `(+---)` convention.
- For a unit-duration four-dimensional Alexandrov interval,
  `Vol = pi / 24` and `ell = (Vol / N)^(1/4)`.
- The metric estimator is the corrected pairing
  `Gamma_B(f,h) = (B(fh) - f Bh - h Bf + fh B1) / 2`.
- Probe fields are centered coordinates times a smooth cutoff that equals one
  near the target and vanishes at a supplied Euclidean support radius. This
  respects the compact-support side of the continuum convergence interface but
  remains an embedding-dependent calibration choice.

## Checked implementation

- Script: `Scripts/experiments/causal_operator_metric.py`
- Tests: `Scripts/experiments/test_causal_operator_metric.py`
- Eight tests cover diamond volume, interval layers, source coefficients,
  local/smeared reduction, source/project sign conversion, compact-probe germ,
  scalar-potential cancellation, and exact affine probe covariance.
- Affine covariance error stayed at floating-point roundoff in every ensemble.

## Support-radius gate

Paired `N=5000`, `L_k=0.16`, 20-realization ensembles:

| Support radius | Ensemble mean diagonal | Mean error | Per-sample error | Correct signature |
|---:|---|---:|---:|---:|
| 0.5 | `(1.647,-0.438,-0.436,-0.521)` | 0.568 | 0.923 | 90% |
| 0.7 | `(1.399,-0.823,-0.589,-0.873)` | 0.745 | 2.974 | 55% |
| 1.0 | `(-0.227,-1.630,-0.761,-1.396)` | 2.813 | 8.009 | 35% |

The raw uncut coordinate probes were substantially worse. The result confirms
that support control is load-bearing; it does not select the support rule from
the order.

## Nonlocality-scale gate

Paired `N=5000`, support radius `0.5`, 20-realization ensembles:

| `L_k` | Ensemble mean error | Per-sample error | Correct signature | `sd(B1)` |
|---:|---:|---:|---:|---:|
| 0.10 | 1.928 | 16.142 | 30% | 2466.0 |
| 0.12 | 0.692 | 4.449 | 45% | 779.3 |
| 0.14 | 0.387 | 1.880 | 25% | 312.1 |
| 0.16 | 0.424 | 0.970 | 65% | 132.5 |
| 0.18 | 0.580 | 0.703 | 80% | 59.4 |

There is a finite scale window. Small `L_k` reduces smoothing bias but revives
large fluctuations; large `L_k` suppresses fluctuations but biases the metric
toward zero. No parameter-free selection rule has been derived.

## Density gate

Fixed `L_k=0.16`, support radius `0.5`:

| Events | Realizations | Ensemble mean diagonal | Mean error | Per-sample error | Correct signature |
|---:|---:|---|---:|---:|---:|
| 1000 | 100 | `(1.688,-0.462,-0.291,-0.389)` | 0.653 | 2.386 | 43% |
| 2500 | 50 | `(1.193,-0.435,-0.514,-0.455)` | 0.475 | 1.200 | 60% |
| 10000 | 20 | `(1.299,-0.521,-0.503,-0.511)` | 0.452 | 0.723 | 95% |

At `N=10000`, lowering `L_k` to `0.14` improved ensemble mean error from
`0.452` to `0.365`, but per-sample error worsened from `0.723` to `1.286` and
correct-signature frequency fell from 95% to 65%. This is evidence for the
required two-scale tradeoff, not yet a convergence demonstration.

## Verdict and next gates

The benchmark is useful. It upgrades the order-to-operator-to-metric route from
a purely verbal proposal to an executable positive calibration with a visible
mesoscopic scale window. It does not yet establish bare-order metric recovery.

Successor gates:

1. Replace embedded coordinate cutoffs with a basis-free, order-derived,
   product-controlled probe sector.
2. Pre-register a refinement schedule with `ell/L_k -> 0`, `L_k -> 0`, and
   increasing samples or an intrinsic averaging prescription.
3. Show rank four, `(+---)` signature, and count-volume agreement across a
   nontrivial scale window, not at one tuned point.
4. Repeat on curved sprinklings and compare operator, connection, and holonomy
   curvature estimators.

Kill conditions:

- no regulator-independent scale window under refinement;
- persistent dependence on the embedding-defined support shape;
- failure of signature or volume consistency after variance control;
- incompatible curvature limits from the three reconstruction routes.

Representative JSON artifacts are under `AgentTasks/` with names beginning
`causal-operator-metric-N`. They record seeds, all scales, ensemble summaries,
and convention metadata.
