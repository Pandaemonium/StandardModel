import Mathlib

/-!
# Focused finite-CAR adjointness target

This standalone package isolates the occupation-basis creation/annihilation
adjoint theorem from second quantization, covariance, and locality. The linear
order supplies only the Koszul sign convention.
-/

noncomputable section

open Finset
open scoped BigOperators

namespace CARAdjoint

variable {ι : Type*} [Fintype ι] [LinearOrder ι] [DecidableEq ι]

abbrev Fock (ι : Type*) := Finset ι -> Complex

def belowCount (i : ι) (S : Finset ι) : Nat :=
  (S.filter fun j => j < i).card

def opSign (i : ι) (S : Finset ι) : Complex :=
  (-1 : Complex) ^ belowCount i S

def create (i : ι) (psi : Fock ι) : Fock ι := fun S =>
  if i ∈ S then opSign i S * psi (S.erase i) else 0

def annihilate (i : ι) (psi : Fock ι) : Fock ι := fun S =>
  if i ∈ S then 0 else opSign i S * psi (insert i S)

def fockInner (psi phi : Fock ι) : Complex :=
  ∑ S : Finset ι, star (psi S) * phi S

theorem belowCount_insert_self (i : ι) (S : Finset ι) (hi : i ∉ S) :
    belowCount i (insert i S) = belowCount i S := by
  unfold belowCount
  rw [Finset.filter_insert, if_neg (lt_irrefl i)]

theorem opSign_insert_self (i : ι) (S : Finset ι) (hi : i ∉ S) :
    opSign i (insert i S) = opSign i S := by
  rw [opSign, opSign, belowCount_insert_self i S hi]

theorem fockInner_create_left (i : ι) (psi phi : Fock ι) :
    fockInner (create i psi) phi = fockInner psi (annihilate i phi) := by
  sorry

theorem fockInner_annihilate_left (i : ι) (psi phi : Fock ι) :
    fockInner (annihilate i psi) phi = fockInner psi (create i phi) := by
  sorry

end CARAdjoint
