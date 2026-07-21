# Task: prove the four eq-36 grading theorems (v2 - rank-one closed forms now available)

Project: Lean 4 (v4.28.0) + Mathlib. Physics formalization of Furey's
division-algebra Standard Model (1806.00612). This package is self-contained.

## Target
`PhysicsSM/Draft/NullEdge/CompositionIdealRepContent.lean` - the four
theorems currently ending in `sorry`:

1. `adT3_vwHat : adT3 vwHat d = 0`
2. `adT3_X1   : adT3 X1 d = X1 d`
3. `adT3_X2   : adT3 X2 d = -(X2 d)`
4. `adT3_X3   : adT3 X3 d = 0`

`adT3 F d = co T3' (F d) - F (co T3' d)`-style weak-isospin grading of the
eq-36 ideal operators (see file for exact definitions).

## WHAT IS NEW IN v2 (use this!)
`PhysicsSM/Draft/NullEdge/RankOneCore.lean` provides PROVEN closed forms
(mirrors of kernel-verified theorems in the parent repo; re-verify here):

  `hatOmega_rank_one    : hatOmega z    = phi z • vIdemStar`
  `hatOmegaDag_rank_one : hatOmegaDag z = psi z • vIdem`

with `phi`/`psi` explicit 4-coordinate C-valued functionals. EVERY composite
containing `hatOmega`/`hatOmegaDag` (including their `co` slot-lifts inside
`betaHat2`, `betaHat2dag`, `hatTau3`, `T3`, `PL`) collapses to
scalar-functional multiplications on the fixed states `vIdem`/`vIdemStar`.
Recommended attack: rewrite with the closed forms FIRST, then the remaining
computation is short scalar algebra plus the `R1`/`R2`/`R3` slot
permutations - not combinatorial operator rewriting. The previous run
(v1, no closed forms) built useful `R3` commutation helpers (now in the
target file) but stalled in simp-normalization blowup on `adT3_vwHat`; the
closed forms remove that blowup.

Useful facts already in the package: `hatTau3` is defined from the nests, so
`hatTau3 z = phi z • (psi-of-vIdemStar ...)`-style two-step collapses also
work; `vIdem`/`vIdemStar` are explicit literals (head-plane idempotents);
`R1_slots`/`R2_slots`/`R3_slots` give the quaternionic slot permutations.

## Normalization caution (pre-registered)
If a grading value differs from the stated one by sign or scale (e.g.
`adT3 X1 d = -(X1 d)` or `2 • X1 d`), DO NOT force the stated value: prove
the true value, rename the theorem accordingly, and record the mismatch
prominently in the docstring. A value mismatch is an honest success outcome.

## Constraints
- No new `a x i o m`/`o p a q u e`/`u n s a f e`; no `n a t i v e _ d e c i d e`.
- Keep the existing definitions EXACTLY as stated (do not weaken/alter).
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- If a theorem is FALSE as stated, prove the corrected statement and report.

## Success criteria
All four theorems (or their honestly-corrected versions) proven and the file
compiles with zero sorries.
