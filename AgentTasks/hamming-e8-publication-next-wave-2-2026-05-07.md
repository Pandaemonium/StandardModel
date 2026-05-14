# Hamming E8 publication next wave 2 - 2026-05-07

Status: submitted 2026-05-07.

Purpose: queue the next Aristotle jobs after Claude integrated the property
package, root bridge, SPL-shape theorem file, Weyl closure API, and Hamming
uniqueness helpers. This wave targets the remaining manuscript-level endpoints
that would make the paper feel complete rather than merely well-supported.

Submission project:

```text
AgentTasks/aristotle-submit/hamming-e8-publication-next2-20260507-project
```

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| S1: final manuscript theorem index | `AgentTasks/aristotle-output/hamming-e8-final-index` | `44b8b7ee-f84d-43e4-9d5c-59dd08bfbf8c` | queued |
| S2: finish Hamming [8,4,4] uniqueness | `AgentTasks/aristotle-output/hamming-844-uniqueness-final` | `362304b5-a444-4521-879c-23234e8bd749` | queued |
| S3: Weyl simple-reflection orbit convergence | `AgentTasks/aristotle-output/hamming-e8-weyl-orbit-convergence` | `73c308f5-3ed7-4af4-8de2-034197c93928` | queued |
| S4: Weyl simple-reflection permutation package | `AgentTasks/aristotle-output/hamming-e8-weyl-permutation-package` | `42e75d6b-c39c-4305-b843-b4fd60578b4d` | queued |
| S5: root-bridge inner-product/isometry theorem | `AgentTasks/aristotle-output/hamming-e8-root-bridge-isometry` | `040d689f-3d7c-4eca-b85f-362d5d24dfca` | queued |
| S6: first theta-shell counts | `AgentTasks/aristotle-output/hamming-e8-theta-shells` | `f8c78023-eefe-49a7-9ab4-cdf09816f56e` | queued |

Submission note:

- The first S1 upload attempt failed with a transient SSL `bad record mac`
  during project upload. It was retried successfully as
  `44b8b7ee-f84d-43e4-9d5c-59dd08bfbf8c`.
- The slim source project was built from the current repo at the path above and
  kept source-only before submission.

Exact resubmission note:

- `44b8b7ee-f84d-43e4-9d5c-59dd08bfbf8c` later failed at 100%. It was
  resubmitted with the same prompt and same project as
  `2d2e0ede-0721-4654-b445-544808f21984`.
- `42e75d6b-c39c-4305-b843-b4fd60578b4d` later failed at 100%. It was
  resubmitted with the same prompt and same project as
  `0d754a3d-1131-4d87-aa26-14bfacca2679`.

## General constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Do not introduce axioms, `opaque`, `unsafe`, `admit`, or trusted `sorry`.
- Trusted modules must be sorry-free.
- Draft modules may contain documented `sorry` only for genuine external
  dependency blockers.
- Use `native_decide` for finite enumerations only with a docstring trust note.
- Run `lake env lean <file>` for every touched Lean file before returning.

## S1: final manuscript theorem index

Write scope:

- `PhysicsSM/Coding/HammingConstructionAE8Final.lean`
- optional root import update in `PhysicsSM.lean`.

Goal:

Create a final citation-friendly theorem index that imports all completed
Hamming-to-E8 bridge files without creating import cycles.

Target declarations:

- aliases for the Type II theorem;
- full-rank/even/unimodular property package;
- scaled minimum norm;
- 240 short vectors;
- short-vector/root-list permutation theorem;
- Cartan/Gram bridge from `E8SpherePackingShape.lean`;
- simple-reflection root preservation and closure-step facts.

Minimum useful result:

- A trusted, sorry-free file that compiles and can be cited as the manuscript's
  formal theorem table.

## S2: finish Hamming [8,4,4] uniqueness

Write scope:

- `PhysicsSM/Draft/Hamming844Uniqueness.lean`
- optional trusted helper file `PhysicsSM/Coding/Hamming844Classification.lean`.

Goal:

Use `PhysicsSM/Coding/Hamming844UniquenessBasic.lean` to attempt the full
classification theorem: every binary linear `[8,4,4]` code is equivalent to
`extendedHamming8`.

Target declarations:

- replace the remaining `sorry` in
  `extendedHamming8_unique_up_to_equivalence`, if feasible;
- otherwise add the strongest trusted finite-classification theorem that falls
  short, and sharpen the draft handoff note.

Proof hints:

