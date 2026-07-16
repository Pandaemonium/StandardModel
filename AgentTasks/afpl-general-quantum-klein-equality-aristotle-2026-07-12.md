# Aristotle proof job: equality case of general quantum Klein

## Context

`PhysicsSM.Draft.NullEdge.GeneralQuantumKlein.qKlein_nonneg` proves the
non-commuting finite-dimensional quantum Klein inequality using a CFC-free
spectral logarithm and a doubly-stochastic eigenbasis-overlap reduction.
`GeneralMaxEntropy.vonNeumann_le_cross_entropy` therefore supplies the
general-`N` entropy bound, but uniqueness is still open. The missing strictness
theorem is the cleanest next operator-information rung.

## Immutable target

Create `PhysicsSM/Draft/NullEdge/GeneralQuantumKleinEquality.lean`, importing
`GeneralQuantumKlein`, and prove:

```lean
theorem qKlein_eq_zero_iff (rho sigma : Matrix n n Complex)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hrho_psd : rho.PosSemidef) (hsigma_pd : sigma.PosDef)
    (hrho_trace : rho.trace = 1) (hsigma_trace : sigma.trace = 1) :
    qRelEntropy rho sigma hrho hsigma = 0 <-> rho = sigma := by
  sorry
```

Keep `[Fintype n] [DecidableEq n]` and the exact `qRelEntropy` already defined
in `GeneralQuantumKlein`. Syntactic Unicode/ASCII changes are allowed; no
mathematical weakening is.

## Proof and audit requirements

- Reuse the existing overlap/scalar proof architecture where possible.
- Identify the exact equality conditions required for the scalar log/Jensen
  inequalities and show they force equality of the spectral matrices, not only
  equality of eigenvalue multisets.
- If degeneracy of eigenvalues complicates eigenvector uniqueness, reason at
  the matrix or spectral-projector level rather than imposing simple spectrum.
- Include the boundary control `rho = sigma` and a strict noncommuting positive
  `2 x 2` density witness. Do not add commutativity, full-rank for `rho`, simple
  spectrum, shared eigenbasis, or dimension restrictions.
- If the theorem is false for the entropy-compatible `logHermitian` convention
  at zero eigenvalues, provide an explicit exact counterexample and the
  corrected support-sensitive theorem. Do not assume ordinary logarithm at a
  singular matrix.
- Expected footprint: standard kernel axioms only. No new axiom, opaque
  placeholder, trust-expanding evaluator, or theorem weakening.

Success is the unchanged biconditional. An exact counterexample or a precise
missing strictness lemma is an acceptable prove-or-kill return, but a one-way
implication or commuting-only theorem is not a substitute.

## Submission metadata

- Aristotle project: `ac779534-f40d-4666-b98a-9d364996d6f7`
- Submission project: `AgentTasks/aristotle-submit/general-quantum-klein-equality-20260712-project`
- Lab work item: `DYN-MODULAR-001`
- Status: submitted 2026-07-12 by Codex
