import PhysicsSM.Draft.NullEdge.GateYM.CenterFluxSector

/-!
# Gate YM: ordered center-charged line operators

This module adds the smallest charged-object layer on top of
`CenterFluxSector`: ordered noncontractible line holonomies on the finite torus.
The center-shift operators already preserve every local plaquette holonomy; the
line holonomies below record the complementary finite identity that a
noncontractible line can pick up a center factor.

Claim label: finite identity / one-form center-symmetry shadow. This is not a
continuum confinement theorem, Ward identity, anomaly statement, spontaneous
breaking claim, or cohomological background-field construction.

Provenance: the one-form-symmetry framing follows GKSW as terminology only, and
the center-twist notation follows the Tomboulis-Yaffe / Kanazawa lane already
documented in `TYAreaLaw`. The proofs below are elementary finite group
bookkeeping.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace CenterFluxSector

variable {G : Type*} [Group G] {Lx Ly : Nat}

/-- Ordered line holonomy wrapping the x-cycle at row `j`.

The product is ordered (`List.prod` over `List.finRange`) because the gauge
group is not assumed commutative. -/
def xLineHol (U : TorusLinkFieldG G Lx Ly) (j : Fin Ly) : G :=
  ((List.finRange Lx).map (fun i => U.hLink i j)).prod

/-- Ordered line holonomy wrapping the y-cycle at column `i`.

The product is ordered (`List.prod` over `List.finRange`) because the gauge
group is not assumed commutative. -/
def yLineHol (U : TorusLinkFieldG G Lx Ly) (i : Fin Lx) : G :=
  ((List.finRange Ly).map (fun j => U.vLink i j)).prod

/-- A central factor tagged onto one label in an ordered product can be pulled
out with multiplicity equal to the label count. -/
theorem prod_central_tag {α : Type*} [DecidableEq α]
    (z : Subgroup.center G) (i0 : α) (l : List α) (f : α → G) :
    ((l.map (fun i => if i = i0 then (z : G) * f i else f i)).prod)
      = (z : G) ^ (l.count i0) * (l.map f).prod := by
  have hcz : ∀ (g : G) (m : Nat), Commute g ((z : G) ^ m) := fun g m =>
    Commute.pow_right (Subgroup.mem_center_iff.mp z.2 g) m
  induction l with
  | nil => simp
  | cons a t ih =>
      simp only [List.map_cons, List.prod_cons, ih, List.count_cons]
      by_cases ha : a = i0
      · subst ha
        simp only [beq_self_eq_true, if_true]
        rw [← mul_assoc, mul_assoc (z : G) (f a),
          (hcz (f a) (t.count a)).eq, ← mul_assoc, ← mul_assoc, ← pow_succ']
      · have hb : (a == i0) = false := by simpa [beq_iff_eq] using ha
        simp only [if_neg ha, hb, Bool.false_eq_true, if_false, add_zero]
        rw [← mul_assoc, (hcz (f a) (t.count i0)).eq, mul_assoc]

/-- The x-cycle line picks up one central factor under an x-flux shift. -/
theorem xLineHol_xFluxShift (z : Subgroup.center G) (i0 : Fin Lx)
    (U : TorusLinkFieldG G Lx Ly) (j : Fin Ly) :
    xLineHol (xFluxShift z i0 U) j = (z : G) * xLineHol U j := by
  unfold xLineHol xFluxShift
  rw [prod_central_tag]
  rw [List.count_finRange]
  simp

/-- The x-cycle line is neutral under y-flux shifts, which touch only vertical
links. -/
theorem xLineHol_yFluxShift (z : Subgroup.center G) (j0 : Fin Ly)
    (U : TorusLinkFieldG G Lx Ly) (j : Fin Ly) :
    xLineHol (yFluxShift z j0 U) j = xLineHol U j := rfl

/-- The y-cycle line picks up one central factor under a y-flux shift. -/
theorem yLineHol_yFluxShift (z : Subgroup.center G) (j0 : Fin Ly)
    (U : TorusLinkFieldG G Lx Ly) (i : Fin Lx) :
    yLineHol (yFluxShift z j0 U) i = (z : G) * yLineHol U i := by
  unfold yLineHol yFluxShift
  rw [prod_central_tag]
  rw [List.count_finRange]
  simp

/-- The y-cycle line is neutral under x-flux shifts, which touch only horizontal
links. -/
theorem yLineHol_xFluxShift (z : Subgroup.center G) (i0 : Fin Lx)
    (U : TorusLinkFieldG G Lx Ly) (i : Fin Lx) :
    yLineHol (xFluxShift z i0 U) i = yLineHol U i := rfl

/-- Opposite x-flux shifts act trivially on every x-cycle line. This is only a
finite deformation-triviality shadow, not a cohomology theorem. -/
theorem xLineHol_xFluxShift_pair (z : Subgroup.center G) (i0 i1 : Fin Lx)
    (U : TorusLinkFieldG G Lx Ly) (j : Fin Ly) :
    xLineHol (xFluxShift z i0 (xFluxShift z⁻¹ i1 U)) j = xLineHol U j := by
  rw [xLineHol_xFluxShift, xLineHol_xFluxShift]
  rw [← mul_assoc]
  simp

/-- Opposite y-flux shifts act trivially on every y-cycle line. This is only a
finite deformation-triviality shadow, not a cohomology theorem. -/
theorem yLineHol_yFluxShift_pair (z : Subgroup.center G) (j0 j1 : Fin Ly)
    (U : TorusLinkFieldG G Lx Ly) (i : Fin Lx) :
    yLineHol (yFluxShift z j0 (yFluxShift z⁻¹ j1 U)) i = yLineHol U i := by
  rw [yLineHol_yFluxShift, yLineHol_yFluxShift]
  rw [← mul_assoc]
  simp

end CenterFluxSector
end GateYM
end NullEdge
end Draft
end PhysicsSM
