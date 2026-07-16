# Claude adversarial review: ExactFlowSchwartzGroup (debcfc09)

- Reviewer: interactive Claude Code (claude family), adversarial
- Work item: `CONT-FOURIER-001`; Source sha256 ea8d1e55... verified (93 lines)
- Date: 2026-07-13

## Verdict: ACCEPT

The F3 payoff: the proved temperate-growth theorem lifts the exact multiplier to
a genuine Schwartz-space one-parameter group.

## Checks

- **`bilinLeftCLM` packaging.** `exactFlowSchwartzCLM m t =
  SchwartzMap.bilinLeftCLM (ContinuousLinearMap.apply C Spinor)
  (momMultForGrowth_hasTemperateGrowth m t)`. Schwartz closure is PROVED, not
  assumed: `bilinLeftCLM` PRODUCES the Schwartz->Schwartz CLM from the temperate-
  growth hypothesis (itself separately proved and previously reviewed). No
  theorem silently assumes closure.
- **Pointwise-to-Schwartz lift.** `exactFlowSchwartzCLM_apply_apply` (`rfl`) gives
  the pointwise action `= momMultForGrowth m t k (f k)`; the group-law theorems
  are proved by `ext f k` (Schwartz extensionality) reducing to the pointwise
  `momMultForGrowth` identities. Genuine lift.
- **Composition order.** `exactFlowSchwartzCLM_add_time`: `U(s+t) = U(s).comp(U(t))`
  via `hmul` (`momMultForGrowth(s+t) = momMult s .comp momMult t` by
  `exactFlow_add_time` + `map_mul`) + `comp_apply`. Correct.
- **Inverse controls.** `exactFlowSchwartzCLM_mul_neg_time`: `U(t).comp(U(-t)) = id`
  for all `t`; since it is `forall`-quantified, specializing at `-t` yields
  `U(-t).comp(U(t)) = id`, so both orders are encoded.
- **Zero-time.** `exactFlowSchwartzCLM_zero_time = id` via `ext` +
  `momMultForGrowth_zero_time`.
- **Scope.** Docstring: "Schwartz-domain preservation and one-parameter-group
  theorem. It does not identify the infinitesimal generator, transport through
  Fourier transform, prove a position-space PDE, or establish a changing-lattice
  limit." Correct.

## Overclaim tests

Vacuity/hollow/overreach/false-shape: all clear. The substantive input is the
proved temperate growth; `bilinLeftCLM` + `ext` genuinely establish the
Schwartz-space group laws.

## Verification

- `lake build ...ExactFlowSchwartzGroup`: exit 0 (8047 jobs). Three `#guard_msgs`
  fired; `[propext, Classical.choice, Quot.sound]`, build-enforced.

## Narrowest claim

The exact momentum multiplier, lifted to Schwartz spinors via `bilinLeftCLM`
using its proved temperate growth, satisfies the exact zero-time identity, the
time-addition group law `U(s+t)=U(s)U(t)`, and inverse cancellation on Schwartz
space. No generator, Fourier transport, PDE, or lattice limit is claimed.
