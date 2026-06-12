import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldFock

/-!
# Spinor.SpinorTenfoldCAR

The canonical anticommutation relations (CAR) and the Clifford relation for
the concrete `Spin(10)` Fock model of `PhysicsSM.Spinor.SpinorTenfoldFock`.

## Mathematical context

This module verifies that the coordinate definitions of `wedge` (creation),
`contract` (annihilation), and `cliffordAction` really implement the
hyperbolic Clifford algebra on the exterior Fock model:

- creation/annihilation at the same index anticommute to the identity,
- distinct operators of every kind anticommute,
- the Clifford square relation `v · (v · ψ) = Q10 v • ψ` holds,
- polarized form: `v · (w · ψ) + w · (v · ψ) = B10 v w • ψ`.

These are the algebraic engine for the pure-spinor development: in particular
they imply that annihilator subspaces of nonzero spinors are isotropic (see
`PhysicsSM.Spinor.SpinorTenfoldColorAxis`).

## Provenance

Proofs produced by the Aristotle proof agent
(job `d91d6453-444a-498f-bf12-a4027c46c13a`, task
`AgentTasks/spin10-car-clifford-aristotle-2026-06-09.md`) and reviewed for
semantic alignment. Two helper lemmas (`belowCount_erase_of_lt`,
`belowCount_insert_of_lt`) originally used `native_decide`; they were replaced
with structural proofs during integration so that this module is axiom-free,
and the slow `fin_cases` proof of `belowCount_erase_of_not_lt` was replaced by
the matching structural argument. Statements are unchanged from the handoff
file `PhysicsSM/Draft/SpinorTenfoldCARAristotle.lean` (now retired).

Conventions are those of `PhysicsSM.Spinor.SpinorTenfoldFock`, validated by
`Scripts/oracle/validate_spinor_tenfold.py`.

Status: trusted — no `sorry`, no `axiom` (in particular no `native_decide`).
-/

noncomputable section

namespace PhysicsSM.Spinor.SpinorTenfold

open Finset

/-!
## Sign bookkeeping helpers

The fermionic ordering sign `opSign i S = (-1)^{belowCount i S}` interacts with
`erase`/`insert` of a *different* index `i`. The four lemmas below record how
`belowCount j` changes when we remove/insert `i`, split by whether `i < j`.
-/

/-- Removing a present element `i < j` decreases the below-count by one. -/
theorem belowCount_erase_of_lt {i j : Fin 5} {S : Finset (Fin 5)}
    (hi : i ∈ S) (hlt : i < j) :
    belowCount j (S.erase i) + 1 = belowCount j S := by
  unfold belowCount
  rw [Finset.filter_erase,
    Finset.card_erase_of_mem (Finset.mem_filter.mpr ⟨hi, hlt⟩)]
  have hpos : 0 < (S.filter (fun k => k < j)).card :=
    Finset.card_pos.mpr ⟨i, Finset.mem_filter.mpr ⟨hi, hlt⟩⟩
  omega

/-- Removing an element `i` with `¬ i < j` does not change the below-count. -/
theorem belowCount_erase_of_not_lt {i j : Fin 5} {S : Finset (Fin 5)}
    (hlt : ¬ i < j) :
    belowCount j (S.erase i) = belowCount j S := by
  unfold belowCount
  rw [Finset.filter_erase, Finset.erase_eq_of_notMem]
  intro h
  exact hlt (Finset.mem_filter.mp h).2

/-- Inserting an absent element `i < j` increases the below-count by one. -/
theorem belowCount_insert_of_lt {i j : Fin 5} {S : Finset (Fin 5)}
    (hi : i ∉ S) (hlt : i < j) :
    belowCount j (insert i S) = belowCount j S + 1 := by
  unfold belowCount
  rw [Finset.filter_insert, if_pos hlt,
    Finset.card_insert_of_notMem (fun h => hi (Finset.mem_filter.mp h).1)]

