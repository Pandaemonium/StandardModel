import PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion

/-!
# Gate YM4/Q8: exponential clustering statement bridge

This module freezes the first Q8 observable-level bridge above the Q6
finite-polymer tail interface.  It is deliberately conditional: the hard Q6
metric tail estimate is passed in as an explicit hypothesis, and the local
observable-to-cluster-expansion comparison is passed in as an explicit
hypothesis.  The theorem proved here is only the clean final step:

`tail contribution bound + observable cluster bridge => exponential clustering`.

Draft-trust: statement bridge only.  No volume-uniform KP theorem, no concrete
plaquette geometry, and no transfer-Hilbert statement is claimed here.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ExponentialClustering

open scoped BigOperators
open PolymerKPCriterion
open PolymerKPConclusion

variable {Gamma Obs : Type*} [Fintype Gamma]

/-- Abstract data for a pairwise connected-correlator statement.

`anchor` chooses the polymer from which the cluster tail is measured,
`separation` is the observable-level distance, and `prefactor` absorbs the
local observable norms and finite support constants. -/
structure LocalObservableData (Gamma Obs : Type*) where
  anchor : Obs -> Gamma
  separation : Obs -> Obs -> Real
  separation_nonneg : forall A B, 0 <= separation A B
  connectedCorr : Obs -> Obs -> Complex
  prefactor : Obs -> Obs -> Real
  prefactor_nonneg : forall A B, 0 <= prefactor A B

/-- The Q6 metric-tail contribution that Q8 consumes. -/
def tailContribution
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (g0 : Gamma) (R : Real) : Real :=
  tsum (fun X : {X : Cluster M.toPolymerSystem //
      X.Connected M.toPolymerSystem hdec /\ X.ReachesFrom M g0 R} =>
    |D.coeff X.1| * X.1.absWeight M.toPolymerSystem)

/-- Exponential clustering for the abstract connected correlator. -/
def HasExponentialClustering
    (L : LocalObservableData Gamma Obs)
    (amplitude : Obs -> Obs -> Real) (m : Real) : Prop :=
  forall A B : Obs,
    ‖L.connectedCorr A B‖ <=
      amplitude A B * Real.exp (-(m * L.separation A B))

/-- Observable-level exponential clustering from an explicit Q6-style tail
bound and an observable-to-cluster bridge.

This is the named Q8 bridge lemma.  The hard work is isolated in `hTail`
(the Q6 metric tail estimate, eventually supplied by `kp_tail_bound`) and
`hBridge` (the expansion/locality comparison for the chosen loop observables).
-/
theorem hasExponentialClustering_of_tailContribution_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (L : LocalObservableData Gamma Obs)
    (m : Real)
    (hTail : forall (g0 : Gamma) (R : Real), 0 <= R ->
      tailContribution M hdec D g0 R <=
        M.energy g0 * Real.exp (-(m * R)))
    (hBridge : forall A B : Obs,
      ‖L.connectedCorr A B‖ <=
        L.prefactor A B *
          tailContribution M hdec D (L.anchor A) (L.separation A B)) :
    HasExponentialClustering L
      (fun A B => L.prefactor A B * M.energy (L.anchor A)) m := by
  intro A B
  have htail := hTail (L.anchor A) (L.separation A B)
    (L.separation_nonneg A B)
  calc
    ‖L.connectedCorr A B‖
        <= L.prefactor A B *
          tailContribution M hdec D (L.anchor A) (L.separation A B) :=
      hBridge A B
    _ <= L.prefactor A B *
        (M.energy (L.anchor A) * Real.exp (-(m * L.separation A B))) :=
      mul_le_mul_of_nonneg_left htail (L.prefactor_nonneg A B)
    _ = (L.prefactor A B * M.energy (L.anchor A)) *
        Real.exp (-(m * L.separation A B)) := by
      rw [mul_assoc]

/-!
## Finite-support generalization

The single-anchor `LocalObservableData` measures the cluster tail from one
polymer `anchor A`.  A local observable is more faithfully modeled by a finite
support set of polymers, with the cluster tail measured from every support
polymer.  The following support-set layer is the recommended API upgrade; the
single-anchor structure above is the special case `support A = {anchor A}`.

The support bridge below is proved with the same clean inequality chaining and
depends only on the explicit `hTail`/`hBridge` hypotheses, exactly like the
single-anchor bridge. -/

