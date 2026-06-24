# Aristotle task: P9 stochastic erasure is not exactly recoverable

```yaml
job_name: null-edge-p9-stochastic-erasure-not-recoverable-20260623
status: integrated-reviewed
project_id: 65561c72-4f30-468c-9193-e25290d8ea79
task_id: 742a157e-e016-4db6-b941-0db89b32ddbf
target_file: NullEdgeP9StochasticErasureNotRecoverable/Core.lean
expected_module: NullEdgeP9StochasticErasureNotRecoverable.Core
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-stochastic-erasure-not-recoverable-20260623
submission_project: AgentTasks/aristotle-submit/null-edge-p9-stochastic-erasure-not-recoverable-20260623-project
```

## Task

Fill the proof hole in the focused standalone Lean file:

```text
AgentTasks/aristotle-standalone/null-edge-p9-stochastic-erasure-not-recoverable-20260623/NullEdgeP9StochasticErasureNotRecoverable/Core.lean
```

Physics context:

- Program lane / paper: P9 source visibility and admissible observer channels.
- Four-layer status: exact finite stochastic no-go theorem. No approximate
  recovery, scaling law, cosmological-constant amplitude, or continuum limit is
  claimed.
- Why this theorem matters physically: P9 has concrete erasing coarse-map
  counterexamples. Exact stochastic recovery is useful only if it excludes
  those erasures. This target proves the basic exclusion: if two genuinely
  distinct fine sources become identical after the observer channel, then no
  common exact recovery can restore both.
- What would weaken or falsify the interpretation: if identical coarse outputs
  can still be exactly recovered as two distinct sources under the stated
  definitions, the admissible-channel story is broken and should be reported.
- Relevant conventions or sources: finite Markov kernels, Blackwell
  sufficiency/comparison of experiments, data-processing equality, and Petz
  recovery as prior-art context. The Lean target is deliberately classical and
  finite.
- What this proof must not be taken to prove: it does not characterize all
  nonrecoverable maps, does not prove approximate no-go bounds, and does not
  establish a cosmological source-suppression mechanism.

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
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-erasure-not-recoverable-20260623/NullEdgeP9StochasticErasureNotRecoverable/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-stochastic-erasure-not-recoverable-20260623/NullEdgeP9StochasticErasureNotRecoverable/Core.lean
```

Submitted as Aristotle project `65561c72-4f30-468c-9193-e25290d8ea79`, task
`742a157e-e016-4db6-b941-0db89b32ddbf`.

## Local integration while Aristotle runs

Codex locally completed and integrated the theorem as:

```text
PhysicsSM.Draft.NullEdgeP9StochasticErasureNotRecoverable
```

The integrated module imports the existing stochastic exact-recovery API and
adds:

- `erased_pair_not_exactRecoverable`.

Scientific value: exact stochastic recovery now excludes fully erased separated
source pairs. This directly fences the admissible observer-channel class against
the known P9 erasing-map counterexamples.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9StochasticErasureNotRecoverable.lean
lake build PhysicsSM.Draft.NullEdgeP9StochasticErasureNotRecoverable
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b|[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9StochasticErasureNotRecoverable.lean
git diff --check
```

Outcome: all checks passed. Aristotle remains useful as an independent proof
check and for its requested next-step recommendations.

## Aristotle completion review

Aristotle completed project `65561c72-4f30-468c-9193-e25290d8ea79`, task
`742a157e-e016-4db6-b941-0db89b32ddbf`.

Completion summary:

- solved `erased_pair_not_exactRecoverable`;
- reported unchanged theorem statement;
- reported no remaining proof holes;
- reported no added assumptions or escape hatches;
- reported only standard Lean axioms for the proof.

Returned code was not copied into the live repo because the already-integrated
repo module is ASCII-clean, imports the existing stochastic API, and passed
local verification.

Useful next-step advice from Aristotle:

- build an explicit two-source erasing-channel example and discharge
  nonrecoverability through this theorem;
- add a positive sharpness example where separated coarse outputs do admit a
  recovery;
- develop approximate versions only after introducing a metric/quantitative
  deficiency notion.
