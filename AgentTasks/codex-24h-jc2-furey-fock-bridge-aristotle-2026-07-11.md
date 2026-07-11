# Aristotle proof job: corrected Furey ideal to three-mode exterior/Fock basis

Name this project `codex-24h-jc2-furey-fock-bridge-20260711`.

Run first:

```text
lake env lean AgentTasks/aristotle-targets/codex_24h_jc2_furey_fock_bridge.lean
```

Close all three proof holes without changing public statements. The central
theorem must verify all 48 ladder/basis cases and prove that the corrected
concrete Furey action table is exactly the standard signed three-mode exterior
creation/contraction table under `occupancy`.

The final theorem must compose the already trusted octonionic-ideal coordinate
equivalence with the occupancy reindexing and send each concrete corrected
Furey basis vector to the matching Fock basis vector.

Required boundaries:

- this is an exact basis/action bridge, stronger than `1+3+3+1` dimensions;
- the target coordinate module is the basis model of the exterior algebra,
  not yet Mathlib's quotient `ExteriorAlgebra` object;
- `Jbar'` is a module for the associative left-action operators; do not infer
  associativity of raw octonion multiplication;
- representation conjugacy is not particle-antiparticle conjugacy;
- the primitive idempotent state is an algebraic Fock vacuum, not the QFT
  vacuum, and occupation is not compositeness.

Use kernel reduction/case analysis, not compiled evaluation. Return all solved
declarations, the axiom footprint, and any convention mismatch.

```yaml
aristotle:
  project_id: 2b4328ae-c91d-4bb5-b726-61f423895e62
  task_id: pending
  target_file: AgentTasks/aristotle-targets/codex_24h_jc2_furey_fock_bridge.lean
  expected_module: none-handoff
  submission_project: AgentTasks/aristotle-submit/codex-24h-jc2-furey-fock-bridge-20260711-project
  output_dir: AgentTasks/aristotle-output/2b4328ae-c91d-4bb5-b726-61f423895e62
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
