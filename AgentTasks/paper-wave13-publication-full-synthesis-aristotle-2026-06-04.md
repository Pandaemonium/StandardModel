# Aristotle task: full publication synthesis package

Date: 2026-06-04

## Goal

Create a publication-facing synthesis file that bundles the exact algebraic
Furey/Baez/DVT synthesis together with the newly integrated gauge quotient and
quunit/qubit/qutrit representation packages.

Primary target file:

```text
PhysicsSM/Publication/FureyBaezDVTFullSynthesis.lean
```

Useful imports:

```text
PhysicsSM.Publication.FureyBaezDVTExactSynthesis
PhysicsSM.Gauge.StandardModelUnitZ6ExactKernelPackage
PhysicsSM.Gauge.QunitQubitQutritQuotientRepresentation
```

## Preferred theorem shape

Create a package such as:

```lean
structure FureyBaezDVTFullSynthesisPackage where
  exact_synthesis : FureyBaezDVTExactSynthesisPackage
  unit_z6_exact_kernel : StandardModelUnitZ6ExactKernelPackage
  quunit_quotient_representation :
    QunitQubitQutritQuotientRepresentationPackage
  identity_fiber_acts_trivially :
    forall x : SMCoveringTriple,
      x.smImage = 1 ->
        quotientActQubitPlusQutrit (Quotient.mk _ x) = id
  no_full_standard_model_derivation : True
  no_topological_quotient_isomorphism : True
```

Instantiate it as:

```lean
noncomputable def fureyBaezDVTFullSynthesisPackage :
  FureyBaezDVTFullSynthesisPackage := ...
```

Add projection theorems for each field, by `rfl` where possible.

## Proof hints

- Use `fureyBaezDVTExactSynthesisPackage`.
- Use `standardModelUnitZ6ExactKernelPackage`.
- Use `qunitQubitQutritQuotientRepresentationPackage`.
- The identity-fiber action proof should be the same small lemma as in the
  gauge synthesis job:
  `smCoveringTriple_smImage_one_quotient_eq`,
  `quotientActQubitPlusQutrit_mk`, and `actQubitPlusQutrit_one`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- This is a paper-facing theorem package, not a derivation of the full Standard
  Model from octonions.
- Do not edit `FureyBaezDVTTheoremIndex.lean`; a separate theorem-index refresh
  job is already running.

## Verification

Run:

```bash
lake build PhysicsSM.Publication.FureyBaezDVTFullSynthesis
```

## Submission

Status: integrated.

Submission project:

```text
AgentTasks/aristotle-submit/paper-wave13-20260604
```

Job ID:

```text
7c0f3220-d235-4252-8524-ada29ffb9f21
```

## Integration

Result status: `COMPLETE`.

Integrated output from:

```text
AgentTasks/aristotle-output/7c0f3220-extracted/paper-wave13-20260604-project_aristotle
```

Files integrated:

```text
PhysicsSM/Publication/FureyBaezDVTFullSynthesis.lean
PhysicsSM.lean
```

Local verification target:

```bash
lake build PhysicsSM.Publication.FureyBaezDVTFullSynthesis
```
