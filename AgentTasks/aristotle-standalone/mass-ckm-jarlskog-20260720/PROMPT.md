# Lemma job: the CKM Jarlskog CP invariant (A2 parameter-count capstone)

Mathlib-only. Concrete extension of the A2 conditional-uniqueness parameter count
(3-gen Dirac = 6 masses + 3 angles + 1 CP phase). Formalize the Jarlskog
invariant of a 3x3 unitary CKM matrix `V` as
`J = Im (V 0 0 * V 1 1 * conj (V 0 1) * conj (V 1 0))` and prove:
1. `J` is rephasing-invariant: replacing `V i j` by `exp(I a_i) V i j exp(-I b_j)`
   (left/right diagonal phase redefinitions) leaves `J` unchanged;
2. `J = 0` for any REAL orthogonal `V` (no CP violation without a genuine phase);
3. an explicit unitary 3x3 witness with `J != 0` (CP violation is possible),
   e.g. a standard-parametrization matrix with a nonzero phase;
4. (if reachable) `J = 0` whenever two rows or two columns are proportional up to
   phase (degenerate mixing kills CP).
This is the concrete CP-observable underlying the "+1 CP phase" in the 3-gen
count. Explicit small matrices; no new axioms/native_decide; standard axioms;
report axioms.
