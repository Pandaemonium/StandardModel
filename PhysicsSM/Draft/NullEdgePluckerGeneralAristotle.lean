import PhysicsSM.Draft.NullEdgeCoreAristotle

/-!
# Draft.NullEdgePluckerGeneralAristotle

Aristotle handoff for the general finite Pluecker mass theorem in the
null-edge causal graph program.

This file builds on `PhysicsSM.Draft.NullEdgeCoreAristotle`, which proves the
two-edge and three-edge identities.  The goal here is the full finite bundle
version: determinant mass of a finite family of complex null spinor edges is
the sum of squared pairwise Pluecker wedges.

Source notes:
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Null_Edge_Causal_Graph_Theorem_Roadmap_2026-06-21.md`

Mathematical route: Cauchy-Binet for a `2 x n` spinor matrix.  If `A` has the
spinors as columns, then the visible momentum matrix is `A A^dagger`, and
`det (A A^dagger)` is the sum of squared two-column minors.  Concretely we
expand the `2 x 2` determinant of the summed rank-one Hermitians, recognize a
Lagrange / Cauchy-Binet double sum, and fold it onto unordered index pairs.

This is draft handoff code.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgePluckerGeneral

open Matrix Complex
open PhysicsSM.Draft.NullEdgeCore

/-! ## Finite visible spinor bundles -/

/-- The Hermitian momentum matrix of a finite visible null-spinor bundle. -/
def finBundleMomentum {n : Nat} (psi : Fin n -> CSpinor) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  ∑ i : Fin n, rankOneHermitian (psi i)

/-- Ordered representatives of unordered pairs of indices. -/
def finPairIndexSet (n : Nat) : Finset (Fin n × Fin n) :=
  Finset.univ.filter fun p => (p.1 : Nat) < (p.2 : Nat)

/-- The total pairwise squared Pluecker spread of a finite spinor bundle. -/
def finPairwisePluckerMass {n : Nat} (psi : Fin n -> CSpinor) : ℂ :=
  ∑ p ∈ finPairIndexSet n,
    complexAbsSq (spinorWedge (psi p.1) (psi p.2))

/-! ## Off-diagonal folding helper -/

/--
A double sum of a function whose diagonal vanishes equals the sum over
unordered index pairs of the two orderings.  This is the combinatorial heart
of the Cauchy-Binet / Lagrange identity below.
-/
theorem sum_pairs_offdiag {n : Nat} (f : Fin n → Fin n → ℂ)
    (hdiag : ∀ i, f i i = 0) :
    ∑ i, ∑ j, f i j = ∑ p ∈ finPairIndexSet n, (f p.1 p.2 + f p.2 p.1) := by
  have h1 : ∑ i, ∑ j, f i j
      = ∑ p ∈ (Finset.univ : Finset (Fin n × Fin n)), f p.1 p.2 := by
    rw [← Finset.univ_product_univ, Finset.sum_product]
  rw [h1, finPairIndexSet, Finset.sum_add_distrib]
  have hswap :
      ∑ p ∈ Finset.univ.filter (fun p : Fin n × Fin n => (p.1 : Nat) < p.2),
          f p.2 p.1
        = ∑ p ∈ Finset.univ.filter (fun p : Fin n × Fin n => (p.2 : Nat) < p.1),
            f p.1 p.2 := by
    apply Finset.sum_nbij' (fun p => (p.2, p.1)) (fun p => (p.2, p.1)) <;> simp_all
  rw [hswap]
  have hpart : ∑ p ∈ (Finset.univ : Finset (Fin n × Fin n)), f p.1 p.2
      = (∑ p ∈ Finset.univ.filter (fun p : Fin n × Fin n => (p.1 : Nat) < p.2),
            f p.1 p.2)
        + ∑ p ∈ Finset.univ.filter
            (fun p : Fin n × Fin n => ¬ (p.1 : Nat) < p.2), f p.1 p.2 := by
    rw [Finset.sum_filter_add_sum_filter_not]
  rw [hpart]; congr 1
  rw [Finset.sum_filter, Finset.sum_filter]
  apply Finset.sum_congr rfl
  intro p _
  rcases lt_trichotomy (p.1 : Nat) (p.2 : Nat) with h | h | h
  · simp [Nat.not_lt.2 (le_of_lt h)]; omega
  · have : p.1 = p.2 := Fin.ext h; simp [this, hdiag]
  · simp [Nat.not_lt.2 (le_of_lt h), h]

/--
General finite Pluecker mass theorem.

The determinant of the summed null momenta is the total pairwise squared
Pluecker spread of the spinor bundle.
-/
theorem fin_bundle_plucker_mass_identity {n : Nat} (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = finPairwisePluckerMass psi := by
  have hentry : ∀ a b : Fin 2, finBundleMomentum psi a b
      = ∑ i, psi i a * (starRingEnd ℂ) (psi i b) := by
    intro a b
    simp [finBundleMomentum, rankOneHermitian, Matrix.sum_apply, Matrix.vecMulVec]
  set f : Fin n → Fin n → ℂ := fun i j =>
    (psi i 0 * (starRingEnd ℂ) (psi i 0)) * (psi j 1 * (starRingEnd ℂ) (psi j 1))
      - (psi i 0 * (starRingEnd ℂ) (psi i 1))
        * (psi j 1 * (starRingEnd ℂ) (psi j 0)) with hf
  have hdet : (finBundleMomentum psi).det = ∑ i, ∑ j, f i j := by
    rw [Matrix.det_fin_two, hentry, hentry, hentry, hentry]
    rw [Finset.sum_mul_sum, Finset.sum_mul_sum, ← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl; intro i _
    rw [← Finset.sum_sub_distrib]
  rw [hdet, sum_pairs_offdiag f (by intro i; simp [hf]; ring)]
  rw [finPairwisePluckerMass]
  apply Finset.sum_congr rfl
  intro p _
  simp only [hf, complexAbsSq, spinorWedge, map_sub, map_mul]
  ring

/-! ## Equality and collinearity criteria -/

/-- All members of a spinor family have zero pairwise Pluecker wedge. -/
def PairwiseWedgeZero {n : Nat} (psi : Fin n -> CSpinor) : Prop :=
  ∀ i j : Fin n, spinorWedge (psi i) (psi j) = 0

/--
If one spinor in the family is nonzero, then vanishing wedges against that
base spinor are equivalent to every spinor being a scalar multiple of it.
-/
theorem wedges_against_base_zero_iff_all_smul
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (hbase : psi base 0 ≠ 0 ∨ psi base 1 ≠ 0) :
    (∀ i : Fin n, spinorWedge (psi base) (psi i) = 0) ↔
      ∃ c : Fin n -> ℂ, ∀ i : Fin n, psi i = c i • psi base := by
  constructor
  · intro h
    have hex : ∀ i, ∃ c : ℂ, psi i = c • psi base := by
      intro i
      exact (spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero
        (psi base) (psi i) hbase).1 (h i)
    exact Classical.skolem.1 hex
  · rintro ⟨c, hc⟩ i
    rw [hc i]
    simp [spinorWedge, mul_comm, mul_left_comm]
    ring

/--
A common nonzero projective direction implies all pairwise wedges vanish.
-/
theorem all_smul_implies_pairwise_wedge_zero
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (c : Fin n -> ℂ) (h : ∀ i : Fin n, psi i = c i • psi base) :
    PairwiseWedgeZero psi := by
  intro i j
  rw [h i, h j]
  simp [spinorWedge]
  ring

/--
Pairwise vanishing wedges are equivalent to a common projective direction,
provided the chosen base spinor is nonzero.
-/
theorem pairwise_wedge_zero_iff_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (hbase : psi base 0 ≠ 0 ∨ psi base 1 ≠ 0) :
    PairwiseWedgeZero psi ↔
      ∃ c : Fin n -> ℂ, ∀ i : Fin n, psi i = c i • psi base := by
  constructor
  · intro h
    exact (wedges_against_base_zero_iff_all_smul psi base hbase).1
      (fun i => h base i)
  · rintro ⟨c, hc⟩
    exact all_smul_implies_pairwise_wedge_zero psi base c hc

/--
The pairwise Pluecker mass vanishes exactly when every indexed pair in the
finite pair set has zero wedge.

This is the positivity step over `ℂ`: a finite sum of squared complex moduli
can vanish only termwise.
-/
theorem finPairwisePluckerMass_eq_zero_iff_pair_terms_zero
    {n : Nat} (psi : Fin n -> CSpinor) :
    finPairwisePluckerMass psi = 0 ↔
      ∀ p ∈ finPairIndexSet n,
        spinorWedge (psi p.1) (psi p.2) = 0 := by
  rw [finPairwisePluckerMass]
  have hre : ∀ p ∈ finPairIndexSet n,
      complexAbsSq (spinorWedge (psi p.1) (psi p.2))
        = ((Complex.normSq (spinorWedge (psi p.1) (psi p.2)) : ℝ) : ℂ) := by
    intro p _; simp [complexAbsSq, Complex.normSq_eq_conj_mul_self, mul_comm]
  rw [Finset.sum_congr rfl hre, ← Complex.ofReal_sum, Complex.ofReal_eq_zero]
  rw [Finset.sum_eq_zero_iff_of_nonneg (fun p _ => Complex.normSq_nonneg _)]
  constructor
  · intro h p hp; exact Complex.normSq_eq_zero.1 (h p hp)
  · intro h p hp; rw [h p hp]; simp

/--
On the unordered pair index set, all terms vanish iff every pair (in any
order) has zero wedge.
-/
theorem pair_terms_zero_iff_pairwise
    {n : Nat} (psi : Fin n -> CSpinor) :
    (∀ p ∈ finPairIndexSet n, spinorWedge (psi p.1) (psi p.2) = 0) ↔
      PairwiseWedgeZero psi := by
  constructor
  · intro h i j
    rcases lt_trichotomy (i : Nat) (j : Nat) with hlt | heq | hgt
    · refine h (i, j) ?_
      simp only [finPairIndexSet, Finset.mem_filter, Finset.mem_univ, true_and]
      exact hlt
    · have : i = j := Fin.ext heq
      rw [this]; simp [spinorWedge]; ring
    · have hp : spinorWedge (psi j) (psi i) = 0 := by
        refine h (j, i) ?_
        simp only [finPairIndexSet, Finset.mem_filter, Finset.mem_univ, true_and]
        exact hgt
      simp only [spinorWedge] at hp ⊢; linear_combination -hp
  · intro h p _; exact h p.1 p.2

/--
Finite massless-collinearity criterion for a nontrivial bundle with a chosen
nonzero base spinor.
-/
theorem fin_bundle_mass_zero_iff_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (hbase : psi base 0 ≠ 0 ∨ psi base 1 ≠ 0) :
    (finBundleMomentum psi).det = 0 ↔
      ∃ c : Fin n -> ℂ, ∀ i : Fin n, psi i = c i • psi base := by
  rw [fin_bundle_plucker_mass_identity,
    finPairwisePluckerMass_eq_zero_iff_pair_terms_zero,
    pair_terms_zero_iff_pairwise]
  exact pairwise_wedge_zero_iff_common_direction psi base hbase

end PhysicsSM.Draft.NullEdgePluckerGeneral

end
