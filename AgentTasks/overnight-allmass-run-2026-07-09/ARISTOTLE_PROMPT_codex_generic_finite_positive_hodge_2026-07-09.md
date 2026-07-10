# Codex Aristotle target: generic finite positive-Hodge core

Prove every theorem in `PositiveHodge/Generic.lean` without changing any
definition, weakening any statement, or introducing new assumptions. Run the
narrow command first:

```text
lake env lean PositiveHodge/Generic.lean
```

## Mathematical target

For a finite complex Euclidean space and a nilpotent differential `Q`, prove the
finite Hodge package:

1. `range Q <= ker Q`;
2. the energy identity for `Delta_Q = Q^* Q + Q Q^*`;
3. `ker Delta_Q = ker Q intersect ker Q^*`;
4. every closed vector has a unique harmonic representative modulo `range Q`;
5. a decoder commuting with `Q` preserves closed and exact vectors;
6. commuting additionally with `Q^*` preserves harmonic representatives.

The unique-representative theorem is the prize. Prefer standard finite
inner-product-space orthogonal-complement and adjoint APIs over basis
calculations.

## Scientific boundary

The constraint Hodge Laplacian is not the spectral mass operator. It selects
cohomology representatives; a separate commuting decoder can assign nonzero
spectral cost to a harmonic physical class. Do not identify `D` with `Q` or
claim positivity from nondegeneracy alone.

The project already contains an explicit nonvacuous positive witness and a
matched negative-sign no-go in
`PhysicsSM/Draft/NullEdge/Carrier/PositiveHodgeDecoder.lean`. This standalone
job supplies the generic finite Hodge theorem underneath that witness.

Context pack:
`AgentTasks/context-packs/generic-finite-positive-hodge-20260709-20260709-203357.md`.

```yaml
aristotle:
  project_id: 090b19dc-685b-4be7-95cb-d3305d6e5b9d
  target_file: PositiveHodge/Generic.lean
  expected_module: PhysicsSM.Draft.NullEdge.Carrier.GenericFiniteHodge
  submission_project: AgentTasks/aristotle-submit/codex-generic-finite-positive-hodge-20260709-2034-project
  output_dir: AgentTasks/aristotle-output/090b19dc-685b-4be7-95cb-d3305d6e5b9d
  status: integrated
```

## Integration result

The service reported `COMPLETE_WITH_ERRORS`, but the returned source contained
all six proofs, no placeholders, and passed the pinned local command
`lake env lean PositiveHodge/Generic.lean`. It landed as
`PhysicsSM/Draft/NullEdge/Carrier/GenericFiniteHodge.lean` with project
namespace and axiom guards. The result is explicitly Hilbert-Hodge; it does not
claim a canonical Krein-positive sector.
