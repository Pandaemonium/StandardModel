# Aristotle: exact `Z2^3` scalar cover intertwiner

Fill all eight proof holes in
`codex_24h_b_z2cubed_flavour_intertwine.lean` without changing any statement.
The theorem package diagnoses the eight-sheet cover of the live successive-axis
`3+1` symbol.  Preserve the scalar-parity intertwiner, determinant zero/pi
swap, nonidentity deck witness, and half-period negative control.

Success means an exact cover census with no claim that aliases are removed.
Failure should identify a false statement or the smallest missing matrix/trig
lemma; do not weaken the physics contract silently.

```yaml
aristotle:
  project_id: fddb28cc-3bb4-4cb3-a5e3-8b504fc91f29
  task_id: 15a4a58a-92f0-4fbf-87f6-4f0c373c49cc
  target_file: AgentTasks/aristotle-targets/codex_24h_b_z2cubed_flavour_intertwine.lean
  expected_module: PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-z2cubed-flavour-intertwine-20260712-project
  output_dir: AgentTasks/aristotle-output/fddb28cc-3bb4-4cb3-a5e3-8b504fc91f29
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Harvested 2026-07-12 00:52 PDT. Aristotle preserved and proved all eight
statements. Integrated as
`PhysicsSM.Draft.NullEdge.Z2CubedFlavourIntertwine`; direct Lean and targeted
build pass. The scalar parity theorem and determinant zero/pi exchange are
exact diagnostics: the eight-sheet cover relabels all multiplicity and supplies
no internal flavour dynamics.
