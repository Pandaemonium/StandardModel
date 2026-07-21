# Proof job: physical singular masses of the mixed pseudo-Dirac branch

Work in Lean 4.28 with Mathlib. Build a self-contained finite-dimensional
module for a two-state complex symmetric Majorana/Dirac mass matrix

```text
M(ML,mD,MR) = [[ML,mD],[mD,MR]].
```

The physics convention is important: physical Majorana masses are Takagi
values, equivalently singular values, not the ordinary complex eigenvalues of
`M`. Borisov and Isaev, arXiv:2312.17714 Appendix C, is the source anchor.
Mathlib semantic search found `LinearMap.singularValues`,
`LinearMap.singularValues_nonneg`, `LinearMap.singularValues_fin`, and
Hermitian unitary diagonalization, but no direct Takagi theorem.

Prove as much of this exact ladder as possible, with no semantic weakening:

1. Define `massMatrix` and the Hermitian positive-semidefinite squared-mass
   matrix `K = M.conjTranspose * M`. Prove Hermiticity and the quadratic-form
   nonnegativity statement explicitly.
2. Compute exact invariants

   ```text
   trace K = normSq ML + 2 * normSq mD + normSq MR
   det K = normSq (ML * MR - mD^2).
   ```

   A formulation using `Complex.normSq` or `Complex.abs ^ 2` is acceptable if
   it typechecks cleanly and all coercions are explicit.
3. Package the two nonnegative squared physical masses as the two eigenvalues
   of `K`. Ideally derive the explicit quadratic formula in terms of the trace
   and determinant, including a proof that the discriminant is nonnegative.
   If Mathlib's spectral API makes this too expensive, prove a finite
   characteristic-polynomial theorem plus explicit nonnegativity for every
   eigenvalue of `K`; do not call arbitrary complex eigenvalues masses.
4. Pure-Dirac control: for `ML=MR=0`, prove `K = normSq(mD) I`, hence the two
   squared physical masses are degenerate.
5. Seesaw/pseudo-Dirac controls: for a clearly stated real specialization,
   relate the singular masses to the absolute values of the real-symmetric
   signed roots, keeping every sign and nonnegativity assumption visible.
6. Mandatory semantic counterexample: use

   ```text
   N = [[1, I],[I,-1]].
   ```

   Prove `N` is complex symmetric, nonzero, and nilpotent (`N*N=0`), so its
   ordinary algebraic eigenvalues are all zero, while `N.conjTranspose*N` is
   nonzero (preferably compute its trace as `4`). This demonstrates exactly why
   the existing algebraic eigenvalue formulas cannot be read as physical
   Majorana masses.
7. Optional ambitious successor: state and prove a two-by-two Autonne-Takagi
   factorization `U.transpose * M * U = diag(s1,s2)` with unitary `U` and
   `0 <= s_i`. Attempt arbitrary dimension only if the available API makes it
   natural.

Return one Lean source file and a concise completion report. Use only Mathlib
and the standard three axioms. No proof placeholders, compiler-trusted
evaluation, fake assumptions, or ordinary-eigenvalue language masquerading as
physical mass. Preserve the nilpotent control even if the positive theorem has
to stop at the squared-mass matrix.

Relevant semantic context:
`AgentTasks/context-packs/mixed-pseudodirac-physical-mass-20260721-20260721-030149.md`.
