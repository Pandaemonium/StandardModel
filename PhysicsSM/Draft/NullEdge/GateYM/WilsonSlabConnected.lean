import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteCore
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCore
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.WilsonLocalWeight
import PhysicsSM.Draft.NullEdge.GateYM.WilsonCutPlaquettePositivity
import PhysicsSM.Draft.NullEdge.GateYM.WilsonCutPlaquetteEnsemble

/-!
# Gate YM3/Q1: the smallest CONNECTED cut-bearing Wilson slab

This draft module builds the first geometrically **connected** cut-bearing
Wilson lattice and proves its mirror-coordinate holonomy factorization, so it
can feed the abstract ensemble bridge
`WilsonCutPlaquetteEnsemble.reflectionPositive_of_hol_factorization`.

## What is new here

The existing `ReflectionCutPlaquetteFamily` feeds the ensemble bridge with a
geometrically **disconnected** `K`-indexed disjoint union of the minimal
four-edge cut plaquette. This module replaces that with a genuinely connected
`2 x 1` temporal slab across the reflection cut: three cross-cut ("temporal")
links, two positive-side spatial links, two mirrored negative-side spatial
links, and **two plaquettes that SHARE the middle cross-cut link** `cut1`.
Because the two plaquettes traverse the shared link with **opposite
orientations** (`plaqA` uses it reversed, `plaqB` forward), the underlying
graph is connected (unlike the disjoint family) and the `c`-dependence still
factors symmetrically.

The genuinely new proof is `slabPlaq_hol_slabMirrorConfig`: the connected
slab's Wilson holonomies have the symmetric read-off form
`hol (config a c b) = e c a * (e c b)^{-1}` for an explicit `e`. Feeding this
into the existing bridge gives reflection positivity for the connected slab's
genuine Wilson `PlaquetteEnsemble.weight`, for an arbitrary finite group `G`
and unitary representation `rho` (`wilsonSlabConnected_reflectionPositive`).

## Geometry

```
  p0 --posA--> p1 --posB--> p2       (positive side)
  ^            ^            ^
  cut0        cut1(shared) cut2      (cross-cut / temporal links)
  |            |            |
  n0 --negA--> n1 --negB--> n2       (negative side)
```

* `plaqA`: `n0 -cut0-> p0 -posA-> p1 -cut1(rev)-> n1 -negA(rev)-> n0`.
* `plaqB`: `n1 -cut1-> p1 -posB-> p2 -cut2(rev)-> n2 -negB(rev)-> n1`.

`cut1` is traversed by BOTH plaquettes (reversed in `plaqA`, forward in
`plaqB`): this is the shared cross-cut link that makes the slab connected.

## Scope / claim label

**finite identity / connected cut slab RP**, draft-trust: kernel-checked, no
proof placeholders. RP for this connected ensemble is a LINK-symmetry /
Osterwalder-Schrader-ingredient result. It is **NOT** yet a transfer operator
or a mass gap; those are the follow-on consumers of this object.

Prerequisites: `PlaquetteCore`, `ReflectionCore`, `PlaquetteEnsemble`,
`WilsonLocalWeight`, `WilsonCutPlaquettePositivity`,
`WilsonCutPlaquetteEnsemble`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace WilsonSlabConnected

open scoped Matrix ComplexOrder
open GaugeCoreGeneral PlaquetteCore ReflectionCore
open WilsonWeightPositivity WilsonCutPlaquettePositivity WilsonCutPlaquetteEnsemble

/-- Vertices of the connected `2 x 1` cut slab. The `n*` vertices are on the
negative side and the `p*` vertices are on the positive side. -/
inductive SlabVertex
  | n0 | n1 | n2
  | p0 | p1 | p2
  deriving DecidableEq, Fintype

/-- Edges of the connected `2 x 1` cut slab: two positive spatial edges, two
negative spatial edges, and three cross-cut ("temporal") edges. The middle
cross-cut edge `cut1` is shared by both plaquettes. -/
inductive SlabEdge
  | posA | posB
  | negA | negB
  | cut0 | cut1 | cut2
  deriving DecidableEq, Fintype

open SlabVertex SlabEdge

