# Hamming E8 next wave after integration - 2026-05-07

Status: submitted 2026-05-07.

Purpose: queue the next helpful Aristotle jobs after the 2026-05-07 integration
of the Hamming -> Construction A -> E8 theorem files. This wave avoids repeating
the newly integrated results and focuses on the remaining proof gaps that would
most improve the paper.

Current integrated footholds:

- `PhysicsSM/Coding/HammingSelfDual.lean`
- `PhysicsSM/Coding/HammingWeightEnumerator.lean`
- `PhysicsSM/Coding/ConstructionALatticeProperties.lean`
- `PhysicsSM/Coding/E8Scaled.lean`
- `PhysicsSM/Coding/E8Basis.lean`
- `PhysicsSM/Coding/E8HalfIntegerBridge.lean`
- `PhysicsSM/Algebra/Octonion/E8RootCompleteness.lean`
- `PhysicsSM/Algebra/Division/CompositionAlgebra.lean`
- `PhysicsSM/Algebra/Furey/HyperchargeBridge.lean`
- `PhysicsSM/Draft/E8SpherePackingBridge.lean`

Submission project:

```text
AgentTasks/aristotle-submit/hamming-e8-next-after-integration-20260507-project
```

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| N1: E8 basis spanning theorem | `AgentTasks/aristotle-output/hamming-e8-basis-spanning` | `5685d64d-a6ef-4e2d-a2c1-fdfc5ad0bb11` | integrated |
| N2: 240 short-vector retry | `AgentTasks/aristotle-output/hamming-e8-short-vectors-retry` | `3afa2409-f851-4bd5-9b0d-334f6ca1032b` | queued |
| N3: Weyl reflection root-preservation retry | `AgentTasks/aristotle-output/hamming-e8-weyl-root-preservation-retry` | `4d7aa130-5e91-4c7e-b60e-a522d5fadac4` | queued |
| N4: composition-algebra Clifford precursor | `AgentTasks/aristotle-output/composition-clifford-precursor` | `94a4869e-98b9-4ce5-b465-a56efa802baf` | in progress |
| N5: Sphere-Packing bridge cleanup | `AgentTasks/aristotle-output/hamming-e8-spherepacking-cleanup` | `80b6869a-9d68-4217-8303-909dc95c2644` | queued |

Submission check:

- Slim submission project:
  `AgentTasks/aristotle-submit/hamming-e8-next-after-integration-20260507-project`.
- The slim project target build passed before upload for:
  `PhysicsSM.Coding.E8Basis`, `PhysicsSM.Coding.E8HalfIntegerBridge`,
  `PhysicsSM.Algebra.Division.CompositionAlgebra`,
  `PhysicsSM.Algebra.Octonion.E8RootCompleteness`, and
  `PhysicsSM.Draft.E8SpherePackingBridge`.
- The `.lake` build directory was removed before submission so Aristotle
  received source context only.

Integration note for N1:

- Integrated into `PhysicsSM/Coding/E8BasisSpanning.lean` and imported from
  `PhysicsSM.lean`.
- The module proves that `e8CodeBasisInt` spans
  `hammingConstructionALattice`, plus the determinant interpretation
  `e8CodeBasis_scaled_gram_det`.
- Local linter settings are scoped to the computational proof declarations that
  use flexible tactics; the theorem module builds without new warnings.

## General constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce axioms, `opaque`, `unsafe`, `admit`, or trusted `sorry`.
- Trusted modules must be sorry-free.
- Draft modules may contain documented `sorry` only for genuine external
  dependency blockers.
- Prefer the neutral name `hammingConstructionALattice`; `e8IntLattice` is a
  compatibility abbreviation.
- Do not claim an imported Sphere-Packing-Lean theorem unless the dependency is
  actually available in the submitted project.
- Run `lake env lean <file>` for every touched Lean file before returning.

## Job N1: E8 basis spanning theorem

Write scope:

- `PhysicsSM/Coding/E8BasisSpanning.lean`
- optional tiny additions to `PhysicsSM/Coding/E8Basis.lean` only for reusable
  helper definitions.

Goal:

Upgrade the integrated Gram-matrix result from "eight good lattice vectors" to
a genuine basis theorem for the Hamming Construction A subgroup.

Target declarations:

- `basisLinearCombination`.
- `e8CodeBasisInt_span_subset`.
- `e8CodeBasisInt_spans_hammingConstructionALattice`.
- if feasible, a `Z`-linear equivalence between `Fin 8 -> Int` coefficient
  vectors and `hammingConstructionALattice`.
- a theorem explaining that the determinant `256` is the unscaled Gram
  determinant of a spanning basis, so the scaled Gram determinant is `1`.

Proof hints:

- `e8CodeBasisInt_mem` and `e8CodeBasisGram_det` already exist.
- The Construction A subgroup contains `2 e_i` for all coordinates, and the
  first four basis vectors lift a generator set for the Hamming code.
- A practical proof may split any `z` in the subgroup into its parity-codeword
  part plus an even vector.

Minimum useful result:

