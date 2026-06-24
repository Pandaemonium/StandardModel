# Aristotle task: P9 noncritical coarse-erasure counterexample

```yaml
job_name: null-edge-p9-noncritical-coarse-erasure-20260623
status: integrated
project_id: fc1b0531-466f-4dec-93e6-d983f1024e56
task_id: 66649453-d495-43c1-b6d1-5c3c455a8af8
target_file: NullEdgeP9NoncriticalCoarseErasure/Core.lean
expected_module: NullEdgeP9NoncriticalCoarseErasure.Core
submission_project: AgentTasks/aristotle-submit/null-edge-p9-noncritical-coarse-erasure-20260623-project
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-noncritical-coarse-erasure-20260623
```

## Task

Fill the proof hole in the focused standalone Lean file:

```text
AgentTasks/aristotle-standalone/null-edge-p9-noncritical-coarse-erasure-20260623/NullEdgeP9NoncriticalCoarseErasure/Core.lean
```

Physics context:

- Program lane / paper: P9 source visibility and coarse-map stability.
- Four-layer status: finite counterexample target; no dynamics or cosmology is
  claimed.
- Why this theorem matters physically: it tests a tempting universality claim
  that operational-gap erasure happens exactly when a coarse map collapses the
  critical swapped pair. A finite search found a noncritical erasing map. If
  proved, P9 must use a named admissible coarse-map class rather than
  unrestricted surjective maps.
- What would weaken or falsify the interpretation: if the theorem statement is
  convention-mismatched or the finite search result was wrong, do not weaken the
  theorem; report the counterexample failure.
- Relevant conventions: finite labelled six-point witness; bucket `1` local
  interval signature; induced existential coarse relation on `Fin 5`.

Completion report requested:

- solved targets:
- unchanged theorem statements? yes/no, list changes:
- remaining proof holes:
- assumptions or escape hatches used:
- suggested next theorem:
- suggested next physics/context check:
- suggested literature or convention check:
- highest-risk remaining gap:

## Submission note

Submitted as Aristotle project `fc1b0531-466f-4dec-93e6-d983f1024e56`, task
`66649453-d495-43c1-b6d1-5c3c455a8af8`.

## Completion review

Aristotle solved the focused proof without changing theorem statements.

Output:

```text
AgentTasks/aristotle-output/fc1b0531-466f-4dec-93e6-d983f1024e56/null-edge-p9-noncritical-coarse-erasure-20260623-project_aristotle/NullEdgeP9NoncriticalCoarseErasure/Core.lean
```

Integrated as:

```text
PhysicsSM/Draft/NullEdgeP9NoncriticalCoarseErasure.lean
```

Main result:

- `nonCriticalErasingMap_erases_bucket_one`
- `nonCriticalErasingMap_is_noncritical_erasure`

Scientific role: this is a finite negative guardrail for the P9 coarse-map
story. The map `0,1,2,3,4,5 |-> 0,1,2,3,3,4` is surjective and keeps the
critical swapped pair `1,2` distinct, but it still erases the bucket-one local
signature after taking induced coarse relations. Therefore unrestricted
surjective coarse maps do not support the tempting "erasure iff critical-pair
collapse" claim; P9 must name an admissible coarse-map class.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9NoncriticalCoarseErasure.lean
```
