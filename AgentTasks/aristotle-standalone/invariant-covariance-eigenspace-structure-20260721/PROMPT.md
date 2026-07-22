# Job: WHY rank controls regional variance - the eigenspace explanation

Mathlib-only, finite, real. This is the structural explanation of an already-proved
dichotomy, and a kernel refutation of any item is a first-class result.

## Background (proved, do not redo)
For a finite transitive group action, invariant PSD covariances that annihilate the
uniform mode behave in two ways:
- **rank 2** (2-transitive): every such covariance is `q . (I - J/N)`, so the regional
  variance is FORCED to `q |A| (N - |A|) / N` - linear in `|A|` for small regions.
- **higher rank**: a six-cycle Laplacian witness is invariant, PSD, hyperuniform, and has
  arc variance exactly `2` for EVERY proper arc - bounded, not growing.

Existence is never obstructed: `I - J/N` is hyperuniform at rank 2 too. The dichotomy is
about the SHAPE of the regional variance. This job explains why, structurally.

## The proposed explanation
The invariant matrices form a commutative algebra spanned by the pair-orbit indicators
(an association-scheme / Bose-Mesner situation). It decomposes the space into common
eigenspaces `V_0 = span(1), V_1, ..., V_(r-1)`. An invariant `C` acts as a scalar `c_i`
on each `V_i`; PSD means every `c_i >= 0`; hyperuniform means `c_0 = 0`. Then
`V(C, A) = sum_(i >= 1) c_i * ‖proj_(V_i) 1_A‖^2`.

**Rank 2 has exactly ONE nontrivial eigenspace**, so `C` is determined up to one scalar
and the regional variance has no shape freedom. **Rank `r >= 3` has `r - 1` of them**, so
the variance can be reweighted across eigenspaces - which is exactly the freedom the
cyclic witness exploits.

## Targets

1. **The invariant algebra is commutative and spanned by pair-orbit indicators.** State
   and prove as much as is clean: the pair-orbit indicator matrices are linearly
   independent, span the invariant matrices, and are closed under multiplication (so the
   span is an algebra). If closure under multiplication is heavy, prove linear
   independence + spanning and state closure as the association-scheme hypothesis.
2. **Simultaneous diagonalization.** For a commuting family of real symmetric matrices,
   there is an orthogonal decomposition into common eigenspaces. Use Mathlib's spectral
   theorem / commuting-family results if available; otherwise state it for a single
   symmetric `C` and its spectral projections.
3. **THE VARIANCE FORMULA - the heart of the job.** For symmetric `C` with orthogonal
   spectral decomposition `C = sum_i c_i P_i` (the `P_i` orthogonal projections summing to
   the identity), prove
   `regionalVariance C A = sum_i c_i * ‖P_i (1_A)‖^2`.
   This is elementary and is the whole explanation: the region enters ONLY through how its
   indicator distributes across eigenspaces.
4. **Rank-2 rigidity re-derived from 3.** If there is exactly one nontrivial eigenspace
   (the orthogonal complement of the uniform vector), then hyperuniformity forces
   `C = c . (I - J/N)` and `regionalVariance C A = c * ‖1_A - (|A|/N) 1‖^2`, which equals
   `c |A| (N - |A|) / N`. Prove the norm computation explicitly - it is the reason the
   rank-2 law is what it is.
5. **Where the freedom lives.** With at least two nontrivial eigenspaces, exhibit two
   invariant PSD hyperuniform covariances on the SAME space with the SAME total variance
   `trace` but different regional-variance profiles on some region. This is the abstract
   form of the six-cycle phenomenon.
6. If cheap: note that `sum_i ‖P_i (1_A)‖^2 = ‖1_A‖^2 = |A|`, so the regional variance is
   a weighted average of the `c_i` with weights summing to `|A|` - making the trade-off
   between eigenspaces explicit and quantitative.

## Constraints
- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only; report `#print axioms` for each main theorem.
- Docstring scope: finite linear algebra about invariant covariance matrices. Say nothing
  about point processes, Lorentz invariance, or the cosmological constant.
