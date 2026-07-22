# Lemma job: frame-blindness obstruction for a CONTINUOUS (compact) group - toward the Lorentz-flavoured statement

Mathlib-only. A finite-group version is proved: for an invariant PSD covariance,
quadratic variance is constant along orbits, so suppressing one regional mode forces
suppression on the whole orbit-generated subrepresentation; selective suppression
requires breaking invariance. The physics target (causal-set zero-one laws;
everpresent Lambda from Poisson fluctuations) concerns a NON-COMPACT, CONTINUOUS
symmetry. Take the next honest step: a COMPACT continuous group.

Setting: a compact topological group `G` acting continuously by linear isometries on a
finite-dimensional real inner-product space `V`; a `G`-invariant PSD operator
`C : V ->L[R] V` (invariant meaning `C (g . v) = g . (C v)`).

Prove:
1. **Invariance is orbit-constancy of variance**: for `G`-invariant `C`, the map
   `v |-> <v, C v>` is constant on each `G`-orbit.
2. **Suppression propagates**: if `C` is PSD and `<v, C v> = 0` then `C v = 0`, and
   hence `C (g . v) = 0` for every `g` - so the kernel is a `G`-INVARIANT SUBSPACE
   containing the whole orbit of `v` and its span.
3. **Averaging/Haar bridge**: any PSD `C` can be averaged over `G` (Haar/Bochner
   integral, or a finite average if you prefer to keep `G` finite for this part) to a
   `G`-invariant PSD `C_avg`, and `<v, C_avg v>` is the orbit average of
   `<g.v, C (g.v)>`. Conclude: averaging can only DELOCALIZE suppression, never
   concentrate it on a single mode.
4. **The obstruction, stated for continuous `G`**: if `G` acts with a nontrivial orbit
   through `v` (i.e. `v` is not `G`-fixed), then no `G`-invariant PSD `C` suppresses
   `v` alone - the suppressed set always contains `span (G . v)`.
5. **Sharpness**: exhibit a compact `G` (e.g. a circle acting by rotation on `R^2`, or
   `SO(2)` on a plane inside `R^3`) with an invariant PSD `C` suppressing an entire
   orbit-span, and a non-invariant PSD suppressing a single line inside it.
Keep everything finite-dimensional. If the Haar/Bochner integral is heavy, prove 1, 2,
4, 5 and state 3 for a finite subgroup, saying so explicitly.
No new axioms/native_decide; standard axioms; report axioms.
