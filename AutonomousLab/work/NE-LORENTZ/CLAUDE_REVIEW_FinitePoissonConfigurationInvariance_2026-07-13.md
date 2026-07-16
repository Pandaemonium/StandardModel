# Claude cross-family review: FinitePoissonConfigurationInvariance (0ab450fa)

- Reviewer: interactive Claude Code (claude family)
- Builder: Codex (Aristotle 0ab450fa)
- Work item: `L0-DIST-001`
- Source: `PhysicsSM/Draft/NullEdge/FinitePoissonConfigurationInvariance.lean`
  (121 lines), sha256 52df7902... verified
- Date: 2026-07-13

## Verdict: ACCEPT

## Construction

- `Config X = Sigma n:Nat, (Fin n -> X)` -- a finite labelled configuration
  (count `n` plus `n` positions).
- `posLaw P n = Measure.pi (fun _:Fin n => P)` -- `n` i.i.d. positions.
- `configLaw r P = (poissonMeasure r).bind (fun n => (posLaw P n).map (Sigma.mk n))`
  -- draw a Poisson count, then i.i.d. positions: the mixed-Poisson finite
  configuration law.
- `configMap T c = <c.1, fun i => T (c.2 i)>` -- apply `T` to each position,
  keep the count.

## Item-by-item

- **Map measurability.** `measurable_configMap` (T measurable => configMap T
  measurable) via `measurable_sigma_of` + `measurable_sigmaMk` (two local helpers
  filling missing Mathlib sigma-measurable-space API) composed with
  `measurable_pi_lambda`. Helpers are proved from `Sigma.instMeasurableSpace` /
  `measurableSet_iInf`, correct.
- **Bind measurability / commutation.** `map_bind_of_measurable`:
  `(m.bind f).map g = m.bind (fun a => (f a).map g)` for measurable `g`, `f`,
  via `Measure.join_map_map` + `Measure.map_map`. In the main proof the Poisson
  kernel's measurability is `measurable_from_nat` (discrete Nat domain).
- **Product-law preservation.** The load-bearing step is
  `measurePreserving_pi (fun _ => P)(fun _ => P)(fun _ => hT)`: the `n`-fold
  product map of a `P`-preserving `T` preserves `posLaw = Measure.pi P`. Combined
  with `configMap ∘ Sigma.mk = Sigma.mk ∘ (pointwise T)` (`hcomp`, by `rfl`) and
  the bind/map pushes, this gives the full law preservation.
- **Statement fidelity.** `configLaw_invariant`:
  `MeasurePreserving T P P => map (configMap T) (configLaw r P) = configLaw r P`.
  Faithful: one-point-law preservation lifts to the whole configuration law.
- **Standard-three guard.** Three in-file `#guard_msgs` blocks
  (measurable_configMap, configLaw_invariant, configLaw_invariant_id) each pin
  `[propext, Classical.choice, Quot.sound]`.
- **Non-vacuity.** `configLaw_invariant_id` (identity control) plus the fact the
  theorem holds for any genuine `P`-preserving `T` (a non-preserving `T` would
  break it) -- not vacuous.
- **Scope boundary.** Docstring: "an invariance-in-distribution theorem. It does
  not say that an individual configuration is pointwise fixed, construct an
  infinite-volume point process, or establish Lorentz invariance for a decorated
  physical model." Correct: `Config` is genuinely finite-volume (finite count,
  finite position tuple), and the conclusion is a `Measure.map` equality
  (invariance in law), not a pointwise fixed point.

## Overclaim tests

Vacuity: none (id control + genuine hypothesis). Hollow: none (real
bind/map/product-measure assembly). Docstring overreach: none (disclaims
pointwise/infinite-volume/Lorentz). False shape: none -- "P-preserving T lifts to
configuration-law-preserving configMap T" is the correct finite point-process
equivariance shape.

## Relationship to the L0-DIST pair

This is the POSITIVE companion to `L0DecorationInvarianceKill`: an EQUIVARIANT
transformation (a `P`-preserving `T` applied to every position) preserves the
configuration law, whereas a NON-equivariant fixed-frame mark breaks it. Together
they make equivariance the explicit gate. Scopes are consistent and neither
overclaims a Lorentz theorem.

## Independent verification

- `lake build PhysicsSM.Draft.NullEdge.FinitePoissonConfigurationInvariance`:
  Build completed successfully (8026 jobs), exit 0. The three in-file
  `#guard_msgs` blocks fired and passed; axiom footprint
  `[propext, Classical.choice, Quot.sound]`, build-enforced.

## Narrowest defensible claim

For the finite-volume mixed-Poisson configuration law (a Poisson count of i.i.d.
positions drawn from a one-point law `P`), any measurable transformation `T`
preserving `P` induces a configuration map that preserves the whole
configuration law in distribution. This is invariance in law for finite labelled
configurations only; it constructs no infinite-volume point process and
establishes no Lorentz invariance.
