import Mathlib
import PhysicsSM.Algebra.Octonion.E8WeylOrbit

/-!
# E8 Weyl Simple-Reflection Permutation Package

This module packages each of the eight E8 simple reflections as a
permutation of the 240-element root list (as a subtype), then proves
basic properties: the apply specification, involutivity, order, and
(as a stretch goal) the verified E8 Cartan matrix.

## Main declarations

- `E8RootSubtype` — the subtype `{v // v ∈ rootList}`, a 240-element
  type.
- `simpleReflectPerm i` — the `i`-th simple reflection as an
  `Equiv.Perm E8RootSubtype`.
- `simpleReflectPerm_apply` — the permutation acts by `simpleReflectD`.
- `simpleReflectPerm_involutive` — each simple reflection permutation
  is an involution.
- `simpleReflectPerm_sq_eq_one` — equivalent: squaring gives the
  identity.
- `simpleReflectPerm_orderOf_eq_two` — the order of each generator
  is 2.
- `simpleRoots_cartan_matrix` — the verified E8 Cartan matrix.

## Dynkin diagram

The E8 Dynkin diagram in our simple root ordering is:

```
α₁ — α₂ — α₃ — α₄ — α₅ — α₇ — α₈
                       |
                       α₆
```

Branch node is α₅ (index 4), connected to α₄, α₆, and α₇.

## Trust boundary

The construction relies on `reflectD_mem_rootList` and
`reflectD_involutive_on_rootList` from `E8WeylBasic`, which use
`n a t i v e _ d e c i d e`. The `Lean.trustCompiler` a x i o m appears in the
a x i o m set of all theorems in this file.

## Source

- Bourbaki, *Lie Groups and Lie Algebras*, Ch. 4–6.
- Humphreys, *Introduction to Lie Algebras and Representation Theory*.
-/

set_option linter.style.nativeDecide false

namespace PhysicsSM.Algebra.Octonion.E8Root

/-! ## Root subtype -/

/-- The E8 root subtype: vectors in `Fin 8 → ℤ` that belong to
    `rootList`. -/
abbrev E8RootSubtype : Type := { v : Fin 8 → ℤ // v ∈ rootList }

/-! ## Simple reflection as a function on the subtype -/

/-- The `i`-th simple reflection sends roots to roots, as a function
    on the root subtype. -/
def simpleReflectSubtype (i : Fin 8)
    (v : E8RootSubtype) : E8RootSubtype :=
  ⟨simpleReflectD i v.val,
    List.forall_iff_forall_mem.mp
      (simpleReflectD_mem_rootList i) v.val v.property⟩

/-- Applying `simpleReflectSubtype` twice returns the original root.
    This follows from `reflectD_involutive_on_rootList`. -/
theorem simpleReflectSubtype_involutive (i : Fin 8)
    (v : E8RootSubtype) :
    simpleReflectSubtype i (simpleReflectSubtype i v) = v := by
  apply Subtype.ext
  simp only [simpleReflectSubtype, simpleReflectD]
  have hinv := reflectD_involutive_on_rootList
  rw [List.forall_iff_forall_mem] at hinv
  have hsr :
      simpleRootListD[i.val]'(by
        have := simpleRootListD_length; omega) ∈ rootList := by
    fin_cases i <;> native_decide
  exact List.forall_iff_forall_mem.mp
    (hinv _ hsr) v.val v.property

/-! ## Simple reflection as a permutation -/

/-- The `i`-th E8 simple reflection, packaged as a permutation of the
    240-element root subtype.

    Constructed via `Function.Involutive.toPerm`, which uses the
    involutivity proof to build the inverse directly. -/
def simpleReflectPerm (i : Fin 8) : Equiv.Perm E8RootSubtype :=
  Function.Involutive.toPerm
    (simpleReflectSubtype i)
    (simpleReflectSubtype_involutive i)

/-- **Apply theorem**: the permutation `simpleReflectPerm i` acts on
    a root by applying `simpleReflectD i` to its underlying vector. -/
theorem simpleReflectPerm_apply (i : Fin 8)
    (v : E8RootSubtype) :
    (simpleReflectPerm i v).val = simpleReflectD i v.val := by
  simp [simpleReflectPerm, Function.Involutive.toPerm,
    simpleReflectSubtype]

/-- **Involutivity**: each simple reflection permutation is an
    involution. Applying it twice yields the identity. -/
theorem simpleReflectPerm_involutive (i : Fin 8) :
    Function.Involutive (simpleReflectPerm i) := by
  intro v
  apply Subtype.ext
  rw [simpleReflectPerm_apply, simpleReflectPerm_apply]
  exact congrArg Subtype.val
    (simpleReflectSubtype_involutive i v)

