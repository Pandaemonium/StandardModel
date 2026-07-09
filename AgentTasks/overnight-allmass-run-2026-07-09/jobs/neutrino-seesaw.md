# claude-neutrino-seesaw — the seesaw: why a Majorana partner makes the neutrino light (finite, rational)

## Context (blind to any repo; self-contained finite matrix algebra, Mathlib only)

Extends the landed Dirac/Majorana structure (NeutrinoDiracMajorana): the SEESAW mechanism is the
reason a neutrino with a heavy Majorana partner is light. A `2x2` neutrino mass matrix mixes a light
active state (no bare Majorana mass) with a heavy sterile partner (large Majorana mass `M_R`) through
a Dirac mass `m_D`. The light eigenvalue is suppressed to `~ m_D^2 / M_R` -- the heavier the partner,
the lighter the neutrino. Prove the finite, rational version WITHOUT square roots (via Vieta:
product/trace of eigenvalues), so it is fully kernel-checked.

## The model (explicit rational 2x2)

Mass matrix `M = !![0, mD; mD, MR]` (symmetric): active-active entry 0 (no bare Majorana), Dirac
off-diagonal `mD > 0`, sterile Majorana `MR > 0`. Eigenvalues `lam` solve `lam^2 - MR*lam - mD^2 = 0`.
Work with the two eigenvalues `lp` (heavy, positive) and `ln` (light, negative) via their symmetric
functions, NOT via the square-root formula.

## Targets (rational/order arithmetic; ring/norm_num/linarith deg<=2; NO Real.sqrt, NO Complex)

1. `char_vieta`: `M`'s characteristic polynomial is `X^2 - MR*X - mD^2`; hence any eigenvalue pair
   `(lp, ln)` satisfies `lp * ln = -mD^2` (det) and `lp + ln = MR` (trace). State via `Matrix.det`,
   `Matrix.trace` on the explicit `M` (both by `ring`/`norm_num` from the entries).
2. `opposite_signs`: since `lp*ln = -mD^2 < 0`, the eigenvalues have OPPOSITE signs (one positive
   `lp>0`, one negative `ln<0`) -- the light neutrino and its heavy partner. From the product being
   negative (rational, `mD != 0`).
3. `seesaw_bound` (payload): the light mass is suppressed -- `|ln| < mD^2 / MR`. Proof (no sqrt):
   `lp = MR - ln = MR + |ln| > MR` (from trace, `ln < 0`), and `|ln| = mD^2 / lp` (from det), so
   `|ln| = mD^2/lp < mD^2/MR`. All from the Vieta relations + `MR>0, mD>0`, order arithmetic
   (`div_lt_div`, `linarith`). The heavier `MR`, the lighter `|ln|`.
4. `seesaw_verdict`: package -- a heavy Majorana partner `MR` seesaws the active neutrino to a light
   mass `|ln| < mD^2/MR` of opposite sign, with product of the two masses pinned at `mD^2`
   (`lp*|ln| = mD^2`). Honest scope: a finite rational 2x2 avatar of the type-I seesaw; the two masses'
   PRODUCT is fixed and the light one is bounded by `mD^2/MR` -- a structural suppression, not a
   prediction of the physical neutrino mass.

MANDATORY non-degeneracy: explicit rationals e.g. `mD = 1, MR = 100` -> `lp*ln = -1`, `lp+ln = 100`,
`lp > 100`, `|ln| < 1/100`; a control with `MR = mD` (no suppression, `|ln| ~ mD`, bound `< mD` still
holds but not small) to show the suppression is `MR`-driven; all in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. REAL or Rational 2x2, explicit entries; det/trace/Vieta, order arithmetic
(`linarith`/`div_lt_div`/`norm_num`), degree <= 2 only; NO Real.sqrt/cos/sin, NO Complex, NO nlinarith
deg>=3. Build under 3 min. Deliver RequestProject/Main.lean (namespace NeutrinoSeesaw) +
ARISTOTLE_SUMMARY.md.
