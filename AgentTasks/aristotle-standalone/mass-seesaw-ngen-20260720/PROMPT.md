# Lemma job: n-generation seesaw Schur complement (A5 extension)

Mathlib-only. Extend the landed one-generation seesaw to arbitrary `n`
generations. For block matrices `mD : Matrix (Fin n) (Fin n) ℂ` (Dirac) and
`MR : Matrix (Fin n) (Fin n) ℂ` (heavy Majorana, invertible), consider the
symmetric neutrino mass matrix `[[0, mD],[mDᵀ, MR]]` on `Fin n ⊕ Fin n`. Prove:
1. the light effective mass is the Schur complement `M_light = - mD * MR⁻¹ * mDᵀ`;
2. the explicit block LDLᵀ / triangular congruence that block-diagonalizes it to
   `diag(M_light, MR)`;
3. `M_light` is symmetric (`M_lightᵀ = M_light`);
4. a controlled bound: with an operator-norm smallness `‖mD‖ * ‖MR⁻¹‖ * ‖mDᵀ‖ ≤ b`,
   `‖M_light‖ ≤ b`.
Concrete route via `Matrix.fromBlocks` and the Schur-complement API if available.
No new axioms/native_decide; standard axioms; report axioms.
