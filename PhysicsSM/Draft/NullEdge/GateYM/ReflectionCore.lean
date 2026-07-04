import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.GaugeCoreGeneral

/-!
# Gate YM3: abstract reflection/cut core (first design pass)

First implementation of the `design:reflection-cut-layer` proposal in
`AgentTasks/overnight-ym-run-2026-07-03/DISCUSSION.md`, resolving that
thread's three open questions as explicit judgment calls (documented
below, not silently assumed) rather than waiting further - per the
ambition-calibration protocol ("one idea round, then proceed with the
most defensible version"). This is a FIRST PASS: flag for cross-review
before anything here is cited in a claim-language document or an
Aristotle submission, since the reflection convention is exactly where
semantic risk concentrates (freeze section 6; the YM3 red-team's
demotion-test discussion).

## Design decisions made (resolving the three open questions)

1. **No on-plane vertices.** Every vertex is strictly on the positive or
   negative side (`posSide v` a `Prop`, with `posSide v <-> not posSide
   (reflectV v)` - i.e. reflection swaps the two sides with no fixed
   vertices). The "cut" is defined at the EDGE level: a link is a
   "positive-side link" if both endpoints are positive, and a "cut link"
   if its endpoints are on opposite sides. This matches freeze section
  6's phrasing ("a plane bisecting a LAYER of temporal links") and
  avoids a three-valued vertex predicate. The overnight `LIT_LOG.md`
  supplement independently confirmed this LINK-vs-SITE geometry from
  secondary sources; primary-source PDF extraction for Osterwalder-Seiler
  remains open.
2. **`A_+`** is modeled as a predicate on observables `F : LinkField G ->
   R`, `DependsOnPositiveSide F`, saying `F` agrees on any two link
   fields that agree on every positive-side link. This avoids
   restructuring `LinkField` into a dependent/subtype form.
3. **`theta` lifted to link fields** as the direct pullback `(theta U) e
   := U (reflectE e)`, with NO extra group-inverse twist. Justified
   post-hoc by `reflectLinkField_involutive` below (a genuine involution
   without needing one) - but this is a design CHOICE, not a derived
   necessity; a future presentation with a different `reflectE`
   convention might need the inverse variant instead. Flagged for
   cross-review, not asserted as final.

## What this file proves (first pass only)

`reflectE` interacting correctly with `posSide` (swaps sides, so
positive-side links map to negative-side links and cut links map to cut
links - checked in `reflectE_positiveLink` / `reflectE_cutLink`),
`reflectLinkField` as an involution on configuration space, and the
single-step compatibility lemmas
`stepHol_reflectLinkField_fwd` / `stepHol_reflectLinkField_rev`.
NO Wilson action, expectation, walk-level reflection map, or RP inequality
lives here yet - this is purely the combinatorial/type-theoretic
scaffolding `<(theta F)* F> >= 0` will eventually be stated over.

Draft-trust: kernel-checked, no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity / first-pass definitions**, cross-reviewed
only as scaffolding, not as RP-LINK. Prerequisites:
`GateYM.GaugeCoreGeneral`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ReflectionCore

open GaugeCoreGeneral

variable {Λ : OrientedLattice}

/-- An abstract reflection of an oriented lattice through a hyperplane: an
involution on vertices swapping "positive side" and "negative side" with
no fixed vertices, and a compatible involution on edges. `reflect_src`/
`reflect_tgt` say the reflected edge's endpoints are the REFLECTIONS of
the original edge's endpoints, with source and target SWAPPED (the
"reversal" a reflection through a transverse plane induces). -/
structure Reflection (Λ : OrientedLattice) where
  reflectV : Λ.V → Λ.V
  reflectE : Λ.E → Λ.E
  reflectV_involutive : Function.Involutive reflectV
  reflectE_involutive : Function.Involutive reflectE
  reflect_src : ∀ e : Λ.E, Λ.src (reflectE e) = reflectV (Λ.tgt e)
  reflect_tgt : ∀ e : Λ.E, Λ.tgt (reflectE e) = reflectV (Λ.src e)
  /-- The positive-side predicate on vertices. No on-plane vertices:
  every vertex is on exactly one side, and reflection swaps sides. -/
  posSide : Λ.V → Prop
  posSide_reflect : ∀ v : Λ.V, posSide v ↔ ¬ posSide (reflectV v)

namespace Reflection

variable (R : Reflection Λ)

/-- A link (edge) is a positive-side link if both its endpoints are on
the positive side. -/
def positiveLink (e : Λ.E) : Prop := R.posSide (Λ.src e) ∧ R.posSide (Λ.tgt e)

