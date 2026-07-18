# Null-edge periodic vacuum-Weyl proper lift

Date: 2026-07-18

## Objective

Upgrade the exact additive two-site vacuum null wave to proper eta-Lorentz
link holonomies, pass it through the nonlinear action curvature extractor, and
audit both finite Palatini Euler sectors at the identity coframe.

## Result

`PeriodicVacuumWeylNullWaveProperLift.lean` proves:

- the two null-rotation polarization generators commute and have cube zero;
- exponentials in their plane truncate exactly at quadratic order and multiply
  by adding polarization coordinates;
- the exponentiated null-wave links are proper eta-Lorentz;
- every exact plaquette is the exponential of its signed additive curl, with
  no Baker-Campbell-Hausdorff correction;
- the six-probe curvature extractor returns exactly `area * curvature`; the
  quadratic exponential term is trace-orthogonal to every probe;
- every finite identity-coframe mixed vacuum Einstein entry vanishes;
- the identity coframe is exactly coframe-stationary for every finite area;
- the direction-`1`, component-`1` link Euler coefficient at site `1` is
  exactly `-2 * area`;
- at nonzero area, the identity coframe is not connection-stationary and is not
  jointly stationary.

The last result is a finite no-go for the static coframe, not a failure of the
vacuum curvature target. It isolates the next construction problem in the
independent-connection equation: a successful refinement must vary the
coframe so its covariant face-weight divergence vanishes.

## Proof architecture

The connection coefficient was first checked by an external symbolic matrix
calculation using the repo conventions. Its four native transport sums are
`-1`, `1 - area`, `1`, and `area - 1`. The Lean proof independently evaluates
those four sums from the definitions and combines them to `-2 * area`. The
symbolic calculation is oracle evidence only; the landed theorem is checked by
the Lean kernel.

Headline declarations carry build-enforced assumption-footprint guards. No
incomplete proof marker or new assumption was introduced.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/PeriodicVacuumWeylNullWaveProperLift.lean`
- `lake build PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift`
- `lake build PhysicsSM.Draft.NullEdge.GRFoundations`
- `pre-commit run --all-files`
- `lake build` (8,319 jobs)

## Remaining gate

Construct a nondegenerate varying coframe for the same proper-Lorentz links, or
a controlled deformation of them, that is jointly stationary at each finite
refinement level and converges to an invertible continuum coframe. Then prove
that the selected connection is Levi-Civita and that the limiting extracted
curvature is its Riemann curvature.

## Aristotle interaction

The previously submitted varying-coframe project
`a8d83497-34e4-4151-a122-59b821b3e587`, task
`49956b25-fb1b-4877-ac4c-7b25370d1518`, remained `RUNNING` / `IN_PROGRESS`
after this local result was proved. Harvest review must require a genuine
varying-coframe joint-stationary construction, Levi-Civita selection, or a
strictly stronger no-go theorem.
