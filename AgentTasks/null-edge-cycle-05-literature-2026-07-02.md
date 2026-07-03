# Null-edge cycle 05 literature notes

Date: 2026-07-02

Focus: after integrating the topology-explicit checkerboard-to-Dirac design
layer, identify literature support for the next Lean target: a momentum-space
matrix-exponential/Trotter estimate.

## Sources checked

1. P. Arrighi, M. Forets, and V. Nesme,
   "The Dirac equation as a quantum walk: higher dimensions, observational
   convergence," arXiv:1307.3524.
   Source: https://arxiv.org/abs/1307.3524

   Relevance: this is the strongest anchor for the next Lean job. The abstract
   explicitly frames convergence through quantum walks, operator splitting,
   Trotter-Kato, and an `O(eps^2)` observational discrepancy. For our
   standalone package, it supports proving a finite-dimensional
   momentum-symbol Trotter estimate before moving to an `L2` or position-space
   theorem.

2. F. W. Strauch, "Relativistic quantum walks," arXiv:quant-ph/0508096.
   Source: https://arxiv.org/abs/quant-ph/0508096

   Relevance: motivates the one-dimensional Dirac/quantum-walk connection and
   wave-packet picture. It supports the physical direction of the checkerboard
   lane but is less directly Lean-facing than the operator-splitting paper.

3. K. A. Earle, "Notes on The Feynman Checkerboard Problem,"
   arXiv:1012.1564.
   Source: https://arxiv.org/abs/1012.1564

   Relevance: useful convention and reconciliation reference for path-sum
   checkerboard formulas. It is more relevant to the source-faithful path-sum
   asymptotic cross-check than to the immediate Trotter estimate.

4. M. Skopenkov and A. Ustinov,
   "Feynman checkers: towards algorithmic quantum theory,"
   arXiv:2007.12879.
   Source: https://arxiv.org/abs/2007.12879

   Relevance: rigorous asymptotics for the Feynman checkers model and turn-count
   formulation. Keep this as the anchor for the future closed-form/path-count
   asymptotic route.

## Cycle-05 conclusion

The next high-value Aristotle job should be narrow and operator-theoretic:
prove the per-step expansion of `momentumStepSymbol` and a matrix-power/Trotter
stability theorem sufficient to promote the commented
`checkerboard_dirac_limit_statement` into a real asymptotic theorem. The
path-count asymptotic route remains valuable, but it is a separate cross-check,
not the shortest path to the first pointwise momentum convergence theorem.
