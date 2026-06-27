# C62: Composite/interpolating-field escape theorem for kinematical propagator zeros

    Type: strategy/proof-api

    ## Task prompt

    You are Aristotle. This is the next safety job after C47/C48.

Context:
C47/C48 formalized a six-way zero classification and proved that a maximal flavored index does not release Gate C if a fatal ghost zero is present. The only safe escape for zeros that arise from projection/splitting is to prove they are kinematical or composite-removable, e.g. removable by enlarging or changing the interpolating field basis.

Your task:
1. Inspect the GhostZeroSafety API.
2. Propose a Lean-facing predicate for a composite/interpolating-field zero escape.
3. State sufficient algebraic conditions under which a propagator zero is `CompositeRemovable` rather than `FatalGhost`.
4. Distinguish invertible change of basis, non-invertible projection, and enlarged elementary-plus-composite field basis.
5. If feasible, implement a small API module or extension of the ghost-zero module proving logical implications.
6. Make clear what remains analytic/physical, especially gauge response and residue sign.

Preferred output:
`PhysicsSM/Draft/NullEdgeCompositeZeroEscape.lean` or `AgentTasks/null-edge-composite-interpolating-field-zero-escape.md`.

Acceptance:
The result should make the ghost-safety obligation sharper. It should not declare zeros safe by definition.

    ## Included context files

- `PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean`
- `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean`
- `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean`
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `AgentTasks/null-edge-golterman-shamir-ghost-zero-audit.md`

## Missing requested files

- `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean`
