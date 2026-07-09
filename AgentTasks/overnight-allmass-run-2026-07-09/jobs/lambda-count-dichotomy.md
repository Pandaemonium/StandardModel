# claude-lambda-count-dichotomy — the pre-registered fork: do constraints make the edge count sub-Poissonian?

## Context (blind to any repo; self-contained finite probability/linear algebra, Mathlib only)

The everpresent-Lambda mechanism needs `Var(N) ~ <N>` (Poisson/extensive). The framework's own
Gauss/gauge constraints could CORRELATE the edge count and make it SUB-extensive (hyperuniform,
like Coulomb systems), which would suppress Lambda far below `1/sqrt(V)` and kill the everpresent
identification of observed dark energy. Decide the fork on FINITE WITNESSES: exhibit both
branches concretely, and state the pre-registered kill criterion. Either branch is publishable.

## The model (finite, explicit rational probability vectors)

Small edge sets with explicit distributions:
- FREE model: `n` independent edges, occupancy `p` each: `<N> = n p`, `Var(N) = n p (1-p)` —
  extensive (proportional to n), Poisson in the sparse limit.
- CONSTRAINED model: the same edges with a Gauss-type SUM CONSTRAINT (e.g. total occupancy fixed
  to exactly `k` — the microcanonical/neutrality analogue: sampling k-subsets uniformly).
  For uniform k-of-n: `<N> = k` EXACTLY and `Var(N) = 0` — the extreme sub-extensive case. For a
  softer constraint (mixture of k and k+1 with rational weights), `Var(N)` is an explicit small
  rational independent of n — sub-extensive.

## Targets

1. `free_variance_extensive`: for the independent model, `Var(N) = n p (1-p)` — proportional to
   `n` (extensive): `Var(N)/n = p(1-p)`, a nonzero constant for `0 < p < 1`. (Explicit finite
   expectation for small n as the soundness witness, formula in general.)
2. `constrained_variance_subextensive` (payload): for the sum-constrained (k-of-n uniform)
   model, `Var(N) = 0` for EVERY n — the constraint kills the extensive fluctuation entirely;
   for the soft two-value mixture, `Var(N) = w(1-w)` (a constant independent of n). In both
   cases `Var(N)/n -> 0`: the constrained count is SUB-extensive/hyperuniform-direction.
3. `dichotomy_criterion` (the pre-registered kill, packaged): define
   `extensive (Var) (n) := Var / n bounded below by a positive constant` vs `subextensive :=
   Var/n -> 0` (state finitely: for all n, Var(n)/n = c > 0 vs Var(n)/n <= C/n). Prove the free
   model satisfies the first and the constrained models the second. COROLLARY (connect to the
   everpresent scaling): with `Lambda_rms^2 = Var/<N>^2`, the free model gives `~ 1/<N>`
   (everpresent) while the hard-constrained model gives `0` (Lambda suppressed entirely) — so
   WHETHER the physical count is free or constrained decides the everpresent identification.
   State the criterion as the theorem `everpresent_iff_extensive` in this finite setting.
4. `which_count_matters` (the refinement, as a definition + witness): the constraint acts on a
   FIBER (internal/color) register, not necessarily the bare edge count — exhibit a two-register
   model (edge occupancy x internal charge) where the GAUSS constraint fixes the total CHARGE
   (charge variance 0) while the bare EDGE count stays free (variance extensive). So the fork's
   resolution depends on WHICH count Lambda is conjugate to — formalized as: constrained charge
   variance = 0 AND free edge variance = n p(1-p) in the same model.

MANDATORY non-degeneracy: all witnesses explicit — free: `n = 3, p = 1/2` => `Var = 3/4`
(extensive, `Var/n = 1/4`); hard-constrained: 2-of-3 uniform => `<N> = 2, Var = 0`; soft:
`w = 1/3` mixture => `Var = 2/9` (n-independent); the two-register witness with charge-Var 0 and
edge-Var nonzero. All rationals stated in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print
axioms <thm>` on every headline. Finite explicit distributions (Finset expectations over small
concrete spaces; rational weights); ring/norm_num/decide/fin_cases + Finset.sum; NO measure
theory, NO exp/log, NO Complex, NO Real.sqrt/cos/sin, NO nlinarith deg>=3. Build under 3 min.
Deliver RequestProject/Main.lean (namespace LambdaCountDichotomy) + ARISTOTLE_SUMMARY.md with an
honest note: these are finite witnesses establishing the FORK and its criterion, not a
computation of the physical ensemble's actual statistics (that is the follow-up oracle probe).
