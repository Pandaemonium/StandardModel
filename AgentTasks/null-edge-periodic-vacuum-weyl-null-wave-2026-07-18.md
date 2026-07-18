# Null-edge periodic vacuum-Weyl null wave

Date: 2026-07-18
Status: implemented and verified

## Objective

Construct the smallest periodically exact additive curvature that escapes the
fixed-eigenplane Weyl obstruction while retaining the full local algebraic
vacuum-Riemann conditions.

## Landed results

`PeriodicVacuumWeylNullWave.lean` proves:

1. a two-site carrier whose time and longitudinal shifts toggle the same null
   coordinate and whose transverse shifts are trivial;
2. two transverse link potentials valued in independent null-rotation
   bivectors;
3. an exact additive plaquette curl with opposite unit amplitudes at the two
   sites;
4. pointwise nonzero curvature and face antisymmetry;
5. metric-lowered Riemann pair exchange and algebraic first Bianchi;
6. exact vanishing of every identity-coframe mixed Ricci entry, scalar
   curvature, and mixed Einstein entry;
7. packaging of each site as a nonzero algebraic vacuum-Riemann target; and
8. componentwise zero periodic mean, inherited from exact additive
   realization.

## Interpretation boundary

This is the first constructive frame-mixed escape from the diagonal periodic
no-go. It is a finite linearized curvature witness. It does not yet construct
nonlinear proper-Lorentz plaquettes jointly stationary with a varying coframe,
derive Levi-Civita transport, or prove graph refinement and continuum
convergence.

## Verification

- Direct Lean check passed cleanly after factoring the Ricci contraction into
  an explicit two-polarization cancellation lemma.
- Targeted module build passed (8084 jobs).
- GR foundations facade build passed (8139 jobs).
- Strict executable-token scan passed with no forbidden proof mechanisms.
- `pre-commit run --all-files` and `git diff --check` passed.
- Full `lake build` passed (8319 jobs); replayed warnings were pre-existing and
  outside this task's files.
- The semantic document index contains 28 declaration chunks for the new
  module.
