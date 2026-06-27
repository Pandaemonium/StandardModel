# Null-edge integration-freeze wave review

Date: 2026-06-26.

Scope: review of the integrated integration-freeze wave artifacts:

- `AgentTasks/aristotle-wave-integration-triage.md`
- `AgentTasks/null-edge-job-dependency-dag.md`
- `AgentTasks/null-edge-conventions-integration-audit.md`
- `AgentTasks/null-edge-trusted-theorem-promotion-policy.md`
- `AgentTasks/null-edge-sign-normalization-dashboard.md`
- `Sources/Null_Edge_P1_Formal_Revision_Plan.md`
- `AgentTasks/null-edge-branch-count-acceptance-criteria.md`
- `AgentTasks/null-edge-specificity-audit.md`
- `AgentTasks/null-edge-branch-script-report.md`

## Executive findings

The returned artifacts are coherent and useful. They do not ask us to expand
broadly; they ask us to narrow the next launch wave around gates and promotion
discipline.

Main conclusions:

- The returned corpus is mutually consistent on the core convention spine:
  mostly-minus signature, dual-soldered architecture, separated gradings,
  `D = iD_N + Gamma_s Phi_H`, `+Phi_H^2` under `[Gamma_s, Phi_H] = 0`, and
  no double-counting.
- A verification gap remains: some proof reports describe kernel-clean
  `PhysicsSM/Draft/*.lean` files, but the triage notes that trusted promotion
  still requires checking live statements, proof cleanliness, and semantic
  alignment.
- Gate A remains unresolved in Lean. The sign audit is strong as a written
  specification, but the positive and wrong-grading theorem/counterexample pair
  should be formalized before finite square theorems are promoted.
- Gate B ordering is now strict: `B0 -> B1 -> B3 -> B2 -> B4`.
- Gate C is a serious kill-switch risk. The flat tetrahedral retarded branch
  script/protocol finds high-momentum determinant-zero/null branch candidates,
  a positive-dimensional null variety on real torus samples, and pervasive
  complex-energy branch risks. This blocks no-doubling, heavy continuum, and
  chirality claims until interpreted and either cured or downgraded.
- Krein `J`-self-adjointness remains hygiene only. It should be paired with a
  finite counterexample showing it does not imply real spectrum or stability.
- P1 can and should be made review-safe independently of P1.5/P2.

## Next wave selected

The next Aristotle wave should not be broad continuum work. It should target:

1. Live verification/semantic review of returned proof files.
2. Gate A sign theorem and wrong-grading counterexamples.
3. Kinetic naming and mass-shell normalization.
4. Gate B foundation: `NullSolderFrame`, simplex/tetrahedral frame,
   inverse-Gram, diagonal trace obstruction.
5. Gate C branch-count interpretation and formal high-momentum branch theorem.
6. Krein double self-adjointness plus counterexample.

Jobs not launched in this wave:

- Heavy Gate D continuum proofs.
- Prediction/codimension claims.
- QCD theorem jobs.
- FMS Lean theorem until the corrected composite is reflected in conventions
  and the FMS audit is fully integrated.
