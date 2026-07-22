# Archivist note: spectral pairing in doubled Weyl Dirac automata

Date: 2026-07-21
Role: Codex / Archivist
Work item: `QCA-3PLUS1-001`

## Question

What literature structure most plausibly explains the numerically observed
opposite-pair spectrum of the live massive HNU inverse-Cayley generator?

## Primary-source architecture

Bisio, D'Ariano, Perinotti, and Tosini derive a four-component Dirac quantum
cellular automaton by locally coupling two Weyl automata.  Up to unitary
conjugation, its momentum-space step has two Weyl blocks and momentum-independent
off-diagonal mass blocks, with coefficients satisfying `n^2 + m^2 = 1`.  The
paper gives a paired quasienergy dispersion and an interpolating Hamiltonian of
Dirac form.

- A. Bisio, G. M. D'Ariano, P. Perinotti, and A. Tosini, "Free quantum field
  theory from quantum cellular automata: derivation of Weyl, Dirac and Maxwell
  quantum cellular automata," arXiv:1601.04832,
  <https://arxiv.org/abs/1601.04832>.
- A. Bisio, G. M. D'Ariano, P. Perinotti, and A. Tosini, "Weyl, Dirac and
  Maxwell Quantum Cellular Automata: analitical solutions and phenomenological
  predictions of the Quantum Cellular Automata Theory of Free Fields,"
  arXiv:1601.04842, <https://arxiv.org/abs/1601.04842>.

The first paper's full text was inspected through the local literature cache,
not only its abstract.  It also explicitly allows the identity Cayley-graph
generator when self-interaction is present.  That is relevant to the separate
stay-sector discussion: onsite amplitude is part of the local unitary rule, not
an external stochastic decision.

## Relation to the live HNU walk

The live construction has the same broad algebraic pattern:

1. `doubledChiralEndpoint k` contains opposite-momentum Weyl/HNU blocks;
2. `diracBasis` changes to the four-component Dirac basis;
3. `massCoin4` supplies a momentum-independent local mass turn; and
4. `massiveHNU = massCoin4 * diracHNU`.

This is a structural analogy, not a theorem imported from the papers.  HNU is a
Floquet endpoint with its own ordered pulse construction, so the published QCA
dispersion cannot simply be copied onto it.

## Recommended exact proof route

Numerical probes of the live Cayley generator at generic Brillouin-zone points
showed eigenvalues of the form `[-lambda1, -lambda2, lambda2, lambda1]`, with
zero trace and positive determinant.  Searches for one fixed complex-linear or
antiunitary matrix implementing the pairing did not produce a stable candidate.

The best next theorem order is therefore algebraic:

1. prove the Cayley generator has an even characteristic polynomial, equivalently
   `charpoly A = charpoly (-A)`;
2. derive opposite pairing of the four ordered real Hermitian eigenvalues;
3. combine pairing with the landed global zero gap to prove exact `2+2` inertia;
4. transfer inertia to rank two of `(1 - sign A) / 2`; and
5. only then ask whether that rank-two band is the physical sector.

If the even-polynomial statement fails, the numerical pairing must be treated as
a sampling artifact or replaced by the exact weaker invariant that survives.

## Nearby literature boundaries

Asboth and Obuse show that discrete-time chiral symmetry depends on the chosen
timeframe and controls paired zero/pi structure in one-dimensional walks:
<https://arxiv.org/abs/1303.1199>.  This supports auditing pulse order before
asserting a fixed chiral involution, but it does not prove a three-dimensional
HNU symmetry.

Gupta and Short's current Dirac-walk analysis uses nonzero stay amplitudes to
alter the doubling ledger while retaining a Dirac continuum limit:
<https://arxiv.org/abs/2601.15885>.  It also reports residual additional
low-energy solutions in `3+1`, so rank-two band selection is not by itself a
companion-removal theorem.

## Formal action

Aristotle project `d2f492c2-6a8c-4dff-b3da-11a35d5dccae` asks for exact HNU
eigenvalue pairing, `2+2` inertia, and rank two of the certified negative
Cayley-sign projector.  If direct ordered-eigenvalue reasoning stalls, the
continuation should be narrowed to the even-characteristic-polynomial identity
before returning to spectral order.

Focused helper project `cd0e99b3-fea6-4040-bed7-177530eb2736` isolates the
two-by-two reciprocal reduced-determinant identity.  Its successor is the
generalized HNU shifted-determinant reduction with an arbitrary nonzero spectral
parameter.  That successor has now landed, for arbitrary complex spectral
parameter, as
`HNUMassiveSpectralReciprocity.massiveHNU_general_shifted_det_reduction`.
The generic finite algebra has now also landed: determinant one of each chiral
block already forces the reduced degree-four polynomial to be reciprocal.
Equal trace and unitarity are not needed for this step.  Consequently every
nonzero characteristic root of the live HNU massive walk has its reciprocal as
another root.  The remaining conversion is from reciprocal unitary roots to
opposite real Cayley eigenvalues and then exact `2+2` inertia.
