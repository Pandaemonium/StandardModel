# NullStrand Next Aristotle Wave - 2026-06-25

Purpose: submit a broad non-duplicate follow-up wave after the completed
NullStrand overnight wave.  These jobs target remaining G1-G3 theorem islands
and the two live holonomy handoffs.

Source of truth:
- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Sources/NullStrand_Lean_Theorem_Manifest_Improved.csv`
- `AgentTasks/null-strand-overnight-ledger-2026-06-25.md`

Submission rule: focused standalone packages unless the target genuinely needs
the full `PhysicsSM` import graph.  Each package should typecheck locally with
only intended proof holes before submission.

## Planned jobs

| job | lane | target |
|---|---|---|
| nullstrand-holonomy-exp-20260625 | HOL-002/HOL-003 | Matrix exponential unitarity and conjugation/gauge covariance |
| nullstrand-flux-variance-20260625 | KIN-007 | Finite weighted variance identity for unit directions |
| nullstrand-massratio-20260625 | KIN-008 | Algebraic mass-ratio substitution |
| nullstrand-two-state-coupling-20260625 | ZZ-005 | Unique minimal two-state positive coupling |
| nullstrand-lap-range-20260625 | LA-002 | Connected graph Laplacian range equals zero-sum subspace |
| nullstrand-sync-order-20260625 | SYNC-001/002 | Kernel commutator equals order-independent action on all laws |
| nullstrand-fock-compose-20260625 | BELL/Fock | Composition of marginal-preserving finite Fock lifts |
| nullstrand-ent-separable-marginal-20260625 | ENT-003 | Separable finite product law has probability marginals |
| nullstrand-stochastic-iterate-20260625 | TRAJ/MASTER | Iterated finite stochastic pushforward preserves probability |
| nullstrand-graph-support-powers-20260625 | GRAPH | Matrix support powers lie in relation powers |

## Submitted projects

| project_id | job | status |
|---|---|---|
| a804a29b-03f2-4cb2-a489-f3de02a15cec | nullstrand-holonomy-exp-20260625 | INTEGRATED_STANDALONE_AND_LIVE |
| 04eff080-e82b-4978-8dcf-61330375717c | nullstrand-flux-variance-20260625 | INTEGRATED_STANDALONE |
| ca3eacd0-5125-42fc-9056-0a4a760d02de | nullstrand-massratio-20260625 | INTEGRATED_STANDALONE |
| 57e9a2b6-3427-498c-9e0e-7aa32a9e8bf2 | nullstrand-two-state-coupling-20260625 | INTEGRATED_STANDALONE |
| f1faeb2b-5c8e-4a91-85b2-fc8273d224de | nullstrand-lap-range-20260625 | INTEGRATED_STANDALONE |
| 6febbcf2-668b-4cc8-9fe1-7f30af9d3fb2 | nullstrand-sync-order-20260625 | INTEGRATED_STANDALONE |
| c61a4690-76f3-48ea-bb58-69a5a05e887b | nullstrand-fock-compose-20260625 | INTEGRATED_STANDALONE |
| 2b88d95e-f5cc-4ad9-928c-a5145233f1a5 | nullstrand-ent-separable-marginal-20260625 | INTEGRATED_STANDALONE |
| 37cfc84c-6bb6-4fe8-9097-103bf0f7defa | nullstrand-stochastic-iterate-20260625 | INTEGRATED_STANDALONE |
| 6fdb344b-92a5-4460-9dae-2a95df0c347b | nullstrand-graph-support-powers-20260625 | INTEGRATED_STANDALONE |

## Local checks before submission

- `lake env lean AgentTasks/aristotle-standalone/nullstrand-two-state-coupling-20260625/NullStrandTwoStateCoupling.lean`
- Serial `lake env lean` over the other nine standalone target files.
- All ten files typechecked. The only warnings were the intended proof holes in
  the standalone handoff files.

## Submission notes

- Submitted with `aristotle submit --project-dir ...` one project at a time.
- Aristotle warned for most packages that no local `.lake` checkout was bundled.
  The focused packages do include `lakefile.toml`, `lake-manifest.json`, and the
  target file; the source files were already checked under the repo's pinned
  Mathlib environment.

## Integration notes

2026-06-25 Codex integration pass:

- Downloaded Aristotle result archives for eight completed next-wave projects:
  `04eff080-e82b-4978-8dcf-61330375717c`,
  `ca3eacd0-5125-42fc-9056-0a4a760d02de`,
  `57e9a2b6-3427-498c-9e0e-7aa32a9e8bf2`,
  `6febbcf2-668b-4cc8-9fe1-7f30af9d3fb2`,
  `c61a4690-76f3-48ea-bb58-69a5a05e887b`,
  `2b88d95e-f5cc-4ad9-928c-a5145233f1a5`,
  `37cfc84c-6bb6-4fe8-9097-103bf0f7defa`, and
  `6fdb344b-92a5-4460-9dae-2a95df0c347b`.
- The CLI wrote tar archives with a `.zip` filename; extracted reviewed copies
  under `AgentTasks/aristotle-output/<project-id>/extracted-tar/`.
- Reviewed diffs against the submitted standalone files. The accepted changes
  were proof-body fills only; local docstrings were preserved where Aristotle's
  returned files converted them to ordinary block comments.
- Integrated the proofs into the eight standalone source directories under
  `AgentTasks/aristotle-standalone/`.
- `a804a29b-03f2-4cb2-a489-f3de02a15cec` and
  `f1faeb2b-5c8e-4a91-85b2-fc8273d224de` were still running at the end of this
  pass.

Verification run after integration:

- `lake env lean AgentTasks/aristotle-standalone/nullstrand-flux-variance-20260625/NullStrandFluxVariance.lean`
- `lake env lean AgentTasks/aristotle-standalone/nullstrand-massratio-20260625/NullStrandMassRatio.lean`
- `lake env lean AgentTasks/aristotle-standalone/nullstrand-two-state-coupling-20260625/NullStrandTwoStateCoupling.lean`
- `lake env lean AgentTasks/aristotle-standalone/nullstrand-sync-order-20260625/NullStrandSyncOrder.lean`
- `lake env lean AgentTasks/aristotle-standalone/nullstrand-fock-compose-20260625/NullStrandFockCompose.lean`
- `lake env lean AgentTasks/aristotle-standalone/nullstrand-ent-separable-marginal-20260625/NullStrandEntSeparable.lean`
- `lake env lean AgentTasks/aristotle-standalone/nullstrand-stochastic-iterate-20260625/NullStrandStochasticIterate.lean`
- `lake env lean AgentTasks/aristotle-standalone/nullstrand-graph-support-powers-20260625/NullStrandGraphSupportPowers.lean`
- Placeholder/escape-hatch scan over the eight integrated standalone target
  directories found no executable Lean matches.

2026-06-25 Codex second integration pass:

- Downloaded Aristotle result archives for the remaining two completed
  next-wave proof projects:
  `a804a29b-03f2-4cb2-a489-f3de02a15cec` and
  `f1faeb2b-5c8e-4a91-85b2-fc8273d224de`.
- Extracted reviewed copies under
  `AgentTasks/aristotle-output/<project-id>/extracted-tar/`.
- Integrated Aristotle's returned standalone files into:
  `AgentTasks/aristotle-standalone/nullstrand-holonomy-exp-20260625/` and
  `AgentTasks/aristotle-standalone/nullstrand-lap-range-20260625/`.
- Promoted the holonomy proof strategy into the live trusted module
  `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean`, replacing a timed-out
  one-step unitarity proof and repairing path-level gauge covariance while
  preserving the existing public theorem statements.
- The Laplacian range result remains staged in the standalone file pending a
  deliberate live-module placement decision.

Verification run after second integration:

- `lake env lean PhysicsSM/NullStrand/Clock/InternalHolonomy.lean`
- `lake env lean AgentTasks/aristotle-standalone/nullstrand-holonomy-exp-20260625/NullStrandHolonomyExp.lean`
- `lake env lean AgentTasks/aristotle-standalone/nullstrand-lap-range-20260625/NullStrandLapRange.lean`
- Placeholder/escape-hatch scan over the live holonomy module and two
  standalone target directories found no executable Lean matches.
