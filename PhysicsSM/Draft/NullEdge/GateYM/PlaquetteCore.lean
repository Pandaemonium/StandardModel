import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.GaugeCoreGeneral

/-!
# Gate YM0/T3: abstract plaquette core

This draft module is the first D5/D7 layer on top of
`GaugeCoreGeneral`. A plaquette is represented as a typed closed 4-walk.
This deliberately avoids choosing a rectangular coordinate lattice yet:
the concrete C-2 square convention will instantiate the four typed steps.

What is proved here:
* a plaquette holonomy transforms by conjugation under gauge
  transformations;
* any class function of a plaquette holonomy is gauge invariant;
* finite sums and finite products of class functions over a plaquette family
  are gauge invariant.

This is the reusable finite identity behind Wilson-action invariance for a
list of plaquettes, but this module still does not define a reflection plane,
transfer matrix, cut factorization, or D12 sector.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity** (abstract plaquette/action invariance).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace PlaquetteCore

open GaugeCoreGeneral

variable {G : Type*} [Group G]
variable {Λ : OrientedLattice}

/-- A based plaquette is a closed typed 4-walk. The fields are intentionally
abstract steps, so a future rectangular lattice can instantiate them with the
forward/reverse edge choices dictated by convention C-2. -/
structure Plaquette (Λ : OrientedLattice) where
  base : Λ.V
  v1 : Λ.V
  v2 : Λ.V
  v3 : Λ.V
  step0 : OrientedLattice.Step Λ base v1
  step1 : OrientedLattice.Step Λ v1 v2
  step2 : OrientedLattice.Step Λ v2 v3
  step3 : OrientedLattice.Step Λ v3 base

namespace Plaquette

/-- The closed typed walk underlying a plaquette. -/
def walk (p : Plaquette Λ) : OrientedLattice.Walk Λ p.base p.base :=
  OrientedLattice.Walk.cons p.step0 <|
    OrientedLattice.Walk.cons p.step1 <|
      OrientedLattice.Walk.cons p.step2 <|
        OrientedLattice.Walk.cons p.step3 <|
          OrientedLattice.Walk.nil p.base

/-- Plaquette holonomy, inherited from the general typed-walk holonomy. -/
def hol (p : Plaquette Λ) (U : Λ.LinkField (G := G)) : G :=
  OrientedLattice.hol U p.walk

/-- Plaquette holonomy is conjugated by the gauge value at its basepoint. -/
theorem hol_gauge (p : Plaquette Λ)
    (g : Λ.V → G) (U : Λ.LinkField (G := G)) :
    p.hol (Λ.gauge g U) = g p.base * p.hol U * (g p.base)⁻¹ := by
  simpa [hol] using OrientedLattice.hol_gauge_closed g U p.walk

/-- A class function of plaquette holonomy is gauge invariant. -/
theorem classFunction_hol_gauge {α : Type*} (p : Plaquette Λ)
    (F : G → α)
    (hclass : ∀ a b : G, F (a * b * a⁻¹) = F b)
    (g : Λ.V → G) (U : Λ.LinkField (G := G)) :
    F (p.hol (Λ.gauge g U)) = F (p.hol U) := by
  simpa [hol] using
    OrientedLattice.classFunction_hol_gauge_closed F hclass g U p.walk

end Plaquette

/-- Additive plaquette action skeleton: sum a class function over a finite
plaquette family. For Wilson actions, the local summand will be
`beta * Re chi(hol p)`. -/
def actionSum {ι R : Type*} [Fintype ι] [AddCommMonoid R]
    (P : ι → Plaquette Λ) (localAction : G → R)
    (U : Λ.LinkField (G := G)) : R :=
  ∑ i, localAction ((P i).hol U)

/-- Gauge invariance of the additive plaquette-action skeleton. -/
theorem actionSum_gauge {ι R : Type*} [Fintype ι] [AddCommMonoid R]
    (P : ι → Plaquette Λ) (localAction : G → R)
    (hclass : ∀ a b : G, localAction (a * b * a⁻¹) = localAction b)
    (g : Λ.V → G) (U : Λ.LinkField (G := G)) :
    actionSum P localAction (Λ.gauge g U) = actionSum P localAction U := by
  unfold actionSum
  refine Finset.sum_congr rfl ?_
  intro i _hi
  exact Plaquette.classFunction_hol_gauge (P i) localAction hclass g U

/-- Multiplicative plaquette weight skeleton: product a class-function weight
over a finite plaquette family. This is the finite-group Wilson ensemble
surface needed before reflection/cut factorization is stated. -/
def productWeight {ι R : Type*} [Fintype ι] [CommMonoid R]
    (P : ι → Plaquette Λ) (localWeight : G → R)
    (U : Λ.LinkField (G := G)) : R :=
  ∏ i, localWeight ((P i).hol U)

/-- Gauge invariance of the multiplicative plaquette-weight skeleton. -/
theorem productWeight_gauge {ι R : Type*} [Fintype ι] [CommMonoid R]
    (P : ι → Plaquette Λ) (localWeight : G → R)
    (hclass : ∀ a b : G, localWeight (a * b * a⁻¹) = localWeight b)
    (g : Λ.V → G) (U : Λ.LinkField (G := G)) :
    productWeight P localWeight (Λ.gauge g U) = productWeight P localWeight U := by
  unfold productWeight
  refine Finset.prod_congr rfl ?_
  intro i _hi
  exact Plaquette.classFunction_hol_gauge (P i) localWeight hclass g U

end PlaquetteCore
end GateYM
end NullEdge
end Draft
end PhysicsSM