- `extendedHamming8_isLinearCode_4_4` and `CodeEquivalent.isLinearCode` are now
  available.
- A finite `native_decide` classification over all 4-dimensional subspaces of
  `F_2^8`, or over row-reduced generator matrices, is acceptable if documented.

Minimum useful result:

- Either the draft theorem is sorry-free, or there is a new trusted finite
  helper theorem that materially narrows the remaining classification gap.

## S3: Weyl simple-reflection orbit convergence

Write scope:

- `PhysicsSM/Algebra/Octonion/E8WeylOrbitConvergence.lean`

Goal:

Upgrade the closure-step API to a concrete orbit theorem: iterating simple
reflections from a chosen root reaches all 240 roots.

Target declarations:

- `simpleClosureIter`.
- `simpleClosureIter_subset_rootList`.
- `simpleClosureIter_monotone`.
- `simpleClosure_from_firstRoot_eq_rootList`, or a bounded version such as
  `simpleClosureIter 8 [rootList.head]` having the same elements as `rootList`.

Proof hints:

- `simpleClosureStep_subset_rootList` and `simpleClosureStep_monotone` are
  already available.
- A finite `native_decide` theorem is acceptable for the final equality with
  `rootList`.

Minimum useful result:

- A sorry-free theorem that a bounded number of simple-closure iterations from
  one explicit root produces a list permutation/equality with `rootList`.

## S4: Weyl simple-reflection permutation package

Write scope:

- `PhysicsSM/Algebra/Octonion/E8WeylPermutations.lean`

Goal:

Package each simple reflection as a permutation of the 240-element root list,
then prove basic Coxeter-style relations where feasible.

Target declarations:

- `simpleReflectPerm`.
- `simpleReflectPerm_apply`.
- `simpleReflectPerm_involutive`.
- if feasible, `simpleReflectPerm_cartan_relation` or explicit braid
  relations for adjacent/non-adjacent simple roots.
- stretch goal: set up, but do not necessarily prove, the Weyl group order
  theorem.

Proof hints:

- `simpleReflectD_mem_rootList` gives preservation.
- `reflectD_involutive_on_rootList` gives inverses.
- Use finite subtype permutations over `{r // r in rootList}` if that is easier
  than list indices.

Minimum useful result:

- A trusted permutation-level action of the eight simple reflections on
  `rootList`, with involutivity.

## S5: root-bridge inner-product/isometry theorem

Write scope:

- `PhysicsSM/Coding/E8RootBridgeIsometry.lean`

Goal:

Strengthen the list permutation theorem in `E8RootBridge.lean` to an
inner-product bridge between the Construction A short-vector model and the
octonionic doubled-coordinate root model.

Target declarations:

- `hadamard8_dot`.
- `shortVectorToDoubledRoot_dotD`.
- `shortVectorToDoubledRoot_normSqD`.
- theorem stating that octonionic actual inner product `dotD / 4` equals the
  scaled Construction A inner product `intDot / 2` on short vectors.

Proof hints:

- `hadamard8_sqNorm` is already proved; a bilinear dot-product analogue is
  likely a finite matrix calculation.
- If proving the bilinear identity abstractly is hard, prove the finite theorem
  over all pairs in `shortHammingE8VectorList` with `native_decide`.

Minimum useful result:

- A sorry-free theorem showing the bridge map preserves pairwise inner products
  under the documented normalization.

## S6: first theta-shell counts

Write scope:

- `PhysicsSM/Coding/E8ThetaShells.lean`

Goal:

Add the first nontrivial theta-series shell counts for the Hamming Construction
A lattice. This starts the path toward `Theta_E8 = E4` without requiring
modular-form infrastructure.

Target declarations:

- `e8ShellListSqNorm0`.
- `e8ShellListSqNorm4`.
- `e8ShellListSqNorm8`.
- count the shells as `1`, `240`, and `2160` in the unscaled integer norm
  convention, if feasible.
- theorem explaining that after `1/sqrt 2` scaling these are the first
  coefficients `1`, `240`, `2160` of the E8 theta series.

Proof hints:

- The `sqNorm = 4` shell is already `shortHammingE8VectorList`.
- For `sqNorm = 8`, coordinates are bounded by `[-2,2]`, so a finite
  enumeration over `Fin 5 ^ 8` is feasible.
- Record the `native_decide` trust boundary.

Minimum useful result:

- A trusted finite enumeration proving the first three shell counts
  `1, 240, 2160`.
