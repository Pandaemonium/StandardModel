# Aristotle task: P9 exact-recovery admissible coarse-map guardrail

```yaml
job_name: null-edge-p9-exact-recovery-admissible-coarse-map-20260623
status: integrated
project_id: 406f955e-dbb7-45a4-9e64-66d4ffb9cde5
task_id: e1a1b690-1250-411a-8885-9e46d1181562
target_file: NullEdgeP9ExactRecoveryAdmissibleCoarseMap/Core.lean
expected_module: NullEdgeP9ExactRecoveryAdmissibleCoarseMap.Core
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-exact-recovery-admissible-coarse-map-20260623
submission_project: AgentTasks/aristotle-submit/null-edge-p9-exact-recovery-admissible-coarse-map-20260623-project
```

## Task

Fill any proof holes or improve the proof structure in the focused standalone
Lean file:

```text
AgentTasks/aristotle-standalone/null-edge-p9-exact-recovery-admissible-coarse-map-20260623/NullEdgeP9ExactRecoveryAdmissibleCoarseMap/Core.lean
```

Physics context:

- Program lane / paper: P9 source visibility, with a bridge to the P7
  observer-channel/recoverability spine.
- Four-layer status: exact finite identity/guardrail. No dynamics,
  cosmological-constant amplitude, or continuum limit is claimed.
- Why this theorem matters physically: recent finite counterexamples show that
  unrestricted coarse maps can erase selected local source signatures. A useful
  positive P9 theorem must therefore name an admissible class. Common exact
  recovery is a constructive admissibility condition: if one recovery map
  reconstructs both source signals, the coarse map could not have erased their
  distinction.
- What would weaken or falsify the interpretation: if the result only holds for
  a tautological definition with no reusable recovery map, or if the statement
  silently assumes injectivity of the coarse map, report that. Do not promote it
  to an approximate-recovery or physical coarse-graining theorem.
- Relevant conventions or sources: classical finite observer-channel
  recoverability; P7 data-processing/Petz scaffolds; P9 noncritical
  coarse-erasure counterexample.
- What this proof must not be taken to prove: it does not characterize all safe
  coarse maps, does not show a given physical coarse-graining is recoverable,
  and does not prove that KL equality alone is sufficient under zero-support
  subtleties.

Completion report requested:

- solved targets:
- unchanged theorem statements? yes/no, list changes:
- remaining proof holes:
- assumptions or escape hatches used:
- suggested next theorem:
- suggested counterexample or no-go test:
- suggested next physics/context check:
- suggested literature or convention check:
- suggested lane priority: promote / continue / narrow / demote:
- highest-risk remaining gap:

## Submission note

Preflight on the standalone source file passed with exactly one intended proof
hole:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-exact-recovery-admissible-coarse-map-20260623/NullEdgeP9ExactRecoveryAdmissibleCoarseMap/Core.lean
```

The focused submission package was prepared with:

```text
Scripts/prepare_aristotle_focused_submission.ps1
```

Submitted as Aristotle project `406f955e-dbb7-45a4-9e64-66d4ffb9cde5`, task
`e1a1b690-1250-411a-8885-9e46d1181562`.

## Local integration while Aristotle runs

Codex also proved the target locally and integrated it as:

```text
PhysicsSM/Draft/NullEdgeP9ExactRecoveryAdmissibleCoarseMap.lean
```

Imported by:

```text
PhysicsSMDraft.lean
```

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9ExactRecoveryAdmissibleCoarseMap.lean
lake build PhysicsSM.Draft.NullEdgeP9ExactRecoveryAdmissibleCoarseMap
lake env lean PhysicsSMDraft.lean
```

When Aristotle completes, compare theorem statements and proof shape, then use
the requested next-step recommendations to decide whether to continue the
exact-recovery/admissible-map lane.

## Aristotle completion review

Aristotle completed the focused proof with the theorem statement unchanged and
no extra assumptions or escape hatches. The proof strategy matched the local
integration: destruct the common recovery map, pull the fine test back along
that recovery map, and use reconstruction of both sources to transfer
distinguishability to the coarse outputs.

The extracted Aristotle source used non-ASCII proof syntax and duplicated the
standalone namespace rather than the repo namespace, so the already-integrated
ASCII draft module remains the live source of record:

```text
PhysicsSM/Draft/NullEdgeP9ExactRecoveryAdmissibleCoarseMap.lean
```

Aristotle's useful next-step guidance:

- continue the lane;
- prove a composition lemma for recoverable/admissible channels;
- add a counterexample/no-go check matching the noncritical coarse-erasure map;
- strengthen the abstract `Channel`/`FinSignal` shell with genuine stochastic
  positivity and normalization before claiming an information-theoretic recovery
  theorem.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9ExactRecoveryAdmissibleCoarseMap.lean
lake build PhysicsSM.Draft.NullEdgeP9ExactRecoveryAdmissibleCoarseMap
lake env lean PhysicsSMDraft.lean
```
