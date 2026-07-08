/-
# Mass monogamy: the Plucker mass is superadditive, and the excess is binding

DRAFT (kernel-clean; no `s o r r y`). Roadmap item **F3**
(`AgentTasks/overnight-allmass-run-2026-07-08/STRENGTHENING_ROADMAP.md`): a new
finite theorem about the kinematic mass of a bundle of null Weyl spinors,
`det P = sum_{i<j} |psi_i ^ psi_j|^2` (the trusted §3 invariant; here in a
self-contained `Fin 2 -> C` presentation). It formalizes the **monogamy /
superadditivity** structure of that distribution:

* `pairwiseMass_append` (**M**): the pairwise mass of a *concatenated* bundle is
  the sum of the two sub-masses PLUS the total cross-pair disagreement. Combining
  bundles *creates* mass equal to their mutual non-collinearity.
* `pairwiseMass_le_append` (**M**): hence combining never decreases mass
  (superadditivity).
* `pairwiseMass_append_eq_iff` (**M**): the bound is tight iff every cross pair is
  collinear - two bundles bind iff they disagree.

## Why it matters

This is a finite kinematic analogue behind the `Delta` binding-defect candidate
(`DELTA_BINDING_ENERGY_FINDING.md`): mass is created *off-diagonally* on bundle
union. It does not establish the dynamical binding defect; it only supplies the
finite off-diagonal Plucker accounting that such a bridge would have to use. In
this program's literature search
(`Sources/Null_Edge_All_Mass_Literature_Review_2026-07-08.md`) we did not find
this Plucker-mass packaging of monogamy (as distinct from the mature
entanglement-monogamy literature: Coffman-Kundu-Wootters; Osborne-Verstraete;
Nandi's G-concurrence), but we make no priority claim.

## Provenance

Statement + Lean proof: Aristotle strengthening round-2 job
`3ebcaf1f-5562-4149-b9fd-73d25582bfae` (2026-07-08), re-checked under the pinned
toolchain - [orig]. Elementary Finset double-sum algebra - [import].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.MassMonogamy

open scoped BigOperators

/-- A complex Weyl 2-spinor. -/
abbrev Spinor := Fin 2 → ℂ

/-- The spinor wedge / Plucker coordinate: the `SL(2,C)` invariant of two
spinors. Vanishes iff the two are collinear. -/
def wedge (psi phi : Spinor) : ℂ := psi 0 * phi 1 - psi 1 * phi 0

/-- The set of ordered pairs `i < j` of a finite index. -/
def upperPairs (n : ℕ) : Finset (Fin n × Fin n) :=
  Finset.univ.filter (fun p => p.1 < p.2)

/-- Pairwise Plucker mass squared of a finite bundle:
`sum_{i<j} |psi_i wedge psi_j|^2`. Real and nonnegative. -/
def pairwiseMass {n : ℕ} (psi : Fin n → Spinor) : ℝ :=
  ∑ p ∈ upperPairs n, Complex.normSq (wedge (psi p.1) (psi p.2))

/-- **T-nonneg.** The pairwise mass is nonnegative. -/
theorem pairwiseMass_nonneg {n : ℕ} (psi : Fin n → Spinor) :
    0 ≤ pairwiseMass psi :=
  Finset.sum_nonneg fun _ _ => Complex.normSq_nonneg _

/-- A spinor does not disagree with itself. -/
theorem wedge_self (psi : Spinor) : wedge psi psi = 0 := by
  unfold wedge; ring

/-- The wedge is antisymmetric. -/
theorem wedge_swap (a b : Spinor) : wedge b a = - wedge a b := by
  unfold wedge; ring

/-- The squared magnitude of the wedge is symmetric in its arguments. -/
theorem normSq_wedge_comm (a b : Spinor) :
    Complex.normSq (wedge a b) = Complex.normSq (wedge b a) := by
  rw [wedge_swap, Complex.normSq_neg]

/-- **Half-sum form.** The full (unordered) double sum counts each unordered pair
twice and the diagonal (self-pairs, which vanish) zero times, so it equals twice
the pairwise mass. -/
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

/-- **F3a - SUPERADDITIVITY (headline).** The pairwise mass of a concatenated
bundle equals the sum of the sub-masses plus the total cross disagreement. -/
theorem pairwiseMass_append {m n : ℕ} (psi : Fin m → Spinor) (phi : Fin n → Spinor) :
    pairwiseMass (Fin.append psi phi) =
      pairwiseMass psi + pairwiseMass phi
        + ∑ i : Fin m, ∑ j : Fin n, Complex.normSq (wedge (psi i) (phi j)) := by
  have h_append : 2 * pairwiseMass (Fin.append psi phi) = ∑ k : Fin (m + n), ∑ l : Fin (m + n), Complex.normSq (wedge (Fin.append psi phi k) (Fin.append psi phi l)) := by
    exact two_mul_pairwiseMass (Fin.append psi phi)
  have h_split_sum : ∑ k : Fin (m + n), ∑ l : Fin (m + n), Complex.normSq (wedge (Fin.append psi phi k) (Fin.append psi phi l)) =
    (∑ i : Fin m, ∑ j : Fin m, Complex.normSq (wedge (psi i) (psi j))) +
    (∑ i : Fin m, ∑ j : Fin n, Complex.normSq (wedge (psi i) (phi j))) +
    (∑ i : Fin n, ∑ j : Fin m, Complex.normSq (wedge (phi i) (psi j))) +
    (∑ i : Fin n, ∑ j : Fin n, Complex.normSq (wedge (phi i) (phi j))) := by
      simp +decide [ Fin.sum_univ_add, Fin.append ];
      simp +decide only [Finset.sum_add_distrib, add_assoc];
  have h_symm_sum : ∑ i : Fin n, ∑ j : Fin m, Complex.normSq (wedge (phi i) (psi j)) = ∑ i : Fin m, ∑ j : Fin n, Complex.normSq (wedge (psi i) (phi j)) := by
    exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => normSq_wedge_comm _ _ );
  linarith [ two_mul_pairwiseMass psi, two_mul_pairwiseMass phi ]

