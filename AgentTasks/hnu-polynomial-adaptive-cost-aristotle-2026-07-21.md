# Aristotle task: sharp HNU product bound and polynomial adaptive cost

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated from the completed Aristotle return

## Objective

Replace the valid but exponentially inflated massive HNU changing-window
certificate with a commutator-scaled unitary product estimate and an explicit
polynomial microscopic-step schedule.

## Claim boundary

This target concerns numerical approximation cost for fixed continuum time.
It does not posit different physical clock rates for different momenta, prove
an interacting continuum limit, or identify the regulator with observable
spacetime discreteness.

The target must derive its one-step bound from the exact HNU exponential word;
an assumed `O(eps^2)` hypothesis is not a close-out. If the optimistic constant
is false, a larger explicit polynomial constant and a precise correction are
success.

Semantic context:
`AgentTasks/context-packs/hnu-polynomial-adaptive-cost-20260721-20260721-033953.md`.

```yaml
aristotle:
  project_id: 9a553b51-fc39-43dd-85e4-8955746c6573
  task_id: be70e2af-3d95-4906-aefc-f7d76e4b5eab
  target_file: PhysicsSM/Draft/NullEdge/HNUPolynomialAdaptiveCost.lean
  expected_module: Mathlib-only sharp product-formula and HNU specialization
  submission_project: AgentTasks/aristotle-standalone/hnu-polynomial-adaptive-cost-20260721
  output_dir: AgentTasks/aristotle-output/9a553b51-fc39-43dd-85e4-8955746c6573
  status: integrated
```

## Landed result

The completed return was locally verified and integrated as
`PhysicsSM/Draft/NullEdge/HNUPolynomialAdaptiveCost.lean`, with a build-enforced
footprint pin in `HNUPolynomialAdaptiveCostAxiomGuard.lean`.

It proves the sharp two-factor skew-Hermitian Lie--Trotter bound, an ordered
finite-product bound `eps^2 / 2 * (sum norms)^2`, exact unitary power
telescoping, an explicit polynomial schedule arithmetic bound, and the exact
depth-eight two-component HNU exponential word. The eight kinetic generators
sum to the Weyl generator and their operator norms sum exactly to `qAbs q`.

## Remaining composition gate

The return did not complete target 4. Its ordered-product estimate is stated
for four-by-four matrices, while its exact HNU word is the two-by-two massless
endpoint. It does not compose the doubled chiral embedding, fixed Dirac-basis
change, or Pluecker mass exponential. Consequently the candidate coefficient
`(R + M)^2 / 2` has a proved cubic schedule arithmetic law but is not yet
identified with the live massive walk's one-step error. No polynomial-cost
massive-continuum claim is made from this module alone.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/HNUPolynomialAdaptiveCost.lean`
- `lake build PhysicsSM.Draft.NullEdge.HNUPolynomialAdaptiveCostAxiomGuard`
  (passed, 8028 jobs)
