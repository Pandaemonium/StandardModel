import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteCore
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCore
import PhysicsSM.Draft.NullEdge.GateYM.WilsonLocalWeight
import PhysicsSM.Draft.NullEdge.GateYM.WilsonCutPlaquettePositivity

/-!
# Gate YM3/Q1: a minimal concrete cut-plaquette geometry

This draft module is the next geometric layer after
`WilsonCutPlaquettePositivity.lean`. It defines a four-edge lattice carrying a
single plaquette that actually crosses the reflection plane: one positive-side
spatial edge, one mirror negative-side spatial edge, and two cut edges.

The main point is the mirror-coordinate factorization

`hol = e(c, a) * (e(c, b))^-1`

with the SAME read-off map `e` on the positive and mirrored-negative slots.
That is precisely the shape consumed by
`WilsonCutPlaquettePositivity.cutKernel_posSemidef_of_wilsonFactor`.

Scope boundary: this is a finite geometry and holonomy-factorization example.
It does not yet identify a full `PlaquetteEnsemble.weight` on a larger
cut-bearing lattice or close RP-LINK.

Claim label: **finite identity / concrete example**. Draft-trust:
kernel-checked; no proof placeholders.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ReflectionCutPlaquetteExample

open scoped Matrix ComplexOrder
open GaugeCoreGeneral PlaquetteCore ReflectionCore
open WilsonWeightPositivity WilsonCutPlaquettePositivity

/-- Vertices of the minimal cut plaquette. The `n*` vertices are on the
negative side and the `p*` vertices are on the positive side. -/
inductive CutPlaqVertex
  | n0
  | n1
  | p0
  | p1
  deriving DecidableEq, Fintype

/-- Edges of the minimal cut plaquette: positive spatial edge, negative spatial
edge, and two cut edges. -/
inductive CutPlaqEdge
  | pos
  | neg
  | cut0
  | cut1
  deriving DecidableEq, Fintype

open CutPlaqVertex CutPlaqEdge

/-- The four-edge lattice supporting one plaquette crossing the reflection
plane. -/
def cutPlaqLattice : OrientedLattice where
  V := CutPlaqVertex
  E := CutPlaqEdge
  src
    | pos => p0
    | neg => n0
    | cut0 => n0
    | cut1 => n1
  tgt
    | pos => p1
    | neg => n1
    | cut0 => p0
    | cut1 => p1

/-- Vertex reflection: positive and negative vertices are paired across the
cut so that the reflected edge orientation obeys `Reflection.reflect_src` /
`Reflection.reflect_tgt`. -/
def reflectCutPlaqVertex : CutPlaqVertex → CutPlaqVertex
  | n0 => p1
  | n1 => p0
  | p0 => n1
  | p1 => n0

/-- Edge reflection for the concrete cut plaquette. -/
def reflectCutPlaqEdge : CutPlaqEdge → CutPlaqEdge
  | pos => neg
  | neg => pos
  | cut0 => cut1
  | cut1 => cut0

/-- Positive-side predicate for the concrete cut plaquette. -/
def cutPlaqPositiveSide : CutPlaqVertex → Prop
  | p0 => True
  | p1 => True
  | n0 => False
  | n1 => False

/-- Reflection structure on the minimal cut-plaquette lattice. -/
def cutPlaqReflection : Reflection cutPlaqLattice where
  reflectV := reflectCutPlaqVertex
  reflectE := reflectCutPlaqEdge
  reflectV_involutive := by
    intro v
    cases v <;> rfl
  reflectE_involutive := by
    intro e
    cases e <;> rfl
  reflect_src := by
    intro e
    cases e <;> rfl
  reflect_tgt := by
    intro e
    cases e <;> rfl
  posSide := cutPlaqPositiveSide
  posSide_reflect := by
    intro v
    cases v <;> simp [cutPlaqPositiveSide, reflectCutPlaqVertex]

/-- The spatial positive edge lies strictly on the positive side. -/
theorem cutPlaqReflection_positive_pos :
    cutPlaqReflection.positiveLink pos := by
  simp [Reflection.positiveLink, cutPlaqReflection, cutPlaqLattice,
    cutPlaqPositiveSide]

/-- The spatial negative edge lies strictly on the negative side. -/
theorem cutPlaqReflection_negative_neg :
    cutPlaqReflection.negativeLink neg := by
  simp [Reflection.negativeLink, cutPlaqReflection, cutPlaqLattice,
    cutPlaqPositiveSide]

/-- The first vertical edge crosses the cut. -/
theorem cutPlaqReflection_cut_cut0 :
    cutPlaqReflection.cutLink cut0 := by
  simp [Reflection.cutLink, cutPlaqReflection, cutPlaqLattice,
    cutPlaqPositiveSide]

/-- The second vertical edge crosses the cut. -/
theorem cutPlaqReflection_cut_cut1 :
    cutPlaqReflection.cutLink cut1 := by
  simp [Reflection.cutLink, cutPlaqReflection, cutPlaqLattice,
    cutPlaqPositiveSide]

/-- The single straddling plaquette:
`n0 -> p0 -> p1 -> n1 -> n0`. -/
def cutPlaquette : Plaquette cutPlaqLattice where
  base := n0
  v1 := p0
  v2 := p1
  v3 := n1
  step0 := OrientedLattice.Step.fwd (Λ := cutPlaqLattice) CutPlaqEdge.cut0
  step1 := OrientedLattice.Step.fwd (Λ := cutPlaqLattice) CutPlaqEdge.pos
  step2 := OrientedLattice.Step.rev (Λ := cutPlaqLattice) CutPlaqEdge.cut1
  step3 := OrientedLattice.Step.rev (Λ := cutPlaqLattice) CutPlaqEdge.neg

