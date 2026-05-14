# Sphere-Packing-Lean bridge next wave - 2026-05-07

Status: completed and integrated 2026-05-07.

Purpose: move the Hamming -> Construction A -> E8 manuscript from the strong
local theorem package to the external Sphere-Packing-Lean (SPL) endpoint.

The local strong-paper spine is now represented by:

```text
PhysicsSM/Coding/HammingConstructionAE8Final.lean
```

The remaining headline target is to identify this local E8 model with the E8
lattice used by Sphere-Packing-Lean and, if possible, transport its density or
optimality theorem.

Submission project:

```text
AgentTasks/aristotle-submit/sphere-packing-lean-bridge-20260507-project
```

## Current SPL source facts

Checked 2026-05-07 against
`https://raw.githubusercontent.com/math-inc/Sphere-Packing-Lean/main/SpherePacking/Dim8/E8/Basic.lean`.

That source documents and defines:

- `Submodule.E8`: the E8 lattice as a `Submodule Z (Fin 8 -> R)` for a field
  `R` with `2 != 0`.
- `Submodule.E8_eq_sup`: the parity definition as an even lattice plus the
  half-vector span.
- `E8Matrix`: an explicit matrix whose rows form a basis for the E8 lattice.
- `E8Matrix_unimodular`: determinant `1`.
- `span_E8Matrix_eq_top`: real span is all of `R^8`.
- `span_E8Matrix`: the `Z`-span of the rows is `Submodule.E8`.
- `E8_integral` and `E8_integral_self`: integrality/evenness.
- `E8Lattice`, `E8Packing`, and `E8Packing_density`, with density
  `pi ^ 4 / 384`.

These names make the next bridge concrete: compare our `E8SpherePackingShape`
and `E8HalfIntegerBridge` theorem surfaces with SPL's `Submodule.E8`,
`E8Matrix`, and `E8Packing_density`.

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| SPL1: local SPL matrix/API bridge | `AgentTasks/aristotle-output/spl-local-matrix-bridge` | `c71fb42f-2bb1-450b-8248-7473c3db9d28` | complete; integrated |
| SPL2: direct SPL import bridge attempt | `AgentTasks/aristotle-output/spl-direct-import-bridge` | `73e972d1-8b93-4d1c-a5cf-29714bd2be44` | complete; integrated |

Integration note:

- `PhysicsSM/Coding/E8SpherePackingMatrixBridge.lean` is the dependency-free
  trusted matrix bridge. It locally reproduces SPL's `E8Matrix` over `Q`,
  proves determinant and Gram facts, proves half-integer predicate membership,
  and proves the SPL-shaped Gram matrix and the scaled Construction A Gram
  matrix are both congruent to `e8Cartan`.
- `PhysicsSM/Draft/E8SpherePackingImported.lean` is the Linux/macOS-only direct
  SPL import reconnaissance file. It confirms SPL declaration types and
  re-exports `E8Packing_density`.

Next bridge target:

- Prove in an SPL-enabled branch that imported `E8Matrix Q` equals local
  `splE8BasisQ`.
- Use SPL's `span_E8Matrix` to identify the local SPL-shaped matrix row span
  with `Submodule.E8`.
- Compose this with the dependency-free Gram-congruence bridge.

## Shared constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Trusted files must contain no `sorry`, `admit`, `axiom`, `opaque`, or
  `unsafe`.
- Do not claim the density or optimality theorem unless the imported SPL theorem
  is actually available and the bridge theorem is kernel-checked.
- Keep local dependency-free bridge facts in `PhysicsSM/Coding`.
- Put SPL-dependent experiments in `PhysicsSM/Draft`.
- If SPL cannot be fetched or imported, return a precise blocker report rather
  than weakening the target silently.

## SPL1: local SPL matrix/API bridge

Write scope:

- `PhysicsSM/Coding/E8SpherePackingMatrixBridge.lean`.
- Optional import update in `PhysicsSM.lean` only if the file is trusted and
  compiles locally without the SPL dependency.

Goal:

Create the dependency-free mathematical bridge to SPL's E8 basis matrix. This
should not import SPL. It should reproduce the mathematical matrix data from
the public Apache-2.0 SPL source with attribution and prove local comparison
theorems against our Construction A model.

Target declarations:

- A local rational or real version of SPL's `E8Matrix` rows, named so it is
  clearly an SPL-shaped compatibility target rather than the imported object.
- A local Gram matrix for that basis, matching the SPL `E8.inn` matrix.
- Proof that the local SPL-shaped basis rows satisfy the half-integer/integer
  even-sum E8 predicate already formalized in `E8HalfIntegerBridge.lean` or
  `Draft/E8SpherePackingBridge.lean`.
- The strongest feasible comparison to our existing basis/Gram facts:
  either a determinant theorem, a Gram equality after a change of basis, or a
  theorem explicitly reducing the final SPL bridge to a named matrix identity.

Minimum useful result:

- A sorry-free trusted file that fixes the exact matrix-normalization target for
  the imported SPL bridge, with verbose provenance comments.

## SPL2: direct SPL import bridge attempt

Write scope:

- `PhysicsSM/Draft/E8SpherePackingImported.lean`.
- Optional local copy of `lakefile.toml` in the Aristotle output if adding the
  SPL dependency is needed in Aristotle's Linux environment.

Goal:

Attempt the actual import-level bridge against `math-inc/Sphere-Packing-Lean`.
This job may modify the submitted project dependency set, but should keep the
main repo's Windows limitation documented.

Target declarations:

- Import `SpherePacking.Dim8.E8.Basic` if possible.
- Confirm the exact types of `Submodule.E8`, `E8Matrix`,
  `E8Matrix_unimodular`, `span_E8Matrix`, `E8Lattice`, `E8Packing`, and
  `E8Packing_density`.
- State the strongest typechecked bridge theorem between the local
  Hamming/Construction A model and SPL's E8 model. Prefer, in order:
  1. equality of submodules after the documented embedding/change of basis;
  2. a linear equivalence/isometry theorem;
  3. equality of Gram matrices against `E8Matrix` or `E8.inn`;
  4. a precise theorem statement with documented blockers and no misleading
     proof claim.
- If the bridge theorem succeeds, state a transported density theorem using
  `E8Packing_density`.

Minimum useful result:

- Either a compiling SPL-import draft file with a typechecked bridge statement,
  or a precise failure report explaining exactly which dependency/type issue
  blocks the bridge.
