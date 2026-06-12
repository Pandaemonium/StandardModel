# Aristotle task: inner derivations are trace-form antisymmetric

Date: 2026-06-04

## Goal

Create a trusted module:

```text
PhysicsSM/Algebra/Jordan/DerivationTraceAntisymmetry.lean
```

This is the narrower resubmission of job
`32bc7d75-10b2-4e77-b18a-3e4cb76f1b77`, which ran out of budget without
producing a usable file.

## Context

Relevant modules:

- `PhysicsSM.Algebra.Jordan.InnerDerivation`
- `PhysicsSM.Algebra.Jordan.TraceForm`
- `PhysicsSM.Algebra.Jordan.TraceFormFrobenius`
- `PhysicsSM.Algebra.Jordan.InnerDerivationJacobiLie`

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

Prefer using the Frobenius identity from `TraceFormFrobenius.lean` if available.
If that file is not available in the submission copy, prove the needed unit
trace identities locally first.

## Target theorems

Prove the inner-derivation version first:

```lean
/-- Inner derivations are traceless against the Jordan unit. -/
theorem innerDerivation_trace_zero (a b c : H3O) :
    traceForm ((innerDerivation a b).toFun c) oneH3O = 0

/-- Inner derivations are antisymmetric for the trace form. -/
theorem innerDerivation_traceForm_antisymm (a b x y : H3O) :
    traceForm ((innerDerivation a b).toFun x) y +
      traceForm x ((innerDerivation a b).toFun y) = 0
```

Then, if feasible, extend the statement to elements of the linear span of inner
derivations:

```lean
theorem innerDerivationSubspace_traceForm_antisymm
    {D : Derivation.H3ODerivation}
    (hD : D ∈ innerDerivationSubspace) (x y : H3O) :
    traceForm (D.toFun x) y + traceForm x (D.toFun y) = 0
```

Do not claim the theorem for all `H3ODerivation` unless the required spanning
theorem is already present or is proved in this file.

## Package

Add:

```lean
structure DerivationTraceAntisymmetryPackage where
  inner_trace_zero :
    forall a b c : H3O,
      traceForm ((innerDerivation a b).toFun c) oneH3O = 0
  inner_antisymm :
    forall a b x y : H3O,
      traceForm ((innerDerivation a b).toFun x) y +
        traceForm x ((innerDerivation a b).toFun y) = 0

noncomputable def derivationTraceAntisymmetryPackage :
    DerivationTraceAntisymmetryPackage
```

If the span theorem is also proved, add it as an additional package field.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DerivationTraceAntisymmetry.lean
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave9-20260604`

Job ID: `396a543a-0eaf-474e-a7c1-06d9ca18b13a`
