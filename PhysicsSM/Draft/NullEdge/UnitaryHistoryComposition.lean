import PhysicsSM.Draft.NullEdge.HistoryOperatorMonoidalDagger

/-!
# Unitarity under sequential and parallel history composition

A chronological history of two-sided unitary complex gates has a unitary total
operator. Equal-length parallel histories remain unitary under the Kronecker
composition used by `HistoryOperatorMonoidalDagger`. A noncommuting Pauli
fixture excludes a commutative or identity-only collapse.

This closes the unitarity composition law for supplied local gates. It does not
derive those gates from primitive null data, prove the checkerboard transfer is
unitary in a physical parameter regime, or select a Krein-positive sector.

Provenance: proof completed by Aristotle project
`23a16501-66f5-4123-8e34-ac4909c555c6` and ported to the landed operator-history
API.
-/

open Matrix

namespace PhysicsSM.Draft.NullEdge.UnitaryHistoryComposition

open PhysicsSM.Draft.NullEdge.HistoryOperatorMonoidalDagger

noncomputable section

variable {n m : Type*} [Fintype n] [DecidableEq n]
  [Fintype m] [DecidableEq m]

def IsUnitary (U : Matrix n n ℂ) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

theorem isUnitary_one : IsUnitary (1 : Matrix n n ℂ) := by
  constructor <;> aesop

theorem isUnitary_mul {A B : Matrix n n ℂ}
    (hA : IsUnitary A) (hB : IsUnitary B) : IsUnitary (A * B) := by
  constructor <;> simp_all +decide [IsUnitary]
  · simp +decide only [mul_assoc]
    simp +decide [← mul_assoc, hA.1, hB.1]
  · grind +qlia

/-- A chronological history of unitary local gates has unitary total
evolution. -/
theorem historyOperator_unitary (h : List (Matrix n n ℂ))
    (hgates : ∀ U ∈ h, IsUnitary U) : IsUnitary (historyOperator h) := by
  induction h with
  | nil => exact isUnitary_one
  | cons U t ih =>
    unfold historyOperator
    rw [List.prod_cons]
    exact isUnitary_mul (hgates U (by simp))
      (ih (fun V hV => hgates V (by simp [hV])))

theorem isUnitary_kronecker {A : Matrix n n ℂ} {B : Matrix m m ℂ}
    (hA : IsUnitary A) (hB : IsUnitary B) :
    IsUnitary (Matrix.kronecker A B) := by
  unfold IsUnitary Matrix.kronecker
  rw [Matrix.conjTranspose_kronecker]
  refine ⟨?_, ?_⟩
  · rw [← Matrix.mul_kronecker_mul, hA.1, hB.1,
      Matrix.one_kronecker_one]
  · rw [← Matrix.mul_kronecker_mul, hA.2, hB.2,
      Matrix.one_kronecker_one]

/-- Equal-length parallel histories of unitary gates have unitary total
evolution on the tensor-product index. -/
theorem parallel_history_operator_unitary
    (h1 : List (Matrix n n ℂ)) (h2 : List (Matrix m m ℂ))
    (hlen : h1.length = h2.length)
    (h1u : ∀ U ∈ h1, IsUnitary U) (h2u : ∀ U ∈ h2, IsUnitary U) :
    IsUnitary (historyOperator (parallelHistory h1 h2)) := by
  induction h1 generalizing h2 with
  | nil =>
    obtain _ | ⟨B, bs⟩ := h2
    · exact isUnitary_one
    · simp at hlen
  | cons A as ih =>
    obtain _ | ⟨B, bs⟩ := h2
    · simp at hlen
    · have hkron : IsUnitary (Matrix.kronecker A B) :=
        isUnitary_kronecker (h1u A (by simp)) (h2u B (by simp))
      have htail : IsUnitary (historyOperator (parallelHistory as bs)) :=
        ih bs (by simpa using hlen)
          (fun U hU => h1u U (by simp [hU]))
          (fun U hU => h2u U (by simp [hU]))
      change IsUnitary
        (historyOperator (Matrix.kronecker A B :: parallelHistory as bs))
      unfold historyOperator
      rw [List.prod_cons]
      exact isUnitary_mul hkron htail

/-- Repeating one unitary gate gives a unitary uniform history. -/
theorem replicated_history_operator_unitary (U : Matrix n n ℂ) (steps : ℕ)
    (hU : IsUnitary U) :
    IsUnitary (historyOperator (List.replicate steps U)) := by
  apply historyOperator_unitary
  intro V hV
  have hVU : V = U := List.eq_of_mem_replicate hV
  simpa [hVU] using hU

/-- Noncommuting unitary local gates produce a nontrivial unitary history. -/
theorem noncommuting_unitary_history_witness :
    IsUnitary sigmaX ∧ IsUnitary sigmaZ ∧
      historyOperator [sigmaX, sigmaZ] ≠
        historyOperator [sigmaZ, sigmaX] ∧
      IsUnitary (historyOperator [sigmaX, sigmaZ]) := by
  unfold historyOperator IsUnitary
  simp_all +decide
  norm_num [← Matrix.mul_assoc, sigmaX, sigmaZ]
  norm_num [← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply,
    Matrix.vecMul]
  norm_num [vecHead, vecTail]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryHistoryComposition.historyOperator_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms historyOperator_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryHistoryComposition.parallel_history_operator_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parallel_history_operator_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryHistoryComposition.noncommuting_unitary_history_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms noncommuting_unitary_history_witness

end


end PhysicsSM.Draft.NullEdge.UnitaryHistoryComposition
