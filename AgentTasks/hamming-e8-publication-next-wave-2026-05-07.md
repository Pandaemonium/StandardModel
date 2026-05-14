# Hamming E8 publication next wave - 2026-05-07

Status: submitted 2026-05-07.

Purpose: queue the next proof-specialist jobs after the Construction A E8
integration produced Type II code data, a spanning basis, determinant one after
scaling, 240 short vectors, the half-integer bridge, and Weyl-root closure.

Current local packaging file:

- `PhysicsSM/Coding/HammingConstructionAE8.lean`

Submission project:

```text
AgentTasks/aristotle-submit/hamming-e8-publication-next-20260507-project
```

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| P1: Construction A short vectors to octonion roots | `AgentTasks/aristotle-output/hamming-e8-root-bridge` | `f676748d-b97a-43f5-9ec4-bfdfe9aa1338` | queued |
| P2: explicit even/unimodular/rank property package | `AgentTasks/aristotle-output/hamming-e8-property-package` | `c592484c-ecd4-4dbc-b286-4611aa998d73` | queued |
| P3: simple-reflection Weyl orbit closure | `AgentTasks/aristotle-output/hamming-e8-weyl-orbit` | `91f270b0-57f6-4422-9e3e-1cb44085aa7a` | queued |
| P4: finish extended Hamming uniqueness stub | `AgentTasks/aristotle-output/hamming-844-uniqueness-finish` | `4051447e-b1f0-4bcc-89bc-8a125888f76b` | queued |
| P5: Sphere-Packing bridge theorem-shape hardening | `AgentTasks/aristotle-output/hamming-e8-spl-shape-hardening` | `52a7991c-87ad-4cad-844e-c35d7ba328bc` | queued |

Submission check:

- Live repo checks passed for `PhysicsSM/Coding/HammingConstructionAE8.lean`
  and `PhysicsSM.lean`.
- `lake build PhysicsSM.Coding.HammingConstructionAE8` passed in the live repo.
- The slim submission project was assembled at the path above and `.lake` was
  removed before upload.
- A targeted build inside the slim copy timed out during setup, so the upload
  relies on the live-repo checks rather than a second build inside the copied
  project.

## General constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce axioms, `opaque`, `unsafe`, `admit`, or trusted `sorry`.
- Trusted modules must be sorry-free.
- Draft modules may contain documented `sorry` only for genuine external
  dependency blockers.
- Use `native_decide` for finite enumerations only when the module docstring
  records the `trustCompiler` boundary.
- Run `lake env lean <file>` for every touched Lean file before returning.

## Job P1: Construction A short vectors to octonion roots

Write scope:

- `PhysicsSM/Coding/E8RootBridge.lean`
- optional tiny imports from `PhysicsSM/Coding/HammingConstructionAE8.lean`.

Goal:

Prove the missing bridge between the 240 short vectors of the Hamming
Construction A lattice and the 240 octonionic doubled-coordinate roots.

Target declarations:

- `shortVectorToDoubledRoot`.
- divisibility lemma showing `Matrix.mulVec hadamard8 z i` is even for every
  short Construction A vector `z`.
- `shortVectorToDoubledRoot_mem_rootList`.
- `shortVectorToDoubledRoot_map_nodup`.
- `shortVectorToDoubledRoot_surjective_rootList`.
- if feasible, a list permutation theorem between
  `shortHammingE8VectorList.map shortVectorToDoubledRoot` and
  `PhysicsSM.Algebra.Octonion.E8Root.rootList`.

Proof hints:

- The expected map is `z |-> (hadamard8.mulVec z) / 2`, coordinatewise.
- `hadamard8_sqNorm` gives norm scaling by 8, so short vectors with
  `sqNorm = 4` map to doubled vectors with norm squared 8 after division by 2.
- `rootList_complete_arbitrary` and `mem_rootList_iff_isE8RootD` can turn
  predicate proofs into list membership.
- A finite `native_decide` proof over the 240-element list is acceptable if
  documented.

Minimum useful result:

- A sorry-free theorem that every mapped Construction A short vector belongs to
  the octonionic root list, and every octonionic root appears as such an image.

