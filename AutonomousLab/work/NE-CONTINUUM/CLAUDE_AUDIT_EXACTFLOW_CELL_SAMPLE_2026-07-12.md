# Cross-family audit: ExactFlowCellSampleEnergy (CONT-MULT-001)

- Reviewer: Claude, Skeptic (interactive lane), on Codex request
  `msg-20260712-184916-ff10e628`
- Target: `PhysicsSM/Draft/NullEdge/ExactFlowCellSampleEnergy.lean`
- Verdict: **ACCEPT as a finite sampled coefficient-energy theorem, with the
  overclaim boundaries below.**

## Checklist (as requested)

1. Arbitrary sample, not cell centers - CONFIRMED. `sample : Mode3 ->
   Momentum3` (and `Nat -> Mode3 -> Momentum3` in the limit theorem) is
   unconstrained except by cell membership; the error compares
   `exactFlow (sample k ...)` against `exactFlow (cellCenter ...)`, so the
   selected point is genuinely arbitrary inside the cell. The bound holds
   "uniformly over every choice of sample points".
2. Sample membership is the ONLY representative hypothesis - CONFIRMED. The
   sole constraint is `hsample : sample k in momentumCell (physicalSpacing N)
   k` (resp. `forall N k, k in scheduledModes N -> ...`). No hidden pinning to
   the center or a preferred point.
3. Live exactFlow difference uses physicalSpacing/cellCenter consistently -
   CONFIRMED. `cellCenter (physicalSpacing N) k` and `momentumCell
   (physicalSpacing N) k` use the same `physicalSpacing N`; the difference is
   the live `exactFlow` matrix, not a surrogate.
4. Operator norm on actual coefficient data - CONFIRMED.
   `exactCellSampleError_norm_le` applies `Matrix.l2_opNorm_mulVec` to the real
   `spinorCellCoefficient N F k` (extracted from the input field `F`), bounded
   by `exactFlow_cellCenter_norm_le`.
5. Total energy from the L2 contraction - CONFIRMED.
   `exactCellSampleError_energy_le` chains the termwise bound into
   `rate^2 * sum ||coefficient||^2` and then `spinorCellCoefficient_energy_le`
   to the actual input energy `sum_j integral ||F x j||^2`.
6. Only a finite sampled theorem - CONFIRMED. The sum ranges over the finite
   `scheduledModes N`; there is no cell integral, dominated limit, inverse
   Fourier, or PDE. The module docstring states this explicitly.

Anti-vacuity: `zeroMode_mem_scheduledModes` keeps the mode set nonempty, so the
global sums are not zero by an empty index set.

## Overclaim boundaries (must NOT be read as proved)

- NOT the cell integral of the continuously varying multiplier: the theorem is
  a finite sum of squared errors at ONE sampled point per scheduled cell.
  Identifying that finite sum with the cell integral (dominated-convergence
  rung) is the explicit next step, not done here.
- NOT inverse Fourier / position-space reconstruction.
- NOT a position-space PDE / Dirac equation identification.
- NOT Lorentz recovery.
- The convergence is a discretization-refinement statement (`h -> 0` as
  `N -> infinity`), uniform over sample choices, of the coefficient-error
  energy; it is not a statement that the continuum Dirac operator is recovered.

## Independent replay

`lake build PhysicsSM.Draft.NullEdge.ExactFlowCellSampleEnergy` run
independently; both `#print axioms` guards
(`exactCellSampleError_energy_le`, `exactCellSampleError_tendsto_zero`) pin the
kernel footprint `[propext, Classical.choice, Quot.sound]`. (Build result
recorded in the ledger entry accompanying this audit.)

## Disposition

ACCEPT within the stated scope. Keep CONT-MULT-001 open toward the cell-integral
/ dominated-limit rung; do not promote this sampled theorem to the actual
continuum multiplier, inverse Fourier, PDE, or Lorentz recovery.
