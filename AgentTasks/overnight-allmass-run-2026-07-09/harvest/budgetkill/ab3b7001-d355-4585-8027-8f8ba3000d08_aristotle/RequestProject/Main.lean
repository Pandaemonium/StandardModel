import Mathlib

open scoped BigOperators
open scoped Nat
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

namespace BudgetSignMismatch

/-!
# Kernel-checked kill-test: sum-of-squares budget ≠ `c · det P` as a family

We model a real-symmetric `2×2` Hermitian-form avatar `P x = !![a, x; x, b]` whose
off-diagonal datum is `x`.  Two invariants are attached to it:

* `budget a b x = a^2 + b^2 + 2*x^2`, the Frobenius / sum-of-squares "total budget"
  avatar (a positive/definite quadratic form in the data), and
* `detP a b x = a*b - x^2`, the indefinite Gram determinant.

The audit claim under test is that `totalBudget = c · det P` as a *family* identity.
We formalize the honest boundary result: `budget` and `detP` depend with **opposite
sign** on `x`, so a constant `c` fitted at one witness fails at a perturbed one; hence
the equality is witness-level (M at a point), not a family law (C).

Everything is over `ℚ`; proofs use `ring`/`norm_num`/`linarith` only.
-/

/-- Frobenius / sum-of-squares "total budget" avatar (a positive quadratic form). -/
def budget (a b x : ℚ) : ℚ := a^2 + b^2 + 2*x^2

/-- Indefinite Gram determinant of `!![a, x; x, b]`. -/
def detP (a b x : ℚ) : ℚ := a*b - x^2

/-! ## 1. Closed forms and opposite-sign dependence on the off-diagonal datum -/

/-- Closed form of `budget` (definitional; by `ring`). -/
theorem budget_closed (a b x : ℚ) : budget a b x = a^2 + b^2 + 2*x^2 := by
  unfold budget; ring

/-- Closed form of `detP` (definitional; by `ring`). -/
theorem detP_closed (a b x : ℚ) : detP a b x = a*b - x^2 := by
  unfold detP; ring

/-- The budget's dependence on `x`: `budget` increases with `x^2`
    (finite avatar of `d/dx budget = 4x`). -/
theorem budget_diff (a b x1 x2 : ℚ) :
    budget a b x2 - budget a b x1 = 2*(x2^2 - x1^2) := by
  unfold budget; ring

/-- The determinant's dependence on `x`: `detP` decreases with `x^2`
    (finite avatar of `d/dx detP = -2x`), the **opposite** sign of the budget. -/
theorem detP_diff (a b x1 x2 : ℚ) :
    detP a b x2 - detP a b x1 = -(x2^2 - x1^2) := by
  unfold detP; ring

/-- Opposite-sign monotonicity, packaged: when `|x2| ≥ |x1|` (i.e. `x1^2 ≤ x2^2`),
    the budget goes up while the determinant goes down. -/
theorem opposite_sign (a b x1 x2 : ℚ) (h : x1^2 ≤ x2^2) :
    0 ≤ budget a b x2 - budget a b x1 ∧ detP a b x2 - detP a b x1 ≤ 0 := by
  constructor
  · rw [budget_diff]; linarith
  · rw [detP_diff]; linarith

/-! ## 2. Witness match: a single `c` works at one configuration -/

/-- At `a = b = 2, x = 1`: `budget = 10`, `detP = 3`, so `c = 10/3` matches. -/
theorem witness_match : budget 2 2 1 = (10/3 : ℚ) * detP 2 2 1 := by
  unfold budget detP; norm_num

/-! ## 3. Family failure: the SAME `c = 10/3` fails at a perturbed `x` -/

/-- At `a = b = 2, x = 0`: `budget = 8` but `(10/3)*detP = 40/3 ≠ 8`.  So the
    witness-fitted constant `c = 10/3` does **not** give the identity here. -/
theorem family_fails : budget 2 2 0 ≠ (10/3 : ℚ) * detP 2 2 0 := by
  unfold budget detP; norm_num

/-! ## 4. Verdict: no single `c` is a family law -/

/-- **Payload.**  There is no constant `c` making `budget = c · detP` hold across the
    family: the two explicit configurations `(2,2,1)` and `(2,2,0)` would force
    incompatible values of `c`.  Together with the opposite-sign dependence this
    confirms the kill-test — `budget = c·detP` is a witness-level equality (M at a
    point), not a family identity (C). -/
theorem signmismatch_verdict :
    -- opposite-sign dependence on the off-diagonal datum
    (∀ a b x1 x2 : ℚ, x1^2 ≤ x2^2 →
        0 ≤ budget a b x2 - budget a b x1 ∧ detP a b x2 - detP a b x1 ≤ 0) ∧
    -- a witness where c = 10/3 matches
    budget 2 2 1 = (10/3 : ℚ) * detP 2 2 1 ∧
    -- the same c fails at a perturbed configuration
    budget 2 2 0 ≠ (10/3 : ℚ) * detP 2 2 0 ∧
    -- hence NO single constant c works for both configs: not a family law
    ¬ ∃ c : ℚ, budget 2 2 1 = c * detP 2 2 1 ∧ budget 2 2 0 = c * detP 2 2 0 := by
  refine ⟨opposite_sign, witness_match, family_fails, ?_⟩
  rintro ⟨c, h1, h0⟩
  -- h1 : 10 = c * 3, h0 : 8 = c * 4, incompatible
  unfold budget detP at h1 h0
  norm_num at h1 h0
  -- from h1: c = 10/3; from h0: c = 2; contradiction
  linarith

/-! ## Axiom footprint (kernel-checked; must be exactly propext, Classical.choice, Quot.sound) -/

/-- info: 'BudgetSignMismatch.budget_closed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms budget_closed

/-- info: 'BudgetSignMismatch.detP_closed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms detP_closed

/-- info: 'BudgetSignMismatch.budget_diff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms budget_diff

/-- info: 'BudgetSignMismatch.detP_diff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms detP_diff

/-- info: 'BudgetSignMismatch.opposite_sign' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms opposite_sign

/-- info: 'BudgetSignMismatch.witness_match' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_match

/-- info: 'BudgetSignMismatch.family_fails' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms family_fails

/-- info: 'BudgetSignMismatch.signmismatch_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms signmismatch_verdict

end BudgetSignMismatch
