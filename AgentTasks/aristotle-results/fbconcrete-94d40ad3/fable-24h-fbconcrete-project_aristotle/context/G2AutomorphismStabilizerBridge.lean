import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111GroupEquiv

/-!
# Algebra.Octonion.G2AutomorphismStabilizerBridge

Bridges the `FixingE111MulLinear` scaffold to a proper automorphism
stabilizer structure for octonion multiplicative linear automorphisms
fixing `e111`.

## Mathematical context

`FixingE111MulLinear` is a record of a function with algebraic properties
(additive, R-linear, multiplicative, unit-preserving, conjugation-preserving,
fixes `e111`). It was shown to be a group isomorphic to SU(3) in
`G2FixingE111GroupEquiv`.

This file defines `OctonionMulAutFixingE111`, which upgrades the bare
function to a proper *automorphism* (bijective by construction) fixing
`e111`, and proves an equivalence with `FixingE111MulLinear`.

## Claim boundary

This file does **not** claim that these automorphisms are exactly `G₂`, only
that automorphisms fixing `e111` correspond to `FixingE111MulLinear` elements.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## The automorphism structure -/

/-- An octonion multiplicative linear automorphism fixing `e111`.

    This bundles a bijection (via `Equiv`) with all the algebraic properties:
    additivity, real-scalar compatibility, multiplicativity, unit preservation,
    conjugation preservation, and the fixing condition on `e111`. -/
structure OctonionMulAutFixingE111 where
  /-- The underlying bijection on octonions. -/
  toEquiv : Octonion ≃ Octonion
  map_add : ∀ x y, toEquiv (x + y) = toEquiv x + toEquiv y
  map_smul : ∀ (r : ℝ) x, toEquiv (r • x) = r • toEquiv x
  map_one : toEquiv 1 = 1
  map_mul : ∀ x y, toEquiv (x * y) = toEquiv x * toEquiv y
  fixes_e111 : toEquiv e111 = e111
  map_conj : ∀ x, toEquiv (Octonion.conj x) = Octonion.conj (toEquiv x)

/-! ## Coercion to `FixingE111MulLinear` -/

/-- Every `OctonionMulAutFixingE111` gives a `FixingE111MulLinear` by
    forgetting bijectivity. -/
def OctonionMulAutFixingE111.toFixingE111MulLinear
    (f : OctonionMulAutFixingE111) : FixingE111MulLinear where
  toFun := f.toEquiv
  map_add := f.map_add
  map_smul := f.map_smul
  map_one := f.map_one
  map_mul := f.map_mul
  fixes_e111 := f.fixes_e111
  map_conj := f.map_conj

/-! ## Construction of the inverse -/

/-- The inverse of a `FixingE111MulLinear` map (defined via the SU(3)
    group structure) satisfies the algebraic properties needed for
    `FixingE111MulLinear`. This is just the group inverse. -/
noncomputable def FixingE111MulLinear.invFun
    (g : FixingE111MulLinear) : Octonion → Octonion :=
  g⁻¹.toFun

theorem FixingE111MulLinear.left_inv_apply
    (g : FixingE111MulLinear) (x : Octonion) :
    g⁻¹.toFun (g.toFun x) = x := by
  have h : (g⁻¹ * g).toFun x = x := by
    rw [inv_mul_cancel]; rfl
  exact h

theorem FixingE111MulLinear.right_inv_apply
    (g : FixingE111MulLinear) (x : Octonion) :
    g.toFun (g⁻¹.toFun x) = x := by
  have h : (g * g⁻¹).toFun x = x := by
    rw [mul_inv_cancel]; rfl
  exact h

/-! ## Lifting `FixingE111MulLinear` to an automorphism -/

/-- Every `FixingE111MulLinear` element lifts to an
    `OctonionMulAutFixingE111`, since the group structure provides an
    inverse. -/
noncomputable def FixingE111MulLinear.toOctonionMulAutFixingE111
    (g : FixingE111MulLinear) : OctonionMulAutFixingE111 where
  toEquiv :=
    { toFun := g.toFun
      invFun := g⁻¹.toFun
      left_inv := g.left_inv_apply
      right_inv := g.right_inv_apply }
  map_add := g.map_add
  map_smul := g.map_smul
  map_one := g.map_one
  map_mul := g.map_mul
  fixes_e111 := g.fixes_e111
  map_conj := g.map_conj

