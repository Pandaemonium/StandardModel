# Task: weak isospin from the colour-supported eq-37 ladder pair (S2b brick)

Project: Lean 4 (v4.28.0) + Mathlib. Physics formalization of Furey's
division-algebra Standard Model (1806.00612 / 1910.08395, composition
semantics). Self-contained package.

## Target

`PhysicsSM/Draft/NullEdge/ColourIsospinFromB.lean` - seven theorems ending
in a hole. Content: the two-mode fermionic su(2) realization

  `T3B = (1/2)(B_1‡ B_1 - B_2‡ B_2)`, `TplusB = B_1‡ B_2`, `TminusB = B_2‡ B_1`

acting on the single-excitation doublet `(slotVL, slotEL) = (B_1‡ vt, B_2‡ vt)`
with vacuum `vt = ofColour vIdem`. Expected pattern: vacuum singlet
(`T3B vt = 0`), doublet grades `(+1/2, -1/2)`, raising/lowering exchange of
the two slots, su(2) commutator closure on the upper slot.

Why this matters: the one-sided omega-nest packaging is CLOSED by the
rank-one collapse and the grading-candidate kills (see design history in the
file docstring); the colour-supported `B_j` layer is the designated
successor route for weak isospin on coloured states. These seven theorems
are the first kernel test of that route.

## Proof strategy hints

The probe layer (`CompositionCl10Probe/Ext`, included) already validated the
CAR slots `{A_1, B_1} = 0`, `{B_1, B_1‡} = 1`-on-probe, and the `j = 2`
block. The census file (`CompositionTransitionCensus`, included, PROVEN)
computes single coordinates of exactly these composites with big-`maxSteps`
simp expansions - reuse its simp-set pattern (the long lemma lists in
`mix11_slotVL_census`). Coordinate-level evaluation on the concrete states
is expected to be decisive; operator-level CAR shortcuts are optional.

## Pre-registered honesty license

If any grading value differs from the stated one by sign or scale, DO NOT
force the stated value: prove the true value, rename the theorem, and record
the mismatch prominently in the docstring. A refutation with an explicit
residual decomposition (pattern: `mix11_slotVL_census`) is a success
outcome. Do not alter the definitions.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with `lake env lean PhysicsSM/Draft/NullEdge/ColourIsospinFromB.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

All seven theorems (or honestly-corrected versions) proven, zero holes in
the target file, and a completion report: solved targets, statement
changes, remaining holes, axioms used.
