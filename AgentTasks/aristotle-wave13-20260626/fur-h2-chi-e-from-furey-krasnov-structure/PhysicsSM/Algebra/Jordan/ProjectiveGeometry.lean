import Mathlib
import PhysicsSM.Algebra.Jordan.H3O
import PhysicsSM.Algebra.Jordan.Automorphism

/-!
# Algebra.Jordan.ProjectiveGeometry

Trusted projective geometry of `OP²` via the exceptional Jordan algebra.

## Overview

The octonionic projective plane `OP²` is modeled via projections in `h_3(O)`:
- **Points** are trace-one projections (rank-one idempotents).
- **Lines** are trace-two projections (rank-two idempotents).
- **Incidence**: a point `p` lies on a line `ℓ` iff `p ○ ℓ = p`.

This module provides trusted definitions and preservation lemmas that
connect the projective dictionary to the automorphism group.

## Main definitions

- `OP2Point` — a point of `OP²`.
- `OP2Line` — a line of `OP²`.
- `LiesOn` — the incidence relation.
- `standardOctonionicLine` — the standard line `diag(1,1,0)`.
- `standardComplexPlaneProjection` — the standard point `diag(1,0,0)`.
- `JordanSubalgebra` — a lightweight bundled subalgebra.
- `standardA`, `standardB`, `standardAInterB` — the standard subalgebras.
- Automorphism actions on projective structures.

## Status

This is a **trusted** module: all definitions and theorems are fully proved.

Sources:
- Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), §4.
- Baez and Schwahn, "Projective Geometry and the Exceptional Jordan Algebra",
  AMS Special Session on Non-Associative Rings and Algebras, March 28, 2026.
-/

namespace PhysicsSM.Algebra.Jordan.ProjectiveGeometry

open PhysicsSM.Algebra.Jordan.H3O
open PhysicsSM.Algebra.Jordan.Automorphism

local infixl:70 " ○ " => jordanProduct

/-! ## Points, lines, and incidence in `OP²` -/

/-- A point of `OP²`, represented as a trace-one projection in `h_3(O)`. -/
structure OP2Point where
  /-- The underlying H3O element. -/
  val : H3O
  /-- It is a Jordan projection: `val ○ val = val`. -/
  isProjection : IsProjection val
  /-- Its trace equals 1. -/
  trace_eq_one : trace val = 1

/-- A line of `OP²`, represented as a trace-two projection in `h_3(O)`. -/
structure OP2Line where
  /-- The underlying H3O element. -/
  val : H3O
  /-- It is a Jordan projection: `val ○ val = val`. -/
  isProjection : IsProjection val
  /-- Its trace equals 2. -/
  trace_eq_two : trace val = 2

/-- Incidence relation: the point `p` lies on the line `ell`. -/
def LiesOn (p : OP2Point) (ell : OP2Line) : Prop :=
  p.val ○ ell.val = p.val

/-! ## The standard octonionic projective line -/

/-- The standard octonionic projective line `diag(1,1,0)` in `OP²`. -/
noncomputable def standardOctonionicLine : OP2Line where
  val := standardOctonionicLineProjection
  isProjection := standardOctonionicLineProjection_isProjection
  trace_eq_two := trace_standardOctonionicLineProjection

/-! ## The standard complex plane projection -/

/-- The standard complex-plane base point `diag(1,0,0)` in `OP²`. -/
noncomputable def standardComplexPlaneProjection : OP2Point where
  val := { alpha := 1, beta := 0, gamma := 0, x := 0, y := 0, z := 0 }
  isProjection := by
    unfold IsProjection
    ext <;> simp [jordanProduct, octonionInner]
  trace_eq_one := by
    simp [trace]

/-! ## Automorphism action on projective structures -/

/-- An automorphism sends a point to a point. -/
noncomputable def mapPoint (g : H3OAutomorphism) (p : OP2Point) : OP2Point where
  val := g p.val
  isProjection := g.map_isProjection p.isProjection
  trace_eq_one := g.map_trace_one p.trace_eq_one

/-- An automorphism sends a line to a line. -/
noncomputable def mapLine (g : H3OAutomorphism) (ell : OP2Line) : OP2Line where
  val := g ell.val
  isProjection := g.map_isProjection ell.isProjection
  trace_eq_two := g.map_trace_two ell.trace_eq_two

/-- Automorphisms preserve incidence. -/
theorem map_liesOn (g : H3OAutomorphism)
    {p : OP2Point} {ell : OP2Line} (h : LiesOn p ell) :
    LiesOn (mapPoint g p) (mapLine g ell) := by
  unfold LiesOn mapPoint mapLine at *
  dsimp
  exact g.map_incidence h

