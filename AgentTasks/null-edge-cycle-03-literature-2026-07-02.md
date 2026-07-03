# Null-edge cycle 03 literature notes

Date: 2026-07-02

Focus: checkerboard normed product bounds after integrating the Aristotle
`matrixL1Norm` result, plus nearby quantum-walk continuum references.

## Sources checked

1. M. Skopenkov and A. Ustinov,
   "Feynman checkers: towards algorithmic quantum theory,"
   arXiv:2007.12879, Russian Math. Surveys 77:3 (2022), 73-160.
   Source: https://arxiv.org/abs/2007.12879

   Relevance: rigorous checkerboard asymptotics and turn-count formulation.
   This remains the closest source anchor for finite path sums, turn grouping,
   and future reversal-clock questions.

2. P. Arrighi, M. Forets, and V. Nesme,
   "The Dirac equation as a quantum walk: higher dimensions, observational
   convergence," arXiv:1307.3524, J. Phys. A 47 (2014) 465302.
   Source: https://arxiv.org/abs/1307.3524

   Relevance: proves observational convergence of a causal homogeneous quantum
   walk to Dirac evolution with an explicit discretization-error order. The
   paper supports shaping the next Lean target as a normed product/scaling
   theorem before claiming a continuum Dirac theorem.

3. P. Arrighi, G. Di Molfetta, I. Marquez-Martin, and A. Perez,
   "The Dirac equation as a quantum walk over the honeycomb and triangular
   lattices," arXiv:1803.01015, Phys. Rev. A 97 (2018) 062111.
   Source: https://arxiv.org/abs/1803.01015

   Relevance: grid-free/lattice-geometry variation for quantum-walk Dirac
   limits. Useful for the scheduler/framing discussion because it warns against
   treating one fixed grid as the only possible discrete support.

4. P. Arrighi, G. Di Molfetta, and S. Facchini,
   "Quantum walking in curved spacetime: discrete metric,"
   arXiv:1711.04662, Quantum 2 (2018) 84.
   Source: https://arxiv.org/abs/1711.04662

   Relevance: supports the future causal-scheduler lane at the level of
   quantum walks with metric-like/local-speed data. It does not support any
   present claim that the standalone package derives gravity.

5. U. Nzongani, N. Eon, I. Marquez-Martin, A. Perez, G. Di Molfetta, and
   P. Arrighi, "Dirac quantum walk on tetrahedra," arXiv:2404.09840.
   Source: https://arxiv.org/abs/2404.09840

   Relevance: directly adjacent to the tetrahedral/hyperdiamond lane. It is
   useful for future source-specific crosswalk work, but it should remain
   separate from the 1+1D checkerboard product-bound lane.

## Cycle-03 conclusion

The next local Lean target should stay modest: use the newly integrated exact
product/remainder norm identity to prove a finite or one-variable asymptotic
product-error statement. A full checkerboard-to-Dirac continuum theorem should
wait until the topology, interpolation map, and evolution comparison norm are
fixed explicitly.
