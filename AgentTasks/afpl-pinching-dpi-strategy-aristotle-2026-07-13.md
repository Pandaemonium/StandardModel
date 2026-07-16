# Aristotle strategy-to-theorem job: genuine pinching-channel DPI

- Work item: `DYN-MODULAR-001`
- Role: Oracle / Builder / Assassin
- Priority: independent information-theory frontier
- Date: 2026-07-13
- Aristotle project: `2963f848-9876-435f-af9f-e9dc68021d7b`

## Mission

Design the smallest honest Lean theorem proving data processing of quantum
relative entropy under one explicit nontrivial pinching/dephasing channel. The
current `ProjectiveMeasurementDPI` proves that the classical outcome relative
entropy in the reference eigenbasis is bounded by the original quantum
relative entropy. The successor must either identify that outcome law with the
quantum relative entropy of an explicitly pinched pair of density matrices, or
prove precisely why Mathlib's noncanonical spectral basis prevents that
identification and give the nearest fixed-basis qubit theorem instead.

## Required inputs to inspect

- `PhysicsSM/Draft/NullEdge/ProjectiveMeasurementDPI.lean`
- `PhysicsSM/Draft/NullEdge/GeneralQuantumKlein.lean`
- `PhysicsSM/Draft/NullEdge/ScalarKleinEqualityCore.lean`
- `PhysicsSM/Draft/NullEdge/FiniteClassicalDPI.lean`
- `PhysicsSM/Draft/NullEdge/ObserverPartialTrace.lean`

## Required output

Return a compact strategy memo plus a typechecking Lean target file with
immutable definitions and theorem statements. The target must include:

1. an explicit channel definition, preferably fixed-basis qubit pinching or
   reference-eigenbasis pinching;
2. Hermiticity, PSD, and trace-preservation obligations;
3. `D(Phi rho || Phi sigma) <= D(rho || sigma)` stated using the repository's
   actual quantum-relative-entropy definition, not merely classical output
   probabilities;
4. one exact strict noncommuting witness, or a precise API blocker if strict
   evaluation is impossible because of spectral choice;
5. a self/shared-basis equality control;
6. a 30/90/240-minute proof ladder and exact imports/declarations.

## Kill and honesty conditions

- Do not call Klein nonnegativity itself data processing.
- Do not claim arbitrary CPTP monotonicity, partial-trace DPI, Petz recovery,
  or gravity.
- If the quantum post-channel entropy cannot be identified without an
  unproved eigenvalue-ordering lemma, return that exact missing lemma and a
  narrower fixed-basis target rather than hiding the gap.
- Use no new assumptions merely to force the result.

The result should let the next agent submit a proof job immediately.
