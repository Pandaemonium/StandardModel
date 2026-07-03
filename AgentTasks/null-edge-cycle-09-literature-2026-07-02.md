# Null-edge cycle 09 literature note

Date: 2026-07-02

## Search focus

After integrating the one-step checkerboard-to-Dirac estimates, the next Lean
target is not another local Taylor bound. It is the accumulated, fixed-time
pointwise momentum theorem:

```text
momentumEvolution D p
  versus
diracEvolutionSymbol D.m p D.totalTime
```

The literature pass therefore focused on quantum-walk/Dirac continuum limits,
operator-norm stability, and checkerboard path-integral continuum claims.

## Sources checked

- Arrighi, Forets, Nesme, "The Dirac equation as a quantum walk: higher
  dimensions, observational convergence", arXiv:1307.3524.
  Link: https://arxiv.org/abs/1307.3524
  Relevance: still the best conceptual source for the convergence shape. It
  frames the walk as discrete, homogeneous, causal, and unitary, and uses an
  observational convergence stance. This supports keeping our first theorem
  pointwise/windowed rather than claiming global position-space convergence
  too early.

- Earle, "Notes on The Feynman Checkerboard Problem", arXiv:1012.1564.
  Link: https://arxiv.org/abs/1012.1564
  Relevance: useful for the parallel path-sum/combinatorial lane. It should not
  be used as a substitute for the operator-norm Trotter proof now being built,
  but it remains a source for auditing closed-form propagator conventions.

- Skopenkov/Ustinov Feynman-checker literature, including
  "Feynman checkers: lattice quantum field theory with real time".
  Link: https://arxiv.org/html/2208.14247v2
  Relevance: reinforces the need to distinguish finite checkerboard amplitudes,
  continuum propagator limits, and normalization conventions. It is a good
  caution against silently upgrading finite sums to continuum propagators.

- Mlodinow/Brun-style discrete-time Dirac quantum-walk continuum-limit work,
  e.g. arXiv:1803.01015 / Phys. Rev. A 97, 042131.
  Link: https://arxiv.org/pdf/1803.01015
  Relevance: supports the broader quantum-walk continuum-limit framing. It is
  less directly useful for the current 1+1D Lean target than Arrighi et al.,
  because our present proof is a finite `2 x 2` momentum-symbol Trotter problem.

- Recent broader quantum-walk continuum-limit material, e.g. "Continuum Limits
  of Lazy Open Quantum Walks", arXiv:2512.17755.
  Link: https://arxiv.org/html/2512.17755v1
  Relevance: not a direct source for our unitary checkerboard theorem, but it
  confirms that modern work still separates unitary ballistic/Dirac limits from
  dissipative or dephased variants. We should not import open-system claims into
  the present unitary finite-core statement.

## Takeaways for Lean

1. Keep the next theorem pointwise in momentum and finite-dimensional. This
   matches the current API and avoids premature function-space commitments.
2. The L2 operator norm is now the best stability norm for the finite walk:
   the integrated Lean proves the one-step symbol and its finite powers are
   unitary with norm exactly `1`.
3. The product/exponential identity is now kernel-checked locally as
   `continuumStepSymbol_pow_eq_diracEvolutionSymbol`, and the concrete finite
   power-stability wrappers are checked as
   `linftyOpNorm_momentumEvolution_sub_continuumPow_le` and
   `linftyOpNorm_momentumEvolution_sub_diracEvolution_le`; the immediate
   missing bridge is choosing uniform/eventual constants under refinement.
4. The checkerboard combinatorics lane remains valuable as an independent
   source-faithful cross-check, but it should not block the Trotter theorem.

## Next Aristotle request suggested by this pass

Ask Aristotle for the accumulated pointwise Trotter theorem in the scoped L2 or
L-infinity operator norm, using the already-proved finite stability wrapper
`linftyOpNorm_momentumEvolution_sub_diracEvolution_le`.

Also ask it to recommend whether the final public theorem should be stated in
the scoped L2 operator norm first, then bridged back to `matrixL1Norm`, or kept
entirely in the finite entrywise norm for statement simplicity.
