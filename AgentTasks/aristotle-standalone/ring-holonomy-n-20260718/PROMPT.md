# Task: general odd-length ring holonomy spectral witness (Paper A gate)

Project: Lean 4 (v4.28.0) + Mathlib. Null-edge program, Paper A flagship
lane. Self-contained two-file package: `RingHolonomySpectrum.lean` (PROVEN
three-site case: gauge conjugacy, holonomy invariance, cubic-trace witness)
and the target.

## Target

`PhysicsSM/Draft/NullEdge/RingHolonomySpectrumN.lean` - six theorems ending
in a hole:

1. `HRing_isHermitian` - by construction (entry-wise conjugate symmetry;
   the `2 < n` hypothesis keeps the two hop conditions disjoint).
2. `HRing_gauge_conjugacy`, `holonomy_gauge_invariant` - generalize the
   proven three-site versions verbatim.
3. `trace_pow_odd` - THE main target: for odd `n > 2` and unit links,
   `trace ((HRing n u)^n) = n * (holonomy + conj holonomy)`. Parity
   argument: expand the trace of the `n`-th power as a sum over closed
   length-`n` walks on the `n`-cycle with steps `+-1`; net displacement is
   congruent to `n` mod 2, so for odd `n` every contributing walk winds
   exactly once forward (product of all `u i` = holonomy) or once backward
   (conjugate); there are `n` starting points each.
4. `not_unitarily_conjugate_of_holonomy_re_ne` - trace of a fixed matrix
   power is a unitary-conjugacy invariant; apply 3.
5. `winding_one_not_conjugate_trivial` - specialize 4 to `-1` vs `+1`
   holonomy (`-2n /= 2n` for `n > 0`).

Consistency anchor: at `n = 3` the formula gives `3 * (-2) = -6` for
holonomy `-1`, matching the proven `trace_cube_H3` witness in the included
file - use it as a sanity check, not a dependency.

## Pre-registered honesty license

If the trace formula needs a different normalization under the stated
matrix convention, prove the TRUE formula, rename, record the mismatch
prominently, and still derive the strongest true discriminator (targets
4-5 adapted). Do not weaken the discriminator to a single fixed `n`.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/RingHolonomySpectrumN.lean` first;
  avoid a full `lake build` until the holes are closed.

## Success criteria

All six theorems (or honestly-corrected versions) proven, zero holes, and a
completion report: solved targets, statement changes, remaining holes,
axioms used.
