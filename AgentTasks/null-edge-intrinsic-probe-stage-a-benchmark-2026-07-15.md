# Stage A2: intrinsic causal-order probe benchmark

## Objective

Test whether simple probe sectors constructed from a finite causal order can
replace the embedding-coordinate probes in the Stage A causal-operator metric
calibration. This is an external numerical oracle, not a proof.

The experiment is implemented in:

```text
Scripts/experiments/causal_intrinsic_probe_metric.py
Scripts/experiments/test_causal_intrinsic_probe_metric.py
```

## Construction and oracle boundary

Each realization conditionally sprinkles a four-dimensional Minkowski diamond.
Embedding coordinates choose a marked event nearest
`(0.85 * duration, 0, 0, 0)`. After that event is marked, each probe selector
uses only the finite causal relation, interval counts, supplied scales, and the
marked event. Coordinates re-enter only after selection to fit a local affine
Jacobian and score the reconstructed pairing.

Three selectors were pre-registered for the final fixed-scale sweep:

1. `profile_pca`: the leading four predecessor/successor incidence-profile
   modes in a profile-distance window with inner/outer quantiles `0.08/0.30`.
2. `operator_svd`: the four lowest right-singular modes of the full project-sign
   smeared Benincasa-Dowker operator.
3. `filtered_profile`: the profile modes smoothed by
   `(I + tau L^4 B_C^* B_C)^-1` with fixed dimensionless `tau = 0.10`.

The profile-distance window assigns equal weights to equal integer distances;
it does not break ties by event label. Probe subspaces are compared through
their orthogonal projectors, so arbitrary signs and basis rotations are gauge.

## Gate

A realization passes only if all three conditions hold simultaneously:

- pairing signature exactly `(1, 3, 0)`;
- coordinate-pulled relative metric error at most `0.50`;
- local affine probe-fit relative error at most `0.25`.

This is stricter than signature alone. A Lorentzian matrix in a probe sector
that is not locally coordinate-like, or that has the wrong metric scale and
cross terms after the fitted Jacobian is removed, is not reconstruction.

## Exact finite controls

Five unit tests pass:

- the dense all-event operator row equals the established one-target oracle;
- the profile window is equivariant under event relabeling;
- the profile-PCA subspace projector is equivariant under relabeling;
- the full operator transforms by simultaneous row/column permutation; and
- the corrected pairing obeys affine probe covariance.

Across the final samples, numerical relabeling-subspace errors are between
roughly `1e-15` and `2e-14`, and affine pairing-covariance errors are between
roughly `1e-16` and `1e-14`. Label dependence is not the cause of failure.

## Fixed-scale results

All runs use duration `1`, nonlocality scale `L = 0.18`, target-time fraction
`0.85`, and the same seed `20260715`. The table reports signature success,
median coordinate-pulled metric error, mean local affine-fit error, and the
number of full gate passes.

| Events | Realizations | Selector | Signature success | Median metric error | Mean affine-fit error | Gate passes |
|---:|---:|---|---:|---:|---:|---:|
| 400 | 20 | `profile_pca` | 20% | 2.933 | 0.153 | 0 |
| 400 | 20 | `filtered_profile` | 35% | 3.195 | 0.181 | 0 |
| 400 | 20 | `operator_svd` | 50% | 160.445 | 0.488 | 0 |
| 800 | 20 | `profile_pca` | 20% | 1.824 | 0.137 | 0 |
| 800 | 20 | `filtered_profile` | 30% | 1.835 | 0.170 | 0 |
| 800 | 20 | `operator_svd` | 35% | 141.838 | 0.597 | 0 |
| 1200 | 12 | `profile_pca` | 0% | 2.461 | 0.116 | 0 |
| 1200 | 12 | `filtered_profile` | 8.3% | 2.653 | 0.163 | 0 |
| 1200 | 12 | `operator_svd` | 33.3% | 233.218 | 0.549 | 0 |