/-- Inserting an element `i` with `¬ i < j` does not change the below-count. -/
theorem belowCount_insert_of_not_lt {i j : Fin 5} {S : Finset (Fin 5)}
    (hlt : ¬ i < j) :
    belowCount j (insert i S) = belowCount j S := by
  unfold belowCount;
  rw [ Finset.filter_insert, if_neg hlt ]

/-- Sign flip from erasing a smaller present index. -/
theorem opSign_erase_of_lt {i j : Fin 5} {S : Finset (Fin 5)}
    (hi : i ∈ S) (hlt : i < j) :
    opSign j (S.erase i) = - opSign j S := by
  unfold opSign
  rw [← belowCount_erase_of_lt hi hlt, pow_succ]
  ring

/-- No sign change from erasing an index that is not below `j`. -/
theorem opSign_erase_of_not_lt {i j : Fin 5} {S : Finset (Fin 5)}
    (hlt : ¬ i < j) :
    opSign j (S.erase i) = opSign j S := by
  unfold opSign
  rw [belowCount_erase_of_not_lt hlt]

/-- Sign flip from inserting a smaller absent index. -/
theorem opSign_insert_of_lt {i j : Fin 5} {S : Finset (Fin 5)}
    (hi : i ∉ S) (hlt : i < j) :
    opSign j (insert i S) = - opSign j S := by
  unfold opSign
  rw [belowCount_insert_of_lt hi hlt, pow_succ]
  ring

/-- No sign change from inserting an index that is not below `j`. -/
theorem opSign_insert_of_not_lt {i j : Fin 5} {S : Finset (Fin 5)}
    (hlt : ¬ i < j) :
    opSign j (insert i S) = opSign j S := by
  unfold opSign
  rw [belowCount_insert_of_not_lt hlt]

/-!
## The canonical anticommutation relations
-/

/-- Creation and annihilation at the same index anticommute to the identity. -/
theorem wedge_contract_same_add
    (i : Fin 5) (psi : FockSpinor) :
    wedge i (contract i psi) + contract i (wedge i psi) = psi := by
  ext S; simp [wedge, contract];
  by_cases hi : i ∈ S <;> simp +decide [ hi ];
  · simp +decide [ ← mul_assoc, opSign, belowCount_erase ];
    norm_num [ ← mul_pow ];
  · simp +decide [ ← mul_assoc, ← pow_add, opSign ];
    rw [ belowCount_insert_of_not_lt ] <;> simp +decide [ hi ]

/-- Two distinct creation operators anticommute. -/
theorem wedge_wedge_anticomm
    {i j : Fin 5} (hij : i ≠ j) (psi : FockSpinor) :
    wedge i (wedge j psi) + wedge j (wedge i psi) = 0 := by
  ext S;
  by_cases hi : i ∈ S <;> by_cases hj : j ∈ S <;> simp +decide [ *, wedge ];
  -- Consider the two cases: i < j and j < i.
  by_cases hlt : i < j;
  · rw [ if_neg ( ne_of_gt hlt ), opSign_erase_of_lt hi hlt, opSign_erase_of_not_lt ( not_lt_of_gt hlt ) ] ; ring;
    rw [ Finset.erase_right_comm ] ; ring;
  · rw [ opSign_erase_of_not_lt hlt, opSign_erase_of_lt hj ( lt_of_le_of_ne ( le_of_not_gt hlt ) hij.symm ) ] ; ring;
    rw [ if_neg hij.symm, Finset.erase_right_comm ] ; ring

/-- Two distinct annihilation operators anticommute. -/
theorem contract_contract_anticomm
    {i j : Fin 5} (hij : i ≠ j) (psi : FockSpinor) :
    contract i (contract j psi) + contract j (contract i psi) = 0 := by
  funext S; by_cases hi : i ∈ S <;> by_cases hj : j ∈ S <;> simp_all +decide [ contract ] ;
  by_cases hlt : i < j <;> simp_all +decide [ opSign_insert_of_lt, opSign_insert_of_not_lt ];
  · rw [ opSign_insert_of_not_lt ] <;> simp_all +decide [ Finset.insert_comm ];
    · rw [ if_neg ( Ne.symm hij ) ] ; ring;
    · exact le_of_lt hlt;
  · rw [ opSign_insert_of_lt ];
    · rw [ if_neg ( Ne.symm hij ) ] ; rw [ Finset.insert_comm ] ; ring;
    · assumption;
    · exact lt_of_le_of_ne hlt ( Ne.symm hij )

