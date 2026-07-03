# Null-edge cycle 04 literature notes

Date: 2026-07-02

Focus: after integrating the accumulated-angle product-error bound, review
which quantum-walk/checkerboard sources justify staying with asymptotic
operator estimates before stating any continuum Dirac theorem.

## Sources checked

1. P. Arrighi, M. Forets, and V. Nesme,
   "The Dirac equation as a quantum walk: higher dimensions, observational
   convergence," arXiv:1307.3524.
   Source: https://arxiv.org/abs/1307.3524

   Relevance: convergence is framed observationally and quantitatively for a
   causal homogeneous quantum walk. This supports the current Lean sequence:
   first prove explicit finite/asymptotic operator estimates, then state a
   topology-explicit continuum theorem.

2. F. W. Strauch, "Relativistic quantum walks," arXiv:quant-ph/0508096.
   Source: https://arxiv.org/abs/quant-ph/0508096

   Relevance: classic bridge between one-dimensional Dirac evolution and
   quantum walks. It motivates the checkerboard lane but does not by itself
   supply the exact topology/interpolation theorem still missing in Lean.

3. M. Skopenkov and A. Ustinov,
   "Feynman checkers: towards algorithmic quantum theory,"
   arXiv:2007.12879.
   Source: https://arxiv.org/abs/2007.12879

   Relevance: rigorous checkerboard asymptotics and turn-count framework. This
   remains the source anchor for future path-count and reversal-clock work.

4. P. Arrighi, G. Di Molfetta, I. Marquez-Martin, and A. Perez,
   "The Dirac equation as a quantum walk over the honeycomb and triangular
   lattices," arXiv:1803.01015.
   Source: https://arxiv.org/abs/1803.01015

   Relevance: useful reminder that quantum-walk Dirac limits need not be tied
   to one rectangular grid. This supports the scheduler/framing caution, but it
   is not a proof of any current 3+1D Gate C release.

5. U. Nzongani, N. Eon, I. Marquez-Martin, A. Perez, G. Di Molfetta, and
   P. Arrighi, "Dirac quantum walk on tetrahedra," arXiv:2404.09840.
   Source: https://arxiv.org/abs/2404.09840

   Relevance: adjacent to the tetrahedral/hyperdiamond lane. Keep it separate
   from the 1+1D checkerboard estimates unless a source-specific crosswalk is
   being built.

## Cycle-04 conclusion

The immediate next theorem should be an asymptotic API upgrade, not a continuum
Dirac theorem: convert the accumulated-angle bound and quotient estimate into
`IsLittleO`/filter-transport statements that can later be composed with a
chosen interpolation topology.
