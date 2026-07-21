# Lemma job: ONE model discharging all four A3 obligations simultaneously

Mathlib-only. Four A3 obligations are now separately proved: a gauge-invariant
observable; transfer positivity; a spectral gap; and the linkage (nonzero
first-excited overlap). They have NEVER been discharged for the SAME model. That is
precisely the gap between "four lemmas" and "a bridge". Close it, or show why it is
hard.

Build ONE explicit finite model and prove ALL of:
1. a finite state space with a symmetric POSITIVE-DEFINITE transfer matrix `T`
   (exhibit it as a Gram matrix `A^T A` with injective `A`);
2. a nondegenerate top eigenvalue `lam0` with second eigenvalue `lam1 < lam0` -
   compute both explicitly;
3. an observable `v` that is INVARIANT under a stated finite group action on the
   state space (state the action; a permutation action is fine);
4. `<e1, v> != 0` - the invariant observable genuinely OVERLAPS the first excited
   state;
5. conclude, for THIS model, that the connected correlation decays at exactly
   `lam1` and the correlation mass is `log (lam0 / lam1)`.
The point is (3) AND (4) TOGETHER: earlier work showed gauge invariance and overlap
are logically independent, so a model achieving both is a genuine (if small)
composite-mass bridge. Keep the state space small (3 or 4 states) and compute
everything explicitly.
If some obligation cannot be met simultaneously, report WHICH and why - a precise
obstruction is an equally acceptable result. No new axioms/native_decide.