/-! ## Round-trip lemmas -/

theorem OctonionMulAutFixingE111.toFixing_toAut_toFun
    (f : OctonionMulAutFixingE111) (x : Octonion) :
    (f.toFixingE111MulLinear.toOctonionMulAutFixingE111).toEquiv x =
      f.toEquiv x := by
  rfl

noncomputable def OctonionMulAutFixingE111.ext
    {f g : OctonionMulAutFixingE111}
    (h : ∀ x, f.toEquiv x = g.toEquiv x) : f = g := by
  cases f; cases g
  simp only [mk.injEq]
  exact Equiv.ext h

theorem FixingE111MulLinear.toAut_toFixing
    (g : FixingE111MulLinear) :
    g.toOctonionMulAutFixingE111.toFixingE111MulLinear = g := by
  cases g; rfl

theorem OctonionMulAutFixingE111.toFixing_toAut
    (f : OctonionMulAutFixingE111) :
    f.toFixingE111MulLinear.toOctonionMulAutFixingE111 = f := by
  apply OctonionMulAutFixingE111.ext
  intro x; rfl

/-! ## The equivalence -/

/-- The equivalence between `OctonionMulAutFixingE111` and
    `FixingE111MulLinear`: every multiplicative linear automorphism fixing
    `e111` corresponds to a unique `FixingE111MulLinear` element, and
    vice versa. -/
noncomputable def octonionMulAutFixingE111EquivFixingE111MulLinear :
    OctonionMulAutFixingE111 ≃ FixingE111MulLinear where
  toFun := OctonionMulAutFixingE111.toFixingE111MulLinear
  invFun := FixingE111MulLinear.toOctonionMulAutFixingE111
  left_inv := OctonionMulAutFixingE111.toFixing_toAut
  right_inv := FixingE111MulLinear.toAut_toFixing

/-! ## Monoid structure on `OctonionMulAutFixingE111` -/

/-- Identity automorphism. -/
noncomputable def OctonionMulAutFixingE111.id :
    OctonionMulAutFixingE111 :=
  (1 : FixingE111MulLinear).toOctonionMulAutFixingE111

/-- Composition of automorphisms. -/
noncomputable def OctonionMulAutFixingE111.comp
    (f g : OctonionMulAutFixingE111) :
    OctonionMulAutFixingE111 :=
  (f.toFixingE111MulLinear * g.toFixingE111MulLinear).toOctonionMulAutFixingE111

/-- Composition of automorphisms preserves the forward direction:
    `toFixingE111MulLinear` is a monoid homomorphism. -/
theorem OctonionMulAutFixingE111.toFixing_comp
    (f g : OctonionMulAutFixingE111) :
    (f.comp g).toFixingE111MulLinear =
      f.toFixingE111MulLinear * g.toFixingE111MulLinear := by
  simp [comp, FixingE111MulLinear.toAut_toFixing]

theorem OctonionMulAutFixingE111.toFixing_id :
    OctonionMulAutFixingE111.id.toFixingE111MulLinear =
      (1 : FixingE111MulLinear) := by
  simp [OctonionMulAutFixingE111.id, FixingE111MulLinear.toAut_toFixing]

/-! ## Composition with the SU(3) equivalence -/

/-- The composite equivalence from `OctonionMulAutFixingE111` to the SU(3)
    submonoid, going through `FixingE111MulLinear`. -/
noncomputable def octonionMulAutFixingE111EquivSU3 :
    OctonionMulAutFixingE111 ≃ su3Submonoid :=
  octonionMulAutFixingE111EquivFixingE111MulLinear.trans
    fixingE111MulLinearEquivSU3.toEquiv

/-- The induced matrix of an `OctonionMulAutFixingE111` automorphism on
    the complement `ℂ³` agrees with the matrix of its underlying
    `FixingE111MulLinear` element. -/
theorem OctonionMulAutFixingE111.onComplexVecMatrix_eq
    (f : OctonionMulAutFixingE111) :
    f.toFixingE111MulLinear.onComplexVecMatrix =
      (fixingE111MulLinearEquivSU3
        f.toFixingE111MulLinear : Matrix (Fin 3) (Fin 3) ℂ) := by
  rfl

end PhysicsSM.Algebra.Octonion.G2ComplexLine
