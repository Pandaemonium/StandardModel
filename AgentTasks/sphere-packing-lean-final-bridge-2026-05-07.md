# Sphere-Packing-Lean final bridge wave - 2026-05-07

Status: submitted 2026-05-07.

Purpose: close the remaining Hamming -> Construction A -> E8 manuscript bridge
from the dependency-free SPL-shaped matrix comparison to the actual imported
Sphere-Packing-Lean E8 object.

The local dependency-free bridge is now trusted:

```text
PhysicsSM/Coding/E8SpherePackingMatrixBridge.lean
```

The direct SPL import reconnaissance file is:

```text
PhysicsSM/Draft/E8SpherePackingImported.lean
```

Submission project:

```text
AgentTasks/aristotle-submit/sphere-packing-lean-final-bridge-20260507-project
```

The submission copy has an SPL-enabled `lakefile.toml` so Aristotle can attempt
the import bridge in a Linux environment. The main repo keeps SPL commented out
for native Windows compatibility.

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| FB1: imported `E8Matrix` equals local `splE8BasisQ` | `AgentTasks/aristotle-output/spl-imported-matrix-equality` | `e0985288-a919-4f73-b1a9-61a04896b4e3` | queued |
| FB2: imported `Submodule.E8` span and density transport scaffold | `AgentTasks/aristotle-output/spl-span-density-transport` | `a590f96e-3588-4284-a17e-d3b199b5107b` | queued |

## Shared constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- This is an SPL-enabled branch/job. It may import
  `SpherePacking.Dim8.E8.Basic` and `SpherePacking.Dim8.E8.Packing`.
- Keep SPL-dependent work in `PhysicsSM/Draft`.
- Trusted local files must not gain an SPL dependency.
- No fake density theorem: only claim density/optimality after a real imported
  SPL theorem and a real checked bridge.
- If the complete bridge is too hard, return the strongest typechecked
  statement plus exact blockers.

## FB1: imported matrix equality

Write scope:

- `PhysicsSM/Draft/E8SpherePackingImported.lean`.
- Optional helper file under `PhysicsSM/Draft`.

Goal:

Prove the hinge theorem identifying the imported SPL matrix with the local
dependency-free reproduction.

Target declarations:

```lean
theorem imported_E8Matrix_Q_eq_splE8BasisQ :
    E8Matrix Q = PhysicsSM.Coding.splE8BasisQ
```

If names or coercions differ, use the semantically equivalent statement:

- equality after `Matrix.map` into `Q`;
- equality row-by-row;
- equality after transposition if SPL and PhysicsSM use opposite row/column
  conventions, with the convention documented.

Then prove the direct imported determinant/Gram bridge:

```lean
theorem imported_E8Matrix_gram_eq_splE8GramQ :
    E8Matrix Q * (E8Matrix Q).transpose = PhysicsSM.Coding.splE8GramQ
```

Minimum useful result:

- A compiling SPL-import draft file proving exact matrix equality or a precise
  row/transpose-adjusted equality with the local `splE8BasisQ`.

## FB2: imported span and density transport scaffold

Write scope:

- `PhysicsSM/Draft/E8SpherePackingImported.lean`.
- Optional helper file under `PhysicsSM/Draft`.

Goal:

Use the imported matrix equality from FB1 plus SPL's `span_E8Matrix` to connect
the local SPL-shaped matrix bridge to `Submodule.E8`. If possible, start the
density transport statement.

Target declarations:

```lean
theorem local_splE8BasisQ_span_eq_imported_E8_Q :
    Submodule.span Z (Set.range PhysicsSM.Coding.splE8BasisQ.row) =
      Submodule.E8 Q
```

For real coordinates:

```lean
theorem local_splE8BasisR_span_eq_imported_E8_R :
    -- same statement after mapping Q entries to R, if this is the better bridge
```

Then state the strongest available composition theorem connecting the local
Construction A matrix bridge to `Submodule.E8`. Acceptable endpoints, in order:

1. a checked submodule equality after the documented embedding/change of basis;
2. a checked `LinearEquiv` or isometry-shaped theorem;
3. a checked theorem saying both row-span Gram matrices are congruent to the
   same imported E8 Cartan/Gram matrix;
4. a precise draft theorem statement with exact blockers.

If the bridge is strong enough, add a density transport theorem using:

```lean
E8Packing_density
```

Minimum useful result:

- A compiling SPL-import draft file proving the local SPL basis span is exactly
  imported `Submodule.E8`, and documenting the remaining map from the
  Construction A basis to that span if full transport is not completed.
