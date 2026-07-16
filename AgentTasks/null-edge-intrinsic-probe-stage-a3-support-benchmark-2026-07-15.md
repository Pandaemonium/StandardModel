# Stage A3: intrinsic interior and retarded-support audit

## Objective

Test the highest-information follow-up to the failed Stage A2 intrinsic probe
selectors: do their bad directions fail an exact two-sided interior and
retarded-support gate? This is an external numerical oracle, not a proof.

The audit follows the recommended metric-first program. It does not add a new
GR-shaped finite identity. It asks whether the existing finite causal operator
has an order-only probe sector with enough local retarded support to make metric
reconstruction plausible.

## Order-only construction

For selector scale `s`, discreteness scale `ell`, and
`nu_s = (s / ell)^4`, the experiment defines:

```text
Past_s(v)   = number of u < v with a_I nu_s <= n(u,v)+1 <= b_I nu_s
Future_s(v) = number of v < w with a_I nu_s <= n(v,w)+1 <= b_I nu_s
I_s(v)      = 1 when both counts are at least q_I nu_s
R_s(x)      = {y < x | I_s(y)=1 and
                         a_R nu_s <= n(y,x)+1 <= b_R nu_s}
```

For every four-probe subspace, support and operator-row coverage are the
minimum generalized Rayleigh quotients over all nonconstant probe
combinations. A zero or rank-deficient denominator is a failure. The frozen
thresholds are support coverage at least `0.80` and row coverage at least
`0.70`.

The implementation and tests are:

```text
Scripts/experiments/causal_interior_support_scan.py
Scripts/experiments/causal_intrinsic_probe_metric.py
Scripts/experiments/test_causal_intrinsic_probe_metric.py
```

## Development grid

The order-only scan evaluates all 32 proposed tuples:

```text
s/L in {0.75, 1.00, 1.25, 1.50}
[a_I,b_I] in {[0.5,2], [1,4]}
q_I in {0.25, 0.50}
[a_R,b_R] in {[0.5,4], [1,4]}
```

It uses 10 independent sprinklings at each of `N = 400, 800, 1200` and
evaluates every event in every nonempty two-sided interior. No embedding
coordinate, target metric, signature, or affine-fit score enters this scan.
All attempted tuples, including failures, are archived in:

```text
AgentTasks/causal-intrinsic-probe-stage-a3-order-grid-2026-07-15.json
```

The best availability tuple at every density is
`s/L = 0.75`, `[a_I,b_I] = [0.5,2]`, `q_I = 0.25`, and
`[a_R,b_R] = [0.5,4]`:

| N | interior marks | shell nonempty | shell has at least 4 points |
|---:|---:|---:|---:|
| 400 | 3,116 | 69.5% | 47.7% |
| 800 | 3,523 | 32.9% | 20.7% |
| 1200 | 6,443 | 44.8% | 31.6% |

The maximum four-point-shell rate over all tuples falls to `8.9%`, `0%`, and
`0%` at `s/L = 1` for `N = 400, 800, 1200`. It is zero at every larger scale.
In particular, `s/L = 1.5` has no two-sided interior in any of the 30 scanned
development sprinklings. The proposed rule of sampling a mark from the
largest-scale interior and requiring a stable adjacent-scale cluster therefore
cannot be run on this finite-density development set as stated.

This is a protocol-level finite-density failure. It is not an asymptotic no-go
for two-sided interiors.

## Existing-selector coverage test

The best order-side tuple was then frozen. One marked event was sampled
uniformly from its two-sided interior in each realization. The mark and all
coverage quantities were selected without embedding coordinates. Coordinates
were opened only afterward for the already established external metric scores.

The three Stage A2 selectors were retested on 20, 20, and 12 independent
realizations at `N = 400, 800, 1200`:

| N | selector | shell >= 4 rate | median support | support pass | row pass | joint order-side pass |
|---:|---|---:|---:|---:|---:|---:|
| 400 | `profile_pca` | 40.0% | 0 | 0% | 5% | 0% |
| 400 | `filtered_profile` | 40.0% | 0 | 0% | 5% | 0% |
| 400 | `operator_svd` | 40.0% | 0 | 0% | 0% | 0% |
| 800 | `profile_pca` | 15.0% | 0 | 0% | 0% | 0% |
| 800 | `filtered_profile` | 15.0% | 0 | 0% | 0% | 0% |
| 800 | `operator_svd` | 15.0% | 0 | 0% | 0% | 0% |
| 1200 | `profile_pca` | 8.3% | 0 | 0% | 0% | 0% |
| 1200 | `filtered_profile` | 8.3% | 0 | 0% | 0% | 0% |
| 1200 | `operator_svd` | 8.3% | 0 | 0% | 0% | 0% |

Machine-readable outputs:

```text
AgentTasks/causal-intrinsic-probe-stage-a3-coverage-n400-2026-07-15.json
AgentTasks/causal-intrinsic-probe-stage-a3-coverage-n800-2026-07-15.json
AgentTasks/causal-intrinsic-probe-stage-a3-coverage-n1200-2026-07-15.json
```

Every selector fails support coverage even when some sampled shells contain at
least four points. This distinguishes the result from a merely empty-shell
artifact. The exact failure mode anticipated by the design audit is present:
global profile variance, normal smoothing, and global low singular energy do
not ensure that every selected direction is visible in the local retarded
operator row.

## Verdict

**The Stage A2 selector kill is confirmed and strengthened.** None of the three
selectors should be repaired by changing only a filter strength or choosing a
more favorable marked event. Their four-dimensional subspaces fail the
pre-registered order-side support gate before target-metric quality is
considered.

**Do not launch the proposed generalized-cluster eigensolver under the current
adjacent-scale protocol yet.** Its largest-scale interior is absent throughout
this development set, so rank and projector stability across
`s/L = 0.75, 1, 1.25, 1.5` cannot be meaningfully scored. Implementing the
eigensolver now would conceal an earlier availability failure.

This does not kill the corrected causal-operator metric architecture. The
coordinate-probe Stage A result still shows that the operator pairing can carry
the target metric over a finite scale window. The open problem is narrower and
clearer: construct an intrinsic, basis-free subspace whose scale window is
order-side available and whose directions have retarded support.

## Next decision

The next numerical work should change only one pre-registered element at a
time, using order-side development scores only:

1. test a finite-volume-aware interior normalization or a larger causal
   diamond so an adjacent-scale interior exists;
2. test whether the viable scale interval widens with density before opening
   any target-metric score;
3. only then solve the basis-free generalized cluster problem, with rank
   emerging from a frozen spectral gap and no four-vector truncation.

If no adjacent scale window develops under density refinement, stop this
interior-projector route. If a window does develop, retarded coverage remains a
hard gate before signature or metric error is inspected.

## Verification commands

```text
cd Scripts/experiments
python -m unittest test_causal_intrinsic_probe_metric.py
python -m py_compile causal_interior_support_scan.py causal_intrinsic_probe_metric.py
python causal_interior_support_scan.py --realizations 10
python causal_intrinsic_probe_metric.py --events 400 --realizations 20 --nonlocality-scale 0.18 --target-selection intrinsic_interior --selector-scale-ratio 0.75 --filter-strength 0.10
python causal_intrinsic_probe_metric.py --events 800 --realizations 20 --nonlocality-scale 0.18 --target-selection intrinsic_interior --selector-scale-ratio 0.75 --filter-strength 0.10
python causal_intrinsic_probe_metric.py --events 1200 --realizations 12 --nonlocality-scale 0.18 --target-selection intrinsic_interior --selector-scale-ratio 0.75 --filter-strength 0.10
```
