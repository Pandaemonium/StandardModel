# Aristotle proof job: P9 operational visibility gap

```yaml
job_name: null-edge-p9-operational-gap-20260623
status: integrated
project_id: 9beafa4e-1932-4276-8aeb-59bea669c6ac
task_id: 87d5fc11-bb04-4c75-9a76-cb5673faa476
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-operational-gap-20260623
submission_project: AgentTasks/aristotle-submit/null-edge-p9-operational-gap-20260623-project
target_file: NullEdgeP9OperationalGap/Core.lean
expected_module: NullEdgeP9OperationalGap.Core
expected_check: lake env lean NullEdgeP9OperationalGap/Core.lean
integrated_module: PhysicsSM.Draft.NullEdgeP9OperationalGap
```

## Physics context

- Program lane / paper: P9 source visibility and the cosmological-constant
  guardrail program.
- Four-layer status: exact finite identity. This does not prove a scaling law
  or a cosmological interpretation.
- Why this theorem matters physically: the banked T1 witness proves that a
  diamond-local interval-size signature separates two finite causal relations
  even when common global histogram diagnostics match. This job packages the
  separation as an explicit observer-channel readout gap.
- What would weaken or falsify the interpretation: if the gap is defined
  post-hoc from the answer, or if later admissible coarse maps erase it without
  a pre-specified preservation class, the result is only a finite witness.
- Relevant conventions or sources: finite causal relations on `Fin 6`, local
  closed diamonds, and local interval-size signatures from
  `NullEdgeP9DiamondLocalSeparation`.

## Task

Close the proof holes in the focused standalone Mathlib package:

```text
NullEdgeP9OperationalGap/Core.lean
```

Do not change definitions or theorem statements unless a statement is
mathematically false, and report any such issue explicitly.

## Target declarations

- `natGap_zero_left`
- `t1_localSignature_gap_at_one`
- `t1_localSignature_distinguishable_threshold_one`
- `t1_localSignature_distinguishable_threshold_two`

## Completion report requested

Please end with:

```text
Completion report:
- solved targets:
- unchanged theorem statements? yes/no, list changes:
- remaining proof holes:
- assumptions or escape hatches used:
- suggested next theorem:
- suggested next physics/context check:
- suggested literature or convention check:
- highest-risk remaining gap:
```

## Integration note

Aristotle completed all four target proofs. Codex adapted the returned proof to
the repo's ASCII Lean style and integrated it as:

```text
PhysicsSM.Draft.NullEdgeP9OperationalGap
```

Verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-operational-gap-20260623/NullEdgeP9OperationalGap/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP9OperationalGap.lean
lake build PhysicsSM.Draft.NullEdgeP9OperationalGap
lake env lean PhysicsSMDraft.lean
```

Scientific significance: this turns the T1 diamond-local separation witness
into an explicit operational readout gap. It is still a finite identity, not a
coarse-map stability theorem or cosmological-constant result.
