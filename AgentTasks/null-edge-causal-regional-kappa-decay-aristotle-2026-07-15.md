# Regional causal-operator covariance decay: Aristotle audit

```yaml
aristotle:
  project_id: 476b4880-407d-4661-9dec-48b2b3797ec3
  task_id: 37eabccb-543b-4316-9433-161b8a413cb5
  target_file: RegionalCovarianceDecayAudit.lean
  expected_module: RegionalCovarianceDecayAudit
  submission_project: AgentTasks/aristotle-submit/causal-regional-kappa-decay-20260715-project
  output_dir: AgentTasks/aristotle-output/476b4880-407d-4661-9dec-48b2b3797ec3
  status: complete and integrated 2026-07-15
```

## Objective

Determine whether the exact A44 compact retarded causal-operator estimator can
support a mathematically honest normalized cross-covariance bound
`kappa_N -> 0` despite complete atom-level read overlap, or whether a localized
bare-order-compatible successor is necessary.

This is a strategy, theorem-design, and no-go audit. The included Lean file
already proves the finite complete-dependency identity and the conditional
asymptotic endpoint. Do not weaken those statements or count them as a proof of
Poisson covariance decay.

## Current estimator

On one finite Poisson sprinkling of a four-dimensional Alexandrov diamond:

1. global past and future counts are computed for every event;
2. pivots are every event tied at or above the count-depth threshold selecting
   at least 16 deepest events;
3. for each pivot, the retarded Benincasa-Dowker row uses exact predecessor
   interval counts;
4. the smooth compact cutoff of each predecessor uses the minimum of its past
   count and its global future count;
5. polynomial probes are centered at the selected pivot and multiplied by that
   cutoff;
6. one finite continuum target is subtracted per pivot;
7. the regional observable is the equal-weight mean of selected-row residuals.

The visible polynomial support is compact. The random information flow is not:
global pivot selection and predecessor future counts make the conservative
atom read set of every selected row the whole sprinkling. The safe dependency
graph is complete.

Three fresh `N=100000` development graphs pass every frozen operator-shape
gate, but three graphs cannot estimate a population covariance upper bound.

## Required analysis

1. Define the random variables and conditioning precisely enough that a
   covariance theorem could be stated without coordinate-selected events.
2. Decide whether conditioning on the selected pivot set, count depths, or
   another sigma-algebra legitimately removes the global dependence without
   changing the physical observable.
3. Examine Poisson add-one-cost, Mecke/Poincare, stabilization, or chaos methods
   for a two-pivot covariance estimate. Track the random selector, taper, shared
   atoms, interval counts, and per-pivot target separately.
4. Give a candidate bound for
   `Cov(R_i,N, R_j,N) / sigmaSq_N`, including its dependence on density,
   nonlocality scale, pivot separation, and boundary depth. State every analytic
   assumption and the regime in which it could imply `kappa_N -> 0`.
5. If decay is not supportable for the exact estimator, provide a rigorous
   obstruction or explicit mechanism that keeps correlations order one.
6. Audit three repair families:
   - an order-derived outer Alexandrov germ with all taper and interval inputs
     computed internally;
   - independent Poisson thinning or sample splitting for anchor selection and
     row evaluation;
   - independent whole-graph replication with within-graph regional means.
7. For each repair, state whether it remains a reconstruction from a bare
   unlabeled order, whether it preserves relabeling covariance and statistical
   Lorentz invariance, and what new scale or decoration it introduces.
8. Identify the smallest next theorem and the smallest pre-registered
   experiment that can discriminate the viable routes. More simulation without
   a population estimand is not an acceptable recommendation.

## Deliverables

- `CAUSAL_REGIONAL_KAPPA_AUDIT.md` with an implement/revise/stop verdict;
- a precise informal theorem statement for the strongest defensible covariance
  result, including all hypotheses and the intended proof method;
- optional additions to `RegionalCovarianceDecayAudit.lean` only when they are
  genuinely kernel-checkable and do not replace the missing Poisson theorem by
  an assumption;
- a short list of literature results that would be required, with convention
  and applicability warnings.

Do not claim concentration, continuum GR, a bare-graph scale reconstruction,
or authorization for `N=200000` or `N=400000`.

## Context

Semantic context pack:
`AgentTasks/context-packs/causal-regional-kappa-decay-20260715-231045.md`.

The semantic index refresh immediately preceding the pack timed out after
three minutes. The pack completed using the existing index; all decisive live
source, audit, and benchmark files are included directly in the submission.

## Submission record

- The live and standalone asymptotic criteria passed the pinned Lean
  toolchain.
- The focused package initially cloned Mathlib without compiled objects. A
  cache fetch exceeded the five-minute shell window but completed the required
  `Mathlib.olean`; the subsequent narrow package check passed.
- Submitted project: `476b4880-407d-4661-9dec-48b2b3797ec3`.
- Submitted task: `37eabccb-543b-4316-9433-161b8a413cb5`.
- Initial project state: `RUNNING`; initial task state: `QUEUED`.
- Follow-up project state: `RUNNING`; task state: `IN_PROGRESS`.

## Harvest and semantic review

- Final project state: `IDLE`; task state: `COMPLETE`.
- Canonical returned audit:
  `AgentTasks/aristotle-output/476b4880-407d-4661-9dec-48b2b3797ec3/extracted/project-files.tar/causal-regional-kappa-decay-20260715-project_aristotle/CAUSAL_REGIONAL_KAPPA_AUDIT.md`.
- The returned Lean file preserves both submitted theorem statements and adds
  only the normalized covariance-from-difference definition and conditional
  limit theorem. The candidate passed the pinned Lean command with no proof
  handoffs or new assumptions.
- Those two declarations were integrated into the live standalone and
  `PhysicsSM/Draft/NullEdge/RegionalCovariance.lean`, with a build-enforced
  standard axiom guard.

The audit correctly distinguishes the implementation's fixed-`N` binomial law
from an unconditioned Poisson process and retains the random tied pivot count.
It explicitly tracks global selection, global predecessor future counts,
interval changes, taper changes, shared atoms, and per-pivot targets. No
conditioning shortcut removes those dependencies.

Its `REVISE` verdict is semantically aligned with the code. The strongest
current obstruction is conditional: a fixed number of deepest pivots should
coalesce near the continuum depth maximizer relative to the larger operator
scale. If the complete row residual is normalized-`L2` continuous under that
displacement, the newly checked identity gives `kappa_N -> 1`, not zero. The
coalescence and stochastic-continuity premises remain unproved and are not
claimed by the Lean theorem.

The recommended same-graph successor is an order-derived outer-germ score with
all information inputs internal and an order-derived separated-anchor packing.
Independent whole-graph replication remains the clean inference architecture
for the unchanged estimator. Density escalation remains deferred.
