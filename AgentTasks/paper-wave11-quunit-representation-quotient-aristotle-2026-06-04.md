# Aristotle task: quunit/qubit/qutrit quotient representation

Date: 2026-06-04

## Goal

Make Baez's quunit/qubit/qutrit dictionary more structural by proving that
the block action of `UnitCoveringTriple` on `QubitPlusQutrit` factors through
the Standard Model quotient because the Z6 kernel acts trivially.

Primary target file:

```text
PhysicsSM/Gauge/QunitQubitQutritQuotientRepresentation.lean
```

Useful imports:

```text
PhysicsSM.Gauge.QunitQubitQutritRepresentation
PhysicsSM.Gauge.QunitQubitQutritDictionary
PhysicsSM.Gauge.StandardModelUnitZ6SMBlockEquiv
PhysicsSM.Gauge.StandardModelUnitZ6Kernel
PhysicsSM.Gauge.StandardModelProductCoveringTrueZ6Kernel
```

## Preferred theorem shape

Create a trusted package proving a factorization of the representation through
the quotient/image relation already used in `SMCoveringQuotient`.

Possible package shape:

```lean
structure QunitQubitQutritQuotientRepresentationPackage where
  quotientAction : SMCoveringQuotient ->* Function.End QubitPlusQutrit
  quotientAction_mk :
    forall x : SMCoveringTriple,
      quotientAction (Quotient.mk _ x) =
        unitCoveringTripleQubitPlusQutritRepresentation
          x.toUnitCoveringTriple
  kernel_trivial :
    forall i : Fin 6,
      actQubitPlusQutrit
        (sixUnitCoveringKernelElts i).toUnitCoveringTriple = id
```

If `SMCoveringTriple` vs `UnitCoveringTriple` coercions make the exact shape
awkward, prove a clean factorization through whatever quotient relation is
currently available in `StandardModelUnitZ6SMBlockEquiv`.

## Stretch target

Prove compatibility between the quotient action and the block subgroup
equivalence `smCoveringQuotientMulEquivSMBlockUnits`, i.e. the action computed
from a quotient class agrees with the action of its corresponding block matrix
on `QubitPlusQutrit`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- This is a representation/dictionary theorem only; do not claim quantum
  computing dynamics or physical Hilbert-space interpretation.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/QunitQubitQutritQuotientRepresentation.lean
lake build PhysicsSM.Gauge.QunitQubitQutritQuotientRepresentation
```

## Submission

Status: integrated.

Submission project:

```text
AgentTasks/aristotle-submit/paper-wave11-20260604
```

Job ID:

```text
0d2541e6-29ca-49d6-b504-65ecccd08978
```

## Integration

Integrated on 2026-06-04 into:

```text
PhysicsSM/Gauge/QunitQubitQutritQuotientRepresentation.lean
PhysicsSM.lean
```

Result: added a trusted quotient representation package proving the
quunit/qubit/qutrit block action factors through `SMCoveringQuotient` and is
compatible with the block-subgroup equivalence.
