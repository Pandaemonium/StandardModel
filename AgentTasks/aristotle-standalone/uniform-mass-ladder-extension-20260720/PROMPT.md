# Lemma job: lift a fixed-mass convergence statement to uniform-in-mass

Mathlib-only, abstract, scoped L2 operator norm on `Matrix (Fin 4) (Fin 4) C`.
An end-to-end audit found the assembled ladder gives a FIXED-mass statement and does
NOT establish mass-uniformity. A separate brick proved uniform bounds on a mass ball.
Compose them properly.

Setting: a family `W : C -> R -> Matrix (Fin 4) (Fin 4) C` (mass, step) and
`E : C -> R -> ...`, with a one-step bound whose constant is a MONOTONE function of
`||M z||`: `||W z eps - E z eps|| <= C (||M z||) * eps^2`, where `||M z|| <= c0 * ||z||`.
Both families unitary, `E z` an exact one-parameter group for each `z`.

Prove:
1. **Uniform one-step**: for `||z|| <= Mb`, `||W z eps - E z eps|| <= C (c0 * Mb) * eps^2`
   (a single constant for the whole ball), using monotonicity of `C`.
2. **Uniform many-step**: hence `||(W z (t/n))^n - E z t|| <= C (c0 * Mb) * t^2 / n`
   for ALL `||z|| <= Mb` simultaneously.
3. **Sup form**: `sup_{||z|| <= Mb} ||(W z (t/n))^n - E z t|| -> 0` as `n -> infinity`.
4. **Honest limit**: show by a witness that this does NOT extend to ALL `z` (unbounded
   mass): exhibit `C` monotone unbounded so that no single constant works for every
   `z`, i.e. the ball hypothesis is load-bearing.
Success: 1-3 proved, 4 witnessed. No new axioms/native_decide; standard axioms.
