# Aristotle task: wave 11 main theorem upgrade

Date: 2026-06-04

## Goal

Upgrade the paper-facing main theorem package to cite the newly integrated
exact packages directly, while preserving the existing claim boundary.

Primary target file:

```text
PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean
```

New trusted modules to import:

```text
PhysicsSM.Algebra.Jordan.DVTTwoSidedImageEquiv
PhysicsSM.Algebra.Octonion.G2AutomorphismSU3Exactness
PhysicsSM.Algebra.Furey.FureyAnomalyDecomposition
```

## Preferred upgrades

Extend `FureyBaezDVTMainTheorem` with fields for:

```lean
dvt_image_equiv : DVTTwoSidedImageEquivPackage
g2_automorphism_su3_exactness : G2AutomorphismSU3ExactnessPackage
furey_anomaly_decomposition : FureyAnomalyDecompositionPackage
```

Instantiate them in `fureyBaezDVTMainTheorem`.

Add small projection theorems:

```lean
theorem mainTheorem_has_dvt_image_equiv :
  fureyBaezDVTMainTheorem.dvt_image_equiv =
    dvtTwoSidedImageEquivPackage := rfl

theorem mainTheorem_has_g2_automorphism_su3_exactness :
  fureyBaezDVTMainTheorem.g2_automorphism_su3_exactness =
    g2AutomorphismSU3ExactnessPackage := rfl

theorem mainTheorem_has_furey_anomaly_decomposition :
  fureyBaezDVTMainTheorem.furey_anomaly_decomposition =
    fureyAnomalyDecompositionPackage := rfl
```

Use the actual namespace qualifications needed by the current files.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not weaken or remove existing main theorem fields.
- Do not claim a derivation of the full Standard Model from octonions.
- Keep the right-handed singlet sector marked as a conventional completion.

## Verification

Run:

```bash
lake build PhysicsSM.Publication.FureyBaezDVTMainTheorem
```

## Submission

Status: integrated.

Submission project:

```text
AgentTasks/aristotle-submit/paper-wave12-20260604
```

Job ID:

```text
a7cd293d-ea3e-4e6e-b8ff-31752a632df0
```

## Integration

Integrated on 2026-06-04 into:

```text
PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean
```

Result: extended `FureyBaezDVTMainTheorem` with direct fields and projection
theorems for the DVT quotient-to-image equivalence, G2/SU(3) exactness, and
Furey anomaly decomposition packages.