/-- The seven-edge lattice supporting two plaquettes that share the middle
cross-cut link, straddling the reflection plane. -/
def slabLattice : OrientedLattice where
  V := SlabVertex
  E := SlabEdge
  src
    | posA => p0
    | posB => p1
    | negA => n0
    | negB => n1
    | cut0 => n0
    | cut1 => n1
    | cut2 => n2
  tgt
    | posA => p1
    | posB => p2
    | negA => n1
    | negB => n2
    | cut0 => p0
    | cut1 => p1
    | cut2 => p2

/-- Vertex reflection: reflection across the cut plane composed with the
spatial reversal `column i <-> column (2 - i)`, chosen so the reflected edge
orientation obeys `Reflection.reflect_src` / `Reflection.reflect_tgt`. -/
def reflectSlabVertex : SlabVertex → SlabVertex
  | n0 => p2
  | n1 => p1
  | n2 => p0
  | p0 => n2
  | p1 => n1
  | p2 => n0

/-- Edge reflection for the connected cut slab. The middle cross-cut edge
`cut1` is fixed; the outer cross-cut edges swap; the positive and (mirrored)
negative spatial edges swap with spatial reversal. -/
def reflectSlabEdge : SlabEdge → SlabEdge
  | posA => negB
  | posB => negA
  | negA => posB
  | negB => posA
  | cut0 => cut2
  | cut1 => cut1
  | cut2 => cut0

/-- Positive-side predicate for the connected cut slab. -/
def slabPositiveSide : SlabVertex → Prop
  | p0 => True
  | p1 => True
  | p2 => True
  | n0 => False
  | n1 => False
  | n2 => False

/-- Reflection structure on the connected cut slab. -/
def slabReflection : Reflection slabLattice where
  reflectV := reflectSlabVertex
  reflectE := reflectSlabEdge
  reflectV_involutive := by
    intro v; cases v <;> rfl
  reflectE_involutive := by
    intro e; cases e <;> rfl
  reflect_src := by
    intro e; cases e <;> rfl
  reflect_tgt := by
    intro e; cases e <;> rfl
  posSide := slabPositiveSide
  posSide_reflect := by
    intro v
    cases v <;> simp [slabPositiveSide, reflectSlabVertex]

/-- The first plaquette of the slab:
`n0 -> p0 -> p1 -> n1 -> n0`, using the left and middle cross-cut links. -/
def plaqA : Plaquette slabLattice where
  base := n0
  v1 := p0
  v2 := p1
  v3 := n1
  step0 := OrientedLattice.Step.fwd (Λ := slabLattice) cut0
  step1 := OrientedLattice.Step.fwd (Λ := slabLattice) posA
  step2 := OrientedLattice.Step.rev (Λ := slabLattice) cut1
  step3 := OrientedLattice.Step.rev (Λ := slabLattice) negA

/-- The second plaquette of the slab:
`n1 -> p1 -> p2 -> n2 -> n1`, using the middle and right cross-cut links.
It shares `cut1` with `plaqA`. -/
def plaqB : Plaquette slabLattice where
  base := n1
  v1 := p1
  v2 := p2
  v3 := n2
  step0 := OrientedLattice.Step.fwd (Λ := slabLattice) cut1
  step1 := OrientedLattice.Step.fwd (Λ := slabLattice) posB
  step2 := OrientedLattice.Step.rev (Λ := slabLattice) cut2
  step3 := OrientedLattice.Step.rev (Λ := slabLattice) negB

/-- The two-plaquette index type of the connected slab. -/
inductive SlabPlaq
  | pA | pB
  deriving DecidableEq, Fintype

/-- The connected slab plaquette family. -/
def slabPlaqFamily : SlabPlaq → Plaquette slabLattice
  | SlabPlaq.pA => plaqA
  | SlabPlaq.pB => plaqB

/-! ### Connectivity: the two plaquettes share the cross-cut link `cut1` -/

/-- The (unoriented) edge underlying a single traversal step. -/
def stepEdge {Λ : OrientedLattice} : {x y : Λ.V} → OrientedLattice.Step Λ x y → Λ.E
  | _, _, OrientedLattice.Step.fwd e => e
  | _, _, OrientedLattice.Step.rev e => e

/-- A plaquette traverses an edge `e` if one of its four steps runs along `e`
(in either orientation). -/
def usesLink (p : Plaquette slabLattice) (e : SlabEdge) : Prop :=
  stepEdge p.step0 = e ∨ stepEdge p.step1 = e ∨
    stepEdge p.step2 = e ∨ stepEdge p.step3 = e

