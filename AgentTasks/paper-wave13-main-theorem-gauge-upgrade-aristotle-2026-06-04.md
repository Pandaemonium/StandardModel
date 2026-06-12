# Aristotle task: main theorem gauge package upgrade

Date: 2026-06-04

## Goal

Upgrade the paper-facing main theorem package so it directly cites the two
newly integrated gauge-level theorem packages:

- `StandardModelUnitZ6ExactKernelPackage`
- `QunitQubitQutritQuotientRepresentationPackage`

Primary target file:

```text
PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean
```

New imports to add:

```text
PhysicsSM.Gauge.StandardModelUnitZ6ExactKernelPackage
PhysicsSM.Gauge.QunitQubitQutritQuotientRepresentation
```

## Preferred theorem shape

Extend `FureyBaezDVTMainTheorem` with fields such as:

```lean
unit_z6_exact_kernel : StandardModelUnitZ6ExactKernelPackage
quunit_quotient_representation :
  QunitQubitQutritQuotientRepresentationPackage
```

Instantiate them in `fureyBaezDVTMainTheorem` using:

```lean
standardModelUnitZ6ExactKernelPackage
qunitQubitQutritQuotientRepresentationPackage
```

Add projection theorems:

```lean
theorem mainTheorem_has_unit_z6_exact_kernel :
  fureyBaezDVTMainTheorem.unit_z6_exact_kernel =
    standardModelUnitZ6ExactKernelPackage := rfl

theorem mainTheorem_has_quunit_quotient_representation :
  fureyBaezDVTMainTheorem.quunit_quotient_representation =
    qunitQubitQutritQuotientRepresentationPackage := rfl
```

If namespace qualifications are needed, use the actual namespaces from the two
gauge modules.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not remove or weaken existing fields.
- Preserve the existing `ClaimBoundary`.
- This is a citation/indexing upgrade only; do not introduce new physics
  claims.

## Verification

Run:

```bash
lake build PhysicsSM.Publication.FureyBaezDVTMainTheorem
```

## Submission

Status: integrated.

Submission project:

```text
AgentTasks/aristotle-submit/paper-wave13-20260604
```

Job ID:

```text
018096b3-40fa-4e53-8fa4-6d3e02d02d7c
```

## Integration

Result status: `COMPLETE`.

Integrated output from:

```text
AgentTasks/aristotle-output/018096b3-extracted/paper-wave13-20260604-project_aristotle
```

Files integrated:

```text
PhysicsSM/Publication/FureyBaezDVTMainTheorem.lean
```

Local verification target:

```bash
lake build PhysicsSM.Publication.FureyBaezDVTMainTheorem
```
