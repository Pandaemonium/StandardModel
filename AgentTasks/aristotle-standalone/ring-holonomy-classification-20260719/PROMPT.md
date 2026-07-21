# Task: holonomy is a COMPLETE gauge invariant (A-lane classification capstone)

Project: Lean 4 (v4.28.0) + Mathlib. Five-file package: four PROVEN landed
modules (do not modify; includes the all-`n` spectral discriminator) + the
target `PhysicsSM/Draft/NullEdge/RingHolonomyClassification.lean` with two
holes.

## Targets

1. `exists_gauge_of_holonomy_eq` - **the crux**: unit-link fields with
   equal holonomy are gauge-equivalent with a unit-modulus gauge. Route
   (in the target docstring): build the gauge site-by-site walking around
   the ring from a base site (`g 0 = 1`,
   `g (k+1) = g k * u k / v k`); the closure constraint at the wrap-around
   link is exactly `holonomy u = holonomy v`; unit modulus from unit
   links. `ZMod n` induction: use `ZMod.natCast_self`-style wrap or work
   through `Fin n` representatives - your choice, but keep the STATEMENT
   unchanged. Check the landed `gaugedLinks` definition for the exact
   gauge convention (`gaugedLinks n g u k = g (k+1) * u k * (g k)⁻¹` or
   its variant - match it, do not redefine).
2. `unitarily_conjugate_of_holonomy_eq` - compose target 1 with the
   landed `HRing_gauge_conjugacy` (mind its hypotheses: `2 < n`,
   nonvanishing gauge).

With the landed `not_unitarily_conjugate_of_holonomy_re_ne_all`, this
closes the classification: holonomy classifies unit-link ring fields up
to gauge, and Re-holonomy discriminates spectra at every `n > 2`.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Statements unchanged; helpers in the target file only.
- Verify with `lake env lean PhysicsSM/Draft/NullEdge/RingHolonomyClassification.lean`.

## Success criteria

Both proven = full success. If the wrap-around bookkeeping stalls, land
the `Fin n`-indexed construction lemma + a precise report.
