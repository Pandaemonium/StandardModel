import Mathlib

/-!
# Operator-valued monoidal dagger histories

Finite histories of complex matrices compose sequentially by multiplication,
reverse under gatewise conjugate transpose, and compose in parallel by the
Kronecker product. A Pauli fixture proves that local chronological order matters
and that parallel composition is nonzero.

This is an operator-valued composition layer for supplied gates. It does not
derive the gate assignment from primitive histories, choose a physical inner
product, impose unitarity, or derive a Born rule.

Provenance: target selected by the 2026-07-10 full-theory composition audit;
proof returned by Aristotle project `d2d6f901-f99a-4ae0-a225-fdccc0c58b74`
and locally reviewed against Mathlib's list-product and Kronecker conventions.
-/

open Matrix

namespace PhysicsSM.Draft.NullEdge.HistoryOperatorMonoidalDagger

noncomputable section

variable {n m : Type*} [Fintype n] [DecidableEq n]
  [Fintype m] [DecidableEq m]

def historyOperator (h : List (Matrix n n ℂ)) : Matrix n n ℂ := h.prod

def daggerHistory (h : List (Matrix n n ℂ)) : List (Matrix n n ℂ) :=
  (h.map Matrix.conjTranspose).reverse

def parallelHistory :
    List (Matrix n n ℂ) -> List (Matrix m m ℂ) ->
      List (Matrix (n × m) (n × m) ℂ)
  | [], [] => []
  | A :: as, B :: bs => Matrix.kronecker A B :: parallelHistory as bs
  | _, _ => []

/-- Sequential gluing is operator multiplication. -/
theorem historyOperator_append (h1 h2 : List (Matrix n n ℂ)) :
    historyOperator (h1 ++ h2) = historyOperator h1 * historyOperator h2 := by
  simp [historyOperator, List.prod_append]

/-- Orientation reversal together with gate adjoint is the operator adjoint. -/
theorem historyOperator_dagger (h : List (Matrix n n ℂ)) :
    historyOperator (daggerHistory h) = (historyOperator h)ᴴ := by
  simp only [historyOperator, daggerHistory, Matrix.conjTranspose_list_prod]

/-- Synchronized disjoint histories compose stepwise by Kronecker product and
their total operator is the Kronecker product of the two totals. -/
theorem historyOperator_parallel (h1 : List (Matrix n n ℂ))
    (h2 : List (Matrix m m ℂ)) (hlen : h1.length = h2.length) :
    historyOperator (parallelHistory h1 h2) =
      Matrix.kronecker (historyOperator h1) (historyOperator h2) := by
  induction h1 generalizing h2 with
  | nil =>
    cases h2 with
    | nil => simp [parallelHistory, historyOperator]
    | cons B bs => simp at hlen
  | cons A as ih =>
    cases h2 with
    | nil => simp at hlen
    | cons B bs =>
      have hlen' : as.length = bs.length := by simpa using hlen
      simp only [parallelHistory, historyOperator, List.prod_cons] at ih ⊢
      rw [ih bs hlen']
      exact (mul_kronecker_mul A as.prod B bs.prod).symm

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
  refine ⟨?_, historyOperator_dagger [sigmaX, sigmaZ], ?_, ?_⟩
  · simp only [historyOperator, List.prod_cons, List.prod_nil, mul_one]
    intro h
    have h01 := congrFun (congrFun h 0) 1
    norm_num [sigmaX, sigmaZ, Matrix.mul_apply, Fin.sum_univ_two] at h01
  · have hpar := historyOperator_parallel [sigmaX] [sigmaZ] rfl
    simpa [historyOperator] using hpar
  · have hpar := historyOperator_parallel [sigmaX] [sigmaZ] rfl
    rw [show historyOperator (parallelHistory [sigmaX] [sigmaZ]) =
          Matrix.kronecker sigmaX sigmaZ by
        simpa [historyOperator] using hpar]
    intro h
    have h00 := congrFun (congrFun h (0, 0)) (1, 0)
    simp [Matrix.kronecker, Matrix.kroneckerMap, sigmaX, sigmaZ] at h00

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HistoryOperatorMonoidalDagger.historyOperator_append' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms historyOperator_append

/-- info: 'PhysicsSM.Draft.NullEdge.HistoryOperatorMonoidalDagger.historyOperator_dagger' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms historyOperator_dagger

/-- info: 'PhysicsSM.Draft.NullEdge.HistoryOperatorMonoidalDagger.historyOperator_parallel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms historyOperator_parallel

/-- info: 'PhysicsSM.Draft.NullEdge.HistoryOperatorMonoidalDagger.operator_composition_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms operator_composition_witness

end

end PhysicsSM.Draft.NullEdge.HistoryOperatorMonoidalDagger