/-- Creation and annihilation at distinct indices anticommute. -/
theorem wedge_contract_distinct_anticomm
    {i j : Fin 5} (hij : i ≠ j) (psi : FockSpinor) :
    wedge i (contract j psi) + contract j (wedge i psi) = 0 := by
  ext S;
  by_cases hi : i ∈ S <;> by_cases hj : j ∈ S <;> simp_all +decide [ wedge, contract ];
  · aesop;
  · grind +suggestions

/-!
## Linearity of the operators over finite sums
-/

/-- `wedge i` commutes with finite sums of spinors. -/
theorem wedge_sum {α : Type*} (i : Fin 5) (s : Finset α) (f : α → FockSpinor) :
    wedge i (∑ k ∈ s, f k) = ∑ k ∈ s, wedge i (f k) := by
  induction s using Finset.cons_induction <;> simp_all +decide [ Finset.sum_insert, Finset.sum_singleton ];
  rw [ ← ‹wedge i ( ∑ k ∈ _, f k ) = ∑ k ∈ _, wedge i ( f k ) ›, wedge_add ]

/-- `contract i` commutes with finite sums of spinors. -/
theorem contract_sum {α : Type*} (i : Fin 5) (s : Finset α) (f : α → FockSpinor) :
    contract i (∑ k ∈ s, f k) = ∑ k ∈ s, contract i (f k) := by
  induction' s using Finset.induction with a s has ih;
  simp [contract_zero];
  by_cases ha : a ∈ s <;> simp_all +decide [ Finset.sum_insert, contract_add ];
  exact Classical.decEq α

/-!
## The Clifford square relation

We expand `v · (v · ψ)` into four double sums of operator products and use the
CAR lemmas. The two "diagonal" blocks (creation-creation and
annihilation-annihilation) vanish by antisymmetry; the two mixed blocks combine
to `Q10 v • ψ`.
-/

