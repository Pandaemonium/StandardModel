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

end ExponentialClustering
end GateYM
end NullEdge
end Draft
end PhysicsSM
