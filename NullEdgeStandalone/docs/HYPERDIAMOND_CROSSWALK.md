# Hyperdiamond And No-Go Crosswalk

This note reframes the 3+1D null-edge Gate C problem as a lattice-fermion
problem. It is a guide for future Lean and Aristotle work, not a new theorem.
The assumption ledger is
[`GATE_C_ASSUMPTION_LEDGER.md`](GATE_C_ASSUMPTION_LEDGER.md).
The integrated frame/covector bridge report is
[`HYPERDIAMOND_BRIDGE_REPORT.md`](HYPERDIAMOND_BRIDGE_REPORT.md).

## Main Diagnosis

Claim label: **no-go theorem** for the bare symbol, plus **reconstruction
target** for any exact hyperdiamond equivalence.

The tetrahedral null-edge frame is structurally in the same problem family as
hyperdiamond / minimally doubled lattice fermions:

- four primitive null edge directions;
- a dual covector soldering frame;
- a finite Brillouin-zone symbol;
- high-momentum singular branches;
- a chirality-selection obstruction.

Aristotle's 2026-07-01 evaluation says to treat

```text
PhysicsSM.Draft.NullEdgeActualCliffordSymbol.no_full_symbol_single_chirality
```

as the central Gate C fact. The bare flat symbol has a two-dimensional,
chirality-balanced kernel at each nonzero high-momentum null branch. Therefore
the bare operator does not release one physical Weyl branch.

The later hyperdiamond Aristotle job integrated
`PhysicsSM.Draft.NullEdgeHyperdiamondNoGo`, which sharpens this into a
per-branch no-go and identifies an explicit chirality projector as sufficient
extra data. That projector theorem is not a physical release theorem; it is a
clean witness for the kind of additional projection data the bare symbol lacks.

The subsequent hyperdiamond bridge job integrated
`PhysicsSM.Draft.NullEdgeHyperdiamondBridge`, proving that the Gate C
tetrahedral dual frame is exactly the complexification of the dual-soldered
tetrahedral frame and that both symbol layers share the same
principal-symbol-square contract.

## Crosswalk

| Null-edge package | Lattice-fermion reading | Current status |
| --- | --- | --- |
| `ell_A = (1, n_A)` | nearest null/tetrahedral directions | concrete frame proved in the dual-soldered layer |
| `alpha^A` | dual soldering covectors | exact Gate C / dual-solder frame crosswalk proved |
| `D_N = sum_A c(alpha^A) nabla_A` | finite Dirac-like lattice operator | abstract dual-solder algebra proved; operator-level equivalence remains open |
| phase corners `q_A in {0, pi}` | Brillouin-zone high-momentum corners | corner split proved |
| nonzero null corners | determinant-zero branches | branch lines proved |
| `no_full_symbol_single_chirality` | doubling/chirality-balance obstruction | central no-go theorem |
| `highMomentum_branch_nogo`, `no_branch_single_sign` | per-branch bare-symbol obstruction | sharpened no-go integrated |
| `chiralProj_forces_alignment`, `chiralProj_cuts_kernel` | sufficient extra projection data | proves what must be added; not a local/gauge/Krein release |
| projected/Wilson release APIs | possible doubler-removal or taste-splitting strategies | frozen schema until operator-derived |

The important shift is psychological and technical: Gate C is not a bespoke
release checklist. It is a chiral lattice fermion problem with known tradeoffs.

## What Should Be Proved Next

The immediate target is not "add more release clauses." It is one of:

1. An operator-level equivalence/crosswalk theorem between a concrete
   null-edge finite-difference operator and a standard hyperdiamond/minimally
   doubled operator, if the definitions line up exactly.
2. A theorem identifying which Nielsen-Ninomiya-style assumption is violated by
   any proposed release operator.
3. A concrete projected operator whose chirality, kernel dimension, Krein sign,
   and nodal-gap data are derived rather than hand-filled.

## Assumption Ledger

Claim label: **reconstruction target** until these assumptions have Lean
referents for a concrete operator. Any future 3+1D release attempt should state
which of these it keeps and which it breaks:

- locality;
- translation invariance;
- Hermiticity or the relevant Krein replacement;
- exact chiral symmetry;
- single Weyl branch;
- gauge covariance;
- correct anomaly/index transport;
- hypercubic or tetrahedral symmetry.

A Wilson-like route usually breaks exact chiral symmetry at finite lattice
spacing. A minimally doubled route keeps a chiral symmetry but keeps at least
two species and often breaks some discrete lattice symmetry. A Ginsparg-Wilson
route changes the chiral symmetry relation. A projected route must prove the
projector is concrete, local enough, gauge-covariant enough, and ghost-safe.

## Current Non-Claim

Claim label: **physical non-claim** and **reconstruction target**.

This package has proved an exact frame/covector bridge between the Gate C
tetrahedral dual frame and the dual-soldered tetrahedral frame. It has not
proved that a null-edge finite-difference operator is literally identical to the
Borici-Creutz operator. The exact operator equivalence, if true, should be a
future Lean theorem after the relevant operator and convention map are defined.

## Sources For Orientation

- Michael Creutz, [Four-dimensional graphene and chiral fermions](https://arxiv.org/abs/0712.1201).
- Artan Borici, [Minimally Doubled Fermion Revival](https://arxiv.org/abs/0812.0092).
- H. B. Nielsen and M. Ninomiya, [Absence of neutrinos on a lattice](https://doi.org/10.1016/0550-3213(81)90524-1).
- Daniel Friedan, [A Proof of the Nielsen-Ninomiya Theorem](https://www.physics.rutgers.edu/~friedan/papers/Commun_Math_Phys_85_481-490_1982.pdf).
