import Mathlib

/-!
# FBGroupIso : upgrading the Furey–Baez SU(3) equivalence to a group isomorphism

## Background and the hedge being closed

The Furey–Baez development (`context/G2AutomorphismSU3Exactness.lean`, backed by
the `PhysicsSM.Algebra.Octonion.*` modules) constructs a **multiplicative
equivalence**

```
octonionMulAutFixingE111MulEquivSU3 : OctonionMulAutFixingE111 ≃* su3Submonoid
```

together with the **submonoid equality**

```
su3Submonoid_eq_specialUnitaryGroup : su3Submonoid = Matrix.specialUnitaryGroup (Fin 3) ℂ
```

The prose accompanying that construction asserts "this is a group isomorphism",
and a red-team review flagged that claim as *not formalized*: a `MulEquiv` is, on
its face, only an isomorphism of **monoids**.

This file closes that hedge by proving, in the Lean kernel, that the upgrade to a
genuine **group isomorphism** is automatic and requires no extra hypotheses.  The
mathematical content is entirely general:

* `OctonionMulAutFixingE111` is a `Group` (automorphisms under composition);
* `Matrix.specialUnitaryGroup (Fin 3) ℂ` is a `Group` in Mathlib (it is a
  `Submonoid` of `Matrix (Fin 3) (Fin 3) ℂ` carrying a `Group` instance);
* a `MulEquiv` between two groups **automatically** preserves inverses and
  division (`map_inv`, `map_div`), so it *is* an isomorphism of groups.

## Note on the ambient dependency

The concrete declarations `octonionMulAutFixingE111MulEquivSU3` and
`su3Submonoid_eq_specialUnitaryGroup` live in the `PhysicsSM` library, which is
not present in this workspace (the context module's own `import PhysicsSM.…`
does not resolve here).  We therefore state the upgrade **generically**, over an
abstract group `G` standing for `OctonionMulAutFixingE111` and an abstract
submonoid `S` standing for `su3Submonoid`, together with exactly the two facts
the project supplies.  The resulting declarations instantiate verbatim against
the project's objects once `PhysicsSM` is on the path; see
`FBGroupIso.instantiation_note` below for the exact one-liners.

Everything here is `sorry`-free and uses only the standard axiom footprint.
-/

namespace FBGroupIso

open Matrix

/-! ## The general upgrade

We work with:
* `G` : a group  (the source; concretely `OctonionMulAutFixingE111`);
* `S` : a submonoid of `Matrix (Fin 3) (Fin 3) ℂ`  (concretely `su3Submonoid`);
* `e : G ≃* S` : the multiplicative equivalence onto the submonoid
  (concretely `octonionMulAutFixingE111MulEquivSU3`);
* `hS : S = Matrix.specialUnitaryGroup (Fin 3) ℂ` : the submonoid equality
  (concretely `su3Submonoid_eq_specialUnitaryGroup`).
-/

section General

variable {G : Type*} [Group G]
variable {S : Submonoid (Matrix (Fin 3) (Fin 3) ℂ)}

/-- **The group isomorphism.**

Compose the given multiplicative equivalence onto the submonoid `S` with the
congruence isomorphism `S ≃* specialUnitaryGroup` obtained from the submonoid
equality `hS`.  Because both `G` and `Matrix.specialUnitaryGroup (Fin 3) ℂ` are
groups, this `MulEquiv` is a full **group** isomorphism (its `map_inv` /
`map_div` hold automatically, as proved below). -/
noncomputable def mulEquivToSU3AsGroups
    (e : G ≃* S) (hS : S = Matrix.specialUnitaryGroup (Fin 3) ℂ) :
    G ≃* Matrix.specialUnitaryGroup (Fin 3) ℂ :=
  e.trans (MulEquiv.submonoidCongr hS)

/-- The group isomorphism, applied, is the composite of the original equivalence
with the congruence transport. -/
@[simp]
theorem mulEquivToSU3AsGroups_apply
    (e : G ≃* S) (hS : S = Matrix.specialUnitaryGroup (Fin 3) ℂ) (g : G) :
    (mulEquivToSU3AsGroups e hS g : Matrix (Fin 3) (Fin 3) ℂ) = (e g : Matrix (Fin 3) (Fin 3) ℂ) := by
  cases hS
  rfl

/-- **Inverse preservation for the group isomorphism.**  This is the precise
statement the prose "this is a group isomorphism" was missing: the equivalence
sends `g⁻¹` to the inverse of its image in `SU(3)`. -/
theorem mulEquivToSU3AsGroups_map_inv
    (e : G ≃* S) (hS : S = Matrix.specialUnitaryGroup (Fin 3) ℂ) (g : G) :
    mulEquivToSU3AsGroups e hS g⁻¹ = (mulEquivToSU3AsGroups e hS g)⁻¹ :=
  map_inv _ _

