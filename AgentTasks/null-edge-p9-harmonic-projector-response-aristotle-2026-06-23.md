# Aristotle task: P9 harmonic-projector response

```yaml
aristotle:
  project_id: dcaa53fb-7c55-441f-b56b-ded744d7e6ed
  target_file: NullEdgeP9HarmonicProjectorResponse/Core.lean
  expected_module: NullEdgeP9HarmonicProjectorResponse.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-harmonic-projector-response-20260623-project
  output_dir: AgentTasks/aristotle-output/dcaa53fb-7c55-441f-b56b-ded744d7e6ed
  status: integrated
```

Close the proof holes without changing definitions or theorem statements.

Scientific role: attach the P9 source-visibility algebra to an explicit finite
projector. Harmonic tests see only the projected source, and boundary-exact
perturbations vanish when the projector annihilates boundary sources.

## Submission note

Submitted as focused Aristotle project
`dcaa53fb-7c55-441f-b56b-ded744d7e6ed`.

## Integration note

Integrated into `PhysicsSM/Draft/NullEdgeP9HarmonicProjectorResponse.lean` and
imported by `PhysicsSMDraft.lean`. Verified with:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9HarmonicProjectorResponse.lean
lake build PhysicsSM.Draft.NullEdgeP9HarmonicProjectorResponse
lake env lean PhysicsSMDraft.lean
```
