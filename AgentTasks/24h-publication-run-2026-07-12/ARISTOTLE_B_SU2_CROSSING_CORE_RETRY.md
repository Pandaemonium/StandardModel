# Aristotle retry: exact SU(2) crossing core

The first full-project task reached the two-hour stall limit without solving a
declaration.  This retry isolates only the two load-bearing `2 x 2` matrix
theorems in a Mathlib-only package.  The family-preimage corollaries and exact
negative controls will be composed locally after this core lands.

Success requires both theorem signatures to remain unchanged.  Determinant-one
unitarity must lock a zero of `det(U-I)` to `U=I`, and a zero of `det(U+I)` to
`U=-I`.

```yaml
aristotle:
  project_id: 9060adfd-4338-4717-bd85-02780e93b741
  task_id: e277a759-de91-4538-8a40-03861dd76a5e
  target_file: SU2CrossingCore/Main.lean
  expected_module: SU2CrossingCore.Main
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-su2-crossing-core-20260711-project
  output_dir: AgentTasks/aristotle-output/9060adfd-4338-4717-bd85-02780e93b741
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Run `lake env lean SU2CrossingCore/Main.lean` first.  Do not run a broad build
before closing both proof holes.

## Integrated result

Both core theorem signatures were preserved exactly.  The returned proof adds
a private structural lemma for determinant-one unitary `2 x 2` matrices and
uses exact entrywise algebra.  The extracted target passed an independent local
Lean check before integration.

The live module `PhysicsSM/Draft/NullEdge/SU2CrossingLocking.lean` also lands:

- the zero- and pi-crossing set equalities for arbitrary Bloch families;
- a determinant-minus-one unitary with a `+1` crossing but not identity;
- its sign-reversed `-1` crossing control.

Direct live Lean and the targeted 8,027-job build passed.  Local and aggregate
pins use the standard footprint `[propext, Classical.choice, Quot.sound]`.
