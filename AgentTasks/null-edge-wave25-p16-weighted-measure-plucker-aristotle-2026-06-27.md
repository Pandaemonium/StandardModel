# Aristotle P16: finite weighted-measure Pluecker theorem

aristotle:
  project_id: 8dbe5125-d0e9-4c8f-a7c4-ab2ca98550da
  task_id: 749797a7-a2f5-4d93-86ee-6e46b20e7d08
  target_file: PhysicsSM/Draft/NullEdgeMeasurePluckerApproximation.lean
  expected_module: PhysicsSM.Draft.NullEdgeMeasurePluckerApproximation
  submission_project: AgentTasks/aristotle-submit/null-edge-wave25-lateral-analysis-20260627-project
  output_dir: AgentTasks/aristotle-output/8dbe5125-d0e9-4c8f-a7c4-ab2ca98550da
  status: submitted
  initial_project_status: RUNNING
  initial_task_status: QUEUED

Dependency class: Independent, but may import the P1 Pluecker core.

Context pack:

```text
AgentTasks/context-packs/null-edge-wave25-lateral-analysis-20260627-114614.md
```

## Background

The lateral analysis proposes a continuum/null-dust extension:

```text
P = integral psi psi^dagger dmu(psi)
det(P) ~ integral integral |psi wedge phi|^2 dmu(psi) dmu(phi)
```

Before attempting analytic measure theory, the right Lean target is the finite
positive-weight version. It is the exact finite proxy for a measure-valued
Pluecker theorem and a clean bridge from P1 to a later P1.5/P1.6 continuum
approximation story.

## Requested target

Create:

```text
PhysicsSM/Draft/NullEdgeMeasurePluckerApproximation.lean
```

The module should define a finite weighted null-spinor measure and prove the
weighted Cauchy-Binet / Pluecker identity.

## Desired API

Suggested shape:

```lean
def weightedBundleMomentum {n : Nat}
    (w : Fin n -> Real) (psi : Fin n -> CSpinor) :
    Matrix (Fin 2) (Fin 2) Complex :=
  sum_i (w i : Complex) • rankOneHermitian (psi i)

def weightedPairwisePluckerMass {n : Nat}
    (w : Fin n -> Real) (psi : Fin n -> CSpinor) : Real :=
  sum_{i<j} w i * w j * normSq (spinorWedge (psi i) (psi j))
```

Then prove, with the cleanest feasible exact normalization:

```text
det(weightedBundleMomentum w psi)
  = weightedPairwisePluckerMass w psi
```

as a complex equality or real-part equality.

If arbitrary real weights introduce distracting sign issues, first prove the
statement for nonnegative weights and document that this is the finite positive
measure case.

## Massless/support criterion

If feasible, add the finite support criterion:

```text
for nonnegative weights, determinant zero implies every pair with positive
weight has zero wedge
```

and, with a chosen positive nonzero base weight, derive:

```text
det = 0 iff all positive-weight spinors are scalar multiples of the base
```

This is the finite version of "measure supported on one projective direction."

## Explicit non-goals

Do not claim:

- analytic integration over a celestial sphere;
- weak convergence;
- DEC or continuum stress-energy;
- any mass prediction.

## Acceptance criteria

- New Lean file compiles.
- No new `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or
  `u n s a f e`.
- The module docstring says this is a finite positive-measure proxy, not the
  continuum theorem.
- The final report states the exact normalization and whether weights are
  arbitrary real, nonnegative real, or complex.