/-- **F3a - superadditivity inequality.** Combining bundles never decreases mass. -/
theorem pairwiseMass_le_append {m n : ℕ} (psi : Fin m → Spinor) (phi : Fin n → Spinor) :
    pairwiseMass psi + pairwiseMass phi ≤ pairwiseMass (Fin.append psi phi) := by
  convert pairwiseMass_append psi phi |> fun h => h.ge.trans' ( le_add_of_nonneg_right ( Finset.sum_nonneg fun i _ => Finset.sum_nonneg fun j _ => Complex.normSq_nonneg _ ) ) using 1

/-- **F3b - EQUALITY / monogamy characterization.** The superadditivity bound is
tight iff every cross pair is collinear (the two sub-bundles mutually agree). -/
theorem pairwiseMass_append_eq_iff {m n : ℕ} (psi : Fin m → Spinor) (phi : Fin n → Spinor) :
    pairwiseMass (Fin.append psi phi) = pairwiseMass psi + pairwiseMass phi ↔
      ∀ i : Fin m, ∀ j : Fin n, wedge (psi i) (phi j) = 0 := by
  rw [pairwiseMass_append];
  simp only [add_eq_left];
  rw [ Finset.sum_eq_zero_iff_of_nonneg fun i _ => Finset.sum_nonneg fun j _ => Complex.normSq_nonneg _ ];
  simp +decide [ Finset.sum_eq_zero_iff_of_nonneg, Complex.normSq_nonneg ]

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassMonogamy.pairwiseMass_append' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairwiseMass_append

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.MassMonogamy.pairwiseMass_append_eq_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairwiseMass_append_eq_iff

end PhysicsSM.Draft.NullEdge.Carrier.MassMonogamy
