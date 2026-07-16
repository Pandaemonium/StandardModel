# Aristotle proof: exact HNU infrared Weyl tangent

```yaml
aristotle:
  project_id: c626cb61-f1db-49ff-aa41-a9d96e9152ad
  task_id: 5a562c93-6cb7-4a5a-bc40-bb54aeab1a3a
  target_file: HNUInfraredTangent.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUInfraredTangent
  status: integrated
```

## Purpose

This is Bridge B1 from the continuum/3+1 synthesis. It connects the exact
corrected depth-eight HNU endpoint to a continuum Weyl generator at the origin.

## Exact targets

Using the uploaded live `HNUExactCore.lean`, define the coordinate rays

```lean
def axisRay (j : Fin 3) (t : Real) : Fin 3 -> Real :=
  fun i => if i = j then t else 0
```

and prove, with the existing HNU sign and rightmost-first ordering conventions,

```text
d/dt endpoint(axisRay 0 t)|0 = -i sigma1
d/dt endpoint(axisRay 1 t)|0 = -i sigma2
d/dt endpoint(axisRay 2 t)|0 = -i sigma3
```

as genuine `HasDerivAt` theorems in the finite-dimensional matrix normed space.
Then prove the combined ray theorem for fixed `q : Fin 3 -> Real`:

```text
d/dt endpoint(t*q)|0 = -i * (q0 sigma1 + q1 sigma2 + q2 sigma3).
```

If the exact coefficient or sign differs, do not alter definitions to force the
target. Prove the corrected formula and explain the convention mismatch.

## Required controls

- prove the zero derivative for the constant zero ray as a boundary control;
- include explicit nonzero axis witnesses, e.g. the axis-1 derivative is not
  zero;
- add standard-three axiom guards;
- no compiled evaluation, new assumptions, or proof placeholders.

## Scope

This is a first-derivative/tangent theorem. It is not a uniform error bound,
many-step limit, position-space PDE theorem, winding theorem, chirality proof,
or primitive-null construction.

## Integration record

- Interactive Claude/Opus independently approved the whole module; review:
  `AutonomousLab/reviews/CLAUDE_REVIEW_HNUInfraredTangent_2026-07-13.md`.
- Integrated as `PhysicsSM/Draft/NullEdge/HNUInfraredTangent.lean`, retargeting
  only the import and namespace while preserving the reviewed proof body.
- Added provenance, local standard-three guards, root import, and central
  flagship guards.
- Verification passed:
  `lake env lean PhysicsSM/Draft/NullEdge/HNUInfraredTangent.lean` and
  `lake build PhysicsSM.Draft.NullEdge.HNUInfraredTangent`.
- The same Aristotle project remains active on successor task
  `10a6436c-e878-4d00-bd06-7b5a655ec316`, which composes this tangent with the
  exact Weyl-orientation/charge architecture.
