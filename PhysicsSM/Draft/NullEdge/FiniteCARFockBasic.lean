import Mathlib

/-!
# Generic finite occupation-basis CAR algebra

For any finite linearly ordered mode type, this module defines the fermionic
occupation-basis Fock space, creation and annihilation operators, and proves
the canonical anticommutation relations.  The linear order fixes only Koszul
sign bookkeeping; it is not physical structure.

This is the algebraic first rung of the second quantization of the finite
Pluecker walk.  It does not yet define the exterior-power lift of a general
one-particle unitary or prove many-body locality.

Provenance: clean-room generic port of the trusted finite-mode proofs in
`PhysicsSM.Spinor.SpinorTenfoldCAR`, with `Fin 5` replaced by an arbitrary
finite linearly ordered mode type.  Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteCARFockBasic

open Finset

variable {ι : Type*} [DecidableEq ι] [LinearOrder ι]

/-- Fermionic Fock space in the occupation-number basis. -/
abbrev Fock (ι : Type*) := Finset ι -> Complex

def belowCount (i : ι) (S : Finset ι) : Nat :=
  (S.filter fun j => j < i).card

def opSign (i : ι) (S : Finset ι) : Complex :=
  (-1 : Complex) ^ belowCount i S

/-- Creation operator at mode `i`. -/
def create (i : ι) (psi : Fock ι) : Fock ι := fun S =>
  if i ∈ S then opSign i S * psi (S.erase i) else 0

/-- Annihilation operator at mode `i`. -/
def annihilate (i : ι) (psi : Fock ι) : Fock ι := fun S =>
  if i ∈ S then 0 else opSign i S * psi (insert i S)

theorem belowCount_erase (i : ι) (S : Finset ι) :
    belowCount i (S.erase i) = belowCount i S := by
  unfold belowCount
  congr 1
  ext j
  simp only [mem_filter, mem_erase]
  constructor
  · rintro ⟨⟨_, hj⟩, hlt⟩
    exact ⟨hj, hlt⟩
  · rintro ⟨hj, hlt⟩
    exact ⟨⟨ne_of_lt hlt, hj⟩, hlt⟩

omit [DecidableEq ι] in theorem opSign_mul_self (i : ι) (S : Finset ι) :
    opSign i S * opSign i S = 1 := by
  unfold opSign
  rw [<- pow_add, <- two_mul, pow_mul]
  simp

theorem belowCount_erase_of_lt {i j : ι} {S : Finset ι}
    (hi : i ∈ S) (hlt : i < j) :
    belowCount j (S.erase i) + 1 = belowCount j S := by
  unfold belowCount
  rw [Finset.filter_erase,
    Finset.card_erase_of_mem (Finset.mem_filter.mpr ⟨hi, hlt⟩)]
  have hpos : 0 < (S.filter fun k => k < j).card :=
    Finset.card_pos.mpr ⟨i, Finset.mem_filter.mpr ⟨hi, hlt⟩⟩
  omega

theorem belowCount_erase_of_not_lt {i j : ι} {S : Finset ι}
    (hlt : ¬ i < j) :
    belowCount j (S.erase i) = belowCount j S := by
  unfold belowCount
  rw [Finset.filter_erase, Finset.erase_eq_of_notMem]
  intro h
  exact hlt (Finset.mem_filter.mp h).2

theorem belowCount_insert_of_lt {i j : ι} {S : Finset ι}
    (hi : i ∉ S) (hlt : i < j) :
    belowCount j (insert i S) = belowCount j S + 1 := by
  unfold belowCount
  rw [Finset.filter_insert, if_pos hlt,
    Finset.card_insert_of_notMem (fun h => hi (Finset.mem_filter.mp h).1)]

theorem belowCount_insert_of_not_lt {i j : ι} {S : Finset ι}
    (hlt : ¬ i < j) :
    belowCount j (insert i S) = belowCount j S := by
  unfold belowCount
  rw [Finset.filter_insert, if_neg hlt]

theorem opSign_erase_of_lt {i j : ι} {S : Finset ι}
    (hi : i ∈ S) (hlt : i < j) :
    opSign j (S.erase i) = -opSign j S := by
  unfold opSign
  rw [<- belowCount_erase_of_lt hi hlt, pow_succ]
  ring

theorem opSign_erase_of_not_lt {i j : ι} {S : Finset ι}
    (hlt : ¬ i < j) :
    opSign j (S.erase i) = opSign j S := by
  unfold opSign
  rw [belowCount_erase_of_not_lt hlt]

theorem opSign_insert_of_lt {i j : ι} {S : Finset ι}
    (hi : i ∉ S) (hlt : i < j) :
    opSign j (insert i S) = -opSign j S := by
  unfold opSign
  rw [belowCount_insert_of_lt hi hlt, pow_succ]
  ring

