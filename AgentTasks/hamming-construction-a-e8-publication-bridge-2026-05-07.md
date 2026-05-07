# Hamming Construction A E8 publication bridge Aristotle jobs - 2026-05-07

Status: submitted 2026-05-07.

Purpose: push the Hamming code -> Construction A -> E8 publication plan from a
minimum-norm theorem island toward a publication-grade bridge with self-duality,
Type II coding theory, scaled E8 normalization, explicit bases, shortest-vector
counts, and compatibility with the Sphere-Packing-Lean E8 endpoint.

Source planning document:

- `Sources/Hamming_ConstructionA_E8_Publication_Outline.md`

Submission project:

```text
AgentTasks/aristotle-submit/hamming-e8-publication-20260507-project
```

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| H1: Hamming self-duality and Type II package | `AgentTasks/aristotle-output/hamming-e8-self-dual-typeii` | `8a9baa92-051d-4668-b466-0f31cd93a7ed` | queued |
| H2: scaled Construction A E8 minimum norm 2 | `AgentTasks/aristotle-output/hamming-e8-scaled-min-norm` | `66bcf261-c71d-4026-b95a-fdc650f47f39` | queued |
| H3: explicit Construction A basis and Gram matrix | `AgentTasks/aristotle-output/hamming-e8-basis-gram` | `cffdeda7-5745-4da3-aed5-75f8df59bb5f` | queued |
| H4: 240 shortest vectors and root-list bridge | `AgentTasks/aristotle-output/hamming-e8-short-vectors-240` | `d4e9f753-1e05-4190-a3a8-c5ca4e88468b` | queued |
| H5: half-integer coordinate model bridge | `AgentTasks/aristotle-output/hamming-e8-half-integer-bridge` | `c2b792b2-b66d-4364-987a-3e9602224ea3` | queued |
| H6: Sphere-Packing-Lean bridge scaffold | `AgentTasks/aristotle-output/hamming-e8-spherepacking-bridge` | `52d0e19d-4823-4f9b-aa6e-c33f3e623fab` | queued |

Submission check:

- `lake env lean PhysicsSM/Coding/HammingE8.lean` passed in the live repo.
- `lake env lean PhysicsSM/Algebra/Octonion/IntegralOctonion.lean` passed in
  the live repo.
- `lake env lean PhysicsSM.lean` passed in the live repo.
- `lake build PhysicsSM.Coding.HammingE8` passed in the slim submission
  project before the temporary `.lake` cache was removed for upload size.

## General constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce axioms, `opaque`, `unsafe`, `admit`, or trusted `sorry`.
- Trusted modules must be sorry-free. If a target is too ambitious, return a
  smaller trusted theorem and a documented handoff in `PhysicsSM/Draft/`.
- Keep the integer norm 4 and scaled real norm 2 conventions visibly separate.
- Prefer small imports. Do not import all of Mathlib in a new file unless the
  existing nearby module already does and there is a clear reason.
- Preserve the existing definitions in:
  - `PhysicsSM/Coding/ConstructionA.lean`
  - `PhysicsSM/Coding/HammingE8.lean`
  - `PhysicsSM/Algebra/Octonion/IntegralOctonion.lean`
- Do not weaken existing theorem statements.
- Add module docstrings and provenance notes.
- Run `lake env lean <file>` for every touched Lean file before returning.

## Existing trusted footholds

In `PhysicsSM.Coding.ConstructionA`:

- `BinaryVector`
- `BinaryLinearCode`
- `hammingWeight`
- `IsDoublyEven`
- `reduceModTwo`
- `constructionA`
- `mem_constructionA_iff`
- `sqNorm`
- `constructionA_sqNorm_ge_four`

In `PhysicsSM.Coding.HammingE8`:

- `extendedHamming8ParityCheck`
- `extendedHamming8`
- `extendedHamming8_card`
- `extendedHamming8_minWeight`
- `extendedHamming8_doublyEven`
- `e8IntLattice`
- `mem_e8IntLattice_iff`
- `mem_e8IntLattice_iff_parityCheck`
- `e8IntLattice_sqNorm_ge_four`
- `e8IntLattice_achieves_sqNorm_four`
- `e8IntLattice_minSqNorm`

In `PhysicsSM.Algebra.Octonion.E8Root`:

- `normSqD`
- `dotD`
- `IsE8RootD`
- `rootList`
- `rootList_length`
- `rootList_nodup`
- `rootList_all_isE8RootD`
- `rootList_complete`
- `normSqD_eq_8`
- `dotD_values_distinct`
- `toOctonion`
- `normSq_toOctonion`

## Job H1: Hamming self-duality and Type II package

Write scope:

- `PhysicsSM/Coding/HammingSelfDual.lean`
- optional tiny additions to `PhysicsSM/Coding/ConstructionA.lean` only if they
  are reusable definitions such as a binary dot product.

Goal:

Prove that the existing extended Hamming code is self-dual and package it as a
Type II binary code.

Target declarations:

- `binaryDot` or a similar coordinate dot product on `BinaryVector n`.
- `dualCode` or `BinaryLinearCode.dual`.
- `SelfDualCode`.
- `IsTypeII`.
- `extendedHamming8_selfOrthogonal`.
- `extendedHamming8_selfDual`.
- `extendedHamming8_typeII`.

Proof hints:

- The code already has cardinality 16.
- In dimension 8 over `ZMod 2`, self-orthogonal plus cardinality 16 should give
  self-dual.
- Finite enumeration with `native_decide` is acceptable for the concrete
  `extendedHamming8` theorem, but make definitions reusable.

Minimum useful result:

- A sorry-free theorem that every pair of codewords in `extendedHamming8` has
  binary dot product zero, plus a documented plan for the self-duality equality
  if the full submodule-cardinality proof is too hard.

