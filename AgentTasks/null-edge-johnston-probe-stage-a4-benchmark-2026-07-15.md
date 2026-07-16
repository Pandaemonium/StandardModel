# Stage A4: Johnston interval-volume probe benchmark

## Objective

Test whether a literature-grounded interval-volume construction can replace the
failed Stage A2 spectral selectors as the probe sector for the corrected causal
operator metric. This is an external numerical oracle, not a proof.

The clean-room implementation follows the lightcone factorization in Steven
Johnston, "Embedding Causal Sets into Minkowski Spacetime," *Classical and
Quantum Gravity* 39 (2022) 095006, arXiv:2111.09331v2, especially equations
(17), (20), (22)-(28), and (32)-(40). The paper supplies both dimension and
density. This benchmark preserves those hypotheses rather than presenting the
construction as a bare-order derivation.

## Order-side construction

For supplied dimension `d`, density `rho`, and interval-volume coefficient
`c_d`, an inclusive interval count estimates proper time by

~~~text
tau(x,y)^2 = ((|I(x,y)| + 2) / (rho c_d))^(2/d).
~~~

Exact bottom and top endpoints define an intrinsic time coordinate by endpoint
polarization. A marked event's strict past and future define Johnston's
rectangular spatial-inner-product matrix. Its rank-three SVD factorization,
together with the intrinsic time coordinate, supplies four probe functions up
to spatial orthogonal gauge.

The implementation computes only the selected past-by-future interval block,
not the full all-pairs count matrix. Low-density tests prove numerical equality
with the full construction. The marked event is chosen from an invariant set
using only intrinsic endpoint time, intrinsic radius, and causal abundance.
Embedding coordinates are opened only for the local affine fit and target
metric score.

The implementation and tests are:

~~~text
Scripts/experiments/causal_johnston_probe_metric.py
Scripts/experiments/test_causal_johnston_probe_metric.py
~~~

The tests cover the four-dimensional interval coefficient, selected-block
count equality, endpoint normalization, agreement of targeted and full
factorizations, relabeling covariance of the pivot candidate set, spatial
subspace covariance, and finiteness/idempotence of the recovered projector.

## Frozen protocol

The causal operator settings are inherited from the earlier coordinate-probe
Stage A calibration rather than tuned on these results:

~~~text
duration T = 1
nonlocality scale L = 0.16
probe support radius = 0.5
maximum per-realization metric error = 0.50
maximum local affine-fit error = 0.25
minimum relative rank-three gap = 0.15
seed = 20260719
realizations = 10 per density
~~~

Three gates are kept separate:

1. The **operator control gate** uses compact coordinate probes at the same
   order-selected marked event. It requires signature `(+---)` and metric error
   at most `0.50`.
2. The **conditional-dimension gate** tests the rank-three Johnston
   factorization, treating four-dimensionality as supplied. It additionally
   requires affine-fit error at most `0.25`.
3. The **prototype gate** also requires the dominant singular-value gap to
   select spatial rank three with relative gap at least `0.15`.

## Results

| N | median affine fit | median Johnston metric error | median coordinate-oracle error | Johnston `(+---)` | operator control pass | conditional pass | rank/prototype pass |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 1,000 | 0.549 | 17.696 | 1.243 | 40% | 0% | 0% | 0% |
| 2,500 | 0.416 | 4.508 | 1.052 | 90% | 0% | 0% | 0% |
| 5,000 | 0.127 | 0.962 | 0.805 | 80% | 0% | 0% | 0% |
| 10,000 | 0.083 | 0.710 | 0.677 | 90% | 0% | 0% | 0% |

The recovered chart converges strongly in the tested density range. Its median
Jacobian condition number is `1.18` at `N=10000`, and the SVD endpoint-scale
balance residual falls from median `0.749` at `N=1000` to `0.077` at
`N=10000`. Random relabeling changes the time probe and spatial subspace only
at approximately `1e-15`; affine probe covariance is equally precise.

At high density, the reconstructed metric error tracks the coordinate control:
their `N=10000` medians differ by only `0.034`. The frozen operator control is
therefore the immediate error floor in this ensemble. The interval-volume
embedding is no longer the dominant error source at that density.

Dimension does not emerge. Across all 40 realizations, the largest relative
singular-value gap occurs only after spatial rank four or five:

| N | dominant rank 4 | dominant rank 5 | dominant rank 3 |
|---:|---:|---:|---:|
| 1,000 | 7 | 3 | 0 |
| 2,500 | 4 | 6 | 0 |
| 5,000 | 3 | 7 | 0 |
| 10,000 | 4 | 6 | 0 |

The rank-three gap itself is often substantial, but selecting it because the
target dimension is known would be circular. No threshold was changed after
opening the target metric scores.

Machine-readable outputs, including all per-realization records, are:

~~~text
AgentTasks/causal-johnston-probe-stage-a4-n1000-2026-07-15.json
AgentTasks/causal-johnston-probe-stage-a4-n2500-2026-07-15.json
AgentTasks/causal-johnston-probe-stage-a4-n5000-2026-07-15.json
AgentTasks/causal-johnston-probe-stage-a4-n10000-2026-07-15.json
~~~

## Verdict

**There is a useful result.** Johnston's interval-volume lightcone
factorization supplies a relabeling-covariant, locally affine probe chart from
causal order once dimension, density, interval endpoints, and a spatial rank
are supplied. At `N=10000`, its metric performance is close to the coordinate
oracle, so it is a credible conditional replacement for the killed Stage A2
probe selectors.

**G2 does not pass.** Absolute density remains supplied, spatial rank three is
imposed rather than selected, the dominant gap rejects rank three in every
realization, the per-realization operator control misses the frozen error gate,
and count-volume agreement has not been tested. This is a conditional chart
reconstruction, not continuum GR from a bare graph.

## Next decision

The next metric experiment should preserve the Johnston probe construction and
change only the operator-control side. First map the high-density
`(N,L,support)` window using coordinate probes at the same order-selected
events. Open Johnston scores only after a control window is frozen. In
parallel, dimension must be tested by a selector independent of the target
metric, preferably against known sprinklings of several dimensions and
nonmanifoldlike negative controls.

Weakly curved benchmarks should wait until the flat operator control passes at
the per-realization threshold. Otherwise curvature error cannot be separated
from the existing flat-space bias.

This decision was executed in Stage A5. The frozen control sweep and held-out
result are recorded in
`AgentTasks/null-edge-johnston-operator-stage-a5-benchmark-2026-07-15.md`.

## Verification commands

~~~text
cd Scripts/experiments
python -m unittest test_causal_operator_metric.py test_causal_intrinsic_probe_metric.py test_causal_johnston_probe_metric.py
python -m ruff check causal_johnston_probe_metric.py test_causal_johnston_probe_metric.py
python causal_johnston_probe_metric.py --events 1000 --realizations 10 --include-samples
python causal_johnston_probe_metric.py --events 2500 --realizations 10 --include-samples
python causal_johnston_probe_metric.py --events 5000 --realizations 10 --include-samples
python causal_johnston_probe_metric.py --events 10000 --realizations 10 --include-samples
~~~
