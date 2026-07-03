# Gate C Assumption Ledger

This ledger separates finite Lean facts from physical release assumptions for
the 3+1D Gate C branch problem.

## Claim Labels

Use these labels consistently:

- **finite identity**: a kernel-checked algebraic or combinatorial identity in
  the finite package.
- **no-go theorem**: a kernel-checked obstruction for the stated finite object.
- **conditional schema**: a typed API or theorem whose hypotheses are free input
  data, not yet derived from a concrete operator.
- **consistency check**: a finite audit that rules out one bad interpretation or
  confirms one required algebraic behavior.
- **reconstruction target**: a theorem still needed to connect two formal
  objects or convention systems.
- **analytic scaffold**: a statement or plan requiring limits, topology,
  estimates, or function spaces not present in the finite package.
- **physical non-claim**: an interpretation the package deliberately does not
  assert.

## Represented In Lean

| Assumption or feature | Current Lean representation | Claim label | Boundary |
| --- | --- | --- | --- |
| Tetrahedral corner bookkeeping | `TetrahedralHighMomentumNullBranch` classifies the 16 `{0, pi}` corners | finite identity | This is high-symmetry corner data, not full torus topology. |
| Nonzero high-momentum null branches | `tasteCorner_high_momentum_null`, `branchP_mink_zero`, `branchP_ne_zero` | finite identity | Identifies finite branch points, not physical species by itself. |
| Determinant-zero branch lines | `NullEdgeSpectralGraphNodalSet` | finite identity | Shows extended bare nodal structure; does not remove branches. |
| Concrete flat Clifford symbol | `cliffordSymbol`, `cliffordSymbol_sq` | finite identity | This is a pointwise symbol, not a full position-space operator. |
| Balanced bare branch kernels | `branchKernel_chirality_sign`, `no_full_symbol_single_chirality` | no-go theorem | The bare symbol cannot force one chirality sign. |
| Per-branch bare no-go | `no_branch_single_sign`, `bare_symbol_proof_cannot_fix_chirality` | no-go theorem | Applies branch-by-branch to the bare symbol only. |
| Explicit chirality projector suffices algebraically | `chiralProj_forces_alignment`, `chiralProj_cuts_kernel` | consistency check | Shows sufficient projection data, not physical legitimacy. |
| Exact dual-frame crosswalk | `hyperdiamond_crosswalk_exact` | finite identity / reconstruction | Identifies the Gate C dual frame with the complexified dual-soldered frame, not an operator equivalence. |
| Gate C / dual-soldered symbol-square bridge | `dualSolder_symbol_matches_gateC_symbol`, `gateC_symbol_sq_kinetic`, `dualSolder_and_gateC_share_square_law` | finite identity / reconstruction | Shows covector and principal-symbol-square agreement, not a full finite-difference operator match. |
| First-order stencil crosswalk API | `NullEdgeHyperdiamondOperatorScaffold` defines `HyperdiamondFirstOrderStencil`, `GateCPrincipalCrosswalk`, `gateCStencil_crosswalk`, `gateCStencil_no_single_chirality`, `BoriciCreutzConventionData`, `boriciCreutzNearest_no_single_chirality`, and the fifth-vector truncation mismatch theorem | reconstruction target / no-go inheritance | The Gate C symbol can be packaged as a four-edge stencil and inherits the square law and bare-symbol chirality no-go. Borici-Creutz convention data now has a Lean landing zone, and the package proves that a nonzero fifth-vector term is omitted by the nearest-neighbor truncation. No source convention is instantiated yet. |
| Represented Nielsen-Ninomiya data ledger | `nielsenNinomiya_assumption_ledger` | consistency check | Bundles represented finite facts while explicitly leaving physical hypotheses absent. |
| `chiralProj` idempotence | `chiralProj_idempotent` | consistency check | Confirms projector structure, not locality, gauge covariance, Krein sign, or operator-derived data. |
| Nonzero index is insufficient | `NullEdgeGateCGhostZeroSafety` | consistency check | Separates flavored index from ghost/Krein safety. |
| Projected/Wilson release records | `NullEdgeProjectedGateCRelease`, `NullEdgeProjectedGateCWilsonRelease` | conditional schema | Their fields are not derived from `cliffordSymbol` or a concrete projector. |

## Not Yet Represented

| Missing assumption or feature | Why it matters | Claim label |
| --- | --- | --- |
| Exact Borici-Creutz or hyperdiamond operator definition | A generic first-order stencil API, `gateCStencil`, `BoriciCreutzConventionData`, and `BORICI_CREUTZ_NEXT_CONVENTION_DATA.md` now exist, but the named Borici-Creutz coefficients/phases, fifth-vector convention, shifted onsite term, pole locations, and basis order are not yet instantiated from a source convention. | reconstruction target |
| Convention map between that operator and the tetrahedral symbol | Needed to compare signs, phases, basis order, and normalization. | reconstruction target |
| Operator-level bridge from dual-soldered difference operator to Gate C `cliffordSymbol` | The frame/covector bridge is proved, but no concrete position-space operator equivalence is defined. | reconstruction target |
| Position-space locality or finite range | Needed for a Nielsen-Ninomiya-style physical no-go theorem. | analytic scaffold |
| Hermiticity or Krein self-adjointness of the actual Gate C symbol/operator | Needed for a physical spectral interpretation. | reconstruction target |
| Exact chiral symmetry or Ginsparg-Wilson replacement | Needed to state which lattice no-go assumption is kept or broken. | reconstruction target |
| Gauge covariance | Needed before projected data can be physical. | physical non-claim |
| Anomaly or topological index transport | Needed for Standard-Model-facing chirality claims. | analytic scaffold |
| Continuum limit | Needed to connect the finite operator to a continuum field equation. | analytic scaffold |
| Construction of `D_phys` | Needed for any release theorem. | physical non-claim |

## Current Verdict

The package proves a strong finite no-go for the **bare** high-momentum
tetrahedral Clifford symbol: its branch kernels are chirality-balanced, and no
bare-symbol-only proof can assign one chirality sign to an entire branch.

The package also proves the exact frame/covector bridge between the Gate C
tetrahedral symbol data and the dual-soldered tetrahedral frame. This is real
reconstruction progress, but it is not a physical release and not an
operator-level Borici-Creutz equivalence.

The package does not yet construct a physical projected operator. The
projected/Wilson modules are conditional ledgers: useful as specifications, but
not evidence of release until their data are derived from a concrete operator
and pass locality, gauge, Krein, nodal, and anomaly audits.

## Best Next Work

1. Define a named hyperdiamond/minimally doubled symbol and an explicit
   convention map, then prove or refute equivalence.
2. Prove or refute an operator-level bridge between a concrete dual-soldered
   finite-difference operator and the Gate C high-momentum symbol.
3. Turn the missing Nielsen-Ninomiya assumptions into Lean predicates only after
   there is a concrete operator to which they apply.
4. Audit any proposed projector, including `chiralProj`, for locality, gauge
   covariance, Krein sign, and operator-derived branch data.