/-- **Squaring gives identity**: `(simpleReflectPerm i) ^ 2 = 1`. -/
theorem simpleReflectPerm_sq_eq_one (i : Fin 8) :
    simpleReflectPerm i ^ 2 = 1 := by
  ext v : 1
  change (simpleReflectPerm i) ((simpleReflectPerm i) v) = v
  exact simpleReflectPerm_involutive i v

/-- The order of each simple reflection divides 2. -/
theorem simpleReflectPerm_order_divides_two (i : Fin 8) :
    orderOf (simpleReflectPerm i) ∣ 2 :=
  orderOf_dvd_of_pow_eq_one (simpleReflectPerm_sq_eq_one i)

/-- Each simple reflection moves at least one root:
    `reflectD αᵢ αᵢ = −αᵢ ≠ αᵢ` because reflecting a root through
    itself gives its negation, and no E8 root is the zero vector. -/
theorem simpleReflectPerm_ne_one (i : Fin 8) :
    simpleReflectPerm i ≠ 1 := by
  fin_cases i <;> native_decide

/-- The order of each simple reflection is exactly 2. -/
theorem simpleReflectPerm_orderOf_eq_two (i : Fin 8) :
    orderOf (simpleReflectPerm i) = 2 := by
  have hd := simpleReflectPerm_order_divides_two i
  have hne : orderOf (simpleReflectPerm i) ≠ 1 := by
    intro h
    exact simpleReflectPerm_ne_one i
      (orderOf_eq_one_iff.mp h)
  have := Nat.le_of_dvd (by decide) hd
  interval_cases orderOf (simpleReflectPerm i) <;> trivial

/-! ## Coxeter relations (stretch goal)

The E8 Coxeter matrix has:
- `m(i,j) = 1` for `i = j` (involutivity, already proved).
- `m(i,j) = 2` for non-adjacent simple roots (commutation).
- `m(i,j) = 3` for adjacent simple roots (braid relation).

We verify the Cartan matrix by `n a t i v e _ d e c i d e` and define the Coxeter
matrix for reference.
-/

/-- The E8 Coxeter matrix in our simple root ordering.
    `coxeterMatrix i j` is the order of `sᵢ · sⱼ` in W(E8). -/
def coxeterMatrix : Fin 8 → Fin 8 → ℕ := ![
  ![1, 3, 2, 2, 2, 2, 2, 2],  -- α₁
  ![3, 1, 3, 2, 2, 2, 2, 2],  -- α₂
  ![2, 3, 1, 3, 2, 2, 2, 2],  -- α₃
  ![2, 2, 3, 1, 3, 2, 2, 2],  -- α₄
  ![2, 2, 2, 3, 1, 3, 3, 2],  -- α₅ (branch)
  ![2, 2, 2, 2, 3, 1, 2, 2],  -- α₆
  ![2, 2, 2, 2, 3, 2, 1, 3],  -- α₇
  ![2, 2, 2, 2, 2, 2, 3, 1]   -- α₈
]

/-- **Cartan matrix**: the verified Cartan matrix of E8 in our
    ordering. Entry `a(i,j) = 2⟨αᵢ,αⱼ⟩/⟨αⱼ,αⱼ⟩ = dotD αᵢ αⱼ / 4`.

    This determines the Coxeter matrix: `m(i,j) = 1` if `i=j`,
    `m(i,j) = 2` if `a(i,j) = 0`, `m(i,j) = 3` if `a(i,j) = -1`.
-/
theorem simpleRoots_cartan_matrix :
    ∀ i j : Fin 8,
      dotD
        (simpleRootListD[i.val]'(by
          have := simpleRootListD_length; omega))
        (simpleRootListD[j.val]'(by
          have := simpleRootListD_length; omega)) / 4 =
      (![
        ![ 2, -1,  0,  0,  0,  0,  0,  0],
        ![-1,  2, -1,  0,  0,  0,  0,  0],
        ![ 0, -1,  2, -1,  0,  0,  0,  0],
        ![ 0,  0, -1,  2, -1,  0,  0,  0],
        ![ 0,  0,  0, -1,  2, -1, -1,  0],
        ![ 0,  0,  0,  0, -1,  2,  0,  0],
        ![ 0,  0,  0,  0, -1,  0,  2, -1],
        ![ 0,  0,  0,  0,  0,  0, -1,  2]
      ] : Fin 8 → Fin 8 → ℤ) i j := by
  native_decide

end PhysicsSM.Algebra.Octonion.E8Root
