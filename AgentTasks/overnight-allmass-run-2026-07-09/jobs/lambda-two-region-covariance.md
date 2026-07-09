# claude-lambda-two-region-covariance — the finite covariance of Lambda between nested causal regions (observational distinguisher)

## Context (blind to any repo; self-contained finite probability, Mathlib only)

Everpresent Lambda predicts not just an RMS but a COVARIANCE structure `<Lambda(t) Lambda(t')>` --
the observational fingerprint that distinguishes fluctuating null-edge dark energy from a rolling
quintessence field. Build the finite core: for two NESTED causal regions (a smaller `R1 subset`
a larger `R2`) with edge counts sharing a common part, compute the covariance of the normalized
Lambda's and show it is set by the SHARED (overlap) count -- long-range, horizon-scale
correlation, not local.

## The model (finite; independent-edge / shared-overlap)

Edges partitioned into three independent groups by counts: `a` = edges only in `R1`, `b` = shared
(`R1 cap R2`), `c` = only in `R2`. `N1 = a + b` (count in R1), `N2 = b + c` (count in R2). Under
independent Poisson-ish edges, `Var(group) = count`, and distinct groups are uncorrelated. Lambda_i
= deltaN_i / <N_i>.

## Targets (rational; Var/Cov identities)

1. `count_variances`: `Var(N1) = a + b`, `Var(N2) = b + c`, and `Cov(N1, N2) = Var(shared b) = b`
   (only the shared edges correlate). Prove from independence (distinct groups uncorrelated,
   `Cov(X+Y, X+Z) = Var(X)` for independent `X,Y,Z`).
2. `lambda_covariance` (payload): `Cov(Lambda1, Lambda2) = Cov(deltaN1, deltaN2)/(<N1><N2>) =
   b/(<N1><N2>)` -- the Lambda covariance is set by the SHARED edge count `b` normalized by the two
   volumes. So nested regions share dark-energy fluctuation in proportion to their causal overlap.
3. `correlation_length_reading`: the normalized correlation `Corr(Lambda1,Lambda2) = b / sqrt((a+b)(b+c))`
   -> 1 as the overlap dominates (`a,c -> 0`, nested/co-moving) and -> 0 as the regions decouple
   (`b -> 0`). Prove the two limits on explicit rational witnesses. Long correlation length =
   horizon-scale, NOT a local clustering fluid.
4. `distinguisher_verdict`: package -- everpresent Lambda has a specific two-region covariance set
   by causal overlap; this is a falsifiable fingerprint distinct from a local scalar field (which
   would give a different, potential-driven correlation). Honest scope: a finite independent-edge
   covariance model; the physical ensemble's actual correlations (and whether they are Poisson vs
   hyperuniform, per the dichotomy) are the open input; no claim about the real dark-energy power
   spectrum.

MANDATORY non-degeneracy: nested witness `a=1, b=98, c=1` (large overlap): `Cov(N1,N2)=98`,
`Corr approx 98/99`; decoupled witness `a=50, b=1, c=50`: `Corr = 1/51` -- explicit rationals
in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Rational + Finset (define Var/Cov by the independent-group formulas, or
via explicit finite expectations for small witnesses); ring/norm_num/decide/fin_cases; Real.sqrt at
most for the correlation line; NO Complex, NO Real.cos/sin/log, NO nlinarith deg>=3. Build under 3
min. Deliver RequestProject/Main.lean (namespace LambdaTwoRegionCovariance) + ARISTOTLE_SUMMARY.md.
