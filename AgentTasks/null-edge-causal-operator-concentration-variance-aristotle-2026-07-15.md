# Causal operator concentration and variance: Aristotle hostile audit

```yaml
aristotle:
  project_id: bcefd810-9c50-479d-a8b3-d5c1eef964c7
  task_id: ca4c46ee-501c-417c-8fde-0194006a6836
  target_file: CausalOperatorConcentrationAudit.lean
  expected_module: CausalOperatorConcentrationAudit
  submission_project: AgentTasks/aristotle-submit/causal-operator-concentration-variance-20260715-project
  output_dir: AgentTasks/aristotle-output/bcefd810-9c50-479d-a8b3-d5c1eef964c7
  status: integrated 2026-07-15
```

## Objective

Derive or sharply bound the finite-density variance and concentration schedule
for the one-row four-dimensional smeared causal-set operator after A41c passed
its deterministic continuum moment gate and A42 failed every held-out discrete
field/metric stratum. Decide whether the next informative experiment should
use substantially smaller `ell/L`, mesoscopic averaging over marked pivots,
finite-binomial target corrections, a modified taper, or a no-go result for
pointwise one-row reconstruction.

The goal is not to rescue A42. Its settings and failed verdict are frozen.

Semantic context pack:

```text
AgentTasks/context-packs/causal-operator-concentration-variance-20260715-20260715-192947.md
```

The preceding semantic-index refresh failed with a Neo4j uniqueness collision
for GR-note chunk zero. The context-pack read query nevertheless completed.
The decisive source files and artifacts are included directly in the package.

## Exact operator convention

For microscopic discreteness length `ell`, nonlocality scale `L`, and
`epsilon=(ell/L)^4`, the source-sign row is

```text
prefactor = 4/(sqrt(6) L^2)
row(y<x) = prefactor * epsilon * f(n(y,x),epsilon)
row(x)   = -prefactor
```

The project `(+---)` convention multiplies this row by `-1`. The broad-layer
kernel is

```text
f(n,e)=(1-e)^n [1-9en/(1-e)
  +8e^2 n(n-1)/(1-e)^2
  -(4/3)e^3 n(n-1)(n-2)/(1-e)^3].
```

If `N` is Poisson with mean `lambda`, its exact mean is

```text
E f(N,e)=exp(-e lambda) P(e lambda),
P(z)=1-9z+8z^2-(4/3)z^3.
```

The finite operator uses interval counts from the same sprinkling, so terms at
different predecessors are dependent. The cutoff is also random: it is a
smooth function of two-sided strict-order counts with deterministic endpoint
values.

## Positive A41c result

Segmented continuum quadrature on both frozen tapered germs converges without
any scalar, drift, rank-one, or potential correction. At `L/R=0.065`, both
profiles have metric error about `0.03`, principal-symbol mismatch below
`0.03`, and Lorentzian signature. Every low/high quadrature comparison passes.

A41d supplies quadrature-certified finite targets at `L/R=0.20,0.16`. Their
finite boundary bias is retained in the targets and is not the A42 failure.

## Negative A42 result

The held-out split uses seed `20261470`, `N=5000,10000,20000`, four
realizations per density, both cutoff profiles, and both scales. At `N=20000`:

| cutoff | `L/R` | `ell/L` | field error | metric error | `Delta_ps` difference | signature rate |
|---|---:|---:|---:|---:|---:|---:|
| primary | 0.20 | 0.51 | 3.65 | 0.47 | 0.40 | 0.50 |
| primary | 0.16 | 0.63 | 4.83 | 1.15 | 0.12 | 0.25 |
| robustness | 0.20 | 0.51 | 4.16 | 0.31 | 0.24 | 1.00 |
| robustness | 0.16 | 0.63 | 5.60 | 0.66 | 0.16 | 0.25 |

All coefficient, endpoint-cutoff, relabeling, and `ell<L` checks pass. Every
field and metric gate fails. Median individual field errors at high density
range from `4.47` to `120.40`, much larger than four-run ensemble-mean errors.
The effective kernel counts `(L/ell)^4` are only about `15.3` and `6.3`.

