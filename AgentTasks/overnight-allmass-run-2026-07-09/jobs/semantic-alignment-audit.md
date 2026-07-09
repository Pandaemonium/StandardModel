# claude-semantic-alignment-audit — STRATEGY/AUDIT: do the LEAN STATEMENTS faithfully encode their claimed physics? (vacuity + reading-outruns-statement)

## This is a STRATEGY / AUDIT job, not a proof job. Deliver an analysis document, no Lean required.

Three prior red-teams reviewed this program's PROSE claims (det-P=mass headline; s7+s10a gravity/Lambda;
s4+s8 budget/protection) and forced honest corrections, all folded. This audit does the COMPLEMENTARY
check the kernel does NOT do: the Lean kernel verifies a proof is correct, but NOT that the theorem
STATEMENT is the intended mathematics. Review the following kernel-checked (0-sorry, guard-pinned)
statements for the two residual failure modes the prose audits did not target:
- **VACUITY**: are the hypotheses satisfiable / the existentials witnessed by explicit non-degenerate
  data, or could the theorem be trivially true (empty hypotheses, or a witness that degenerates)?
- **READING-OUTRUNS-STATEMENT**: does the manuscript's one-line reading claim MORE than the Lean
  statement actually says (a false-shape or over-generalization)?

## The statements under review (verbatim Lean) and their intended readings

1. `PauliMomentumPhysLean.det_P_eq_massSq (p0 p1 p2 p3 : R) : (P p0 p1 p2 p3).det = ((p0^2 - p1^2 -
   p2^2 - p3^2 : R) : C)` where `P p = p0 s0 + p1 s1 + p2 s2 + p3 s3` (Pauli). READING: "det of the
   little-group spinor matrix = m^2, the correct P (not the 4-vector Gram)".
2. `DetPUniqueness.detP_unique (co : Fin 6 -> R) (hnull : forall v, Qform co (edge v) = 0) (_hinv :
   forall A a b c, det A = 1 -> Qform co (A^T sym A) = Qform co sym) : exists k, forall a b c, Qform co
   (sym a b c) = k * det (sym a b c)`. READING: "det P is the UNIQUE quadratic vanishing on null edges -
   canonical, not chosen; null-vanishing ALONE forces it (SL2-inv unused)".
3. `RankCeiling.rank3_det_ne_pairwise : (massPair 1 1 1 != detG 1 1 1) and (massPair 1 1 0 != detG 1 1 0)
   and (massPair 1 1 0 != 0 and detG 1 1 0 = 0)`. READING: "at rank 3 the naive det P3 is a DIFFERENT
   function from the pairwise mass - the det reading is intrinsically rank-2".
4. `BudgetSignMismatch.family_fails : budget 2 2 0 != (10/3) * detP 2 2 0` (with `witness_match : budget
   2 2 1 = (10/3) * detP 2 2 1`). READING: "totalBudget = c*det P is witness-fitted, not a family
   identity - same c fails at another config".
5. `EvenMassGaps.even_gaps (hm : m != 0) : (Hmass m).det = m^4 and (Hmass m).det != 0` (with
   `odd_preserves : (A + Podd s).mulVec v = 0`). READING: "chiral protection is CONDITIONAL - odd
   perturbation preserves the zero mode, even mass gaps it".
6. `LambdaExponentFork.fork_iff (alpha : Q) : lamExp alpha = -1/2 <-> alpha = 1` where `lamExp alpha =
   alpha/2 - 1`. READING: "everpresent-Lambda survives iff the count-variance exponent alpha=1 - the
   sharp decidable fork".

## Your job: for EACH of (1)-(6), assess

- **Vacuity verdict** (witnessed / non-degenerate / at-risk): are there explicit non-degenerate
  witnesses making the statement non-empty? For the universally-quantified ones (1,2,6) is the claim
  substantive for ALL inputs, or does it collapse on a measure-zero/degenerate set? For the witness-
  based ones (3,4,5) are the witnesses genuinely non-degenerate (e.g. does statement 4's "family fails"
  really need TWO configs, or is one enough / are they cherry-picked in a way that hides a real family
  identity elsewhere)?
- **Reading-outruns-statement verdict** (faithful / slight-overreach / false-shape): does the one-line
  reading claim more than the Lean says? Specifically: (1) does "the correct P" reading overclaim beyond
  a determinant identity at one parametrization? (2) does "canonical" overclaim beyond quadratic forms
  (what about higher-degree invariants)? (3) does "intrinsically rank-2" follow from two witnesses, or is
  it an over-generalization from `massPair != detG` at specific points? (4) is "witness-fitted" fair, or
  could a DIFFERENT functional form (not `a^2+b^2+2x^2`) rescue a family identity? (5) does "conditional
  protection" generalize from one 2x2 example? (6) is `lamExp = alpha/2-1` the right exponent, and does
  "iff alpha=1" capture the physical everpresent condition or just the arithmetic?
- Flag any statement where the Lean is TRUE but the manuscript reading is a NON-SEQUITUR or subtly
  stronger.

## Output format
For each (1)-(6): a two-line verdict (vacuity: X; reading: Y) with the specific reasoning; then a ranked
list of the TOP 3 statements whose manuscript reading is most at risk of outrunning the Lean, with the
precise gap. Honesty over generosity - the point is to catch a false-shape or vacuity that three prose
red-teams and the kernel all miss, because the kernel checks the proof, not the intent.
