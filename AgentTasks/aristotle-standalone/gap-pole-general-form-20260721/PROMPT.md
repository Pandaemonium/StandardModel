# Lemma job: the general form of the gap-does-not-fix-pole obstruction

Mathlib-only, abstract. A finite obstruction shows two unitarily conjugate Hermitian
involutions of C^2 with the SAME spectrum have physical two-point weights 1 and 0 at a
shared gap edge. Strengthen it from a single witness pair to a general statement.

Prove, for a fixed physical vector `v` and Hermitian `H` on `C^n`:
1. **Weight is basis-dependent, spectrum is not**: for any Hermitian `H` and any
   unitary `U`, `H` and `U H U*` have the SAME spectrum, but the weight
   `<v, P_lambda(U H U*) v>` generally differs from `<v, P_lambda(H) v>` - give the
   exact relation (it equals the weight of `H` in the direction `U* v`).
2. **Full range**: for a fixed gap edge eigenvalue `lambda` of multiplicity `k >= 1` in
   an `n`-dimensional space with `1 <= k < n`, the achievable weights
   `{<v, P_lambda(U H U*) v> : U unitary}` for a fixed unit `v` fill the ENTIRE
   interval `[0, 1]` - so the spectrum constrains the physical weight not at all.
3. Conclude the general obstruction: the map (spectrum) -> (physical weight) is not
   well defined, for every `n >= 2` and every such `lambda` - not merely for the one
   `2 x 2` witness.
Success: 1-2 proved, 3 stated. If the full interval is hard, prove the weaker
'attains both 0 and 1' for general `n`. No new axioms/native_decide; standard axioms.
