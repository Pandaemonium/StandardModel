# Lemma job: coin unitarity from the HERMITIAN half (discharges the composition trap)

Mathlib-only, abstract, scoped L2 operator norm on `Matrix (Fin 4) (Fin 4) C`.

A composition audit found a trap: the quadratic identity `M * M = (m^2 : C) . 1`
ALONE does NOT establish unitarity of the associated coin
`C a := cos(a m) . 1 - (I * sin(a m) / (m:C)) . M`. Unitarity needs the
ADJOINTNESS condition. Close that gap cleanly.

Prove:
1. **Skew-adjoint exponent**: if `M.IsHermitian` and `a : R`, then
   `((-a : C) . (I . M))` is skew-adjoint (`star X = -X`).
2. **Unitary exponential**: a skew-adjoint `X` has `exp X` unitary, hence
   `||exp X|| = 1`.
3. **Coin unitarity, correctly sourced**: if `M.IsHermitian` AND
   `M * M = (m^2 : C) . 1` with `0 <= m` (and `m = 0 -> M = 0`), then the coin
   `C a` is unitary for every real `a` - and prove it VIA (1)+(2) plus the closed
   form, i.e. the unitarity is sourced from HERMITICITY, not from the squaring
   relation.
4. **The trap, made explicit**: exhibit a matrix `N` with `N * N = (m^2 : C) . 1`
   that is NOT Hermitian and whose associated `C a` is NOT unitary for some `a` -
   proving that the squaring relation alone is genuinely insufficient.
5. **Group law**: under the same hypotheses prove `C a * C b = C (a + b)` and
   `C 0 = 1`, i.e. the reference family is an exact one-parameter group with
   identity - the other side condition the composition audit requires.
Success: 1-3 and 5 proved, 4 witnessed. No new axioms/native_decide; standard axioms.
