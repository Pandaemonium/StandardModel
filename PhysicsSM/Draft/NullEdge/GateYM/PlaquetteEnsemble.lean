import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.LatticeEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteCore

/-!
# Gate YM0/T3: finite plaquette ensemble skeleton

This draft module combines `PlaquetteCore` and `LatticeEnsemble`. It
specializes the abstract finite ensemble sums to a product of local
class-function plaquette weights.

The local weight is still arbitrary: this module does not yet choose the
Wilson weight `exp(beta * Re chi)`, a concrete plaquette list, a reflection
plane, a cut structure, or a transfer matrix. The point is to bank the finite
bookkeeping that all of those later constructions reuse.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity** (finite plaquette-product ensemble).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace PlaquetteEnsemble

open GaugeCoreGeneral
open PlaquetteCore

variable {G : Type*} [Group G]
variable {Λ : OrientedLattice}
variable {ι : Type*} [Fintype ι]

/-- Product of local plaquette weights over a finite plaquette family. -/
def weight (P : ι → Plaquette Λ) (localWeight : G → ℝ)
    (U : Λ.LinkField (G := G)) : ℝ :=
  productWeight P localWeight U

/-- Partition function for a finite product plaquette weight. -/
def partition [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (localWeight : G → ℝ) : ℝ :=
  LatticeEnsemble.partition Λ (weight P localWeight)

/-- Weighted numerator for a finite product plaquette weight. -/
def numerator [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (localWeight : G → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ) : ℝ :=
  LatticeEnsemble.numerator Λ (weight P localWeight) observable

/-- Expectation for a finite product plaquette weight. -/
def expectation [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (localWeight : G → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ) : ℝ :=
  LatticeEnsemble.expectation Λ (weight P localWeight) observable

/-- Positive local plaquette weights give a positive product weight. -/
theorem weight_pos (P : ι → Plaquette Λ) (localWeight : G → ℝ)
    (hpos : ∀ h, 0 < localWeight h)
    (U : Λ.LinkField (G := G)) :
    0 < weight P localWeight U := by
  unfold weight productWeight
  exact Finset.prod_pos (fun i _hi => hpos ((P i).hol U))

/-- Positive local plaquette weights give a positive partition function. -/
theorem partition_pos [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (localWeight : G → ℝ)
    (hpos : ∀ h, 0 < localWeight h) :
    0 < partition P localWeight := by
  unfold partition
  exact LatticeEnsemble.partition_pos Λ (weight P localWeight)
    (weight_pos P localWeight hpos)

/-- Class-function local weights make the product plaquette weight gauge
invariant. -/
theorem weight_gauge (P : ι → Plaquette Λ) (localWeight : G → ℝ)
    (hclass : ∀ a b : G, localWeight (a * b * a⁻¹) = localWeight b)
    (g : Λ.V → G) (U : Λ.LinkField (G := G)) :
    weight P localWeight (Λ.gauge g U) = weight P localWeight U := by
  exact productWeight_gauge P localWeight hclass g U

/-- For a class-function local plaquette weight, applying a fixed gauge
transformation only to the observable leaves the weighted numerator
unchanged. -/
theorem numerator_observable_comp_gauge
    [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (localWeight : G → ℝ)
    (hclass : ∀ a b : G, localWeight (a * b * a⁻¹) = localWeight b)
    (g : Λ.V → G)
    (observable : Λ.LinkField (G := G) → ℝ) :
    numerator P localWeight (fun U => observable (Λ.gauge g U))
      = numerator P localWeight observable := by
  unfold numerator
  exact LatticeEnsemble.numerator_observable_comp_gauge_of_weight_invariant
    Λ g (weight P localWeight) observable
    (fun U => weight_gauge P localWeight hclass g U)

/-- For a class-function local plaquette weight, applying a fixed gauge
transformation only to the observable leaves the expectation unchanged. -/
theorem expectation_observable_comp_gauge
    [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (localWeight : G → ℝ)
    (hclass : ∀ a b : G, localWeight (a * b * a⁻¹) = localWeight b)
    (g : Λ.V → G)
    (observable : Λ.LinkField (G := G) → ℝ) :
    expectation P localWeight (fun U => observable (Λ.gauge g U))
      = expectation P localWeight observable := by
  unfold expectation
  exact LatticeEnsemble.expectation_observable_comp_gauge_of_weight_invariant
    Λ g (weight P localWeight) observable
    (fun U => weight_gauge P localWeight hclass g U)

end PlaquetteEnsemble
end GateYM
end NullEdge
end Draft
end PhysicsSM