/-- The singleton plaquette family containing the concrete cut plaquette. -/
def cutPlaquetteFamily : PUnit → Plaquette cutPlaqLattice :=
  fun _ => cutPlaquette

/-- Mirror coordinates for the concrete cut plaquette.

The stored `neg` coordinate is the mirrored negative-side variable. The actual
negative edge value in the link field is `cut0 * neg * cut1^-1`, so the
plaquette holonomy factors through the same read-off map on both side slots. -/
structure CutMirrorCoord (G : Type) where
  pos : G
  cut0 : G
  cut1 : G
  neg : G

variable {G : Type} [Group G]

/-- Symmetric read-off word used by the cut-factor bridge. -/
def cutPlaqEWord (c : G × G) (x : G) : G :=
  c.1 * x * c.2⁻¹

/-- Build a link field from positive, cut, and mirrored-negative coordinates. -/
def cutMirrorConfig (a : G) (c : G × G) (b : G) :
    cutPlaqLattice.LinkField (G := G)
  | pos => a
  | cut0 => c.1
  | cut1 => c.2
  | neg => c.1 * b * c.2⁻¹

/-- The mirror-coordinate equivalence for the minimal cut plaquette. -/
def cutMirrorCoord : cutPlaqLattice.LinkField (G := G) ≃ CutMirrorCoord G where
  toFun U :=
    { pos := U pos
      cut0 := U cut0
      cut1 := U cut1
      neg := (U cut0)⁻¹ * U neg * U cut1 }
  invFun q := cutMirrorConfig q.pos (q.cut0, q.cut1) q.neg
  left_inv U := by
    funext e
    cases e <;> simp [cutMirrorConfig]
    group
  right_inv q := by
    cases q
    simp [cutMirrorConfig]
    group

/-- Holonomy of the concrete cut plaquette in mirror coordinates. -/
theorem cutPlaquette_hol_mirrorConfig (a b : G) (c : G × G) :
    cutPlaquette.hol (cutMirrorConfig a c b)
      = cutPlaqEWord c a * (cutPlaqEWord c b)⁻¹ := by
  rcases c with ⟨c0, c1⟩
  simp [Plaquette.hol, Plaquette.walk, OrientedLattice.hol,
    OrientedLattice.stepHol, cutPlaquette, cutMirrorConfig, cutPlaqEWord]
  group

/-- Equivalent holonomy factorization phrased through the coordinate
equivalence. -/
theorem cutPlaquette_hol_cutMirrorCoord (q : CutMirrorCoord G) :
    cutPlaquette.hol ((cutMirrorCoord (G := G)).symm q)
      = cutPlaqEWord (q.cut0, q.cut1) q.pos
        * (cutPlaqEWord (q.cut0, q.cut1) q.neg)⁻¹ := by
  rcases q with ⟨a, c0, c1, b⟩
  exact cutPlaquette_hol_mirrorConfig a b (c0, c1)

variable [Fintype G] {n : ℕ}

/-- The Wilson cut-factor bridge specialized to the concrete read-off word of
the minimal cut plaquette. This is not yet an ensemble-weight theorem; it is
the RP-KER-ready kernel associated to the holonomy factorization above. -/
theorem cutPlaquette_wilsonFactor_reflectionPositive
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    ReflectionPositivityKernel.IsReflectionPositive (A := G) (C := G × G)
      (fun a c b =>
        ((wilsonKernel beta rho (cutPlaqEWord c a) (cutPlaqEWord c b) : ℝ) : ℂ)) :=
  reflectionForm_nonneg_of_wilsonFactor beta hbeta rho hmul hone hunit cutPlaqEWord

omit [Fintype G] in
/-- The genuine singleton `PlaquetteEnsemble.weight` of the concrete
cut plaquette is exactly the Wilson kernel expression at mirror coordinates. -/
theorem cutPlaquette_weight_mirrorConfig_eq_wilsonKernel
    (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (a b : G) (c : G × G) :
    PlaquetteEnsemble.weight cutPlaquetteFamily
        (WilsonLocalWeight.wilsonLocalWeight beta rho) (cutMirrorConfig a c b)
      = wilsonKernel beta rho (cutPlaqEWord c a) (cutPlaqEWord c b) := by
  simp [PlaquetteEnsemble.weight, PlaquetteCore.productWeight,
    cutPlaquetteFamily, WilsonLocalWeight.wilsonLocalWeight, wilsonKernel,
    cutPlaquette_hol_mirrorConfig]

/-- The singleton cut-plaquette ensemble weight is reflection positive in
mirror coordinates. This closes the one-plaquette concrete example only; it is
not yet the full finite cut-bearing lattice product theorem. -/
theorem cutPlaquette_ensemble_reflectionPositive
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    ReflectionPositivityKernel.IsReflectionPositive (A := G) (C := G × G)
      (fun a c b =>
        ((PlaquetteEnsemble.weight cutPlaquetteFamily
            (WilsonLocalWeight.wilsonLocalWeight beta rho)
            (cutMirrorConfig a c b) : ℝ) : ℂ)) := by
  convert cutPlaquette_wilsonFactor_reflectionPositive beta hbeta rho hmul hone hunit using 1
  funext a c b
  rw [cutPlaquette_weight_mirrorConfig_eq_wilsonKernel]

end ReflectionCutPlaquetteExample
end GateYM
end NullEdge
end Draft
end PhysicsSM
