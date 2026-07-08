/-
# Mass monogamy, general partition form (F3, round 2)

Proof job (Aristotle). Extends the just-landed 2-way superadditivity
(`pairwiseMass_append`, provided below verbatim) to the **general monogamy**
distribution of the Plucker mass over an arbitrary partition of the bundle.

The definitions (`Spinor`, `wedge`, `upperPairs`, `pairwiseMass`) and the
2-way theorems are provided and PROVEN below - use them. Add and prove the
following, kernel-clean (no `s o r r y`):

## Targets

- **F3-cross (naming).** Define the cross-disagreement of two sub-bundles
  `crossMass psi phi := sum_{i,j} Complex.normSq (wedge (psi i) (phi j))`, and
  note `crossMass psi phi = crossMass phi psi` (symmetry) and `0 <= crossMass`.
- **F3-subset (general 2-way superadditivity over a Finset partition).** For a
  bundle `psi : Fin n -> Spinor` and a Finset `S : Finset (Fin n)`, the mass
  carried by pairs *within* `S` plus the mass carried by pairs within `Sᶜ` is at
  most the total: define `massOn S := sum over unordered pairs {i,j} ⊆ S of
  Complex.normSq (wedge (psi i) (psi j))`; then
  `massOn S + massOn Sᶜ ≤ pairwiseMass psi`, with the deficit equal to the
  cross-disagreement between `S` and `Sᶜ`. (The `Fin.append` case is `S =`
  the first block.) This is monogamy proper: no matter how the bundle is
  partitioned, the parts' internal masses never exceed the whole, and the
  slack is the inter-part disagreement.
- **F3-nway (if clean).** For a family of bundles `psi_1, ..., psi_k`, the mass
  of the concatenation is `sum_a pairwiseMass (psi_a) + sum_{a<b} crossMass
  (psi_a) (psi_b)`, hence `sum_a pairwiseMass (psi_a) ≤ pairwiseMass (append
  all)`. Deliver via iterating `pairwiseMass_append`, or state the two-block
  `massOn` form (F3-subset) if the k-fold indexing is awkward.

Run `lake env lean AllMassMonogamy2/Core.lean` (Mathlib-only). Report semantic
alignment. The load-bearing content is that internal masses never exceed the
whole and the slack is inter-part disagreement (monogamy). Commit + push.

## Provenance

Roadmap F3, round 2; all-mass overnight run 2026-07-08 [orig]. Builds on the
landed `pairwiseMass_append` (Aristotle job 3ebcaf1f).
-/

import Mathlib

namespace AllMassMonogamy2

open scoped BigOperators

abbrev Spinor := Fin 2 → ℂ

def wedge (psi phi : Spinor) : ℂ := psi 0 * phi 1 - psi 1 * phi 0

def upperPairs (n : ℕ) : Finset (Fin n × Fin n) :=
  Finset.univ.filter (fun p => p.1 < p.2)

def pairwiseMass {n : ℕ} (psi : Fin n → Spinor) : ℝ :=
  ∑ p ∈ upperPairs n, Complex.normSq (wedge (psi p.1) (psi p.2))

theorem pairwiseMass_nonneg {n : ℕ} (psi : Fin n → Spinor) :
    0 ≤ pairwiseMass psi :=
  Finset.sum_nonneg fun _ _ => Complex.normSq_nonneg _

theorem wedge_swap (a b : Spinor) : wedge b a = - wedge a b := by
  unfold wedge; ring

theorem normSq_wedge_comm (a b : Spinor) :
    Complex.normSq (wedge a b) = Complex.normSq (wedge b a) := by
  rw [wedge_swap, Complex.normSq_neg]

theorem two_mul_pairwiseMass {n : ℕ} (psi : Fin n → Spinor) :
    (2 : ℝ) * pairwiseMass psi =
      ∑ i : Fin n, ∑ j : Fin n, Complex.normSq (wedge (psi i) (psi j)) := by
  unfold pairwiseMass; simp +decide [ two_mul ] ;
  rw [ eq_comm, ← Finset.sum_product' ];
  rw [ show ( Finset.univ ×ˢ Finset.univ : Finset ( Fin n × Fin n ) ) = Finset.image ( fun p : Fin n × Fin n => ( p.2, p.1 ) ) ( upperPairs n ) ∪ upperPairs n ∪ Finset.diag ( Finset.univ : Finset ( Fin n ) ) from ?_, Finset.sum_union, Finset.sum_union ] <;> norm_num;
  · rw [ Finset.sum_image ] <;> norm_num [ add_comm, wedge_self ];
    · exact Finset.sum_congr rfl fun x hx => normSq_wedge_comm _ _;
    · aesop_cat;
  · norm_num [ Finset.disjoint_left, upperPairs ];
    grind;
  · simp +decide [ Finset.disjoint_left, upperPairs ];
    grind;
  · ext ⟨ i, j ⟩ ; by_cases hij : i = j <;> by_cases hij' : i < j <;> simp +decide [ hij ] ;
    · exact Or.inr ( Finset.mem_filter.mpr ⟨ Finset.mem_univ _, hij' ⟩ );
    · exact Or.inl ( Finset.mem_filter.mpr ⟨ Finset.mem_univ _, lt_of_le_of_ne ( le_of_not_gt hij' ) ( Ne.symm hij ) ⟩ )

/-- 2-way superadditivity (PROVEN; provided to build on). -/
theorem pairwiseMass_append {m n : ℕ} (psi : Fin m → Spinor) (phi : Fin n → Spinor) :
    pairwiseMass (Fin.append psi phi) =
      pairwiseMass psi + pairwiseMass phi
        + ∑ i : Fin m, ∑ j : Fin n, Complex.normSq (wedge (psi i) (phi j)) := by
  have h_split_sum : ∑ k : Fin (m + n), ∑ l : Fin (m + n), Complex.normSq (wedge (Fin.append psi phi k) (Fin.append psi phi l)) =
    (∑ i : Fin m, ∑ j : Fin m, Complex.normSq (wedge (psi i) (psi j))) +
    (∑ i : Fin m, ∑ j : Fin n, Complex.normSq (wedge (psi i) (phi j))) +
    (∑ i : Fin n, ∑ j : Fin m, Complex.normSq (wedge (phi i) (psi j))) +
    (∑ i : Fin n, ∑ j : Fin n, Complex.normSq (wedge (phi i) (phi j))) := by
      simp +decide [ Fin.sum_univ_add, Fin.append ];
      simp +decide only [Finset.sum_add_distrib, add_assoc];
  have h_symm_sum : ∑ i : Fin n, ∑ j : Fin m, Complex.normSq (wedge (phi i) (psi j)) = ∑ i : Fin m, ∑ j : Fin n, Complex.normSq (wedge (psi i) (phi j)) := by
    exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => normSq_wedge_comm _ _ );
  linarith [ two_mul_pairwiseMass psi, two_mul_pairwiseMass phi, two_mul_pairwiseMass (Fin.append psi phi) ]

/- F3-cross, F3-subset, F3-nway: add and prove here. -/

end AllMassMonogamy2
