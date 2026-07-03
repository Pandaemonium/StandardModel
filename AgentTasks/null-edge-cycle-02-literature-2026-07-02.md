# Null-edge cycle 02 literature note

Date: 2026-07-02

Cycle objective: support the integrated checkerboard quotient estimates and
choose the next Aristotle handoff.

## Sources checked

- F. W. Strauch, *Relativistic quantum walks*, Phys. Rev. A 73, 054302
  (2006), DOI 10.1103/PhysRevA.73.054302, arXiv:quant-ph/0508096:
  <https://arxiv.org/abs/quant-ph/0508096>.
- G. Di Molfetta and P. Arrighi, *A quantum walk with both a continuous-time
  and a continuous-spacetime limit*, arXiv:1906.04483:
  <https://arxiv.org/abs/1906.04483>.
- I. Bialynicki-Birula, *Weyl, Dirac, and Maxwell equations on a lattice as
  unitary cellular automata*, Phys. Rev. D 49, 6920:
  <https://link.aps.org/doi/10.1103/PhysRevD.49.6920>.
- Kimura and Misumi, *Characters of Lattice Fermions Based on the Hyperdiamond
  Lattice*, arXiv:0907.1371:
  <https://arxiv.org/abs/0907.1371>.

## Lean consequences

1. The checkerboard/QW literature supports continuing from entrywise quotient
   estimates toward a normed finite-dimensional product estimate. The next Lean
   scaffold should make the matrix norm explicit rather than hiding it behind
   generic topology.
2. Di Molfetta--Arrighi reinforces the need to keep continuous-time
   discrete-space and continuous-spacetime limits distinct. The current Lean
   results are finite/asymptotic scaffold only.
3. Bialynicki-Birula supports the broader QCA/Dirac-limit orientation, but not
   a theorem in this package without explicit scaling/topology hypotheses.
4. Kimura--Misumi keeps the hyperdiamond lane pointed at source-fixed pole data
   and non-nearest/fifth-vector ingredients before any named-operator no-go.
