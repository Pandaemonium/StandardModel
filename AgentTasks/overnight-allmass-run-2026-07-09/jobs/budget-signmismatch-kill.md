# claude-budget-signmismatch-kill — kernel-check the s4 kill-test: sum-of-squares budget != c*det P as a family (witness-fitted)

## Context (blind to any repo; self-contained finite rational algebra, Mathlib only)

An adversarial audit's sharpest s4 finding: the mass-budget claim `totalBudget = c*det P` cannot be a
family identity, because `totalBudget = tr(D^#D)` is a SUM OF SQUARES (positive/Frobenius form) while
`det P` is an INDEFINITE Gram determinant -- they depend with OPPOSITE SIGN on the off-diagonal data. So
`budget = c*det P` holds at best at a fitted witness point, not across a family. Formalize this as an
honest boundary theorem: exhibit that a single constant `c` matching at one configuration FAILS at a
perturbed one (the ratio drifts), confirming the identity is witness-level (M) not a law (C).

## The model (finite, rational; real symmetric 2x2 as the off-diagonal-data avatar)

A Hermitian-form avatar `P x = !![a, x; x, b]` with off-diagonal datum `x` (real). Two invariants:
`budget a b x := a^2 + b^2 + 2*x^2` (the Frobenius / sum-of-squares "totalBudget" avatar), and
`detP a b x := a*b - x^2` (the indefinite Gram determinant). Fix `a, b` and vary `x`.

## Targets (rational; ring/norm_num/linarith; NO Real, NO Complex, NO nlinarith deg>=3)

1. `budget_closed` / `detP_closed`: `budget a b x = a^2+b^2+2x^2` and `detP a b x = a*b - x^2` (defs;
   ring). And the OPPOSITE-SIGN dependence: `d/dx budget = 4x` (increases with |x|) while `d/dx detP =
   -2x` (decreases) -- state finitely as `budget a b x2 - budget a b x1 = 2*(x2^2 - x1^2)` (>=0 for
   |x2|>=|x1|) and `detP a b x2 - detP a b x1 = -(x2^2 - x1^2)` (<=0). By `ring`.
2. `witness_match`: at an explicit config there is a `c` with `budget = c * detP` -- e.g. `a=b=2, x=1`:
   `budget = 4+4+2 = 10`, `detP = 4-1 = 3`, so `c = 10/3` gives `budget = (10/3)*detP`. Explicit.
3. `family_fails` (payload): the SAME `c=10/3` does NOT work at a perturbed `x` -- e.g. `a=b=2, x=0`:
   `budget = 8`, `detP = 4`, and `(10/3)*4 = 40/3 != 8`. So `budget = (10/3)*detP` FAILS off the
   witness. Hence no single `c` gives a family identity. Explicit `norm_num`.
4. `signmismatch_verdict` (payload): package -- the sum-of-squares budget and the Gram determinant move
   with opposite sign in the off-diagonal datum (`budget` up, `detP` down as `|x|` grows), so
   `budget/detP` is not constant across the family; a `c` fitted at one witness fails at another
   (explicit witnesses). Therefore "budget answers to det P" is a witness-level equality (M at a point),
   not a family law (C). Honest scope: this CONFIRMS the audit's kill-test -- a finite negative/boundary
   result marking that the det-P-answer is not a proven identity, exactly matching the manuscript's
   M(witness)+C(family) grading.

MANDATORY non-degeneracy: the two explicit configs (`a=b=2,x=1` match with `c=10/3`; `a=b=2,x=0` fails
same `c`); the opposite-sign gap facts as `norm_num`/`ring`. All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Rational; ring/norm_num/linarith; NO Real.sqrt/cos/sin, NO Complex, NO
nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean (namespace BudgetSignMismatch)
+ ARISTOTLE_SUMMARY.md.
