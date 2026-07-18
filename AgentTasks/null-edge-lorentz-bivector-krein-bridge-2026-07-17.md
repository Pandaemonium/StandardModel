# Null-edge Lorentz-bivector Krein bridge

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-004`
Status: kernel-checked physical convention and representation bridge

## Result

`PhysicsSM/Draft/NullEdge/LorentzBivectorKreinBridge.lean` derives the
six-component curvature-fiber convention from the project's mostly-minus
spacetime metric. The ordered basis is

```text
(e1 wedge e2, e1 wedge e3, e2 wedge e3,
 e0 wedge e1, e0 wedge e2, e0 wedge e3).
```

The module proves:

- the determinant pairing induced from spacetime is exactly
  `diag(+,+,+,-,-,-)`;
- the first three components are spatial rotation planes and the last three
  are time-space boost planes;
- the finite exterior-square matrix obeys the Binet pairing identity;
- every eta-Lorentz four-vector transport preserves the split-six pairing;
- the concrete `SL(2,C)` action already soldered to null edges induces such a
  preserving six-component transport;
- for a preserving transport, the abstract Krein adjoint `J U^T J` is an
  actual inverse action.

The headline results carry build-enforced standard-three axiom guards. No
proof handoff or compiled-evaluator shortcut is used.

## Interpretation boundary

This closes the physical basis, fundamental-symmetry, and representation
convention gate. It does not yet put the Krein pairing into the complete
link/face action, derive the face weight from null-coframe `e wedge e` and
dual-cell volumes, vary nonlinear Lorentz plaquette holonomy, or prove
Levi-Civita selection.

## Successor

`FinitePeriodicKreinLinkPalatiniVariation.lean` now assembles the periodic
Krein summation-by-parts theorem and the full finite-fiber link/face variation
into one Krein-paired face-action Euler theorem. The remaining target is to
derive its face field geometrically, nonlinearize the holonomy variation, and
rerun the exact three-site conformal witness.

## Verification

```text
lake env lean PhysicsSM/Draft/NullEdge/LorentzBivectorKreinBridge.lean
```

The command passed with no warnings.