/-- `plaqA` traverses the shared cross-cut link `cut1` (as a reverse step). -/
theorem usesLink_plaqA_cut1 : usesLink plaqA cut1 := by
  exact Or.inr (Or.inr (Or.inl rfl))

/-- `plaqB` traverses the shared cross-cut link `cut1` (as a forward step). -/
theorem usesLink_plaqB_cut1 : usesLink plaqB cut1 := by
  exact Or.inl rfl

/-- `cut1` is a genuine cross-cut link. -/
theorem slabReflection_cut_cut1 : slabReflection.cutLink cut1 := by
  simp [Reflection.cutLink, slabReflection, slabLattice, slabPositiveSide]

/-- **Connectivity witness.** The middle link `cut1` is a genuine cross-cut
link that is traversed by BOTH plaquettes — with opposite orientations
(`plaqA` reversed, `plaqB` forward). This shared cross-cut link is what makes
the slab a single connected component, unlike the disjoint indexed family. -/
theorem plaquettes_share_cross_cut_link :
    slabReflection.cutLink cut1 ∧ usesLink plaqA cut1 ∧ usesLink plaqB cut1 ∧
      plaqA.step2 = OrientedLattice.Step.rev (Λ := slabLattice) cut1 ∧
      plaqB.step0 = OrientedLattice.Step.fwd (Λ := slabLattice) cut1 :=
  ⟨slabReflection_cut_cut1, usesLink_plaqA_cut1, usesLink_plaqB_cut1, rfl, rfl⟩

/-! ### Mirror-coordinate parametrization and holonomy factorization -/

variable {G : Type} [Group G]

/-- Symmetric read-off word for each plaquette of the slab. For `plaqA` the
half-variable enters through the left/middle cut pair `(c0, c1)`; for `plaqB`
through the middle/right cut pair `(c1, c2)`. The SAME functional form reads
off the positive half (`a`) and the mirrored negative half (`b`). -/
def slabEWord : SlabPlaq → (G × G × G) → (G × G) → G
  | SlabPlaq.pA, (c0, c1, _c2), (a0, _a1) => c0 * a0 * c1⁻¹
  | SlabPlaq.pB, (_c0, c1, c2), (_a0, a1) => c1 * a1 * c2⁻¹

/-- Mirror-coordinate link field of the connected slab.

* `a = (a0, a1)` are the positive-side spatial link values (`posA`, `posB`);
* `c = (c0, c1, c2)` are the cross-cut link values (`cut0`, `cut1`, `cut2`);
* `b = (b0, b1)` are the mirrored negative-side variables. The actual negative
  spatial link values are the twisted `cut * b * cut^{-1}` combinations, so
  each plaquette holonomy factors through the SAME read-off map on both side
  slots. -/
def slabMirrorConfig (a : G × G) (c : G × G × G) (b : G × G) :
    slabLattice.LinkField (G := G)
  | posA => a.1
  | posB => a.2
  | cut0 => c.1
  | cut1 => c.2.1
  | cut2 => c.2.2
  | negA => c.1 * b.1 * (c.2.1)⁻¹
  | negB => c.2.1 * b.2 * (c.2.2)⁻¹

/-- Holonomy factorization for `plaqA` in mirror coordinates. -/
theorem plaqA_hol_slabMirrorConfig (a : G × G) (c : G × G × G) (b : G × G) :
    plaqA.hol (slabMirrorConfig a c b)
      = slabEWord SlabPlaq.pA c a * (slabEWord SlabPlaq.pA c b)⁻¹ := by
  rcases a with ⟨a0, a1⟩
  rcases b with ⟨b0, b1⟩
  rcases c with ⟨c0, c1, c2⟩
  simp [Plaquette.hol, Plaquette.walk, OrientedLattice.hol,
    OrientedLattice.stepHol, plaqA, slabMirrorConfig, slabEWord]
  group

/-- Holonomy factorization for `plaqB` in mirror coordinates. -/
theorem plaqB_hol_slabMirrorConfig (a : G × G) (c : G × G × G) (b : G × G) :
    plaqB.hol (slabMirrorConfig a c b)
      = slabEWord SlabPlaq.pB c a * (slabEWord SlabPlaq.pB c b)⁻¹ := by
  rcases a with ⟨a0, a1⟩
  rcases b with ⟨b0, b1⟩
  rcases c with ⟨c0, c1, c2⟩
  simp [Plaquette.hol, Plaquette.walk, OrientedLattice.hol,
    OrientedLattice.stepHol, plaqB, slabMirrorConfig, slabEWord]
  group

