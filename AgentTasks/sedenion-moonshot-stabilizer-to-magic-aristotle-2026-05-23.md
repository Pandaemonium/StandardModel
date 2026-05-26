# Aristotle M1: stabilizer-to-magic moonshot

Create or modify the draft Lean module:

```text
PhysicsSM/Draft/Sedenions/StabilizerMagicMoonshot.lean
```

## Big Goal

Turn the slogan

```text
sedenion zero-product plaquettes are signed affine stabilizer plaquettes,
while the order-three sedenion psi action may move them toward magic.
```

into precise finite Lean statements.

This is a moonshot.  Try to reach the strongest theorem you can, even if the
final output is a counterexample to the optimistic version.

## Existing Context

Use:

```text
PhysicsSM.Draft.Sedenions.StabilizerPlaquettes
PhysicsSM.Draft.Sedenions.CocycleQuadraticPhase
PhysicsSM.Draft.Sedenions.S3PsiAction
PhysicsSM.Draft.Sedenions.S3PsiActionAbstract
```

Known existing representative facts include:

- `StabilizerPlaquettes.signedPlaq`
- `StabilizerPlaquettes.gen₁_stabilizes`
- `StabilizerPlaquettes.gen₂_stabilizes`
- `StabilizerPlaquettes.gen₃_stabilizes`
- `StabilizerPlaquettes.gen₄_stabilizes`
- `StabilizerPlaquettes.generators_pairwise_commute`
- `StabilizerPlaquettes.generators_independent`
- `StabilizerPlaquettes.stabilizer_count_eq_16`
- `S3PsiAction.psiImageSupport`
- `S3PsiAction.psi_never_preserves_low_pair`
- `S3PsiActionAbstract.psiBlock_orderOf_eq_three`

## Desired Theorems

First target: generalize the representative stabilizer theorem.

Suggested shape:

```lean
def IsSignedZeroProductPlaquetteStabilizer (P : ...) : Prop := ...

theorem all_zero_product_plaquettes_are_stabilizer_like :
    ...
```

It is acceptable to encode the finite family as a list or finset if that gives a
cleaner theorem.  The theorem should say that each of the 42 signed zero-product
plaquettes has four independent commuting Pauli stabilizers, or an equivalent
finite stabilizer certificate.

Second target: test the psi/magic hypothesis.

Useful possible outcomes:

- Prove that the naive `psi` image of a sparse plaquette is not itself one of
  the 42 sparse signed zero-product plaquettes.
- Prove that a representative `psi` image has support size larger than 4.
- Prove that the naive `psi` image cannot be certified by the same four-sparse
  stabilizer template.
- If you can define a finite stabilizer-state predicate robustly enough, prove
  either preservation or non-preservation by `psi`.

## Constraints

- Do not claim a physical magic theorem unless the finite predicate is defined
  in the Lean file.
- Do not import analytic quantum mechanics infrastructure.
- Do not add axioms, opaque constants, unsafe code, or admits.
- If a broad stabilizer predicate is too much, return a clean finite certificate
  theorem for all 42 plaquettes and a precise negative theorem about the naive
  psi image.
