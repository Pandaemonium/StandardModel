# Adversarial docstring audit: the origin-of-mass module prose

Mathlib-only adversarial audit. Two prior waves audited a different module set's prose
and found 7 over-claims out of 10 claims examined. Apply the SAME severity to these
origin-of-mass claims. Verdict per item: SOUND or PROSE-OUTRUNS-STATEMENT, with a
Mathlib witness for the latter.

Claims:
1. "an internal spectral gap does not determine physical mass" - the witness is two
   unitarily conjugate Hermitian involutions with physical weights 1 and 0. Does this
   support the GENERAL claim, or only that ONE fixed observable direction fails to
   see it? State the honest general form.
2. "the transfer gap does not fix the correlation mass" - shown via raw correlations.
   Is the claim about RAW two-point values, or about the CONNECTED/normalized mass
   readout? These differ; say which is proved.
3. "Pluecker cannot select the Yukawa" - shown by two admissible couplings with equal
   Frobenius norm and determinant. Do norm+determinant EXHAUST the invariants a
   Pluecker datum could supply? If a finer invariant (e.g. full singular-value
   multiset, or the pair itself up to equivalence) could distinguish them, the no-go
   is weaker than stated. Check singular values.
4. "the fermion sector shares only the scalar v" - proved for one specific mass functor.
   Is 'only' justified, or is it 'not through the displayed vector-valued route'?
5. "the mechanism matrix is internally consistent" - Gamma-odd cap Gamma-even = {0}.
   Does this establish NON-DOUBLE-COUNTING for the PHYSICAL rows, or only that two
   formal parity classes are disjoint? State the gap between them.
Be adversarial. No new axioms/native_decide; standard axioms; report axioms.
