# Lemma job: frame-blindness vs hyperuniformity for a general compact group action

Mathlib-only. A finite kernel-checked result says: a PERMUTATION-invariant covariance
can suppress at most the uniform grand-total mode, and hyperuniform suppression of a
regional non-uniform mode necessarily breaks permutation invariance. This is the
finite shadow of a causal-set structural fact (no Poincare-invariant sprinkling other
than Poisson is known; sprinklings cannot prefer a timelike direction). Generalize the
finite statement from the symmetric group to an ARBITRARY finite group action, so the
obstruction is about invariance as such rather than about permutations.

Setting: a finite index set `X`, a finite group `G` acting on `X`, and a real
symmetric positive-semidefinite covariance `C : Matrix X X R` that is `G`-INVARIANT
(`C (g x) (g y) = C x y`).

Prove:
1. **Invariant covariances are constant on orbits of the action on pairs**; hence `C`
   lies in the commutant (the "orbit algebra") of the permutation representation.
   State the dimension of that algebra as the number of orbits on `X x X`.
2. **Transitive case**: if `G` acts TRANSITIVELY on `X`, then the total-sum mode
   `1 = (1,...,1)` is an EIGENVECTOR of every `G`-invariant `C`. Prove it.
3. **The suppression obstruction**: with `G` transitive, if `C` is `G`-invariant and
   PSD, and `f` is any vector with `sum f = 0` (a non-uniform/regional mode), show the
   variance `f^T C f` is controlled by the NON-trivial isotypic components, and prove
   that suppressing `f^T C f` to zero for ONE such `f` forces it to vanish on the
   entire `G`-orbit of `f` - so regional suppression is never "local", it is forced to
   be isotypic-wide.
4. **Sharp witness**: exhibit a `G` and an invariant PSD `C` where suppressing a
   regional mode forces suppressing the whole isotypic block, and a non-invariant `C`
   that suppresses that single mode alone - proving invariance is exactly what
   obstructs selective suppression.
This turns "permutation-invariance" into "invariance under any transitive group",
which is the step toward a Lorentz-flavoured statement.
No new axioms/native_decide; standard axioms; report axioms.
