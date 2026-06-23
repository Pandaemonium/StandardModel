# Aristotle task: P4 scalar flip isotropy

```yaml
aristotle:
  project_id: b6f7bbc8-2376-461d-98aa-253cda38ed21
  target_file: NullEdgeP4ScalarFlipIsotropy/Core.lean
  expected_module: NullEdgeP4ScalarFlipIsotropy.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p4-scalar-flip-isotropy-20260623-project
  output_dir: AgentTasks/aristotle-output/b6f7bbc8-2376-461d-98aa-253cda38ed21
  status: integrated
```

Close the proof holes without changing definitions or theorem statements.

Scientific role: prove the finite algebraic selection rule that an isotropic
Pauli-expanded flip generator has no vector component; the scalar part is the
candidate Dirac mass, while vector parts are anisotropic couplings.

## Submission note

Submitted as focused Aristotle project
`b6f7bbc8-2376-461d-98aa-253cda38ed21`.

## Integration note

Integrated as `PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP4ScalarFlipIsotropy.lean
lake build PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP4ScalarFlipIsotropy.lean
```

The theorem statements were unchanged relative to the focused package. The
placeholder scan was clean.
