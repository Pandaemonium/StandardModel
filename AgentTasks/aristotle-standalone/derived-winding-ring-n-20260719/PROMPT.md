# Task: Paper A completion brick - derived winding-one rings at every odd length

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, Paper A lane.
Self-contained package (19 modules). Everything upstream is PROVEN and
landed tonight: `RingHolonomySpectrumN` (odd-n trace-power discriminator),
`RingHolonomyHalfLinkN` (turning 2pi => holonomy -1 => not conjugate to
trivial), and the ALREADY-GENERIC derived-winding layer
(`PlueckerWindingDerived`: `linkIncrement`, `totalTurning` over any
`ZMod L`).

## Target

`PhysicsSM/Draft/NullEdge/DerivedWindingRingN.lean` - two theorems ending
in a hole:

1. `holonomy_derivedHalfLinkN` - since `derivedHalfLinkN L z =
   halfLinkField L (linkIncrement z)` and `totalTurning z = ∑ p,
   linkIncrement z p` DEFINITIONALLY, this is
   `holonomy_halfLinkField` applied at `delta = linkIncrement z` with
   `hsum` rewritten through the `totalTurning` definition (one unfold +
   apply; add a small rewriting helper if a coercion resists).
2. `derived_winding_one_not_conjugate_trivial` - compose with
   `halfLink_ring_not_conjugate_trivial` (same instantiation).

## Constraints

- Do not modify included modules. No new axioms/escapes; standard axioms
  only ([propext, Classical.choice, Quot.sound]).
- Verify with `lake env lean PhysicsSM/Draft/NullEdge/DerivedWindingRingN.lean`.

## Success criteria

Both theorems proven, zero holes, completion report with axioms used.
This closes Paper A's ring-holonomy chain end-to-end from derived Pluecker
data at arbitrary odd length.
