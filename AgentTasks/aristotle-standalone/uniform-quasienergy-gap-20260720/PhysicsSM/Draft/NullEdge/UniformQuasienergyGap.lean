import Mathlib

/-!
# Compactness upgrade: pointwise no-crossing implies a uniform quasienergy gap

Audit-driven strengthening of the AFPL HNU headline
`HNUMassiveGlobalGap.massiveHNU_zero_pi_gap`, which proves that a continuous
family of `4 x 4` unitaries over the compact Brillouin cube has
`det (U k - 1) ≠ 0` and `det (U k + 1) ≠ 0` for every `k` (no zero/pi
quasienergy crossing, POINTWISE). Independent review (Opus, 2026-07-20) noted
that over a compact parameter space, continuity plus exact unitarity upgrade
this to a UNIFORM spectral-gap margin. This module states that abstract upgrade,
which is Mathlib-only and composes with the landed HNU theorem.

Intended reading: `μ` is an eigenvalue of `U k` iff `det (U k - μ • 1) = 0`.
For a unitary `U k` every eigenvalue lies on the unit circle, so
`‖μ - 1‖ ≤ 2` and `det (U k - 1) = ∏ (μ_j - 1)` over the eigenvalues gives
`‖μ - 1‖ ≥ |det (U k - 1)| / 2^(m-1)`. Compactness makes `|det (U k ∓ 1)|`
bounded below by some `δ₀ > 0`, so every eigenvalue is bounded away from `+1`
and `-1` uniformly.

Proof plan (for the prover):
1. `k ↦ (U k - 1).det` and `k ↦ (U k + 1).det` are continuous (det is
   continuous, `U` is continuous); their norms are continuous and nowhere zero
   on the compact `K`, so each attains a positive minimum
   (`IsCompact.exists_isMinOn` / `Continuous.exists_forall_le` on `univ`),
   giving `δ₀ > 0` with `δ₀ ≤ ‖(U k - 1).det‖` and `δ₀ ≤ ‖(U k + 1).det‖`.
2. For fixed `k`, if `det (U k - μ • 1) = 0` then `μ` is a root of the
   characteristic polynomial, so `(U k - 1).det = ∏_j (μ_j - 1)` over the
   eigenvalues (with multiplicity) and `μ` is one of the `μ_j`. Unitarity gives
   `‖μ_j - 1‖ ≤ 2`, so `‖μ - 1‖ ≥ ‖(U k - 1).det‖ / 2^(m-1) ≥ δ₀ / 2^(m-1)`.
   Symmetrically for `+1`.
3. Take `δ = δ₀ / 2^(m-1)`.

If the eigenvalue-product route is heavy, the acceptable fallback is to prove
the theorem for `m = 4` concretely (the HNU case) and report the general-`m`
lemma (`det (U - 1) = ∏ (eigenvalue - 1)` for a matrix over `ℂ`) as the one
missing ingredient.
-/

namespace PhysicsSM.Draft.NullEdge.UniformQuasienergyGap

open Matrix

/-- **Uniform quasienergy gap from pointwise no-crossing.**  A continuous family
of `m x m` unitaries over a nonempty compact parameter space with no zero and no
pi crossing anywhere has a single uniform margin `δ > 0` separating every
eigenvalue from both `+1` and `-1`. -/
theorem uniform_quasienergy_gap
    {K : Type*} [TopologicalSpace K] [CompactSpace K] [Nonempty K]
    {m : ℕ} (U : K → Matrix (Fin m) (Fin m) ℂ) (hcont : Continuous U)
    (hunit : ∀ k, U k ∈ Matrix.unitaryGroup (Fin m) ℂ)
    (h0 : ∀ k, (U k - 1).det ≠ 0) (hpi : ∀ k, (U k + 1).det ≠ 0) :
    ∃ δ : ℝ, 0 < δ ∧ ∀ (k : K) (μ : ℂ), (U k - μ • (1 : Matrix (Fin m) (Fin m) ℂ)).det = 0 →
      δ ≤ ‖μ - 1‖ ∧ δ ≤ ‖μ + 1‖ := by
  sorry

end PhysicsSM.Draft.NullEdge.UniformQuasienergyGap
