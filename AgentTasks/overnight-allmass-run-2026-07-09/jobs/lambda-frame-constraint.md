# claude-lambda-frame-constraint — frame-blindness forces the Poisson (everpresent) branch: a finite theorem

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

The cosmological-constant fork (`LambdaCountDichotomy`, already landed): the everpresent-Lambda
identification survives iff the pierced-null-edge count `N` of a region has EXTENSIVE variance
(Poisson, `Var ~ N`); it dies if the count is HYPERUNIFORM (sub-extensive, `Var << N`). Prior art
(Sorkin; Bombelli-Henson-Sorkin): Poisson sprinkling is the UNIQUE Lorentz-invariant discretization
-- a regular/hyperuniform point set picks out a preferred frame. This job makes the finite core of
that statement a theorem: FRAME-BLINDNESS (permutation invariance, the finite avatar of "no preferred
direction") allows exactly ONE variance-suppressed mode -- fixing the grand total -- which does NOT
suppress the regional fluctuations everpresent-Lambda needs. Suppressing any NON-uniform direction
requires a preferred covector, breaking frame-blindness.

## The model (finite, rational)

Counts over `k` regions: `n : Fin k -> Q`. A "count ensemble" is captured by its rational covariance
matrix `C : Matrix (Fin k) (Fin k) Q` (symmetric PSD). Permutation invariance (finite frame-blindness):
`C` commutes with every permutation matrix, equivalently `C = a . I + b . J` (`J` = all-ones matrix),
for rationals `a, b`. "Hyperuniform in direction `v`" means `v` is a null/suppressed eigenvector of
`C` (`C.mulVec v = 0`, `v != 0`). The uniform direction is `ones = ![1,...,1]`.

## Targets (rational; ring/norm_num/decide/fin_cases; NO Real, NO Complex, NO nlinarith deg>=3)

1. `perm_inv_iff_aI_bJ`: a symmetric rational `C` commutes with all permutation matrices IFF
   `C = a . I + b . J` for some rationals `a,b`. (For a fixed small `k`, e.g. `k=3`, prove via
   `fin_cases`/`decide` on the transposition generators -- keep it finite and explicit.)
2. `suppressed_dir_is_uniform` (payload): for `C = a.I + b.J` with `a != 0` (nondegenerate base
   variance), the ONLY suppressed direction is the uniform one: if `C.mulVec v = 0` and `v != 0` then
   `v` is a scalar multiple of `ones` (and then `a + k.b = 0`). I.e. a frame-blind ensemble can only
   suppress the grand-total mode. Prove for explicit `k=3` (or general `k` if clean) by linear algebra
   on `a.I + b.J`.
3. `nonuniform_suppression_breaks_symmetry` (payload): exhibit an explicit rational symmetric PSD `C'`
   that suppresses a NON-uniform direction (e.g. `v = ![1,-1,0]`, `C'.mulVec v = 0`) and show `C'` does
   NOT commute with some explicit transposition (does not equal any `a.I + b.J`) -- hyperuniformity in
   a non-uniform mode requires a preferred covector. Explicit witness.
4. `frame_blind_everpresent_verdict`: package -- a frame-blind (permutation-invariant) count ensemble
   suppresses at most the uniform grand-total mode, leaving regional variance extensive (the everpresent/
   Poisson branch); any hyperuniform suppression of a regional (non-uniform) mode requires a preferred
   covector and breaks frame-blindness. Honest scope: permutation invariance is the FINITE avatar of
   Lorentz frame-blindness; the continuum Lorentz-invariance => Poisson step stays imported. This is the
   finite structural core of "the hyperuniform branch costs a preferred frame."

MANDATORY non-degeneracy: explicit `k=3`; explicit `a,b` (e.g. `a=1`); the uniform suppressed witness
(`a+3b=0`, e.g. `a=1,b=-1/3`, `C.mulVec ones = 0`); the non-uniform witness `C'` with `C'.mulVec ![1,-1,0]=0`
and an explicit non-commuting transposition; all in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Rational matrices, small fixed `k` (3 is fine); ring/norm_num/decide/
fin_cases/Finset; NO Real.sqrt/cos/sin, NO Complex, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace LambdaFrameConstraint) + ARISTOTLE_SUMMARY.md.
