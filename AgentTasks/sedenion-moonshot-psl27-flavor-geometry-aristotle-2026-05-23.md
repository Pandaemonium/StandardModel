# Aristotle M3: PSL(2,7) / GL(3,2) flavor geometry moonshot

Create or modify the draft Lean module:

```text
PhysicsSM/Draft/Sedenions/PSL27FlavorGeometry.lean
```

## Big Goal

Promote the finite `GL(3,2)` action results into a clean flavor-geometry
package around the 42 assessors, the 42 zero-product supports, and the signed
Cayley-Dickson cocycle.

The mathematical slogan is:

```text
sedenion zero-divisor geometry carries a PSL(2,7)-like affine-plane symmetry,
and the signs are preserved at least up to gauge.
```

Here `PSL(2,7)` should be treated as the classical group isomorphic to
`GL(3,2)` on the seven nonzero points of `F2^3`.  If a literal PSL(2,7) group
model is too expensive, prove the theorem for the existing `GL32Action` model.

## Existing Context

Use:

```text
PhysicsSM.Draft.Sedenions.GL32Action
PhysicsSM.Draft.Sedenions.CocycleQuadraticPhase
PhysicsSM.Draft.Sedenions.ReedMullerCode
```

Known existing facts include:

- `GL32Action.gl32Triples`
- `GL32Action.gl32_card`
- `GL32Action.gl32_preserves_sameStrutSupports`
- `GL32Action.gl32_preserves_zpSupports`
- `GL32Action.sign_not_globally_preserved`
- `GL32Action.octonion_gauge_all_gl32`

## Desired Theorems

Try for the strongest orbit/classification theorem you can prove:

- `GL(3,2)` acts on the 42 zero-product supports.
- The action is transitive, or classify its orbits if not.
- The action on same-strut supports has orbit sizes explaining the
  `42 + 21` split.
- The signed cocycle is preserved exactly, or preserved up to an explicitly
  defined gauge, or prove a precise obstruction.
- Optional: prove the action cardinality `168` and identify it as the expected
  PSL(2,7)-size symmetry in comments/docstrings, without needing a separate
  abstract PSL construction.

Suggested public theorem names:

```lean
theorem gl32_zero_product_supports_transitive : ...
theorem same_strut_orbit_split_42_21 : ...
theorem cayley_dickson_sign_preserved_up_to_gauge : ...
```

## Constraints

- Do not copy external group-theory code.
- Do not overclaim a literal PSL(2,7) formalization if the file only uses
  `GL(3,2)`.
- No axioms, opaque constants, unsafe code, or admits.
