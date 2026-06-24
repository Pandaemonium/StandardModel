# Aristotle task: P9 stochastic exact-recovery composition

```yaml
job_name: null-edge-p9-stochastic-exact-recovery-composition-20260623
status: integrated-reviewed
project_id: 53d2e069-8b2e-4478-8c25-53282f26b36b
task_id: 5a59d5b0-8bc2-4edc-9c9c-3979aae1cdb0
target_file: NullEdgeP9StochasticExactRecoveryComposition/Core.lean
expected_module: NullEdgeP9StochasticExactRecoveryComposition.Core
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-composition-20260623
submission_project: AgentTasks/aristotle-submit/null-edge-p9-stochastic-exact-recovery-composition-20260623-project
```

## Task

Fill the proof holes in the focused standalone Lean file:

```text
AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-composition-20260623/NullEdgeP9StochasticExactRecoveryComposition/Core.lean
```

Physics context:

- Program lane / paper: P9 source visibility and admissible observer channels.
- Four-layer status: exact finite stochastic identity/closure theorem. No
  scaling law, approximate recovery, cosmological-constant amplitude, or
  continuum limit is claimed.
- Why this theorem matters physically: P9 now has erasing coarse-map
  counterexamples and one positive exact-recovery admissibility certificate. To
  be useful as an observer-channel class, exact stochastic recoverability must
  be stable under composing observer channels. This theorem asks for that
  closure property on a fixed source pair.
- What would weaken or falsify the interpretation: if exact recovery does not
  compose under the stated source-independent stochastic hypotheses, or if the
  proof needs a hidden invertibility/support assumption, report the issue
  instead of weakening the theorem silently.
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

Preflight on the standalone source file passed with exactly two intended proof
holes:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-composition-20260623/NullEdgeP9StochasticExactRecoveryComposition/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-stochastic-exact-recovery-composition-20260623/NullEdgeP9StochasticExactRecoveryComposition/Core.lean
```

Spark/Pasteur literature triage judged the composition theorem scientifically
meaningful rather than mere bookkeeping, because it is the closure property
needed for a usable admissible observer-channel class. Missing source candidates
to consider later: Blackwell comparison of experiments, Le Cam/Torgersen
randomization, and a direct Petz/data-processing equality reference.

Submitted as Aristotle project `53d2e069-8b2e-4478-8c25-53282f26b36b`, task
`5a59d5b0-8bc2-4edc-9c9c-3979aae1cdb0`.

## Local integration while Aristotle runs

Codex locally completed and integrated the theorem as:

```text
PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryComposition
```

The integrated module imports the existing stochastic exact-recovery API and
adds:

- `FinDist.ext`;
- `Stoch.comp`;
- `Stoch.apply_comp`;
- `PairExactRecoverable.comp`.

Scientific value: exact stochastic recovery is now closed under composition on
the selected source pair. This makes exact recovery a structurally usable
sufficient class of admissible P9 observer channels, rather than a one-off
certificate.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9StochasticExactRecoveryComposition.lean
lake build PhysicsSM.Draft.NullEdgeP9StochasticExactRecoveryComposition
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b|[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9StochasticExactRecoveryComposition.lean
git diff --check
```

Outcome: all checks passed. Aristotle remains useful as an independent proof
check and for its requested next-step recommendations.

## Aristotle completion review

Aristotle completed project `53d2e069-8b2e-4478-8c25-53282f26b36b`, task
`5a59d5b0-8bc2-4edc-9c9c-3979aae1cdb0`.

Completion summary:

- solved `Stoch.apply_comp` and `PairExactRecoverable.comp`;
- reported unchanged theorem statements;
- reported no remaining proof holes;
- reported no added assumptions or escape hatches;
- reported only standard Lean axioms for the proof.

Returned code was not copied into the live repo because the already-integrated
repo module is ASCII-clean, imports the existing stochastic API instead of
duplicating it, and passed local verification.

Useful next-step advice from Aristotle:

- prove associativity of `Stoch.comp` and n-fold/functorial composition laws;
- prove a no-go theorem that an erasing rank-deficient/support-collapsing
  channel is not `PairExactRecoverable` for a separated source pair;
- decide whether P9 needs fixed-source-pair recovery or uniform recovery over a
  family of source pairs;
- cross-check this exact-recovery notion against Blackwell sufficiency and
  data-processing equality/Petz recovery conventions.
