# Intrinsic causal probe sector: Aristotle hostile design audit

```yaml
aristotle:
  project_id: e54f17ec-8b85-4f88-af96-d797cb553f3c
  task_id: 32646a07-09fe-4381-8e48-7fcdcb3b50e7
  target_file: PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
  submission_project: AgentTasks/aristotle-submit/intrinsic-probe-next-selector-20260715-project
  output_dir: AgentTasks/aristotle-output/e54f17ec-8b85-4f88-af96-d797cb553f3c
  status: completed and harvested 2026-07-15
```

## Objective

Design and hostilely audit the next intrinsic probe-sector prototype for the
causal-operator metric reconstruction after three natural order-only selectors
failed their numerical gate. Return a precise algorithm, invariance boundary,
pre-registered numerical test, and Lean-facing interface. Do not prove another
finite identity unless it reduces the actual reconstruction debt.

Semantic context pack:

```text
AgentTasks/context-packs/intrinsic-probe-next-selector-20260715-20260715-085913.md
```

Primary result to audit:

```text
AgentTasks/null-edge-intrinsic-probe-stage-a-benchmark-2026-07-15.md
```

## Current evidence

The concrete local/smeared causal operator and corrected finite-field pairing
are kernel checked. The existing `IntrinsicProbeSector` is only an interface;
it does not construct probes.

At fixed `L = 0.18`, target-time fraction `0.85`, and densities
`N = 400, 800, 1200`, the following order-only selectors produced zero full
gate passes across 52 realizations:

1. leading predecessor/successor causal-profile modes;
2. four lowest right-singular modes of the full smeared causal operator; and
3. profile modes filtered by `(I + 0.10 L^4 B_C^* B_C)^-1`.

All three are label-covariant to numerical roundoff. Their failure is metric,
signature, support, or local-affinity failure, not event-label dependence.
Profile modes become more affine with density but remain wrong under the
second-order pairing. Raw low singular modes are not coordinate-like and their
four-mode spectral boundary becomes less isolated.

## Locked constraints

1. The selector may use only the finite strict order, interval counts, a marked
   event, and explicitly supplied positive microscopic/mesoscopic scales.
2. Embedding coordinates and the target metric may be used only for held-out
   scoring. They may not choose the interior, support, modes, cluster,
   hyperparameters, signs, or basis.
3. A random sprinkling cannot canonically select a Lorentz frame. The physical
   output must be a subspace or quotient with basis changes treated as gauge.
4. Relabeling covariance is necessary but already passed; it is not evidence of
   geometric quality.
5. The retarded operator at `x` must sample enough of every selected probe's
   support. Symmetric profile proximity failed this condition in the interior.
6. Selecting the four modes that best match coordinates, signature, or metric
   is forbidden. Dimension four must be a pre-registered stable cluster test,
   not an oracle-selected truncation.
7. Hyperparameters must be dimensionless or tied to the supplied scale and
   fixed before the held-out metric score is evaluated.
8. A result is not a pass unless signature, local rank, affine/product quality,
   metric error, count-volume consistency, and stability over adjacent scales
   improve together with density.

## Required audit

1. Run only
   `lake env lean IntrinsicProbeSelectorAudit.lean`.
2. Explain why each failed selector failed and whether the observed behavior is
   expected from causal-set geometry rather than merely finite sample noise.
3. Determine whether a two-sided interior projector can be defined from past
   and future interval abundance without introducing an embedding or preferred
   frame. Give an exact finite formula.
4. Give an exact order-only retarded-support criterion at a marked event and
   explain how it avoids selecting a near-light-cone tail as a local ball.
5. Design a scale-indexed generalized eigenspace or singular-subspace problem
   whose output is a subspace cluster, not four individually ordered vectors.
   State all matrices, weights, projectors, and normalization factors.
6. Include a product-closure or graph-Sobolev score computed with held-out
   probes and the same causal operator. Prevent direct optimization against the
   target metric.
7. State a pre-registered density/scale protocol, success thresholds, and kill
   conditions. Separate development, validation, and held-out realizations.
8. Audit whether the marked event itself can be selected intrinsically. If not,
   keep it as a local evaluation argument rather than hiding the input.
9. Propose the smallest honest Lean API. Prefer an equivariant subspace or
   projector and conditional convergence theorem over a canonical basis.
10. Identify any no-go theorem that should be proved before more computation,
    especially one caused by automorphisms, Lorentz invariance, degeneracy, or
    the impossibility of canonical frame selection.
11. Rank the next three experiments by information gain and estimated cost.
12. If the proposed route still supplies the desired four-dimensional sector
    by assumption, reject it and say so explicitly.

## Required report

Return:

- command result;
- failure diagnosis for all three tested selectors;
- complete next-selector pseudocode with no embedding-dependent construction;
- invariance and no-go analysis;
- fixed numerical protocol and kill conditions;
- proposed Lean declarations and theorem signatures with every supplied input
  visible; and
- a short decision: implement, revise, or stop this route.

Do not insert proof holes into copied Lean source and do not claim continuum GR.

## Submission record

- The focused package passed `lake build PhysicsSM` with 8,029 jobs.
- The exact required command
  `lake env lean IntrinsicProbeSelectorAudit.lean` passed with exit code 0.
- Generated `.lake` dependencies and the temporary shared-cache junction were
  removed before upload.
- Submitted project: `e54f17ec-8b85-4f88-af96-d797cb553f3c`.
- Submitted task: `32646a07-09fe-4381-8e48-7fcdcb3b50e7`.
- Initial task state: `QUEUED`.

## Harvest record

- Final task state: `COMPLETE`.
- Harvested with
  `python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-intrinsic-probe-next-selector-aristotle-2026-07-15.md e54f17ec-8b85-4f88-af96-d797cb553f3c`.
- Decision: **REVISE**. Aristotle rejects promotion of any selector unless a
  basis-free rank emerges from a frozen cluster rule and all order-side,
  product, signature, affine, metric, volume, and density gates pass jointly.
- The report gives exact two-sided interior and timelike retarded-shell
  formulas, basis-independent worst-direction coverage quotients, a normalized
  generalized cluster problem, held-out product scores, a split protocol, and
  explicit kill conditions.
- It independently identifies the automorphism/basis obstruction. The live
  Lean module now contains the stronger checked named-probe consequence
  `probe_constant_of_automorphismTransitive` and an explicit two-event
  antichain witness; these were added after the submitted source snapshot and
  must not be overwritten by the zero-diff candidate archive.
- Aristotle noted that the focused upload contained only the `N = 1200` raw
  JSON. This was an upload-size choice, not a repository reproducibility gap:
  the live repo contains the `N = 400`, `800`, and `1200` fixed-scale outputs,
  all validated by JSON/pre-commit checks.
- Returned reports:
  `AgentTasks/aristotle-output/e54f17ec-8b85-4f88-af96-d797cb553f3c/extracted/project-files.tar/intrinsic-probe-next-selector-20260715-project_aristotle/ARISTOTLE_SUMMARY.md`
  and `INTRINSIC_PROBE_DESIGN_AUDIT.md` in the same directory.
