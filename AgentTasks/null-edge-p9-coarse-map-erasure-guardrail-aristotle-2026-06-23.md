# Aristotle focused job: P9 coarse-map erasure guardrail

```yaml
job_name: null-edge-p9-coarse-map-erasure-guardrail-20260623
status: integrated
project_id: 748e6c8d-509e-49de-b022-758c8b921ba6
task_id: 2fc5836a-227c-4fb2-939a-d1d50b9f0c7f
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-coarse-map-erasure-guardrail-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-coarse-map-erasure-guardrail-20260623-project
target_module: NullEdgeP9CoarseMapErasureGuardrail.Core
target_file: NullEdgeP9CoarseMapErasureGuardrail/Core.lean
expected_check: lake env lean NullEdgeP9CoarseMapErasureGuardrail/Core.lean
integrated_module: PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail
integrated_file: PhysicsSM/Draft/NullEdgeP9CoarseMapErasureGuardrail.lean
```

## Task

Fill the proof holes in `NullEdgeP9CoarseMapErasureGuardrail/Core.lean`
without changing definitions or theorem statements.

Scientific target: this is a T2 guardrail for the P9 source-visibility program.
The stronger T1 diamond-local witness shows a local readout can separate two
finite causal relations with matching global signatures. This file records a
countervailing fact: an explicit coarse map that collapses the critical swapped
vertices erases the separator. Coarse stability is therefore not automatic and
must be proved for any proposed observer channel.

## Targets

```lean
coarseRel_equal_implies_localSignature_equal
collapseCritical_identifies_swapped_vertices
collapseCritical_preserves_endpoints
collapseCritical_coarseRel_eq
collapseCritical_diamondCard_eq
collapseCritical_localIntervalSignature_eq
collapseCritical_erases_T1_at_one
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9CoarseMapErasureGuardrail/Core.lean
```

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission note

Local preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-coarse-map-erasure-guardrail-20260623/NullEdgeP9CoarseMapErasureGuardrail/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-coarse-map-erasure-guardrail-20260623/NullEdgeP9CoarseMapErasureGuardrail/Core.lean
```

The Lean preflight passed with exactly seven intended proof-hole warnings and
no errors. Non-ASCII scan was clean.

Prepared focused project:

```text
AgentTasks/aristotle-submit/null-edge-p9-coarse-map-erasure-guardrail-20260623-project
```

Submitted as Aristotle project `748e6c8d-509e-49de-b022-758c8b921ba6`.

## Aristotle completion

Aristotle filled all seven targets without changing definitions or theorem
statements. It reported no remaining proof holes, no added assumptions, and no
nonstandard constructs. The proof uses finite enumeration and standard Lean
tactics such as `decide`, `simp`, `fin_cases`, `convert`, and extensionality.

## Integration note

Integrated as `PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail` and
imported from `PhysicsSMDraft.lean`. The extracted Aristotle proof contained a
mojibake arrow in the final congruence helper and no final newline; the
integrated file normalizes this to ASCII and preserves the theorem statements
and definitions.

Scientific significance: this is a T2 failure-control theorem. It proves that
the T1 diamond-local separator is not automatically coarse-stable: the explicit
critical-collapse map identifies the swapped vertices and makes the coarse
relations, diamond cardinalities, and local interval signatures agree. Any
positive T2 theorem must therefore name a pre-specified admissible coarse-map
class instead of hand-tuning a preserving map.
