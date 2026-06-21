# Aristotle task: null-edge causal graph finite core, round 2

Date: 2026-06-20

## Goal

Continue the existing Aristotle project for the null-edge causal graph program
without requiring local integration of round 1 first.

Remote project:

```text
3b32b0fb-525d-47bf-b818-1980d1fad98d
```

Round 1 completed the initial finite core in:

```text
PhysicsSM/Draft/NullEdgeCoreAristotle.lean
```

Round 2 asks Aristotle to extend the same remote file with the next
highest-value finite theorem targets.

## Selected targets

1. **Three-edge Pluecker mass.**  Add `threeEdgeMomentum` and prove that its
   determinant is the sum of the three pairwise squared spinor wedges.  This
   is the first genuinely multi-edge visible-bundle theorem after the two-edge
   identity.
2. **Diamond curvature API.**  Add reusable laws for trivial labels, pointwise
   multiplication/inversion where feasible, and pure-gauge triviality.  These
   make the Abelian diamond defect usable as a finite curvature observable.
3. **Cochain coboundary square-zero.**  Add a cochain-side operator dual to
   the existing formal chain boundary and prove the coboundary squares to zero
   where feasible.

## Constraints

- Keep the work in `PhysicsSM.Draft`.
- Do not change completed round-1 theorem statements unless a real issue is
  discovered.
- No new `axiom`, `opaque`, `unsafe`, `admit`, proof-command `sorry`, or
  `native_decide`.
- Helper lemmas are acceptable in the same file when they clarify the API.

## Submission

```yaml
aristotle:
  project_id: 3b32b0fb-525d-47bf-b818-1980d1fad98d
  task_id: 26298711-dbce-4f7b-b426-cd845ca7855b
  target_file: PhysicsSM/Draft/NullEdgeCoreAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeCoreAristotle
  output_dir: AgentTasks/aristotle-output/3b32b0fb-525d-47bf-b818-1980d1fad98d
  status: failed
```

The broad continuation task failed without a useful Lean error summary in
`aristotle show`.  The likely issue is scope: the prompt mixed a determinant
identity, diamond group API, positivity/vanishing criteria, and cochain
machinery in one task.

## Repair submission

The repair task splits off only the highest-value mass theorem:

```yaml
aristotle_repair:
  project_id: 3b32b0fb-525d-47bf-b818-1980d1fad98d
  task_id: f1e7422f-5373-4629-a56f-0201386e477c
  target_file: PhysicsSM/Draft/NullEdgeCoreAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeCoreAristotle
  status: failed
```

Repair target:

```lean
threeEdgeMomentum
three_edge_plucker_mass_identity
```

The diamond API, vanishing criteria, finite-bundle generalization, and
cochain/coboundary targets are intentionally deferred to later split tasks.

## SPL-free repair project

The narrow repair task also failed without a useful Lean error summary.  The
completed round-1 Aristotle summary noted that the original project needed a
temporary local `.lake/packages/SpherePacking` stub just to configure Lake,
even though `NullEdgeCoreAristotle.lean` imports only `Mathlib`.

To avoid that dependency path entirely, a fresh minimal submission package was
prepared:

```text
AgentTasks/aristotle-submit/null-edge-core-three-edge-splfree-20260620-project
```

This package:

- removes the active `SpherePacking` require from `lakefile.toml` and
  `lake-manifest.json`;
- omits `PhysicsSMDraft.lean` and `PhysicsSMSPL.lean`;
- uses a one-module `PhysicsSM.lean` root importing only
  `PhysicsSM.Draft.NullEdgeCoreAristotle`;
- starts from the completed round-1 Aristotle output file;
- adds the three-edge theorem as the only round-2 target.

The three-edge proof was filled locally in the package with the direct
`simp`/`ring` determinant proof:

```lean
threeEdgeMomentum
three_edge_plucker_mass_identity
```

Local checks:

```text
lake env lean AgentTasks/aristotle-submit/null-edge-core-three-edge-splfree-20260620-project/ThreeEdgeSmoke.lean
lake env lean AgentTasks/aristotle-submit/null-edge-core-three-edge-splfree-20260620-project/PhysicsSM/Draft/NullEdgeCoreAristotle.lean
```

The package-local check from inside the generated package was not retained
because it created `.lake` dependency state; after confirming that the failure
was only missing local mathlib oleans, the generated `.lake` directory was
removed before submission.

```yaml
aristotle_splfree_repair:
  project_id: 96c644ea-416b-4c04-b251-e99de180e0bd
  task_id: ce5b0922-7e97-4585-9b78-a386471a4f3a
  target_file: PhysicsSM/Draft/NullEdgeCoreAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeCoreAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-core-three-edge-splfree-20260620-project
  status: integrated
```

Aristotle returned `COMPLETE_WITH_ERRORS`, but the reported errors were only
non-fatal style/linter messages.  The SPL-free package verified successfully:

- `lake env lean PhysicsSM/Draft/NullEdgeCoreAristotle.lean` exited 0;
- `lake build PhysicsSM.Draft.NullEdgeCoreAristotle` completed successfully;
- the new declarations `threeEdgeMomentum` and
  `three_edge_plucker_mass_identity` were kernel-checked;
- the target file had no proof-command placeholders or forbidden constructs.

The verified file was copied into the live repo and imported from
`PhysicsSMDraft.lean`.

## Verification requested from Aristotle

```bash
lake env lean PhysicsSM/Draft/NullEdgeCoreAristotle.lean
lake build PhysicsSM.Draft.NullEdgeCoreAristotle
```

Also scan the target file for proof-command placeholders and forbidden trusted
constructs.