## Job H2: scaled Construction A E8 minimum norm 2

Write scope:

- `PhysicsSM/Coding/E8Scaled.lean`

Goal:

Define a real/scaled model of the Construction A lattice and prove that the
minimum nonzero squared norm is 2 after scaling by `1 / sqrt 2`.

Target declarations:

- `intVectorToReal`.
- `scaledE8Vector`, mapping `z : Fin 8 -> Int` to `Fin 8 -> Real`.
- `scaledSqNorm`.
- `scaledSqNorm_eq_sqNorm_div_two`.
- `scaledE8_minSqNorm_two`.

Proof hints:

- Start from `e8IntLattice_minSqNorm`.
- Avoid a full topological lattice API if unnecessary. A predicate/set of real
  vectors is enough for this job.
- The theorem may quantify over integer preimages rather than proving
  injectivity/surjectivity of a real lattice wrapper.

Minimum useful result:

- A theorem saying that for every nonzero `z : Fin 8 -> Int` in
  `e8IntLattice`, the scaled vector has squared norm at least 2, and that an
  example attains 2.

## Job H3: explicit Construction A basis and Gram matrix

Write scope:

- `PhysicsSM/Coding/E8Basis.lean`

Goal:

Choose an explicit eight-vector integer basis for `e8IntLattice`, prove the
basis vectors are members of the Construction A lattice, and compute the Gram
matrix. If feasible, prove the basis spans the lattice.

Target declarations:

- `e8CodeBasisInt : Fin 8 -> Fin 8 -> Int`.
- `e8CodeBasisInt_mem`.
- `e8CodeBasisGram`.
- `e8CodeBasisGram_eq`.
- `e8CodeBasisGram_det`.
- stretch: `e8CodeBasisInt_spans`.

Proof hints:

- It is acceptable to choose a basis whose Gram matrix is an E8 Cartan/Gram
  matrix up to permutation.
- The project already has `PhysicsSM.Lie.Exceptional.E8`; compare to local E8
  Cartan data if that is easier than importing Sphere-Packing-Lean.
- A finite determinant computation with `native_decide` is acceptable if the
  statement is exact over `Int`.

Minimum useful result:

- A sorry-free membership theorem for all basis vectors and a sorry-free exact
  Gram matrix theorem.

## Job H4: 240 shortest vectors and root-list bridge

Write scope:

- `PhysicsSM/Coding/E8ShortVectors.lean`

Goal:

Classify/count the integer vectors in `e8IntLattice` with squared norm 4, and
connect them to the existing doubled-coordinate `E8Root.rootList`.

Target declarations:

- `isShortE8IntVector`.
- `shortE8IntVectorList`.
- `shortE8IntVectorList_nodup`.
- `shortE8IntVectorList_length`.
- `shortE8IntVectorList_complete`.
- `shortE8IntVectorList_card_eq_240`.
- `shortE8IntVectorList_to_E8Root`.

Proof hints:

- Vectors with integer squared norm 4 have coordinates of shape
  `(+/-2,0,...,0)` or `(+/-1,+/-1,+/-1,+/-1,0,0,0,0)`.
- Use `mem_e8IntLattice_iff_parityCheck` for the Hamming parity condition.
- Use `E8Root.rootList_length`, `rootList_nodup`, and `rootList_complete`
  where possible.

Minimum useful result:

- A sorry-free 240-element explicit list of short vectors, with membership,
  norm, nodup, and length theorems.

## Job H5: half-integer coordinate model bridge

Write scope:

- `PhysicsSM/Coding/E8HalfIntegerBridge.lean`

Goal:

Define the standard half-integer/integer even-sum coordinate model of E8 and
prove a bridge from the scaled Hamming Construction A model to that coordinate
model.

Target declarations:

- `HalfIntegerCoordinate`.
- `halfIntegerE8Predicate`.
- `scaledConstructionA_to_halfIntegerE8`.
- `halfIntegerE8_to_scaledConstructionA`.
- `scaledE8_eq_halfIntegerE8`.

Proof hints:

- Keep the theorem as an equivalence of predicates if equality of submodules is
  too heavy.
- Make the normalization explicit: integer Construction A has minimum squared
  norm 4; scaled E8 has minimum squared norm 2.
- This theorem is intended as the shortest path to Sphere-Packing-Lean's E8
  coordinate model.

Minimum useful result:

- Bidirectional membership lemmas between the scaled Construction A preimage
  and the half-integer even-sum coordinate predicate.

## Job H6: Sphere-Packing-Lean bridge scaffold

Write scope:

- `PhysicsSM/Draft/E8SpherePackingBridge.lean`

Goal:

Prepare the strongest typechecked bridge scaffold to Sphere-Packing-Lean that
is possible without pretending the dependency is locally available on Windows.

Target declarations:

- Local type aliases or structures needed to state a bridge theorem cleanly.
- A documented theorem statement for equality/isometry between our E8 model and
  Sphere-Packing-Lean's `Submodule.E8`/`E8Lattice` style model.
- If Sphere-Packing-Lean names are available in the submitted project, import
  them and prove the strongest bridge statement feasible.
- Otherwise, keep this in `PhysicsSM/Draft/` with explicit `sorry` handoff
  comments and no trusted fake theorem.

Proof hints:

- Read `lakefile.toml` comments about the Windows `Aux.lean` filename issue.
- The likely practical bridge is through either an exact Gram matrix theorem or
  a half-integer coordinate membership equivalence.
- Do not create local constants named as if they were Sphere-Packing-Lean
  definitions unless they are clearly marked as draft placeholders.

Minimum useful result:

- A typechecked draft file that records the exact theorem shape and blockers,
  with no trusted claims about the sphere-packing theorem itself.
