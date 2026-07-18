# Null-edge carrier causal-time functional

Date: 2026-07-16

Work item: `GRAV-GROWING-ATLAS-001`

Status: kernel-checked and built

## Candidate

For a marked carrier `A = (bottom, top)`, define

```text
tau_A(f) = f(top) - f(bottom).
```

This is a graph-native linear functional: it uses only the strict causal order
and the endpoints already carried by the Alexandrov chart.  It gives a natural
sign convention for the zeroth vector of a selected rank-four frame without
choosing any spatial handedness.

The Lean module proves:

1. the endpoints are distinct;
2. `tau_A` is nonzero on the full zero-sum carrier probe space;
3. an explicit endpoint-difference probe has contrast two;
4. `tau_A` and its selected-sector restriction are exactly equivariant under
   every finite causal-order isomorphism;
5. the future-signed-frame predicate is therefore label independent.

## Selector gate

Nonzero on the full probe space does not imply nonzero on the selected
rank-four sector.  A graph-native sector selector must pass:

```text
sectorEndpointContrast != 0.
```

For a Lorentzian sector, the metric dual of this functional must additionally
be timelike.  If the restriction vanishes or its dual is null/spacelike at a
nonvanishing asymptotic rate, the endpoint-based time-orientation route is
killed for that selector.

## Overlap gate

Local endpoint signs alone do not prove global time orientability.  On every
retained pair overlap, the induced Lorentz transition must preserve the chosen
future component.  Equivalently, its time-component character must be zero
after a consistent chart-sign gauge.  The generic obstruction algebra is now
in `AtlasComponentCharacter.lean`; the concrete character multiplication law
is now kernel-checked in `LorentzComponentCharacter.lean` (Aristotle project
`f3a64d3b-b82b-42c9-8bce-715a9a5f4447`).

## Claim boundary

- Endpoint functional and relabeling covariance: finite `M` after verification.
- Nonblind/timelike selected-sector restriction: open empirical and analytic
  gate.
- Global time orientation of the derived atlas: open.
- Spatial orientation remains an independent obstruction.

## Verification record

- Module SHA-256:
  `aa843b21879b82eb5bf7cf21e1049931b7281a76925c1b0053cc178be1011cfb`.
- Lean LSP diagnostics passed with no errors or warnings.
- Independent axiom/source audits passed for the explicit contrast witness and
  order-isomorphism covariance theorem, with only `propext`,
  `Classical.choice`, and `Quot.sound`.
- `lake build PhysicsSM.Draft.NullEdge.CarrierCausalTimeFunctional` passed
  (`8037` jobs).