## Locked constraints

1. Do not change, reinterpret, or average away the A42 failure.
2. Use one count-normalized retarded operator; do not introduce an independent
   fitted metric correction.
3. The outer marked interval and positive scales may be supplied explicitly,
   but no embedding coordinate may choose weights, strata, or samples.
4. Treat interval-count dependence, endpoint conditioning, and random cutoff
   depth explicitly. An independent-Poisson approximation must be labeled.
5. Distinguish convergence of the ensemble mean, convergence after local
   spatial averaging, convergence in probability at one pivot, and almost-sure
   convergence.
6. Preserve the two-scale hierarchy `ell << L << R`; explain which limit is
   taken first or how a joint schedule is chosen.
7. No curvature, intrinsic algebra, or continuum-GR claim may be opened until
   the finite operator moments concentrate.
8. Any proposed numerical threshold and seed split must be frozen before the
   next data are generated.

## Required audit

1. Run `lake env lean CausalOperatorConcentrationAudit.lean` first and report
   the result.
2. Derive the one-term second moment of the broad-layer kernel under a Poisson
   interval-count model. Give the exact finite sum, a closed form if possible,
   and its small-`epsilon` asymptotics after the operator prefactors.
3. Analyze covariance between contributions at two predecessors. State what
   can be exact from Poisson-process geometry and what needs a bound or
   simulation.
4. Separate four variance sources: kernel cancellation, finite-binomial versus
   Poisson counts, random order-depth taper, and shared-sprinkling covariance.
5. Determine the scaling of field-response and `Gamma`/metric variance with
   `ell/L`, number of averaged pivots, overlap fraction, and germ volume.
6. Decide whether pointwise one-row concentration is feasible in the joint
   limit. If not, formulate the strongest honest averaged observable.
7. Use the A42 values to estimate a defensible lower bound on effective kernel
   count and/or number of independent germs for the next experiment. Include
   computational cost estimates for naive and reusable-count algorithms.
8. Audit whether A42 should compare with the Poisson continuum target or an
   exact finite-binomial expectation first. Quantify the expected correction.
9. Preregister one smallest decisive successor with development, validation,
   held-out seeds, densities, `L/R`, averaging rule, thresholds, negative
   controls, and kill conditions. Do not choose a grid by target-error search.
10. Give Lean-facing definitions and theorem statements for exact Poisson
    kernel moments, scale reciprocity, variance decomposition, and any
    conditional concentration theorem, with all hypotheses visible.

## Required report

Return `ARISTOTLE_SUMMARY.md` and
`CAUSAL_OPERATOR_CONCENTRATION_VARIANCE_AUDIT.md` containing:

- the Lean command result;
- exact calculations and clearly labeled approximations;
- a variance-source ledger;
- a verdict on pointwise versus averaged reconstruction;
- one frozen successor protocol with cost and kill conditions;
- proposed Lean declarations; and
- a final decision: implement, revise, or stop.

Do not claim continuum GR. End with a concise completion report listing any
assumption not derived from strict order and counts.

## Submission record

- The standalone source passed
  `lake env lean AgentTasks/aristotle-standalone/causal-operator-concentration-variance-20260715/CausalOperatorConcentrationAudit.lean`.
- The focused package passed the required command
  `lake env lean CausalOperatorConcentrationAudit.lean` after fetching the
  pinned Mathlib cache.
- The package scan found no proof-hole, extra-assumption, or unsafe-code tokens.
- Submitted project: `bcefd810-9c50-479d-a8b3-d5c1eef964c7`.
- Submitted task: `ca4c46ee-501c-417c-8fde-0194006a6836`.
- Initial task state: `QUEUED`; first follow-up state: `IN_PROGRESS`.

## Live derivation update

While the task was running, the live A41 source was extended with the exact
Poisson second moment of the broad-layer factor. In the falling-factorial
basis, the product identity

```text
(N)_i (N)_j = sum_k binom(i,k) binom(j,k) k! (N)_(i+j-k)
```

