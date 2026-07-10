# codex-suite-cd-master-1220-20260709

aristotle:
  project_id: 1c184e23-66aa-4051-bfd1-e54e4482a0e1
  target_file: PhysicsSM/Draft/NullEdge/SuiteCDMasterCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.SuiteCDMasterCapstone
  submission_project: AgentTasks/aristotle-submit/codex-ambitious-wave-1220-20260709-project
  output_dir: AgentTasks/aristotle-output/1c184e23-66aa-4051-bfd1-e54e4482a0e1
  status: harvested and landed 2026-07-09

You are Aristotle. Build a proof-focused Suite C / Suite D master packet, not an
audit report.

Target file:

```text
PhysicsSM/Draft/NullEdge/SuiteCDMasterCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.KMC3FlagshipCapstone
import PhysicsSM.Draft.NullEdge.IndexProtectionBridge
import PhysicsSM.Draft.NullEdge.SuiteDChargeNonvacuity
import PhysicsSM.Draft.NullEdge.WEPActionResourceBridge
import PhysicsSM.Draft.NullEdge.MassResourceModularAudit
import PhysicsSM.Draft.NullEdge.InformationResourceBridge
import PhysicsSM.Draft.NullEdge.GoalIVReconciliationCapstone
```

Mission: Suite C says positive-code particle structure is supported by finite
KM/CP/family-rank/anomaly packets. Suite D says mass-resource/gravity structure
is supported by charge/resource nonvacuity, WEP action/resource, modular-resource
consistency, information-resource, and finite Goal IV reconciliation packets.
Bundle both suites into one theorem surface with the explicit controls and
nonzero witnesses retained.

Preferred namespace/theorems:

```lean
namespace SuiteCDMasterCapstone

theorem suiteC_positive_code_packet
    (K : Type*) [Field K] (N w : Nat) (hN : 1 <= N) : ...
theorem suiteD_mass_resource_packet
    {n : Nat} {G K : Matrix (Fin n) (Fin n) C} {kappa : C}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) : ...
theorem suiteCD_master_capstone
    {n : Nat} {G Kmat : Matrix (Fin n) (Fin n) C} {kappa : C}
    (hK : WEPTrace.ChannelBlind Kmat kappa)
    (hstat : WEPActionBridge.Stationary G Kmat)
    (F : Type*) [Field F] (N w : Nat) (hN : 1 <= N) : ...

end SuiteCDMasterCapstone
```

Specialize parameters if necessary for typechecking, but do not drop the N=2
control, N=3 nonzero CP witness, C3 control, or resource nonvacuity payload.
Add guard pins.

Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/SuiteCDMasterCapstone.lean
lake build PhysicsSM.Draft.NullEdge.SuiteCDMasterCapstone
```