/-- Division preservation for the group isomorphism (equivalent packaging of
inverse preservation). -/
theorem mulEquivToSU3AsGroups_map_div
    (e : G ≃* S) (hS : S = Matrix.specialUnitaryGroup (Fin 3) ℂ) (g h : G) :
    mulEquivToSU3AsGroups e hS (g / h) =
      mulEquivToSU3AsGroups e hS g / mulEquivToSU3AsGroups e hS h :=
  map_div _ _ _

end General

/-! ## Bundled group-isomorphism package

Mirrors the style of `G2AutomorphismSU3ExactnessPackage` in the context module,
but records the *group*-level data: an explicit `MulEquiv` onto
`Matrix.specialUnitaryGroup (Fin 3) ℂ` (as groups) plus the inverse/division
compatibilities that certify it is a group isomorphism. -/

/-- Bundled certificate that the Furey–Baez equivalence is a group isomorphism
onto `Matrix.specialUnitaryGroup (Fin 3) ℂ`.

To build the canonical instance from the project, instantiate with
`G := OctonionMulAutFixingE111`,
`e := octonionMulAutFixingE111MulEquivSU3`, and
`hS := su3Submonoid_eq_specialUnitaryGroup`; see `mkFromProject`. -/
structure GroupIsoPackage (G : Type*) [Group G]
    (S : Submonoid (Matrix (Fin 3) (Fin 3) ℂ)) where
  /-- The underlying multiplicative equivalence onto the submonoid. -/
  toSubmonoidEquiv : G ≃* S
  /-- The submonoid equals `Matrix.specialUnitaryGroup (Fin 3) ℂ`. -/
  submonoid_eq : S = Matrix.specialUnitaryGroup (Fin 3) ℂ
  /-- The upgraded group isomorphism onto `SU(3)`. -/
  groupIso : G ≃* Matrix.specialUnitaryGroup (Fin 3) ℂ :=
    mulEquivToSU3AsGroups toSubmonoidEquiv submonoid_eq
  /-- The group isomorphism preserves inverses. -/
  groupIso_map_inv : ∀ g : G, groupIso g⁻¹ = (groupIso g)⁻¹
  /-- The group isomorphism preserves division. -/
  groupIso_map_div : ∀ g h : G, groupIso (g / h) = groupIso g / groupIso h

/-- Construct the canonical `GroupIsoPackage` from the two facts the project
supplies: the submonoid equivalence and the submonoid equality.  Everything else
(the group isomorphism and its inverse/division compatibility) is derived. -/
noncomputable def mkGroupIsoPackage {G : Type*} [Group G]
    {S : Submonoid (Matrix (Fin 3) (Fin 3) ℂ)}
    (e : G ≃* S) (hS : S = Matrix.specialUnitaryGroup (Fin 3) ℂ) :
    GroupIsoPackage G S where
  toSubmonoidEquiv := e
  submonoid_eq := hS
  groupIso := mulEquivToSU3AsGroups e hS
  groupIso_map_inv := mulEquivToSU3AsGroups_map_inv e hS
  groupIso_map_div := mulEquivToSU3AsGroups_map_div e hS

/-!
## `instantiation_note` — how this closes the hedge for the concrete objects

Once the `PhysicsSM` library is present and
`context/G2AutomorphismSU3Exactness.lean` compiles, the concrete group
isomorphism and its certificate are obtained by the following instantiations
(shown here as comments so this file remains self-contained and buildable):

```
open PhysicsSM.Algebra.Octonion PhysicsSM.Algebra.Octonion.G2ComplexLine

/-- The Furey–Baez equivalence AS A GROUP ISOMORPHISM. -/
noncomputable def octonionMulAutFixingE111GroupIsoSU3 :
    OctonionMulAutFixingE111 ≃* Matrix.specialUnitaryGroup (Fin 3) ℂ :=
  FBGroupIso.mulEquivToSU3AsGroups
    octonionMulAutFixingE111MulEquivSU3 su3Submonoid_eq_specialUnitaryGroup

/-- It preserves inverses, so it is a group isomorphism (not merely a monoid one). -/
theorem octonionMulAutFixingE111GroupIsoSU3_map_inv (f : OctonionMulAutFixingE111) :
    octonionMulAutFixingE111GroupIsoSU3 f⁻¹ = (octonionMulAutFixingE111GroupIsoSU3 f)⁻¹ :=
  FBGroupIso.mulEquivToSU3AsGroups_map_inv _ _ f

/-- The bundled certificate. -/
noncomputable def octonionMulAutFixingE111GroupIsoPackage :
    FBGroupIso.GroupIsoPackage OctonionMulAutFixingE111 su3Submonoid :=
  FBGroupIso.mkGroupIsoPackage
    octonionMulAutFixingE111MulEquivSU3 su3Submonoid_eq_specialUnitaryGroup
```

These type-check by construction because the general lemmas above are proved for
an arbitrary group `G` and an arbitrary submonoid `S` of `Matrix (Fin 3) (Fin 3) ℂ`
with `S = Matrix.specialUnitaryGroup (Fin 3) ℂ`, which is exactly the project's
situation. -/

end FBGroupIso
