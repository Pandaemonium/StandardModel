import PhysicsSM.Draft.NullEdge.GateYM.ExponentialClustering

/-!
# Gate YM4/Q8: observable support bookkeeping bridge

This module adds the thin observable-support interface recommended by the Q8
concrete-observable audit.  It is deliberately only bookkeeping:

* `LocalPlaquetteObservable` exposes the finite plaquette/polymer support of a
  local observable.
* `ObservableSupportBridge` records that this support is the same support used
  by the abstract `LocalObservableSupportData` clustering API.
* The lemmas below rewrite the support tail through that identity and pass
  existing conditional `ExponentialClustering` lemmas through it.

No metric-tail theorem, concrete Wilson-loop expansion, volume-uniform
Kotecky-Preiss estimate, or physical clustering theorem is claimed here.  All
decay input remains an explicit hypothesis.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ObservableSupport

open ExponentialClustering
open PolymerKPCriterion
open PolymerKPConclusion

variable {Gamma Obs : Type*} [Fintype Gamma]

/-- A local observable with finite plaquette/polymer support.

This is intentionally just data.  It does not prescribe Wilson-loop
coefficients, cluster-expansion weights, or a metric separation notion. -/
structure LocalPlaquetteObservable (Gamma Obs : Type*) where
  support : Obs -> Finset Gamma

/-- Bookkeeping bridge from concrete observable supports to the abstract
finite-support clustering API.

`support_eq` is the whole point: the abstract support appearing in
`LocalObservableSupportData` is exactly the plaquette/polymer support exposed by
the concrete observable layer. -/
structure ObservableSupportBridge (Gamma Obs : Type*) where
  supportData : LocalObservableSupportData Gamma Obs
  observable : LocalPlaquetteObservable Gamma Obs
  support_eq : forall A : Obs, supportData.support A = observable.support A

namespace ObservableSupportBridge

/-- The abstract support tail can be rewritten using the observable support. -/
theorem supportTail_eq
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (B : ObservableSupportBridge Gamma Obs)
    (A : Obs) (R : Real) :
    supportTail M hdec D (B.supportData.support A) R =
      supportTail M hdec D (B.observable.support A) R := by
  rw [B.support_eq A]

/-- Cardinal support-tail bound stated in terms of the observable support.

The bound is exactly `supportTail_le_card_mul_bound` after rewriting through
`support_eq`; it does not prove decay of the anchor tails. -/
theorem supportTail_le_card_mul_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (B : ObservableSupportBridge Gamma Obs)
    (A : Obs) (R C : Real)
    (hC : forall g0 : Gamma, g0 ∈ B.observable.support A ->
      tailContribution M hdec D g0 R <= C) :
    supportTail M hdec D (B.supportData.support A) R <=
      ((B.observable.support A).card : Real) * C := by
  rw [supportTail_eq M hdec D B A R]
  exact ExponentialClustering.supportTail_le_card_mul_bound M hdec D
    (B.observable.support A) R C hC

/-- Zero observable support forces zero connected correlator under the existing
explicit support-tail bridge hypothesis.

This is a naming/reindexing corollary of
`connectedCorr_eq_zero_of_support_empty`; it is not a concrete observable
expansion theorem. -/
theorem connectedCorr_eq_zero_of_observable_support_empty
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (B : ObservableSupportBridge Gamma Obs)
    {A C : Obs}
    (hSupport : B.observable.support A = ∅)
    (hBridge : forall A C : Obs,
      ‖B.supportData.connectedCorr A C‖ <=
        B.supportData.prefactor A C *
          supportTail M hdec D (B.observable.support A)
            (B.supportData.separation A C)) :
    B.supportData.connectedCorr A C = 0 := by
  exact ExponentialClustering.connectedCorr_eq_zero_of_support_empty
    M hdec D B.supportData
    (by rw [B.support_eq A, hSupport])
    (by
      intro A C
      simpa [B.support_eq A] using hBridge A C)

/-- Uniform-energy finite-support clustering stated with observable supports.

This is a pass-through wrapper around
`hasExponentialClusteringSupport_of_uniform_energy_bound`.  The anchored tail
estimate and observable-to-tail comparison remain explicit hypotheses. -/
theorem hasExponentialClusteringSupport_of_uniform_energy_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (B : ObservableSupportBridge Gamma Obs)
    (m E : Real)
    (hEnergy : forall (A : Obs) (g0 : Gamma),
      g0 ∈ B.observable.support A -> M.energy g0 <= E)
    (hTail : forall (g0 : Gamma) (R : Real), 0 <= R ->
      tailContribution M hdec D g0 R <=
        M.energy g0 * Real.exp (-(m * R)))
    (hBridge : forall A C : Obs,
      ‖B.supportData.connectedCorr A C‖ <=
        B.supportData.prefactor A C *
          supportTail M hdec D (B.observable.support A)
            (B.supportData.separation A C)) :
    HasExponentialClusteringSupport B.supportData
      (fun A C =>
        B.supportData.prefactor A C *
          ((B.observable.support A).card : Real) * E) m := by
  have hClust :
      HasExponentialClusteringSupport B.supportData
        (fun A C =>
          B.supportData.prefactor A C *
            ((B.supportData.support A).card : Real) * E) m := by
    exact ExponentialClustering.hasExponentialClusteringSupport_of_uniform_energy_bound
      M hdec D B.supportData m E
      (by
        intro A g0 hg0
        exact hEnergy A g0 (by simpa [B.support_eq A] using hg0))
      hTail
      (by
        intro A C
        simpa [B.support_eq A] using hBridge A C)
  intro A C
  simpa [B.support_eq A] using hClust A C

end ObservableSupportBridge

end ObservableSupport
end GateYM
end NullEdge
end Draft
end PhysicsSM
