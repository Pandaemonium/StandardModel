# Aristotle job: superposed geometries and the Lambda phase (geometry register)

Date: 2026-07-09.  Origin: Pro "positive Hodge theory of finite null
information" synthesis (sec 1-2: the background-independent carrier
`K = oplus_K K_K`, "the universe is a finite superposition of null encodings
that decodes itself"; sec 7: `U_Lambda = exp(i Lambda N̂)`, Lambda conjugate
to event count).  Complements the landed `PathSumSemantics` (histories as the
hidden register) by making the GEOMETRY the hidden register, and complements
the Lambda lane L1-L4 (`LambdaUnimodular` landed, `lambda-susceptibility` and
`lambda-count-dichotomy` submitted) which treat statistics, not coherence.

## Statement package

Standalone Mathlib-only package.  Model: two geometry branches with event
counts `N i`, amplitudes `a i`, visible states `psi i`, record-overlap matrix
`Om`; the Lambda-dressed reduced visible state `rhoVis` carries the phase
`exp(I Lambda N i)` per branch.  Targets: Hermiticity; orthogonal records
imply Lambda-independence (decohered multiverse hides Lambda); equal counts
imply Lambda-independence (global phase); the interference coefficient
carries exactly `exp(I Lambda (N0 - N1))` (finite Fourier conjugacy);
pi-periodicity for counts `(1,3)`; and the positive witness that coherent
branches of different count make `rhoVis(0) != rhoVis(pi/2)`.

The sharp finite claim the package pins: **Lambda is observable exactly
through geometry-register coherence between branches of different event
count.**  Honest scope (in-file): two branches, overlap supplied as data, no
continuum, no derivation of Lambda's value.  Statements handed off with
documented `s o r r y` markers; all typecheck.

## Metadata

```yaml
aristotle:
  project_id: e4aad67f-5c4d-48d6-81fe-1793cdf42c7b
  target_file: AgentTasks/aristotle-standalone/geometry-register-lambda-20260709/GeometryRegisterLambda/GeometrySuperposition.lean
  expected_module: GeometryRegisterLambda.GeometrySuperposition
  submission_project: AgentTasks/aristotle-submit/geometry-register-lambda-20260709-project
  output_dir: AgentTasks/aristotle-output/e4aad67f-5c4d-48d6-81fe-1793cdf42c7b
  status: submitted
```

## Integration notes

On completion: dry-run integrate helper, review, port to
`PhysicsSM/Draft/NullEdge/` with guard blocks; record in the Lambda doc
(`Sources/Null_Edge_Cosmological_Constant_2026-07-09.md`) as the coherence
rung alongside L1-L4, and in `Sources/Null_Edge_Future_Directions.md`.
