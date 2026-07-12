# Direct literature pass: `3+1` doubling escapes after the reciprocal slice no-go

Date: 2026-07-11 22:50 PDT  
Owner: Codex  
Mode: direct fallback after Spark worker context exhaustion

## Ranked primary sources

1. [Bakircioglu, Arnault, Arrighi, *Fermion Doubling in Quantum Cellular
   Automaton Models*](https://arxiv.org/abs/2505.07900), especially Sections
   4-6 and Appendix C/D.  The paper gives a discrete-time determinant-level
   doubling analysis and removes spurious neighborhoods by an eight-sheeted
   Brillouin-zone covering in `3+1`, interpreted as an eight-flavour QCA.  It
   preserves linearity and chiral symmetry by changing the lattice/translation
   representation rather than finding a single-cone four-component symbol.
   This is the most concrete successor to our failed direct reciprocal P1:
   enlarge the register and prove a covering equivalence, not another
   four-component corner perturbation.

2. [Gupta and Short, *Fermion Doubling in Dirac Quantum
   Walks*](https://arxiv.org/abs/2601.15885), Sections III and the doubling
   appendices.  Their stationary-amplitude projector family removes conventional
   doublers and pseudo-doublers for suitable parameters, but in `3+1` retains
   exactly two extraneous low-energy solutions `+/-q(theta)` because the
   construction combines one-dimensional walks axis by axis.  This supports
   our exact alias result and identifies the next theorem: derive and classify
   those two non-corner roots in the live rational fixture.

3. [Nzongani et al., *Dirac quantum walk on
   tetrahedra*](https://arxiv.org/abs/2404.09840), Sections II-IV and Appendix
   B.  The walk uses an ordered tetrahedral/cell register and strictly local
   shift, basis, and mass operations to obtain the `3+1` Dirac equation in the
   continuum.  The robust boundary construction doubles the internal degrees
   of freedom.  It is a construction precedent for enlarging directional
   memory, but it does not provide an all-zone no-doubling theorem in the cited
   result.

4. [D'Ariano and Perinotti, *Quantum cellular automata and free quantum field
   theory*](https://arxiv.org/abs/1608.02004).  This derives Weyl/Dirac/Maxwell
   automata from unitarity, homogeneity, locality, and isotropy on Cayley graphs.
   It is valuable for admissible architecture and convention design, not by
   itself a root-exclusion certificate.

5. [Bialynicki-Birula, *Weyl, Dirac, and Maxwell equations on a lattice as
   unitary cellular automata*](https://doi.org/10.1103/PhysRevD.49.6920).
   Historical exact-unitary `3+1` construction precedent.  Any borrow requires
   a fresh basis, lattice, and Fourier-sign audit before comparison with the
   repository symbol.

## Strategic conclusion

The literature does not justify expecting a unique-cone four-component repair
inside the already-tested axiswise families.  The two strongest exact routes
are instead:

- **minimal-doubling census:** prove that the stationary-amplitude rational
  fixture has exactly the origin, one exact corner alias, and one off-corner
  conjugate pair, matching Gupta-Short's `+/-q(theta)` structure; or
- **covering/register theorem:** formalize the eight-sheeted `3+1` covering as
  a finite flavour register and prove that all old Brillouin-zone aliases map
  to one physical momentum with explicit flavour labels.

The covering route solves doubling by reinterpreting multiplicity as flavour;
it does not derive the Standard Model family count or eliminate extra physical
degrees of freedom.  The tetrahedral route similarly changes the microscopic
cell and owes an all-zone root census.

## Lean-shaped next targets

1. `stationaryWeyl_identity_iff`: express `U(zx,zy,zz)=I` as three explicit
   real Laurent-polynomial equations and classify all unit-torus solutions up
   to conjugation and inversion.
2. `stationaryWeyl_exactly_four_zero_nodes`: after proving the two oracle roots
   algebraic, package a `Finset` equality and nondegenerate Jacobian at each
   root.
3. `flavourCover_preimage_census`: define the finite `Z2^3` flavour action on
   phase tuples and prove every original alias orbit has one representative in
   the reduced Brillouin zone.
4. `flavourCover_intertwines_walk`: prove the enlarged-register walk is
   unitarily equivalent to the original walk pulled back along the covering.
5. `tetrahedral_symbol_root_census`: compute the exact finite symbol and test
   `det(U-I)=0` and `det(U+I)=0` over its full reciprocal cell before claiming
   it as a successor.

## Convention and licensing notes

The cited arXiv papers are mathematical references, not source-code imports.
The repository must independently lock Fourier signs, quasienergy branch,
register order, spatial lattice, and chirality conventions.  No external code
was copied.  The covering paper's `flavouring` is a physical reinterpretation
with an enlarged register, not an alias-free single-species theorem.
