# Null-edge cycle 01 literature refresh

Date: 2026-07-02

Cycle objective: support the current Aristotle jobs and local Lean work on the
checkerboard generator expansion and the hyperdiamond pole-structure/no-four-edge
target.

## Sources checked

- F. W. Strauch, *Relativistic quantum walks*, arXiv:quant-ph/0508096.
  Relevant because it explicitly connects one-dimensional Dirac dynamics and
  quantum walks: <https://arxiv.org/abs/quant-ph/0508096>.
- Di Molfetta and Arrighi, *A quantum walk with both a continuous-time and a
  continuous-spacetime limit*, arXiv:1906.04483. Relevant for separating a
  continuous-time discrete-space Hamiltonian limit from a continuous-spacetime
  Dirac limit: <https://arxiv.org/abs/1906.04483>.
- Creutz, *Four-dimensional graphene and chiral fermions*, arXiv:0712.1201.
  Relevant as the source-side origin of the minimally doubled chiral action:
  <https://arxiv.org/abs/0712.1201>.
- Borici, *Creutz Fermions on an Orthogonal Lattice*, arXiv:0712.4401. Relevant
  for the orthogonal-lattice form and fixed-parameter continuum-limit claim:
  <https://arxiv.org/abs/0712.4401>.
- Bedaque, Buchoff, Tiburzi, Walker-Loud, *Search for Fermion Actions on
  Hyperdiamond Lattices*, arXiv:0804.1145. Relevant because it separates
  hyperdiamond symmetry from minimal doubling: <https://arxiv.org/abs/0804.1145>.
- Kimura and Misumi, *Characters of Lattice Fermions Based on the Hyperdiamond
  Lattice*, arXiv:0907.1371. Relevant because it explicitly ties correct
  excitations to pole/Lorentz-covariance conditions and non-nearest-site
  hoppings: <https://arxiv.org/abs/0907.1371>.
- Kimura and Misumi, *Lattice Fermions Based on Higher-Dimensional Hyperdiamond
  Lattices*, arXiv:0907.3774. Relevant for Creutz/Borici conditions and the
  tightening of minimal-doubling parameter ranges:
  <https://arxiv.org/abs/0907.3774>.
- Kishore, Basak, Chakrabarti, *Eigenspectra of Minimally Doubled Fermions*,
  arXiv:2501.10336. Relevant because it reinforces that minimally doubled
  formulations need spectral-flow/flavored-chirality information beyond plain
  spacetime `gamma5`: <https://arxiv.org/abs/2501.10336>.

## Consequence for Lean

1. The checkerboard job should stay focused on `HasDerivAt isotropicStep
   isotropicGenerator 0`, exact generator decomposition, and later explicitly
   stated limit hypotheses. It should not claim a continuum Dirac theorem yet.
2. The hyperdiamond job should define pole/excitation predicates and strengthen
   the fifth-vector truncation mismatch. It should not instantiate a named
   Borici-Creutz operator without source-fixed gamma basis, phases,
   normalization, pole locations, onsite/fifth-vector terms, and chirality data.
