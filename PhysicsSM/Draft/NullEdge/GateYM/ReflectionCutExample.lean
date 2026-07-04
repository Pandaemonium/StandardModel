import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCore

/-!
# Gate YM3: minimal two-layer link-reflection example

This draft module is a concrete sanity check for
`PhysicsSM.Draft.NullEdge.GateYM.ReflectionCore`. It models the link-reflection
geometry recorded in the overnight run's literature supplement: the reflection
plane sits between two vertex layers and cuts temporal links in half.

The lattice here is intentionally minimal. Vertices are `(side, spatial label)`
with `side = false` on the negative side and `side = true` on the positive
side; every edge is a cut edge from the negative layer to the positive layer.
Reflection flips the side coordinate and leaves the cut-link label fixed.

What this proves:
* the abstract `Reflection` structure is inhabited by a genuine no-on-plane
  link-reflection geometry;
* every edge in this minimal model is a cut link;
* no edge lies strictly on the positive or negative side.

It does not prove Wilson action covariance, cut-kernel factorization, or
reflection positivity.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity / sanity-check model**.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ReflectionCutExample

open GaugeCoreGeneral ReflectionCore

/-- A minimal two-layer lattice whose links all cross the reflection plane. -/
def twoLayerCutLattice (S : Type*) : OrientedLattice where
  V := Bool × S
  E := S
  src s := (false, s)
  tgt s := (true, s)

/-- Link reflection on the two-layer cut lattice: flip the side coordinate and
leave the cut-link label fixed. -/
def twoLayerCutReflection (S : Type*) : Reflection (twoLayerCutLattice S) where
  reflectV v := (!v.1, v.2)
  reflectE s := s
  reflectV_involutive := by
    intro v
    rcases v with ⟨b, s⟩
    cases b <;> rfl
  reflectE_involutive := by
    intro s
    rfl
  reflect_src := by
    intro s
    rfl
  reflect_tgt := by
    intro s
    rfl
  posSide v := v.1 = true
  posSide_reflect := by
    intro v
    rcases v with ⟨b, s⟩
    cases b <;> simp

/-- Every link in the two-layer cut lattice crosses the reflection plane. -/
theorem twoLayerCutReflection_cutLink (S : Type*) (s : S) :
    (twoLayerCutReflection S).cutLink s := by
  simp [Reflection.cutLink, twoLayerCutReflection, twoLayerCutLattice]

/-- No link in the two-layer cut lattice lies strictly on the positive side. -/
theorem twoLayerCutReflection_not_positiveLink (S : Type*) (s : S) :
    ¬ (twoLayerCutReflection S).positiveLink s := by
  simp [Reflection.positiveLink, twoLayerCutReflection, twoLayerCutLattice]

/-- No link in the two-layer cut lattice lies strictly on the negative side. -/
theorem twoLayerCutReflection_not_negativeLink (S : Type*) (s : S) :
    ¬ (twoLayerCutReflection S).negativeLink s := by
  simp [Reflection.negativeLink, twoLayerCutReflection, twoLayerCutLattice]

end ReflectionCutExample
end GateYM
end NullEdge
end Draft
end PhysicsSM
