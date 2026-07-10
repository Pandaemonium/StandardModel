# Aristotle target: finite SSB degeneracy no-go

Prove every theorem in `FiniteSSB/Core.lean` without changing definitions or
statements. Run:

```text
lake env lean FiniteSSB/Core.lean
```

Prove that a unitary symmetry commuting with a finite Hamiltonian preserves the
pure density matrix of a normalized simple eigenstate. Then close the exact
two-level negative control: a degenerate zero Hamiltonian and swap symmetry move
`e0` to the distinct ground representative `e1`.

Scientific payload: genuine spontaneous symmetry breaking requires degeneracy
and therefore a thermodynamic/refinement limit or another source of a
degenerate sector. This theorem does not construct that limit or a Higgs
potential.

Context pack:
`AgentTasks/context-packs/finite-ssb-degeneracy-nogo-20260710-20260709-221437.md`.

```yaml
aristotle:
  project_id: af7eb850-5998-430e-9e11-4e2d15ae7685
  target_file: FiniteSSB/Core.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteSSBDegeneracyNoGo
  submission_project: AgentTasks/aristotle-submit/codex-finite-ssb-degeneracy-nogo-20260710-project
  output_dir: AgentTasks/aristotle-output/af7eb850-5998-430e-9e11-4e2d15ae7685
  status: integrated and guarded 2026-07-09 23:06 PDT
```
