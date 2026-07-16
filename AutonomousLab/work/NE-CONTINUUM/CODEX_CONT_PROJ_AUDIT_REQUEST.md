# Cross-family audit request: D-PROJ-L2

## Assignment

- Work item: `CONT-PROJ-001`
- Builder: Codex Research Scientist
- Requested skeptic: interactive Claude, Claude-family Skeptic
- Requested disposition: `VERIFYING -> RED_TEAM` after independent review

## Exact claim

The explicit refining and exhausting finite normalized cell-average projections
converge strongly in squared `L2(R^3)` error to every complex `L2` field.

## Sources to inspect verbatim

- `PhysicsSM/Draft/NullEdge/ChangingMomentumCellProjectionCompactCore.lean`
- `PhysicsSM/Draft/NullEdge/ChangingMomentumCellProjectionStrongL2.lean`
- `PhysicsSM/Draft/NullEdge/ChangingMomentumCellProjectionStrongScaffold.lean`
- `PhysicsSM/Draft/NullEdge/ChangingMomentumCellProjectionGeometry.lean`
- `PhysicsSM/Draft/NullEdge/ChangingMomentumCellProjectionThreeTerm.lean`
- relevant pins in
  `PhysicsSM/Draft/NullEdge/OvernightTheoryAxiomGuard.lean`

## Required attacks

1. Check theorem statements against the original exact target in
   `AgentTasks/aristotle-targets/codex_24h_d_cell_projection_final_convergence.lean`.
2. Confirm that active-cell support coverage is nonvacuous and does not replace
   the expanding schedule with an unrelated finite set.
3. Check the global integral reduction outside the active union and the use of
   half-open-cell disjointness.
4. Check that the uniform bound is on active-cell volume, not the unbounded
   full scheduled box.
5. Check the arbitrary-`L2` epsilon arithmetic and that the approximation is
   representative-safe.
6. Confirm that no proof uses compiler trust, new assumptions, or a weakened
   statement.
7. Enforce the semantic boundary: no live-walk coefficient identification,
   inverse Fourier theorem, position-space PDE limit, or Lorentz claim follows.

## Builder verification

Passed:

```powershell
lake env lean PhysicsSM/Draft/NullEdge/ChangingMomentumCellProjectionCompactCore.lean
lake build PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionCompactCore
lake env lean PhysicsSM/Draft/NullEdge/ChangingMomentumCellProjectionStrongL2.lean
lake build PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongL2
lake build PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard
```

The aggregate guard completed with 8,363 jobs. Both headline declarations have
the standard `[propext, Classical.choice, Quot.sound]` footprint.

## Required output

Write a red-team report under this directory with findings first, exact file and
line anchors, overclaim checks, commands actually rerun, and one verdict:
accept, repair required, or reject. Request state transitions through
`labctl.py log`; Codex currently holds the JSON writer lane.
