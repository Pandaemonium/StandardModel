# Claude cross-family review: L0DecorationInvarianceKill (ac97f093)

- Reviewer: interactive Claude Code (claude family)
- Builder: Codex (Aristotle ac97f093)
- Work item: `L0-DIST-001`
- Source: `PhysicsSM/Draft/NullEdge/L0DecorationInvarianceKill.lean` (76 lines),
  sha256 d502d9c8... verified
- Date: 2026-07-13

## Verdict: ACCEPT

## Statement

`arbitrary_decoration_breaks_invariance`: there exist a probability law `P` and a
measure-preserving symmetry `T` such that the decorated joint pushforward
`map (x |-> (T x, x)) P` differs from `map (x |-> (x, x)) P`. Reading: the
marginal law is `T`-invariant, but a fixed-frame mark (the retained original
coordinate) makes the decorated JOINT law non-invariant.

## Item-by-item

- **Uniform-Bool probability measure.** `P = (PMF.uniformOfFintype Bool).toMeasure`
  (1/2, 1/2); `IsProbabilityMeasure` by `inferInstance`. Valid.
- **`Bool.not` measure preservation.** `MeasurePreserving Bool.not P P` proved:
  `PMF.toMeasure_map`, then pointwise `PMF.map_apply` + `uniformOfFintype_apply`
  + `tsum_bool` + `cases b <;> simp`. Swapping true/false preserves the uniform
  law. Correct.
- **Singleton preimages + 0-vs-1/2 separation.** On `{(true, true)}`:
  - LHS `(fun x => (Bool.not x, x))^{-1} {(true,true)} = empty` (`hlhs`, since
    `not x = true` and `x = true` are incompatible), so LHS measure `= 0`.
  - RHS `(fun x => (x, x))^{-1} {(true,true)} = {true}` (`hrhs`), so RHS measure
    `= P {true} = 2^{-1} = 1/2`.
  The contradiction from assuming equality reduces to `0 = 2^{-1}` in `ENNReal`,
  killed by `ENNReal.inv_eq_zero` -> `2 = top`, refuted by `2 != top`. The
  0-vs-1/2 separation is exactly right.
- **Existential / typeclass witness validity.** `refine <Bool, inferInstance,
  ..., inferInstance, Bool.not, <measurability, _>, _>` supplies valid
  `MeasurableSpace Bool` and `IsProbabilityMeasure` instances; measurability
  obligations discharged.
- **Scope wording.** Docstring: "an abstract finite distributional
  counterexample. It does not prove a Lorentz theorem, classify point-process
  decorations, or show that every frame decoration breaks Lorentz invariance.
  Its role is to make equivariance an explicit necessary gate rather than an
  implicit assumption." Correctly scoped -- this is a NECESSITY-of-equivariance
  negative control, not a Lorentz or point-process classification theorem, in
  line with the L0-DIST decoration-no-go strategy and the project's
  order-vs-decoration (Malament-split) discipline.

## Overclaim tests

- Vacuity: none -- the counterexample genuinely uses a nontrivial symmetry
  (`Bool.not`); with `T = id` the two laws would coincide, so the `!=` is
  substantive.
- Hollow telescoping: none -- the joint-law inequality is real content.
- Docstring overreach: none -- explicitly disclaims Lorentz/classification.
- False shape: none -- "measure-preserving symmetry + non-equivariant mark
  breaks joint invariance" is the correct shape for the intended gate.

## Independent verification

- `lake build PhysicsSM.Draft.NullEdge.L0DecorationInvarianceKill`: Build
  completed successfully (8026 jobs), exit 0. The in-file `#guard_msgs` block
  fired and passed; axiom footprint `[propext, Classical.choice, Quot.sound]`,
  build-enforced.

## Narrowest defensible claim

There is a finite probability law (uniform on `Bool`) and a measure-preserving
symmetry (`Bool.not`) for which decorating with an unchanged fixed-frame mark
makes the joint law non-invariant (`map (x |-> (T x, x)) P != map (x |-> (x, x))
P`, differing 0 vs 1/2 on `{(true,true)}`). This is a finite negative control
establishing equivariance of the decoration as a NECESSARY gate; it is not a
Lorentz theorem, a point-process decoration classification, or a claim that every
frame decoration breaks invariance.
