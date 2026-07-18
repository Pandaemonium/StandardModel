# Null-edge atlas cone gauge trivialization

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Claim grade: `M [orig/comp]`, finite group and Cech algebra only

## Question

What bundle topology can an exact transition atlas detect if all chart
overlaps share one common root chart?

## Result

`PhysicsSM/Draft/NullEdge/AtlasConeGaugeTrivialization.lean` proves that a
cone-shaped occupied nerve is gauge-trivial on every occupied edge.  If every
occupied edge `i-j` extends to an occupied triple `i-j-r`, then the chart gauge

```text
h(i) = T(i,r)
```

gives `h(i)^(-1) T(i,j) h(j) = 1` by the exact Cech cocycle.

The result is generic for every group-valued Cech transition field.  The
module also proves the eta-Lorentz specialization: one Lorentz-valued gauge
makes every occupied transition the identity, hence proper and
orthochronous. Applying any component character preserves the
trivialization.

A two-chart `Multiplicative (ZMod 2)` witness has a raw nonidentity transition
but is exact Cech data and gauge-trivial on the complete cone nerve. This
controls a common over-claim: nonidentity transition entries alone do not
diagnose a bundle obstruction.

SHA-256:
`6da5173ec8b709fea6ef53655f19822b124b2974c93683bb351999bfe77cde8f`

## Atlas consequence

The R4/R4-D atlas audits found persistent full common intersections in the
selected complete-family regime. Conditional on constructing exact
transitions there, the resulting nerve would be cone-shaped and therefore
unable to realize nontrivial orientation, time-orientation, or spin-bundle
topology. Escaping complete-family saturation is thus required both for the
bounded-multiplicity atlas target and for nontrivial topological controls.

This does not say that a cone atlas has zero connection curvature. Cech
transition data and connection transport remain separate; independent
connection holonomy can still be nontrivial.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/AtlasConeGaugeTrivialization.lean`
  passed with no warnings.
- `lake build PhysicsSM.Draft.NullEdge.AtlasConeGaugeTrivialization` passed
  8045 jobs. It replayed one pre-existing unused-variable warning in
  `AtlasTransitionHolonomy.lean`; the new module itself was clean.
- Build-enforced axiom guards report only `propext`, `Classical.choice`, and
  `Quot.sound` where expected.
- No proof handoff markers, unsafe declarations, or extra assumptions were
  added.

## Remaining gates

1. Build a bounded-multiplicity, non-cone atlas from graph-native carriers.
2. Derive compatible rank-four sectors and exact eta-Lorentz transitions on
   that atlas.
3. Evaluate and trivialize, or exhibit, the two component classes.
4. Construct concrete local `SL(2,C)` lifts and instantiate the central face
   obstruction.
5. Keep connection curvature separate and prove its continuum convergence.
