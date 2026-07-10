# Suite A — operator-to-geometry: a finite causal spectral distance on the T2 carrier

## Context (blind to the wider repo; seeds in `seeds/`, Mathlib only)

A finite "null-edge" program models matter as a finite spectral triple
`(A, H, D, J, Gamma)`. The Euclidean Connes spectral distance is already
kernel-checked on a 2-point carrier: `seeds/SpectralDistance.lean` (namespace
`NullEdge`) defines `spectralDist D x y = sup { |f x - f y| : ‖[D,f]‖ <= 1 }`
and proves for the 2-level Dirac `Dm m` that the distance between the two points
is exactly `1/m` (`fwit_sep`, `lipBall_sep_le`). `seeds/FiniteCPT.lean`
(namespace `ConjectureR`) supplies the Krein/indefinite structure: fundamental
symmetry `Jmet` (indefinite, trace 0), grading `Gamma`, Krein adjoint
`sharp X = J Xᴴ J`, and a Krein-self-adjoint Dirac `Dop`.

**Goal (a finite Malament-flavoured statement).** Replace the Euclidean sup by
the **Lorentzian/causal** spectral distance built from the Krein structure and
show the operator data recovers geometry: (i) the CAUSAL ORDER of the finite
carrier's points/edges, and (ii) the mass SCALE, with the E-slot appearing as the
mismatch between order-derived geometry and decoration-derived scale (the
Malament split: causal order fixes the conformal class for free; decorations owe
the scale).

## Targets (land the cheapest first; a kill is a publishable result)

1. **Causal spectral distance, defined.** On a small explicit Krein carrier
   (start with the `C^2`/2-point case, then the `C^4` FiniteCPT witness), define a
   finite causal/Lorentzian spectral distance `dCausal` using Krein-positive
   "steep" functions (`f` with `[D,f]` Krein-positive / `Jmet`-causal), following
   the Franco–Eckstein causal-spectral-triple recipe `[import — clean-room, do not
   assume Mathlib has it]`. Prove it is well-defined (the sup/inf is attained on
   the finite carrier).
2. **Scale recovery.** Prove `dCausal` on the 2-point carrier is a definite
   function of the mass `m` (e.g. `= 1/m`, mirroring `fwit_sep`), so the
   decoration scale is recovered from `(A, D)` alone. **MANDATORY non-degeneracy
   fixture:** exhibit an explicit `m = 3` (or `3/5`) rational witness giving a
   specific NONZERO distance value, so "recovers scale" is not vacuous.
3. **Order recovery.** Prove the Krein/causal sign of `dCausal` (or an associated
   causal relation `x <= y`) reproduces the intended causal order of the two
   edges (a two-element order), and is antisymmetric/transitive on the carrier —
   i.e. the operator determines the order, not just the metric.
4. **(stretch) E-slot as mismatch.** State (and prove on the witness if
   tractable) that the order-derived conformal geometry and the decoration-derived
   scale can DISAGREE, the disagreement being exactly an E-slot quantity — a
   finite, kernel-level statement of "gravity = the defect of the null ruler."

## Kills (state as theorems)

- The causal spectral distance degenerates (identically `0`, `+inf`, or
  independent of `m`) — operator does NOT recover scale.
- The recovered relation is not a partial order (fails antisymmetry/transitivity)
  — operator does NOT recover causal order.

## Constraints (hard)

Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only.
Footprint exactly `[propext, Classical.choice, Quot.sound]`, verified in-file with
`#guard_msgs (whitespace := lax) in #print axioms <thm>` on every headline theorem.
Deliver `RequestProject/Main.lean` (namespace `SuiteA_Op2Geom`) +
`ARISTOTLE_SUMMARY.md`: which targets landed, the definition of `dCausal` you used,
the non-degeneracy witness value, and an honest note on the Franco–Eckstein recipe
port + anything you could only state (not prove) about the E-slot mismatch.
