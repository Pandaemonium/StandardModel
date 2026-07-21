# Lemma job: finite transfer positivity and the gap, kept separate from the observable

Mathlib-only. An A3 bridge is only honest if positivity and the gap are proved, not
paired by assertion with a gauge-invariant observable. Prove the positivity half
abstractly, and state precisely what it does and does not give.

For a finite symmetric matrix `T : Matrix (Fin n) (Fin n) R`:
1. **Positive definiteness from a Gram form**: if `T = Aᵀ * A` with `A` injective
   (full column rank), then `T` is symmetric positive definite. Prove it.
2. **Spectral gap from positivity + strict top eigenvalue**: if `T` is symmetric
   positive definite with a nondegenerate largest eigenvalue `lam0` and second
   `lam1 < lam0`, then for any vector `v`, `<v, T^n v> / lam0^n` converges, and the
   CORRECTION term decays like `(lam1/lam0)^n`. State it exactly.
3. **What positivity does NOT give**: exhibit a symmetric positive definite `T` whose
   spectral gap is arbitrarily SMALL, so positivity alone places no lower bound on
   the gap - the gap is an independent input.
4. **What the gap does NOT give**: exhibit two symmetric positive definite matrices
   with the SAME gap but different eigenvector structure, so the gap alone does not
   fix the associated projector.
Deliver 1-2 as theorems and 3-4 as witnesses. Do NOT connect this to any gauge
observable; that pairing is a separate obligation. No new axioms/native_decide.
