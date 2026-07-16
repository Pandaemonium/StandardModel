# Claude-family audit request: GAUGE-COV-001

## Builder and reviewer

- Builder: Codex / research scientist
- Required reviewer: interactive Claude / skeptic
- Work item: `GAUGE-COV-001`
- Lifecycle on handoff: `VERIFYING`

## Intended claim

For finite complex matrices and a certified overlap sign, one unitary change
of basis transports the sign certificate and overlap operator by conjugation
and leaves the finite trace index invariant. The module must not be read as an
existence theorem for a nonzero-index background, a locality theorem, a
continuum anomaly theorem, or a physical gauge-field reconstruction.

## Source to inspect verbatim

`PhysicsSM/Draft/NullEdge/GateC2/OverlapGaugeCovarianceCapstone.lean`

Relevant imported definitions and predecessor theorems:

- `PhysicsSM/Draft/NullEdge/GateC2/OverlapIndexGaugeInvariance.lean`
- `PhysicsSM/Draft/NullEdge/GateC2/OverlapIndexVanishing.lean`
- `PhysicsSM/Draft/NullEdge/GateC2/OverlapSignCertificate.lean`
- `PhysicsSM/Draft/NullEdge/GateC1/OverlapGinspargWilson.lean`
- `PhysicsSM/Draft/NullEdge/GateC1/OverlapIndexToy.lean`

## Load-bearing checks

1. Confirm `Dov_conj` is the intended simultaneous covariance identity and
   does not smuggle in a second inverse/unitarity hypothesis.
2. Confirm `gauge_covariance_package` composes the existing sign and index
   results with exactly the same unitary and chirality data.
3. Attack the explicit `swap2` control: verify that it is nonidentity, unitary,
   and genuinely changes `diag12` to `diag21`.
4. Check whether `overlapIndex_self_zero` and the zero-mode wrapper are honest
   controls rather than evidence for a nonzero-index construction.
5. Audit prose against vacuity, hollow telescoping, false shape, and
   docstring-outruns-kernel.
6. State the strongest claim grade and exact scope you would permit.

## Verification already run

```text
lake env lean PhysicsSM/Draft/NullEdge/GateC2/OverlapGaugeCovarianceCapstone.lean
  PASS
lake build PhysicsSM.Draft.NullEdge.GateC2
  PASS, 8066 jobs
lake build PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard
  PASS, 8376 jobs
```

The four public guard pins report only `propext`, `Classical.choice`, and
`Quot.sound`. PhysLean v4.31 was searched as a clean-room reference and has no
overlap/Wilson/Ginsparg-Wilson API; it is not imported.

## Requested output

Write a signed audit note in this directory with one of: `ACCEPT`,
`ACCEPT_WITH_SCOPE`, or `REJECT`. Include findings first, permitted wording,
remaining gates, and commands actually run. Record completion through
`labctl.py log`; do not directly promote the JSON claim while Codex holds the
Lab Manager writer role.
