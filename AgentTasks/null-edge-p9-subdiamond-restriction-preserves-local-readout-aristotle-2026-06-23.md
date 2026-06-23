# Aristotle proof job: P9 subdiamond restriction preserves local readout

```yaml
job_name: null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623
status: integrated-locally-aristotle-canceled
project_id: a46df819-3986-4fb0-a404-c441aaaf9653
task_id: 7e27b984-0f9b-4cce-a631-85911429833b
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623
submission_project: AgentTasks/aristotle-submit/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623-project
target_file: NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean
expected_check: lake env lean NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean
```

## Task

Prove the generic Class A positive T2 theorem selected by Aristotle's
positive-T2 coarse-map strategy job.

Scientific context: the banked T1 witness shows that diamond-local interval
readouts can separate finite causal relations that agree on common global
histogram diagnostics. The banked negative T2 guardrail shows that a
critical-collapse map can erase the signal. This job asks for the positive
Alexandrov/subdiamond restriction spine: subdiamonds are convex, and the local
interval readout restricted to a subdiamond agrees with measuring the
subdiamond directly.

## Target declarations

- `subdiamond_convex`
- `subdiamond_restriction_preserves_ic`
- `subdiamond_restriction_preserves_localIntervalAbundance`
- `subdiamond_restriction_preserves_localIntervalSignature`

## Claim boundary

This is finite source-visibility scaffolding. It is not a
cosmological-constant theorem and it does not prove that all coarse maps
preserve the T1 signal. It identifies one pre-specified admissible class:
Alexandrov endpoint-preserving subdiamond restriction.

## Submission note

Preflight on the standalone source file in the main repo passed with exactly
four intended proof holes:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean
```

The focused submission project was prepared with:

```text
Scripts/prepare_aristotle_focused_submission.ps1
```

The packaged-project local check attempted to clone dependencies and failed
because the new tiny Lake project had no built Mathlib oleans yet; the
generated `.lake` directory was removed before submission to keep the upload
focused. Aristotle should run the narrow check inside its own environment.

Submitted as Aristotle project `a46df819-3986-4fb0-a404-c441aaaf9653`, task
`7e27b984-0f9b-4cce-a631-85911429833b`.

## Local completion

Codex finished the four proofs locally before Aristotle returned. The theorem
cluster is integrated in:

```text
PhysicsSM/Draft/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout.lean
```

and imported by:

```text
PhysicsSMDraft.lean
```

The redundant Aristotle task was canceled to avoid spending proof budget twice
on the same finite order-theory lemma.

Verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout.lean
lake build PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout
lake env lean PhysicsSMDraft.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout.lean AgentTasks/aristotle-standalone/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout.lean AgentTasks/aristotle-standalone/null-edge-p9-subdiamond-restriction-preserves-local-readout-20260623/NullEdgeP9SubdiamondRestrictionPreservesLocalReadout/Core.lean
```

Scientific significance: this is the first positive T2 Class A result. It
proves that Alexandrov/subdiamond restriction preserves the local interval-size
readout under transitivity, giving a non-hand-tuned positive companion to the
critical-collapse erasure guardrail.
