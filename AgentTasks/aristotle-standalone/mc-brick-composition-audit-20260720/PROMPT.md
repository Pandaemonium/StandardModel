# Adversarial audit: do the MC support bricks actually compose?

Mathlib-only adversarial audit + witnesses, scoped L2 operator norm. A set of
walk-agnostic "support bricks" was produced for a continuum-reduction ladder.
Before they are integrated, check they COMPOSE and are not individually vacuous.

The bricks (statements, restated abstractly):
- **B1 (coin core)**: `M*M = (m^2:C).1`, `0<=m`, `(m=0 -> M=0)` =>
  `exp((-a:C).(I.M)) = cos(am).1 - (I sin(am)/m).M`.
- **B2 (block/conjugation lift)**: two 2-component estimates `<= c eps^2` =>
  the 4-component block-diagonal, and its unitary conjugate, obey `<= c eps^2`.
- **B3 (tail)**: `U,V` unitary => `||U-V|| <= 2`, and the tail L2 error is `<= 2||f||`.
- **B4 (componentwise L2)**: `||f||_2^2 = sum_i ||f_i||_2^2`; multiplier transport.
- **B5 (many-step skeleton)**: unitary `W eps, E eps`, `||W eps - E eps|| <= c eps^2`,
  `E` a one-parameter group => `||(W (t/n))^n - E t|| <= c t^2 / n`.

Audit questions - answer each with a proof or an explicit counterexample:
1. **Composability**: can B1+B2 actually FEED B5? Specifically, does the object
   produced by B2 (a conjugated block-diagonal difference bound) have the form B5
   requires (both families unitary, `E` a group)? Identify any hypothesis MISMATCH -
   e.g. B5 needs `W eps` unitary, but a block-diagonal of two unitaries is unitary
   only if each block is; and B5 needs the exact group law for `E`, which the
   conjugated exponential satisfies only if conjugation is by a FIXED unitary
   (independent of eps). State these as explicit side conditions.
2. **Non-vacuity**: exhibit a concrete nontrivial instance satisfying ALL of
   B1,B2,B5 simultaneously (nonzero `M`, nonzero `c`, `n >= 2`), so the composite is
   not vacuous.
3. **Hidden constant drift**: verify the composite constant is still `c` (not
   `2c`, `4c`, ...) after B2 then B5; prove the composite bound explicitly.
4. **A trap**: is B5's conclusion still true if `E` is NOT a one-parameter group?
   Give a counterexample showing the group law is load-bearing.
Deliver verdicts + Lean witnesses. No new axioms/native_decide; standard axioms.
