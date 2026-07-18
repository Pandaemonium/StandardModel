# Aristotle job: atlas transition cocycles versus connection holonomy

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`

```yaml
aristotle:
  project_id: 58922023-5727-41fb-af75-684e8944efe6
  task_id: 44cc2a3e-9553-4471-8632-5d6423b0e2e2
  target_file: AtlasTransitionHolonomy/AtlasTransitionHolonomy.lean
  expected_module: AtlasTransitionHolonomy.AtlasTransitionHolonomy
  submission_project: AgentTasks/aristotle-submit/atlas-transition-holonomy-20260716-project
  source_root: AgentTasks/aristotle-standalone/atlas-transition-holonomy-20260716
  output_dir: AgentTasks/aristotle-output/58922023-5727-41fb-af75-684e8944efe6
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/AtlasTransitionHolonomy.lean
```

## Exact target

Prove all six displayed theorem statements without weakening them:

- chart-gauge preservation of an exact Cech transition system;
- trivial transition product on an occupied triple overlap;
- endpoint covariance of arbitrary connection transport;
- gauge invariance of class-function observables on closed paths;
- a nontrivial `Multiplicative (ZMod 2)` triangle witness;
- the packaged separation verdict.

The intended distinction is semantic, not merely algebraic. Exact chart
transitions are bundle-gluing data and must satisfy the Cech cocycle. Curvature
belongs to separate connection transport whose loop product can be nontrivial.
Do not identify a Bargmann phase with a failure of the chart cocycle.

## Constraints

- Keep the multiplication and gauge conventions exactly as written.
- Do not change any definition or theorem statement.
- Small private helper lemmas are welcome.
- Use only Mathlib and kernel-checked tactics; do not use the compiled evaluator.
- Finish with a concise report listing solved targets, statement changes,
  remaining proof holes, and assumptions used.

## Preflight

- The exact source file passed `lake env lean` in the live pinned repository;
  only the six intentional proof handoff warnings remain.
- The fresh focused copy downloaded its Mathlib dependencies but had no local
  compiled Mathlib cache, so its narrow preflight stopped at `unknown module
  prefix 'Mathlib'`. This is a package-cache limitation, not a source
  diagnostic; Aristotle was explicitly instructed to run the same narrow
  command first.
- Submitted as project `58922023-5727-41fb-af75-684e8944efe6` and registered in
  the AFPL Aristotle registry.

## Scientific boundary

This is finite group algebra, claim grade `M [orig/comp]` after proof and
semantic review. It does not construct the growing atlas, transition data,
Lorentz coframes, spin lift, curvature limit, stress-energy, or Einstein
dynamics.

## Integration

- Dry-run extraction found the expected focused module with no placeholders.
- The candidate diff changed only the six proof bodies; every submitted
  theorem statement remained unchanged.
- The extracted candidate passed `lake env lean` locally.
- Proofs were integrated into
  `PhysicsSM/Draft/NullEdge/AtlasTransitionHolonomy.lean` with six
  build-enforced axiom guards matching the Lean MCP audit.
- `lake env lean PhysicsSM/Draft/NullEdge/AtlasTransitionHolonomy.lean`
  passed. One warning reports an unused binder retained in the submitted
  packaged verdict.
- No proof holes or compiled-evaluator proof steps remain in the integrated
  module.
