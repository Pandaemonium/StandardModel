# Impact note: the strongest overnight result

Date: 2026-07-21
Role: Codex / Impact Strategist
Work item: `QCA-3PLUS1-001`

## Lead result

The strongest result is no longer an infrared Taylor match or a fitted lattice
dispersion. The live local-unitary HNU construction now has a kernel-checked
changing-lattice position-space convergence theorem to the free massive Dirac
evolution in `3+1` dimensions, for fixed complex Pluecker mass, finite time,
and arbitrary fixed `L2` initial data.

The proof stack includes:

- the exact finite local unitary and its full-zone massive gap;
- a fixed-momentum `O(1/n)` many-step estimate;
- sampling, interpolation, and momentum-cell projection;
- compact-momentum control plus an ultraviolet-tail argument;
- exact identification of the limiting Schwartz generator with the massive
  Dirac differential expression in Mathlib's Fourier convention; and
- a self-adjoint, closed maximal momentum Hamiltonian and its exact
  Fourier-conjugated position operator.

The onsite rest operator is determined by the same complex Pluecker area that
arises from the null-spinor data. The continuum theorem therefore does not add
a second independent mass coefficient to the walk.

## Why it matters

This crosses the main line separating a suggestive discrete model from a
mathematically controlled regulator candidate. The construction now recovers
the actual finite-time free massive Dirac dynamics in position space under an
explicit changing-lattice limit, rather than merely reproducing its first
derivative at zero momentum.

The most defensible external framing is:

> A finite-depth local-unitary `3+1` regulator with a Pluecker-derived rest
> operator converges strongly to the free massive Dirac flow for fixed mass,
> time, and square-integrable data.

## Boundaries that must stay in the lead presentation

The theorem does not derive the observed mass scale, flavor ratios, gauge
interactions, an interacting quantum field theory, or stability of the selected
low-energy sector under interactions. The complete microscopic register also
retains its topologically required compensating sector. Current work replaces
the unphysical demand to delete that sector with a source-grounded theorem
target: a gapped quasi-local low-energy band whose accumulated interaction
leakage vanishes in the continuum schedule.

## Next result with the highest marginal impact

Compose the actual doubled HNU word and Pluecker mass exponential with the sharp
unitary product formula to replace the current exponential adaptive-depth bound
by a polynomial one. In parallel, prove the moving-projector leakage telescope
and then instantiate a gap-dependent quasi-local physical-band estimate. These
two results would address computational cost and physical-sector interpretation,
the most important remaining objections to the free `3+1` regulator.
