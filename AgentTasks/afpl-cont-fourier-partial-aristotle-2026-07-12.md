# Aristotle proof job: Fourier derivative symbol with explicit 2*pi

## Context

The F2/F3 continuum strategy returned by Aristotle project
`5d4f2be5-f731-40ea-9dee-d5716b20be69` found that Mathlib's Fourier convention
is `exp(-2*pi*i*<x,w>)`. The position-space Dirac generator therefore carries
`-i/(2*pi)` when the landed momentum symbol uses the raw Fourier coordinate.
This job isolates the convention-critical Schwartz derivative theorem before
the PDE composition.

## Immutable target

Create a separate module
`PhysicsSM/Draft/NullEdge/FourierPartialCorrespondence.lean` importing Mathlib
and `ChangingCellFourierL2`. Preserve this mathematical statement:

```lean
/-- Forward Fourier transform of a coordinate derivative under Mathlib's
`exp(-2*pi*i*<x,w>)` convention. -/
theorem fourier_partial_correspondence
    (g : SchwartzMap FourierMomentum3 Spinor) (j : Fin 3) :
    (fourierTransform fun x =>
      fderiv Real (fun y => g y) x
        (EuclideanSpace.single j (1 : Real)))
      = fun w =>
          (2 * (Real.pi : Complex) * Complex.I * (w j : Complex)) •
            fourierTransform (fun x => g x) w := by
  sorry
```

The notation may be changed to the exact names/notations used by pinned
Mathlib (`fourierTransform`, `Real.fourier`, or `\uD835\uDC15`) only if the resulting
statement is definitionally the same. The sign and factor `2 * pi` are
immutable.

## Required route and controls

- Use Mathlib's `Real.fderiv_fourier`,
  `VectorFourier.fourierIntegral_fderiv`, `Real.fourier_deriv`, or the precise
  v4.28 successor declarations; record which direction each lemma proves.
- Discharge all integrability/differentiability conditions from the Schwartz
  API. Introduce no analytic assumption.
- Add a zero Schwartz-map control and one nonzero Gaussian-times-basis-vector
  example or explain the smallest existing Schwartz witness API needed for it.
- Expected footprint: standard kernel axioms only. No trust-expanding evaluator,
  new axiom, opaque placeholder, or dropped constant.
- Run the new file directly before any broad build.

## Kill condition

If the displayed function-level theorem is not expressible with the available
vector-valued API, return the smallest scalar/component theorem that implies it
by finite extensionality, with the exact missing assembly lemma. A result with
unit coefficient, the opposite sign, an unspecified Fourier convention, or an
`Lp` class evaluated pointwise is failure, not progress.

## Submission metadata

- Aristotle project: `3b1fe9d3-ed3f-4216-8a93-dee66fe15b2e`
- Submission project: `AgentTasks/aristotle-submit/cont-fourier-partial-20260712-project`
- Lab work item: `CONT-FOURIER-001`
- Status: submitted 2026-07-12 by Codex
