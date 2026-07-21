# Lemma job: general Hermitian Kallen-Lehmann representation (A4 strengthening)

Mathlib-only. Upgrade the landed DIAGONAL finite KL representation to a GENERAL
Hermitian `H : Matrix (Fin m) (Fin m) ℂ` via the spectral theorem. For a physical
vector `v`, using the eigenbasis of `H` (Mathlib `Matrix.IsHermitian.spectral_theorem`
/ `eigenvalues` / `eigenvectorBasis`), prove:
1. `⟨v, (z • 1 - H)⁻¹ v⟩ = Σ_i wᵢ / (z - μᵢ)` for `z` off the spectrum, where
   `μᵢ` are the real eigenvalues and `wᵢ = ‖⟨eᵢ, v⟩‖² ≥ 0` the KL weights in the
   eigenbasis;
2. the physical mass `min { μᵢ : wᵢ ≠ 0 }` can exceed `min μᵢ` (a Hermitian
   witness, not necessarily diagonal, with a ground eigenvector orthogonal to `v`).
This lifts the diagonal `KLAtomFiniteCore`/`FiniteKallenLehmann` results to arbitrary
finite Hermitian response operators. Concrete `m=2` acceptable if the general
spectral route is heavy; name what is proved. No new axioms/native_decide;
standard axioms; report axioms.