/-- **The connected-slab holonomy factorization (M1/M3).** Every plaquette of
the connected slab has, in mirror coordinates, the symmetric read-off form
`hol (config a c b) = e c a * (e c b)^{-1}`. This is the one genuinely new
proof: the shared cross-cut link `cut1` appears with opposite orientation in
the two plaquettes, so its contribution factors symmetrically on both sides. -/
theorem slabPlaq_hol_slabMirrorConfig
    (k : SlabPlaq) (a : G × G) (c : G × G × G) (b : G × G) :
    (slabPlaqFamily k).hol (slabMirrorConfig a c b)
      = slabEWord k c a * (slabEWord k c b)⁻¹ := by
  cases k with
  | pA => exact plaqA_hol_slabMirrorConfig a c b
  | pB => exact plaqB_hol_slabMirrorConfig a c b

/-! ### Reflection positivity for the connected slab -/

variable [Fintype G] {n : ℕ}

omit [Fintype G] in
/-- The genuine Wilson `PlaquetteEnsemble.weight` of the connected slab, in
mirror coordinates, is exactly the product of the two Wilson cut kernels. -/
theorem slab_weight_slabMirrorConfig_eq_wilsonKernel_prod
    (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (a : G × G) (c : G × G × G) (b : G × G) :
    PlaquetteEnsemble.weight slabPlaqFamily
        (WilsonLocalWeight.wilsonLocalWeight beta rho) (slabMirrorConfig a c b)
      = ∏ k : SlabPlaq, wilsonKernel beta rho (slabEWord k c a) (slabEWord k c b) :=
  weight_mirrorConfig_eq_wilsonKernel_prod_of_hol_factorization
    slabPlaqFamily slabMirrorConfig slabEWord
    (fun k a c b => slabPlaq_hol_slabMirrorConfig k a c b)
    beta rho a c b

/-- **Reflection positivity of the connected cut slab (RP-LINK ingredient).**
For an arbitrary finite group `G` and a unitary representation `rho` with
`beta >= 0`, the genuine Wilson `PlaquetteEnsemble.weight` of the connected
`2 x 1` cut slab is reflection positive in mirror coordinates.

This is the connected-geometry consumer of
`WilsonCutPlaquetteEnsemble.reflectionPositive_of_hol_factorization`, fed by
the new holonomy factorization `slabPlaq_hol_slabMirrorConfig`. It is a
link-symmetry / Osterwalder-Schrader-ingredient statement, **not** yet a
transfer operator or a mass gap. -/
theorem wilsonSlabConnected_reflectionPositive
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    ReflectionPositivityKernel.IsReflectionPositive
      (A := G × G) (C := G × G × G)
      (fun a c b =>
        ((PlaquetteEnsemble.weight slabPlaqFamily
            (WilsonLocalWeight.wilsonLocalWeight beta rho)
            (slabMirrorConfig a c b) : ℝ) : ℂ)) :=
  reflectionPositive_of_hol_factorization
    slabPlaqFamily slabMirrorConfig slabEWord
    (fun k a c b => slabPlaq_hol_slabMirrorConfig k a c b)
    beta hbeta rho hmul hone hunit

/-- Mixed reflection positivity: a factorized positive/mirror-side contribution
times the connected slab's genuine Wilson weight is reflection positive. This
is the connected-geometry instance of the mixed product assembly, ready for the
positive-side observable insertions the OS reconstruction consumes. -/
theorem factorized_mul_wilsonSlabConnected_reflectionPositive
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (h : (G × G) → (G × G × G) → ℂ) :
    ReflectionPositivityKernel.IsReflectionPositive
      (A := G × G) (C := G × G × G)
      (fun a c b =>
        (h a c * (starRingEnd ℂ) (h b c)) *
          ((PlaquetteEnsemble.weight slabPlaqFamily
            (WilsonLocalWeight.wilsonLocalWeight beta rho)
            (slabMirrorConfig a c b) : ℝ) : ℂ)) :=
  factorized_mul_reflectionPositive_of_hol_factorization
    slabPlaqFamily slabMirrorConfig slabEWord
    (fun k a c b => slabPlaq_hol_slabMirrorConfig k a c b)
    beta hbeta rho hmul hone hunit h

end WilsonSlabConnected
end GateYM
end NullEdge
end Draft
end PhysicsSM
