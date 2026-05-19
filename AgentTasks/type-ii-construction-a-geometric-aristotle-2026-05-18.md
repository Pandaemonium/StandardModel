# Type II Construction A geometric bridge - 2026-05-18

Status: complete and integrated.

Purpose: finish the broad theorem that a binary Type II code gives an even
self-dual Construction A lattice after the standard `1 / sqrt 2` scaling.

## Target file

```text
PhysicsSM/Draft/ConstructionATypeIIAristotle.lean
```

## Current status

The file already proves the integer-coordinate algebraic core:

```lean
theorem scaledConstructionADualInt_eq_constructionA_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    scaledConstructionADualInt C = constructionA C

theorem constructionA_typeII_integer_package {n : Nat}
    (C : BinaryLinearCode n) (hC : IsTypeII C) :
    (forall z : Fin n -> Int, z ∈ constructionA C ->
        exists k : Int, sqNorm z = 4 * k) /\
      scaledConstructionADualInt C = constructionA C
```

These proofs are sorry-free.  They are the intended scaffolding for the real
geometric bridge.

## Primary targets

Please prove both remaining sorries in the same file:

```lean
theorem scaledConstructionAReal_even_of_doublyEven {n : Nat}
    (C : BinaryLinearCode n) (hC : IsDoublyEven C) :
    forall x : Fin n -> Real, x ∈ scaledConstructionAReal C ->
      exists k : Int, realDot x x = (2 * k : Real)
```

```lean
theorem scaledConstructionARealDual_eq_self_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    scaledConstructionARealDual C = (scaledConstructionAReal C : Set (Fin n -> Real))
```

## Proof sketches

For `scaledConstructionAReal_even_of_doublyEven`:

1. Unpack membership in `scaledConstructionAReal C` as the image of
   `constructionA C` under `scaledConstructionARealLinearMap`.
2. Write `x = z / sqrt 2`.
3. Expand `realDot x x`, use `Real.sq_sqrt` for `sqrt 2 ^ 2 = 2`.
4. Use `constructionA_sqNorm_eq_four_mul_of_doublyEven C hC z hz`.
5. Conclude `realDot x x = 2 * k`.

For `scaledConstructionARealDual_eq_self_of_selfDual`:

1. For the easy inclusion, take `y = z / sqrt 2` with `z ∈ constructionA C`.
   For any `x = w / sqrt 2`, use
   `constructionA_le_scaledConstructionADualInt_of_selfDual` to get
   `2 ∣ intDot z w`, then show `realDot y x` is the corresponding integer.
2. For the hard inclusion, suppose `y` pairs integrally with every scaled
   Construction A vector.
3. Test against the scaled images of `twoBasisVec i`.  This gives integers
   `z i` with `Real.sqrt 2 * y i = z i`.
4. Show `y = scaledConstructionARealLinearMap n z`.
5. For every `w ∈ constructionA C`, pairing against `w / sqrt 2` gives
   `2 ∣ intDot z w`; hence `z ∈ scaledConstructionADualInt C`.
6. Apply `scaledConstructionADualInt_eq_constructionA_of_selfDual C hC`.
7. Conclude `y ∈ scaledConstructionAReal C`.

## Constraints

- Do not change theorem statements unless the current statement is genuinely
  malformed.
- No new axioms, no `unsafe`, no `admit`.
- Final target file should have no executable `sorry`.
- Keep the proof Mathlib/project-local only; this job intentionally avoids SPL.
- It is fine to add small helper lemmas in the same file.

## Verification

Expected targeted check:

```text
lake build PhysicsSM.Draft.ConstructionATypeIIAristotle
```

## Submission package

Planned package:

```text
AgentTasks/aristotle-submit/type-ii-construction-a-geometric-20260518-project
```

Planned command:

```text
powershell -ExecutionPolicy Bypass -File Scripts/prepare_aristotle_submission.ps1 -JobName type-ii-construction-a-geometric-20260518 -TaskNote AgentTasks/type-ii-construction-a-geometric-aristotle-2026-05-18.md -CheckPath PhysicsSM/Draft/ConstructionATypeIIAristotle.lean
```

## Submitted job

| Job | Aristotle ID | Status at submission check |
|-----|--------------|----------------------------|
| Type II Construction A real geometric bridge | `0b21f2ce-dbc5-4c71-82a7-e10caf4938e0` | queued |

Submission confirmed with:

```text
aristotle list
```

## Local verification before submission

```text
lake build PhysicsSM.Draft.ConstructionATypeIIAristotle
lake env lean PhysicsSMDraft.lean
powershell -ExecutionPolicy Bypass -File Scripts/prepare_aristotle_submission.ps1 -JobName type-ii-construction-a-geometric-20260518 -TaskNote AgentTasks/type-ii-construction-a-geometric-aristotle-2026-05-18.md -CheckPath PhysicsSM/Draft/ConstructionATypeIIAristotle.lean
```

The target module builds with exactly the two intended `sorry` handoff markers.

## Integration result

Status: integrated on 2026-05-18.

Result fetched with:

```text
aristotle result 0b21f2ce-dbc5-4c71-82a7-e10caf4938e0 --destination AgentTasks\aristotle-output\type-ii-construction-a-geometric-20260518
```

The Aristotle result archive was extracted to:

```text
AgentTasks\aristotle-output\type-ii-construction-a-geometric-20260518-extracted
```

Integrated file:

```text
PhysicsSM/Draft/ConstructionATypeIIAristotle.lean
```

The two remaining theorems are now proved:

```lean
scaledConstructionAReal_even_of_doublyEven
scaledConstructionARealDual_eq_self_of_selfDual
```

The integrated proof was lightly cleaned after import: obsolete handoff
comments were replaced by theorem docstrings, one brittle local arithmetic step
was made explicit, and flexible `simp at *` noise was removed from the final
inclusion proof.

Verification after integration:

```text
lake build PhysicsSM.Draft.ConstructionATypeIIAristotle
lake env lean PhysicsSMDraft.lean
rg -n "\bsorry\b|\badmit\b|\baxiom\b|\bunsafe\b" PhysicsSM\Draft\ConstructionATypeIIAristotle.lean
```

The grep command produced no hits.  Axiom checks for
`scaledConstructionAReal_even_of_doublyEven`,
`scaledConstructionARealDual_eq_self_of_selfDual`, and
`constructionA_typeII_integer_package` report only the standard Lean
foundations `propext`, `Classical.choice`, and `Quot.sound`.
