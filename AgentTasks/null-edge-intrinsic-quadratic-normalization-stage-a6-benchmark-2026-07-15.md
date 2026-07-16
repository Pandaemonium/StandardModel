# Stage A6: intrinsic quadratic operator normalization

## Objective

Test whether causal interval counts can fix the absolute normalization deficit
isolated by Stage A5 without fitting a scalar to the target metric.

This is an external numerical oracle with one kernel-checked algebraic anchor.
Dimension, density, interval endpoints, nonlocality scale, and compact support
remain supplied. It is not scale reconstruction from a bare order.

## Source-formula audit

The implemented smeared four-dimensional operator was rechecked against
equations (2), (8), and (9) of Benincasa and Dowker,
arXiv:1001.2725v4. The prefactor, leading `epsilon`, broad-layer polynomial,
onsite sign, and `epsilon=(ell/L)^4` all agree.

There is also a strong numerical cross-check. Benincasa and Dowker report
`sd(B1)=134.8` for `N=5000` and `L=0.16`. The earlier Stage A implementation
gave `132.5` under the same density and scale. A missing overall coefficient is
therefore unlikely to explain the Stage A5 normalization deficit.

The source proves convergence of the *mean* under its support and slow-variation
hypotheses; it does not imply that a finite, compact-probe realization is
unbiased or concentrated at the densities tested here.

## Exact finite anchor

For centered probes `f(x)=h(x)=0`, the corrected pairing obeys

~~~text
B(f h)(x) = 2 Gamma_B(f,h)(x).
~~~

This is now kernel-checked as

~~~text
FiniteCausalOrderOperator.operator_mul_eq_two_correctedPairingAt_of_centered
~~~

with a build-enforced axiom audit. The theorem contains no convergence or
geometric claim.

For four centered coordinate probes and internal form `eta=(+---)`, their
quadratic contraction `q=eta_ab X^a X^b` should therefore satisfy

~~~text
B q = 2 eta_ab Gamma_B(X^a,X^b) -> 2d = 8.
~~~

## Order-side estimator

For each strict predecessor `y<x`, open-interval counts define

~~~text
tau_C(y,x)^2 = ((n(y,x)+2)/(rho c_4))^(1/2).
~~~

Endpoint-volume time and `tau_C` estimate the Euclidean radial distance needed
for the same compact cutoff `w` as the coordinate control. The intrinsic
quadratic probe is

~~~text
q_C(y) = tau_C(y,x)^2 w(y)^2.
~~~

The squared cutoff is required because the metric trace contracts products of
compact probes. The proposed positive normalization is

~~~text
a_C = 8 / B q_C
~~~

when `Bq_C>0`. A nonpositive or nonfinite response is a failed normalization;
the implementation never flips its sign.

The construction is relabeling-equivariant and is tested against the full
interval-count matrix. It uses no target metric value to calculate `a_C`, but
it does use supplied dimension, density, endpoints, and support.

## Frozen development result

The Stage A5 grid was reused without alteration:

~~~text
N = 5000
20 realizations
seed = 20260720
L in {0.12, 0.14, 0.16, 0.18, 0.20}
support in {0.36, 0.50, 0.65}
metric-error gate = 0.50 with signature (+---)
~~~

Selection priority was count-normalized gate rate, median count-normalized
error, aggregate count-normalized error, then the deterministic scale/support
tie-breakers. All 15 settings had zero count-normalized gate passes. The rule
selected the best failed setting, `L=0.14` and support `0.36`.

| selected-setting quantity | development result |
|---|---:|
| raw Lorentzian-signature rate | 65% |
| raw median metric error | 0.836 |
| mean `Bq_C`, target 8 | 0.908 |
| normalization-defined rate | 50% |
| median positive factor, defined samples | 2.682 |
| normalized median error, defined samples | 1.230 |
| normalized gate-pass rate | 0% |
| aggregate factor from mean `Bq_C` | 8.811 |
| aggregate normalized error | 1.936 |

## Held-out result

The selected setting was evaluated on ten independent `N=10000` realizations
with seed `20260722`. Johnston scores were not opened because the operator
control failed.

| selected-setting quantity | held-out result |
|---|---:|
| raw Lorentzian-signature rate | 60% |
| raw median metric error | 0.831 |
| mean `Bq_C`, target 8 | 0.858 |
| normalization-defined rate | 70% |
| median positive factor, defined samples | 4.980 |
| normalized median error, defined samples | 1.032 |
| normalized gate-pass rate | 0% |
| aggregate factor from mean `Bq_C` | 9.325 |
| aggregate normalized error | 2.152 |

The response does not approach eight from `N=5000` to `N=10000`, its
fluctuations remain large, and applying its factor worsens both per-sample and
aggregate metric errors.

Machine-readable outputs are:

~~~text
AgentTasks/causal-intrinsic-quadratic-normalization-stage-a6-development-n5000-2026-07-15.json
AgentTasks/causal-intrinsic-quadratic-normalization-stage-a6-heldout-control-n10000-2026-07-15.json
~~~

## Verdict

**Kill this particular normalization estimator.** Endpoint-volume time plus
single-interval proper-time estimates do not provide a sufficiently accurate
compact quadratic probe at the tested densities. The response is frequently
nonpositive and is severely biased even when positive. It must not be used to
renormalize the causal operator or to claim count-volume consistency.

**Do not kill the exact quadratic-moment architecture.** The centered-product
identity is exact and kernel-checked. A successor would need a demonstrably
consistent order-derived quadratic probe, probably with mesoscopic regression
or moment fitting rather than a pointwise square root of one noisy interval
count.

## Next decision

The next admissible normalization study should first estimate the quadratic
field and its uncertainty independently of `B`. It must pass held-out
proper-time and radial-distance calibration before its operator response is
opened. Candidate routes are:

1. regress interval volume over a mesoscopic neighborhood rather than using
   one interval count per event;
2. fit the quadratic moment jointly from an overcomplete Johnston lightcone
   chart while keeping its internal basis gauge;
3. test an asymptotic schedule with fixed `L/ell` and increasing physical
   support, so boundary bias and discreteness bias are separately visible.

No curved benchmark should use a normalization that fails this flat held-out
control.

Stage A7 executed the overcomplete-chart successor. Its independently validated
Johnston quadratic is retained, while its single-row trace normalization is
killed. See
`AgentTasks/null-edge-johnston-quadratic-normalization-stage-a7-benchmark-2026-07-15.md`.

## Verification commands

~~~text
lake env lean PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean
cd Scripts/experiments
python -m unittest test_causal_operator_metric.py test_causal_johnston_probe_metric.py test_causal_johnston_operator_control_scan.py
python -m ruff check causal_operator_metric.py causal_johnston_probe_metric.py causal_johnston_operator_control_scan.py test_causal_operator_metric.py test_causal_johnston_probe_metric.py test_causal_johnston_operator_control_scan.py
python causal_johnston_operator_control_scan.py --events 5000 --realizations 20 --selection-mode count_normalized --include-samples
python causal_johnston_operator_control_scan.py --events 10000 --realizations 10 --nonlocality-scales 0.14 --support-radii 0.36 --selection-mode count_normalized --seed 20260722 --include-samples
~~~
