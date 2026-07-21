# Lemma job: the LINKAGE an A3 composite-mass claim needs (observable <-> gap)

Mathlib-only, abstract. Two halves of an A3 bridge now exist separately: a
gauge-invariant observable, and transfer positivity/gap facts. The claim "the finite
gap IS the composite mass of that observable" needs the LINKAGE, which is exactly
where such bridges overclaim. Isolate it.

Setting: symmetric positive-definite `T` on `R^n` with nondegenerate top eigenvalue
`lam0`, second `lam1 < lam0`, top eigenvector `e0`; an observable vector `v`.
Define the connected correlation `Cc n = <v, T^n v> - <v,e0>^2 * lam0^n`.

Prove:
1. **Linkage under overlap**: if `<e1, v> != 0` (nonzero overlap with the FIRST
   EXCITED eigenvector), then `Cc n / lam1^n -> <e1,v>^2 > 0`, so the connected decay
   rate is EXACTLY `lam1` and `log (lam0/lam1)` is the correlation mass.
2. **Failure without overlap**: if `<e1, v> = 0`, exhibit that `Cc n` decays at a
   STRICTLY faster rate (the next nonzero overlap), so the observable reports a
   LARGER mass than the transfer gap - the linkage genuinely fails.
3. **The gauge-invariance gap**: show by a witness that gauge invariance of an
   observable does NOT by itself imply nonzero overlap with the first excited state -
   i.e. invariance and overlap are INDEPENDENT properties. (A constant observable is
   invariant under everything and has zero excited overlap.)
4. Conclude the precise statement an A3 bridge must prove: gauge-invariant observable
   AND positive transfer AND spectral gap AND nonzero first-excited overlap. Any three
   of these do not give the composite-mass identification.
No new axioms/native_decide; standard axioms; report axioms.