/-- Automorphisms reflect incidence. -/
theorem map_liesOn_iff (g : H3OAutomorphism)
    (p : OP2Point) (ell : OP2Line) :
    LiesOn (mapPoint g p) (mapLine g ell) ↔ LiesOn p ell := by
  constructor
  · intro h
    unfold LiesOn mapPoint mapLine at *
    dsimp at h
    have h1 : p.val ○ ell.val = p.val := by
      apply g.toEquiv.injective
      rw [g.map_jordan]
      exact h
    exact h1
  · exact map_liesOn g

/-- `diag(1,0,0)` lies on the standard octonionic line `diag(1,1,0)`. -/
theorem standardComplexPlaneProjection_liesOn_standardLine :
    LiesOn standardComplexPlaneProjection standardOctonionicLine := by
  unfold LiesOn standardComplexPlaneProjection standardOctonionicLine
    standardOctonionicLineProjection
  ext <;> simp [jordanProduct, octonionInner]

/-- The identity automorphism acts trivially on points. -/
@[simp]
theorem mapPoint_one (p : OP2Point) :
    mapPoint 1 p = p := by
  cases p; simp [mapPoint, H3OAutomorphism.one_apply]

/-- The identity automorphism acts trivially on lines. -/
@[simp]
theorem mapLine_one (ell : OP2Line) :
    mapLine 1 ell = ell := by
  cases ell; simp [mapLine, H3OAutomorphism.one_apply]

/-! ## Jordan subalgebra structure -/

/--
A lightweight Jordan subalgebra structure.

This is intentionally not a Mathlib `Subalgebra`, because the project does
not yet have a bundled Jordan algebra hierarchy. It records only the carrier
and the closure facts needed for the Baez-Schwahn theorem.
-/
structure JordanSubalgebra where
  /-- The carrier set. -/
  carrier : Set H3O
  /-- Zero is in the carrier. -/
  zero_mem : (0 : H3O) ∈ carrier
  /-- The carrier is closed under addition. -/
  add_mem : ∀ {a b}, a ∈ carrier → b ∈ carrier → a + b ∈ carrier
  /-- The carrier is closed under negation. -/
  neg_mem : ∀ {a}, a ∈ carrier → -a ∈ carrier
  /-- The carrier is closed under scalar multiplication. -/
  smul_mem : ∀ (r : ℝ) {a}, a ∈ carrier → r • a ∈ carrier
  /-- The carrier is closed under the Jordan product. -/
  jordan_mem : ∀ {a b}, a ∈ carrier → b ∈ carrier → a ○ b ∈ carrier

/-- The standard `h_2(O)` block as a Jordan subalgebra. -/
noncomputable def standardA : JordanSubalgebra where
  carrier := {a : H3O | InStandardA a}
  zero_mem := zero_inStandardA
  add_mem := by intro _ _ ha hb; exact add_mem_standardA ha hb
  neg_mem := by intro _ ha; exact neg_mem_standardA ha
  smul_mem := by intro r _ ha; exact smul_mem_standardA r ha
  jordan_mem := by intro _ _ ha hb; exact jordan_mem_standardA ha hb

/-- The standard `h_3(C)` block as a Jordan subalgebra. -/
noncomputable def standardB : JordanSubalgebra where
  carrier := {a : H3O | InStandardB a}
  zero_mem := zero_inStandardB
  add_mem := by intro _ _ ha hb; exact add_mem_standardB ha hb
  neg_mem := by intro _ ha; exact neg_mem_standardB ha
  smul_mem := by intro r _ ha; exact smul_mem_standardB r ha
  jordan_mem := by intro _ _ ha hb; exact jordan_mem_standardB ha hb

/-- The standard `h_2(C)` intersection as a Jordan subalgebra. -/
noncomputable def standardAInterB : JordanSubalgebra where
  carrier := {a : H3O | InStandardAInterB a}
  zero_mem := zero_inStandardAInterB
  add_mem := by
    intro _ _ ha hb; exact ⟨add_mem_standardA ha.1 hb.1, add_mem_standardB ha.2 hb.2⟩
  neg_mem := by intro _ ha; exact ⟨neg_mem_standardA ha.1, neg_mem_standardB ha.2⟩
  smul_mem := by
    intro r _ ha; exact ⟨smul_mem_standardA r ha.1, smul_mem_standardB r ha.2⟩
  jordan_mem := by
    intro _ _ ha hb
    exact ⟨jordan_mem_standardA ha.1 hb.1, jordan_mem_standardB ha.2 hb.2⟩

