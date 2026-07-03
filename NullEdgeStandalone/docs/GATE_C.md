# Gate C Status

Gate C is the branch-release problem for the flat tetrahedral null-edge symbol.
This package includes the finite branch data and the current release-audit APIs.
For a compact assumption ledger, see
[`GATE_C_ASSUMPTION_LEDGER.md`](GATE_C_ASSUMPTION_LEDGER.md).

## Claim Labels

- **finite identity**: checked algebra about the finite branch/symbol data.
- **no-go theorem**: checked obstruction for the stated finite object.
- **conditional schema**: typed release API with hypotheses not yet derived from
  a concrete operator.
- **consistency check**: finite audit separating necessary from sufficient
  conditions.
- **physical non-claim**: interpretation deliberately not asserted.

## What Is Proved

Claim label: **finite identity**.

`PhysicsSM.Draft.TetrahedralHighMomentumNullBranch` proves finite corner data:

- the origin is coefficient-zero null;
- the four three-pi corners are nonzero null corners;
- the warning corner `(pi, pi, pi, 0)` is null even though its coefficient vector
  is nonzero;
- the 16 corners split as 1 origin, 4 nonzero null, 10 spacelike, 1 timelike.

`PhysicsSM.Draft.NullEdgeSpectralGraphNodalSet` proves that the high branches
sit on exact determinant-zero branch lines. They are not isolated species of the
bare symbol.

Claim label: **no-go theorem**.

`PhysicsSM.Draft.NullEdgeActualCliffordSymbol` proves the corrected bare-symbol
statement: each nonzero null branch kernel contains both `Gamma_s = +1` and
`Gamma_s = -1` zero modes. The bare operator does not assign a single chirality
sign per branch.

`PhysicsSM.Draft.NullEdgeHyperdiamondNoGo` sharpens that statement:

- `highMomentum_branch_nogo` bundles the four high-momentum branch facts with
  the global no-go.
- `no_branch_single_sign` proves the obstruction branch-by-branch.
- `bare_symbol_proof_cannot_fix_chirality` says every proposed branch sign is
  contradicted by some bare zero mode.
- `chiralProj_forces_alignment` and `chiralProj_cuts_kernel` show that an
  explicit chirality projector is sufficient extra data to select one branch
  mode, while deliberately not claiming locality, gauge covariance, Krein
  safety, or physical release.

Claim label: **reconstruction target** / **finite identity**.

`PhysicsSM.Draft.NullEdgeHyperdiamondBridge` proves the exact frame/covector
bridge currently supported by the definitions:

- `hyperdiamond_crosswalk_exact` identifies the Gate C tetrahedral dual frame
  with the complexified dual-soldered tetrahedral frame.
- `dualSolder_symbol_matches_gateC_symbol` identifies the real dual-soldered
  tetrahedral covector with Gate C `pCov` after complexification and records
  the corresponding symbol-square law.
- `nielsenNinomiya_assumption_ledger` bundles the finite assumptions currently
  represented in Lean and explicitly leaves locality, gauge covariance,
  operator Hermiticity/Krein data, and index/anomaly transport absent.
- `chiralProj_idempotent` proves the sufficient chirality projector is
  idempotent, without upgrading it to physical projected-operator data.

Aristotle's 2026-07-01 evaluation identifies this theorem family, especially
`no_full_symbol_single_chirality`, as the central Gate C fact. It should be read
as the finite null-edge version of a lattice-fermion doubling obstruction, not
as a temporary inconvenience. See
[`HYPERDIAMOND_CROSSWALK.md`](HYPERDIAMOND_CROSSWALK.md) for the 3+1D
lattice-fermion reframing.

Claim label: **consistency check**.

`PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety` proves that a nonzero flavored
index alone is not enough for release: a fatal gauge-coupled wrong-sign Krein
zero blocks full release.

Claim label: **conditional schema**.

`PhysicsSM.Draft.NullEdgeProjectedGateCRelease` and
`PhysicsSM.Draft.NullEdgeProjectedGateCWilsonRelease` package the conditional
projected/Wilson release API for `D_phys`.

## Current Reading

The bare flat operator is fatal for the naive release route. It is not fatal for
the program.

The current release target is projected and audited:

```text
(D_gap, Pi_phys, D_phys, Gamma_lat, physical/Krein data)
```

A release must supply:

- nodal-set control;
- branch-projector control;
- one-dimensional projected kernels;
- projected chirality alignment;
- projected Krein positivity;
- ghost-zero safety;
- species-splitting and regulator-moduli audit.

## Frozen Release Ledger

The projected/Wilson release modules are retained in this standalone package as
an audit ledger and as typed documentation of what a future release would have
to supply. They are not themselves a released physical operator.

The current `ProjData`-style records contain free bookkeeping fields such as
chirality signs, kernel dimensions, Krein signs, and nodal-gap flags. Those
fields are not derived here from the actual `cliffordSymbol` or a concrete
projector. Consequently, bundled release theorems should be read as conditional
packaging of assumptions, not as physics progress.

Do not grow this ledger by adding more satisfiable clauses. Productive Gate C
work should instead do one of three things:

- prove a sharper no-go theorem for the bare or regulated symbol;
- prove mutual minimality of the existing release predicates;
- construct concrete projected operator data and connect the predicates to it.

## Non-Claims

Claim label: **physical non-claim**.

The package does not construct the final physical `D_phys`. It does not release
the bare `D_+`. It does not prove anomaly cancellation, locality of a final
operator, or a full physical Hilbert-space interpretation.
