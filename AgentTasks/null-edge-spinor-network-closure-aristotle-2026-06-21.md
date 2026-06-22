# Aristotle task: spinor-network closure moment identity

Date: 2026-06-21

## Objective

Prove the finite weighted celestial fan identity that rewrites pairwise angular
Pluecker spread as an energy-minus-closure moment-map mass.

Target file:

```text
NullEdgeSpinorNetworkClosure/Finite.lean
```

Expected module:

```text
NullEdgeSpinorNetworkClosure.Finite
```

Context pack:

```text
AgentTasks/context-packs/null-edge-spinor-network-closure-20260621-manual.md
```

## Theorem targets

```lean
pluckerMass_eq_energy_sq_sub_closureDefect_sq
closed_spinorFan_is_restFrame
```

## Why this matters

The strengthened research program now treats spinor-network closure as the most
actionable finite bridge from celestial Pluecker mass to source-visibility and
BF/spin-foam closure. This job banks only the finite moment identity, leaving
the stronger physics interpretations for later.

## Constraints

- Keep the job finite and algebraic.
- Do not add BF closure, spin-foam simplicity, or cosmological source claims.
- Do not change theorem statements unless there is a real mathematical error;
  if so, explain the counterexample or missing hypothesis.
- Final target file should contain no proof holes or escape-hatch declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-spinor-network-closure-20260621/NullEdgeSpinorNetworkClosure/Finite.lean
```

Result before submission: passed with exactly one intended proof-hole warning.

## Aristotle metadata

```yaml
aristotle:
  project_id: f1be6e52-31cc-411b-86b7-a841b1cfd318
  task_id: f46b9cc7-bf48-4bda-b3c1-7dbbe3678ec5
  target_file: NullEdgeSpinorNetworkClosure/Finite.lean
  expected_module: NullEdgeSpinorNetworkClosure.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-spinor-network-closure-20260621-project
  output_dir: AgentTasks/aristotle-output/f1be6e52-31cc-411b-86b7-a841b1cfd318
  status: complete
```

Submitted 2026-06-21. `aristotle submit` created project
`f1be6e52-31cc-411b-86b7-a841b1cfd318`; `aristotle tasks` reported task
`f46b9cc7-bf48-4bda-b3c1-7dbbe3678ec5` as `IN_PROGRESS`.

Completed 2026-06-21. Aristotle reported that
`pluckerMass_eq_energy_sq_sub_closureDefect_sq` was proved without changing
the theorem statement. The target file reportedly passes
`lake env lean NullEdgeSpinorNetworkClosure/Finite.lean` with no warnings and
no remaining proof holes. The proof is finite algebra: expand `E^2`, expand
`|C|^2`, use the unit-direction hypothesis to remove diagonal terms, and pair
the symmetric off-diagonal double sum into the `i < j` angular-mass sum.
