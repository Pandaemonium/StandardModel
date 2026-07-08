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

## Focus-2 result (spectra & budgets): carrier mass phase diagram

`carrier_spectrum_sim.py` (Lean-anchored to T2_positive_mass, signed_budget_sum
_one, posDef_iff_det_pos). On the two-edge Cl(4) carrier the physical-sector mass
form has eigenvalues {lambda, lambda+kappa, lambda-kappa}; the SQUARED MASS GAP
= least eigenvalue = **lambda - kappa** (aperture minus closure), so:
  * massive phase: kappa < lambda (aperture dominates), gap = lambda - kappa;
  * massless critical line: kappa = lambda (exact, kappa_crit/lambda = 1.000);
  * positivity lost: kappa > lambda.
A clean finite critical-coupling phase diagram, matching the Delta binding-defect
critical point. This is the dynamics/spectra simulator's first physics output and
a candidate manuscript result (finite mass gap = aperture - closure on a concrete
carrier). NOTE: exact values are specific to this block-diagonal witness; the
STRUCTURE (gap = aperture-dominance margin, critical at parity) is the claim.

## Dynamics-simulation layer COMPLETE (3 directions, all Lean-anchored)

- (A) carrier_spectrum_sim.py - mass phase diagram (gap = aperture-closure).
- (B) carrier_evolution_sim.py - unitary evolution, spectrum resolution,
  quantum-walk transfer operator, 2-fermion Slater scattering amplitudes.
- (C) carrier_rgflow_sim.py - Schur RG flow (k_eff = t^2/mu, invariant mu*k_eff),
  canonical ensemble (Z, F=<E>-TS, ground dominance), condensate near-zero-mode
  fraction rising to the critical line (finite Banks-Casher shadow).
Each block validated against a landed M-identity (T2, budget, FiniteUnitary
Evolution, FiniteRGFlow, FiniteCanonicalEnsemble, RGSchurMassWitness). The Lean
IS the simulation spec + validation oracle - Focus-2 goal met at the demo level.
