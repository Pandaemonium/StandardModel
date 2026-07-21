# Lemma job: abstract one-step -> many-step convergence skeleton (MC4 shape)

Mathlib-only, abstract, scoped L2 operator norm
(`open scoped Matrix.Norms.L2Operator`) on `Matrix (Fin 4) (Fin 4) C`.

Assemble the standard "one-step estimate + telescoping => fixed-time many-step
convergence" skeleton as ONE reusable theorem, so a walk only has to supply its
one-step bound.

Prove:
1. **Telescoping**: for `U V` unitary, `||U^n - V^n|| <= n * ||U - V||`
   (prove it; do not assume it).
2. **Skeleton**: let `W : R -> Matrix (Fin 4) (Fin 4) C` and
   `E : R -> Matrix (Fin 4) (Fin 4) C` be families with
   - `W eps` and `E eps` unitary for all `eps` in `[0, 1]`,
   - a one-step bound `||W eps - E eps|| <= c * eps^2` for `0 <= eps <= 1`,
   - the exact one-parameter group law `E s * E t = E (s + t)` (so `E (t/n)^n = E t`).
   Conclude, for `t > 0` and `n` with `t/n <= 1`:
   ```
   || (W (t/n))^n - E t || <= c * t^2 / n
   ```
   i.e. an `O(1/n)` fixed-time rate from the `O(eps^2)` one-step bound.
3. State the conclusion also in the `Tendsto` form: `(W (t/n))^n -> E t` as
   `n -> infinity`.
This is the walk-agnostic skeleton; the walk supplies only hypothesis `c`. No new
axioms/native_decide; standard axioms; report axioms.