theorem opSign_insert_of_not_lt {i j : ι} {S : Finset ι}
    (hlt : ¬ i < j) :
    opSign j (insert i S) = opSign j S := by
  unfold opSign
  rw [belowCount_insert_of_not_lt hlt]

/-- Creation is nilpotent at a fixed mode. -/
theorem create_create_self (i : ι) (psi : Fock ι) :
    create i (create i psi) = 0 := by
  funext S
  simp only [create, Pi.zero_apply]
  split
  · rw [if_neg (Finset.notMem_erase i S), mul_zero]
  · rfl

/-- Annihilation is nilpotent at a fixed mode. -/
theorem annihilate_annihilate_self (i : ι) (psi : Fock ι) :
    annihilate i (annihilate i psi) = 0 := by
  funext S
  simp only [annihilate, Pi.zero_apply]
  split
  · rfl
  · rw [if_pos (Finset.mem_insert_self i S), mul_zero]

/-- Same-mode CAR: `{a_i^dagger, a_i} = 1`. -/
theorem create_annihilate_same_add (i : ι) (psi : Fock ι) :
    create i (annihilate i psi) + annihilate i (create i psi) = psi := by
  ext S
  simp [create, annihilate]
  by_cases hi : i ∈ S <;> simp +decide [hi]
  · simp +decide [<- mul_assoc, opSign, belowCount_erase]
    norm_num [<- mul_pow]
  · simp +decide [<- mul_assoc, <- pow_add, opSign]
    rw [belowCount_insert_of_not_lt] <;> simp +decide

/-- Distinct creation operators anticommute. -/
theorem create_create_anticomm {i j : ι} (hij : i ≠ j) (psi : Fock ι) :
    create i (create j psi) + create j (create i psi) = 0 := by
  ext S
  by_cases hi : i ∈ S <;> by_cases hj : j ∈ S <;>
    simp +decide [*, create]
  by_cases hlt : i < j
  · rw [if_neg (ne_of_gt hlt), opSign_erase_of_lt hi hlt,
      opSign_erase_of_not_lt (not_lt_of_gt hlt)]
    ring
    rw [Finset.erase_right_comm]
    ring
  · rw [opSign_erase_of_not_lt hlt,
      opSign_erase_of_lt hj (lt_of_le_of_ne (le_of_not_gt hlt) hij.symm)]
    ring
    rw [if_neg hij.symm, Finset.erase_right_comm]
    ring

/-- Distinct annihilation operators anticommute. -/
theorem annihilate_annihilate_anticomm {i j : ι}
    (hij : i ≠ j) (psi : Fock ι) :
    annihilate i (annihilate j psi) +
      annihilate j (annihilate i psi) = 0 := by
  funext S
  by_cases hi : i ∈ S <;> by_cases hj : j ∈ S <;>
    simp_all +decide [annihilate]
  by_cases hlt : i < j <;>
    simp_all +decide [opSign_insert_of_lt, opSign_insert_of_not_lt]
  · rw [opSign_insert_of_not_lt] <;>
      simp_all +decide [Finset.insert_comm]
    · rw [if_neg (Ne.symm hij)]
      ring
    · exact le_of_lt hlt
  · rw [opSign_insert_of_lt]
    · rw [if_neg (Ne.symm hij), Finset.insert_comm]
      ring
    · assumption
    · exact lt_of_le_of_ne hlt (Ne.symm hij)

/-- Distinct creation and annihilation operators anticommute. -/
theorem create_annihilate_distinct_anticomm {i j : ι}
    (hij : i ≠ j) (psi : Fock ι) :
    create i (annihilate j psi) + annihilate j (create i psi) = 0 := by
  ext S
  by_cases hi : i ∈ S <;> by_cases hj : j ∈ S <;>
    simp_all +decide [create, annihilate]
  · aesop
  · by_cases hlt : i < j
    · rw [opSign_erase_of_lt hi hlt,
        opSign_insert_of_not_lt (i := j) (j := i) (not_lt_of_gt hlt),
        Finset.erase_insert_of_ne (Ne.symm hij)]
      ring
    · have hji : j < i :=
        lt_of_le_of_ne (le_of_not_gt hlt) (Ne.symm hij)
      rw [opSign_erase_of_not_lt hlt,
        opSign_insert_of_lt hj hji,
        Finset.erase_insert_of_ne (Ne.symm hij)]
      ring

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARFockBasic.create_annihilate_same_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms create_annihilate_same_add

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARFockBasic.create_create_anticomm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms create_create_anticomm

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARFockBasic.annihilate_annihilate_anticomm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms annihilate_annihilate_anticomm

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCARFockBasic.create_annihilate_distinct_anticomm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms create_annihilate_distinct_anticomm

end PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
