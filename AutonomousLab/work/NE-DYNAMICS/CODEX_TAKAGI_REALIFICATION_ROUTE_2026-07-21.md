# Takagi fallback: real symmetric doubling

Date: 2026-07-21
Role: Archivist / Research Scientist
Work item: `MASS-ORIGIN-001`

## Sharpened blocker

The in-progress full Takagi proof has completed the conversion from a supplied
orthonormal phase-paired family to the exact unitary matrix equation and final
congruence.  One lemma remains: construct an orthonormal family `u_i` and
nonnegative `sigma_i` with

```text
A * vecStar (u_i) = sigma_i * u_i
```

for every finite complex symmetric `A`, including zero and repeated singular
values.

## Literature route

Dieci, Papini, and Pugliese give a finite realification that converts the
problem to the ordinary real symmetric spectral theorem.  Write

```text
A = B + i C,    B^T = B,    C^T = C,
M = [[B, C], [C, -B]].
```

Then `M` is a real symmetric `2n x 2n` matrix.  Its eigenvalues are the singular
values of `A` and their negatives.  If an orthonormal positive-eigenvalue frame
is written as stacked real columns `[X; Y]`, then `U = X + iY` is unitary and
gives a Takagi factorization.  The involution `[X;Y] -> [Y;-X]` supplies the
opposite eigenvectors automatically.

Primary source:
- Luca Dieci, Alessandra Papini, and Alessandro Pugliese, "Takagi
  Factorization of Matrices Depending on Parameters and Locating Degeneracies
  of Singular Values," arXiv:2110.15918, especially the real symmetric matrix
  construction and converse around equation (1):
  https://arxiv.org/abs/2110.15918

The source explicitly treats repeated and zero singular values as genuine
degeneracies, not removable hypotheses.  It also states the exact freedom in
each repeated nonzero block and the unrestricted unitary freedom in the zero
block.

## Lean decomposition

1. Define real and imaginary block matrices `B`, `C`, and the doubled real
   symmetric matrix `M`.
2. Prove `M` symmetric from `A.transpose = A`.
3. Apply Mathlib's real symmetric orthonormal eigenbasis theorem.
4. Prove the fixed involution anticommutes with `M`; nonzero eigenspaces pair as
   `sigma` and `-sigma`.
5. Choose one orthonormal half of each nonzero pair and reconstruct complex
   columns `X + iY`.
6. Handle the zero block separately as the complex kernel of `A`; choose a
   complex orthonormal basis there.  This is the only part not discharged by
   simply selecting positive real eigenvectors.
7. Feed the reconstructed columns into the already-completed assembly in the
   Aristotle snapshot.

## Decision

Keep the current antilinear-involution job running because its snapshot shows
substantive assembly progress.  If its remaining basis lemma does not close,
split the realification route into three focused jobs: doubled symmetry and
anticommutation; nonzero paired eigenspaces; zero-kernel complex basis and final
assembly.  Do not weaken by assuming invertibility or distinct singular values.

## Tool friction

The broad scholarly meta-search hit a Semantic Scholar HTTP 429.  Direct arXiv
and OpenAlex searches succeeded.  Neo4j full-text chunk search was reachable but
did not contain the Takagi paper.  Zotero MCP returned a local connection-refused
error during this pass, so no Zotero write was attempted.
