# Aristotle focused job: P9 iso-histogram separation witness

```yaml
job_name: null-edge-p9-isohistogram-separation-20260623
status: integrated
project_id: 66f5c60f-a1db-4764-8e42-8ff665ebd271
task_id: a3bf2e9e-8627-4563-b79a-ac6735521231
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-isohistogram-separation-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-isohistogram-separation-20260623-project
target_module: NullEdgeP9IsohistogramSeparation.Core
target_file: NullEdgeP9IsohistogramSeparation/Core.lean
expected_check: lake env lean NullEdgeP9IsohistogramSeparation/Core.lean
integrated_module: PhysicsSM.Draft.NullEdgeP9IsohistogramSeparation
integrated_file: PhysicsSM/Draft/NullEdgeP9IsohistogramSeparation.lean
```

## Task

Fill the proof holes in `NullEdgeP9IsohistogramSeparation/Core.lean` without
changing definitions or theorem statements.

Scientific target: this is the first finite witness for the P9
iso-histogram-separation gate. It gives two five-point strict transitive
relations with the same out-degree signature, same in-degree signature, and
same interval-abundance signature, but a frozen joint in/out-degree readout
separates them. The point is not that this readout is the final P9 observer
channel; the point is that common intrinsic histograms are incomplete, so a
real P9 readout must be specified and tested against null controls.

## Targets

```lean
relA_irreflexive
relA_transitive
relB_irreflexive
relB_transitive
same_outDegreeSignature
same_inDegreeSignature
same_intervalSignature
jointReadout21_relA
jointReadout21_relB
jointReadout21_separates
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9IsohistogramSeparation/Core.lean
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
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-isohistogram-separation-20260623/NullEdgeP9IsohistogramSeparation/Core.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" AgentTasks/aristotle-standalone/null-edge-p9-isohistogram-separation-20260623/NullEdgeP9IsohistogramSeparation/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-isohistogram-separation-20260623/NullEdgeP9IsohistogramSeparation/Core.lean
```

The Lean preflight passed with exactly ten intended proof-hole warnings and no
other errors. Non-ASCII scan was clean.

Prepared focused project:

```text
AgentTasks/aristotle-submit/null-edge-p9-isohistogram-separation-20260623-project
```

Submitted as Aristotle project `66f5c60f-a1db-4764-8e42-8ff665ebd271`, task
`a3bf2e9e-8627-4563-b79a-ac6735521231`.

## Aristotle completion

Aristotle filled all ten targets without changing the definitions or theorem
statements. The final proof bodies are finite enumeration proofs using
`decide`, `fin_cases`, `funext`, and unfolding of the local predicates. No
escape hatches or nonstandard assumptions were reported.

## Integration note

Integrated as `PhysicsSM.Draft.NullEdgeP9IsohistogramSeparation` and imported
from `PhysicsSMDraft.lean`.

Scientific significance: this is a useful but deliberately low-weight P9
sanity witness. It proves that matching separate in-degree, out-degree, and
interval-abundance histograms is not enough to determine a frozen joint readout.
It should not be advertised as a source-visibility theorem by itself. The next
load-bearing target is the stronger diamond-local separation witness with
matched joint degree and interval signatures.
