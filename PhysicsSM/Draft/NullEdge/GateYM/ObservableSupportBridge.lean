import PhysicsSM.Draft.NullEdge.GateYM.ExponentialClustering

/-!
# Gate YM4/Q8: observable support bookkeeping bridge

This module adds the thin observable-support interface recommended by the Q8
concrete-observable audit.  It is deliberately only bookkeeping:

* `LocalPlaquetteObservable` exposes the finite plaquette/polymer support of a
  local observable.
* `AnchoredLocalPlaquetteObservable` optionally adds a distinguished support
  anchor for later concrete observable expansions.
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

/-- A local observable with finite plaquette/polymer support and a chosen
support anchor.

This is still only data.  The anchor is useful for later concrete observable
expansions that first prove estimates anchor-by-anchor.  No decay or expansion
coefficient is encoded here. -/
structure AnchoredLocalPlaquetteObservable (Gamma Obs : Type*) where
  support : Obs -> Finset Gamma
  anchor : Obs -> Gamma
  anchor_mem : forall A : Obs, anchor A ∈ support A

namespace AnchoredLocalPlaquetteObservable

/-- Forget the optional support anchor and retain only finite support data. -/
def toLocalPlaquetteObservable
    (O : AnchoredLocalPlaquetteObservable Gamma Obs) :
    LocalPlaquetteObservable Gamma Obs where
  support := O.support

end AnchoredLocalPlaquetteObservable

/-- Bookkeeping bridge from concrete observable supports to the abstract
finite-support clustering API.

`support_eq` is the whole point: the abstract support appearing in
`LocalObservableSupportData` is exactly the plaquette/polymer support exposed by
the concrete observable layer. -/
structure ObservableSupportBridge (Gamma Obs : Type*) where
  supportData : LocalObservableSupportData Gamma Obs
  observable : LocalPlaquetteObservable Gamma Obs
  support_eq : forall A : Obs, supportData.support A = observable.support A

/-- Bookkeeping bridge for local observables that also carry a distinguished
support anchor.

This is the anchored variant of `ObservableSupportBridge`; it remains a pure
support-identification layer and does not assert any concrete observable
expansion or decay estimate. -/
structure AnchoredObservableSupportBridge (Gamma Obs : Type*) where
  supportData : LocalObservableSupportData Gamma Obs
  observable : AnchoredLocalPlaquetteObservable Gamma Obs
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

/-- Zero observable support-tail forces zero connected correlator under the
existing explicit support-tail bridge hypothesis.

This is a naming/reindexing corollary of
`connectedCorr_eq_zero_of_supportTail_eq_zero`; it does not supply a decay
estimate or a concrete observable expansion. -/
theorem connectedCorr_eq_zero_of_observable_supportTail_eq_zero
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (B : ObservableSupportBridge Gamma Obs)
    {A C : Obs}
    (hTailZero :
      supportTail M hdec D (B.observable.support A)
        (B.supportData.separation A C) = 0)
    (hBridge : forall A C : Obs,
      ‖B.supportData.connectedCorr A C‖ <=
        B.supportData.prefactor A C *
          supportTail M hdec D (B.observable.support A)
            (B.supportData.separation A C)) :
    B.supportData.connectedCorr A C = 0 := by
  exact ExponentialClustering.connectedCorr_eq_zero_of_supportTail_eq_zero
    M hdec D B.supportData
    (by simpa [B.support_eq A] using hTailZero)
    (by
      intro A C
      simpa [B.support_eq A] using hBridge A C)

/-- Pointwise zero anchored tails over the observable support force zero
connected correlator under the existing support-tail bridge hypothesis.

This keeps the pointwise tail-vanishing input explicit and only rewrites the
support through `ObservableSupportBridge.support_eq`. -/
theorem connectedCorr_eq_zero_of_forall_observable_tailContribution_eq_zero
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (B : ObservableSupportBridge Gamma Obs)
    {A C : Obs}
    (hTailZero : forall g0 : Gamma, g0 ∈ B.observable.support A ->
      tailContribution M hdec D g0 (B.supportData.separation A C) = 0)
    (hBridge : forall A C : Obs,
      ‖B.supportData.connectedCorr A C‖ <=
        B.supportData.prefactor A C *
          supportTail M hdec D (B.observable.support A)
            (B.supportData.separation A C)) :
    B.supportData.connectedCorr A C = 0 := by
  exact
    ExponentialClustering.connectedCorr_eq_zero_of_forall_tailContribution_eq_zero
      M hdec D B.supportData
      (by
        intro g0 hg0
        exact hTailZero g0 (by simpa [B.support_eq A] using hg0))
      (by
        intro A C
        simpa [B.support_eq A] using hBridge A C)

/-- Uniform anchored-tail finite-support clustering stated with observable
supports.

