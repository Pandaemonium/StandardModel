# claude-even-mass-gaps-kill — kernel-check the s8 kill-test: an EVEN mass term gaps the chiral zero mode (protection is conditional, not "immune to every potential")

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

An adversarial audit's sharpest s8 finding: the chiral-index "protected massless mode" is robust only to
GRADING-PRESERVING (odd) perturbations; an EVEN (grading-diagonal) mass term GAPS it. So "immune to every
potential and transport" is false -- the honest statement is chiral-symmetry-CONDITIONAL protection
(SSH/BdG-type). Formalize this as an honest boundary theorem: exhibit the chiral zero mode, show an ODD
perturbation preserves it (true, narrow content) but an EVEN mass term makes the eigenvalue nonzero (the
kill). This confirms the protection is conditional.

## The model (finite, rational; graded 2x2 with an odd Dirac operator)

Z/2 grading `Gamma = diag(1,-1)` on `R^2`. An ODD operator anticommutes with `Gamma` (off-diagonal):
`D t = !![0, t; t, 0]` (odd, Hermitian). At `t=0` (the imbalance/critical case) `D` has a zero mode;
more relevantly, model a chiral pair where the zero mode is the kernel. Perturbations:
- ODD (grading-reversing, off-diagonal): `Podd s = !![0, s; s, 0]` -- stays odd; `D t + Podd s = D (t+s)`.
- EVEN (grading-diagonal): `Peven m = !![m, 0; 0, -m]` (a chiral/axial mass) or `!![m,0;0,m]`.

Use the explicit chiral zero-mode setup: `D0 = !![0,0;0,0]`-kernel is everything; better, take the odd
operator `A = !![0, 1; 0, 0]` (maps + to -, rank 1, so on a 2-dim graded space dim ker = 1, an exact
protected zero mode `v = ![1,0]` with `A v = 0`). Perturb `A`.

## Targets (rational; ring/norm_num/fin_cases/linarith; NO Real, NO Complex, NO nlinarith deg>=3)

1. `zero_mode_exists`: for the odd operator `A = !![0,1;0,0]`, the vector `v = ![1,0]` is a zero mode of
   the Hermitian square: `(A.conjTranspose * A).mulVec v = 0` (or use `M = !![0,1;1,0]`'s kernel setup
   -- pick a clean explicit chiral pair). Exhibit the exact zero eigenvalue. Explicit.
2. `odd_preserves` (the true narrow content): adding an ODD perturbation keeps a zero mode -- the odd
   perturbed operator still annihilates some explicit nonzero vector (or its Hermitian square retains a
   zero eigenvalue). Explicit witness (an odd `Podd s`, the zero mode persists / index unchanged).
3. `even_gaps` (payload -- the kill): adding an EVEN (grading-diagonal) mass `Peven m = !![m,0;0,-m]`
   with `m != 0` makes the mode MASSIVE -- the relevant Hermitian square `H = (A+Peven m)^# (A+Peven m)`
   has NO zero eigenvalue (its determinant is nonzero, e.g. `det H = m^2*(...) != 0`, or the least
   eigenvalue is `> 0`). Exhibit explicit `m` (e.g. `m=1`) with the gap: the previously-zero mode now
   has positive `H`-value. Explicit `norm_num`/`fin_cases`.
4. `conditional_protection_verdict` (payload): package -- the chiral zero mode is preserved by ODD
   (grading-preserving) perturbations but GAPPED by an EVEN mass term (explicit `m=1` witness making the
   eigenvalue nonzero). So the protection is chiral-symmetry-CONDITIONAL, NOT "immune to every potential":
   the honest scope is odd/grading-preserving perturbations only. Honest scope: this CONFIRMS the audit's
   kill-test -- a finite boundary result marking the protection's true (narrow) reach, matching the
   manuscript's corrected s8 wording.

MANDATORY non-degeneracy: the explicit zero mode `v`; an explicit ODD perturbation preserving it; the
explicit EVEN mass `m=1` that gaps it (with the nonzero det / positive eigenvalue as `norm_num`). All
in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL/rational 2x2 (or 4x4 if cleaner), explicit; Matrix.det/mulVec + ring/
norm_num/fin_cases/linarith; NO Real.sqrt/cos/sin, NO Complex, NO nlinarith deg>=3. Build under 3 min.
Deliver RequestProject/Main.lean (namespace EvenMassGaps) + ARISTOTLE_SUMMARY.md.
