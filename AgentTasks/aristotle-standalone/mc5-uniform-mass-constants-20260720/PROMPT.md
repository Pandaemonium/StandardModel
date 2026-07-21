# Lemma job: uniform-in-mass constants on a bounded mass ball (MC5 item 4)

Mathlib-only, abstract, scoped L2 operator norm
(`open scoped Matrix.Norms.L2Operator`) on `Matrix (Fin 4) (Fin 4) C`.

An audit noted that a fixed-mass convergence theorem extends to a family theorem
only if the constants are uniform on a bounded mass ball. Make that precise and
prove the uniformity, so the extension is a lemma rather than a hope.

Setting: a mass-dependent generator `M : C -> Matrix (Fin 4) (Fin 4) C` that is
**linear in the mass parameter** in the sense `||M z|| <= c0 * ||z||` for a fixed
`c0` (this holds for any `M z = z.re . B1 + z.im . B2`, with
`c0 = ||B1|| + ||B2||` - prove that instance too).

Prove:
1. **Uniform generator bound**: for `||z|| <= Mbound`, `||M z|| <= c0 * Mbound`.
2. **Uniform exponential bound**: `||exp (eps . (I . M z))|| <= Real.exp (eps * c0 * Mbound)`
   for `0 <= eps`; and if `M z` is Hermitian, the exponential is unitary so the
   bound is exactly `1` - state which hypothesis you use.
3. **Uniform second-order remainder**: `||exp (eps . (I . M z)) - 1 - eps . (I . M z)||
   <= (eps * c0 * Mbound)^2 * Real.exp (eps * c0 * Mbound)`, uniformly for
   `||z|| <= Mbound`.
4. Conclude a statement of the form: any constant built from `||M z||` alone is
   bounded uniformly on the ball `||z|| <= Mbound`, so a fixed-`z` estimate with such
   a constant upgrades to a uniform-in-`z` estimate on the ball.
Success: 1-3 proved with explicit constants and 4 stated precisely. No new
axioms/native_decide; standard axioms; report axioms.
