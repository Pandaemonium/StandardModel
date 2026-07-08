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

/-!
PROJECT PROVENANCE (landed 2026-07-08). Roadmap item **F3** round 2; Aristotle
job `b6764db8-a5f7-4bbb-bea4-241d6c5dfce4`, re-checked under the pinned toolchain.
General-partition mass monogamy, extending `Carrier/MassMonogamy.lean`: for any
`Finset` split `S` of a bundle, the internal masses never exceed the whole
(`massOn_add_massOn_compl_le`), the slack being the inter-part disagreement; plus
the 3-way concatenation form. Self-contained (re-derives the base defs).
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.MassMonogamyPartition

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

theorem wedge_self (a : Spinor) : wedge a a = 0 := by
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

/-! ## F3-cross: cross-disagreement of two sub-bundles -/

/-- The **cross-disagreement** of two sub-bundles: the total mass carried by the
wedges of every fibre of `psi` against every fibre of `phi`. -/
def crossMass {m n : ℕ} (psi : Fin m → Spinor) (phi : Fin n → Spinor) : ℝ :=
  ∑ i : Fin m, ∑ j : Fin n, Complex.normSq (wedge (psi i) (phi j))

theorem crossMass_nonneg {m n : ℕ} (psi : Fin m → Spinor) (phi : Fin n → Spinor) :
    0 ≤ crossMass psi phi := by
  unfold crossMass
  exact Finset.sum_nonneg fun _ _ => Finset.sum_nonneg fun _ _ => Complex.normSq_nonneg _

theorem crossMass_comm {m n : ℕ} (psi : Fin m → Spinor) (phi : Fin n → Spinor) :
    crossMass psi phi = crossMass phi psi := by
  unfold crossMass
  exact Finset.sum_comm.trans
    (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => normSq_wedge_comm _ _)

/-
Cross-disagreement distributes over a concatenated right block.
-/
theorem crossMass_append_right {m n k : ℕ} (psi : Fin m → Spinor)
    (phi : Fin n → Spinor) (chi : Fin k → Spinor) :
    crossMass psi (Fin.append phi chi) = crossMass psi phi + crossMass psi chi := by
  unfold crossMass; simp +decide [ Fin.sum_univ_add ] ;
  rw [ Finset.sum_add_distrib ]

/-! ## F3-subset: general 2-way superadditivity over a Finset partition -/

/-- The mass carried by unordered pairs lying **inside** the block `S`. -/
def massOn {n : ℕ} (psi : Fin n → Spinor) (S : Finset (Fin n)) : ℝ :=
  ∑ p ∈ (upperPairs n).filter (fun p => p.1 ∈ S ∧ p.2 ∈ S),
    Complex.normSq (wedge (psi p.1) (psi p.2))

/-- The **inter-part disagreement** for a split `S ∪ Sᶜ`: the mass carried by
unordered pairs with exactly one endpoint in `S`. -/
def interMass {n : ℕ} (psi : Fin n → Spinor) (S : Finset (Fin n)) : ℝ :=
  ∑ p ∈ (upperPairs n).filter (fun p => ¬ (p.1 ∈ S ↔ p.2 ∈ S)),
    Complex.normSq (wedge (psi p.1) (psi p.2))

theorem massOn_nonneg {n : ℕ} (psi : Fin n → Spinor) (S : Finset (Fin n)) :
    0 ≤ massOn psi S :=
  Finset.sum_nonneg fun _ _ => Complex.normSq_nonneg _

theorem interMass_nonneg {n : ℕ} (psi : Fin n → Spinor) (S : Finset (Fin n)) :
    0 ≤ interMass psi S :=
  Finset.sum_nonneg fun _ _ => Complex.normSq_nonneg _

/-
**Exact mass partition.** The total pairwise mass splits, with no loss, into
the internal mass of `S`, the internal mass of its complement `Sᶜ`, and the
inter-part disagreement between the two blocks.
-/
theorem pairwiseMass_split {n : ℕ} (psi : Fin n → Spinor) (S : Finset (Fin n)) :
    pairwiseMass psi = massOn psi S + massOn psi Sᶜ + interMass psi S := by
  unfold pairwiseMass massOn interMass;
  simp +decide only [Finset.sum_filter, ← Finset.sum_add_distrib];
  congr with p ; aesop

/-- **Monogamy (headline).** However the bundle is partitioned into `S` and
`Sᶜ`, the two internal masses never exceed the whole; the slack is exactly the
inter-part disagreement `interMass psi S ≥ 0`. -/
theorem massOn_add_massOn_compl_le {n : ℕ} (psi : Fin n → Spinor)
    (S : Finset (Fin n)) :
    massOn psi S + massOn psi Sᶜ ≤ pairwiseMass psi := by
  have h := pairwiseMass_split psi S
  have hi := interMass_nonneg psi S
  linarith

/-! ## F3-nway: k-fold concatenation (demonstrated for k = 3) -/

/-- Three-fold concatenation: the mass of the concatenation is the sum of the
three sub-masses plus the three pairwise cross-disagreements. -/
theorem pairwiseMass_append3 {m n k : ℕ} (psi : Fin m → Spinor)
    (phi : Fin n → Spinor) (chi : Fin k → Spinor) :
    pairwiseMass (Fin.append psi (Fin.append phi chi)) =
      pairwiseMass psi + pairwiseMass phi + pairwiseMass chi
        + crossMass psi phi + crossMass psi chi + crossMass phi chi := by
  have h1 := pairwiseMass_append psi (Fin.append phi chi)
  have h2 := pairwiseMass_append phi chi
  have h3 := crossMass_append_right psi phi chi
  unfold crossMass at *
  linarith

/-- **Monogamy, 3-way form.** The three internal masses never exceed the mass of
the concatenation; the slack is the sum of the pairwise cross-disagreements. -/
theorem pairwiseMass_append3_le {m n k : ℕ} (psi : Fin m → Spinor)
    (phi : Fin n → Spinor) (chi : Fin k → Spinor) :
    pairwiseMass psi + pairwiseMass phi + pairwiseMass chi ≤
      pairwiseMass (Fin.append psi (Fin.append phi chi)) := by
  have h := pairwiseMass_append3 psi phi chi
  have c1 := crossMass_nonneg psi phi
  have c2 := crossMass_nonneg psi chi
  have c3 := crossMass_nonneg phi chi
  linarith

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassMonogamyPartition.massOn_add_massOn_compl_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massOn_add_massOn_compl_le

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassMonogamyPartition.pairwiseMass_append3_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairwiseMass_append3_le

end PhysicsSM.Draft.NullEdge.Carrier.MassMonogamyPartition
