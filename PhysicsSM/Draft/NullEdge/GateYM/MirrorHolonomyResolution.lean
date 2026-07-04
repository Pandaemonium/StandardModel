import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteReflection
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionDouble
import PhysicsSM.Draft.NullEdge.GateYM.WilsonLocalWeight
import PhysicsSM.Draft.NullEdge.GateYM.MirrorHolonomyConjugation

/-!
# Gate YM3 / N3 resolution: the genuine mirror-plaquette Wilson-weight identity

This module closes the general (INDEPENDENT-configuration) case flagged open
in `WilsonReflectionPositivity.lean`'s "What this does NOT prove" section and
refuted, for the OLD convention, by `MirrorHolonomyConjugation.lean` (node N3).

## What was wrong, and the fix (Route B)

The N3 negative result showed that with the previous inverse-free reflection
pullback `theta U e = U (reflectE e)`, the genuine mirror plaquette's holonomy
was the pure WORD REVERSAL of the original plaquette holonomy - which, for
nonabelian gauge groups, is NOT conjugate to the original or its inverse, so
the Wilson-weight identity `w(mirror) = w(original)` FAILED.

The correction, implemented in `ReflectionCore.reflectLinkField`, bakes the
group inverse into the reflection pullback:
`theta U e = (U (reflectE e))^{-1}` (Route B of the design note). With this,
`ReflectionWalk.hol_mirrorWalk_eq_inv` and
`PlaquetteReflection.hol_mirrorPlaquette_eq_inv` give the honest identity

  `(mirrorPlaquette R p).hol U = (p.hol (theta U))^{-1}`

in `G` itself - no `MulOpposite` bookkeeping. Since the Wilson weight of a
unitary representation is invariant under group inversion
(`WilsonWeightPositivity.reChar_inv_of_unitary`), this yields the
Wilson-weight identity for GENERAL configurations.

## Why the negative side enters inverted (honest scope note)

The genuine mirror plaquette's RAW holonomy at a doubled-lattice
configuration `U` is a fixed word in the negative-side link values
`U (false, -)`; no choice of reflection convention can turn that raw word
into the group inverse of `p0.hol b` for an ARBITRARY independent `b`
(the per-step endpoint types force it to be a word reversal, whose Wilson
weight is inversion-invariant but NOT conjugation-invariant - this is the
irreducible content of N3). The resolution is exactly the one recommended
in `MirrorHolonomyConjugation.lean`: the negative-side link field is
identified with `b` through the time-reflection INVERSE, i.e. the doubled
configuration carries `U (false, e) = (b e)^{-1}`. This is precisely the
pointwise inverse that `reflectLinkField` and
`ReflectionDouble.reflectLinkField_doubleReflection_eq` now make explicit.
With that identification the mirror-plaquette Wilson weight equals the
original plaquette Wilson weight at `b`, for every independent `a, b`.

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites:
`PlaquetteReflection`, `ReflectionDouble`, `WilsonLocalWeight`.

`liftStepPos`/`liftPlaquettePos`/`hol_liftPlaquettePos` are the canonical
home for the positive-copy lift construction; `WilsonReflectionPositivity.lean`
imports this module and reuses them rather than duplicating them.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace MirrorHolonomyResolution

open scoped Matrix
open GaugeCoreGeneral ReflectionCore PlaquetteCore PlaquetteReflection ReflectionDouble

variable {L0 : OrientedLattice} {G : Type} [Group G] {n : ℕ}

/-- Lift a step of the base lattice to the positive (`true`) copy of the
doubled lattice. -/
def liftStepPos : {x y : L0.V} → OrientedLattice.Step L0 x y →
    OrientedLattice.Step (doubleLattice L0) (true, x) (true, y)
  | _, _, OrientedLattice.Step.fwd e =>
      OrientedLattice.Step.castEndpoints (Λ := doubleLattice L0)
        (by simp [doubleLattice]) (by simp [doubleLattice])
        (OrientedLattice.Step.fwd (true, e))
  | _, _, OrientedLattice.Step.rev e =>
      OrientedLattice.Step.castEndpoints (Λ := doubleLattice L0)
        (by simp [doubleLattice]) (by simp [doubleLattice])
        (OrientedLattice.Step.rev (true, e))

