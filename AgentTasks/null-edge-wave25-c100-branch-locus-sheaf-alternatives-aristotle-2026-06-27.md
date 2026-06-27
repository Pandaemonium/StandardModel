# Aristotle C100: Gate C branch locus, kernel-sheaf, and release alternatives

aristotle:
  project_id: fe79fdc5-e44f-420d-bdda-8e509ea66819
  task_id: e7c5f428-3b83-4e56-a0b9-1cb14c5e4fd0
  target_file: PhysicsSM/Draft/NullEdgeBranchLocusPhysicalSectorAPI.lean
  expected_module: PhysicsSM.Draft.NullEdgeBranchLocusPhysicalSectorAPI
  submission_project: AgentTasks/aristotle-submit/null-edge-wave25-lateral-analysis-20260627-project
  output_dir: AgentTasks/aristotle-output/fe79fdc5-e44f-420d-bdda-8e509ea66819
  status: integrated
  initial_project_status: RUNNING
  initial_task_status: QUEUED
  integrated: 2026-06-27

Dependency class: Independent C1-facing design job.

Context pack:

```text
AgentTasks/context-packs/null-edge-wave25-lateral-analysis-20260627-114614.md
```

## Background

The new analysis suggests treating Gate C as a branch-index/topological problem
rather than a scalar-coefficient tuning problem. The raw branch object is:

```text
Z = { q : det D_+(q) = 0 }
```

The current program status:

- bare `D_+` has chirality-balanced branch kernels;
- known off-branch and cyclotomic zeros exist;
- scalar Wilson terms may support Gate C0 species health but cannot release C1
  chirality at the origin;
- ghost-zero safety forbids removing gauge-charged branches only by propagator
  zeros.

The lateral target is a C1 alternatives theorem or API:

```text
under locality, covariance, branch symmetry, and ghost safety, release must use
one of: boundary inflow, overlap/sign projection, controlled non-ultralocality,
matrix-valued spinor-line Wilson mass, or explicit branch involution.
```

## Requested target

Create:

```text
PhysicsSM/Draft/NullEdgeBranchLocusPhysicalSectorAPI.lean
```

or, if a useful Lean artifact is not realistic, return a Markdown report under:

```text
AgentTasks/null-edge-gate-c-branch-locus-alternatives-report.md
```

Prefer a small finite API with concrete non-implication guardrails if possible.

## Desired Lean concepts

Suggested finite/predicate API:

```lean
structure BranchLocusData where
  BranchPoint : Type
  isZero : BranchPoint -> Prop
  onPhysicalGerm : BranchPoint -> Prop
  kernelBalanced : BranchPoint -> Prop
  liftedByGap : BranchPoint -> Prop
  removedByPropagatorZero : BranchPoint -> Prop
  ghostSafe : Prop

structure PhysicalSectorReleaseData where
  branchData : BranchLocusData
  projectedKernelOneDim : Prop
  projectedChiralityAligned : Prop
  projectedKreinPositive : Prop
  inversePropagatorGapForUnwanted : Prop
  noPropagatorZeroRemoval : Prop
```

The exact names may vary. The important goal is to separate:

```text
branch-locus control
projected one-line kernel
physical chirality
Krein positivity
true inverse-propagator gap
ghost-zero safety
```

## Requested guardrails

Please prove concrete non-implications or countermodels where feasible:

- scalar branch lifting does not imply C1 chirality;
- interface/projector shape does not imply nonzero physical index;
- projected chirality does not imply ghost safety;
- true inverse-propagator gap is distinct from propagator-zero removal.

## Matrix-valued Wilson / branch involution focus

Include an explicit design slot for:

```text
T_br
Pi_bad(q)
matrix-valued spinor-line Wilson lift
```

The output should state what exact finite theorem would certify that such a
term polarizes branch lines without being a ghost-zero filter.

## Explicit non-goals

Do not claim:

- full Gate C release;
- physical overlap/domain-wall success;
- anomaly cancellation;
- locality of a nonlocal sign function unless assumed and named.

## Acceptance criteria

- Lean file compiles if a Lean artifact is created.
- No new `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or
  `u n s a f e`.
- The artifact/report must be explicitly C1-facing and must not relabel C0
  species health as Gate C release.
- End with a short alternatives table and a prioritized next theorem list.

## Integration review

Status: integrated 2026-06-27.

Integrated artifact:

```text
PhysicsSM/Draft/NullEdgeBranchLocusPhysicalSectorAPI.lean
```

Result:

- Added a self-contained C1-facing finite predicate/API module separating
  branch-locus control, one-line projected kernel data, chirality alignment,
  Krein positivity, true inverse-propagator gap, propagator-zero removal, and
  ghost safety.
- Added concrete non-implication guardrails showing that scalar branch lifting,
  projector/interface shape, and projected chirality do not by themselves supply
  the missing C1 obligations.
- Added design slots for branch-line polarization, bad-branch projectors, and
  matrix-valued spinor-line Wilson lifts.

Review notes:

- This is planning/API infrastructure. It does not prove a physical null-edge
  Gate C release.
- The useful next fork is now sharper: either construct a branch classifier /
  spinor-line polarizer satisfying the legal-polarizer clauses, or prove that
  such a classifier cannot be analytic/local/gauge-safe and must be replaced by
  overlap or domain-wall structure.
