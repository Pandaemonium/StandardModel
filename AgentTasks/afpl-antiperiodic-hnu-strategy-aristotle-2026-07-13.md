# Aristotle strategy: can antiperiodic pi dilation survive the full HNU schedule?

- project_id: `e9a3645d-b658-46fe-b761-5b260df7ddad`
- task_id: `44c3c958-01c0-4087-948e-77c4c86e1304`
- output_dir:
  `AgentTasks/aristotle-output/e9a3645d-b658-46fe-b761-5b260df7ddad`
- status: integrated-project-reused

## Question

The untwisted compact dilation failed because its zero auxiliary momentum held
the complementary branch and its out-and-back holonomy cancelled to one. A
two-site antiperiodic shift can instead satisfy `T^2 = -I`, so two microscopic
auxiliary moves decode to a pi phase. Can this twisted mechanism be composed
with the exact depth-eight HNU schedule and the transverse selector without
canceling, introducing extra zero-sector copies, or hiding anomaly charge?

## Required audit

1. Write the exact finite schedule architecture. Track the changing HNU spin
   projectors separately from the global transverse selector and auxiliary
   register; do not pretend they commute unless proved.
2. Determine whether applying the same two-tick twist to all eight HNU
   substeps cancels by even parity. If so, identify the smallest asymmetric or
   global-period placement that retains one pi complement while preserving the
   selected HNU endpoint.
3. Prove or refute exact full-step unitarity and real-space finite locality for
   the proposed placement.
4. Census all auxiliary/twist bands and both zero and pi eigenspaces. An
   antiperiodic boundary condition must not be described as removing copies
   without a full finite census.
5. Track the HNU zero-sector Weyl charge and the compensating pi/bulk charge in
   one explicit ledger. State exactly what remains an imported topological
   identification rather than a finite theorem.
6. Test whether the same auxiliary register can also implement the rank-one
   transverse selector, or prove a dimension/commutation obstruction.
7. Return a Lean-ready theorem ladder for the strongest surviving architecture,
   or a scoped no-go with a finite nontrivial witness.

## Boundaries

Do not claim 3+1 completion from a local factorization, endpoint equality, or a
constant pi phase. The route succeeds only if the full finite operator, all
sectors, locality, and charge ledger are explicit. Prefer a sharp no-go over an
unproved synthesis.

## 2026-07-13 disposition

Aristotle returned a scoped relocation no-go, independently approved by
interactive Claude/Opus. The live integration
`PhysicsSM/Draft/NullEdge/AntiperiodicHNU.lean` keeps the decisive compact
content: an exactly unitary all-moving two-site shift with `T^2 = -I`, decoded
sector reflections, their exact depth-eight product, and the theorem that the
symmetric twist moves the HNU origin from `+1` to `-1`. This kills uniform
antiperiodic placement, not all transported-selector or inflow routes.

The Aristotle project is now running the transported-projector/holonomy
successor, so its registry status remains running.
