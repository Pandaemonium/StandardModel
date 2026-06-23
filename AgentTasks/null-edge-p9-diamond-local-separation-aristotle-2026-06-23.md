# Aristotle focused job: P9 diamond-local separation witness

```yaml
job_name: null-edge-p9-diamond-local-separation-20260623
status: integrated
project_id: 04524791-1cc4-4ccc-816d-e0d278a7e770
task_id: 347422a5-12b0-4e8e-b9b2-055f09d95ac7
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-diamond-local-separation-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-diamond-local-separation-20260623-project
target_module: NullEdgeP9DiamondLocalSeparation.Core
target_file: NullEdgeP9DiamondLocalSeparation/Core.lean
expected_check: lake env lean NullEdgeP9DiamondLocalSeparation/Core.lean
integrated_module: PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation
integrated_file: PhysicsSM/Draft/NullEdgeP9DiamondLocalSeparation.lean
```

## Task

Fill the proof holes in `NullEdgeP9DiamondLocalSeparation/Core.lean` without
changing definitions or theorem statements.

Scientific target: this is the stronger T1 witness recommended after Claude's
critique of the cheap iso-histogram target. It gives two six-point strict
transitive relations with the same joint in/out-degree signature and same
global interval-abundance signature. The chosen diamond from `0` to `4` has
the same cardinality in both relations, but its local interval-size signature
differs. This makes the separator diamond-local rather than merely a global
marginals-vs-joint statistic.

## Targets

```lean
relA_irreflexive
relA_transitive
relB_irreflexive
relB_transitive
same_jointDegreeSignature
same_intervalSignature
diamondCard_relA_0_4
diamondCard_relB_0_4
localIntervalSignature_relA_0_4_at_one
localIntervalSignature_relB_0_4_at_one
localIntervalSignature_0_4_separates
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9DiamondLocalSeparation/Core.lean
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
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-diamond-local-separation-20260623/NullEdgeP9DiamondLocalSeparation/Core.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" AgentTasks/aristotle-standalone/null-edge-p9-diamond-local-separation-20260623/NullEdgeP9DiamondLocalSeparation/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-diamond-local-separation-20260623/NullEdgeP9DiamondLocalSeparation/Core.lean
```

The Lean preflight passed with exactly eleven intended proof-hole warnings and
no other errors. Non-ASCII scan was clean.

Prepared focused project:

```text
AgentTasks/aristotle-submit/null-edge-p9-diamond-local-separation-20260623-project
```

Submitted as Aristotle project `04524791-1cc4-4ccc-816d-e0d278a7e770`, task
`347422a5-12b0-4e8e-b9b2-055f09d95ac7`.

## Aristotle completion

Aristotle filled all eleven targets without changing definitions or theorem
statements. The final proofs are finite enumeration/cardinality proofs using
`decide`, `Finset.filter_congr_decidable`, and the two explicit local interval
cardinality calculations. Aristotle reported no remaining proof holes, no
nonstandard assumptions, and only standard kernel axioms for theorem
inspection.

## Integration note

Integrated as `PhysicsSM.Draft.NullEdgeP9DiamondLocalSeparation` and imported
from `PhysicsSMDraft.lean`. The extracted Aristotle proof used Unicode logical
symbols in two local helper statements; the integrated module normalizes those
proof bodies to ASCII without changing the theorem statements or definitions.

Scientific significance: this is the first genuinely useful finite T1 witness
for the P9 iso-histogram gate. Unlike the cheap marginals-vs-joint witness, it
matches joint in/out-degree and global interval-abundance signatures while a
same-size local diamond readout separates the two relations. It still needs T2
coarse-map stability and T3 noise robustness before it can carry
source-visibility physics.
