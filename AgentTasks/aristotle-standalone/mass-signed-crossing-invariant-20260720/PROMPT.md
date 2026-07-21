# Lemma job: the signed crossing invariant (closes the HNU Floquet-ledger gap)

Mathlib-only. The homotopy audit showed the UNSIGNED upper-half-circle eigenvalue
count is homotopy-invariant but is NOT the full Floquet invariant - the signed
version needs oriented crossing data. Formalize the signed invariant for a
continuous path `t -> U t` of `2x2` unitaries with isolated crossings of `+1`:
1. define the signed crossing number as the sum of `sign(d/dt arg(eigenvalue))`
   over crossings of the `+1` point (an eigenvalue passing +1 counterclockwise =
   +1, clockwise = -1);
2. prove that for the ENDPOINT-to-endpoint signed count, reversing the path
   orientation negates it (unlike the unsigned count, which is preserved);
3. exhibit two concrete diagonal `2x2` unitary paths with the SAME unsigned
   crossing count but OPPOSITE signed count (a crossing traversed one way vs the
   other), proving the signed invariant is strictly finer;
4. relate to the winding: the signed count equals the net winding of `det(U t)`
   through `+1`... state the precise relation for the diagonal case.
This closes the ledger gap the audit named (oriented crossing sign). Explicit
diagonal 2x2; no new axioms/native_decide; standard axioms; report axioms.
