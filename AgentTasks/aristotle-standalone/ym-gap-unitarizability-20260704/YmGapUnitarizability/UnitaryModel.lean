import Mathlib

/-!
# YM gap lane: every simple complex FDRep of a finite group has a unitary
matrix model

Standalone Mathlib-only target. This file is a focused Aristotle package for
one structural theorem in a larger lattice-gauge-theory formalization
program.

## Why this statement, exactly

The parent repository has kernel-checked the finite-group 2D Wilson-loop
area law `<W_R> = chi_R(1) * gamma^area` and the vacuum-dominance bound
`|gamma| <= 1` (hence nonnegative string tension). The dominance bound is
currently CONDITIONAL on an explicit "unitary matrix model" hypothesis:

`hmodel : forall g, R.character g = Matrix.trace (rho' g)` for some `rho'`
multiplicative, unital, and unitary.

This package's single target discharges that hypothesis unconditionally:
every finite-dimensional complex representation of a finite group is
unitarizable, stated at the matrix level so it plugs directly into the
existing bound. The consumer only needs EXISTENCE; the dimension `n` may be
anything (it will in fact be the finrank, but the statement does not
require that).

## Suggested proof route (pure matrix algebra; no inner-product-space API)

1. Choose a basis `b := Module.finBasis C R` (`FDRep` carries a
   `FiniteDimensional` instance; `FDRep.character g` is
   `LinearMap.trace` of the action of `g`, and `LinearMap.trace` equals
   `Matrix.trace` of `LinearMap.toMatrix b b`). Let
   `M g := LinearMap.toMatrix b b (R.rho g)`. Then `M` is multiplicative
   and unital, each `M g` is invertible (inverse `M g⁻¹`), and
   `R.character g = Matrix.trace (M g)`.
2. Weyl averaging at the matrix level: define
   `P := ∑ g : G, (M g)ᴴ * M g`. Then `P` is Hermitian positive definite
   (each summand is PSD via `Matrix.posSemidef_conjTranspose_mul_self`;
   positive definiteness from the `g = 1` summand and invertibility, or
   from `P`'s quadratic form: `x ≠ 0` gives the `g = 1` term
   `‖x‖² > 0`). The key intertwining identity, by reindexing the sum over
   `g ↦ g * h`:
   `(M h)ᴴ * P * M h = P` for every `h`.
3. Let `Q := CFC.sqrt P` (available in this Mathlib:
   `CFC.sqrt_mul_sqrt_self`, `CFC.sqrt_nonneg`, `CFC.isUnit_sqrt_iff`,
   `Matrix.PosSemidef.posSemidef_sqrt`-era lemmas exist under the `CFC`
   names; `Q` is Hermitian PSD and invertible since `P` is a unit).
   Define `rho' g := Q * M g * Q⁻¹`. Then:
   - multiplicative and unital (conjugation by a fixed invertible matrix);
   - unitary: `(rho' g)ᴴ * rho' g = Q⁻¹ᴴ (M g)ᴴ Qᴴ Q M g Q⁻¹`
     `= Q⁻¹ (M g)ᴴ P (M g) Q⁻¹ = Q⁻¹ P Q⁻¹ = 1`, using `Qᴴ = Q`,
     `Q * Q = P`, and the intertwining identity;
   - `Matrix.trace (rho' g) = Matrix.trace (M g) = R.character g` by
     trace cyclicity (`Matrix.trace_mul_cycle` or conjugation-invariance).

Alternative routes (invariant inner product + orthonormal basis) are
acceptable if easier, but the statement below must remain EXACTLY as
written.

Do NOT weaken the statement: do not add hypotheses (no `[Simple R]` - the
theorem is true for every `FDRep`; no `Nontrivial`, no `DecidableEq`
beyond existing instances), do not replace the unitarity equation
`(rho g)ᴴ * rho g = 1` by a `Matrix.unitaryGroup` membership (the consumer
uses this literal form), and do not change `Matrix.trace` to
`LinearMap.trace` in the conclusion.
-/

namespace YmGapUnitarizability

open scoped Matrix

open CategoryTheory

/-- **TARGET.** Every finite-dimensional complex representation of a finite
group admits a unitary matrix model: a multiplicative, unital, unitary
matrix-valued function with the same character. -/
theorem fdRep_exists_unitary_matrix_model {G : Type} [Group G] [Fintype G]
    (R : FDRep ℂ G) :
    ∃ (n : ℕ) (rho : G → Matrix (Fin n) (Fin n) ℂ),
      (∀ g h : G, rho (g * h) = rho g * rho h) ∧
      rho 1 = 1 ∧
      (∀ g : G, (rho g)ᴴ * rho g = 1) ∧
      (∀ g : G, R.character g = Matrix.trace (rho g)) := by
  sorry

end YmGapUnitarizability
