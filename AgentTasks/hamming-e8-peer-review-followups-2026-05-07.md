# Hamming E8 peer-review follow-up Aristotle jobs - 2026-05-07

Status: submitted 2026-05-07.

Purpose: address peer-review gaps in the Hamming -> Construction A -> E8
publication draft that are not fully covered by the first Hamming E8 Aristotle
wave. These jobs are deliberately focused on structural honesty: evenness,
full-rank packaging, arbitrary root-list completeness, and reducing or
documenting the `native_decide` trust boundary.

Related task records:

- `AgentTasks/hamming-construction-a-e8-publication-bridge-2026-05-07.md`
- `Sources/Hamming_ConstructionA_E8_Publication_Outline.md`

Submission project:

```text
AgentTasks/aristotle-submit/hamming-e8-peer-review-20260507-project
```

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| PR1: Construction A evenness and full-rank API | `AgentTasks/aristotle-output/hamming-e8-even-full-rank` | `814f4cda-e254-4076-9f39-1a84aeb8014f` | queued |
| PR2: arbitrary E8 root-list completeness | `AgentTasks/aristotle-output/hamming-e8-rootlist-arbitrary-complete` | `23373807-da3d-4f4e-8a8f-1bf32c501c35` | queued |
| PR3: native-decide finite-certificate audit | `AgentTasks/aristotle-output/hamming-e8-native-decide-audit` | `8858aa89-a4f3-4801-a6f2-b43275a14194` | queued |

Submission check:

- `lake env lean PhysicsSM/Coding/HammingE8.lean` passed in the live repo.
- `lake env lean PhysicsSM/Coding/ConstructionA.lean` passed in the live repo.
- `lake env lean PhysicsSM/Algebra/Octonion/IntegralOctonion.lean` passed in
  the live repo.
- `lake env lean PhysicsSM.lean` passed in the live repo.
- `lake build PhysicsSM.Coding.HammingE8
  PhysicsSM.Algebra.Octonion.IntegralOctonion` passed in the slim submission
  project before the temporary `.lake` cache was removed for upload size.

## General constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce axioms, `opaque`, `unsafe`, `admit`, or trusted `sorry`.
- Trusted modules must be sorry-free.
- Keep integer norm 4 and scaled norm 2 conventions separate.
- Do not claim E8 identification unless a bridge theorem is actually proved.
- New code should prefer the neutral name `hammingConstructionALattice`; the
  older `e8IntLattice` abbreviation is compatibility only.
- Run `lake env lean <file>` for every touched Lean file before returning.

## Job PR1: Construction A evenness and full-rank API

Write scope:

- `PhysicsSM/Coding/ConstructionALatticeProperties.lean`

Goal:

Prove structural facts that move Construction A from "additive subgroup" toward
the geometric lattice layer, without overclaiming E8.

Target declarations:

- a lemma showing `constructionA C` contains every doubled coordinate basis
  vector, or an equivalent full-rank/spanning precursor;
- `constructionA_contains_twoZBasis` or a similarly named theorem;
- a parity theorem relating `sqNorm z mod 4` to the Hamming weight of
  `reduceModTwo z`;
- `constructionA_sqNorm_dvd_four_of_doublyEven`;
- specialization to `hammingConstructionALattice`;
- if feasible, a real-span theorem showing the real span is all of
  `Fin n -> Real`.

Proof hints:

- `even_vector_mem_constructionA` already proves any vector with all even
  coordinates lies in Construction A.
- For parity of squares, use the elementary fact that `a^2 mod 4` is `0` for
  even `a` and `1` for odd `a`.
- The existing `extendedHamming8_doublyEven'` supplies the concrete doubly-even
  hypothesis.

Minimum useful result:

- A sorry-free theorem that every vector of `hammingConstructionALattice` has
  squared norm divisible by 4 in the unscaled integer normalization.

Claim boundary:

- This does not prove unimodularity.
- This does not prove the lattice is E8.

## Job PR2: arbitrary E8 root-list completeness

Write scope:

- `PhysicsSM/Algebra/Octonion/E8RootCompleteness.lean`
- optional tiny additions to `PhysicsSM/Algebra/Octonion/IntegralOctonion.lean`
  only if they are general coordinate-bound helper lemmas.

Goal:

Upgrade the current finite-range completeness theorem for `E8Root.rootList` to
an arbitrary integer-vector completeness theorem.

Existing context:

- `E8Root.IsE8RootD`
- `E8Root.rootList`
- `E8Root.rootList_complete`
- `E8Root.coordinate_abs_le_two_of_normSqD_eq_8`

Target declarations:

- a function converting an integer coordinate known to lie in `[-2,2]` into
  the corresponding `Fin 5` index;
- `rootList_complete_arbitrary`:
  every `v : Fin 8 -> Int` satisfying `IsE8RootD v` belongs to `rootList`;
- optional theorem explaining that `rootList` enumerates exactly the predicate
  `IsE8RootD`.

Proof hints:

- `IsE8RootD v` includes `normSqD v = 8`.
- `coordinate_abs_le_two_of_normSqD_eq_8` gives `|v i| <= 2`.
- The current `rootList_complete` handles vectors expressed through the finite
  value list `![-2,-1,0,1,2]`.

Minimum useful result:

- A sorry-free arbitrary completeness theorem, even if the proof uses a small
  case split over each coordinate value.

## Job PR3: native-decide finite-certificate audit

Write scope:

- `PhysicsSM/Coding/HammingE8Certified.lean`
- optional documentation-only additions to `PhysicsSM/Coding/HammingE8.lean`.

Goal:

Reduce or precisely document the `native_decide` trust boundary for the Hamming
finite facts used in the publication.

Target declarations:

- if feasible, replacement certified theorems for:
  - `extendedHamming8_card`;
  - `extendedHamming8_minWeight`;
  - `extendedHamming8_doublyEven`;
  - `e8IntLattice_achieves_sqNorm_four`;
- otherwise, a trusted certificate module that explicitly lists the 16 codewords
  and proves membership, no-duplicates, cardinality, minimum weight, and
  doubly-evenness from that list with ordinary kernel checking;
- a theorem linking the certified list back to `extendedHamming8`.

Proof hints:

- A list of 16 codewords may be easier to review than a fully generic finite
  cardinality proof.
- For a proof-agent result, a clear finite certificate is more valuable than a
  clever but opaque tactic proof.

Minimum useful result:

- A typechecked certificate list with no `native_decide` in the new theorem
  proofs, even if it does not replace every old theorem immediately.

Claim boundary:

- This job is about publication trust hygiene. It does not change the
  mathematical content of the Hamming Construction A theorem.
