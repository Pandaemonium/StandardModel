# claude-unified-mass-budget — matter mass and gravity mass are graded pieces of ONE operator answering ONE invariant

## Context (blind to any repo; self-contained finite rational algebra, Mathlib only)

The unification thesis in one theorem: the finite Dirac square `4 D#D` decomposes into MATTER
channels (aperture Q_A, closure Q_C, turn Q_T) PLUS a GRAVITY channel (soldering E_#), and the
graded supertrace of the whole equals the SAME null-disagreement invariant `det P` that defines
mass. So "matter mass" and "gravity mass" are not two things -- they are graded pieces of one
operator, both answering the one Pluecker invariant. Prove it finitely.

## The model (explicit rational matrices)

An explicit rational carrier `D` (small, e.g. Cl(4)-flavored 4x4/8x8) with `4 D#D = Q_A + Q_C +
Q_T + E_sold` (all explicit rational symmetric/graded matrices). A chirality grading `Gamma`
(`Gamma^2 = 1`). The direction Gram `P` (2x2) with `det P` the mass invariant.

## Targets (ring/norm_num on explicit rational matrices)

1. `square_splits`: `4 D#D = Q_A + Q_C + Q_T + E_sold` exactly (an explicit matrix identity by
   `ring`), with the four blocks having distinct even/odd chirality grades under `Gamma`
   (`Gamma Q_X Gamma = +/- Q_X`, sign stated per channel) -- the matter/gravity split is a
   GRADING, not an ad hoc partition.
2. `budget_sum_one`: normalized channel shares `b_A + b_C + b_T + b_E = 1` (the total mass
   budget), with the MATTER share `b_A + b_C + b_T` and the GRAVITY share `b_E` explicit
   rationals summing to 1 -- one budget, split matter vs gravity.
3. `answers_detP` (payload): the graded supertrace / total budget of `4 D#D` equals (a fixed
   rational multiple of) `det P` -- the same null-disagreement mass invariant from the
   kinematic layer. So the operator's matter+gravity budget and the kinematic mass `det P` are
   the SAME number. State the exact identity `totalBudget(D) = c * det P` on an explicit witness.
4. `unified_verdict`: package -- matter mass (Q_A+Q_C+Q_T) and gravity mass (E_sold) are the
   graded pieces of one finite operator `4 D#D`, their shares sum to one budget, and that budget
   IS the kinematic null-disagreement `det P`. One operator, one invariant, four channels, both
   forces. Honest scope: a finite carrier identity; the channel<->physics identification stays C.

MANDATORY non-degeneracy: fully explicit rational `D`, `P`; ALL four channel blocks NONZERO
and the gravity share `b_E != 0` (else gravity is trivially absent); the identity
`totalBudget = c det P` instantiated at a specific nonzero rational (e.g. via the T2-style 3-4-5
witness), stated in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print
axioms <thm>` on every headline. REAL rational matrices (keep dims small); ring/norm_num/decide/
fin_cases; NO Complex, NO Real.cos/sin/sqrt, NO nlinarith deg>=3. Build under 3 min. Deliver
RequestProject/Main.lean (namespace UnifiedMassBudget) + ARISTOTLE_SUMMARY.md with honest scope.
