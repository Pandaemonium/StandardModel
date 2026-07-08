# Aristotle task - P03 nonabelian Q_C two-face obstruction

## Job

- Requested job name:
  `ne-hard-p03-qc-nonabelian-twoface-gram-obstruction-strategy-20260707`
- Lane: GateYM / `Q_C` / nonabelian closure mass
- Type: oracle/strategy/proof

```yaml
aristotle:
  project_id: 8d95b408-7e9e-43b6-8478-6bb9540545f8
  task_id: f8d5e78f-935e-412f-b0a0-50c61efe3780
  target_file: PhysicsSM/Draft/NullEdge/GateYM/QCClosureGramCheck.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.QCClosureGramCheck
  submission_project: AgentTasks/aristotle-submit/ne-hard-p03-qc-nonabelian-twoface-gram-obstruction-strategy-20260707-project
  output_dir: AgentTasks/aristotle-output/8d95b408-7e9e-43b6-8478-6bb9540545f8
  status: submitted
```

## Context

The scalar/unitary and finite matrix Gram-normalization facts are landed in
`QCClosureGramCheck.lean`.  The hard open question is the carrier-side
nonabelian/operator `Q_C` factorization in the concrete Weitzenbock
normalization.

Fable proposes an oracle-first witness ladder:

1. one square face with SU(2)-style transports,
2. two faces sharing an edge,
3. compute the Gram part and obstruction remainder.

Pro's correction: numeric probes may scout, but any sign/positivity result must
come with an exact or symbolic certificate.

## Target

Design and, if feasible, implement the smallest exact nonabelian witness that
decides one of:

```text
Q_C = L^# L,
Q_C = sum_f J_f^# J_f + R with R positive semidefinite,
Q_C = sum_f J_f^# J_f + R with R indefinite.
```

For each witness, record:

- the exact `Q_C` matrix,
- the candidate Gram part,
- the exact remainder `R`,
- the sign certificate for `R`,
- whether the adjoint is Hilbert or Krein.

Prefer Gaussian-rational / Pauli-type exact unitary matrices over floating
fixtures.

## Desired output

- A Lean patch if the witness can be kernelized.
- Otherwise, an exact oracle plan plus concrete matrices and the theorem
  statements to submit next.
- Do not allow the nonabelian result to collapse into the already-landed
  abelian/unitary normalization.

## Required patch layer

Use:

- `AgentTasks/twoday-carrier-run-2026-07-07/FABLE_HANDOFF_HARDEST_PIECES.md`,
- `AgentTasks/twoday-carrier-run-2026-07-07/ARISTOTLE_HARDEST_PIECES_PRO_PATCHES_2026-07-07.md`.
