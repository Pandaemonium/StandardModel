import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCore

/-!
# Gate YM3: the doubled lattice - a general concrete `Reflection` instance

This module resolves a genuine construction question surfaced while
building the first concrete instance for Q1 (RP-LINK / `WilsonReflectionPositivity`):
`ReflectionCore.Reflection`'s axioms (`reflect_src`/`reflect_tgt`, the
endpoint SWAP convention forced by `reflectStep` mapping a `Step.fwd e` to
a `Step.fwd (reflectE e)`, never to a `Step.rev`) are satisfiable for an
edge NOT crossing the reflection plane only if that edge's mirror image on
the other side has REVERSED endpoint orientation relative to it. A naive
lattice with a single uniform edge-orientation convention on both sides of
the plane (for example reflecting `RectTreeGauge.rectLattice` through a
coordinate hyperplane, keeping the same "always increasing coordinate"
orientation on both sides) fails this check for every edge transverse to
the reflection direction: the induced target endpoints land on `succ i`
where `castSucc i` is needed (or vice versa), and these differ in general
(see `PREP_NOTES.md`/`DISCUSSION.md` `design:q1-reflection-orientation` for
the full derivation with the concrete `Fin` computation).

## The fix: reverse orientation on the mirror copy

Given ANY oriented lattice `L0` (a "half-space" lattice with NO reference
to reflection), `doubleLattice L0` glues two copies of `L0` - a `true`
("positive side") copy with `L0`'s own orientation, and a `false`
("negative side") copy with REVERSED orientation (source and target
swapped) - into one lattice with a canonical, always-valid `Reflection`
that simply flips the side bit. No cut links exist in this construction
(the two copies share no edges), so it directly instantiates the
FACTORIZED class of `ReflectionPositivityKernel` (queue item Q1's baseline
tier). A cut-link-bearing instance (Q1's strong/shocking tiers) is a
DIFFERENT, richer construction - gluing extra cross edges between the two
copies - left for follow-up work; this module is deliberately scoped to
the reusable doubling construction alone.

## What is proved

- `doubleLattice`: the glued lattice.
- `doubleReflection`: the canonical `Reflection (doubleLattice L0)`, with
  `posSide (side, v) := (side = true)` and no on-plane vertices (`Bool` has
  no fixed point under `not`).
- `doubleLinkFieldEquiv`: `LinkField (doubleLattice L0) (G := G) ~
  (L0.LinkField (G := G)) x (L0.LinkField (G := G))` (currying `Bool x E ->
  G`), the mirror-coordinate change of variables with NO cut factor - this
  is exactly the `A x A` (no `C`) shape `ReflectionPositivityKernel`'s
  factorized corollaries consume with `C := PUnit`.
- `reflectLinkField_doubleReflection_eq`: under `doubleLinkFieldEquiv`,
  `reflectLinkField` swaps the two factors - the precise sense in which the
  negative-side coordinate IS the mirror image, matching RP-KER's
  mirror-coordinate convention.

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites: `ReflectionCore`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ReflectionDouble

open GaugeCoreGeneral ReflectionCore

variable (L0 : OrientedLattice)

/-- The doubled lattice: two copies of `L0`, glued with the negative
(`false`) copy carrying REVERSED orientation. No cut links: the two
copies share no edges. -/
def doubleLattice : OrientedLattice where
  V := Bool × L0.V
  E := Bool × L0.E
  src := fun p => (p.1, if p.1 then L0.src p.2 else L0.tgt p.2)
  tgt := fun p => (p.1, if p.1 then L0.tgt p.2 else L0.src p.2)

/-- The canonical reflection on the doubled lattice: flip the side bit,
leave the underlying `L0` vertex/edge label untouched. -/
def doubleReflection : Reflection (doubleLattice L0) where
  reflectV p := (!p.1, p.2)
  reflectE p := (!p.1, p.2)
  reflectV_involutive := by
    intro p
    simp
  reflectE_involutive := by
    intro p
    simp
  reflect_src := by
    intro e
    cases e with
    | mk side e =>
        cases side <;> simp [doubleLattice]
  reflect_tgt := by
    intro e
    cases e with
    | mk side e =>
        cases side <;> simp [doubleLattice]
  posSide p := p.1 = true
  posSide_reflect := by
    intro p
    cases p with
    | mk side v =>
        cases side <;> simp

variable {G : Type} [Group G]

/-- Mirror-coordinate change of variables: a link field on the doubled
lattice is exactly a pair of link fields on `L0` (positive-side factor,
negative-side factor), via currying `Bool x E -> G`. -/
def doubleLinkFieldEquiv :
    (doubleLattice L0).LinkField (G := G) ≃
      L0.LinkField (G := G) × L0.LinkField (G := G) where
  toFun U := (fun e => U (true, e), fun e => U (false, e))
  invFun p := fun q => if q.1 then p.1 q.2 else p.2 q.2
  left_inv := by
    intro U
    funext q
    cases q with
    | mk side e => cases side <;> rfl
  right_inv := by
    intro p
    rfl

omit [Group G] in
/-- Under `doubleLinkFieldEquiv`, reflection swaps the two factors: the
negative-side coordinate of the reflected field is the ORIGINAL positive-side
factor, and vice versa. This is the precise "negative side by mirror image"
convention `ReflectionPositivityKernel.reflectionForm` requires. -/
theorem reflectLinkField_doubleReflection_eq (U : (doubleLattice L0).LinkField (G := G)) :
    doubleLinkFieldEquiv L0 ((doubleReflection L0).reflectLinkField U)
      = ((doubleLinkFieldEquiv L0 U).2, (doubleLinkFieldEquiv L0 U).1) := by
  rfl

end ReflectionDouble
end GateYM
end NullEdge
end Draft
end PhysicsSM
