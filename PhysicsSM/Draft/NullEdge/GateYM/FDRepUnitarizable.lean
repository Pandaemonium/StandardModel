import Mathlib

/-!
# Gate YM1/gap lane: finite-group unitarizability (Weyl's unitarian trick)

Every finite-dimensional complex representation of a finite group admits a
unitary matrix model - a multiplicative, unital, unitary matrix-valued
function with the same character. This discharges, unconditionally, the
matrix-model hypothesis carried explicitly by
`WilsonVacuumDominance.norm_wilsonNormalizedGamma_le_one` and
`wilsonStringTension_nonneg` (queue item Q4 of
`Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` section 14).

## Provenance

Proved by Aristotle project `d4a9bd1f-f54b-404b-91ac-701721b81f8d`
(standalone Mathlib-only package
`AgentTasks/aristotle-standalone/ym-gap-unitarizability-20260704/`,
task `955405d9-4be0-49ea-9211-070931b884a4`, harvested 2026-07-05).
Integrated verbatim after semantic review: the target theorem's
signature is byte-identical to the submitted skeleton (same existential
shape, same literal unitarity equation `(rho g)^H * rho g = 1`, same
`Matrix.trace` conclusion, no hypotheses added - in particular no
`[Simple R]`, since the statement holds for every `FDRep`). Local
re-verification under the pinned toolchain: `lake env lean` clean, zero
warnings; axiom footprint `[propext, Classical.choice, Quot.sound]` on
all four public declarations.

Proof route: Weyl's unitarian trick in pure matrix algebra. Fix a basis
of `R.V` to get a multiplicative unital matrix function `M`; the
Weyl-averaged Gram matrix `P = sum_g (M g)^H * (M g)` is positive
definite and intertwines `M h` for every `h` (`(M h)^H * P * M h = P`,
by reindexing the sum along `g -> g * h`); conjugating `M` by
`Q := CFC.sqrt P` gives a unitary, trace-preserving matrix model.

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites: Mathlib only.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace FDRepUnitarizable

open scoped Matrix MatrixOrder ComplexOrder

open CategoryTheory

/-- The Weyl-averaged Gram matrix `sum_g (M g)^H * (M g)` is positive
definite when `M` is a unital multiplicative matrix-valued function on a
finite group: positive semidefiniteness comes from each summand being a
Gram matrix, positive definiteness from the `g = 1` summand, which equals
`1`. -/
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

/-- The Weyl-averaged Gram matrix is invariant under conjugation by any
`M h`: `(M h)^H * P * M h = P`. Proved by distributing the product into
the sum and reindexing via the bijection `g -> g * h`. -/
lemma weyl_gram_intertwine {n : ℕ} {G : Type} [Group G] [Fintype G]
    (M : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, M (g * h) = M g * M h) (h : G) :
    (M h)ᴴ * (∑ g : G, (M g)ᴴ * M g) * M h = ∑ g : G, (M g)ᴴ * M g := by
  have h_lhs : ((M h)ᴴ * (∑ g : G, (M g)ᴴ * M g)) * M h
      = ∑ g : G, ((M h)ᴴ * ((M g)ᴴ * M g) * M h) := by
    simp +decide only [Matrix.mul_sum, Matrix.sum_mul]
  convert h_lhs using 1
  conv_lhs => rw [← Equiv.sum_comp (Equiv.mulRight h)]
  simp +decide [hmul, Matrix.mul_assoc]

/-- **Unitarian trick, matrix form.** Any multiplicative, unital
matrix-valued function `M` on a finite group is conjugate to a unitary one
with the same trace: set `Q := CFC.sqrt (sum_g (M g)^H * (M g))` and
`rho g := Q * M g * Q^-1`. -/
lemma unitarize_matrix {n : ℕ} {G : Type} [Group G] [Fintype G]
    (M : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, M (g * h) = M g * M h) (hone : M 1 = 1) :
    ∃ rho : G → Matrix (Fin n) (Fin n) ℂ,
      (∀ g h : G, rho (g * h) = rho g * rho h) ∧
      rho 1 = 1 ∧
      (∀ g : G, (rho g)ᴴ * rho g = 1) ∧
      (∀ g : G, Matrix.trace (rho g) = Matrix.trace (M g)) := by
  obtain ⟨Q, hQ⟩ : ∃ Q : Matrix (Fin n) (Fin n) ℂ,
      Q * Q = ∑ g : G, (M g)ᴴ * M g ∧ Qᴴ = Q ∧ IsUnit Q := by
    set P : Matrix (Fin n) (Fin n) ℂ := ∑ g : G, (M g)ᴴ * M g
    have hP_posDef : P.PosDef := by
      convert weyl_gram_posDef M hone
    refine' ⟨_, _, _, _⟩
    exact CFC.sqrt P
    · convert CFC.sqrt_mul_sqrt_self P _
      exact hP_posDef.posSemidef.nonneg
    · convert IsSelfAdjoint.of_nonneg (CFC.sqrt_nonneg P) |> IsSelfAdjoint.star_eq
    · convert (CFC.isUnit_sqrt_iff P _).mpr _
      · exact hP_posDef.posSemidef.nonneg
      · exact hP_posDef.isUnit
  refine' ⟨fun g => Q * M g * Q⁻¹, _, _, _, _⟩ <;>
    simp_all +decide [Matrix.isUnit_iff_isUnit_det]
  · simp +decide [mul_assoc, hQ.2.2, isUnit_iff_ne_zero]
  · intro g
    simp_all +decide [Matrix.mul_assoc, Matrix.conjTranspose_nonsing_inv]
    have h_unitary : (M g)ᴴ * (∑ g : G, (M g)ᴴ * M g) * M g
        = ∑ g : G, (M g)ᴴ * M g := by
      convert weyl_gram_intertwine M hmul g using 1
    simp_all +decide [← mul_assoc, ← hQ.1]
  · intro g
    rw [Matrix.trace_mul_comm]
    simp +decide [hQ.2.2, isUnit_iff_ne_zero]

/-- **Every finite-dimensional complex representation of a finite group
admits a unitary matrix model.** A multiplicative, unital, unitary
matrix-valued function with the same character - Weyl's unitarian trick,
packaged at the matrix level for direct use by the Wilson vacuum-dominance
bound. Holds for EVERY `FDRep`, not just simple ones. -/
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

end FDRepUnitarizable
end GateYM
end NullEdge
end Draft
end PhysicsSM
