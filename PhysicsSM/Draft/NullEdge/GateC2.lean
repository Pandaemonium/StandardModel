import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexIntegrality
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexEndIntegrality
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignExistence
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignHermitian
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexEigenspace
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexMatrixSignature
import PhysicsSM.Draft.NullEdge.GateC2.GaugeOverlapInterface
import PhysicsSM.Draft.NullEdge.GateC2.GaugeIndexInertiaForm
import PhysicsSM.Draft.NullEdge.GateC2.FlagshipOperatorIndex
import PhysicsSM.Draft.NullEdge.GateC2.FlagshipOperatorIndexZero
import PhysicsSM.Draft.NullEdge.GateC2.TetraFreeIndexZero
import PhysicsSM.Draft.NullEdge.GateC2.TetraFreeIndexDensity
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexWindingWitness
import PhysicsSM.Draft.NullEdge.GateC2.OverlapWindingSignJoin
import PhysicsSM.Draft.NullEdge.GateC2.OverlapHoppingSignWitness
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexGaugeInvariance
import PhysicsSM.Draft.NullEdge.GateC2.FluxOverlapIndex

/-!
# Gate C2 aggregator: the index / gauge / certified-sign layer

This is a pure import aggregator for the Gate C2 draft tree (the lattice chiral
index, its integrality, the functional-calculus-free certified overlap sign, the
gauge-overlap interface, the index-equals-signature controlling fact, the free /
density benchmarks, the explicit witnesses, and the concrete nonzero-flux
example).  It lets the whole C2 layer be kernel-checked in one command:

    lake build PhysicsSM.Draft.NullEdge.GateC2

It is deliberately NOT added to the default `PhysicsSM` build target (which is the
trusted core and does not include the NullEdge gate tree); this module only
provides a single targeted root for verifying the C2 layer together.  Adding a
new C2 module?  Add its import here so the aggregate check stays complete.

Layer map (see `Sources/Null_Edge_Gate_C2_Index_And_Certified_Sign.md`):
* index + integrality: `OverlapIndexIntegrality`, `OverlapIndexEndIntegrality`;
* certified sign: `OverlapSignCertificate` (unique), `OverlapSignExistence`
  (exists), `OverlapSignHermitian` (self-adjoint forced);
* index = signature: `OverlapIndexEigenspace`, `OverlapIndexMatrixSignature`;
* gauge interface: `GaugeOverlapInterface`, `GaugeIndexInertiaForm`;
* free / density benchmarks: `FlagshipOperatorIndex`, `FlagshipOperatorIndexZero`,
  `TetraFreeIndexZero`, `TetraFreeIndexDensity`;
* witnesses: `OverlapIndexWindingWitness`, `OverlapWindingSignJoin`,
  `OverlapHoppingSignWitness`, `OverlapIndexGaugeInvariance`;
* concrete nonzero flux: `FluxOverlapIndex` (the pi-flux triangle).

All modules are draft-trust: kernel-checked, no `s o r r y`, no
`n a t i v e _ d e c i d e`; axiom footprint `[propext, Classical.choice,
Quot.sound]`.
-/
