# Claude adversarial review: S3QuadraticSelectorClassification (909624b6)

- Reviewer: interactive Claude Code (claude family), adversarial
- Work item: `LAB-BOOTSTRAP-001`; Source sha256 7d3ad976... verified (104 lines)
- Date: 2026-07-13

## Verdict: ACCEPT

Complete permutation-natural quadratic classification + fixed-total selector,
honestly scoped as mathematics (not a claim that physics selects a metric).

## Checks

- **iff extraction for all six coefficients.** `full_s3_invariance_iff`:
  invariance under swap(x,y) AND swap(y,z) `<->` `a = b and b = c and d = e and
  e = f`. Swap(x,y) forces `a = b` (x^2/y^2) and `e = f` (xz/yz); swap(y,z)
  forces `b = c` and `d = e`; together the six reduce to `{a = b = c, d = e = f}`.
  The `->` uses `linarith` on unit/pair evaluations `h 1 0 0`, `h 1 1 0`, ...;
  `<-` by `grind`. Correct and complete.
- **Cross-term factor-two convention.** `quadratic6 = a x^2 + b y^2 + c z^2 +
  2 d x y + 2 e x z + 2 f y z`. Conventional factor of two, as documented.
- **Fixed-total identity / only `a - d` controls.** `fixed_total_cost_identity`:
  on `x + y + z = s`, `symmetricQuadratic a d = (a - d)(x^2+y^2+z^2) + d s^2`
  (using `2(xy+xz+yz) = s^2 - (x^2+y^2+z^2)`). The `d s^2` term is CONSTANT on
  the fibre, so all selector information is in `a - d`.
- **Uniqueness direction + load-bearing `d < a`.**
  `symmetricQuadratic_unique_equal_thirds`: `d < a` (transverse strict convexity),
  `x + y + z = s`, and cost `<=` cost at equal thirds force `x = y = z = s/3`, via
  `positive_symmetric_unique_equal_thirds (0 < a - d)`. `d < a` is load-bearing:
  it is exactly the `a - d > 0` strict-convexity that makes equal thirds the
  unique fibre minimizer.
- **Distinct-metric control.** `distinct_symmetric_metrics`:
  `symmetricQuadratic 1 0 != symmetricQuadratic 2 1` as functions -- yet both have
  `a - d = 1`, so they induce the SAME selector: non-canonicity of the metric.
- **Flat-boundary control.** `transverse_boundary_flat`: at `a = d = 1`, the cost
  is constantly `1` on every unit-total fibre -- confirming the necessity of the
  strict `d < a`.

## Overclaim tests

Vacuity: none (distinct-metric + flat-boundary controls, genuine classification).
Hollow: none (six-to-two reduction + fixed-total identity + unique minimizer are
real content). Docstring overreach: none -- "It does not claim that physics or
information theory chooses either remaining coefficient." False shape: none -- a
permutation-invariant quadratic classification plus fixed-total selector is the
correct shape; the docstring cleanly separates permutation-naturality (reduces
coefficients) from strict convexity (selects equal thirds).

## Verification

- `lake build ...S3QuadraticSelectorClassification`: exit 0 (8027 jobs). Three
  `#guard_msgs` fired; `[propext, Classical.choice, Quot.sound]`, build-enforced.

## Narrowest claim

The homogeneous real quadratic forms in three channels invariant under the two
adjacent swaps are exactly those with all diagonal coefficients equal and all
cross coefficients equal; and among such fully symmetric forms, any with strict
transverse convexity (`d < a`) has equal thirds as its unique minimizer on each
fixed-total fibre, with the common-mode coefficient `d` contributing only a
fibre-constant. This is a mathematical classification/selector theorem; it makes
no claim that physics or information theory selects a particular coefficient or
metric.
