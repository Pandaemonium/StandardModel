# claude-definitions-honesty-audit — STRATEGY/AUDIT: do the MODEL DEFINITIONS honestly encode the physics, or beg the question?

## This is a STRATEGY / AUDIT job, not a proof job. Deliver an analysis document, no Lean required.

Four prior audits checked this program's PROSE claims (3 red-teams) and its THEOREM STATEMENTS (semantic-
alignment). The last one's meta-finding: "several readings are load-bearing on DEFINITIONS, not the
proved proposition - which is exactly where a false-shape hides." This audit closes that gap: for each
model DEFINITION below, assess whether it FAITHFULLY encodes the intended physics object, or whether it
is CHOSEN so the theorem trivially confirms the reading (question-begging / model-rigged-to-conclude).

The tell you are hunting: a definition whose specific form (a factor, a sign, a chosen entry) is what
makes the headline true, such that a DIFFERENT equally-defensible definition would make it false. If the
physics lives entirely in an un-argued definitional choice, the theorem is a tautology dressed as a result.

## The definitions under review (verbatim Lean) with their intended physics

1. **Lambda exponent** (`LambdaExponentFork`): `lamExp (alpha : Q) := alpha/2 - 1`. INTENDED: the
   Lambda_rms scaling exponent as a function of the count-variance exponent alpha, from Lambda_rms =
   sqrt(Var N)/N = N^{alpha/2}/N. QUESTION: is `alpha/2 - 1` FORCED by "sqrt halves the exponent, /N
   subtracts 1", or is it a posited constant? Does anything but the physics dictate the `/2` and the `-1`?

2. **Budget vs det** (`BudgetSignMismatch`): `budget a b x := a^2 + b^2 + 2*x^2`; `detP a b x := a*b -
   x^2`. INTENDED: `budget` = the Frobenius/sum-of-squares `tr(D#D)` avatar; `detP` = the Gram
   determinant. QUESTION: is the coefficient `2` on `x^2` in `budget` the honest Frobenius norm of a
   symmetric `[[a,x],[x,b]]` (which has TWO off-diagonal `x` entries, so `2x^2` IS correct), or chosen
   to sharpen the sign-mismatch? Is the sign-mismatch (`+2x^2` vs `-x^2`) a real structural fact or a
   definitional artifact?

3. **Pairwise mass vs Gram det** (`RankCeiling`): `massPair a b c := 2*(a+b+c)`; `detG a b c := det
   !![0,a,b; a,0,c; b,c,0]` (zero-diagonal `3x3` Gram, `= 2abc`). INTENDED: massPair = the true rest-
   mass-squared `sum 2 p_i.p_j` of three null edges; detG = the naive determinant extension. QUESTION:
   is `massPair = 2(a+b+c)` the correct `m^2 = (sum p_i)^2` for zero-diagonal (null) `p_i.p_i=0` (it is:
   `(sum p_i)^2 = 2 sum_{i<j} p_i.p_j`), and is the disagreement with detG genuine, or is detG a straw
   object nobody would propose?

4. **Chiral protection model** (`EvenMassGaps`): `Gamma := diag(1,-1)`; `A := !![0,1;0,0]` (odd);
   `v := ![1,0]`; `Podd s := !![0,s;0,0]` (odd); `Peven m := !![m,0;0,-m]` (even); `Hmass m := (A + Peven
   m)^H (A + Peven m)`. INTENDED: a graded carrier with a chiral zero mode, an odd perturbation (grading-
   reversing) and an even one (grading-preserving). QUESTION: is `A` a fair "odd operator with a chiral
   zero mode", or is it degenerate/too-special (rank 1, nilpotent)? Are `Podd`/`Peven` genuinely the
   odd/even parts w.r.t. `Gamma` (`Gamma X = -X Gamma` vs `Gamma X = X Gamma`), or mislabeled? Does the
   `Peven = diag(m,-m)` (a chiral/axial mass) fairly represent "an even mass term", or is it cherry-
   picked to gap the mode while a different even term might not?

5. **Null edge + quadratic space** (`DetPUniqueness`): `edge v := v v^T` (rank-1); `Qform (co : Fin 6 ->
   R) P := co0 P00^2 + co1 P01^2 + ... ` (a general quadratic in the 3 entries of symmetric `P`).
   INTENDED: `edge` = a null momentum (rank-1 PSD); `Qform` ranges over ALL quadratic forms. QUESTION:
   does `edge v = v v^T` capture all null edges (rank-1 PSD symmetric = `v v^T`, yes), and does the
   6-coefficient `Qform` really span ALL quadratic forms on symmetric `2x2` (3 entries -> 6 quadratic
   monomials, yes), so "unique among quadratics" is a genuine 6-dim -> 1-dim uniqueness, not a rigged
   subspace?

## Your job: for EACH (1)-(5)

- **Faithful / rigged verdict**: is the definition the honest encoding, or is a specific choice (factor,
  sign, entry) doing the work the physics should? State the ONE alternative definition that would break
  the headline, and whether that alternative is more or less defensible than the one chosen.
- **Question-begging check**: could the theorem be restated as "by our definition, X" - i.e. is the
  content in the definition rather than the proof?

## Output format
Per (1)-(5): a two-line verdict (faithful/rigged; content-in-def or content-in-proof) with the specific
reasoning and the breaking alternative. Then the TOP 2 definitions most at risk of being question-begging.
Honesty over generosity - find the definitional choice that secretly carries the headline, if there is one.
