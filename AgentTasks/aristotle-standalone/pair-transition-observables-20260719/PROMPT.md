# Task: the operational two-particle transition law (Paper E successor)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, Paper E lane.
Self-contained package (16 modules). The canonical exponential bridge
landed TONIGHT and is included PROVEN + guarded
(`PairExponentialCanonicalBridge`): the canonical `Uop` is the exact
matrix exponential of the canonical generator.

## Target

`PhysicsSM/Draft/NullEdge/PairTransitionObservables.lean` - five theorems
ending in a hole. The portfolio's Paper E gate asks for ONE operational
two-particle quantity; this module delivers the pair-transition law:

1. `uop_basisLow_highPair` - the transition amplitude from the low-pair
   basis state to the high-pair coordinate. Direct from the included
   `@[simp] Uop_high` closed form with `psi = basisLow` (the two basis
   coordinates evaluate to `0` and `1`; mind
   `highPair ≠ lowPair` decidability - `PlueckerQuarticInteraction`
   supplies the pair definitions and their disequality).
2. `pair_transition_prob` - the Rabi law: with `m² = z conj z`, `m > 0`,
   the amplitude's squared norm is exactly `s²` (use the included
   `unit_coefficient` for `|z/m| = 1`).
3. `pair_transition_phase_pairing` - amplitude times `z` equals
   `-i s (conj z * z)/m`: the interferometric Pluecker-phase readout
   (pure algebra from 1).
4. `singleton_immobile` - the selection rule: singleton occupation sets
   differ from both pairs (cardinality), so `Uop_off` applies.
5. `exponential_pair_transition` - THE headline: compose the landed bridge
   theorem `canonical_pair_evolution_is_exponential` with 1 at
   `c = cos (a‖z‖)`, `s = sin (a‖z‖)`, `m = ‖z‖`.

## Pre-registered honesty license

The included `Uop_low`/`Uop_high` fix the sign/conjugation conventions; if
a stated closed form differs from what they force, prove the true value,
rename, and record the mismatch prominently. Do not modify included
modules.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/PairTransitionObservables.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

All five theorems (or honestly-corrected versions) proven, zero holes,
plus a completion report: solved targets, statement changes, axioms used.
