# Aristotle job: finite strict-past nilpotence

Date: 2026-07-16
Work item: `GRAV-ORDER-OPERATOR-001`
Status: harvested, integrated, built, and independently approved

```yaml
aristotle:
  project_id: cdb53c37-a5ad-4c72-9714-27136ce91f62
  task_id: fc83b976-a463-422a-8c9e-5d97ea35f9a1
  target_file: FiniteStrictPastNilpotence/WeightedPast.lean
  expected_module: FiniteStrictPastNilpotence.WeightedPast
  submission_project: AgentTasks/aristotle-submit/finite-strict-past-nilpotence-20260716-project
  source_root: AgentTasks/aristotle-standalone/finite-strict-past-nilpotence-20260716
  integration_target: PhysicsSM/Draft/NullEdge/FiniteStrictPastNilpotence.lean
  status: harvested_and_integrated
```

## Objective

Prove that every weighted strict-past incidence operator on a nonempty finite
transitive irreflexive relation is nilpotent at the event-cardinality power.
Also prove a nonzero two-event chain witness whose operator squares to zero.

This is the causal-combinatorial half of the proposed retarded polynomial-
projector no-go. Combined with the separate scalar-plus-nilpotent Aristotle
job, it would show that direct polynomial idempotents of the finite retarded
operator are trivial.

## Exact targets

Focused Mathlib-only source:
`AgentTasks/aristotle-standalone/finite-strict-past-nilpotence-20260716/FiniteStrictPastNilpotence/WeightedPast.lean`.

Preserve the public relation structure, operator definition, exponent
`Fintype.card V`, and exact two-chain conjunction. Do not add a linear order,
chosen topological sort, acyclicity certificate, or stronger relation
hypothesis to the public theorem. Private use of a finite linear extension,
path expansion, or matrix representation is welcome.

If transitivity plus irreflexivity is insufficient, return a concrete
counterexample or minimal missing hypothesis rather than changing the theorem.

## Proof idea

Expand the `n`-th power as sums over length-`n` strict chains. Transitivity and
irreflexivity imply all vertices in such a chain are distinct. A chain with
`Fintype.card V` strict edges would contain one more distinct vertex than the
finite type, so every coefficient vanishes. Equivalently, choose a linear
extension and identify the operator matrix as strictly triangular.

## Context

Semantic context pack:
`AgentTasks/context-packs/finite-strict-past-nilpotence-20260716-20260716-144958.md`.

The project `FiniteCausalOrder.layeredPastSum` has exactly this weighted past
shape, with weights determined by interval-count layers. Integration will
remain a separate semantic bridge after the standalone theorem is returned.

## Scope boundary

The theorem proves nilpotence of the off-diagonal past part only. It does not
derive physical scales, a rank-four sector, self-adjointness, a spectral gap,
Lorentzian inertia, or continuum convergence.

## Submission

After correcting a linear-map notation typo and adding local classical
decidability to the weighted operator definition, the focused source passed
`lake env lean` with exactly two intended proof-hole warnings. Aristotle
project `cdb53c37-a5ad-4c72-9714-27136ce91f62`, task
`fc83b976-a463-422a-8c9e-5d97ea35f9a1`, was submitted with verbatim-statement
and counterexample-if-false instructions.

## Harvest and integration

Aristotle returned both public statements verbatim and complete. The extracted
file passed under the pinned repository toolchain. Production integration:

- module: `PhysicsSM/Draft/NullEdge/FiniteStrictPastNilpotence.lean`;
- SHA-256:
  `c698f35060fa9b8dee3f8b0943af6052957119b6b0cdb1c7e8888c45b66f2dac`;
- direct Lean and the combined 8037-job targeted build passed;
- both public theorems have build-enforced standard-three axiom guards;
- the nonzero two-chain square-zero control is preserved.

The theorem is composed with the existing layered causal operator in
`PhysicsSM/Draft/NullEdge/LayeredOperatorPolynomialNoGo.lean`. Claude
independently approved the unchanged Aristotle statements, exact assumptions,
nonvacuous two-chain control, and project adapter. Review artifact:
`AutonomousLab/reviews/CLAUDE_REVIEW_LAYERED_OPERATOR_NOGO_2026-07-16.md`.
