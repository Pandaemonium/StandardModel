# Task: the eq-36 isospin-grading family no-go (linear span of the killed candidates)

Project: Lean 4 (v4.28.0) + Mathlib. Physics formalization of Furey's
division-algebra Standard Model (1806.00612). Self-contained package.

## Target

`PhysicsSM/Draft/NullEdge/IsospinGradingFamilyNoGo.lean` - all seven theorems
currently ending in a hole. The mathematical content:

The previous run (`IsospinGradingSearch.lean`, included, PROVEN) killed three
point candidates for the doublet grading `(0,+1,-1,0)` on the ideal operators
`(vwHat, X1, X2, X3)`: `G_R` has grading vector `(0,2,2,0)`, `G_PL` has
`(0,1,1,2)`, `G_R_normalized` has `(0,1,1,0)`. The obstruction is always
SAME-SIGN on `X1`/`X2`. This job upgrades the point kills to the family kill:
`adG` is linear in the grading operator, so every member of the span
`famG a b e = a G_PL + b G_R + e id` grades `X1` and `X2` by the SAME
coefficient `a + 2b`; hence the `(+1,-1)` separation is impossible.

1. `adG_add`, `adG_smul_X1`, `adG_id` - linearity plumbing (short).
2. `famG_X1`, `famG_X2` - the affine grade computation. Use the PROVEN
   closed forms: `hatOmega_rank_one`, `hatOmegaDag_rank_one` (RankOneCore),
   the `R1_slots/R2_slots/R3_slots` permutations, and the landed grading
   theorems in `IsospinGradingSearch` (`adG_R_X1` etc.); the intended proof
   is linear combination of the landed identities, NOT a fresh coordinate
   expansion.
3. `famG_no_sign_separation` - the no-go. The scalar-extraction step needs a
   nonzero value of `X1`/`X2` on a concrete state; ADD a small nonzero
   witness lemma if none is available (pattern: evaluate on `ofColour vIdem`
   coordinates; the operators are built from `betaHat`s whose rank-one
   closed forms make single coordinates cheap).

## Pre-registered honesty license

If `famG_X1`/`famG_X2` are false as stated (wrong coefficient), prove the
true coefficient identities, rename accordingly, and STILL derive the
strongest true version of the final no-go (equal-coefficient obstruction).
Do not weaken `famG_no_sign_separation` beyond what the corrected
identities force; record any correction prominently in docstrings.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Keep all existing definitions EXACTLY as stated.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with `lake env lean PhysicsSM/Draft/NullEdge/IsospinGradingFamilyNoGo.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

All seven theorems (or honestly-corrected versions) proven, zero holes in
the target file, and a short completion report: solved targets, statement
changes, remaining holes, axioms used.
