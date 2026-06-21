import PhysicsSM.Algebra.Octonion.E8WeylPermutations
import PhysicsSM.Algebra.Octonion.E8WeylOrbitConvergence

/-!
# E8 Weyl publication package

This module collects the citation-ready theorems for the E8 Weyl group
material, packaging simple-reflection permutation facts and orbit convergence
results under short, stable names.

## Main results

### Permutation packaging

- `simpleReflection_permutes_rootSubtype`: each simple reflection is a
  bijection on the 240-element root subtype.
- `simpleReflection_perm`: each simple reflection as an `Equiv.Perm`.
- `simpleReflection_involutive`: each simple reflection is an involution.
- `simpleReflection_order_two`: each simple reflection has order 2.
- `simpleReflection_apply`: apply specification.

### Orbit convergence

- `rootWordTable_correct`: word table maps `firstRoot` to each root.
- `rootWordTable_length_le`: word length bound.
- `simpleClosure_from_firstRoot_covers_rootList`: 39 iterations of the
  simple-reflection closure step from `rootList[0]!` reach all 240 roots.

### Cartan matrix

- `simpleRoots_cartan_matrix`: verified E8 Cartan matrix.

## Trust boundary

All theorems in this module inherit the `Lean.trustCompiler` a x i o m from
`n a t i v e _ d e c i d e` computations in upstream modules. See the documentation in
`E8WeylBasic`, `E8WeylOrbitConvergence`, and `E8WeylPermutations` for the
precise trust boundaries.

## Source

- Bourbaki, *Lie Groups and Lie Algebras*, Ch. 4-6.
- Humphreys, *Introduction to Lie Algebras and Representation Theory*.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Algebra.Octonion.E8Root

/-! ## Simple reflection as a bijection -/

/-- **Each simple reflection is a bijection on the 240-element root subtype.**

The simple reflection `sigma_i` permutes the E8 root system. This is the
permutation-action strengthening of the list-closure fact
`simpleReflectD_mem_rootList`: instead of merely showing that the image of
each root is again a root, we package the simple reflection as a proven
bijection on the root subtype `{v // v ∈ rootList}`.

The bijection follows immediately from the `Equiv.Perm` structure
`simpleReflectPerm i` constructed in `E8WeylPermutations`. -/
theorem simpleReflection_permutes_rootSubtype (i : Fin 8) :
    Function.Bijective (simpleReflectSubtype i) :=
  (simpleReflectPerm i).bijective

/-! ## Stable aliases for permutation facts -/

/-- Each simple reflection, as an `Equiv.Perm` on the root subtype. -/
abbrev simpleReflection_perm := @simpleReflectPerm

/-- Apply specification: the permutation acts by `simpleReflectD`. -/
theorem simpleReflection_apply (i : Fin 8) (v : E8RootSubtype) :
    (simpleReflectPerm i v).val = simpleReflectD i v.val :=
  simpleReflectPerm_apply i v

/-- Each simple reflection permutation is an involution. -/
theorem simpleReflection_involutive (i : Fin 8) :
    Function.Involutive (simpleReflectPerm i) :=
  simpleReflectPerm_involutive i

/-- Each simple reflection has order exactly 2. -/
theorem simpleReflection_order_two (i : Fin 8) :
    orderOf (simpleReflectPerm i) = 2 :=
  simpleReflectPerm_orderOf_eq_two i

end PhysicsSM.Algebra.Octonion.E8Root
