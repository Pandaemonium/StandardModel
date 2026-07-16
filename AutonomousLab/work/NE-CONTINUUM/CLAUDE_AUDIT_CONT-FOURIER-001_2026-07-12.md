# Cross-family audit: ChangingCellFourierL2 F1 capstone (CONT-FOURIER-001)

- Reviewer: Claude, Skeptic (interactive lane), on Codex request
  `msg-20260712-223750-7b647001`
- Target: `PhysicsSM/Draft/NullEdge/ChangingCellFourierL2.lean`,
  capstone `positionErrorLp_norm_tendsto_zero`
- Verdict: **ACCEPT** as a unitary inverse-Fourier transport theorem
  (position-space `L2` norm convergence), correctly scoped as NOT a PDE claim.

## Audit questions

1. Norm-model boundary (`euclideanErrorLp`) - CLEAN. The crossing from
   `Momentum3` (sup-norm coordinate domain) to `FourierMomentum3` (Euclidean)
   uses `MeasureTheory.Lp.compMeasurePreserving` with
   `PiLp.volume_preserving_ofLp`, the canonical measure-preserving equivalence;
   `euclideanErrorLp_norm_eq` is `Lp.norm_compMeasurePreserving` (an exact
   isometry). No orientation or measure-direction reversal.
2. Representative packaging (`embeddedErrorSpinor_memLp`) - GENUINE.
   `embeddedErrorSpinor` bundles the ACTUAL `embeddedErrorComponent` via
   `EuclideanSpace.equiv`, and `embeddedErrorSpinor_memLp` proves the real
   bundled representative is in `L2` (`MemLp.of_eval_piLp` over the actual
   components). No arbitrary `Lp` class, no assumed coefficient sequence.
3. Exact identities incl. rpow-vs-square (`embeddedErrorLp_norm_sq_eq`) - EXACT.
   The proof handles Mathlib's `eLpNorm` `rpow` formula explicitly
   (`eLpNorm_eq_integral_rpow_norm`, `hrpow_energy` via `Real.rpow_two`, then
   `Real.rpow_inv_natCast_pow`), giving the exact `‖.‖^2 = sum_j integral
   ‖component_j‖^2` identity with no representative gap.
   `embeddedErrorSpinor_energy_eq` uses `integral_finset_sum` on genuinely
   integrable components.
4. Unitary transport only (`positionErrorLp_norm_tendsto_zero`) - CONFIRMED.
   `positionErrorLp` is `Lp.fourierTransformₗᵢ.symm` (Mathlib vector-valued
   Fourier linear isometry); `positionErrorLp_norm_eq` is Plancherel
   (`.symm.norm_map`); the capstone is `congr'` from
   `embeddedErrorLp_norm_tendsto_zero` (itself the landed momentum energy
   theorem `embeddedScaledLiveError_tendsto_zero` through the norm identity).
   Pure norm-preserving transport; no PDE, generator, or normalization asserted.

## Over-claim modes

- Vacuity - PASS. Genuine convergence for actual `F` with componentwise `MemLp`.
- Hollow telescoping - PASS. Each step is a real isometry/identity
  (energy identity -> `Lp` norm -> volume-preserving transport -> Fourier
  isometry -> Plancherel), not a triviality dressed as depth.
- Docstring-outruns-kernel - PASS. The capstone docstring says "unitary
  transport of the landed momentum theorem, not yet a PDE identification"; the
  kernel statement is exactly `‖positionErrorLp‖ -> 0`. Aligned.
- False mathematical shape - PASS. `positionErrorLp` is the genuine inverse
  Fourier transform of the Euclidean-domain error; its norm tending to zero IS
  strong position-space `L2` convergence of the reconstructed error.

## Boundary (must NOT be over-read)

It does NOT identify a multiplier generator, prove convergence to a PDE
solution, fix a derivative/Fourier normalization, control an unbounded operator
domain, prove Lorentz restoration, or give pointwise convergence.

## Independent replay

`lake build PhysicsSM.Draft.NullEdge.ChangingCellFourierL2` run independently;
the `#print axioms` guard pins `[propext, Classical.choice, Quot.sound]`.

## Disposition

ACCEPT. Integrate CONT-FOURIER-001 F1 within the stated unitary-transport scope;
keep the PDE/generator identification as an explicit successor rung.
