# Goal III rung (e) — discrete boost covariance emerges at criticality

## Context (blind to the wider repo; seeds in `seeds/`, Mathlib only)

The exact rational RG of the null-edge chain carrier already landed
(`seeds/Goal3ExactRG.lean`, namespace `Goal3ExactRG`): the two-site decimation
`R(lam,kap) = (lam - 2 kap^2/lam, -kap^2/lam)` leaves the critical line
`|kap| = |lam|` invariant, the linearization has relevant eigenvalue exactly 2
(`nu = 1`), and on the critical line the Dirac mass shell is conical `omega = ±k`
(`z = 1`, `conical_dispersion_z_eq_one`). `seeds/ContinuumLimit.lean` (namespace
`...ContinuumLimit`) gives the Dirac quantum walk `Ustep k theta = Ushift k *
Ucoin theta` and its mass shell; `seeds/SubluminalBound.lean` gives `v_g <= 1`
with equality iff massless.

**The remaining rung.** Relativity should be BORN at the fixed point: the
massless (critical) walk should carry an exact DISCRETE boost covariance, and
this covariance should FAIL off the critical line — so "Lorentz symmetry emerges
at criticality" becomes a theorem pair (Arrighi–Facchini–Forets discrete Lorentz
covariance of the Dirac quantum walk `[import — clean-room, do not assume in
Mathlib]`).

## Targets (a theorem pair; the kill and the win are equally valuable)

1. **`massless_walk_boost_covariant`.** On the massless line (`theta = 0`, or the
   critical `kap = lam` walk), construct an explicit discrete boost operator
   `Lambda(rapidity)` — a `2x2` real/complex hyperbolic-rotation-like map on the
   `(k, omega)` or momentum data (rational hyperbolic Pythagorean data, e.g. the
   `3-4-5`-type boost `!![5/3, 4/3; 4/3, 5/3]/...` normalized so `det = 1`,
   preserving `omega^2 - k^2`) — and prove the massless walk's dispersion /
   one-step evolution is COVARIANT under it: the mass shell `omega = ±k` maps to
   itself, and the walk transforms as a spinor under `Lambda` (an intertwining
   identity `U(Lambda . p) = S(Lambda) U(p) S(Lambda)^{-1}` or the dispersion-set
   invariance, whichever you can land cleanly).
   **MANDATORY non-degeneracy fixture:** exhibit an explicit NONTRIVIAL rational
   boost (rapidity != 0, e.g. the 3-4-5 boost) with `Lambda != identity` on which
   covariance holds — so it is not the trivial `Lambda = 1` statement.
2. **`massive_walk_boost_covariance_fails`.** Off the critical line (a massive
   walk, `theta != 0` / `kap != lam`), the SAME boost family does NOT preserve the
   (now hyperbolic-shifted) mass shell `cos omega = cos k cos theta`: exhibit an
   explicit rational boost + momentum where the boosted point leaves the mass
   shell. So boost covariance is a critical-point phenomenon.

Together: boost symmetry is emergent — exact on the massless line, broken off it.

## Kills (state as theorems)

- The massless walk is NOT boost covariant for any nontrivial `Lambda` (relativity
  does not emerge — a major negative).
- The massive walk IS boost covariant too (boost symmetry is not special to
  criticality — the emergence claim dies).

## Constraints (hard)

Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only.
Footprint exactly `[propext, Classical.choice, Quot.sound]`, verified in-file with
`#guard_msgs (whitespace := lax) in #print axioms <thm>` on every headline theorem.
Deliver `RequestProject/Main.lean` (namespace `Goal3BoostCov`) +
`ARISTOTLE_SUMMARY.md`: the boost operator you used, the nontrivial rational boost
witness, which of the two theorems landed, and an honest note on the exact form of
the covariance (spinor intertwiner vs mass-shell-set invariance) you proved.
