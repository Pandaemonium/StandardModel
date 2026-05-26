# Aristotle N2: affine symmetry classification moonshot

Create or modify:

```text
PhysicsSM/Draft/Sedenions/AffineSymmetryClassificationMoonshot.lean
```

## Big Goal

Classify the finite affine symmetries of the sedenion zero-product geometry.

The current Lean package proves that `GL(3,2)` acts transitively on the 42
zero-product supports.  This job asks whether that is the full natural affine
symmetry, or only a visible subgroup.

## Existing Context

Use:

```text
PhysicsSM.Draft.Sedenions.ReedMullerCode
PhysicsSM.Draft.Sedenions.GL32Action
PhysicsSM.Draft.Sedenions.PSL27FlavorGeometry
PhysicsSM.Draft.Sedenions.GenerationCancellationGeometry
```

## Desired Theorems

Work with a finite family of affine maps on `F2^4`, represented as:

```text
x |-> A x + b
```

where `A` is an invertible 4 by 4 binary matrix and `b` is a 4-bit translation.
If enumerating all `AGL(4,2)` maps is too heavy, restrict to maps preserving
the forced pair `{0,8}` or the low/high partner relation.

Try to prove or refute:

1. The affine automorphisms preserving the 42 zero-product supports have a
   computable cardinality.
2. The subgroup preserving the partner relation and forced coordinates is the
   expected lifted `GL(3,2)` action.
3. The automorphisms preserving `C_ZD` may be larger than those preserving the
   42 zero-product supports; classify the size gap if present.
4. The sign cocycle is preserved exactly, up to gauge, or not at all under the
   larger affine automorphism group.

Suggested theorem names:

```lean
theorem affine_preservers_zp_supports_card : ...
theorem partner_forced_preservers_eq_gl32_lift : ...
theorem cZD_preserver_card : ...
theorem affine_sign_gauge_obstruction_or_classification : ...
```

## Constraints

- Do not enumerate arbitrary `Fin 16` permutations.  Use affine maps or a
  clearly bounded finite family.
- A classification showing a larger group is especially useful.
- No axioms, opaque constants, unsafe code, or admits.
