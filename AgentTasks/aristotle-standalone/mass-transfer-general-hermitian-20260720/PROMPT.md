# Lemma job: general Hermitian transfer positive bridge (A3 extension)

Mathlib-only. Extend the landed DIAGONAL positive transfer-mass bridge to a
general symmetric positive-definite `T : Matrix (Fin m) (Fin m) ℝ` via the
spectral theorem. With eigenvalues `μ` (top `μ₀` nondegenerate, strictly largest)
and eigenbasis `e`, for observable `v`:
1. `⟨v, Tⁿ v⟩ = Σ_i ⟨eᵢ,v⟩² μᵢⁿ`;
2. the connected correlation `Cc(n) = ⟨v,Tⁿv⟩ - ⟨e₀,v⟩² μ₀ⁿ = Σ_{i≠0} ⟨eᵢ,v⟩² μᵢⁿ`;
3. if `v` overlaps the first excited eigenvector (`⟨e₁,v⟩ ≠ 0`, `μ₁` the second
   eigenvalue), `Cc(n)/μ₁ⁿ` is bounded below by a positive constant for large `n`,
   so the connected decay rate is exactly `μ₁` and the mass is `log(μ₀/μ₁)`.
Concrete `m=2` acceptable if the general spectral route is heavy. No new
axioms/native_decide; standard axioms; report axioms.
