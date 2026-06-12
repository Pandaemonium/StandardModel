# Aristotle task: unit-level Z6 exact kernel package

Date: 2026-06-04

## Goal

Strengthen the unit-level Standard Model quotient theorem by connecting
`StandardModelUnitZ6SMBlockEquiv` to the exact six-element kernel family,
mirroring the true-product result in
`StandardModelProductCoveringTrueZ6Kernel`.

Primary target file:

```text
PhysicsSM/Gauge/StandardModelUnitZ6ExactKernelPackage.lean
```

Useful imports:

```text
PhysicsSM.Gauge.StandardModelUnitZ6SMBlockEquiv
PhysicsSM.Gauge.StandardModelUnitZ6Kernel
PhysicsSM.Gauge.StandardModelZ6KernelPackage
PhysicsSM.Gauge.StandardModelProductCoveringTrueZ6Kernel
```

## Preferred theorem shape

Create a trusted package proving that the unit-level image relation used by
`SMCoveringQuotient` has the expected six-element identity fiber.

Preferred package:

```lean
structure StandardModelUnitZ6ExactKernelPackage where
  unit_kernel_family_maps_to_one :
    forall i : Fin 6,
      unitCoveringTripleImageGroupHom
        ((sixUnitCoveringKernelElts i).toUnitCoveringTriple) = 1
  quotient_kernel_card_six :
    Fintype.card CoveringKernelElt = 6
  quotient_equiv_smblock :
    SMCoveringQuotient ~=* SMBlockUnitsSubgroup
```

If possible, also prove an exact identity-fiber iff:

```lean
forall x : SMCoveringTriple,
  x.smImage = 1 <->
    exists i : Fin 6,
      x.toUnitCoveringTriple =
        (sixUnitCoveringKernelElts i).toUnitCoveringTriple
```

Adapt names to the available APIs. If the iff is too hard because of bundled
subtype equality, return the strongest forward/backward lemmas you can prove.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change existing gauge-group definitions or normalizations.
- This is algebraic unit-level exactness only, not a topological quotient
  theorem.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelUnitZ6ExactKernelPackage.lean
lake build PhysicsSM.Gauge.StandardModelUnitZ6ExactKernelPackage
```

## Submission

Status: integrated.

Submission project:

```text
AgentTasks/aristotle-submit/paper-wave11-20260604
```

Job ID:

```text
961feee4-8567-40c2-83ed-a57112794669
```

## Integration

Integrated on 2026-06-04 into:

```text
PhysicsSM/Gauge/StandardModelUnitZ6ExactKernelPackage.lean
PhysicsSM.lean
```

Result: added a trusted unit-level Z6 exact-kernel package linking the
unit-covering quotient equivalence to the six explicit kernel elements, plus
kernel-form lemmas at the `SMCoveringTriple` abstraction level.
