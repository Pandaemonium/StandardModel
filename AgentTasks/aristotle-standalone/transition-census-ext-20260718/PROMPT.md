# Task: the full eq-39/eq-40 transition-census table (P3 step 4)

Project: Lean 4 (v4.28.0) + Mathlib. Physics formalization of Furey's
division-algebra Standard Model (1806.00612 / 1910.08395, composition
semantics). Self-contained package.

## Target

`PhysicsSM/Draft/NullEdge/CompositionTransitionCensusExt.lean` - eleven
theorems ending in a hole, completing the census that
`CompositionTransitionCensus` (included, PROVEN) started:

1. Nonvanishing of all remaining single-excitation slots
   (`slotDbar1/2/3`, `slotEL`) - pattern: the proved `slotVL_ne_zero`
   (pick one coordinate of a suitable image, show it is nonzero).
2. The `Mix11` column: full-slot upgrade of the landed colour-slot
   agreement (`mix11_slotDbar1_full`), the two distinct-colour kills
   (`mix11_slotDbar2/3 = 0`), and the `slotEL` census entry.
3. The `MixT11` sector-rotation column: `MixT11 = (-i) * Mix11` on the
   vacuum, `slotVL`, and `slotDbar1` (the landed coordinate witnesses show
   exactly this `-i` ratio at the probed coordinates).

## Why this matters

The Re7-commutant route to the eq-40 exclusion theorem was refuted by the
kernel (CORRECTION 10); the slot census is now a primary handle: "mixing
generators cross the quark/lepton slot partition" needs the full table,
including the residual structure, to be stated honestly.

## Proof strategy hints

Reuse the census file's own big-`maxSteps` simp-set pattern
(`mix11_slotVL_census`, `mix11_slotDbar1_census`) - the definitions unfold
to explicit `ComplexOctonion` coordinate arithmetic. For the `-i` ratio
theorems, compute both sides to normal form; a coordinate-wise `Dixon.ext`
split is expected.

## Pre-registered honesty license

Every expected equality may instead be returned as an explicit residual
decomposition with named nonzero coordinates (the census pattern). A
refutation with an exact residual is a SUCCESS outcome and is the census
datum. Do not alter the included definitions.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/CompositionTransitionCensusExt.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

All eleven theorems (or honestly-corrected residual versions) proven, zero
holes, and a completion report with the final census table in prose.
