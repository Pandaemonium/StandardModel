# Aristotle C98: interface-shape does not imply chiral index witness

Date: 2026-06-27
Type: independent finite Lean/audit job
Dependency class: independent. This job does not need C89/C92/C93/C95/C97 to return.

## Background

The null-edge Gate C program separates:

- C0: external species health.
- C1: physical chiral release.

C93 is currently running as an overlap/Ginsparg-Wilson C1 interface. But an algebraic interface shape by itself can be satisfied by trivial or zero-index models. C1 must require a separate nonzero chiral/index witness.

This job should formalize that guardrail in a tiny finite model.

## Task

Create a small finite theorem package or Lean-ready report proving that interface shape alone does not imply a chiral index witness.

Preferred Lean module:

```text
PhysicsSM/Draft/NullEdgeChiralIndexWitnessGuardrail.lean
```

If Lean is feasible, keep it independent of the full null-edge operator and use finite tables or toy records. If Lean is not feasible, return Lean-ready declarations and proof sketches.

## Suggested finite API

Define a toy candidate with enough fields to distinguish form from content:

```text
structure InterfaceToy where
  hasInterfaceShape : Prop or Bool
  plusCount : Nat
  minusCount : Nat
```

Define:

```text
InterfaceShape T := T.hasInterfaceShape
ChiralIndexWitness T := T.plusCount != T.minusCount
ZeroIndex T := T.plusCount = T.minusCount
```

Or use an integer-valued index if simpler.

## Required theorems

Prove explicit finite guardrails:

```text
interface_shape_not_index_witness:
  exists T, InterfaceShape T and not ChiralIndexWitness T.
```

Make the witness concrete, for example:

```text
hasInterfaceShape = true, plusCount = 1, minusCount = 1
```

Also prove a positive non-vacuity witness:

```text
interface_shape_with_index_witness:
  exists T, InterfaceShape T and ChiralIndexWitness T.
```

for example:

```text
hasInterfaceShape = true, plusCount = 1, minusCount = 0
```

If using `ZeroIndex`, prove:

```text
zero_index_blocks_chiral_witness:
  ZeroIndex T -> not ChiralIndexWitness T.
```

## Scientific role

This guardrail should be consumed by C93/C94:

```text
Overlap/Ginsparg-Wilson/domain-wall interface shape
is not C1 release unless paired with a nonzero index / AntiVectorlikeWitness.
```

It protects against the zero-operator or vectorlike-interface trap.

## Constraints

- Do not import the full null-edge operator unless necessary.
- Do not define `InterfaceShape` so that it already contains nonzero index.
- Do not prove a release theorem.
- Include explicit finite examples/countermodels, not only abstract non-implication over arbitrary predicates.
- Avoid placeholder proofs in headline theorems if producing Lean.

## Desired output summary

At the end, state whether the output gives:

```text
A concrete interface-shaped zero-index countermodel.
A concrete interface-shaped nonzero-index witness.
A reusable guardrail theorem for C93/C94.
```
