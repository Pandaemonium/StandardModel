# Literature memo: Takagi factorization and physical Majorana masses

Date: 2026-07-21
Owner: Codex / Archivist lane
Work item: `MASS-ORIGIN-001`

## Question

What finite theorem should replace ordinary complex-eigenvalue language for a
general complex symmetric Majorana mass matrix?

## Source result

The convention-locked target is the Autonne-Takagi factorization

`A = U * diagonal(sigma) * U.transpose`,

where `A.transpose = A`, `U` is unitary, and every `sigma i` is real and
nonnegative. The entries of `sigma` are the singular values, so their squares
are the eigenvalues of `A^H A`. This is a unitary congruence, not an ordinary
unitary similarity diagonalization.

Primary anchors:

- L. Dieci, A. Papini, and A. Pugliese, *Takagi factorization of matrices
  depending on parameters and locating degeneracies of singular values*,
  arXiv:2110.15918. The paper treats the zero and repeated-singular-value cases
  as genuine structural cases rather than assuming a simple spectrum. Zotero
  key `AX8PHHAI`.
- D. Borisov and F. Isaev, arXiv:2312.17714, Appendix C, used by the current
  two-state Majorana semantics. Zotero key `I9NUBC9A`.
- R. Horn and F. Zhang, DOI `10.1080/03081087.2011.618838`, states the complex
  factorization `A = U Sigma U^T` and identifies `Sigma` with the singular-value
  diagonal. The paper's main extension is quaternionic; only its stated complex
  baseline is relevant here.

## Lean-library result

`lean-explore` over Mathlib found no existing Autonne-Takagi declaration. It did
find the main reusable infrastructure:

- `LinearMap.singularValues`;
- `LinearMap.singularValues_nonneg`;
- `LinearMap.singularValues_fin`, identifying singular values with square roots
  of eigenvalues of the adjoint composite;
- `Matrix.IsHermitian.conjStarAlgAut_star_eigenvectorUnitary`, the finite
  Hermitian unitary diagonalization theorem;
- `Matrix.eigenvalues_self_mul_conjTranspose_nonneg`.

The PhysLean search found neutrino phase declarations but no Takagi
factorization or Majorana singular-mass diagonalization theorem.

## Consequence for the project

The landed two-state module
`MixedPseudoDiracPhysicalMass.lean` correctly proves the eigenvalues of `M^H M`
and includes a nonzero complex symmetric nilpotent matrix whose ordinary
eigenvalues all vanish while its singular data do not. It closes the two-state
mass-semantics correction, but not arbitrary generation number.

The next theorem should prove the finite `Fin n` Takagi factorization with:

1. the exact `A = U Sigma U^T` orientation;
2. explicit unitarity of `U`;
3. nonnegative real diagonal `sigma`;
4. identification of `sigma^2` with the spectrum of `A^H A`;
5. zero and repeated-singular-value cases included, not excluded by a hidden
   simple-spectrum hypothesis.

An acceptable partial return is a precise Mathlib API blocker proving that the
missing step is phase-compatible pairing of the two SVD bases. It is not
acceptable to replace Takagi congruence by Hermitian similarity diagonalization.

## Formalization audit update

An in-progress Aristotle return exposed a false-shape error in the first Lean
translation of the squared-mass corollary. In Mathlib notation, `star U` is the
conjugate transpose `U^H`; it is not the entrywise conjugate matrix required on
the left side after substituting a Takagi congruence. The correct left factor is
`U.transpose\u1d34` (equivalently, entrywise conjugation in the finite complex
matrix convention used by the task).

The snapshot kernel-checks four useful pieces:

1. a unitary eigenbasis for the positive Hermitian squared-mass operator;
2. Takagi assembly conditional on a phase-compatible paired basis;
3. the corrected squared-mass identity; and
4. an exact `2 x 2` quarter-turn counterexample to the incorrectly oriented
   identity: the Takagi congruence side is `-1` while the bad right side is `1`.

The remaining theorem is therefore sharply isolated. One must construct the
phase-compatible pairing inside zero and repeated singular-value subspaces.
Ordinary Hermitian diagonalization supplies the squared singular values but does
not by itself choose those phases. The false identity is retired rather than
weakened or silently repaired in prose.

The hole-free partial spine is now landed in
`FiniteTakagiMajoranaPartial.lean` with build-enforced axiom pins. The full
Autonne-Takagi existence theorem is not landed and remains the named
phase-compatible basis problem above.

## Claim boundary

Even a full finite Takagi theorem classifies physical nonnegative mass
parameters for a supplied complex symmetric matrix. It does not derive that
matrix, select flavor textures or absolute scales, establish a propagator pole,
or choose the observed neutrino branch.