/-- A link is a negative-side link if both its endpoints are on the
negative side. -/
def negativeLink (e : Λ.E) : Prop := ¬ R.posSide (Λ.src e) ∧ ¬ R.posSide (Λ.tgt e)

/-- A link is a cut link if its endpoints are on opposite sides - the
freeze's "layer of temporal links" crossing the reflection plane. -/
def cutLink (e : Λ.E) : Prop := R.posSide (Λ.src e) ↔ ¬ R.posSide (Λ.tgt e)

/-- Reflection sends positive-side links to negative-side links. -/
theorem reflectE_positiveLink {e : Λ.E} (he : R.positiveLink e) :
    R.negativeLink (R.reflectE e) := by
  unfold negativeLink
  rw [R.reflect_src, R.reflect_tgt]
  exact ⟨(R.posSide_reflect _).mp he.2, (R.posSide_reflect _).mp he.1⟩

/-- Reflection sends negative-side links to positive-side links. -/
theorem reflectE_negativeLink {e : Λ.E} (he : R.negativeLink e) :
    R.positiveLink (R.reflectE e) := by
  unfold positiveLink
  rw [R.reflect_src, R.reflect_tgt]
  refine ⟨?_, ?_⟩
  · by_contra hcon
    exact he.2 ((R.posSide_reflect _).mpr hcon)
  · by_contra hcon
    exact he.1 ((R.posSide_reflect _).mpr hcon)

/-- Reflection sends cut links to cut links. -/
theorem reflectE_cutLink {e : Λ.E} (he : R.cutLink e) : R.cutLink (R.reflectE e) := by
  have hsrc := R.posSide_reflect (Λ.src e)
  have htgt := R.posSide_reflect (Λ.tgt e)
  unfold cutLink at he ⊢
  rw [R.reflect_src, R.reflect_tgt]
  tauto

variable {G : Type*}

/-- The pullback action of reflection on link fields (design decision 3
above: NO extra group inverse). -/
def reflectLinkField (U : Λ.LinkField (G := G)) : Λ.LinkField (G := G) :=
  fun e => U (R.reflectE e)

/-- The reflection action on link fields is an involution - `theta` is
its own inverse, as a reflection must be. -/
theorem reflectLinkField_involutive :
    Function.Involutive (R.reflectLinkField (G := G)) := by
  intro U
  funext e
  unfold reflectLinkField
  rw [R.reflectE_involutive e]

/-- An observable `F` depends only on the positive-side sublink field: it
agrees on any two link fields that agree on every positive-side link.
This is the freeze's `A_+`, "the algebra of functions of links strictly
on the positive side." -/
def DependsOnPositiveSide {Rt : Type*} (F : Λ.LinkField (G := G) → Rt) : Prop :=
  ∀ U V : Λ.LinkField (G := G), (∀ e, R.positiveLink e → U e = V e) → F U = F V

variable [Group G]

/-- Single-step compatibility (answers `review:reflection-core-first-pass`'s
requested check against the `Step.rev` convention, forward-traversal
case): the reflected link field's forward-step holonomy at `e` equals
the original link field's forward-step holonomy at the reflected edge
`reflectE e`. Immediate from the definitions - `reflectLinkField` was
built exactly so this holds without needing `reflect_src`/`reflect_tgt`
at the single-step level (those govern how the REFLECTED step's
endpoints relate to the original, not the holonomy value itself). -/
theorem stepHol_reflectLinkField_fwd (U : Λ.LinkField (G := G)) (e : Λ.E) :
    OrientedLattice.stepHol (R.reflectLinkField U) (OrientedLattice.Step.fwd e)
      = OrientedLattice.stepHol U (OrientedLattice.Step.fwd (R.reflectE e)) :=
  rfl

/-- Single-step compatibility, reverse-traversal case: the reflected link
field's reverse-step holonomy at `e` (which is `(U (reflectE e))⁻¹` by
the `Step.rev` convention) equals the original link field's reverse-step
holonomy at the reflected edge. Together with the `fwd` case above, this
is exactly the "one new compatibility theorem" `review:reflection-core-
first-pass` asked for at the single-step level; the WALK-level
generalization (relating `hol` of a full walk to `hol` of a suitably
reversed-and-reflected walk, which needs a `Walk` reversal/concatenation
operation not yet built in `GaugeCoreGeneral`) is a documented handoff,
not attempted here. -/
theorem stepHol_reflectLinkField_rev (U : Λ.LinkField (G := G)) (e : Λ.E) :
    OrientedLattice.stepHol (R.reflectLinkField U) (OrientedLattice.Step.rev e)
      = OrientedLattice.stepHol U (OrientedLattice.Step.rev (R.reflectE e)) :=
  rfl

end Reflection
end ReflectionCore
end GateYM
end NullEdge
end Draft
end PhysicsSM
