# Proof job: theta-family wave 2 - kernel atlas, symbolic iff, landed-fixture pin (Paper C freeze-grade)

Kernel-only Lean 4 (standard three axioms; NO native_decide). Import
Mathlib + context modules (do not modify them). Extend
context/ThetaFamilyProtection.lean's namespace in a NEW file
ThetaFamilyCompletion.lean. FULL IMPORT CLOSURE is included in context/
this time (all five modules).

Ranked targets (from an independent strategy audit; each has a gate):

T1 (b1, ~easy): atlas_two_charts_family:
  theorem: for all theta : Real, all b with
  HalfPeriodInvariant.wallCount b = 2:
  (M13 theta b = (M13 theta b)^T) or (M02 theta b = (M02 theta b)^T).
  Proof shape: exactly the body of modes_persist minus the engine step
  (two_wall_chart dispatch + M13_selfadj_of / M02_selfadj_of). This is
  the kernel + all-theta replacement of the fixed-angle native_decide
  atlas.

T2 (b2, the payoff): the symbolic positional IFF.
  Step 1 GATE: compute the closed form of every entry of
  M13 theta b - (M13 theta b)^T. Expected (VERIFY, do not assume): every
  nonzero entry is +-(signB (b 0) + signB (b 2)) * Real.sin theta.
  If ANY entry carries a different trig monomial, STOP the iff and
  report - ship sufficiency only (kill condition; do not prove an iff
  entrywise-by-luck).
  Step 2 (if gate passes):
  theorem M13_antisymm_entry (theta b) :
    (M13 theta b - (M13 theta b)^T) 0 1
      = -(signB (b 0) + signB (b 2)) * Real.sin theta  -- exact
      coefficient from your Step-1 computation
  theorem M13_selfadj_iff (theta b) :
    M13 theta b = (M13 theta b)^T <->
      (signB (b 0) + signB (b 2)) * Real.sin theta = 0
  and mirror-symmetrically M02_selfadj_iff on signB (b 1) + signB (b 3).
  This subsumes the fixture iff and the T5 controls as instances.

T3 (Q2c, credibility pin): Wth_eq_landed. The landed fixture walk is
  walkQ cW (sField b) over Q with cW = 4/5 and sine magnitudes 3/5
  (context HalfPeriodInvariant: Wof b = walkQ cW (sField b)). Let
  theta0 satisfy Real.cos theta0 = 4/5 and Real.sin theta0 = 3/5
  (state as hypotheses hc : Real.cos theta0 = 4/5,
  hs : Real.sin theta0 = 3/5 - no need to construct theta0).
  Prove: Wth theta0 b = (Wof b).map (Rat.cast) for every b (or the
  equivalent entrywise transport through shiftR/coinR =
  shiftQ/coinQ .map Rat.cast). This proves the theta-family result
  CONTAINS the landed fixture at the fixture angle - the missing
  referee pin.

T4 (dictionary compat hygiene, one-liners): in the CGGSVWZDictionary
  namespace conventions, add wallCount_compat, loneAt_compat,
  fixedSingleton_compat: the local helper defs agree with the landed
  HalfPeriodInvariant ones on all inputs (by decide, kernel).

Deliverable: ThetaFamilyCompletion.lean + short memo with the Step-1
entry table (all 16 antisymmetric entries in closed form).
