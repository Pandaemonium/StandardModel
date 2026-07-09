# claude-lambda-edge-count — the cosmological constant from the null-edge count: Lambda ~ 1/sqrt(N)

## Context (blind to any repo; self-contained finite/rational, Mathlib only)

The causal-set "everpresent Lambda" (Ahmed-Dodelson-Greene-Sorkin) predicts a fluctuating
cosmological constant `|Lambda| ~ 1/sqrt(V)` from Poisson number-volume fluctuations `delta N ~
sqrt(V)` with `Lambda` conjugate to the 4-volume `V`. Make it the framework's OWN by routing it
through the null-EDGE count: prove that the pierced-null-edge count `N` of a finite causal region
is an extensive volume measure, so with the Poisson input `Lambda = delta N / N` has RMS `1/sqrt N`.

## The model (finite; N a natural number / rational)

A finite causal region has a pierced-null-edge count `N : Nat` (its discrete 4-volume). Regions
compose disjointly. Define `lambdaOf deltaN N = deltaN / N` (the normalized cosmological constant).

## Targets

1. `edgecount_extensive`: the edge count is additive over disjoint sub-regions:
   `N (A disjoint-union B) = N A + N B` (an extensive volume measure). Give a concrete finite
   model (e.g. `N` of a region = the cardinality of its pierced-edge finset) and prove additivity
   + monotonicity (`A subset B -> N A <= N B`).
2. `lambda_secondMoment_eq_inv_count`: under the Poisson hypothesis `deltaN^2 = N` (stated as an
   explicit hypothesis, the discreteness input), the normalized `Lambda = deltaN / N` has second
   moment `deltaN^2 / N^2 = 1 / N` (`ring`/`field_simp`).
3. `lambda_rms_eq_inv_sqrt_count` (payload): the RMS magnitude is `sqrt(N / N^2) = 1 / sqrt N` --
   the everpresent scaling law with `N` = the null-EDGE count (the theory's own primitive), not an
   abstract volume. So `Lambda ~ 1 / sqrt(edge count)`.
4. `everpresent_verdict`: package -- the cosmological constant fluctuates with RMS set by the
   inverse square root of the pierced-null-edge count of the region; for a large region this is
   tiny and tracks the ambient scale. Honest scope: this proves the SCALING given the Poisson
   input and the extensive edge count; it does NOT derive the value or the Lambda-V conjugacy
   (imported), and predicts a FLUCTUATING dark energy.

MANDATORY non-degeneracy: instantiate on `N = 100`: `deltaN^2 = 100`, second moment `1/100`,
RMS `1/10` (explicit rationals in-theorem); exhibit the extensive additivity on two concrete
disjoint finite edge-sets with nonzero counts.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Nat/rational + `Real.sqrt` ONLY for the final RMS line (use
`Real.sqrt_div'`/`Real.sqrt_inv`-style lemmas, not numeric sqrt evaluation); the rest is
ring/norm_num/decide/Finset cardinality; NO Complex, NO Real.cos/sin, NO nlinarith deg>=3. Build
under 3 min. Deliver RequestProject/Main.lean (namespace LambdaEdgeCount) + ARISTOTLE_SUMMARY.md.
