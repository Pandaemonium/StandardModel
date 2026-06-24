# Aristotle task: P9 stochastic exact-recovery gap preservation

```yaml
job_name: null-edge-p9-stochastic-exact-recovery-gap-20260623
status: integrated-reviewed
project_id: ebd742af-00c2-45eb-9bf1-51e775195ed4
task_id: 6417d07e-520e-4db9-adf7-08e258f4de66
target_file: NullEdgeP9StochasticExactRecoveryGap/Core.lean
expected_module: NullEdgeP9StochasticExactRecoveryGap.Core
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-gap-20260623
submission_project: AgentTasks/aristotle-submit/null-edge-p9-stochastic-exact-recovery-gap-20260623-project
```

## Task

Fill the proof hole in the focused standalone Lean file:

```text
AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-gap-20260623/NullEdgeP9StochasticExactRecoveryGap/Core.lean
```

Physics context:

- Program lane / paper: P9 source visibility and admissible observer channels.
- Four-layer status: exact finite stochastic quantitative theorem. No
  approximate recovery, scaling law, cosmological-constant amplitude, or
  continuum limit is claimed.
- Why this theorem matters physically: the qualitative observable-pullback
  theorem says a fine distinction remains visible to a recovered coarse
  observer. This target sharpens the result to preservation of the numerical
  expectation gap, making the finite observer-channel language closer to
  operational source response.
- What would weaken or falsify the interpretation: if exact recovery is
  insufficient to preserve the gap as stated, or if the proof needs extra
  positivity, invertibility, or support hypotheses, report that rather than
  weakening the theorem silently.
- Relevant conventions or sources: finite Markov kernels, Blackwell
  sufficiency/comparison of experiments, data-processing equality, and Petz
  recovery as prior-art context. The Lean target is deliberately classical and
  finite.
- What this proof must not be taken to prove: it does not prove arbitrary
  coarse maps are admissible, does not prove approximate recovery, and does not
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
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-gap-20260623/NullEdgeP9StochasticExactRecoveryGap/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-gap-20260623/NullEdgeP9StochasticExactRecoveryGap/Core.lean
```

Submitted as Aristotle project `ebd742af-00c2-45eb-9bf1-51e775195ed4`, task
`6417d07e-520e-4db9-adf7-08e258f4de66`.

## Local integration while Aristotle runs

Codex locally completed and integrated the theorem as:

```text
PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryGap
```

The integrated module imports the existing stochastic exact-recovery API and
adds:

- `exactRecovery_preserves_observableGap`.

Scientific value: the exact-recovery observer-channel theorem now preserves
the numerical expectation gap, not merely a non-equality witness. This is the
stronger finite operational form of source visibility under common exact
stochastic recovery.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9StochasticExactRecoveryGap.lean
lake build PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryGap
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b|[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9StochasticExactRecoveryGap.lean
git diff --check
```

Outcome: all checks passed. Aristotle remains useful as an independent proof
check and for its requested next-step recommendations.

## Aristotle completion review

Aristotle completed project `ebd742af-00c2-45eb-9bf1-51e775195ed4`, task
`6417d07e-520e-4db9-adf7-08e258f4de66`.

Completion summary:

- solved `exactRecovery_preserves_observableGap`;
- reported unchanged theorem statement;
- reported no remaining proof holes;
- reported no added assumptions or escape hatches.

Returned code was not copied into the live repo because the already-integrated
repo module is ASCII-clean, imports the existing stochastic API, and passed
local verification.

Useful next-step advice from Aristotle:

- prove a family version using one recovery channel for a whole source family;
- prove a strictness variant showing nonzero fine gap iff the recovered coarse
  gap is nonzero;
- prove a no-go theorem showing an erased separated pair cannot be exactly
  recoverable;
- audit the same-recovery-channel semantics against Blackwell/Petz conventions.
