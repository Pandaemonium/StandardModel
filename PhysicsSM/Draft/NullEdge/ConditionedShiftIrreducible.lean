import Mathlib

/-!
# A fixed coin cannot reproduce a projector-conditioned shift family

This is the exact algebraic fork in the anomalous-Floquet 3+1 route. A scalar
spin-blind shift gives the same phase to every internal sector. Multiplying it
by one momentum-independent coin cannot reproduce a family that phases one
proper projector sector while holding its complement fixed, already when the
two phases `+1` and `-1` are compared.

The theorem is deliberately scoped: it does not exclude multi-step circuits,
momentum-dependent coins, extra registers, or other primitive alphabets.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ConditionedShiftIrreducible

open Matrix Complex

def conditionedStep {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (P : Matrix n n Complex) : Matrix n n Complex :=
  z • P + (1 - P)

def spinBlindThenCoin {n : Type*} [Fintype n] [DecidableEq n]
    (z : Complex) (C : Matrix n n Complex) : Matrix n n Complex := z • C

/-
A proper selected sector cannot be reproduced at both signs by one fixed
coin following a spin-blind scalar shift.
-/
theorem no_fixed_coin_factorization {n : Type*} [Fintype n] [DecidableEq n]
    (P : Matrix n n Complex) (hP : P ≠ 1) :
    ¬ ∃ C : Matrix n n Complex,
      spinBlindThenCoin 1 C = conditionedStep 1 P ∧
      spinBlindThenCoin (-1) C = conditionedStep (-1) P := by
  contrapose! hP; simp_all +decide [ spinBlindThenCoin, conditionedStep ] ;
  exact Matrix.ext fun i j => by have := congr_fun ( congr_fun hP i ) j; norm_num at *; linear_combination' this / 2;

def selected : Matrix (Fin 2) (Fin 2) Complex := !![1, 0; 0, 0]

theorem selected_ne_one : selected ≠ 1 := by
  unfold selected;
  exact ne_of_apply_ne ( fun m => m 1 1 ) ( by norm_num )

/-- Explicit two-channel nonvacuity witness. -/
theorem selected_no_fixed_coin :
    ¬ ∃ C : Matrix (Fin 2) (Fin 2) Complex,
      spinBlindThenCoin 1 C = conditionedStep 1 selected ∧
      spinBlindThenCoin (-1) C = conditionedStep (-1) selected := by
  convert no_fixed_coin_factorization selected selected_ne_one

/-! ### Build-enforced standard-axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ConditionedShiftIrreducible.no_fixed_coin_factorization' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_fixed_coin_factorization

/-- info: 'PhysicsSM.Draft.NullEdge.ConditionedShiftIrreducible.selected_no_fixed_coin' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms selected_no_fixed_coin

end PhysicsSM.Draft.NullEdge.ConditionedShiftIrreducible
