# Summary of changes for run 3082e64f-9c60-4f5a-8454-1c4b5322a975
Completed the Mathlib-only Lean formalization in `RequestProject/Main.lean`; the project builds successfully and contains no `sorry`, `native_decide`, new axioms, `opaque`, or `unsafe` declarations.

Proved:
- Every invariant matrix for a transitive finite action has the uniform vector as an eigenvector.
- Hyperuniformity reduces to one scalar row-sum equation.
- Pair-class indicator matrices give unique coordinates for matrices constant on a finite surjective pair-class labeling, yielding the requested orbit-indicator dimension statement when labels are symmetrized pair-orbits.
- General rank-two rigidity: every PSD hyperuniform rank-two matrix is
  `q • (I - (1/N) • J)` with `q ≥ 0`, and its regional variance is
  `q |A| (N-|A|) / N`.
- In diagonal normalization `a = C 0 0`, this is
  `C = (aN/(N-1)) • (I - (1/N) • J)` and
  `V(C,A) = a |A| (N-|A|)/(N-1)`.
- The requested implication `C 0 0 = 0 → C = 0`.
- A six-cycle Laplacian witness, including symmetry, rotation invariance, transitivity, PSD via an exact sum-of-squares identity, hyperuniformity, nonzeroness, at least three distinct pair-orbits, and variance exactly `2` for every initial proper nonempty arc.
- The explicit comparison at arc size three: cyclic variance `2` versus rank-two diagonal-normalized variance `18/5`.

Kernel refutation found: the proposed claim that a transitive group admits a nonzero invariant PSD hyperuniform covariance only if its rank is at least three is false. Rank two itself admits the nonzero covariance `I - J/N` for every `N ≥ 2`; this is formally proved as `rankTwo_nonzero_counterexample`. Thus the valid dichotomy is about the *shape of regional variance*, not existence: rank two forces the finite-population law, while the cyclic higher-rank witness has constant proper-arc variance. The requested formula in Target 3 also mixed two normalizations; both correct versions are proved separately.

`#print axioms` is included for every main theorem. The reported dependencies are only standard permitted axioms (`propext`, `Classical.choice`, and `Quot.sound`). A default library target and root import were added so `lake build` checks the formalization directly.
