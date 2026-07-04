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
It also includes the finite orbit-sum identity for gauge-transformed
observables.

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

/-- Sum an observable over the finite gauge orbit of a configuration. This is
the unnormalized gauge average; normalizing by the gauge-group cardinality is a
later convenience layer. -/
def gaugeOrbitSumObservable [Fintype (Λ.V → G)]
    (observable : Λ.LinkField (G := G) → ℝ)
    (U : Λ.LinkField (G := G)) : ℝ :=
  ∑ g : Λ.V → G, observable (Λ.gauge g U)

/-- Under a gauge-invariant finite weight, the numerator of the gauge-orbit
sum of an observable is the size of the finite gauge group times the original
numerator. -/
theorem numerator_gaugeOrbitSumObservable_of_weight_invariant
    [Fintype (Λ.LinkField (G := G))] [Fintype (Λ.V → G)]
    (weight : Λ.LinkField (G := G) → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ)
    (hweight : ∀ g U, weight (Λ.gauge g U) = weight U) :
    numerator Λ weight (gaugeOrbitSumObservable Λ observable)
      = (Fintype.card (Λ.V → G)) • numerator Λ weight observable := by
  have h_each : ∀ g : Λ.V → G,
      numerator Λ weight (fun U => observable (Λ.gauge g U))
        = numerator Λ weight observable := by
    intro g
    exact numerator_observable_comp_gauge_of_weight_invariant Λ g weight observable
      (hweight g)
  unfold numerator gaugeOrbitSumObservable
  calc
    (∑ U, (∑ g : Λ.V → G, observable (Λ.gauge g U)) * weight U)
        = ∑ U, ∑ g : Λ.V → G, observable (Λ.gauge g U) * weight U := by
          refine Finset.sum_congr rfl ?_
          intro U _hU
          rw [Finset.sum_mul]
    _ = ∑ g : Λ.V → G, ∑ U, observable (Λ.gauge g U) * weight U := by
          rw [Finset.sum_comm]
    _ = ∑ _g : Λ.V → G, numerator Λ weight observable := by
          refine Finset.sum_congr rfl ?_
          intro g _hg
          rw [← h_each g]
          rfl
    _ = (Fintype.card (Λ.V → G)) • numerator Λ weight observable := by
          rw [Finset.sum_const, Finset.card_univ]

/-- Average an observable over the finite gauge orbit of a configuration. -/
def gaugeOrbitAverageObservable [Fintype (Λ.V → G)]
    (observable : Λ.LinkField (G := G) → ℝ)
    (U : Λ.LinkField (G := G)) : ℝ :=
  ((Fintype.card (Λ.V → G) : ℝ)⁻¹) * gaugeOrbitSumObservable Λ observable U

/-- Under a gauge-invariant finite weight, replacing an observable by its
finite gauge-orbit average leaves the numerator unchanged. -/
theorem numerator_gaugeOrbitAverageObservable_of_weight_invariant
    [Fintype (Λ.LinkField (G := G))] [Fintype (Λ.V → G)]
    (weight : Λ.LinkField (G := G) → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ)
    (hweight : ∀ g U, weight (Λ.gauge g U) = weight U) :
    numerator Λ weight (gaugeOrbitAverageObservable Λ observable)
      = numerator Λ weight observable := by
  haveI : Nonempty (Λ.V → G) := ⟨fun _ => (1 : G)⟩
  have hcard_nat : Fintype.card (Λ.V → G) ≠ 0 := Fintype.card_ne_zero
  have hcard : (Fintype.card (Λ.V → G) : ℝ) ≠ 0 := by
    exact_mod_cast hcard_nat
  unfold gaugeOrbitAverageObservable
  calc
    numerator Λ weight
        (fun U => ((Fintype.card (Λ.V → G) : ℝ)⁻¹)
          * gaugeOrbitSumObservable Λ observable U)
        = ((Fintype.card (Λ.V → G) : ℝ)⁻¹)
          * numerator Λ weight (gaugeOrbitSumObservable Λ observable) := by
          unfold numerator
          rw [Finset.mul_sum]
          refine Finset.sum_congr rfl ?_
          intro U _hU
          ring
    _ = numerator Λ weight observable := by
          rw [numerator_gaugeOrbitSumObservable_of_weight_invariant
            Λ weight observable hweight]
          rw [nsmul_eq_mul]
          field_simp [hcard]

end LatticeEnsemble
end GateYM
end NullEdge
end Draft
end PhysicsSM
