# Aristotle prompt: finite Yukawa mass-operator bridge

Please fill the proof holes in:

```text
NullEdgeYukawaMassOperator/Finite.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeYukawaMassOperator/Finite.lean
```

## Objective

Prove the finite bridge between Higgs/Yukawa chirality-flip legality and the
first-order mass operator used in the null-edge origin-of-mass program.

The intended interpretation is:

- the finite Yukawa table is the Standard-Model permission rule for
  chirality-changing vertices;
- the scalar post-symmetry-breaking mass parameter `m` defines an odd
  left/right flip operator;
- the square of that first-order flip is the scalar mass block `m * m`.

## Targets

Please close:

```text
physicalYukawaFlip_gaugeLegal
candidateGaugeLegal_iff_exists_yukawaFlip
scalarYukawaFlipOperator_anticommutes_chirality
scalarYukawaFlipOperator_sq_eq_massSq
legalCandidate_has_yukawaMassOperator
```

## Constraints

- Do not change the theorem statements unless one is mathematically false.
- Do not add assumptions or fake definitions.
- Do not use escape-hatch declarations.
- Helper lemmas in the same file are welcome.
- Keep the file ASCII-clean.
- The final target should pass the narrow Lean command above without proof holes.

## Proof hints

- The finite Yukawa table has only four `YukawaFlip` constructors and six
  `Multiplet` constructors; case splits plus `norm_num` should close the
  legality classifier.
- For the mass operator square and chirality anticommutation, use `ext` on the
  matrix entries, split the `Sum X X` indices, and simplify with
  `Matrix.mul_apply`, `offDiagonal`, `chiralityMatrix`, `Matrix.one_apply`, and
  `Finset.sum_eq_single` style facts if needed.
- The final existential bridge should combine
  `candidateGaugeLegal_iff_exists_yukawaFlip`,
  `scalarYukawaFlipOperator_sq_eq_massSq`, and
  `scalarYukawaFlipOperator_anticommutes_chirality`.
