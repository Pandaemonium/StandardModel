# HNU Cayley even-determinant Aristotle task

## Objective

Prove the determinant-level bridge from exact reciprocal Floquet roots to
opposite inverse-Cayley energies for the live massive HNU walk.

## Landed inputs

- `HNUMassiveSpectralReciprocity.massiveHNU_shifted_det_reciprocal` proves the
  full degree-four characteristic determinant is reciprocal for every nonzero
  complex spectral parameter.
- `HNUMassiveGlobalGap.massiveHNU_zero_pi_gap` supplies the `+1` and `-1` gaps
  on the closed Brillouin cube when `0 < a < pi`.
- `HNUCayleyBandSelector.cayleyGenerator` is
  `i (U - 1) (U + 1)^-1` in the live convention.

The scalar Cayley map sends `lambda` and `lambda^-1` to opposite values.  Work
at the determinant level and preserve the theorem statement exactly.  This is
not yet ordered eigenvalue pairing, rank-two inertia, projector continuity, or
physical-sector selection.

## Local landing while Aristotle runs

The target was closed independently in
`PhysicsSM/Draft/NullEdge/HNUCayleyEvenDeterminant.lean` and pinned by
`HNUCayleyEvenDeterminantAxiomGuard.lean`. The proof first derives
`det (massiveHNU 1 a k) = 1`, upgrades reciprocal characteristic symmetry to
the homogeneous swap

`det (y U - z I) = det (z U - y I)`,

and factors the two inverse-Cayley shifts through the common inverse of
`U + I`. The final theorem is exactly the submitted statement. Direct source,
guard, and targeted guard builds pass. The Aristotle task remains in flight as
an independent proof/audit and must be harvested separately before its result is
credited.

Semantic context pack:
`AgentTasks/context-packs/hnu-cayley-even-determinant-20260721-20260721-161726.md`.

## Aristotle metadata

```yaml
aristotle:
  project_id: 09c09e63-6955-407e-9be5-04520ed388b2
  task_id: 5db64d8f-5b09-4215-849f-5e3eaca7360d
  target_file: AgentTasks/aristotle-full/hnu-cayley-even-determinant-20260721/Main.lean
  expected_module: Main
  submission_project: AgentTasks/aristotle-submit/hnu-cayley-even-determinant-20260721-project
  output_dir: AgentTasks/aristotle-output/09c09e63-6955-407e-9be5-04520ed388b2
  status: running
```
