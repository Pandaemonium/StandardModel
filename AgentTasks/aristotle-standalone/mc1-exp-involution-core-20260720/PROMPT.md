# Lemma job: closed form of exp(-i a M) when M^2 = m^2 . 1 (abstract MC1 core)

Mathlib-only, ABSTRACT (no project files). This is the mathematical core of a
massive-Dirac coin identity, extracted so it is reusable and provable without any
project context.

For `M : Matrix (Fin 4) (Fin 4) C` with `M * M = (m^2 : C) . 1` for some real
`m >= 0`, and `a : R`, prove the closed form

```
exp ((-a : C) . (I . M)) = (Complex.cos (a*m)) . 1 - (I * Complex.sin (a*m) / (m : C)) . M
```

with the convention that at `m = 0` the second term is `0` (Lean's `x/0 = 0`), so
that the identity holds UNCONDITIONALLY in `m` - including `m = 0` where `M^2 = 0`
and (for the intended application) `M = 0`, both sides being `1`. State exactly
which hypothesis you need at `m = 0`: if `M = 0` is required, say so; if `M^2 = 0`
suffices, prove that.

Route: split the exponential series into even and odd powers using `M^(2k) =
m^(2k) . 1` and `M^(2k+1) = m^(2k) . M`, then recognize the cos/sin series. Use the
`Matrix.exp` / `NormedSpace.exp` API with the L2 operator norm
(`open scoped Matrix.Norms.L2Operator`) so the series converges in a Banach algebra.

Success: the unconditional closed form, plus the `m = 0` degenerate case handled
explicitly. No new axioms/native_decide; standard axioms; report axioms.
