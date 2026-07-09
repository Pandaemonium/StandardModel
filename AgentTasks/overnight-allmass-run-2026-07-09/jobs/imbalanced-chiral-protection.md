# claude-imbalanced-chiral-protection — the CORRECT chiral protection: imbalanced grading => EVERY odd perturbation preserves a zero mode (replacing the rigged balanced toy)

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

A definitions-level audit showed that a *balanced* 2D graded toy CANNOT demonstrate chiral zero-mode
protection: with `dim H+ = dim H-` the index is 0, and a generic odd perturbation (the physical Dirac
mass) gaps the mode. The GENUINE chiral (index / SSH-BdG) protection requires an IMBALANCED grading
(`dim H+ != dim H-`, nonzero index). Prove the correct statement: for an imbalanced grading, EVERY odd
operator has a zero mode in the larger chirality sector, robust to EVERY odd perturbation (a rank/
dimension argument), while an even perturbation can break the grading. This is the honest replacement for
the rigged balanced example.

## The model (finite, rational; imbalanced 3-dim grading)

Grading `Gamma = diag(1, 1, -1)` on `Q^3`: `H+ = span(e0,e1)` (dim 2), `H- = span(e2)` (dim 1), so the
index `dim H+ - dim H- = +1`. An ODD operator (anticommuting with `Gamma`) is block-off-diagonal:
`D b0 b1 c0 c1 = !![0,0,b0; 0,0,b1; c0,c1,0]` (the `H- -> H+` column `(b0,b1)` and the `H+ -> H-` row
`(c0,c1)`). The `H+ -> H-` part is the `1x2` map `C = (c0, c1)`. An EVEN perturbation is grading-diagonal,
e.g. `E m = diag(0,0,m)` or `diag(m,0,0)`.

## Targets (rational; ring/norm_num/decide/fin_cases + rank/kernel; NO Real, NO Complex, NO nlinarith deg>=3)

1. `D_is_odd`: `Gamma * (D b0 b1 c0 c1) = - (D b0 b1 c0 c1) * Gamma` for all coefficients (D anticommutes
   with Gamma). `E m = diag(a,b,c)`-type is even (`Gamma * E = E * Gamma`). By `fin_cases`/`ring`.
2. `index_is_one`: the grading is imbalanced -- `dim H+ = 2`, `dim H- = 1`, so `index = 1`. State via the
   trace of Gamma (`tr Gamma = 1 = dim H+ - dim H-`) or the explicit dimensions.
3. `odd_has_zero_mode` (payload -- the CORRECT protection): for EVERY odd `D` (any `b0 b1 c0 c1`), there
   is a NONZERO `v in H+` with `D v = 0`. Reason: the `H+ -> H-` block `C = (c0,c1)` is a `1x2` map, so
   its kernel is at least `2 - 1 = 1`-dimensional -- an explicit nonzero `v = (c1, -c0, 0)` satisfies
   `C.mulVec (v restricted) = c0*c1 - c1*c0 = 0` and lies in `H+`, and `D v = 0` (the `H-` component is
   0 since `v` has no `e2` part and `C v = 0`). Exhibit `v = ![c1, -c0, 0]` and prove `D ... v = 0` for
   ALL `c0,c1,b0,b1` (when `(c0,c1) != 0`; and if `(c0,c1)=0` then `e0` itself is a zero mode). So the
   zero mode survives EVERY odd perturbation -- genuine robustness, not cherry-picked.
4. `even_can_gap` (the honest contrast): an even perturbation CAN lift the protection by breaking the
   pure-odd structure -- exhibit an even `E` and a base odd `D0` such that `D0 + E` has NO zero mode in
   `H+` (e.g. `E = diag(m,0,0)` shifts `e0`). Explicit witness with `det != 0` on the relevant block.
5. `chiral_protection_verdict`: package -- for the imbalanced grading `Gamma=diag(1,1,-1)` (index 1),
   EVERY odd perturbation preserves a zero mode in `H+` (`odd_has_zero_mode`, the `1x2`-kernel argument),
   which is the genuine index/SSH-BdG chiral protection; an even (grading-breaking) term can gap it. This
   is what the balanced 2D toy could NOT show. Honest scope: finite rational avatar; the robustness is
   the rank argument for imbalanced gradings (the real content), not a cherry-picked example.

MANDATORY non-degeneracy: explicit odd witnesses (e.g. `b=c=(1,1)`) with the zero mode `v=![1,-1,0]`;
the generic-odd robustness for symbolic `c0,c1`; an explicit even gap witness; `tr Gamma = 1`. All in-theorem.

## Constraints (HARD -- buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only. Footprint exactly
[propext, Classical.choice, Quot.sound]; in-file `#guard_msgs (whitespace := lax) in #print axioms
<thm>` on every headline. Rational `3x3` matrices + `mulVec`; fin_cases/ring/norm_num/decide; NO
Real.sqrt/cos/sin, NO Complex, NO nlinarith deg>=3. Build under 3 min. Deliver RequestProject/Main.lean
(namespace ImbalancedChiralProtection) + ARISTOTLE_SUMMARY.md.
