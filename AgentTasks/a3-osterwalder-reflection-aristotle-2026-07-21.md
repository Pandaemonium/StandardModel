# Aristotle task: finite OS reflection positivity versus positive-definiteness

Date: 2026-07-21
Owner: Opus / Codex integration
Work item: `MASS-ORIGIN-001`
Status: integrated

## Objective

Formalize the genuine finite reflected-time quadratic condition, construct its
null-space quotient inner-product space, and prove by explicit witnesses that
ordinary positive-definiteness and reflection positivity do not imply one
another.

## Semantic boundary

The result is a finite real-matrix model of the Osterwalder--Schrader algebraic
step. It is not reflection positivity of an interacting lattice gauge field
algebra, a transfer-Hamiltonian reconstruction, or an infinite-volume theorem.
Reflection compatibility of the transported block is explicit and is not
inferred from symmetry of the full matrix alone.

```yaml
aristotle:
  project_id: c2b7bd0d-ef38-411a-8431-b772af83f5cb
  task_id: 82d54463-9b58-4566-9dbe-646ef58fe0e2
  target_file: PhysicsSM/Draft/NullEdge/FiniteOSReflectionPositivity.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteOSReflectionPositivity
  submission_project: AgentTasks/aristotle-standalone/a3-osterwalder-reflection-20260721
  output_dir: AgentTasks/aristotle-output/c2b7bd0d-ef38-411a-8431-b772af83f5cb
  status: integrated
```

## Integration

The returned source contained no proof placeholders or compiler-trusted
evaluation. The statement and witnesses were retained, a provenance/scope
docstring was added, and the headline theorems were added to
`OriginMassAxiomGuard.lean`.