## Job P2: explicit even/unimodular/rank property package

Write scope:

- `PhysicsSM/Coding/HammingConstructionAE8Properties.lean`
- optional tiny additions to `PhysicsSM/Coding/HammingConstructionAE8.lean`.

Goal:

Add precise theorem statements for the lattice properties reviewers expect:
rank 8/full rank, evenness after scaling, and unimodularity after scaling. Use
the existing concrete basis and Gram determinant rather than importing abstract
lattice classification machinery.

Target declarations:

- `ConcreteFullRankByBasis` or an equivalent local predicate.
- `hammingConstructionA_fullRank_by_e8CodeBasisInt`.
- `hammingConstructionA_scaled_even`.
- `hammingConstructionA_scaled_unimodular`.
- `hammingConstructionA_publication_property_package`.

Proof hints:

- Full rank should use `e8CodeBasisInt_spans_hammingConstructionALattice` and
  `e8CodeBasisGram_det_pos`.
- Evenness should use `hammingConstructionALattice_sqNorm_dvd_four`; after
  dividing unscaled `sqNorm` by 2, norms are even integers.
- Unimodularity should use `e8CodeBasis_scaled_gram_det`.

Minimum useful result:

- Citation-friendly sorry-free theorems with mathematically honest concrete
  definitions of full rank, evenness, and unimodularity.

## Job P3: simple-reflection Weyl orbit closure

Write scope:

- `PhysicsSM/Algebra/Octonion/E8WeylOrbit.lean`

Goal:

Strengthen `E8WeylBasic.lean` from closure under arbitrary root reflections to
a finite simple-reflection orbit statement. This is a step toward Weyl group
generation without attempting the full group-order computation.

Target declarations:

- `simpleReflectD`.
- a bounded closure operation from `simpleRootListD`.
- `simple_reflection_orbit_contains_rootList`.
- `simple_reflection_orbit_eq_rootList`, if feasible.

Proof hints:

- Use the eight roots in `simpleRootListD`.
- Finite closure over the 240-element root list is acceptable with
  `native_decide`.
- Do not attempt `|W(E8)| = 696729600` in this job unless the orbit proof is
  already complete and cheap.

Minimum useful result:

- A sorry-free theorem that the simple reflections reach all 240 roots from at
  least one simple root.

## Job P4: finish extended Hamming uniqueness stub

Write scope:

- `PhysicsSM/Draft/Hamming844Uniqueness.lean`
- optional trusted helper file `PhysicsSM/Coding/Hamming844UniquenessBasic.lean`.

Goal:

Try to remove the documented `sorry` in the uniqueness stub, or split out the
largest sorry-free theorem that the current `CodeEquivalence.lean` machinery
supports.

Target declarations:

- keep the existing theorem statement if it is semantically correct;
- otherwise add a precise weaker theorem and document why the original statement
  needs more infrastructure.

Proof hints:

- Aristotle job `74567637-7a07-4637-9060-5a1a90e1ce98` completed and produced
  `PhysicsSM/Coding/CodeEquivalence.lean`; use that API first.

Minimum useful result:

- Either a sorry-free uniqueness theorem, or a smaller trusted theorem plus a
  sharper handoff note in the draft file.

## Job P5: Sphere-Packing bridge theorem-shape hardening

Write scope:

- `PhysicsSM/Draft/E8SpherePackingBridge.lean`
- optional trusted helper file `PhysicsSM/Coding/E8SpherePackingShape.lean`.

Goal:

Make the bridge to Sphere-Packing-Lean more precise without importing SPL.
Remove any misleading theorem shape and add dependency-free theorems that will
be directly reusable once SPL is available.

Target declarations:

- a local submodule-style wrapper for the integer Construction A lattice, if
  feasible;
- a theorem that the scaled `e8CodeBasisInt` Gram matrix is the matrix currently
  used as the local SPL-shaped target;
- a theorem statement documenting the exact basis-change map needed for the SPL
  equivalence, with proof if dependency-free.

Minimum useful result:

- The draft bridge still builds, has no avoidable local holes, and contains a
  theorem shape that can be copied almost directly into an SPL-enabled branch.
