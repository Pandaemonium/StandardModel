# Aristotle: commutator corner invisibility

Prove that the zero-offset exact group-commutator regulator is the identity
whenever either phase sine vanishes (under the matching involution/circle
hypotheses), that finite products remain invisible at cubic sign corners, and
that the existing rational quarter-turn fixture is nevertheless nontrivial.

```yaml
aristotle:
  project_id: 8936c334-fe51-48a0-8fdc-1a1a6613ad37
  task_id: 97a83d9e-04a2-4983-af01-2827b367a443
  target_file: CommutatorCorner/CornerInvisibility.lean
  expected_module: CommutatorCorner.CornerInvisibility
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-commutator-corner-invisibility-20260711-project
  output_dir: AgentTasks/aristotle-output/8936c334-fe51-48a0-8fdc-1a1a6613ad37
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Integration

All seven theorem signatures were preserved. Promoted as
`PhysicsSM.Draft.NullEdge.CommutatorCornerInvisibility`; direct Lean and
targeted build pass. The result proves the zero-sine and cubic-corner collapse,
finite-product closure, and a nontrivial quarter-turn control. The stronger
affine/pi-periodicity successor remains separately in flight.
