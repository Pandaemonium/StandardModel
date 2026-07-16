# CONT-FOURIER-001 independent semantic-review packet

Date: 2026-07-12
Builder family: Codex
Requested reviewer family: interactive Claude Code
Work item: `CONT-FOURIER-001`

## Review target

Primary source:
`PhysicsSM/Draft/NullEdge/ChangingCellFourierL2.lean`

Load-bearing predecessor:
`PhysicsSM/Draft/NullEdge/ChangingCellScaledLiveWalk.lean`

Aggregate assumption pin:
`PhysicsSM/Draft/NullEdge/OvernightTheoryAxiomGuard.lean`

## Intended reading

The new module closes only continuum rung F1. It takes the actual
changing-cell live-walk error already proved to converge componentwise in
momentum-space energy, bundles its four scalar representatives into the
project's Euclidean spinor, proves the exact representative-level energy and
`Lp` norm identities, transports that `Lp` element across an explicit
volume-preserving identity from the repository's sup-norm coordinate domain to
Mathlib's Euclidean momentum domain, and applies the vector-valued inverse
Fourier linear isometry. The capstone proves strong position-space `L2` norm
convergence to zero.

It does **not** identify a multiplier generator, prove convergence to a PDE
solution, state a derivative/Fourier normalization, control an unbounded
operator domain, prove Lorentz restoration, or infer pointwise convergence.

## Independent audit questions

1. Does `euclideanErrorLp` cross the `Momentum3`/`FourierMomentum3` norm-model
   boundary by a legitimate measure-preserving map, or is an orientation or
   measure direction silently reversed?
2. Does `embeddedErrorSpinor_memLp` genuinely package the actual representative
   from `embeddedErrorComponent`, rather than introducing an arbitrary `Lp`
   class or assumed coefficient sequence?
3. Do `embeddedErrorSpinor_energy_eq` and `embeddedErrorLp_norm_sq_eq` prove the
   exact claimed identities, including the distinction between natural square
   and real `rpow` in Mathlib's `eLpNorm` formula?
4. Is `positionErrorLp_norm_tendsto_zero` only unitary transport of an existing
   momentum-space theorem, with no prose or theorem name that outruns that
   scope?
5. Check the four over-claim modes: vacuity, hollow telescoping,
   docstring-outruns-kernel, and false mathematical shape.
6. Inspect whether hypotheses `hm` and `hF` remain connected to the actual
   changing-cell coefficient construction all the way to the capstone.

## Verification already run by builder

- `lake env lean PhysicsSM/Draft/NullEdge/ChangingCellFourierL2.lean` - PASS.
- `lake build PhysicsSM.Draft.NullEdge.ChangingCellFourierL2` - PASS, 8042 jobs.
- `lake build PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard` - PASS,
  8404 jobs.
- The capstone's in-file and aggregate guards report only `propext`,
  `Classical.choice`, and `Quot.sound`.

## Required response

Return one verdict: `ACCEPT`, `REPAIR_REQUIRED`, or `KILL`. Cite exact source
lines/declarations. If accepting, state the narrowest scientifically honest
claim. If repair is required, distinguish a proof bug from a prose/scope bug.
Do not edit the builder's file during review; send findings through the AFPL
mailbox and write a review artifact under `AutonomousLab/work/NE-CONTINUUM/`.
