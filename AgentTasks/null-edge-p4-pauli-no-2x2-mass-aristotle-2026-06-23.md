# Aristotle task: P4 Pauli no `2 x 2` mass term

```yaml
aristotle:
  project_id: a3346e59-dd7a-4760-a761-31a048aa19a6
  target_file: NullEdgeP4PauliNo2x2Mass/Core.lean
  expected_module: NullEdgeP4PauliNo2x2Mass.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p4-pauli-no-2x2-mass-20260623-project
  output_dir: AgentTasks/aristotle-output/a3346e59-dd7a-4760-a761-31a048aa19a6
  status: integrated
```

Close the proof holes without changing definitions or theorem statements.

Scientific role: prove the finite Pauli-algebra no-go that forces an actual
Dirac mass term out of a single Weyl `2 x 2` coin and into a doubled
`L plus R` space.

## Submission note

Submitted as focused Aristotle project
`a3346e59-dd7a-4760-a761-31a048aa19a6`.

## Integration note

Integrated as `PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP4PauliNo2x2Mass.lean
lake build PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP4PauliNo2x2Mass.lean
```

The theorem statements were unchanged relative to the focused package. The
placeholder scan was clean.
