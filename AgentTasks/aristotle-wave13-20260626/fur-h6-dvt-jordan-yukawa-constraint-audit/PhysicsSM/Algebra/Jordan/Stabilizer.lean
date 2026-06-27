import Mathlib
import PhysicsSM.Algebra.Jordan.H3O
import PhysicsSM.Algebra.Jordan.Automorphism
import PhysicsSM.Algebra.Jordan.ProjectiveGeometry

/-!
# Algebra.Jordan.Stabilizer

Common stabilizer group for the automorphisms of `h_3(O)` that preserve
both a complex projective plane and an octonionic line in `OP²`.

## Overview

This module defines the common stabilizer of a complex projective plane
and an octonionic line inside the octonionic projective plane `OP²`, and
proves it carries a group structure inherited from `H3OAutomorphism`.

The key insight is that both the complex-plane stabilization condition
(setwise preservation of the subalgebra carrier) and the line stabilization
condition are closed under the group operations of `H3OAutomorphism`, so
the common stabilizer is a subgroup.

## Main definitions

- `StabilizesComplexPlane` — general predicate: an automorphism preserves
  a complex projective plane's subalgebra carrier setwise.
- `StabilizesStandardComplexPlane` — specialization to the standard `h_3(C)`.
- `StabilizesStandardOctonionicLine` — specialization to `diag(1,1,0)`.
- `ProjectiveCommonStabilizer` — the common stabilizer subtype.
- `commonStabilizerSubgroup` — the common stabilizer as a `Subgroup`.
- `instGroupProjectiveCommonStabilizer` — the group instance.

## Status

This is a **trusted** module: all definitions and theorems are fully proved.

Sources:
- John Baez and Paul Schwahn, "Projective Geometry and the Exceptional Jordan
  Algebra", AMS Special Session on Non-Associative Rings and Algebras,
  March 28, 2026.
- Ivan Todorov and Michel Dubois-Violette, "Deducing the symmetry of the
  standard model from the automorphism and structure groups of the exceptional
  Jordan algebra", Int. J. Mod. Phys. A 33(20), 1850118, 2018.
-/

namespace PhysicsSM.Algebra.Jordan.Stabilizer

open PhysicsSM.Algebra.Jordan.H3O
open PhysicsSM.Algebra.Jordan.Automorphism
open PhysicsSM.Algebra.Jordan.ProjectiveGeometry

/-! ## Complex-plane stabilization -/

/-- An automorphism stabilizes a complex projective plane if it preserves
    the underlying subalgebra carrier setwise. -/
def StabilizesComplexPlane
    (g : H3OAutomorphism)
    (X : ComplexProjectivePlaneInOP2) : Prop :=
  g.Stabilizes X.subalgebra.carrier

/-- The identity stabilizes any complex projective plane. -/
theorem stabilizesComplexPlane_one (X : ComplexProjectivePlaneInOP2) :
    StabilizesComplexPlane 1 X :=
  H3OAutomorphism.one_stabilizes X.subalgebra.carrier

/-- Composition of complex-plane-stabilizing automorphisms stabilizes
    the plane. -/
theorem stabilizesComplexPlane_mul {g h : H3OAutomorphism}
    {X : ComplexProjectivePlaneInOP2}
    (hg : StabilizesComplexPlane g X)
    (hh : StabilizesComplexPlane h X) :
    StabilizesComplexPlane (g * h) X :=
  H3OAutomorphism.comp_stabilizes hg hh

/-- The inverse of a complex-plane-stabilizing automorphism stabilizes
    the plane. -/
theorem stabilizesComplexPlane_inv {g : H3OAutomorphism}
    {X : ComplexProjectivePlaneInOP2}
    (hg : StabilizesComplexPlane g X) :
    StabilizesComplexPlane g⁻¹ X :=
  H3OAutomorphism.inv_stabilizes hg

/-! ## Standard stabilization predicates -/

/-- An automorphism stabilizes the standard complex projective plane
    (the `h_3(C)` block `standardB`). -/
