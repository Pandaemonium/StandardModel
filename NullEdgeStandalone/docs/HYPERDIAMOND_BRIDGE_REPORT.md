# Hyperdiamond Bridge Report

Date: 2026-07-01

Aristotle project:

```text
359b4428-8c43-4f89-b43d-07815dbfb3a6
```

Aristotle task:

```text
d9b0e9a0-1928-49e0-8e53-826c521427b9
```

This report records the bridge/audit layer integrated into
`PhysicsSM.Draft.NullEdgeHyperdiamondBridge`.

## Claim Boundaries

The bridge module adds reconstruction and audit content only:

- no-go content remains in `NullEdgeActualCliffordSymbol` and
  `NullEdgeHyperdiamondNoGo`;
- reconstruction/frame content remains in `DualSolderSymbolKinetic` and
  `TetrahedralHighMomentumNullBranch`;
- the projected/Wilson release APIs remain frozen conditional schemas;
- no physical release theorem is added.

No Borici-Creutz or named hyperdiamond operator equivalence is claimed. The
package still has no concrete finite-difference operator with those conventions.
The proved content is the exact frame identity and the shared symbol-square
contract supported by the current definitions.

## Integrated Lean Content

Module:

```text
PhysicsSM.Draft.NullEdgeHyperdiamondBridge
```

New checked facts:

- `hyperdiamond_crosswalk_exact`: the Gate C tetrahedral dual frame equals the
  complexification of the dual-soldered tetrahedral frame, entry by entry. The
  only convention conversion is `sqrt 3 / 4 = (3 / 4) / sqrt 3`.
- `dualSolder_symbol_matches_gateC_symbol`: for a real coefficient vector, the
  Gate C symbol covector `pCov` is the complexification of the dual-soldered
  tetrahedral covector, and its Gate C Clifford symbol squares to `qform`.
- `gateC_symbol_sq_kinetic`: standalone Gate C statement that
  `cliffordSymbol (pCov u)^2 = qform u * 1`.
- `dualSolder_and_gateC_share_square_law`: both the abstract dual-soldered
  symbol and the Gate C matrix symbol obey the same principal-symbol-square
  contract.
- `nielsenNinomiya_assumption_ledger`: a represented-data ledger bundling the
  finite facts already formalized: corner classification, Clifford square law,
  balanced-kernel no-go, tetrahedral biorthogonality, and resolution of
  identity.
- `chiralProj_idempotent`: the sufficient chirality projector from the no-go
  module is genuinely idempotent.

## Nielsen-Ninomiya Ledger

Represented in Lean:

- Brillouin-corner classification at `{0, pi}^4`;
- Clifford symbol-square law;
- high-momentum null branches;
- balanced branch kernels and single-sign no-go;
- tetrahedral dual-frame biorthogonality and resolution of identity.

Not represented:

- locality or finite range of a position-space operator;
- Hermiticity or Krein self-adjointness of the concrete symbol;
- exact chiral symmetry as an operator identity;
- topological index, winding, anomaly transport, or continuum limit;
- gauge covariance.

Therefore this is not an instance of the Nielsen-Ninomiya theorem. It is a
finite assumption ledger showing which hypotheses currently have Lean
referents and which remain absent.

## chiralProj Audit

`chiralProj_idempotent` supports the sufficiency reading:

```text
if chiralProj is supplied, it selects one chirality sign.
```

It does not make `chiralProj` physical projected-operator data. For that, the
project still needs locality/finite range, gauge covariance, Krein sign audit,
and branch data derived from a concrete operator rather than hand-filled signs.
See [`CHIRALPROJ_AUDIT.md`](CHIRALPROJ_AUDIT.md).
