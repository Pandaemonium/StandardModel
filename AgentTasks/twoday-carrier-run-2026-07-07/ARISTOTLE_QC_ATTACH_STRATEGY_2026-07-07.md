# Aristotle QC Attachment Strategy Job

Submitted: 2026-07-07 00:51 PDT

```yaml
aristotle:
  project_id: f4e21d1c-0c93-4d9f-8754-3c4759603c80
  task_id: 8068bd6e-e126-4ca8-a7f3-82b94d8657fd
  target_file: null
  expected_module: null
  submission_project: AgentTasks/aristotle-submit/tc-qc-attach-strategy-20260707-0051
  output_dir: AgentTasks/aristotle-output/f4e21d1c-0c93-4d9f-8754-3c4759603c80
  status: queued
```

## Purpose

Focused strategy job for the next QC layer after Codex landed
`PhysicsSM/Draft/NullEdge/GateYM/QCCarrierBridge.lean`.

Question: can the distinguished observable in
`QCCarrierBridge.LeadingQCCarrierContract` be attached to the concrete Carrier
torus curvature API without claiming a measure, expectation value, nonabelian
result, or beyond-leading positivity theorem?

## Packet

- `QCCarrierBridge.lean`: exact landed bridge module.
- `WeitzenbockQC_Torus.lean`: Carrier torus curvature API, especially
  `plaquetteCurvature`, `nabla_commutator_path_difference`, and
  `mZero_iff_commute`.
- `CarrierAxiomGuard.lean`: guarded Carrier-side theorem names.
- Context pack:
  `AgentTasks/context-packs/qc-carrier-attachment-strategy-20260707-004959.md`.

The packet is strategy-only. It is not a buildable Lake project; Aristotle was
asked not to edit or prove code.

## Requested Output

Decision-forcing report:

- whether concrete attachment is meaningful now or should remain Fable-gated;
- the sharpest next Lean API shape;
- 2-4 Lean-style candidate statements;
- over-claim risks around arbitrary readouts, `mZero_iff_commute`, scalar
  `tanh beta` normalization, and nonabelian/beyond-leading claims;
- recommendation among bookkeeping structure, theorem using
  `mZero_iff_commute`, audit job, or Fable escalation.
