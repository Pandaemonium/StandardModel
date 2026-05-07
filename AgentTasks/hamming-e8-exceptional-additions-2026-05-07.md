# Hamming E8 exceptional additions Aristotle jobs - 2026-05-07

Status: submitted 2026-05-07.

Purpose: add high-value, non-duplicative targets from the expanded peer-review
notes. The first Hamming/E8 Aristotle wave already covers self-duality, scaled
minimum norm, Gram matrices, 240 shortest vectors, root-list comparison, and
Sphere-Packing-Lean scaffolding. This batch targets adjacent results that could
make the publication exceptional without blocking the main bridge.

Planning source:

- `Sources/Hamming_ConstructionA_E8_Publication_Outline.md`

Submission project:

```text
AgentTasks/aristotle-submit/hamming-e8-exceptional-20260507-project
```

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| X1: Hamming weight enumerator and MacWilliams check | `AgentTasks/aristotle-output/hamming-e8-weight-enumerator-macwilliams` | `5cd16d9e-4433-4a7e-85bd-6d87a48bf91b` | queued |
| X2: code equivalence and Hamming uniqueness scaffold | `AgentTasks/aristotle-output/hamming-e8-code-equivalence-uniqueness` | `74567637-7a07-4637-9060-5a1a90e1ce98` | queued |
| X3: E8 Weyl reflections over the 240-root list | `AgentTasks/aristotle-output/hamming-e8-weyl-reflections` | `953b8c64-b1a1-411a-80c8-f0ad69d387bf` | queued |

Submission check:

- `lake env lean PhysicsSM/Coding/HammingE8.lean` passed in the live repo.
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
- Do not claim E8 identification unless a bridge theorem is actually proved.
- Prefer the neutral Construction A name `hammingConstructionALattice`.
- Keep `native_decide` use explicit in module docstrings if finite searches use
  it.
- Run `lake env lean <file>` for every touched Lean file before returning.

## Job X1: Hamming weight enumerator and MacWilliams check

Write scope:

- `PhysicsSM/Coding/HammingWeightEnumerator.lean`

Goal:

Define a lightweight weight-enumerator API for binary codes and prove the
extended Hamming `[8,4,4]` code has weight distribution `1, 14, 1`.
Then prove the concrete MacWilliams-style self-dual weight-enumerator check for
this code. The fully general MacWilliams theorem is a stretch, not required.

Target declarations:

- `weightDistribution` or a similarly named finite count by Hamming weight.
- `extendedHamming8_weight_zero_count`.
- `extendedHamming8_weight_four_count`.
- `extendedHamming8_weight_eight_count`.
- `extendedHamming8_weight_other_count`.
- a polynomial or coefficient-level statement corresponding to
  `W(x,y) = x^8 + 14*x^4*y^4 + y^8`.
- stretch: a concrete MacWilliams transform theorem for this enumerator.

Proof hints:

- Use `extendedHamming8_mem_iff_mulVec`, `hammingWeight`, and finite
  enumeration of `BinaryVector 8`.
- A coefficient-level theorem over `Nat` or `Int` is preferable to a brittle
  multivariate polynomial formalization if the polynomial API is heavy.
- If `native_decide` is used, document the `trustCompiler` boundary.

Minimum useful result:

- A sorry-free theorem giving the exact count of codewords at weights 0, 4, and
  8, with all other weights zero.

## Job X2: code equivalence and Hamming uniqueness scaffold

Write scope:

- `PhysicsSM/Coding/CodeEquivalence.lean`
- optional draft file `PhysicsSM/Draft/Hamming844Uniqueness.lean` for
  statements that are too large to finish.

Goal:

Start the formal code-equivalence layer needed for uniqueness-up-to-column
permutation statements. Prove basic API facts and, if feasible, a finite
uniqueness theorem for the extended `[8,4,4]` Hamming code.

Target declarations:

- `permuteBinaryVector`.
- `permuteCode`.
- `CodeEquivalent`.
- reflexivity, symmetry, and transitivity of code equivalence.
- invariance of `hammingWeight` under coordinate permutation.
- invariance of minimum-weight and doubly-even predicates under equivalence.
- stretch: a draft or trusted finite statement that every binary `[8,4,4]`
  code is equivalent to `extendedHamming8`.

Proof hints:

- Keep the uniqueness theorem in draft if the classification search becomes too
  large.
- The equivalence API itself is valuable and should be trusted/sorry-free.

Minimum useful result:

- A sorry-free equivalence API with weight preservation under coordinate
  permutations.

## Job X3: E8 Weyl reflections over the 240-root list

Write scope:

- `PhysicsSM/Algebra/Octonion/E8Weyl.lean`

Goal:

Define Weyl reflections using the doubled-coordinate `E8Root.rootList` and
prove the first finite root-system action facts. Computing the full Weyl group
order `696729600` is an ambitious stretch, not the minimum target.

Existing context:

- `PhysicsSM.Algebra.Octonion.IntegralOctonion`
- `E8Root.rootList`
- `E8Root.dotD`
- `E8Root.normSqD`
- `E8Root.rootList_length`
- `E8Root.rootList_nodup`
- `E8Root.rootList_all_isE8RootD`
- `E8Root.dotD_values_distinct`

Target declarations:

- `reflectD (r v : Fin 8 -> Int) : Fin 8 -> Int`, the doubled-coordinate
  reflection formula for a root `r`.
- `reflectD_root_mem_rootList`: if `r` and `v` are in `rootList`, then
  `reflectD r v` is in `rootList`.
- `reflectD_involutive` for root reflections, if feasible.
- a small finite list of simple roots drawn from `rootList`.
- stretch: prove the generated action is transitive on `rootList`.
- stretch: compute or state a draft theorem for Weyl group order `696729600`.

Proof hints:

- In doubled coordinates, actual inner product is `dotD / 4`, and roots have
  actual norm squared 2. Therefore the reflection can be written integrally as
  `v - (dotD v r / 4) * r`; use the existing divisibility theorem.
- If integer division is awkward, define the coefficient using a proof that
  `4` divides `dotD v r`.
- Finite root preservation can be discharged by `native_decide` if necessary,
  with a trust note.

Minimum useful result:

- A sorry-free root-preservation theorem for reflections through roots in
  `rootList`.
