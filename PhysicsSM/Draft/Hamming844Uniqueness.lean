import Mathlib
import PhysicsSM.Coding.Hamming844Classification

/-!
# Uniqueness of the extended [8,4,4] Hamming code

This file proves that every binary linear `[8,4,4]` code is equivalent to
the extended Hamming code `extendedHamming8` under coordinate permutation.

## Statement

```
theorem extendedHamming8_unique_up_to_equivalence
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8
```

## Proof outline

1. **Information set existence:** Every `[8,4,4]` code has 4 coordinate
   positions where the restriction is injective. (Counting: at most 15
   nonzero codewords block at most 15 of the 70 possible 4-element subsets.)

2. **Systematic form:** After permuting the information set to `{0,1,2,3}`,
   the code equals a systematic submodule `[I₄ | P]` for some `P`.

3. **Finite classification:** Every systematic `[I₄ | P]` code with minimum
   distance `≥ 4` is a coordinate permutation of `extendedHamming8`.
   (Verified by `native_decide` over all `2^16` matrices `P`; only 24 pass
   the minimum-distance filter.)

4. **Transitivity:** Composing the coordinate permutations yields the
   desired equivalence.

## Trust boundary

The finite classification step uses `native_decide`, introducing the
`Lean.trustCompiler` axiom. All structural reasoning is axiom-minimal.

## Source / provenance

- Pless, *Introduction to the Theory of Error-Correcting Codes*, Theorem 5.3.
- MacWilliams & Sloane, *The Theory of Error-Correcting Codes*, Ch. 1–2.
- Aristotle job for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Coding

/-- **Every binary `[8, 4, 4]` code is equivalent to the extended Hamming
code `extendedHamming8`.**

This is the classification theorem: up to coordinate permutation, there is
a unique binary linear code with parameters `[8, 4, 4]`. The proof combines
a structural information-set argument with a finite `native_decide`
verification over all systematic generator matrices. -/
theorem extendedHamming8_unique_up_to_equivalence
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8 :=
  extendedHamming8_unique_up_to_equivalence_proof C hC

end PhysicsSM.Coding
