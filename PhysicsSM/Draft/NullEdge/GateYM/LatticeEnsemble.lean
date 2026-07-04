import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.GaugeCoreGeneral

/-!
# Gate YM0/T3: finite lattice ensemble skeleton

This draft module begins the shared finite probability layer requested by the
overnight YM `idea:rp-link-scope` discussion. It sits on top of
`GaugeCoreGeneral`: configurations are link fields on an oriented lattice, and
gauge transformations are the equivalences already proved there.

The module intentionally stays abstract:
* no Wilson action yet,
* no plaquette list yet,
* no reflection/cut structure yet,
* no transfer matrix or D12 sector yet.

It provides the finite sums that those later constructions will consume:
partition function, numerator, expectation, positivity for positive weights,
change of variables under a fixed gauge transformation, and the basic
consequence for gauge-invariant weights acting on transformed observables.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity** (finite-sum ensemble skeleton).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace LatticeEnsemble

open GaugeCoreGeneral

variable {G : Type*} [Group G]
variable (Λ : OrientedLattice)

/-- Partition function for an arbitrary finite weight on link configurations. -/
def partition [Fintype (Λ.LinkField (G := G))]
    (weight : Λ.LinkField (G := G) → ℝ) : ℝ :=
  ∑ U, weight U

/-- Weighted numerator for an observable. -/
def numerator [Fintype (Λ.LinkField (G := G))]
    (weight : Λ.LinkField (G := G) → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ) : ℝ :=
  ∑ U, observable U * weight U

/-- Finite-volume expectation value. This definition is deliberately total;
later physics-facing theorems carry the positivity/nonzero hypotheses needed to
interpret it probabilistically. -/
def expectation [Fintype (Λ.LinkField (G := G))]
    (weight : Λ.LinkField (G := G) → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ) : ℝ :=
  numerator Λ weight observable / partition Λ weight

/-- A strictly positive finite weight has strictly positive partition sum. -/
theorem partition_pos [Fintype (Λ.LinkField (G := G))]
    (weight : Λ.LinkField (G := G) → ℝ)
    (hweight : ∀ U, 0 < weight U) :
    0 < partition Λ weight := by
  unfold partition
  refine Finset.sum_pos (fun U _hU => hweight U) ?_
  exact ⟨fun _ => (1 : G), by simp⟩

/-- Change of variables for the partition sum under a fixed gauge
transformation. -/
theorem partition_comp_gauge [Fintype (Λ.LinkField (G := G))]
    (g : Λ.V → G) (weight : Λ.LinkField (G := G) → ℝ) :
    partition Λ (fun U => weight (Λ.gauge g U)) = partition Λ weight := by
  unfold partition
  exact OrientedLattice.sum_comp_gauge g weight

/-- Change of variables for the weighted numerator under a fixed gauge
transformation applied to both the observable and the weight. -/
theorem numerator_comp_gauge [Fintype (Λ.LinkField (G := G))]
    (g : Λ.V → G)
    (weight : Λ.LinkField (G := G) → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ) :
    numerator Λ (fun U => weight (Λ.gauge g U))
        (fun U => observable (Λ.gauge g U))
      = numerator Λ weight observable := by
  unfold numerator
  exact OrientedLattice.sum_comp_gauge g (fun U => observable U * weight U)

/-- Change of variables for finite-volume expectation under a fixed gauge
transformation applied to both the observable and the weight. -/
theorem expectation_comp_gauge [Fintype (Λ.LinkField (G := G))]
    (g : Λ.V → G)
    (weight : Λ.LinkField (G := G) → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ) :
    expectation Λ (fun U => weight (Λ.gauge g U))
        (fun U => observable (Λ.gauge g U))
      = expectation Λ weight observable := by
  unfold expectation
  rw [numerator_comp_gauge, partition_comp_gauge]

/-- If the weight is invariant under a fixed gauge transformation, then
applying that gauge transformation only to the observable does not change the
weighted numerator. -/
theorem numerator_observable_comp_gauge_of_weight_invariant
    [Fintype (Λ.LinkField (G := G))]
    (g : Λ.V → G)
    (weight : Λ.LinkField (G := G) → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ)
    (hweight : ∀ U, weight (Λ.gauge g U) = weight U) :
    numerator Λ weight (fun U => observable (Λ.gauge g U))
      = numerator Λ weight observable := by
  calc
    numerator Λ weight (fun U => observable (Λ.gauge g U))
        = numerator Λ (fun U => weight (Λ.gauge g U))
            (fun U => observable (Λ.gauge g U)) := by
          unfold numerator
          refine Finset.sum_congr rfl ?_
          intro U _hU
          rw [← hweight U]
    _ = numerator Λ weight observable := numerator_comp_gauge Λ g weight observable

/-- If the weight is invariant under a fixed gauge transformation, then
applying that gauge transformation only to the observable does not change the
finite-volume expectation. -/
theorem expectation_observable_comp_gauge_of_weight_invariant
    [Fintype (Λ.LinkField (G := G))]
    (g : Λ.V → G)
    (weight : Λ.LinkField (G := G) → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ)
    (hweight : ∀ U, weight (Λ.gauge g U) = weight U) :
    expectation Λ weight (fun U => observable (Λ.gauge g U))
      = expectation Λ weight observable := by
  unfold expectation
  rw [numerator_observable_comp_gauge_of_weight_invariant Λ g weight observable hweight]

end LatticeEnsemble
end GateYM
end NullEdge
end Draft
end PhysicsSM