def StabilizesStandardComplexPlane (g : H3OAutomorphism) : Prop :=
  StabilizesComplexPlane g standardComplexPlane

/-- An automorphism stabilizes the standard octonionic line `diag(1,1,0)`. -/
def StabilizesStandardOctonionicLine (g : H3OAutomorphism) : Prop :=
  StabilizesLine g standardOctonionicLine

/-- The identity stabilizes the standard complex plane. -/
theorem stabilizesStandardComplexPlane_one :
    StabilizesStandardComplexPlane 1 :=
  stabilizesComplexPlane_one standardComplexPlane

/-- Composition preserves standard complex plane stabilization. -/
theorem stabilizesStandardComplexPlane_mul {g h : H3OAutomorphism}
    (hg : StabilizesStandardComplexPlane g)
    (hh : StabilizesStandardComplexPlane h) :
    StabilizesStandardComplexPlane (g * h) :=
  stabilizesComplexPlane_mul hg hh

/-- Inverse preserves standard complex plane stabilization. -/
theorem stabilizesStandardComplexPlane_inv {g : H3OAutomorphism}
    (hg : StabilizesStandardComplexPlane g) :
    StabilizesStandardComplexPlane g⁻¹ :=
  stabilizesComplexPlane_inv hg

/-- The identity stabilizes the standard octonionic line. -/
theorem stabilizesStandardOctonionicLine_one :
    StabilizesStandardOctonionicLine 1 :=
  stabilizesLine_one standardOctonionicLine

/-- Composition preserves standard octonionic line stabilization. -/
theorem stabilizesStandardOctonionicLine_mul {g h : H3OAutomorphism}
    (hg : StabilizesStandardOctonionicLine g)
    (hh : StabilizesStandardOctonionicLine h) :
    StabilizesStandardOctonionicLine (g * h) :=
  stabilizesLine_mul hg hh

/-- Inverse preserves standard octonionic line stabilization. -/
theorem stabilizesStandardOctonionicLine_inv {g : H3OAutomorphism}
    (hg : StabilizesStandardOctonionicLine g) :
    StabilizesStandardOctonionicLine g⁻¹ :=
  stabilizesLine_inv hg

/-! ## Common stabilizer -/

/-- The common stabilizer of a complex projective plane and an octonionic
    line, as a subtype of `H3OAutomorphism`. -/
def ProjectiveCommonStabilizer
    (X : ComplexProjectivePlaneInOP2)
    (ell : OP2Line) : Type :=
  { g : H3OAutomorphism //
    StabilizesComplexPlane g X ∧ StabilizesLine g ell }

/-- The common stabilizer as a subgroup of `H3OAutomorphism`. -/
noncomputable def commonStabilizerSubgroup
    (X : ComplexProjectivePlaneInOP2)
    (ell : OP2Line) : Subgroup H3OAutomorphism where
  carrier := {g | StabilizesComplexPlane g X ∧ StabilizesLine g ell}
  mul_mem' := fun ha hb =>
    And.intro (stabilizesComplexPlane_mul ha.1 hb.1)
              (stabilizesLine_mul ha.2 hb.2)
  one_mem' :=
    And.intro (stabilizesComplexPlane_one X) (stabilizesLine_one ell)
  inv_mem' := fun ha =>
    And.intro (stabilizesComplexPlane_inv ha.1)
              (stabilizesLine_inv ha.2)

/-- The group structure on the common stabilizer of a complex projective
    plane and an octonionic line.

    This inherits the group structure from `H3OAutomorphism` via the
    subgroup construction, using the closure of both stabilization
    conditions under identity, composition, and inversion.

    -- Dubois-Violette-Todorov, §3; Baez-Schwahn slides. -/
