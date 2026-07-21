# Lemma job: abstract two-factor eps^2 product bridge (MC3 shape)

Mathlib-only, ABSTRACT (no project files), with the scoped L2 operator norm
(`open scoped Matrix.Norms.L2Operator`) on `Matrix (Fin 4) (Fin 4) C`.

An audit identified the cheapest route to a two-factor product estimate: combine a
generic accumulation lemma with the second-order exponential remainder, then convert
the `exp s - 1 - s` envelope into a clean `C * eps^2` bound. Formalize that route
abstractly so any walk can instantiate it.

Prove:
1. **Envelope-to-quadratic conversion**: for `0 <= s`,
   `Real.exp s - 1 - s <= s^2 * Real.exp s / 2` (or the cleaner
   `<= s^2 * Real.exp s`); state and prove whichever you can.
2. **Second-order remainder**: `||exp X - 1 - X|| <= ||X||^2 * Real.exp ||X||`
   for `X : Matrix (Fin 4) (Fin 4) C` (if this is easier via the series, do it).
3. **Two-factor product bridge**: for `A B : Matrix (Fin 4) (Fin 4) C` and
   `eps : R` with `0 <= eps`, setting `a = eps * ||A||`, `b = eps * ||B||`,
   ```
   || exp (eps . A) * exp (eps . B) - exp (eps . (A + B)) || <= C(A,B) * eps^2
   ```
   with `C(A,B)` EXPLICIT (e.g. `(||A||+||B||)^2 * Real.exp (eps*(||A||+||B||))`
   or a clean bound valid for `eps <= 1`). **No commutation between `A` and `B` may
   be assumed** - this is exactly the Lie-Trotter defect at second order.
Success: statement 3 with an explicit constant, plus whichever of 1-2 it needs.
No new axioms/native_decide; standard axioms; report axioms.
