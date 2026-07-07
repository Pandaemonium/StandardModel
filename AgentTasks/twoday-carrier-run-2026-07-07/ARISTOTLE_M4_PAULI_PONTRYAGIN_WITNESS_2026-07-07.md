# Aristotle M4 Pauli/Pontryagin Witness Job

Submitted: 2026-07-07 02:03 PDT

```yaml
aristotle:
  project_id: 578f32e6-efb8-4cab-abd8-325b02034685
  task_id: 873b2c8c-4c49-4c77-a50d-ab2e2074e848
  target_file: null
  expected_module: null
  submission_project: AgentTasks/aristotle-submit/tc-m4-pauli-pontryagin-witness-20260707-0202
  output_dir: AgentTasks/aristotle-output/578f32e6-efb8-4cab-abd8-325b02034685
  status: complete
```

## Purpose

Focused strategy/construction job for Fable call 03's Codex-directed next
target: redo the `M4(C)` Pauli witness as a genuine Pontryagin/Krein model with
fundamental symmetry `J = rho(Gamma)` and a `kappa = 2` certificate, instead of
silently using the ordinary conjugate-transpose star.

This is ownership-safe: Codex is not editing `PhysicsSM/Draft/NullEdge/Carrier/**`
without Claude acknowledgement. The requested output is a semantic report and,
if possible, a standalone Lean skeleton that Claude/Codex can review before any
Carrier landing.

## Context Pack

- `AgentTasks/context-packs/m4-pauli-pontryagin-witness-20260707-0200-20260707-020148.md`

## Packet

- `PROMPT.md`
- `WITNESS_SATISFIABILITY.md`
- `2026-07-07-015136-fable-call-03.md`
- `CarrierKreinSquare.lean`
- `CarrierSquareAssembly.lean`
- `WeitzenbockMaster.lean`
- `CarrierPotentialTurn.lean`
- `CarrierAxiomGuard.lean`
- `NullEdgeSuperDiracKreinCore.lean`
- `THREAD_BOARD.md`
- `LEDGER.md`
- `FABLE_QUEUE.md`
- `lean-toolchain`

## Requested Output

`M4_PAULI_PONTRYAGIN_WITNESS_REPORT.md` with:

- corrected Pauli model table;
- ordinary/Krein adjoint table;
- exact Lean target statements;
- false-shape or convention warnings for the old witness note;
- recommended first landing and ownership notes;
- optional standalone Lean skeleton and typecheck status.

## Harvest

Completed: 2026-07-07 02:30 PDT.

Output harvested under:

- `AgentTasks/aristotle-output/578f32e6-efb8-4cab-abd8-325b02034685/tc-m4-pauli-pontryagin-witness-20260707-0202_aristotle/M4_PAULI_PONTRYAGIN_WITNESS_REPORT.md`
- `AgentTasks/aristotle-output/578f32e6-efb8-4cab-abd8-325b02034685/tc-m4-pauli-pontryagin-witness-20260707-0202_aristotle/CarrierGlueWitnessSkeleton.lean`

Verdict:

- The physical witness must use `J = Gamma` with `kreinSharp J X = J * X^H * J`,
  not the ordinary conjugate-transpose star.
- The gamma generators must be `i * Pauli`, so the Clifford metric has
  `g e e = -2` and off-diagonal `0`.
- The scalar potential must be real: `phi = c * I`, `c : R`, `c != 0`.
- `J = diag(1,1,-1,-1)` is a Hermitian involution with trace zero, giving
  inertia `(2,2)` and `kappa = 2`.
- The simultaneous slot witness survives the sign correction:
  `Q_A = -8 * I`, `Q_C = +8 * (sigma_z tensor sigma_z)`, and
  `Q_T = c^2 * I`.

Tracked handoff:

- `AgentTasks/twoday-carrier-run-2026-07-07/M4_PAULI_PONTRYAGIN_WITNESS_HANDOFF_2026-07-07.md`

Ownership note:

- Codex did not edit `PhysicsSM/Draft/NullEdge/Carrier/**`.
- Recommended Carrier-owned follow-up is a `kreinSharp J` restatement of
  `carrier_krein_square`, or a type synonym carrying the Krein star, followed by
  instantiation with the M4 witness.
