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

## Lit pass 2026-07-08 (~post call-05): mass-side QW prior art

Ran neo4j chunk search (QW continuum-limit / coin-operator-as-mass). Top hit and
a genuine novelty check:

- **Mlodinow & Brun, "Discrete spacetime, quantum walks and relativistic wave
  equations" (arXiv:1802.03910, PRA 97 042131, 2018).** A 3D quantum walk whose
  coin space must be (at least) **4-dimensional**, which FORCES the Dirac gamma
  matrices, imposed by parity + a discrete-rotation ("noncorrelation") symmetry.
  The **coin-flip operator gives the mass term**; setting the internal phase
  operators Q_{X,Y,Z}=0 yields a MASSLESS particle (min coin dim drops to 2).
  This is the closest *mass-side* prior art: "mass = an internal operator you
  can switch off," directly rhyming with our two-null-edge Cl(4) carrier and its
  massless critical line kappa=lambda. Distinctions (our novelty): no Krein
  grading, no four-channel budget, no det P tie; their single coin operator is
  our aperture/closure pair. ACTED: added to §2a (mass-side comparator sentence),
  References, source map. Not source support for our budget - a comparator.

TODO (still open): full-text Manighalam-Kon coin-classification (which carriers
admit a continuum limit) - complements Mlodinow-Brun's 4D-coin-forcing result.

## Lit pass 2026-07-08 (continuum-limit classification) - TODO closed

Chunk search for "which QWs admit a continuum limit / coin classification".
Manighalam-Kon is NOT in the ingested null-edge graph; the graph's actual
continuum-limit anchors are (a) Mlodinow-Brun 1802.03910 - the necessary
conditions (4D coin carrying the gammas + parity + noncorrelation/discrete-
rotation) for a QW to yield the Dirac equation in the continuum - and (b) the
checkerboard continuum theorem (Gersch; Jacobson-Schulman), PROVEN for the 1+1D
chain (already cited). So the "which carriers admit a continuum limit" TODO is
effectively ANSWERED by Mlodinow-Brun; ACTED by making §9a's QW continuum-limit
remark concrete (naming those conditions, cross-ref §2a) instead of a bare "cf."
No need to chase Manighalam-Kon via external scholarly search.

## Lit pass 2026-07-08 (core-thesis novelty check) - reassuring negative

Chunk-searched the graph for the DEFINING thesis "mass = obstruction to coherent
null transport / geometric disagreement of null directions". Nearest hits (all
< 0.75 similarity, none a match):
- Causal-set tails / back-scattering off curvature (Sorkin school) - a different
  propagation phenomenon, not mass-as-null-disagreement;
- energy-momentum diffusion from discreteness (massless stays on the light cone);
- "Discreteness without symmetry breaking" direction-map theorem (relevant to our
  null-frame/direction claims, already in the Malament-split discussion);
- minimally-doubled fermions: backward/forward propagating states in parallel
  correlators (a doubling-side neighbor, already covered in §8).
NO prior art frames mass as null-direction disagreement / null-transport
obstruction. This substantiates the §2a claim ("we did not find this specific
tie ... and we make no primacy claim"); the classical spinor-helicity fact
(P^2 = sum|<ij>|^2) remains the honest nearest [import], already credited. No
manuscript edit needed - §2a already states this conservatively.

## Direction B deepened: carrier_scattering_sim.py (finite S-matrix)

Added the 4th dynamics simulator: a 1+1D Dirac QW with a mass barrier. Unitary
+ norm-conserving S-matrix (|T|+|R|=1 after clearance), transmission monotone-
down in barrier mass and ->1 as m0->0 (massless region transparent = critical
line as a scattering statement), reciprocal (T_L=T_R < 1e-3). Faithful regime =
small coin angle (Mlodinow-Brun continuum). All checks pass. Wired into S9a +
Appendix A. Directions A+B+C now covered by 4 Lean-anchored sims.

## Lit pass 2026-07-08 (grounding the scattering sim)

Chunk search for "Klein tunneling Dirac mass barrier transmission QW". Top hit:
- **Bisio, D'Ariano, Perinotti, Tosini, "Weyl, Dirac and Maxwell Quantum Cellular
  Automata" (arXiv:1601.04842)**, section "Scattering against a potential
  barrier" - the 1D Dirac QCA scattered against a position-dependent barrier,
  exactly the setup of carrier_scattering_sim.py. ACTED: cited in the sim
  docstring (specific paper+section), manuscript References, and source map. The
  established prior-art anchor for our finite S-matrix; the barrier-mass ->
  aperture-closure-gap anchoring remains ours.
