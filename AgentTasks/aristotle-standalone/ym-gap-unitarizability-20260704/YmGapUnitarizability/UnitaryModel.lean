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

## Proof route (pure matrix algebra; Weyl's unitarian trick)

1. Choose a basis `b := Module.finBasis ℂ R.V` and let
   `M g := LinearMap.toMatrix b b (R.ρ g)`. Then `M` is multiplicative and
   unital, and `R.character g = Matrix.trace (M g)`.
2. Weyl averaging: `P := ∑ g, (M g)ᴴ * M g` is positive definite
   (`weyl_gram_posDef`), with the intertwining identity
   `(M h)ᴴ * P * M h = P` (`weyl_gram_intertwine`).
3. Conjugate by `Q := CFC.sqrt P`: `rho g := Q * M g * Q⁻¹` is
   multiplicative, unital, unitary, and cospectral to `M g`
   (`unitarize_matrix`).
-/

namespace YmGapUnitarizability

open scoped Matrix MatrixOrder ComplexOrder

open CategoryTheory

/-
The Weyl-averaged Gram matrix `∑ g, (M g)ᴴ * M g` is positive definite
when `M` is a unital multiplicative matrix-valued function on a finite
group.  Positive semidefiniteness comes from each summand being a Gram
matrix; positive definiteness comes from the `g = 1` summand, which equals
`1`.
-/
lemma weyl_gram_posDef {n : ℕ} {G : Type} [Group G] [Fintype G]
    (M : G → Matrix (Fin n) (Fin n) ℂ) (hone : M 1 = 1) :
    (∑ g : G, (M g)ᴴ * M g).PosDef := by
  classical
  rw [← Finset.add_sum_erase _ _ (Finset.mem_univ (1 : G))]
  have hpsd : (∑ g ∈ Finset.univ.erase (1 : G), (M g)ᴴ * M g).PosSemidef := by
    refine Finset.sum_induction _ _ (fun _ _ => Matrix.PosSemidef.add)
      Matrix.PosSemidef.zero ?_
    intro g _
    exact Matrix.posSemidef_conjTranspose_mul_self (M g)
  have hone' : ((M 1)ᴴ * M 1).PosDef := by
    rw [hone]
    simpa using (Matrix.PosDef.one (n := Fin n) (R := ℂ))
  exact hone'.add_posSemidef hpsd

/-
The Weyl-averaged Gram matrix is invariant under conjugation by any
`M h`: `(M h)ᴴ * P * M h = P`.  This is proved by expanding the product into
the sum, recognizing each term as `(M (g * h))ᴴ * M (g * h)`, and reindexing
the sum via the bijection `g ↦ g * h`.
-/
lemma weyl_gram_intertwine {n : ℕ} {G : Type} [Group G] [Fintype G]
    (M : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, M (g * h) = M g * M h) (h : G) :
    (M h)ᴴ * (∑ g : G, (M g)ᴴ * M g) * M h = ∑ g : G, (M g)ᴴ * M g := by
  -- Distribute the left and right multiplication into the sum using `Finset.mul_sum` and `Finset.sum_mul`, so the LHS becomes
  have h_lhs : ((M h)ᴴ * (∑ g : G, (M g)ᴴ * M g)) * M h = ∑ g : G, ((M h)ᴴ * ((M g)ᴴ * M g) * M h) := by
    simp +decide only [Matrix.mul_sum, Matrix.sum_mul];
  convert h_lhs using 1;
  conv_lhs => rw [ ← Equiv.sum_comp ( Equiv.mulRight h ) ] ;
  simp +decide [ hmul, Matrix.mul_assoc ]

/-
**Unitarian trick, matrix form.** Any multiplicative, unital
matrix-valued function `M` on a finite group is conjugate to a unitary one
with the same trace: set `Q := CFC.sqrt (∑ g, (M g)ᴴ * M g)` and
`rho g := Q * M g * Q⁻¹`.
-/
lemma unitarize_matrix {n : ℕ} {G : Type} [Group G] [Fintype G]
    (M : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, M (g * h) = M g * M h) (hone : M 1 = 1) :
    ∃ rho : G → Matrix (Fin n) (Fin n) ℂ,
      (∀ g h : G, rho (g * h) = rho g * rho h) ∧
      rho 1 = 1 ∧
      (∀ g : G, (rho g)ᴴ * rho g = 1) ∧
      (∀ g : G, Matrix.trace (rho g) = Matrix.trace (M g)) := by
  obtain ⟨Q, hQ⟩ : ∃ Q : Matrix (Fin n) (Fin n) ℂ, Q * Q = ∑ g : G, (M g)ᴴ * M g ∧ Qᴴ = Q ∧ IsUnit Q := by
    -- Let $P = \sum_{g \in G} (M g)ᴴ * (M g)$.
    set P : Matrix (Fin n) (Fin n) ℂ := ∑ g : G, (M g)ᴴ * M g;
    have hP_posDef : P.PosDef := by
      convert weyl_gram_posDef M hone;
    refine' ⟨ _, _, _, _ ⟩;
    exact CFC.sqrt P;
    · convert CFC.sqrt_mul_sqrt_self P _;
      exact hP_posDef.posSemidef.nonneg;
    · convert IsSelfAdjoint.of_nonneg ( CFC.sqrt_nonneg P ) |> IsSelfAdjoint.star_eq;
    · convert ( CFC.isUnit_sqrt_iff P _ ).mpr _;
      · exact hP_posDef.posSemidef.nonneg;
      · exact hP_posDef.isUnit;
  refine' ⟨ fun g => Q * M g * Q⁻¹, _, _, _, _ ⟩ <;> simp_all +decide [ Matrix.isUnit_iff_isUnit_det ];
  · simp +decide [ mul_assoc, hQ.2.2, isUnit_iff_ne_zero ];
  · intro g; simp_all +decide [ Matrix.mul_assoc, Matrix.conjTranspose_nonsing_inv ] ;
    have h_unitary : (M g)ᴴ * (∑ g : G, (M g)ᴴ * M g) * M g = ∑ g : G, (M g)ᴴ * M g := by
      convert weyl_gram_intertwine M hmul g using 1;
    simp_all +decide [ ← mul_assoc, ← hQ.1 ];
  · intro g; rw [ Matrix.trace_mul_comm ] ; simp +decide [ hQ.2.2, isUnit_iff_ne_zero ] ;

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
  classical
  set b := Module.finBasis ℂ R.V with hb
  set M : G → Matrix (Fin (Module.finrank ℂ R.V)) (Fin (Module.finrank ℂ R.V)) ℂ :=
    fun g => LinearMap.toMatrix b b (R.ρ g) with hM
  have hmul : ∀ g h : G, M (g * h) = M g * M h := by
    intro g h
    simp only [hM, map_mul, LinearMap.toMatrix_mul]
  have hone : M 1 = 1 := by
    simp only [hM, map_one, LinearMap.toMatrix_one]
  obtain ⟨rho, h1, h2, h3, h4⟩ := unitarize_matrix M hmul hone
  refine ⟨_, rho, h1, h2, h3, ?_⟩
  intro g
  have hchar : R.character g = Matrix.trace (M g) := by
    rw [hM]
    rw [show R.character g = LinearMap.trace ℂ R.V (R.ρ g) from rfl]
    rw [LinearMap.trace_eq_matrix_trace ℂ b (R.ρ g)]
  rw [hchar, h4 g]

end YmGapUnitarizability