/-- Abstract data for a pairwise connected-correlator statement with finite
support sets.

`support` gives the finite set of polymers on which each observable lives,
`separation` is the observable-level distance, and `prefactor` absorbs the
local observable norms and finite support constants. -/
structure LocalObservableSupportData (Gamma Obs : Type*) where
  support : Obs -> Finset Gamma
  separation : Obs -> Obs -> Real
  separation_nonneg : forall A B, 0 <= separation A B
  connectedCorr : Obs -> Obs -> Complex
  prefactor : Obs -> Obs -> Real
  prefactor_nonneg : forall A B, 0 <= prefactor A B

/-- The support-set tail: the metric-tail contribution summed over every
support polymer of the source observable. -/
def supportTail
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (S : Finset Gamma) (R : Real) : Real :=
  Finset.sum S (fun g0 => tailContribution M hdec D g0 R)

/-- The support-set tail of an empty observable support is zero. -/
theorem supportTail_empty
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (R : Real) :
    supportTail M hdec D ∅ R = 0 := by
  simp [supportTail]

/-- The finite-support tail reduces to the single-anchor tail on singleton
supports. -/
theorem supportTail_singleton
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (g0 : Gamma) (R : Real) :
    supportTail M hdec D ({g0} : Finset Gamma) R =
      tailContribution M hdec D g0 R := by
  simp [supportTail]

/-- Exponential clustering for the support-indexed connected correlator. -/
def HasExponentialClusteringSupport
    (L : LocalObservableSupportData Gamma Obs)
    (amplitude : Obs -> Obs -> Real) (m : Real) : Prop :=
  forall A B : Obs,
    ‖L.connectedCorr A B‖ <=
      amplitude A B * Real.exp (-(m * L.separation A B))

/-- Support-set observable-level exponential clustering from the same explicit
Q6-style tail bound and an observable-to-cluster bridge summed over the source
support.

This is the recommended Q8 bridge lemma at finite-support granularity.  As
with the single-anchor version, the hard work is isolated in `hTail` (the Q6
metric tail estimate, eventually supplied by `kp_tail_bound`) and `hBridge`
(the expansion/locality comparison for the chosen loop observables).  The
resulting amplitude sums the KP energy over the source support. -/
theorem hasExponentialClusteringSupport_of_supportTail_bound
    (M : MetricPolymerSystem Gamma)
    (hdec : forall g h, Decidable (M.incompatible g h))
    (D : ClusterCoeffData M.toPolymerSystem hdec)
    (L : LocalObservableSupportData Gamma Obs)
    (m : Real)
    (hTail : forall (g0 : Gamma) (R : Real), 0 <= R ->
      tailContribution M hdec D g0 R <=
        M.energy g0 * Real.exp (-(m * R)))
    (hBridge : forall A B : Obs,
      ‖L.connectedCorr A B‖ <=
        L.prefactor A B *
          supportTail M hdec D (L.support A) (L.separation A B)) :
    HasExponentialClusteringSupport L
      (fun A B => L.prefactor A B *
        Finset.sum (L.support A) (fun g0 => M.energy g0)) m := by
  intro A B
  have hstep :
      supportTail M hdec D (L.support A) (L.separation A B)
        <= Finset.sum (L.support A) (fun g0 => M.energy g0) *
            Real.exp (-(m * L.separation A B)) := by
    unfold supportTail
    rw [Finset.sum_mul]
    apply Finset.sum_le_sum
    intro g0 _
    exact hTail g0 (L.separation A B) (L.separation_nonneg A B)
  calc
    ‖L.connectedCorr A B‖
        <= L.prefactor A B *
          supportTail M hdec D (L.support A) (L.separation A B) :=
      hBridge A B
    _ <= L.prefactor A B *
        (Finset.sum (L.support A) (fun g0 => M.energy g0) *
          Real.exp (-(m * L.separation A B))) :=
      mul_le_mul_of_nonneg_left hstep (L.prefactor_nonneg A B)
    _ = (L.prefactor A B *
          Finset.sum (L.support A) (fun g0 => M.energy g0)) *
        Real.exp (-(m * L.separation A B)) := by
      rw [mul_assoc]

end ExponentialClustering
end GateYM
end NullEdge
end Draft
end PhysicsSM