This is a pass-through wrapper around
`hasExponentialClusteringSupport_of_uniform_anchor_tail_bound`; the anchored
tail estimate and observable-to-tail comparison remain explicit hypotheses. -/
theorem hasExponentialClusteringSupport_of_uniform_anchor_tail_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (B : ObservableSupportBridge Gamma Obs)
    (m K : Real)
    (hTail : forall A C : Obs, forall g0 : Gamma,
      g0 ∈ B.observable.support A ->
        tailContribution M hdec D g0 (B.supportData.separation A C) <=
          K * Real.exp (-(m * B.supportData.separation A C)))
    (hBridge : forall A C : Obs,
      ‖B.supportData.connectedCorr A C‖ <=
        B.supportData.prefactor A C *
          supportTail M hdec D (B.observable.support A)
            (B.supportData.separation A C)) :
    HasExponentialClusteringSupport B.supportData
      (fun A C =>
        B.supportData.prefactor A C *
          ((B.observable.support A).card : Real) * K) m := by
  have hClust :
      HasExponentialClusteringSupport B.supportData
        (fun A C =>
          B.supportData.prefactor A C *
            ((B.supportData.support A).card : Real) * K) m := by
    exact
      ExponentialClustering.hasExponentialClusteringSupport_of_uniform_anchor_tail_bound
        M hdec D B.supportData m K
        (by
          intro A C g0 hg0
          exact hTail A C g0 (by simpa [B.support_eq A] using hg0))
        (by
          intro A C
          simpa [B.support_eq A] using hBridge A C)
  intro A C
  simpa [B.support_eq A] using hClust A C

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

namespace AnchoredObservableSupportBridge

/-- Forget the optional observable anchor and retain only the support bridge. -/
def toObservableSupportBridge
    (B : AnchoredObservableSupportBridge Gamma Obs) :
    ObservableSupportBridge Gamma Obs where
  supportData := B.supportData
  observable :=
    AnchoredLocalPlaquetteObservable.toLocalPlaquetteObservable B.observable
  support_eq := B.support_eq

omit [Fintype Gamma] in
/-- The chosen observable anchor lies in the concrete observable support. -/
theorem anchor_mem_observable_support
    (B : AnchoredObservableSupportBridge Gamma Obs) (A : Obs) :
    B.observable.anchor A ∈ B.observable.support A :=
  B.observable.anchor_mem A

omit [Fintype Gamma] in
/-- The chosen observable anchor lies in the abstract support after rewriting
through the support bridge. -/
theorem anchor_mem_supportData
    (B : AnchoredObservableSupportBridge Gamma Obs) (A : Obs) :
    B.observable.anchor A ∈ B.supportData.support A := by
  rw [B.support_eq A]
  exact B.observable.anchor_mem A

/-- The anchored tail contribution is bounded by the observable support tail.

This is only the monotonicity of `supportTail` applied to the singleton
containing the chosen anchor. -/
theorem tailContribution_anchor_le_observable_supportTail
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (B : AnchoredObservableSupportBridge Gamma Obs)
    (A : Obs) (R : Real) :
    tailContribution M hdec D (B.observable.anchor A) R <=
      supportTail M hdec D (B.observable.support A) R := by
  have hsubset :
      ({B.observable.anchor A} : Finset Gamma) ⊆ B.observable.support A := by
    intro g hg
    rw [Finset.mem_singleton] at hg
    rw [hg]
    exact B.observable.anchor_mem A
  have hmono := ExponentialClustering.supportTail_mono M hdec D R hsubset
  simpa [ExponentialClustering.supportTail_singleton] using hmono

/-- The anchored tail contribution is bounded by the abstract support tail.

This is the same support-tail monotonicity statement after applying
`support_eq`. -/
theorem tailContribution_anchor_le_supportDataTail
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (B : AnchoredObservableSupportBridge Gamma Obs)
    (A : Obs) (R : Real) :
    tailContribution M hdec D (B.observable.anchor A) R <=
      supportTail M hdec D (B.supportData.support A) R := by
  simpa [B.support_eq A] using
    tailContribution_anchor_le_observable_supportTail M hdec D B A R

/-- If the observable support tail vanishes, the chosen anchor contributes
zero.  This is a support-bookkeeping edge case, not a decay theorem. -/
theorem tailContribution_anchor_eq_zero_of_observable_supportTail_eq_zero
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (B : AnchoredObservableSupportBridge Gamma Obs)
    {A : Obs} {R : Real}
    (hTailZero :
      supportTail M hdec D (B.observable.support A) R = 0) :
    tailContribution M hdec D (B.observable.anchor A) R = 0 :=
  ExponentialClustering.tailContribution_eq_zero_of_mem_of_supportTail_eq_zero
    M hdec D hTailZero (B.observable.anchor_mem A)

/-- If the abstract support tail vanishes, the chosen observable anchor
contributes zero. -/
theorem tailContribution_anchor_eq_zero_of_supportDataTail_eq_zero
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (B : AnchoredObservableSupportBridge Gamma Obs)
    {A : Obs} {R : Real}
    (hTailZero :
      supportTail M hdec D (B.supportData.support A) R = 0) :
    tailContribution M hdec D (B.observable.anchor A) R = 0 :=
  ExponentialClustering.tailContribution_eq_zero_of_mem_of_supportTail_eq_zero
    M hdec D hTailZero (anchor_mem_supportData B A)

end AnchoredObservableSupportBridge

end ObservableSupport
end GateYM
end NullEdge
end Draft
end PhysicsSM
