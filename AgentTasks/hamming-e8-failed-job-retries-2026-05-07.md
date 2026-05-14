# Hamming E8 failed-job retries - 2026-05-07

Status: retry jobs submitted 2026-05-07.

The following Aristotle jobs failed with Harmonic internal errors. No Lean
counterexample, proof log, or partial patch was returned.

| Original job | Original target | Failure reason |
|--------------|-----------------|----------------|
| `4051447e-b1f0-4bcc-89bc-8a125888f76b` | finish extended Hamming `[8,4,4]` uniqueness stub | Harmonic internal error |
| `91f270b0-57f6-4422-9e3e-1cb44085aa7a` | simple-reflection Weyl orbit closure | Harmonic internal error |

Submission project:

```text
AgentTasks/aristotle-submit/hamming-e8-publication-next-20260507-project
```

## Retry jobs

| Retry | Output directory | Aristotle ID | Status |
|-------|------------------|--------------|--------|
| R1: Hamming uniqueness helper package | `AgentTasks/aristotle-output/hamming-844-uniqueness-helper-retry` | `d647d290-ecf4-47e8-b3ee-f6b7caa077b1` | queued |
| R2: finite simple-reflection closure steps | `AgentTasks/aristotle-output/hamming-e8-weyl-simple-closure-retry` | `470bb46f-eed8-4ffb-89a6-431a73d0779d` | queued |

Submission note:

- Both original jobs failed with the Aristotle result message: "Project failed
  due to an internal error. The team at Harmonic has been notified; please try
  again."
- The retries are intentionally narrower than the original jobs to reduce the
  search surface and avoid another internal failure.

## R1: Hamming uniqueness helper package

Write scope:

- `PhysicsSM/Coding/Hamming844UniquenessBasic.lean`
- optional tiny edits to `PhysicsSM/Draft/Hamming844Uniqueness.lean` only to
  import the helper and sharpen the handoff note.

Narrowed goal:

Do not try to prove the full uniqueness theorem in one shot. Instead, prove a
sorry-free helper package that makes the draft uniqueness theorem easier and
more semantically precise.

Target declarations:

- `extendedHamming8_isLinearCode_4_4`, proving that `extendedHamming8` itself
  satisfies the local `IsLinearCode extendedHamming8 4 4` predicate, or an
  equivalent trusted predicate if importing the draft structure is undesirable.
- `CodeEquivalent.isLinearCode`, showing code equivalence preserves the
  `[8,4,4]` predicate, if feasible.
- a finite predicate over candidate `4`-dimensional subspaces only if the above
  helper layer is complete.

Minimum useful result:

- A trusted file with no `sorry` that proves the extended Hamming code has the
  exact local `[8,4,4]` predicate and that equivalence preserves the predicate.

## R2: finite simple-reflection closure steps

Write scope:

- `PhysicsSM/Algebra/Octonion/E8WeylOrbit.lean`

Narrowed goal:

Avoid an abstract orbit theorem. Build a finite closure API for the eight
simple reflections and prove one or two concrete closure invariants.

Target declarations:

- `simpleReflectD (i : Fin 8) (v : Fin 8 -> Int) : Fin 8 -> Int`.
- `simpleReflectD_mem_rootList`.
- `simpleClosureStep`.
- `simpleClosureStep_subset_rootList`.
- `simpleClosureStep_monotone`.
- if feasible, `simpleClosureSeven_eq_rootList` or a similar bounded closure
  theorem verified by `native_decide`.

Proof hints:

- `simpleRootListD_subset_rootList` and `reflectD_mem_rootList` already prove
  the hard root-preservation fact.
- A finite `native_decide` proof over the 240-root list is acceptable if the
  module docstring records the `trustCompiler` boundary.

Minimum useful result:

- A trusted file with no `sorry` proving that each simple reflection sends
  `rootList` to itself, plus a closure-step API for future orbit generation.