reduces the second moment to a finite degree-six polynomial times
`exp(lambda*((1-epsilon)^2-1))`. At fixed `z=epsilon*lambda`, symbolic
expansion gives

```text
Var f(N,epsilon)
  = epsilon*exp(-2z)*z*(4z^3-36z^2+75z-30)^2/9
    + O(epsilon^2).
```

The closed formula agrees with a direct Poisson sum in the live unit tests.
An `instruct` continuation sent this result to the running Aristotle task
without assuming away shared-predecessor covariance or random-taper noise.
The attempted file upload was rejected because Aristotle accepts new files
only while a project is idle; the text instruction succeeded.

## Live status update

At approximately 40 minutes, the project remained `RUNNING` and task
`ca4c46ee-501c-417c-8fde-0194006a6836` remained `IN_PROGRESS`. A
`continue --mode ask --wait` request for an exact-formula and successor-impact
summary timed out locally after 49 seconds with no response; it did not cancel
or redirect the task. The live program has meanwhile opened an explicitly
competing intrinsic-local-operator branch, but no conclusion from that branch
is supplied to or attributed to Aristotle before its audit is harvested.

## Provisional 70-minute snapshot review

An in-progress snapshot now contains both requested reports and an expanded
Lean file. The task still reports `IN_PROGRESS`, so this is not yet the final
harvest.

Findings retained:

- the exact Poisson second moment and fixed-`z` leading variance agree with the
  live independent derivation;
- finite-binomial one-kernel corrections are orders of magnitude smaller than
  the A42 field errors and cannot rescue the failed schedule;
- the whole-row law must retain random-atom diagonal noise, random taper depth,
  and shared-sprinkling covariance;
- a pointwise convergence statement remains conditional on a total
  `O(epsilon/L^4)` variance bound;
- `N=400000` at `L/R=0.20` gives the first nominal
  `(L/ell)^4 >= 256` scale, but a dense causal bit matrix is already about
  20 GB before overhead.

Items not adopted verbatim:

- the proposed 256 pivots are sampled from a continuum central subinterval,
  whereas A44 requires the order-only tied count-depth selector now
  implemented in the live tree;
- the `N=400000` run is not authorized before an algorithmic prototype proves
  the stated memory/runtime cap;
- the supplied conditional Chebyshev theorem does not expose positive
  `mEff` and nonnegative `sigma2` hypotheses despite the report saying those
  hypotheses are visible;
- the six-field planning bound is dominated by the constant channel, while
  the corrected metric cancels scalar multiplication potentials exactly, so
  operator and metric scheduling must be reported separately.

An `instruct` continuation asked Aristotle to stop expanding scope and finalize
the already-written reports. The integration below preserves the exact
falling-factorial theorem and covariance guidance after correcting the
positivity and selector semantics locally.

## Final harvest and integration

- Project `bcefd810-9c50-479d-a8b3-d5c1eef964c7` is `IDLE`.
- Original task `ca4c46ee-501c-417c-8fde-0194006a6836` is `COMPLETE`.
- Finalization task `3b83385f-9cf0-4fde-97d3-5304da40b2d1` is `COMPLETE`.
- The clean extraction is under
  `AgentTasks/aristotle-output-final-clean/bcefd810-9c50-479d-a8b3-d5c1eef964c7/`.
- The falling-factorial product proof was integrated into
  `PhysicsSM/Draft/NullEdge/CausalOperatorKernelMoments.lean` and passes Lean.
- The conditional Chebyshev theorem was integrated with explicit hypotheses
  `0 <= sigmaSq` and `0 < mEff`; the proof term uses both hypotheses.
- The Poisson and finite-binomial expressions remain formula definitions, not
  claims that a finite causal row has either probability law.
- The coordinate-selected 256-pivot proposal and unprototyped `N=400000` run
  were not adopted. A44 requires the order-only tied-depth selector and a
  reusable-count resource prototype first.

The integration preserves the exact finite algebra and the useful covariance
diagnosis without promoting the still-unproved total-variance bound.