noncomputable instance instGroupProjectiveCommonStabilizer
    (X : ComplexProjectivePlaneInOP2) (ell : OP2Line) :
    Group (ProjectiveCommonStabilizer X ell) where
  mul a b := Subtype.mk (a.1 * b.1)
    (And.intro (stabilizesComplexPlane_mul a.2.1 b.2.1)
               (stabilizesLine_mul a.2.2 b.2.2))
  one := Subtype.mk 1
    (And.intro (stabilizesComplexPlane_one X) (stabilizesLine_one ell))
  inv a := Subtype.mk a.1⁻¹
    (And.intro (stabilizesComplexPlane_inv a.2.1)
               (stabilizesLine_inv a.2.2))
  mul_assoc a b c := Subtype.ext (mul_assoc a.1 b.1 c.1)
  one_mul a := Subtype.ext (one_mul a.1)
  mul_one a := Subtype.ext (mul_one a.1)
  inv_mul_cancel a := Subtype.ext (inv_mul_cancel a.1)

/-! ## Standard common stabilizer -/

/-- The common stabilizer of the standard complex plane and the standard
    octonionic line, as a subgroup of `H3OAutomorphism`. -/
noncomputable def standardCommonStabilizerSubgroup :
    Subgroup H3OAutomorphism :=
  commonStabilizerSubgroup standardComplexPlane standardOctonionicLine

/-! ## Preservation lemmas for the common stabilizer -/

/-- The identity element of the common stabilizer. -/
noncomputable def ProjectiveCommonStabilizer.id
    (X : ComplexProjectivePlaneInOP2)
    (ell : OP2Line) : ProjectiveCommonStabilizer X ell :=
  Subtype.mk 1
    (And.intro (stabilizesComplexPlane_one X) (stabilizesLine_one ell))

/-- Multiplication in the common stabilizer. -/
noncomputable def ProjectiveCommonStabilizer.comp
    {X : ComplexProjectivePlaneInOP2} {ell : OP2Line}
    (a b : ProjectiveCommonStabilizer X ell) :
    ProjectiveCommonStabilizer X ell :=
  Subtype.mk (a.1 * b.1)
    (And.intro (stabilizesComplexPlane_mul a.2.1 b.2.1)
               (stabilizesLine_mul a.2.2 b.2.2))

/-- Inverse in the common stabilizer. -/
noncomputable def ProjectiveCommonStabilizer.symm
    {X : ComplexProjectivePlaneInOP2} {ell : OP2Line}
    (a : ProjectiveCommonStabilizer X ell) :
    ProjectiveCommonStabilizer X ell :=
  Subtype.mk a.1⁻¹
    (And.intro (stabilizesComplexPlane_inv a.2.1)
               (stabilizesLine_inv a.2.2))

/-- The underlying automorphism of the identity element is `1`. -/
theorem ProjectiveCommonStabilizer.id_val
    (X : ComplexProjectivePlaneInOP2) (ell : OP2Line) :
    (ProjectiveCommonStabilizer.id X ell).1 = 1 := rfl

/-- The underlying automorphism of a product is the product. -/
theorem ProjectiveCommonStabilizer.comp_val
    {X : ComplexProjectivePlaneInOP2} {ell : OP2Line}
    (a b : ProjectiveCommonStabilizer X ell) :
    (ProjectiveCommonStabilizer.comp a b).1 = a.1 * b.1 := rfl

/-- The underlying automorphism of an inverse is the inverse. -/
theorem ProjectiveCommonStabilizer.symm_val
    {X : ComplexProjectivePlaneInOP2} {ell : OP2Line}
    (a : ProjectiveCommonStabilizer X ell) :
    (ProjectiveCommonStabilizer.symm a).1 = a.1⁻¹ := rfl

/-! ## Incidence preservation -/

/-- A common stabilizer element preserves incidence. -/
theorem ProjectiveCommonStabilizer.preserves_liesOn
    {X : ComplexProjectivePlaneInOP2} {ell : OP2Line}
    (g : ProjectiveCommonStabilizer X ell)
    {p : OP2Point} {l : OP2Line} (h : LiesOn p l) :
    LiesOn (mapPoint g.val p) (mapLine g.val l) :=
  map_liesOn g.val h

end PhysicsSM.Algebra.Jordan.Stabilizer
