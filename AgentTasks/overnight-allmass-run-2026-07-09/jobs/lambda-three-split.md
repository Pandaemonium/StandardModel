# claude-lambda-three-split — the three Lambdas: bare + induced, sequestered, count sets the observed

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

The cosmological-constant magnitude problem in the spectral-action picture: the order-0 term of the
finite spectral action carries a BARE Lambda; the matter channels (order-4) radiatively INDUCE a
further Lambda; naively `Lambda_obs = Lambda_bare + Lambda_ind` is huge and adjustable. The framework's
sequestering statement (extends the landed VacuumSequestering + LambdaMomentHierarchy): a uniform
vacuum shift of the Dirac square is absorbed by the unimodular multiplier, so `Lambda_bare` and the
uniform part of `Lambda_ind` DROP OUT of the physical, count-fluctuation Lambda. What is left -- the
observed Lambda -- is fixed by the pierced-edge COUNT (order-0 `tr(1)` fluctuation), not by the bare or
induced pieces. Prove the finite, rational version.

## The model (explicit rational)

Dirac square `H = H0 + lb . one + g . Hmat` on `Fin n` (small n, e.g. 2 or 3): `H0` the bare kinetic
square, `lb` (bare Lambda coefficient) times identity, `g . Hmat` the matter contribution. Define:
- `Lambda_bare (lb) := lb` (the uniform vacuum shift coefficient);
- `Lambda_ind (g) := (1/n) * (g . Hmat).trace` (the uniform/scalar part induced by matter -- the trace
  density of the matter block);
- The UNIMODULAR/sequestered observable `Lambda_seq (H) := H.trace / n - (traceless-mean is removed)`,
  i.e. the map that subtracts the uniform (identity-proportional) part: sequestered content depends only
  on the count-fluctuation, NOT on `lb` or the uniform matter shift.

Concretely define `seq (H) := H - ((H.trace / n) . one)` (the traceless part) and let the physical Lambda
be a COUNT functional `Lambda_count (N : Q) := 1 / N` independent of `lb, g` (the everpresent handle).

## Targets (rational; ring/norm_num/decide/fin_cases; NO Real transcendental, NO Complex, NO nlinarith deg>=3)

1. `bare_plus_induced`: the naive total `Lambda_naive (lb) (g) = Lambda_bare lb + Lambda_ind g` is an
   explicit rational function, and it is ADJUSTABLE -- exhibit two different `(lb, g)` giving different
   `Lambda_naive` (the magnitude problem: nothing fixes it). Explicit witnesses.
2. `uniform_shift_sequestered` (payload 1): the traceless map `seq` KILLS every uniform shift:
   `seq (H + c . one) = seq H` for all rational `c` (so `seq` is blind to `Lambda_bare` and to the
   uniform part of the induced Lambda). Prove by `Matrix.trace` linearity + `ring`.
3. `observed_is_count` (payload 2): the physical/observed Lambda is the count functional, independent of
   `lb` and `g`: `Lambda_count N` does not depend on `(lb, g)` (trivial-by-construction but load-bearing:
   the sequestered dynamics leave ONLY the count), AND the sequestered operator `seq H` is itself
   independent of `lb` (`seq (H0 + lb.one + g.Hmat) = seq (H0 + g.Hmat)` for all `lb`). Both directions
   explicit.
4. `three_lambda_verdict`: package -- there are three Lambdas: `Lambda_bare` (adjustable, order-0
   input), `Lambda_ind` (radiative, order-4), and `Lambda_obs = Lambda_count` (set by the pierced-edge
   count). The first two are sequestered out of the traceless/unimodular dynamics (`seq` kills uniform
   shifts); only the count survives. Honest scope: a finite linear-algebra avatar of vacuum sequestering
   -- it shows the STRUCTURE (uniform shifts drop, count remains), NOT the numerical value or sign of
   the physical Lambda (imported/open, the event horizon).

MANDATORY non-degeneracy: explicit small `n` (2 or 3); explicit `H0, Hmat` (nonzero, distinct); two
`(lb,g)` pairs with different `Lambda_naive` but SAME `seq H` (up to the `g` part) -- witnessing
sequestering; `Lambda_count` for two `N` values. All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Rational matrices, small fixed `n`; Matrix.trace linearity + ring/norm_num/
decide/fin_cases; NO Real.sqrt/cos/sin, NO Complex, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace LambdaThreeSplit) + ARISTOTLE_SUMMARY.md.
