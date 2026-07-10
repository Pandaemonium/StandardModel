# Summary of changes for run ab3b7001-d355-4585-8027-8f8ba3000d08
Delivered `RequestProject/Main.lean` (namespace `BudgetSignMismatch`) plus `ARISTOTLE_SUMMARY.md`, formalizing the s4 sign-mismatch kill-test over ℚ.

Model: real-symmetric 2×2 avatar `P x = !![a,x;x,b]` with `budget a b x = a^2+b^2+2*x^2` (sum-of-squares total-budget avatar) and `detP a b x = a*b - x^2` (indefinite Gram determinant).

Theorems proved (all `ring`/`norm_num`/`linarith`; no Real, no Complex, no `nlinarith`):
1. `budget_closed`, `detP_closed` (closed forms); `budget_diff` = `2*(x2^2-x1^2)` (up) and `detP_diff` = `-(x2^2-x1^2)` (down) showing opposite-sign dependence on the off-diagonal datum; `opposite_sign` packages the monotonicity (budget-gap ≥ 0, det-gap ≤ 0 when `x1^2 ≤ x2^2`).
2. `witness_match`: at `a=b=2, x=1`, `budget = (10/3)·detP` (10 = (10/3)·3).
3. `family_fails`: the same `c=10/3` fails at `a=b=2, x=0` (8 ≠ 40/3).
4. `signmismatch_verdict` (payload): bundles the opposite-sign dependence, witness match, family failure, and proves `¬ ∃ c` matching both configs — so no single constant is a family law. The det-P-answer is therefore witness-level (M at a point), not a proven family identity (C).

Verification: `RequestProject.Main` builds in ~18s (well under 3 min) with no `sorry`/`admit`/`native_decide`/new axiom. Each of the 8 headline theorems carries an in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>`, all confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. Work committed and pushed.

# BudgetSignMismatch — kernel-checked s4 kill-test

**File:** `RequestProject/Main.lean` (namespace `BudgetSignMismatch`).

Honest boundary result confirming the audit's sign-mismatch kill-test: the
sum-of-squares "total budget" cannot equal `c · det P` as a *family* identity,
because the two invariants depend with **opposite sign** on the off-diagonal datum.

## Model (finite, rational)

Real-symmetric `2×2` avatar `P x = !![a, x; x, b]` over `ℚ`:

- `budget a b x := a^2 + b^2 + 2*x^2` — Frobenius / sum-of-squares total-budget avatar (positive form).
- `detP a b x := a*b - x^2` — indefinite Gram determinant.

## Results (all `ring`/`norm_num`/`linarith`; no `Real`, no `Complex`, no `nlinarith`)

1. **Closed forms & opposite-sign dependence**
   - `budget_closed`, `detP_closed`: the definitional closed forms.
   - `budget_diff`: `budget a b x2 - budget a b x1 = 2*(x2^2 - x1^2)` (up with `|x|`).
   - `detP_diff`: `detP a b x2 - detP a b x1 = -(x2^2 - x1^2)` (down with `|x|`, opposite sign).
   - `opposite_sign`: for `x1^2 ≤ x2^2`, budget-gap `≥ 0` and det-gap `≤ 0`.
2. **`witness_match`**: at `a=b=2, x=1`, `budget = 10`, `detP = 3`, so `c = 10/3` matches: `budget = (10/3)·detP`.
3. **`family_fails`**: the same `c = 10/3` fails at `a=b=2, x=0` (`budget = 8`, `(10/3)·detP = 40/3 ≠ 8`).
4. **`signmismatch_verdict`** (payload): packages the opposite-sign dependence, the witness match, the
   family failure, and proves `¬ ∃ c`, `budget = c·detP` at both configs — so no single constant is a
   family law. This is a witness-level equality (M at a point), not a family identity (C).

## Verification

- Builds under 3 min; `RequestProject.Main` compiles with no `sorry`/`admit`/`native_decide`/new axiom.
- Each headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms <thm>`; the axiom
  footprint is exactly `[propext, Classical.choice, Quot.sound]`.