- A sorry-free theorem that every `z : Fin 8 -> Int` in
  `hammingConstructionALattice` is an integer linear combination of
  `e8CodeBasisInt`.

## Job N2: 240 short-vector retry

Original failed job:

- `d4e9f753-1e05-4190-a3a8-c5ca4e88468b`

Write scope:

- `PhysicsSM/Coding/E8ShortVectors.lean`

Goal:

Retry the 240-short-vector theorem in a smaller, finite-enumeration-first form.
Do not try to prove Weyl group facts or Sphere-Packing-Lean compatibility in
this job.

Target declarations:

- `isShortHammingE8Vector`.
- `shortHammingE8VectorList`.
- `shortHammingE8VectorList_length`.
- `shortHammingE8VectorList_nodup`.
- `shortHammingE8VectorList_mem`.
- `shortHammingE8VectorList_complete`.
- `shortHammingE8Vector_count_eq_240`.

Proof hints:

- A short integer vector has `sqNorm = 4`.
- Coordinates must be in `{0, +/-1, +/-2}`.
- Membership is decidable using `mem_e8IntLattice_iff_parityCheck`.
- If completeness is hard, first prove that the explicit list has 240 members,
  all in the lattice, all with `sqNorm = 4`.

Minimum useful result:

- A sorry-free explicit list of 240 short vectors with length, nodup,
  membership, and norm theorems.

## Job N3: Weyl reflection root-preservation retry

Original failed job:

- `953b8c64-b1a1-411a-80c8-f0ad69d387bf`

Write scope:

- `PhysicsSM/Algebra/Octonion/E8WeylBasic.lean`

Goal:

Retry the Weyl-reflection target in a much smaller form: define the reflection
formula over the integrated `E8Root.rootList` and prove root-list preservation.
Do not compute the Weyl group order in this job.

Target declarations:

- `reflectD (r v : Fin 8 -> Int) : Fin 8 -> Int`.
- `reflectD_mem_rootList` for `r v : rootList`.
- `reflectD_involutive_on_rootList`, if feasible.
- a small `simpleRootListD`, if helpful for future work.

Proof hints:

- In doubled coordinates, actual inner product is `dotD / 4`, and roots have
  actual norm squared `2`.
- The integral reflection formula is `v - (dotD v r / 4) * r`.
- Use `dotD_div_four`, `rootList_complete_arbitrary`, and
  `mem_rootList_iff_isE8RootD` where possible.
- Finite preservation over the 240-root list is acceptable with `native_decide`
  if the module docstring records the trust boundary.

Minimum useful result:

- A sorry-free theorem that reflecting one listed root through another listed
  root stays in `rootList`.

## Job N4: composition-algebra Clifford precursor

Write scope:

- `PhysicsSM/Algebra/Division/CompositionClifford.lean`

Goal:

Build the next small theorem layer above `EuclideanCompAlg`, preparing the real
Hurwitz/Clifford route without claiming the classification theorem.

Target declarations:

- `rePartOf`.
- `imPartOf`.
- `IsPureImaginary`.
- basic lemmas for star-invariance of real/pure-imaginary parts.
- if the existing record has enough axioms, a norm-form identity saying that
  `x * star x` is the scalar multiple of `1` determined by `normSq x`.
- if the existing record is not strong enough, define a stronger
  `NormFormCompAlg` mixin with the missing axiom and prove the first Clifford
  relation inside that mixin.

Proof hints:

- The current `EuclideanCompAlg` record has norm multiplicativity and
  positivity, but it may not be strong enough to derive the norm-form identity
  alone. If not, make the missing hypothesis explicit in a successor mixin.

Minimum useful result:

- A trusted theorem surface that precisely states the extra hypotheses needed
  for the Clifford precursor, without pretending to prove Hurwitz
  classification.

## Job N5: Sphere-Packing bridge cleanup

Write scope:

- `PhysicsSM/Draft/E8SpherePackingBridge.lean`
- optional trusted helper file `PhysicsSM/Coding/E8LocalBridge.lean`.

Goal:

Clean the draft bridge after the integrated basis and half-integer files. The
current draft has documented `sorry`s because Sphere-Packing-Lean is not a local
dependency. The job should remove any avoidable local proof holes and keep only
true SPL-dependency blockers.

Target declarations:

- a local theorem connecting `e8CodeBasisInt` and `gram_matrix_bridge`.
- a local theorem using `E8Basis.lean` to show the scaled explicit basis has
  Gram matrix `e8CodeBasisGram / 2`.
- if feasible, a theorem comparing that local Gram matrix to the local
  `e8GramMatrix` up to permutation or basis change.
- replace the misleading simple-scaling draft theorem with a correct basis-
  change handoff if it cannot be proved.

Proof hints:

- The draft text already notes that simple coordinate scaling is not the right
  half-integer coordinate bridge. The correct bridge goes through basis change
  and Gram matrices.
- Do not import Sphere-Packing-Lean unless the submitted project actually has
  it available.

Minimum useful result:

- The draft file still typechecks, with fewer or better-isolated `sorry`s, and
  no trusted fake claim about SPL.
