# claude-lambda-exponent-fork — the count-variance exponent is the sharp decidable Lambda fork: everpresent survives iff alpha = 1

## Context (blind to any repo; self-contained finite rational arithmetic, Mathlib only)

The cosmological-constant fork, in its sharpest decidable form (per an adversarial audit): the everpresent-
Lambda prediction Lambda_rms ~ 1/sqrt(N) is EQUIVALENT to the count-variance being extensive, Var(N) ~
N^alpha with alpha = 1 (Poisson). If the generating process is hyperuniform, Var(N) ~ N^alpha with
alpha < 1, and then Lambda_rms ~ N^{alpha/2 - 1} decays FASTER than N^{-1/2}, killing the 10^-122 number.
The fork is self-sharpening: alpha = 1 keeps the number but forfeits hyperuniform novelty; alpha < 1 gains
novelty but kills the number -- not both. Prove the finite EXPONENT arithmetic that makes this a decidable
kill (no logs, no reals beyond rational exponents -- work with the exponents themselves).

## The model (finite, rational exponents)

The Lambda_rms scaling exponent as a function of the count-variance exponent alpha:
`lamExp (alpha : Q) : Q := alpha / 2 - 1`  (since Lambda_rms = sqrt(Var N)/N = N^{alpha/2}/N = N^{alpha/2 - 1}).
Everpresent/Poisson value: `alpha = 1 -> lamExp = -1/2`. Work entirely with `lamExp` as a rational
function of `alpha` (the arithmetic of the exponent), NOT with `Real.rpow` -- this keeps it kernel-clean.

## Targets (rational; ring/norm_num/linarith; NO Real.rpow/log/sqrt, NO Complex, NO nlinarith deg>=3)

1. `lamExp_closed`: `lamExp alpha = alpha/2 - 1`, and `lamExp` is strictly increasing in `alpha`
   (`alpha1 < alpha2 -> lamExp alpha1 < lamExp alpha2`). By `ring`/`linarith`.
2. `everpresent_value`: `lamExp 1 = -1/2` (the Poisson/extensive everpresent exponent). `norm_num`.
3. `hyperuniform_faster` (payload): for `alpha < 1`, `lamExp alpha < -1/2` (hyperuniform decays strictly
   faster than the everpresent 1/sqrt(N), so the 10^-122 number is NOT reproduced); and for `alpha > 1`
   (super-extensive) `lamExp alpha > -1/2`. By `linarith`.
4. `fork_iff` (payload): `lamExp alpha = -1/2 <-> alpha = 1` -- the everpresent exponent is realized IFF
   the count is exactly extensive. So the fork is decidable on the single measurable exponent `alpha`.
5. `exponent_fork_verdict`: package -- the count-variance exponent `alpha` is the sharp decidable form of
   the Poisson-vs-hyperuniform fork: `alpha = 1 <-> lamExp = -1/2 <-> everpresent number survives`;
   `alpha < 1 -> lamExp < -1/2 -> the number fails` (and, by the imported Bombelli-Henson-Sorkin theorem,
   the process is then Lorentz-violating). The "not both" content: extensivity (`alpha=1`) keeps the
   number at the cost of no hyperuniform novelty; sub-extensivity (`alpha<1`) gains novelty at the cost
   of the number. Honest scope: this is the EXPONENT arithmetic (a decidable pre-registered kill-
   condition); it does not derive WHICH alpha nature realizes (stays a conjecture C), and the Lorentz
   tie is imported (BHS), not proved here.

MANDATORY non-degeneracy: explicit rationals -- `lamExp 1 = -1/2` (everpresent); `lamExp (1/2) = -3/4 <
-1/2` (hyperuniform witness, faster decay); `lamExp 2 = 0 > -1/2` (super-extensive); the strict
inequalities as `norm_num` facts. All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Rational arithmetic only (exponents as Q); ring/norm_num/linarith; NO
Real.rpow/log/sqrt, NO Complex, NO nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean
(namespace LambdaExponentFork) + ARISTOTLE_SUMMARY.md.
