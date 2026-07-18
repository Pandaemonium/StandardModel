# Corrected-pairing layer-coherent no-go

Date: 2026-07-16  
Work item: `GRAV-ORDER-OPERATOR-001`  
Owner: Codex

## Question

Can one coherent mode from each of the four supported local causal-operator
layers provide the missing rank-four Lorentzian sector on a larger carrier?

## Exact target

For positive populations `N_n` and nonzero discreteness scale `ell`, compress
each disjoint interval-count layer `n = 0,1,2,3` to one unnormalized
indicator-difference coordinate. The corrected weighted-difference form is
diagonal on those coordinates, with entries

```text
(-N_0 p/2, 9 N_1 p/2, -8 N_2 p, 4 N_3 p),
```

where `p = sourceLocal4DPrefactor(ell) > 0`.

The required theorem proves the sign profile `(-,+,-,+)` and rules out one
positive plus three negative diagonal coordinates for every choice of a
distinguished coordinate.

## Semantic boundary

This is a compressed layer-Gram model. It exactly represents the sum over a
disjoint layer for an unnormalized coherent indicator-difference coordinate,
but it does not construct the layers, prove their nonemptiness in a random
carrier, select a spatial sector, or establish spectral/refinement stability.
It refutes only the proposed one-mode-per-local-layer shortcut. The concrete
five-event mostly-minus witness remains valid because its population pattern is
three layer-zero directions plus one layer-three direction, not one coordinate
from each of four alternating-sign layers.

## Review provenance

The target follows the Codex skeptical audit:
`AutonomousLab/reviews/CODEX_REVIEW_CORRECTED_SPECTRUM_S1_2026-07-16.md`.
The local coefficient row comes from
`FiniteCausalOrderOperator.sourceLocal4DCoefficient`; the diagonal form comes
from
`CorrectedPairingDifferenceCoordinates.fiveEventDifferenceProbe_gram_diagonal`.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/CorrectedPairingLayerCoherentNoGo.lean`
  passed with no diagnostics.
- `lake build PhysicsSM.Draft.NullEdge.CorrectedPairingLayerCoherentNoGo`
  passed, 8037 jobs.
- The three flagship declarations have build-enforced axiom pins with only
  `propext`, `Classical.choice`, and `Quot.sound`.
- Full repository build remains to be run with the next integration batch.
