# Aristotle task: P9 stochastic exact-recovery observable pullback

```yaml
job_name: null-edge-p9-stochastic-exact-recovery-observable-pullback-20260623
status: integrated-reviewed
project_id: 6ba5e2b1-389a-47e6-b784-d225d691868e
task_id: c88eab9e-03ff-4ac8-93a4-e99446d0f348
target_file: NullEdgeP9StochasticExactRecoveryObservablePullback/Core.lean
expected_module: NullEdgeP9StochasticExactRecoveryObservablePullback.Core
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-observable-pullback-20260623
submission_project: AgentTasks/aristotle-submit/null-edge-p9-stochastic-exact-recovery-observable-pullback-20260623-project
```

## Task

Fill the proof holes in the focused standalone Lean file:

```text
AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-observable-pullback-20260623/NullEdgeP9StochasticExactRecoveryObservablePullback/Core.lean
```

Physics context:

- Program lane / paper: P9 source visibility, with P7 observer-channel
  recoverability as the information-theoretic admissibility criterion.
- Four-layer status: exact finite stochastic theorem. No approximate recovery,
  dynamics, cosmological-constant amplitude, or continuum limit is claimed.
- Why this theorem matters physically: the algebraic exact-recovery theorem
  already proves that recoverable coarse maps preserve abstract tests. This
  target adds finite stochastic structure: normalized distributions,
  column-stochastic observer channels, and observable expectations. It is the
  next step toward making "admissible observer channel" scientifically honest.
- What would weaken or falsify the interpretation: if the stochastic hypotheses
  are insufficient for pushforward normalization, or if the observable pullback
  requires extra assumptions, report that rather than weakening the theorem.
- Relevant conventions or sources: classical finite Markov channels, P7
  data-processing/Petz scaffolds, P9 exact-recovery admissible-map guardrail.
- What this proof must not be taken to prove: it does not prove approximate
  recovery, does not prove a physical coarse map is admissible, and does not
  prove cosmological source suppression.

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

Preflight on the standalone source file passed with exactly three intended proof
holes:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-observable-pullback-20260623/NullEdgeP9StochasticExactRecoveryObservablePullback/Core.lean
```

The focused submission package was prepared with:

```text
Scripts/prepare_aristotle_focused_submission.ps1
```

Submitted as Aristotle project `6ba5e2b1-389a-47e6-b784-d225d691868e`, task
`c88eab9e-03ff-4ac8-93a4-e99446d0f348`.

## Local integration while Aristotle runs

Codex locally completed and integrated the theorem as:

```text
PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback
```

The integrated module proves:

- finite normalized distribution pushforward through a column-stochastic
  channel;
- `expect_pullbackObservable_eq_expect_recovered`;
- `exactRecovery_pullsBack_distinguishingObservable`.

This gives P9 a finite stochastic exact-recovery guardrail: if a coarse
observer channel has a common stochastic recovery for two fine source
distributions, then every fine observable distinguishing those sources has a
coarse pulled-back observable distinguishing their coarse outputs.

Verification:

```text
lake build PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryObservablePullback
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9StochasticExactRecoveryObservablePullback.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9StochasticExactRecoveryObservablePullback.lean
git diff --check
```

Outcome: all checks passed. The first `PhysicsSMDraft.lean` check was rerun
after a parallel-build race on the new `.olean`; the rerun passed.

Aristotle remains useful as an independent proof check and for the requested
next-step recommendations.

## Aristotle completion review

Aristotle completed project `6ba5e2b1-389a-47e6-b784-d225d691868e`, task
`c88eab9e-03ff-4ac8-93a4-e99446d0f348`.

Completion summary:

- solved all three targets;
- reported unchanged theorem statements;
- reported no remaining proof holes;
- reported no added assumptions or escape hatches;
- confirmed the stochastic hypotheses are sufficient as stated.

Returned code was not copied into the live repo because it uses the standalone
namespace and Unicode Lean notation. The already-integrated ASCII repo module
remains the source of record and has passed local verification.

Useful next-step advice from Aristotle:

- prove a quantitative gap-preservation theorem:
  `expect f p - expect f q = expect g (T.apply p) - expect g (T.apply q)`;
- test that column-stochastic normalization is load-bearing by dropping
  `col_sum`;
- audit the orientation convention for observer channels and recovery maps
  against the P7 Petz/data-processing scaffold;
- continue the lane, while keeping the exact finite recovery boundary explicit.