/-! ## Subalgebra type predicates -/

/-- A subalgebra is of type `h_2(O)`: it contains a trace-two element. -/
def IsH2O (A : JordanSubalgebra) : Prop :=
  ∃ e : H3O, e ∈ A.carrier ∧ trace e = 2

/-- A subalgebra is of type `h_3(C)`: all elements have complex-line entries. -/
def IsH3C (B : JordanSubalgebra) : Prop :=
  ∀ a, a ∈ B.carrier → InStandardB a

/-- A subalgebra is of type `h_2(C)`: all elements are in `A ∩ B`. -/
def IsH2C (C : JordanSubalgebra) : Prop :=
  ∀ a, a ∈ C.carrier → InStandardAInterB a

/-- The standard `A` block has type `h_2(O)`. -/
theorem standardA_isH2O : IsH2O standardA :=
  ⟨standardOctonionicLineProjection,
   standardOctonionicLineProjection_inStandardA,
   trace_standardOctonionicLineProjection⟩

/-- The standard `B` block has type `h_3(C)`. -/
theorem standardB_isH3C : IsH3C standardB := fun _ ha => ha

/-- The standard intersection has type `h_2(C)`. -/
theorem standardAInterB_isH2C : IsH2C standardAInterB := fun _ ha => ha

/-- The standardA ∩ standardB intersection equals standardAInterB. -/
theorem standardAInterB_is_intersection :
    standardAInterB.carrier = standardA.carrier ∩ standardB.carrier := by
  ext a; simp [standardAInterB, standardA, standardB, InStandardAInterB]

/-! ## Stabilizer of a line -/

/-- An automorphism stabilizes a line if it fixes the underlying H3O element. -/
def StabilizesLine (g : H3OAutomorphism) (ell : OP2Line) : Prop :=
  g ell.val = ell.val

/-- The identity stabilizes every line. -/
theorem stabilizesLine_one (ell : OP2Line) :
    StabilizesLine 1 ell := rfl

/-- Composition of line-stabilizing automorphisms stabilizes the line. -/
theorem stabilizesLine_mul {g h : H3OAutomorphism} {ell : OP2Line}
    (hg : StabilizesLine g ell) (hh : StabilizesLine h ell) :
    StabilizesLine (g * h) ell := by
  unfold StabilizesLine at *
  change g (h ell.val) = ell.val
  rw [hh, hg]

/-- The inverse of a line-stabilizing automorphism stabilizes the line. -/
theorem stabilizesLine_inv {g : H3OAutomorphism} {ell : OP2Line}
    (hg : StabilizesLine g ell) :
    StabilizesLine g⁻¹ ell := by
  unfold StabilizesLine at *
  change g.toEquiv.symm ell.val = ell.val
  have h1 : g.toEquiv.symm (g.toEquiv ell.val) = ell.val :=
    g.toEquiv.symm_apply_apply ell.val
  rwa [hg] at h1

/-! ## The line stabilizer as a subgroup -/

/-- The subgroup of automorphisms stabilizing a given line. -/
noncomputable def lineStabilizerSubgroup (ell : OP2Line) :
    Subgroup H3OAutomorphism where
  carrier := {g | StabilizesLine g ell}
  mul_mem' hg hh := stabilizesLine_mul hg hh
  one_mem' := stabilizesLine_one ell
  inv_mem' hg := stabilizesLine_inv hg

/-! ## Complex projective plane in `OP²` -/

/--
A complex projective plane inside `OP²`.

For the final formalization this should be equivalent to a Jordan
subalgebra `B ⊂ h_3(O)` with `B ≅ h_3(C)`.
-/
structure ComplexProjectivePlaneInOP2 where
  /-- The set of points in the plane. -/
  points : Set OP2Point
  /-- The associated Jordan subalgebra. -/
  subalgebra : JordanSubalgebra
  /-- The subalgebra is of type `h_3(C)`. -/
  subalgebra_isH3C : IsH3C subalgebra
  /-- Points are characterized by membership in the subalgebra. -/
  point_mem_iff : ∀ p, p ∈ points ↔ p.val ∈ subalgebra.carrier

/-- The standard complex projective plane in `OP²`. -/
noncomputable def standardComplexPlane : ComplexProjectivePlaneInOP2 where
  points := {p | p.val ∈ standardB.carrier}
  subalgebra := standardB
  subalgebra_isH3C := standardB_isH3C
  point_mem_iff _ := Iff.rfl

end PhysicsSM.Algebra.Jordan.ProjectiveGeometry
