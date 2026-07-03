# Hyperdiamond No-Go Aristotle Report

Date: 2026-07-01

Aristotle project:

```text
b347d197-c5f4-4289-a07e-a90447c2d020
```

Aristotle task:

```text
99bc83d2-4022-4835-91b3-8259b7963cd6
```

This report records the hyperdiamond/Gate C no-go integration. The returned
work added a new Lean module:

```text
PhysicsSM.Draft.NullEdgeHyperdiamondNoGo
```

The module strengthens the bare-symbol obstruction. It does not add release
clauses and does not claim equivalence with a Borici-Creutz operator.
For the current claim-label and assumption ledger, see
[`GATE_C_ASSUMPTION_LEDGER.md`](GATE_C_ASSUMPTION_LEDGER.md).
The later bridge/audit integration is summarized in
[`HYPERDIAMOND_BRIDGE_REPORT.md`](HYPERDIAMOND_BRIDGE_REPORT.md).

## Integrated Lean Content

The new module proves:

- `gamma5_sq`, `gamma5_mulVec_involutive`, `g5_sq_one`: helper facts for the
  spacetime chirality operator and the model branch sign.
- `highMomentum_branch_nogo`: a bundled theorem for all four high-momentum
  branches, collecting nullity, nonzero branch covector, nonzero symbol,
  nilpotency, opposite-chirality kernel modes, and the global single-sign
  no-go.
- `BranchAssignsSingleSign`: the per-branch single-sign predicate.
- `no_branch_single_sign`: no branch kernel is monochromatic under the bare
  symbol.
- `bare_symbol_proof_cannot_fix_chirality`: every candidate sign is contradicted
  by a nonzero bare zero mode.
- `chiralProj`, `gamma5_chiralProj`, `chiralProj_forces_alignment`: an explicit
  chirality projector is sufficient to force the existing
  `OperatorForcesAlignmentAfterProjection` interface.
- `chiralProj_on_eigen`, `chiralProj_cuts_kernel`: the projector keeps one
  chirality mode and kills the independent opposite one on each high-momentum
  branch.

## Physics Reading

The bare high-momentum symbol is a balanced object: every nonzero high-momentum
null branch has both spacetime chiralities in its kernel. The new per-branch
theorem makes the obstruction harder to misread:

```text
no bare-symbol-only proof can derive one branch chirality sign
```

The projector result identifies the kind of extra data that could break the
balance. It is only a sufficiency result for a chirality projector. It is not a
proof that the projector is local, gauge-covariant, Krein-safe, anomaly-safe, or
derived from a physical lattice operator.

## Crosswalk Corrections

The live standalone package does contain dual-soldered frame algebra, including
the tetrahedral dual-pairing theorem. The Gate C bare-symbol files, however, do
not by themselves define the full finite difference operator or prove an exact
equivalence with a standard hyperdiamond/minimally doubled operator.

Therefore the honest status is:

- dual-soldered frame identities are backed by Lean in the standalone package;
- the bare high-momentum `cliffordSymbol` no-go is backed by Lean;
- exact equivalence to Borici-Creutz or another named hyperdiamond operator is
  not backed by Lean;
- projected/Wilson release schemas remain conditional ledgers until their data
  are derived from a concrete operator.

## Nielsen-Ninomiya Assumption Map

Represented finitely:

- Brillouin-corner bookkeeping at `{0, pi}^4`;
- a concrete Clifford symbol and its square;
- high-momentum null branches;
- balanced branch kernels;
- naive/flavored chirality bookkeeping.

Not yet represented as theorem hypotheses:

- locality or finite-range position-space operator data;
- Hermiticity or a Krein self-adjointness theorem attached to this symbol;
- exact chiral symmetry as an operator identity;
- topological index, winding, anomaly transport, or continuum limit;
- gauge covariance.

So the package captures the finite obstruction pattern, but it is not yet a
formal instance of the full Nielsen-Ninomiya theorem.

## Next Targets

The originally listed frame/covector bridge targets were subsequently
integrated in `PhysicsSM.Draft.NullEdgeHyperdiamondBridge`. The remaining best
Lean targets are:

1. `hyperdiamond_operator_crosswalk_exact`
   Define a specific hyperdiamond/minimally doubled finite-difference operator
   and prove, or refute, equivalence under an explicit convention map.

2. `nielsenNinomiya_assumption_instance`
   Give Lean referents for locality, Hermiticity/Krein, chiral symmetry, and
   index assumptions before claiming an instance of the theorem.

3. `chiralProj_physical_audit`
   If `chiralProj` is used as a prototype, audit locality, gauge covariance,
   Krein sign, and whether its data are operator-derived.
