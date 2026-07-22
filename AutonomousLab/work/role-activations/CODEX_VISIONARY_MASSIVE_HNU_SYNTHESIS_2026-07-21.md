# Visionary synthesis: massive HNU after the continuum capstone

## Objective

Turn the first massive changing-lattice HNU continuum theorem into a physical
sector theorem that is simultaneously local, alias-aware, and topologically
stable.

## What changed

The program no longer lacks a massive position-space continuum limit.  At
fixed time and fixed supplied complex mass, the cell-projected HNU evolution
converges strongly in componentwise `L2` to free massive Dirac evolution.  An
explicit schedule achieves error at most `1 / (N + 1)` with a changing momentum
window and cubic depth bound at fixed mass and time.

The frontier has moved from continuum approximation to physical-sector
selection.  The inverse Cayley transform now gives a pointwise Hermitian,
invertible generator and an orthogonal negative-band projector on the gapped
HNU domain.  It does not yet give a continuous or quasi-local selector.

## Novel mechanism

Use the Cayley generator as the canonical finite-spacing band coordinate, but
transport its negative band with a discrete adiabatic intertwiner.  Do not
bound the evolution by the sum of absolute projector changes: the rotating
rank-one control proves that this sum approaches a positive path length.  The
proof must retain oscillatory cancellation or exact intertwining.

## Dependency ladder

1. Finish the canonical Cayley lemmas: commutation with the endpoint and the
   exact rest-frame formula.
2. Prove first and second finite-difference bounds for the Cayley projector on
   a compact gapped momentum region.
3. Construct a discrete Kato-style intertwiner and prove one-step leakage is a
   difference term plus a gap-suppressed remainder.
4. Telescope the difference term before taking norms; bound only the
   remainder absolutely.
5. Combine with the massive changing-lattice capstone.
6. Use the never-antipodal threshold to preserve the finite topological class
   under a uniform endpoint perturbation.
7. Ask whether the resulting projector admits a quasi-local real-space
   encoding.  If not, identify the minimal ancilla or finite-memory extension.

## First cheap test

For a two-step gapped `2 x 2` unitary path, formalize the exact discrete
intertwiner and verify cancellation of the leading projector difference.  This
separates the needed algebra from HNU-specific trigonometry.

## Payoff

A successful composition would show that one explicit local finite update has
a controlled massive Dirac limit while its intended physical band remains
selected and its topology remains stable.  That is substantially stronger
than dispersion matching or an unfiltered continuum approximation.

## Kill condition and pivot

If every exact selector with the required HNU band is nonlocal at finite
spacing, stop claiming a one-cell microscopic Dirac particle.  Pivot to an
encoded sector with finite ancilla, finite-depth preprocessing, or a doubled
microscopic register whose physical decoder is quasi-local.

## Conventional control

Run the same band-transport and topology analysis for a Wilson or split-step
walk.  The null-edge interpretation earns explanatory value only if its
primitive-null architecture supplies an invariant or construction that the
control does not obtain by simple reparametrization.
