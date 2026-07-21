# Adversarial audit: two-component pointwise Weyl generator claim

Mathlib-only adversarial audit + witnesses. A program claims a "two-component HNU
exact pointwise generator" theorem of the shape: the derivative at `eps = 0` of a
one-parameter family of `2 x 2` unitaries `W eps` equals `-i (sum_j sigma_j q_j)`
(a Weyl generator), for fixed momentum `q`. Audit the SHAPE of such a claim for the
four over-claim modes {vacuity, hollow-telescoping, docstring-outruns-kernel,
false-shape}, and prove Mathlib-only witnesses:
1. **Derivative-at-zero is NOT an O(eps^2) estimate.** Exhibit two families with the
   SAME derivative at 0 whose distance from `exp(-i eps G)` differs at order
   `eps^2` - so a pointwise-generator theorem does not license a rate claim.
2. **Scalar sign / orientation.** Show that `d/d eps|_0 W eps = -i G` versus `+i G`
   are genuinely different claims by exhibiting a family where the sign flip gives a
   different (wrong) generator; i.e. the sign is load-bearing, not conventional.
3. **Multiplication orientation.** For noncommuting `A B`, exhibit
   `exp(A) exp(B) != exp(B) exp(A)`, so "the product of factors" must fix an order;
   a generator claim that sums generators hides an order choice at second order.
4. **Non-vacuity.** Give a concrete nonzero `q` and a concrete `W` witnessing that
   the generator is nonzero (the claim is not about a trivial family).
Deliver a verdict per mode with the witness. No new axioms/native_decide; standard
axioms; report axioms.
