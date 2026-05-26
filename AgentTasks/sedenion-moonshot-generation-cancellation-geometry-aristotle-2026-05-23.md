# Aristotle M2: generation cancellation geometry moonshot

Create or modify the draft Lean module:

```text
PhysicsSM/Draft/Sedenions/GenerationCancellationGeometry.lean
```

## Big Goal

Test whether the sedenion order-three generation action preserves, spreads, or
breaks the zero-divisor cancellation geometry.

The optimistic physics-facing slogan is:

```text
the sedenion S3 generation symmetry acts naturally on zero-divisor cancellation
channels.
```

The likely finite theorem may be more nuanced:

```text
the sparse assessor geometry is not invariant under the naive psi action, but
psi spreads each sparse channel into a structured support controlled by vertical
low/high pairs.
```

Either outcome is useful.

## Existing Context

Use:

```text
PhysicsSM.Draft.Sedenions.S3PsiAction
PhysicsSM.Draft.Sedenions.S3PsiActionAbstract
PhysicsSM.Draft.Sedenions.CocycleQuadraticPhase
PhysicsSM.Draft.Sedenions.ReedMullerCode
```

Known existing facts include:

- `S3PsiAction.psiBaseSupport`
- `S3PsiAction.psiImageSupport`
- `S3PsiAction.psi_never_preserves_low_pair`
- `S3PsiActionAbstract.psiBlock_cube_eq_one`
- `S3PsiActionAbstract.psiBlock_orderOf_eq_three`

## Desired Theorems

Try for a theorem package with these layers:

1. A clean finite model of the naive `psi` action on support sets.
2. A classification of the support size of the image of a zero-product support
   under `psi`.
3. A proof that this image is not generally one of the original 42 sparse
   zero-product supports.
4. A positive structure theorem saying the image is contained in, or equal to,
   a union of vertical partner pairs.
5. Optional: an abstract interface for a future `Cl(8)` or `Cl(10)` embedded
   generation action, with the finite theorem stated as assumptions in a draft
   namespace only if needed.

Suggested public theorem names:

```lean
theorem psi_spreads_zero_product_supports : ...
theorem psi_not_sparse_cancellation_symmetry : ...
theorem psi_image_controlled_by_vertical_pairs : ...
```

## Constraints

- Do not assert that the full Gresnigt-Gourlay-Varma `Cl(8)` generation action
  has been formalized unless it actually has.
- The finite negative theorem is just as valuable as the positive theorem.
- No axioms, opaque constants, unsafe code, or admits.
