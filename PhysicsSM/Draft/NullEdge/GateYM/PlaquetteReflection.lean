import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteCore
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionWalk

/-!
# Gate YM3: plaquette reflection holonomy

This draft module lifts the walk-level reflection identity from
`ReflectionWalk` to the abstract four-step plaquettes of `PlaquetteCore`.
The result is still an algebraic finite identity, not reflection positivity:
it does not prove Wilson action reflection covariance, cut factorization, or
the RP-LINK inequality.

Conventions:
* plaquette boundaries are the typed closed 4-walks from `PlaquetteCore`;
* link reflection uses the endpoint-reversing `ReflectionCore.Reflection`;
* the noncommutative order reversal is recorded in `MulOpposite G`, exactly as
  in `ReflectionWalk`.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity**.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace PlaquetteReflection

open GaugeCoreGeneral ReflectionCore PlaquetteCore

variable {Λ : OrientedLattice}
variable (R : ReflectionCore.Reflection Λ)

/-- Reflect a plaquette by reversing its boundary orientation and reflecting
all four steps. This is the plaquette-level packaging of
`ReflectionCore.Reflection.mirrorWalk`. -/
def mirrorPlaquette (p : Plaquette Λ) : Plaquette Λ where
  base := R.reflectV p.base
  v1 := R.reflectV p.v3
  v2 := R.reflectV p.v2
  v3 := R.reflectV p.v1
  step0 := R.reflectStep p.step3
  step1 := R.reflectStep p.step2
  step2 := R.reflectStep p.step1
  step3 := R.reflectStep p.step0

/-- The reflected plaquette walk is definitionally the reflected/reversed walk
from `ReflectionWalk`. -/
theorem mirrorPlaquette_walk (p : Plaquette Λ) :
    (mirrorPlaquette R p).walk = R.mirrorWalk p.walk := by
  rfl

variable {G : Type*} [Group G]

/-- Plaquette-level form of the reflected-walk holonomy identity.

The opposite group is load-bearing: for nonabelian gauge groups, reflecting a
boundary reverses multiplication order, so a same-group inverse statement would
be false in general. -/
theorem op_hol_reflectLinkField_mirrorPlaquette
    (p : Plaquette Λ) (U : Λ.LinkField (G := G)) :
    MulOpposite.op (p.hol (R.reflectLinkField U)) =
      (mirrorPlaquette R p).hol (ReflectionCore.Reflection.opLinkField U) := by
  change MulOpposite.op (OrientedLattice.hol (R.reflectLinkField U) p.walk) =
      OrientedLattice.hol (ReflectionCore.Reflection.opLinkField U)
        (mirrorPlaquette R p).walk
  rw [mirrorPlaquette_walk]
  exact R.op_hol_reflectLinkField_mirrorWalk U p.walk

end PlaquetteReflection
end GateYM
end NullEdge
end Draft
end PhysicsSM
