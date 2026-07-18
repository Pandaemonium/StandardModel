# Aristotle job: bare-graph permutation-projector no-go

Date: 2026-07-16  
Work item: `GRAV-GROWING-ATLAS-001`

```yaml
aristotle:
  project_id: f523fa23-14ad-4bdb-b5f7-f35a6cb6b47c
  task_id: 8ab43627-8e0c-4a2b-b512-5b7ff62e77ff
  target_file: PermutationProjectorNoGo/PermutationProjectorNoGo.lean
  expected_module: PermutationProjectorNoGo.PermutationProjectorNoGo
  submission_project: AgentTasks/aristotle-submit/bare-graph-permutation-projector-no-go-20260716-project
  source_root: AgentTasks/aristotle-standalone/bare-graph-permutation-projector-no-go-20260716
  output_dir: AgentTasks/aristotle-output/f523fa23-14ad-4bdb-b5f7-f35a6cb6b47c
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/BareGraphPermutationProjectorNoGo.lean
```

## Exact target

Prove that a fully permutation-equivariant idempotent on the natural real
vertex-probe module `Fin n -> Real` cannot have range finrank four when
`6 <= n`. Preserve the definition and theorem statement exactly. Small private
classification lemmas are welcome.

The intended proof classifies the commutant of the natural permutation
representation. Equivariance makes all diagonal matrix coefficients equal and
all off-diagonal coefficients equal. Equivalently, the module splits into the
constant line and the zero-sum sector. Idempotency selects either, both, or
neither, so the only possible range dimensions are `0`, `1`, `n - 1`, and `n`;
none is four for `n >= 6`.

## Scientific purpose and boundary

The graph-native rank-four projector is the principal open G2 bridge in the
general-relativity program. Complete and edgeless graphs have the full
permutation group as automorphisms. This theorem would show that a universal
canonical selector on scalar vertex probes cannot return rank four on those
fully symmetric bare graphs. A physical reconstruction must therefore restrict
the graph class, derive symmetry-breaking local structure, add equivariant
decorations, or use a richer probe representation.

This is a scoped no-canonicity theorem. It does not rule out rank-four
projectors on generic asymmetric graphs, decorated graphs, edge probes,
spin-frame probes, or other representations.

## Constraints

- Do not weaken full equivariance, idempotency, exact finrank, or `6 <= n`.
- Do not add self-adjointness, positivity, a chosen basis, or an explicit
  two-parameter commutant hypothesis to the public theorem.
- Do not add assumptions or replace the conclusion by a scalar surrogate.
- Use kernel-checked tactics only; no compiled evaluator or escape hatches.
- Finish with solved targets, statement changes, remaining proof holes, and
  assumptions used.

## Context

- Semantic context pack:
  `AgentTasks/context-packs/bare-graph-permutation-projector-no-go-20260716-130011.md`.
- Mathlib provides the natural permutation representation API, linear-map
  ranges and finrank, trace, matrices, and idempotent range/kernel lemmas. The
  focused statement defines its coordinate action explicitly so no project
  import is required.

## Submission

Submitted project `f523fa23-14ad-4bdb-b5f7-f35a6cb6b47c`, task
`8ab43627-8e0c-4a2b-b512-5b7ff62e77ff`, after the standalone file passed
`lake env lean` with exactly its one intended proof-hole warning.

At 2026-07-16 13:25 PDT, a nonredirecting `continue --mode ask --wait`
requested the exact preserved-statement status, completed classification
lemmas, remaining Lean blocker, and whether to keep waiting or split. The local
CLI wait timed out after 124 seconds without a response; the task remained
`IN_PROGRESS`. No instruction or resubmission followed, so the original proof
search continues unchanged.

## Harvest and integration

Aristotle completed the original theorem without changing the permutation
action, equivariance hypothesis, idempotency hypothesis, bound `6 <= n`, or
exact range-finrank conclusion. The proof derives a common diagonal and
off-diagonal coefficient, decomposes the scalar vertex module into constant
and zero-sum sectors, uses idempotency to restrict both sector eigenvalues to
zero or one, and excludes rank four from the resulting dimensions
`0`, `1`, `n - 1`, and `n`.

The proof was integrated into
`PhysicsSM/Draft/NullEdge/BareGraphPermutationProjectorNoGo.lean`. Local
cleanup removed unused simplifier arguments and normalized two ring goals; the
public statement and proof architecture are unchanged.

Verification:

- returned candidate: direct `lake env lean` passes with no proof holes;
- integrated target: direct `lake env lean` passes cleanly;
- `lake build PhysicsSM.Draft.NullEdge.BareGraphPermutationProjectorNoGo`
  passes (`8034` jobs);
- Lean MCP source/axiom audit is clean and reports only `propext`,
  `Classical.choice`, and `Quot.sound`;
- the integrated module carries a build-enforced axiom guard.

## Independent semantic review

Claude independently replayed the kernel check and audited statement identity,
the two-parameter commutant reduction, all four range cases, the sharp `n = 5`
control, and the graph-facing scope. Verdict: **APPROVED, no revisions**.

Review artifact:
`AutonomousLab/reviews/CLAUDE_REVIEW_PERMUTATION_PROJECTOR_NOGO_2026-07-16.md`.