/-- Lift a base-lattice plaquette to the positive copy of the doubled
lattice. -/
def liftPlaquettePos (p0 : Plaquette L0) : Plaquette (doubleLattice L0) where
  base := (true, p0.base)
  v1 := (true, p0.v1)
  v2 := (true, p0.v2)
  v3 := (true, p0.v3)
  step0 := liftStepPos p0.step0
  step1 := liftStepPos p0.step1
  step2 := liftStepPos p0.step2
  step3 := liftStepPos p0.step3

/-- Step-level holonomy compatibility for the positive lift. -/
theorem stepHol_liftStepPos {x y : L0.V} (s : OrientedLattice.Step L0 x y)
    (U : (doubleLattice L0).LinkField (G := G)) :
    OrientedLattice.stepHol U (liftStepPos s)
      = OrientedLattice.stepHol (doubleLinkFieldEquiv L0 U).1 s := by
  cases s with
  | fwd e =>
      simp only [liftStepPos, OrientedLattice.stepHol_castEndpoints]
      rfl
  | rev e =>
      simp only [liftStepPos, OrientedLattice.stepHol_castEndpoints]
      rfl

/-- The positive lift's holonomy equals the base plaquette's holonomy against
the positive-side restriction of `U`. -/
theorem hol_liftPlaquettePos (p0 : Plaquette L0)
    (U : (doubleLattice L0).LinkField (G := G)) :
    (liftPlaquettePos p0).hol U = p0.hol (doubleLinkFieldEquiv L0 U).1 := by
  unfold Plaquette.hol liftPlaquettePos Plaquette.walk
  simp only [OrientedLattice.hol, stepHol_liftStepPos]

/-- The doubled-lattice configuration with positive side `a` and negative side
the time-reflection inverse `b^{-1}`. This is the mirror-coordinate
configuration in which the negative-side field is identified with `b` through
the reflection inverse (the N3 fix). -/
def mirrorConfig (a b : L0.LinkField (G := G)) :
    (doubleLattice L0).LinkField (G := G) :=
  fun q => if q.1 then a q.2 else (b q.2)⁻¹

/-- **Genuine mirror-plaquette holonomy, general case.** For independent link
fields `a, b`, the holonomy of the genuine mirror plaquette (of the positive
lift of `p0`) at the mirror-coordinate configuration `mirrorConfig a b` is the
GROUP INVERSE of the original plaquette holonomy at `b`. No abelian/degeneracy
assumption, no `MulOpposite`. -/
theorem hol_mirrorPlaquette_mirrorConfig (p0 : Plaquette L0)
    (a b : L0.LinkField (G := G)) :
    (mirrorPlaquette (doubleReflection L0) (liftPlaquettePos p0)).hol
        (mirrorConfig a b)
      = (p0.hol b)⁻¹ := by
  rw [hol_mirrorPlaquette_eq_inv, hol_liftPlaquettePos]
  have hb : (doubleLinkFieldEquiv L0
      ((doubleReflection L0).reflectLinkField (mirrorConfig a b))).1 = b := by
    funext e
    rw [reflectLinkField_doubleReflection_eq]
    simp only [mirrorConfig, doubleLinkFieldEquiv, Equiv.coe_fn_mk,
      Bool.false_eq_true, if_false, inv_inv]
  rw [hb]

/-- **N3 resolution / criterion 2 (general independent-configuration case).**
For a unitary representation `rho` and INDEPENDENT link fields `a, b`, the
genuine mirror plaquette's Wilson weight (at the mirror-coordinate
configuration `mirrorConfig a b`) equals the original plaquette's Wilson
weight at `b`.

This is the precise statement flagged OPEN in
`WilsonReflectionPositivity.lean` and refuted for the previous convention by
`MirrorHolonomyConjugation.lean`. It now holds for every finite/arbitrary
group `G`, base lattice `L0`, plaquette `p0`, unitary representation `rho`,
and independent configurations `a, b` - the twist is resolved for the general
case, not just reflection-derived configurations. The positive-side field `a`
does not affect the negative-side mirror plaquette's weight and is included
only to display the full mirror-coordinate configuration. -/
theorem mirrorPlaquette_wilsonWeight_eq (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (p0 : Plaquette L0) (a b : L0.LinkField (G := G)) :
    WilsonLocalWeight.wilsonLocalWeight beta rho
        ((mirrorPlaquette (doubleReflection L0) (liftPlaquettePos p0)).hol
          (mirrorConfig a b))
      = WilsonLocalWeight.wilsonLocalWeight beta rho (p0.hol b) := by
  rw [hol_mirrorPlaquette_mirrorConfig,
    WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit]

end MirrorHolonomyResolution
end GateYM
end NullEdge
end Draft
end PhysicsSM
