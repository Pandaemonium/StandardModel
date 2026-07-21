# Task: ring-holonomy spectral witness at EVERY length (drop the parity hypothesis)

Project: Lean 4 (v4.28.0) + Mathlib. Four-file package: three PROVEN landed
modules (do not modify) + the target. The landed chain establishes the
trace-power holonomy formula and spectral discriminator at every ODD ring
length `n > 2`; this job extends both to EVEN `n` and composes the
all-`n` result.

## Target

`PhysicsSM/Draft/NullEdge/RingHolonomyAllN.lean` - six theorems ending in
a hole:

1. `trace_forwardHop_pow_of_lt` / 2. `trace_backwardHop_pow_of_lt` -
   pure hop powers below the ring length are traceless. The landed
   `h_forwardHop_pow` entry formula (inside `trace_pow_odd`'s proof, easy
   to re-derive) gives diagonal entries only when `(m : ZMod n) = 0`,
   impossible for `0 < m < n`.
3. `trace_pow_even` - **the crux**. Even-`n` trace formula
   `trace (H^n) = n * C(n, n/2) + n * (w + conj w)`. Suggested route: the
   landed binomial expansion (`Commute.add_pow`; the hops commute since
   `F * B = B * F = 1` by the landed `forward_backward_mul` /
   `backward_forward_mul`) gives
   `(F + B)^n = ∑ k, C(n,k) • F^k * B^(n-k)`. With `F * B = 1` each term
   telescopes to the pure power `F^(2k-n)` when `2k >= n`, else
   `B^(n-2k)`. Traces vanish for exponents strictly between `0` and `n`
   (targets 1-2); the survivors are `k = 0` (`n * conj w`), `k = n`
   (`n * w`), and `k = n/2` (`C(n, n/2) * n`, trace of the identity).
4. `not_unitarily_conjugate_of_holonomy_re_ne_even` - mirror the landed
   odd discriminator proof (conjugation preserves `trace (H^n)`; the
   combinatorial constant cancels in the comparison; then the real parts
   must agree).
5. `not_unitarily_conjugate_of_holonomy_re_ne_all` - parity case split
   (`Nat.even_or_odd`), composing the landed odd theorem with target 4.
6. `halfLink_ring_not_conjugate_trivial_all` - compose target 5 with the
   landed parity-free `holonomy_halfLinkField` / `unitLinks_halfLinkField`
   exactly as the landed odd composition does.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Do NOT modify the three landed modules; add helper lemmas in the target
  file only.
- Do NOT change the six target statements (they are pre-registered). If
  the even-`n` constant is genuinely different from `n * C(n, n/2)`,
  STOP and report the corrected constant with a kernel-checked small-`n`
  computation (e.g. `n = 4`) instead of proving a changed statement
  silently.
- Verify with `lake env lean PhysicsSM/Draft/NullEdge/RingHolonomyAllN.lean`.

## Success criteria

All six proven = full success (the Paper A chain then holds at EVERY ring
length `n > 2`). If the even crux resists: prove 1, 2, 4-6 conditional
routes are NOT acceptable - instead land 1-2 plus a precise decomposition
report for 3 (which telescoping step fails, what Mathlib lemma is
missing). Completion report: convention choices, axioms per theorem.
