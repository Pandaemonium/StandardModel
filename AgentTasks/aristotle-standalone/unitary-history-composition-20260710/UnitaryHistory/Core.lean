import Mathlib

open Matrix

namespace UnitaryHistory

noncomputable section

variable {n m : Type*} [Fintype n] [DecidableEq n]
  [Fintype m] [DecidableEq m]

def historyOperator (h : List (Matrix n n ℂ)) : Matrix n n ℂ := h.prod

def IsUnitary (U : Matrix n n ℂ) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

def parallelHistory :
    List (Matrix n n ℂ) -> List (Matrix m m ℂ) ->
      List (Matrix (n × m) (n × m) ℂ)
  | [], [] => []
  | A :: as, B :: bs => Matrix.kronecker A B :: parallelHistory as bs
  | _, _ => []

theorem isUnitary_one : IsUnitary (1 : Matrix n n ℂ) := by
  sorry

theorem isUnitary_mul {A B : Matrix n n ℂ}
    (hA : IsUnitary A) (hB : IsUnitary B) : IsUnitary (A * B) := by
  sorry

/-- A chronological history of unitary local gates has unitary total
evolution. -/
theorem historyOperator_unitary (h : List (Matrix n n ℂ))
    (hgates : ∀ U ∈ h, IsUnitary U) : IsUnitary (historyOperator h) := by
  sorry

theorem isUnitary_kronecker {A : Matrix n n ℂ} {B : Matrix m m ℂ}
    (hA : IsUnitary A) (hB : IsUnitary B) :
    IsUnitary (Matrix.kronecker A B) := by
  sorry

/-- Equal-length parallel histories of unitary gates have unitary total
evolution on the tensor-product index. -/
theorem parallel_history_operator_unitary
    (h1 : List (Matrix n n ℂ)) (h2 : List (Matrix m m ℂ))
    (hlen : h1.length = h2.length)
    (h1u : ∀ U ∈ h1, IsUnitary U) (h2u : ∀ U ∈ h2, IsUnitary U) :
    IsUnitary (historyOperator (parallelHistory h1 h2)) := by
  sorry

abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ
def sigmaX : M2 := !![0, 1; 1, 0]
def sigmaZ : M2 := !![1, 0; 0, -1]

theorem noncommuting_unitary_history_witness :
    IsUnitary sigmaX ∧ IsUnitary sigmaZ ∧
      historyOperator [sigmaX, sigmaZ] ≠ historyOperator [sigmaZ, sigmaX] ∧
      IsUnitary (historyOperator [sigmaX, sigmaZ]) := by
  sorry

end

end UnitaryHistory
