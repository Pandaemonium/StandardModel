# Impact note: the strongest overnight result

Date: 2026-07-21
Role: Codex / Impact Strategist
Work item: `QCA-3PLUS1-001`

## Lead result

The strongest result is no longer an infrared Taylor match or a fitted lattice
dispersion. The live local-unitary HNU construction now has a kernel-checked
changing-lattice position-space convergence theorem to the free massive Dirac
evolution in `3+1` dimensions, for a fixed supplied nonzero complex mass
parameter, finite time, and arbitrary fixed `L2` initial data.

The proof stack includes:

- the exact finite local unitary and its full-zone massive gap;
- a fixed-momentum `O(1/n)` many-step estimate;
- sampling, interpolation, and momentum-cell projection;
- compact-momentum control plus an ultraviolet-tail argument;
- exact identification of the limiting Schwartz generator with the massive
  Dirac differential expression in Mathlib's Fourier convention; and
- a self-adjoint, closed maximal momentum Hamiltonian and its exact
  Fourier-conjugated position operator.

Under the explicit specialization `z = psi wedge phi`, the onsite rest
operator, dynamical mass shell, and two-edge determinant mass use the same
complex Pluecker area, with no second coefficient inserted. The walk dynamics
do not force this specialization or select the value of `z`.

## Why it matters

This crosses the main line separating a suggestive discrete model from a
mathematically controlled regulator candidate. The construction now recovers
the actual finite-time free massive Dirac dynamics in position space under an
explicit changing-lattice limit, rather than merely reproducing its first
derivative at zero momentum.

The most defensible external framing is:

> A finite-depth local-unitary `3+1` regulator converges strongly to the free
> massive Dirac flow for fixed mass, time, and square-integrable data; when its
> supplied mass parameter is specialized to the finite Pluecker area, the
> lattice and null-spinor mass invariants coincide without a second mass slot.

## Boundaries that must stay in the lead presentation

The theorem does not derive the observed mass scale, flavor ratios, gauge
interactions, an interacting quantum field theory, or stability of the selected
low-energy sector under interactions. The complete microscopic register also
retains its topologically required compensating sector. Current work replaces
the unphysical demand to delete that sector with a source-grounded theorem
target: a gapped quasi-local low-energy band whose accumulated interaction
leakage vanishes in the continuum schedule.

## Polynomial cost now landed

The actual doubled HNU word and complex rest generator now compose with the
sharp unitary product estimate. A common schedule reaches error at most
`1/(N+1)`, and on the displayed linearly growing momentum window its real depth
has an explicit cubic upper bound. This removes the former exponential-cost
debt for the free finite-matrix approximation; it does not make approximation
depth a physical clock or cover interactions.

## Next result with the highest marginal impact

The proved zero/pi gap now gives the live HNU fiber an invertible Hermitian
inverse-Cayley generator and a canonical finite negative-sign orthogonal
projector. Endpoint commutation, the exact rest-frame convention, and
continuity of the inverse-Cayley generator are now proved. The full
four-component characteristic determinant has also been reduced, for every
complex spectral parameter, to an exact two-component opposite-chirality
determinant. Determinant one of the two chiral endpoint blocks now proves exact
reciprocal pairing of every nonzero characteristic root. The inverse-Cayley
shifted determinant is now proved even for every complex spectral parameter,
so opposite Cayley energies are an exact characteristic-polynomial symmetry.
The highest-impact successor is therefore sharply finite: prove exact `2+2`
inertia and continuity of the canonical rank-two projector; then derive a
quasi-local moving-band leakage law under an
explicit local interaction. That would address physical-sector interpretation,
the main remaining objection to the free `3+1` regulator.
