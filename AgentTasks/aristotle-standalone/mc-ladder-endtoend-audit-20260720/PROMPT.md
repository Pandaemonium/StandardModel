# Adversarial end-to-end audit: does the assembled ladder prove what it claims?

Mathlib-only adversarial audit + witnesses. A six-rung ladder is claimed to give:
"for fixed mass and Schwartz data, a changing-lattice evolution converges in L2 on
finite time intervals to the continuum flow, with an O(1/n) rate uniform on compact
momentum boxes."

All rungs now have individual bricks. Audit the END-TO-END claim for gaps that
survive even when every rung is individually true.

Answer each with a proof or explicit counterexample:
1. **Quantifier order.** "O(1/n) uniform on compact momentum boxes" - is the constant
   allowed to depend on the box `K`? Show that a bound `C(K)/n` with `C` unbounded in
   `K` does NOT give a single rate valid for all momenta, and state the exact
   quantifier order the claim needs.
2. **Fixed time vs uniform time.** Given `||A_n(t) - B(t)|| <= C t^2 / n` for each
   fixed `t`, does it follow that `sup_{t <= T} ||A_n(t) - B(t)|| -> 0`? Prove it for
   the stated form (the bound is monotone in `t`), and give a counterexample family
   where a pointwise-in-`t` rate does NOT give uniform-in-`t` convergence, to show the
   monotonicity is what saves it.
3. **Compact bulk + tail split.** If the bulk error is `<= a_n -> 0` on `|q| <= K` and
   the tail contributes `<= 2 * ||f restricted to |q| > K||`, prove the combined bound
   and show the ORDER OF LIMITS matters: one must choose `K` first (to make the tail
   small for the FIXED `f`), then `n`. Exhibit the failure if `K` is chosen depending
   on `n` in the wrong direction.
4. **What is NOT proved.** State plainly which of these the assembled ladder does NOT
   establish: uniformity in the mass; interacting dynamics; uniqueness of the walk;
   any statement about doubling/mirror sectors.
Deliver verdicts + Lean witnesses where a counterexample is requested.
No new axioms/native_decide; standard axioms; report axioms.
