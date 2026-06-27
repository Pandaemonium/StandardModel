# Aristotle C95: anti-vectorialization guardrail for Gate C1

Date: 2026-06-27
Type: independent finite Lean/audit job
Dependency class: independent / soft-dependent. This job does not need C93's exact API.

## Background

The null-edge Gate C program has split into:

- C0: external species health, including branch lifting, regulator legality, Krein-positive physical sector, and ghost-zero safety.
- C1: physical chiral release, requiring an actual protected chiral/index mechanism such as overlap/Ginsparg-Wilson, domain-wall, or a mathematically equivalent finite chiral construction.

Recent Claude and Pro feedback emphasize that an overlap/Ginsparg-Wilson or domain-wall interface is not enough by itself. A candidate can still be vectorlike: every would-be plus chirality survivor may be paired by a minus chirality survivor, giving net index zero. Gate C1 therefore needs an explicit anti-vectorialization side condition.

This job exists to prevent future progress accounting from treating:

```text
C0 health + regulator exists + modified chirality exists
```

as moral C1 release.

## Task

Create a small, concrete, finite theorem package that formalizes the anti-vectorialization guardrail independently of the concrete null-edge operator.

Preferred output:

```text
PhysicsSM/Draft/NullEdgeAntiVectorializationGuardrail.lean
```

If a Lean module is not feasible within the job, return a precise report with Lean-ready definitions and theorem statements. Do not make a broad Gate C release claim.

## Required finite model

Use a finite table of physical modes/branches. Each mode should have enough data to define:

```text
chiralitySign : +1 or -1
multiplicity : Nat
isPhysical : Bool or Prop
c0Healthy : Bool or Prop
```

Define:

```text
plusCount
minusCount
netIndexNonzero := plusCount != minusCount
```

or an integer-valued `NetIndex`. Natural-count statements are preferred if they make the Lean proof simpler.

## Required predicates

Define a finite version of the honest secretly-vectorlike condition:

```text
VectorlikeSpectrum B : Prop
```

It should not merely mean `plusCount = minusCount` by definition if a slightly richer finite statement is easy. Prefer an explicit pairing or involution predicate:

```text
there exists a pairing/involution sigma on physical modes,
sigma has no fixed physical points,
sigma preserves multiplicity or mode weight,
sigma swaps chirality.
```

Define:

```text
C0Healthy B : Prop
```

as a deliberately weak external health predicate, e.g. every physical mode has `c0Healthy = true`. Do not include nonzero index inside `C0Healthy`.

Define a C1 discriminator:

```text
AntiVectorlikeWitness B : Prop
```

It can initially be `plusCount != minusCount` or `NetIndex B != 0`, but name it as the witness that future C1 release predicates must demand.

## Required theorems

Prove all of the following, with explicit finite examples/countermodels:

```text
vectorlike_implies_zero_index:
  VectorlikeSpectrum B -> plusCount B = minusCount B
  or VectorlikeSpectrum B -> NetIndex B = 0.

nonzero_index_forbids_vectorlike:
  AntiVectorlikeWitness B -> not VectorlikeSpectrum B.

c0_health_does_not_forbid_vectorlike:
  exists B0, C0Healthy B0 and VectorlikeSpectrum B0.
```

The third theorem is essential. It must be a concrete finite table, not merely an abstract existential over arbitrary predicates.

Also prove a discriminating example:

```text
exists B1, C0Healthy B1 and AntiVectorlikeWitness B1.
```

Together, the two examples show that C0 health is compatible with both vectorlike and non-vectorlike finite spectra, so C0 cannot decide C1.

## Optional but valuable theorem

If easy, prove a same-C0-health comparison theorem:

```text
there exist B0 B1 such that
  C0Healthy B0 and C0Healthy B1 and
  VectorlikeSpectrum B0 and AntiVectorlikeWitness B1.
```

This is the cleanest Lean-facing guardrail against saying C0 health implies C1 release.

## Scientific role

This module/report should become the guardrail used by C93/C94:

```text
Overlap/GW interface + regulator health + modified chirality
is still not C1 release unless AntiVectorlikeWitness / nonzero-index data are supplied.
```

## Constraints

- Keep the result finite and abstract; do not import the full null-edge operator unless necessary.
- Do not weaken the guardrail into a tautology.
- Do not state that C0 health implies C1 release.
- If using Lean, avoid placeholder proofs in headline theorems.
- If any assumption is needed, name it explicitly and explain whether it is a C1 hypothesis or a C0 hypothesis.
- Keep ghost-zero safety canonical: if C92 returns a ghost predicate, this module should later import/reuse it. For now, `C0Healthy` should be a toy external-health flag, not a second ghost-safety API.

## Desired output summary

At the end, state whether the output gives:

```text
A concrete finite anti-vectorialization theorem.
A concrete C0-healthy vectorlike countermodel.
A concrete C0-healthy non-vectorlike witness.
A reusable predicate or API for later C93/C94 integration.
```
