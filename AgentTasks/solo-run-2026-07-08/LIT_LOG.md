# Solo run literature log (2026-07-08)

## Sweep 1 - dynamics / simulation frontier (Focus 2 kickoff)

Quantum-walk continuum limits + lattice-Dirac (directly relevant to Focus-2
evolution/transfer-operator + the checkerboard bridge F8/T6):

- Manighalam & Kon, "Continuum Limits of the 1D Discrete Time Quantum Walk"
  (arXiv:1909.07531) - formal framework for which DTQW "coins" admit continuum
  limits; the continuous-space limit yields massless Dirac states. Directly
  informs the transfer-operator -> Dirac continuum-limit direction.
- Succi, Fillion-Gourdeau, Palpacelli, "Quantum Lattice Boltzmann is a quantum
  walk" (arXiv:1504.03158) - operator-splitting / QLB schemes ARE quantum walks
  whose continuum limit gives Dirac; a concrete numerical-scheme <-> QW bridge
  (useful for the Python evolution sim).
- Nzongani et al., "Dirac quantum walk on tetrahedra" (arXiv:2404.09840) -
  (3+1)D Dirac from a QW on a TETRAHEDRAL space (matter on a spin network). Very
  close to our tetrahedral regulator + null-edge propagation; a template for the
  evolution/scattering sim on the tetrahedral lattice.
- Gupta & Short, "Fermion Doubling in Dirac Quantum Walks" (arXiv:2601.15885) -
  doubler-free QW families (F7 lineage; already logged in the lit review).
- Janiurek & Kendon, "Continuum Limits of Lazy Open Quantum Walks"
  (arXiv:2512.17755) - PDE continuum limit incl. decoherence; a "rest state" as
  an internal dof (adjacent to the turn channel).

TODO: full-text the Nzongani tetrahedral QW (matches our regulator) and the
Manighalam-Kon coin-classification (which carriers admit a continuum limit).