/-- The creation-creation double sum vanishes by antisymmetry. -/
theorem wedge_wedge_double_sum_zero (a : Fin 5 → ℂ) (psi : FockSpinor) :
    ∑ i, ∑ k, (a i * a k) • wedge i (wedge k psi) = 0 := by
  have h_sum_zero : ∑ i, ∑ k, (a i * a k) • wedge i (wedge k psi) = ∑ i, ∑ k, -(a i * a k) • wedge i (wedge k psi) := by
    rw [ Finset.sum_comm ];
    refine' Finset.sum_congr rfl fun i hi => Finset.sum_congr rfl fun j hj => _;
    by_cases hij : i = j;
    · simp +decide [ hij, wedge_wedge_self ];
    · have := wedge_wedge_anticomm hij psi;
      rw [ eq_neg_of_add_eq_zero_right this ] ; norm_num ; ring;
  exact eq_of_sub_eq_zero ( by ext; have := congr_fun h_sum_zero ‹_›; norm_num at *; linear_combination' this / 2 )

/-- The annihilation-annihilation double sum vanishes by antisymmetry. -/
theorem contract_contract_double_sum_zero (b : Fin 5 → ℂ) (psi : FockSpinor) :
    ∑ i, ∑ k, (b i * b k) • contract i (contract k psi) = 0 := by
  -- By commutativity of the sum and antisymmetry of the terms, we can show that the sum is equal to its own negative.
  have h_sum_neg : ∑ i, ∑ k, (b i * b k) • contract i (contract k psi) = -∑ i, ∑ k, (b i * b k) • contract i (contract k psi) := by
    have h_sum_neg : ∑ i, ∑ k, (b i * b k) • contract i (contract k psi) = ∑ i, ∑ k, (b k * b i) • contract k (contract i psi) := by
      rw [ Finset.sum_comm ];
    rw [ ← Finset.sum_neg_distrib ];
    rw [ h_sum_neg, Finset.sum_congr rfl ];
    intro i hi; rw [ ← Finset.sum_neg_distrib ] ; refine' Finset.sum_congr rfl fun j hj => _ ; by_cases hij : i = j <;> simp +decide [ *, mul_comm ] ;
    · rw [ contract_contract_self ] ; norm_num;
    · have := contract_contract_anticomm hij psi; simp_all +decide [ mul_comm, add_eq_zero_iff_eq_neg ] ;
  grind +qlia

/-- The two mixed double sums combine to `(∑ aᵢ bᵢ) • ψ`. -/
theorem mixed_double_sum (a b : Fin 5 → ℂ) (psi : FockSpinor) :
    (∑ i, ∑ k, (a i * b k) • wedge i (contract k psi))
      + (∑ i, ∑ k, (b i * a k) • contract i (wedge k psi))
      = (∑ i, a i * b i) • psi := by
  rw [ ← Finset.sum_comm ]
  simp +decide [ mul_comm, Finset.sum_add_distrib, Finset.smul_sum,
    Finset.sum_smul, ← add_smul ]
  rw [ ← Finset.sum_add_distrib ];
  refine' Finset.sum_congr rfl fun i hi => _;
  rw [ ← Finset.sum_add_distrib ];
  rw [ Finset.sum_eq_single i ];
  · rw [ ← smul_add, wedge_contract_same_add ];
  · intro j hj hij; rw [ ← smul_add ] ; rw [ wedge_contract_distinct_anticomm hij ] ; simp +decide ;
  · aesop

/-- The Clifford square expands into four double-sum operator blocks. -/
theorem cliffordAction_cliffordAction_expand (v : V10) (psi : FockSpinor) :
    cliffordAction v (cliffordAction v psi)
      = (∑ i, ∑ k, (v.1 i * v.1 k) • wedge i (wedge k psi))
        + (∑ i, ∑ k, (v.1 i * v.2 k) • wedge i (contract k psi))
        + (∑ i, ∑ k, (v.2 i * v.1 k) • contract i (wedge k psi))
        + (∑ i, ∑ k, (v.2 i * v.2 k) • contract i (contract k psi)) := by
  rw [cliffordAction_eq_sum];
  rw [cliffordAction_eq_sum];
  simp +decide only [wedge_add, smul_add, sum_add_distrib, contract_add];
  simp +decide only [wedge_sum, wedge_smul, contract_sum, contract_smul, mul_smul];
  simp +decide only [smul_sum, add_assoc]

/-- **The Clifford square relation** in the hyperbolic Fock model:
`v · (v · ψ) = Q10 v • ψ`. The coordinate operators genuinely represent the
Clifford algebra `Cl(10, ℂ)`. -/
theorem cliffordAction_cliffordAction_self
    (v : V10) (psi : FockSpinor) :
    cliffordAction v (cliffordAction v psi) = Q10 v • psi := by
  rw [cliffordAction_cliffordAction_expand, wedge_wedge_double_sum_zero,
    contract_contract_double_sum_zero, zero_add, add_zero, mixed_double_sum]
  rw [Q10]

/-- **Polarized Clifford relation**:
`v · (w · ψ) + w · (v · ψ) = B10 v w • ψ`. -/
theorem cliffordAction_anticomm
    (v w : V10) (psi : FockSpinor) :
    cliffordAction v (cliffordAction w psi)
      + cliffordAction w (cliffordAction v psi)
      = B10 v w • psi := by
  have h_expand :
      cliffordAction v (cliffordAction w psi) + cliffordAction w (cliffordAction v psi)
        = cliffordAction (v + w) (cliffordAction (v + w) psi)
          - cliffordAction v (cliffordAction v psi)
          - cliffordAction w (cliffordAction w psi) := by
    simp only [cliffordAction_add_vec, cliffordAction_add_spinor]
    abel
  rw [h_expand, cliffordAction_cliffordAction_self, cliffordAction_cliffordAction_self,
    cliffordAction_cliffordAction_self, Q10_add, add_smul, add_smul]
  abel

end PhysicsSM.Spinor.SpinorTenfold

end
