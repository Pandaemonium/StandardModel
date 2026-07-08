/-
# S1-CC: the `6×6` witness is an instance of the general reduction

This file closes the loop: it re-derives the witness balance
`S1CCPhysicalSectorWitness.balanced_on_physical_sector` (the `(2,2,·)` count that
was proved by hand on the explicit `6×6` carrier) as a *direct instance* of the
coordinate-free general theorem `S1CCGeneralReduction.compression_balanced`.

The only witness-specific inputs are:
* the closure grading `b = σz ⊗ 1` is a diagonal `±1` grading (`bg_eq_diagonal`);
* it anticonjugates the full-carrier closure form (`bg_anticonj`, already in the
  witness file).

Everything else — the descent to `V'/N`, the compression to the coset
representatives `r`, and the balance — is supplied by the general engine, with no
appeal to the specific `Q_G = c₁ ⊗ diag(0,0,1)`.  This is the concrete
demonstration that the witness result is *not* special to its coordinate
alignment.

## Provenance

All-mass solo run 2026-07-08 [orig].  Proof from Aristotle (standalone package
`AgentTasks/aristotle-standalone/allmass-strategy-s1ccgen-20260708`), reviewed for
semantic alignment and re-based onto the project's real `S1CCPhysicalSectorWitness`
and `S1CCGeneralReduction`.  `witness_balanced_via_general` reproduces the count of
`B_isHermitian` (the witness compression `B = JQc.submatrix r r`) as an instance of
`compression_balanced`; the two hermiticity proofs coincide by Prop
proof-irrelevance.
-/

import PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness
import PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction

namespace PhysicsSM.Draft.NullEdge.GateYM.S1CCWitnessAsInstance

open Matrix
open PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness
open PhysicsSM.Draft.NullEdge.GateYM.S1CCGeneralReduction

/-- The closure grading of the witness, as a diagonal `±1` function on the
carrier `Fin 2 × Fin 3`: `+1` on the `σz = +1` Clifford sheet, `-1` on the
`σz = -1` sheet. -/
def dWitness : Fin 2 × Fin 3 → ℂ := fun p => if p.1 = 0 then 1 else -1

/-- `dWitness` is a `±1` grading. -/
theorem dWitness_grading (p : Fin 2 × Fin 3) : dWitness p = 1 ∨ dWitness p = -1 := by
  unfold dWitness; split <;> simp

/-- The witness bivector grading `b = σz ⊗ 1` is exactly `diagonal dWitness`. -/
theorem bg_eq_diagonal : bg = diagonal dWitness := by
  unfold bg dWitness
  ext ⟨a, i⟩ ⟨b, j⟩
  fin_cases a <;> fin_cases i <;> fin_cases b <;> fin_cases j <;>
    simp [kroneckerMap, sz, diagonal, Matrix.one_apply]

/-- **Witness balance, re-derived from the general theorem.** The `(2,2,·)`
count on the physical sector of the explicit `6×6` witness is an instance of
`compression_balanced`, using only the diagonal grading `dWitness` and the
full-carrier anticonjugation `bg_anticonj` — never the specific `Q_G`. -/
theorem witness_balanced_via_general :
    (Finset.univ.filter (fun i => 0 < B_isHermitian.eigenvalues i)).card =
      (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i < 0)).card := by
  have hanti : diagonal dWitness * JQc * diagonal dWitness = -JQc := by
    rw [← bg_eq_diagonal]; exact bg_anticonj
  exact compression_balanced JQc JQc_hermitian dWitness dWitness_grading hanti r

end PhysicsSM.Draft.NullEdge.GateYM.S1CCWitnessAsInstance

/-! ## Build-enforced axiom pin -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCWitnessAsInstance.witness_balanced_via_general' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCWitnessAsInstance.witness_balanced_via_general
