# Aristotle task: trace-form Frobenius identity for H3O

Date: 2026-06-04

## Goal

Create a trusted module:

```text
PhysicsSM/Algebra/Jordan/TraceFormFrobenius.lean
```

This is the split-out prerequisite for the trace-antisymmetry of inner
derivations.

## Context

Relevant modules:

- `PhysicsSM.Algebra.Jordan.H3O`
- `PhysicsSM.Algebra.Jordan.TraceForm`
- `PhysicsSM.Algebra.Jordan.Derivation`

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

The trace form is defined as `traceForm a b = trace (jordanProduct a b)`.
The Jordan product is commutative but not associative; do not use associative
algebra shortcuts.

## Target theorems

Prove:

```lean
/-- Frobenius associativity of the H3O trace form. -/
theorem traceForm_jordanProduct_left (a b c : H3O) :
    traceForm (jordanProduct a b) c = traceForm a (jordanProduct b c)

/-- The Jordan unit recovers the trace-form definition. -/
theorem traceForm_oneH3O_jordanProduct (a b : H3O) :
    traceForm oneH3O (jordanProduct a b) = traceForm a b

/-- Symmetric variant of the unit identity. -/
theorem traceForm_jordanProduct_oneH3O (a b : H3O) :
    traceForm (jordanProduct a b) oneH3O = traceForm a b
```

If the first theorem is too hard, prove the two unit identities first and
record the exact blocker for the full Frobenius identity.

## Package

Add:

```lean
structure TraceFormFrobeniusPackage where
  frobenius :
    forall a b c : H3O,
      traceForm (jordanProduct a b) c = traceForm a (jordanProduct b c)
  one_left :
    forall a b : H3O,
      traceForm oneH3O (jordanProduct a b) = traceForm a b
  one_right :
    forall a b : H3O,
      traceForm (jordanProduct a b) oneH3O = traceForm a b

noncomputable def traceFormFrobeniusPackage :
    TraceFormFrobeniusPackage
```

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/TraceFormFrobenius.lean
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave9-20260604`

Job ID: `68007ce0-18d2-43d5-a7c8-ccf0bcf1fc00`

## Result

Status: COMPLETE, integrated 2026-06-04.

Output archive:
`AgentTasks/aristotle-output/68007ce0-output`

Extracted output:
`AgentTasks/aristotle-output/68007ce0-output-extracted/paper-wave9-20260604_aristotle`

Integrated module:

```text
PhysicsSM/Algebra/Jordan/TraceFormFrobenius.lean
```

Top-level import added to `PhysicsSM.lean`.

Verification run after integration:

```bash
lake env lean PhysicsSM/Algebra/Jordan/TraceFormFrobenius.lean
```
