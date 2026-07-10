import Mathlib

open Matrix

namespace HistoryOperator

noncomputable section

variable {n m : Type*} [Fintype n] [DecidableEq n]
  [Fintype m] [DecidableEq m]

def historyOperator (h : List (Matrix n n ℂ)) : Matrix n n ℂ := h.prod

def daggerHistory (h : List (Matrix n n ℂ)) : List (Matrix n n ℂ) :=
  (h.map Matrix.conjTranspose).reverse

def parallelHistory :
    List (Matrix n n ℂ) → List (Matrix m m ℂ) →
      List (Matrix (n × m) (n × m) ℂ)
  | [], [] => []
  | A :: as, B :: bs => Matrix.kronecker A B :: parallelHistory as bs
  | _, _ => []

/-- Sequential gluing is operator multiplication. -/
theorem historyOperator_append (h1 h2 : List (Matrix n n ℂ)) :
    historyOperator (h1 ++ h2) = historyOperator h1 * historyOperator h2 := by
  sorry

/-- Orientation reversal together with gate adjoint is the operator adjoint. -/
theorem historyOperator_dagger (h : List (Matrix n n ℂ)) :
    historyOperator (daggerHistory h) = (historyOperator h)ᴴ := by
  sorry

/-- Synchronized disjoint histories compose stepwise by Kronecker product and
their total operator is the Kronecker product of the two totals. -/
theorem historyOperator_parallel (h1 : List (Matrix n n ℂ))
    (h2 : List (Matrix m m ℂ)) (hlen : h1.length = h2.length) :
    historyOperator (parallelHistory h1 h2) =
      Matrix.kronecker (historyOperator h1) (historyOperator h2) := by
  sorry

abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ

def sigmaX : M2 := !![0, 1; 1, 0]
def sigmaZ : M2 := !![1, 0; 0, -1]

/-- Nondegenerate fixture: order matters locally, dagger reverses it, and a
one-step parallel history produces a nonzero tensor operator. -/
theorem operator_composition_witness :
    historyOperator [sigmaX, sigmaZ] ≠ historyOperator [sigmaZ, sigmaX] ∧
      historyOperator (daggerHistory [sigmaX, sigmaZ]) =
        (historyOperator [sigmaX, sigmaZ])ᴴ ∧
      historyOperator (parallelHistory [sigmaX] [sigmaZ]) =
        Matrix.kronecker sigmaX sigmaZ ∧
      historyOperator (parallelHistory [sigmaX] [sigmaZ]) ≠ 0 := by
  sorry

end

end HistoryOperator
