import Mathlib
import PhysicsSM.Draft.NullEdge.WAYTurnNoGo

/-!
# Constructive finite WAY charge-exchange witness

`WAYTurnNoGo` proves that a system chirality flip tensored with an identity
ancilla cannot conserve additive charge. This module supplies the constructive
complement: a nontrivial swap-like system-ancilla gate is unitary, conserves
total binary charge, and maps the basis state with system charge zero and
ancilla charge one to the state with those charges exchanged.

This is a basis-transition reservoir witness. It does not implement a universal
coherent system-only chirality flip, return the ancilla unchanged, derive a weak
charge representation, or determine a Higgs scalar mass. In particular, it
supports “a nontrivial charge reservoir can mediate a turn,” not “the Higgs
mechanism has been derived.”

Provenance: clean-room finite theorem shape informed by the WAY/resource theory
literature (Ahmadi-Jennings-Rudolph, arXiv:1209.0921;
Kuramochi-Tajima, arXiv:2208.13494) and Mathlib's Kronecker/permutation APIs.
Proofs were completed by Aristotle project
`78cc049a-8896-4a8d-a322-dbb8b480a2de` and locally rechecked under the pinned
toolchain. PhysLean was searched first and had no directly matching WAY API.
-/

open Matrix Kronecker

namespace PhysicsSM.Draft.NullEdge.WAYChargeExchangeWitness

/-- Binary charge projector with charges zero and one. -/
noncomputable def charge : Matrix (Fin 2) (Fin 2) ℂ := !![0, 0; 0, 1]

/-- System chirality flip. -/
noncomputable def flip : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- The swap gate on a system qubit and an ancilla qubit. -/
noncomputable def swapGate :
    Matrix (Fin 2 × Fin 2) (Fin 2 × Fin 2) ℂ :=
  fun x y => if x.1 = y.2 ∧ x.2 = y.1 then 1 else 0

/-- Total additive binary charge. -/
noncomputable def totalCharge :
    Matrix (Fin 2 × Fin 2) (Fin 2 × Fin 2) ℂ :=
  (charge ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)) +
    ((1 : Matrix (Fin 2) (Fin 2) ℂ) ⊗ₖ charge)

/-- Standard system-ancilla basis vector. -/
noncomputable def basis (i a : Fin 2) : Fin 2 × Fin 2 → ℂ :=
  fun x => if x = (i, a) then 1 else 0

/-- The swap gate is unitary. -/
theorem swapGate_unitary :
    swapGate.conjTranspose * swapGate = 1 := by
  ext ⟨i, j⟩ ⟨k, l⟩
  fin_cases i <;> fin_cases j <;> fin_cases k <;> fin_cases l <;>
    simp [swapGate, Matrix.conjTranspose, Matrix.mul_apply, Fintype.sum_prod_type,
      Fin.sum_univ_two, Prod.ext_iff]

/-- The swap gate exactly conserves total additive charge. -/
theorem swapGate_conserves_total_charge :
    swapGate * totalCharge = totalCharge * swapGate := by
  ext ⟨i, j⟩ ⟨k, l⟩
  fin_cases i <;> fin_cases j <;> fin_cases k <;> fin_cases l <;>
    simp [swapGate, totalCharge, charge, Matrix.mul_apply, Fintype.sum_prod_type,
      Fin.sum_univ_two, Matrix.one_apply, Matrix.add_apply, Matrix.kroneckerMap_apply]

/-- The ancilla supplies one unit of charge to flip the system basis state. -/
theorem swapGate_exchanges_basis_charge :
    swapGate.mulVec (basis 0 1) = basis 1 0 := by
  ext ⟨k, l⟩
  fin_cases k <;> fin_cases l <;>
    simp [swapGate, basis, Matrix.mulVec, dotProduct, Fintype.sum_prod_type,
      Fin.sum_univ_two, Prod.ext_iff]

/-- The constructive gate is not the forbidden system flip with a trivial
ancilla. -/
theorem swapGate_ne_trivial_flip :
    swapGate ≠ flip ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  intro h
  have hentry := congrFun (congrFun h (0, 0)) (1, 0)
  simp [swapGate, flip, Matrix.kroneckerMap_apply] at hentry

/-- The trivial-ancilla system flip fails the same total-charge conservation
test that the swap gate passes. -/
theorem trivial_flip_fails_total_charge :
    (flip ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)) * totalCharge ≠
      totalCharge * (flip ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)) := by
  intro h
  have hentry := congrFun (congrFun h (0, 0)) (1, 0)
  simp [flip, totalCharge, charge, Matrix.mul_apply, Fintype.sum_prod_type,
    Fin.sum_univ_two, Matrix.one_apply, Matrix.add_apply,
    Matrix.kroneckerMap_apply] at hentry

/-- A nontrivial unitary exchange gate conserves total charge and performs the
basis turn, while the trivial implementation fails. -/
theorem constructive_charge_reservoir_witness :
    swapGate.conjTranspose * swapGate = 1 ∧
      swapGate * totalCharge = totalCharge * swapGate ∧
      swapGate.mulVec (basis 0 1) = basis 1 0 ∧
      swapGate ≠ flip ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ) ∧
      (flip ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)) * totalCharge ≠
        totalCharge * (flip ⊗ₖ (1 : Matrix (Fin 2) (Fin 2) ℂ)) :=
  ⟨swapGate_unitary, swapGate_conserves_total_charge,
    swapGate_exchanges_basis_charge, swapGate_ne_trivial_flip,
    trivial_flip_fails_total_charge⟩

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.WAYChargeExchangeWitness.constructive_charge_reservoir_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms constructive_charge_reservoir_witness

end PhysicsSM.Draft.NullEdge.WAYChargeExchangeWitness
