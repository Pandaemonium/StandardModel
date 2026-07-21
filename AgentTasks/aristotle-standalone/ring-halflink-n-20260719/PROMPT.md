# Task: half-link fields at general ring length (Paper A chain, A2)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, Paper A lane.
Self-contained three-file package. `RingHolonomySpectrumN` landed TONIGHT
(included, PROVEN): the odd-`n` trace-power holonomy formula and the
spectral discriminator `winding_one_not_conjugate_trivial`.

## Target

`PhysicsSM/Draft/NullEdge/RingHolonomyHalfLinkN.lean` - three theorems
ending in a hole:

1. `unitLinks_halfLinkField` - `exp(iθ) * conj (exp(iθ)) = 1`
   (`Complex.exp_conj` / `Complex.mul_conj`-style; `Complex.abs_exp` of a
   purely imaginary exponent).
2. `holonomy_halfLinkField` - the product of the half-links is
   `exp(i (∑ δ)/2) = exp(iπ) = -1` when `∑ δ = 2π`
   (`Complex.exp_sum` / `Finset.prod_exp`-style collection of exponents,
   then `Complex.exp_pi_mul_I`; the three-site pattern is
   `halfLink_three_eq_neg_one_of_sum_eq_two_pi` in the repo's 3-site
   bridge - same argument, `Finset.sum` instead of three terms).
3. `halfLink_ring_not_conjugate_trivial` - compose 1-2 with the included
   `winding_one_not_conjugate_trivial` (the trivial field `fun _ => 1` has
   holonomy `1` and unit links trivially).

## Pre-registered honesty license

If a factor-of-two or sign convention in the half-link exponent must shift
for holonomy `-1` to come out exactly, fix it ONCE, record prominently,
and keep the composed corollary exact. Do not modify the included modules.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/RingHolonomyHalfLinkN.lean` first.

## Success criteria

All three theorems proven, zero holes, completion report with axioms used.