Machine-readable outputs:

```text
AgentTasks/causal-intrinsic-probe-stage-a-n400-t085-2026-07-15.json
AgentTasks/causal-intrinsic-probe-stage-a-n800-t085-2026-07-15.json
AgentTasks/causal-intrinsic-probe-stage-a-n1200-t085-2026-07-15.json
```

## Verdict

**Kill result for these selectors.** None of the 52 realizations passes the
joint prototype gate. Increasing density does not produce a stable Lorentzian
signature or a decreasing metric error at fixed `L`.

The failure modes are diagnostic:

- Profile PCA becomes more locally affine with density, reaching mean fit
  error `0.116` at `N = 1200`, but its corrected pairing does not approach the
  fitted Minkowski metric. Small non-affine residuals are amplified by the
  second-order operator.
- The normal-operator filter does not repair that mismatch at fixed
  `tau = 0.10`; stronger exploratory smoothing improved neither metric error
  nor affine quality jointly.
- Raw low singular modes are poorly coordinate-like and have enormous pulled
  metric errors. Their mean selected/unselected spectral gap also shrinks from
  about `0.102` at `N = 400` to `0.038` at `N = 1200`, so the four-mode boundary
  is becoming less isolated rather than more stable.

This does **not** kill the corrected causal-operator metric architecture. The
embedding-coordinate Stage A benchmark already shows that the operator pairing
can recover the target metric over a finite scale window. It kills the naive
claim that incidence-profile PCA, raw lowest singular modes, or their simplest
normal-operator smoothing automatically supply the required intrinsic probe
sector.

## Next admissible selector

The next prototype must include the structure these failures omit:

1. an intrinsic interior/boundary projector using two-sided causal abundance,
   not symmetric profile proximity alone;
2. a retarded-support condition ensuring the selected sector is sampled by the
   operator row at the marked event;
3. stability of a four-dimensional **subspace cluster** across a mesoscopic
   scale interval, rather than selecting the four lowest individual modes;
4. a graph-Sobolev or product-closure penalty measured by the same causal
   operator used in the pairing; and
5. a held-out product-rule score, so selector tuning cannot optimize directly
   against embedding coordinates or the target metric.

A promising formulation is a constrained generalized eigenspace of a filtered
normal operator on an intrinsically selected interior region, followed by a
pre-registered stability test across adjacent scales. It should not be
formalized as the physical probe sector until it first passes this numerical
gate.

The existing named-probe interface is itself now known to be too rigid on
symmetric orders. `IntrinsicProbeSector.probe_constant_of_automorphismTransitive`
proves that individual naturality makes every probe constant on each
automorphism orbit, with the two-event antichain as an explicit transitive
witness. The successor Lean object must therefore encode an equivariant
subspace or projector whose basis may rotate, not four pointwise-fixed scalar
functions.

## Stage A3 update

The proposed interior/support falsification has now been run and is recorded in
`AgentTasks/null-edge-intrinsic-probe-stage-a3-support-benchmark-2026-07-15.md`.
It confirms that all three selectors have zero support-gate passes on the best
order-side availability tuple. It also finds that the proposed largest
adjacent scale has no two-sided interior anywhere in the finite-density
development scan. The generalized eigensolver is therefore deferred until an
order-side available adjacent scale window is demonstrated.

## Verification

```text
cd Scripts/experiments
python -m unittest test_causal_intrinsic_probe_metric.py
python causal_intrinsic_probe_metric.py --events 400 --realizations 20 --nonlocality-scale 0.18 --target-time-fraction 0.85 --filter-strength 0.10
python causal_intrinsic_probe_metric.py --events 800 --realizations 20 --nonlocality-scale 0.18 --target-time-fraction 0.85 --filter-strength 0.10
python causal_intrinsic_probe_metric.py --events 1200 --realizations 12 --nonlocality-scale 0.18 --target-time-fraction 0.85 --filter-strength 0.10
```
