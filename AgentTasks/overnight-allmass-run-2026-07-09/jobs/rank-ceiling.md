# claude-rank-ceiling — kernel-check the rank-2 ceiling: at rank 3 the naive det does NOT give m^2 (formalizing the audit's kill-test as an honest boundary)

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

An adversarial audit produced the sharpest kill-test of the program's headline: `mass^2 = det P` is
intrinsically a TWO-edge (2x2) statement, and the naive extension to three null edges (`mass^2 = det P3`
for the 3x3 Gram) FAILS -- the true rest-mass-squared of a multi-edge state is the sum of PAIRWISE
products `sum_{i<j} 2 p_i . p_j`, NOT the Gram determinant. This job formalizes that boundary honestly:
it proves, on explicit finite witnesses, that the pairwise mass and the 3x3 determinant are DIFFERENT
functions -- so the determinant reading is genuinely rank-2-only and the program must (and does) restrict
its det-P claim to two-edge states. This is the honest theorem that marks where universality stops.

## The model (finite, rational)

Three null "edges" as rational vectors carrying a pairwise-product structure. Model the pairwise inner
products by an explicit rational symmetric `3x3` Gram `G` with ZERO diagonal (null: `p_i . p_i = 0`) and
off-diagonal `g_ij = p_i . p_j`: `G = !![0, a, b; a, 0, c; b, c, 0]`. Two candidate "mass^2" readings:
* pairwise (physical): `massPair G = 2*(a + b + c)` (= `sum_{i<j} 2 p_i.p_j`, the true `m^2` of the sum
  `p = p1+p2+p3`, since `p.p = sum_i p_i.p_i + 2 sum_{i<j} p_i.p_j = 0 + 2(a+b+c)`);
* determinant (naive extension): `detG = G.det` (the 3x3 Gram determinant `= 2abc` for this pattern).

## Targets (rational; ring/norm_num/decide/fin_cases; NO transcendental, NO Complex, NO nlinarith deg>=3)

1. `massPair_closed` and `detG_closed`: `massPair G a b c = 2*(a+b+c)` and `G.det = 2*a*b*c` for the
   zero-diagonal pattern, via `Matrix.det_fin_three` + `ring`.
2. `rank2_ok` (the SANITY anchor -- the claim DOES hold at rank 2): for the 2x2 zero-diagonal null Gram
   `G2 = !![0, a; a, 0]`, the pairwise mass `2*a` and `-G2.det = a^2`... state the CORRECT rank-2 fact
   the program actually uses: for the 2x2 SPINOR PSD matrix `P = !![p, x; x, q]`, `det P = p*q - x^2`
   is the mass^2 (a genuine 2x2 determinant), i.e. at rank 2 the determinant reading is exact. (Keep
   this as the honest contrast: rank 2 works.)
3. `rank3_det_ne_pairwise` (payload): the two readings DISAGREE at rank 3 -- exhibit explicit rationals
   where `massPair != detG`: e.g. `a=b=c=1` gives `massPair = 6` but `detG = 2`, so `6 != 2`. And a
   second witness `a=1,b=1,c=0`: `massPair = 4`, `detG = 0` -- the determinant VANISHES (linear
   dependence) while the mass is nonzero. So `det P3` cannot be the mass at rank 3. Explicit, `norm_num`.
4. `rank_ceiling_verdict`: package -- at rank 2 the determinant IS the mass^2 (the program's actual
   claim); at rank 3 the naive `det P3` is a DIFFERENT function from the physical pairwise mass
   (`massPair != detG` on explicit witnesses, and `detG` even vanishes on a nonzero-mass configuration).
   Therefore the det-P reading is intrinsically two-edge, and universality across higher spin is NOT
   claimed. Honest scope: this is a NEGATIVE/boundary result -- it marks the limit, it does not extend
   the mechanism. Dimensional note (informal, in docstring): an `r x r` Gram determinant scales as
   mass^{2r}, so only `r=... ` wait -- keep the honest statement to the explicit numeric disagreement.

MANDATORY non-degeneracy: the two explicit rank-3 witnesses (`a=b=c=1`: 6 vs 2; `a=b=1,c=0`: 4 vs 0);
the rank-2 contrast (`det !![p,x;x,q] = p*q - x^2` with an explicit massive `p=q=1,x=0` -> mass^2=1).
All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Rational symmetric matrices; Matrix.det_fin_two/det_fin_three + ring/norm_num/
decide/fin_cases; NO Real.sqrt/cos/sin, NO Complex, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace RankCeiling) + ARISTOTLE_SUMMARY.md.
