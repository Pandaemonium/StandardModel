# claude-lambda-susceptibility — Lambda's RMS is a thermodynamic response: Var(N) identity + the Bernoulli bound

## Context (blind to any repo; self-contained finite probability/algebra, Mathlib only)

Fold the cosmological constant into the mass-thermodynamics suite: for a finite ensemble of
null-edge occupancies, the count variance is a susceptibility, and the everpresent-Lambda
scaling becomes an UPPER-BOUND theorem for independent edges. Two finite identities and a bound;
no measure theory needed — work with explicit finite probability vectors.

## The model (finite, rational)

`n` edges; edge `i` occupied with probability `p_i` (rational, `0 <= p_i <= 1`), independently
(product measure on `Fin n -> Bool`, or simply work with the algebraic identities below). The
count `N = sum of indicators`; `<N> = sum p_i`; `Var(N) = sum p_i (1 - p_i)` (independence).

## Targets

1. `mean_count` and `var_count`: for the product/independent model, `<N> = sum p_i` and
   `Var(N) = sum_i p_i (1 - p_i)`. (Either derive from an explicit finite expectation over
   `Fin n -> Bool`, or — acceptable fallback — DEFINE mean/variance by these formulas for an
   independent-edge model, stating the independence reading in the docstring, and prove the
   bound/monotonicity structure below. Prefer the genuine finite-expectation derivation for at
   least `n = 2` as a soundness witness.)
2. `bernoulli_bound` (payload 1): `Var(N) = sum p_i(1-p_i) <= sum p_i = <N>` — the count
   variance of independent edges never exceeds the mean, with EQUALITY iff every `p_i(1-p_i) =
   p_i`, i.e. `p_i -> 0` (the sparse/Poisson limit). So Poisson statistics is the EXTREMAL case
   of an ideal edge gas.
3. `lambda_rms_upper_bound` (payload 2): with `Lambda = deltaN / <N>` and `deltaN^2 = Var(N)`,
   the second moment obeys `Var(N)/<N>^2 <= 1/<N>` — the everpresent scaling `Lambda_rms <=
   1/sqrt(<N>)` as an UPPER-BOUND theorem (equality in the sparse limit). State via squared
   quantities (no sqrt needed except optionally the final line via Real.sqrt monotonicity).
4. `susceptibility_reading`: the grand-canonical identity in finite form — define the ensemble
   weight with a chemical potential `mu` (e.g. `p_i(mu) = e^mu-free RATIONAL form: use the
   logistic p = mu/(1+mu) for rational mu > 0 to stay transcendental-free, or simply p_i as a
   parameter), and show `d<N>/dp_i = 1` and `Var = sum p_i(1-p_i)` is the response coefficient
   — i.e. the count fluctuation IS the susceptibility of the mean count to the occupancy
   parameters (state the cleanest rational version; do NOT use exp/log).
5. `area_exponent_note` (bonus, one-liner): if `V = A^2` (rational), then `1/sqrt(V) = 1/A`
   stated as the squared identity `(1/A)^2 = 1/V` — the "Lambda is inverse horizon-area" exponent
   identity (interpretation stays in prose).

MANDATORY non-degeneracy: instantiate on `n = 3`, `p = (1/2, 1/3, 1/4)`: `<N> = 13/12`,
`Var = 1/4 + 2/9 + 3/16 = 95/144`, and `Var <= <N>` as `95/144 <= 156/144` — explicit rationals
in-theorem; plus the sparse witness `p = (1/100, 1/100, 1/100)` where `Var/<N> = 99/100` (close
to 1, the Poisson limit direction).

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print
axioms <thm>` on every headline. Rational arithmetic + Finset.sum; ring/norm_num/decide/
fin_cases + sum manipulations; NO exp/log (use rational parametrizations), NO Complex, NO
Real.cos/sin, Real.sqrt at most for one final monotonicity line; NO nlinarith deg>=3. Build
under 3 min. Deliver RequestProject/Main.lean (namespace LambdaSusceptibility) +
ARISTOTLE_SUMMARY.md.
