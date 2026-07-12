import PhysicsSM.Draft.NullEdge.LiveWeylJacobian
import PhysicsSM.Draft.NullEdge.MasslessChargeCensusComposition

/-!
# Live massless Weyl derivative and finite census bridge

This module identifies the matrix used in the exact sixteen-node arithmetic
census with the complete Frechet derivative of the Pauli vector extracted from
the live ordered positive-Weyl step.  It therefore upgrades the two finite
charge sums from supplied-matrix arithmetic to statements about the actual
live derivative at the designated nodes.

This bridge does not prove that the two node lists exhaust the positive-Weyl
crossings on the momentum torus.  Branch-resolved crossing completeness is the
next theorem gate.

Provenance: internal composition of `LiveWeylJacobian` and
`MasslessChargeCensusComposition`, 2026-07-11.
-/

namespace PhysicsSM.Draft.NullEdge.LiveMasslessWeylCensusBridge

open scoped BigOperators
open SU2LocalCrossingCharge
open LiveWeylJacobian
open MasslessWeylChargeCensus
open MasslessChargeCensusComposition

/-- The census matrix is exactly the matrix of the live Frechet derivative. -/
theorem weylJacobian_eq_Jm (q : LiveWeylJacobian.V3) :
    LiveWeylJacobian.weylJacobian q =
      MasslessWeylChargeCensus.Jm (q 0) (q 1) (q 2) := by
  rfl

/-- Every zero-sector census matrix is the live Weyl Jacobian at its node. -/
theorem zeroJ_eq_live_weylJacobian (n : ZeroNode) :
    zeroJ n = LiveWeylJacobian.weylJacobian (zeroCoords n) := by
  rfl

/-- Every pi-sector census matrix is the live Weyl Jacobian at its node. -/
theorem piJ_eq_live_weylJacobian (n : PiNode) :
    piJ n = LiveWeylJacobian.weylJacobian (piCoords n) := by
  rfl

/-- The displayed derivative is genuine at every designated zero-sector node. -/
theorem zeroNode_has_live_fderiv (n : ZeroNode) :
    HasFDerivAt LiveWeylJacobian.weylVector
      (LiveWeylJacobian.weylJacobianCLM (zeroCoords n)) (zeroCoords n) :=
  LiveWeylJacobian.hasFDerivAt_weylVector _

/-- The displayed derivative is genuine at every designated pi-sector node. -/
theorem piNode_has_live_fderiv (n : PiNode) :
    HasFDerivAt LiveWeylJacobian.weylVector
      (LiveWeylJacobian.weylJacobianCLM (piCoords n)) (piCoords n) :=
  LiveWeylJacobian.hasFDerivAt_weylVector _

/-- The actual live-Jacobian charges cancel on the designated zero-sector list. -/
theorem live_zero_charge_sum :
    (∑ n : ZeroNode,
      localCrossingCharge (LiveWeylJacobian.weylJacobian (zeroCoords n))) = 0 := by
  simpa [zeroCharge, zeroJ_eq_live_weylJacobian] using zeroCharge_sum

/-- The actual live-Jacobian charges cancel on the designated pi-sector list. -/
theorem live_pi_charge_sum :
    (∑ n : PiNode,
      localCrossingCharge (LiveWeylJacobian.weylJacobian (piCoords n))) = 0 := by
  simpa [piCharge, piJ_eq_live_weylJacobian] using piCharge_sum

/-- Every designated live zero-sector crossing has a distinct nondegenerate
partner inside the exact finite census. -/
theorem live_zeroNode_has_partner (n : ZeroNode) :
    ∃ m ∈ (Finset.univ : Finset ZeroNode), m ≠ n ∧
      (LiveWeylJacobian.weylJacobian (zeroCoords m)).det ≠ 0 := by
  simpa [zeroJ_eq_live_weylJacobian] using zeroNode_has_partner n

/-- Every designated live pi-sector crossing has a distinct nondegenerate
partner inside the exact finite census. -/
theorem live_piNode_has_partner (n : PiNode) :
    ∃ m ∈ (Finset.univ : Finset PiNode), m ≠ n ∧
      (LiveWeylJacobian.weylJacobian (piCoords m)).det ≠ 0 := by
  simpa [piJ_eq_live_weylJacobian] using piNode_has_partner n

end PhysicsSM.Draft.NullEdge.LiveMasslessWeylCensusBridge
