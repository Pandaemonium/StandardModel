# Claude adversarial review: S3SelectorPhaseDiagram (81bc8433)

- Reviewer: interactive Claude Code (claude family), adversarial
- Work item: `LAB-BOOTSTRAP-001`; Source sha256 d2471f7f... verified (84 lines)
- Date: 2026-07-13

## Verdict: ACCEPT

Exhaustive phase diagram completing the `S3` quadratic-selector classification:
the sign of the transverse coefficient `a - d` trichotomizes the fixed-total
behaviour.

## Checks

- **Transverse ray identity.** `transverse_ray_identity`:
  `symmetricQuadratic a d t (-t) s = 2 (a - d) t^2 + a s^2`. At `(t, -t, s)`:
  `sum of squares = 2 t^2 + s^2`, `sum of cross = t(-t) + t s - t s = -t^2`, so
  `a (2 t^2 + s^2) + 2 d (-t^2) = 2 (a - d) t^2 + a s^2`. Correct; the ray lies on
  the fixed-total-`s` fibre (`t + (-t) + s = s`), the common mode `s` is constant,
  and `a - d` controls the `t^2` growth.
- **Every-threshold unboundedness witness + sign algebra.**
  `negative_transverse_unbounded_below`: `a < d -> forall B, exists t,
  cost < B`. `a < d` gives `d - a > 0`, so the `t^2` coefficient `2(a - d)` is
  negative. Witness `t = |M| + 1` with `M = (a s^2 - B) / (2 (d - a))`; the goal
  reduces via `hkey : 2 (d - a) M = a s^2 - B` and `ht2 : (|M| + 1)^2 > M` to a
  true `nlinarith`. Holds for EVERY threshold `B`. Sign algebra correct.
- **Three phase-diagram regimes.** `selector_phase_diagram` bundles: `d < a` ->
  unique equal-thirds selection (`symmetricQuadratic_unique_equal_thirds`);
  `a = d` -> flat non-selection (`cost = a s^2` on the fibre, via
  `fixed_total_cost_identity`); `a < d` -> unbounded-below instability
  (`negative_transverse_unbounded_below`). Exhaustive over `R` (the trichotomy
  `a > d`, `a = d`, `a < d`).
- **Non-vacuity.** The unbounded-below existence is an explicit witness; the three
  regimes are genuine and exhaustive.
- **Explicit limit -- no physical/information selector.** Docstring: "a theorem
  about the fully permutation-symmetric homogeneous quadratic family. It does not
  choose the family from physics or information theory." Correctly scoped.

## Overclaim tests

Vacuity: none (explicit witness + exhaustive regimes). Hollow: none (the
trichotomy with explicit ray witnesses is real content). Docstring overreach:
none. False shape: none -- a sign-of-`(a - d)` phase diagram over
selection/flat/instability is the correct shape.

## Verification

- `lake build ...S3SelectorPhaseDiagram`: exit 0. Three `#guard_msgs` fired;
  `[propext, Classical.choice, Quot.sound]`, build-enforced.

## Narrowest claim

For the fully permutation-symmetric homogeneous quadratic family
`symmetricQuadratic a d`, restricted to a fixed-total fibre, the sign of the
transverse coefficient `a - d` exactly determines the regime: `a > d` selects the
equal-thirds point uniquely, `a = d` is flat (cost constant `a s^2`), and `a < d`
is unbounded below (unstable, with an explicit divergent ray `(t, -t, s)`). This
is a mathematical phase-diagram classification; it makes no claim that physics or
information theory selects the family or the regime.
