# codex-km-neutrino-family-anomaly-master-1220-20260709

aristotle:
  project_id: 1e2e2a9e-f481-418d-96be-68315c5a79b2
  target_file: PhysicsSM/Draft/NullEdge/KMNeutrinoFamilyAnomalyCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.KMNeutrinoFamilyAnomalyCapstone
  submission_project: AgentTasks/aristotle-submit/codex-ambitious-wave-1220-20260709-project
  output_dir: AgentTasks/aristotle-output/1e2e2a9e-f481-418d-96be-68315c5a79b2
  status: canceled after >2h stall; proof-complete snapshot harvested and landed 2026-07-09

You are Aristotle. Build the strongest finite Goal II / neutrino bridge now
available.

Target file:

```text
PhysicsSM/Draft/NullEdge/KMNeutrinoFamilyAnomalyCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.KMC3FlagshipCapstone
import PhysicsSM.Draft.NullEdge.NeutrinoCPSeesawBridge
import PhysicsSM.Draft.NullEdge.NeutrinoMassMechanismCapstone
import PhysicsSM.Draft.NullEdge.KMFamilyRankBridge
import PhysicsSM.Draft.NullEdge.FiniteKMCP
import PhysicsSM.Draft.NullEdge.C3IndexAnomalyCapstone
import PhysicsSM.Draft.NullEdge.IndexProtectionBridge
```

Mission: compose the finite CP phase-counting witness, family-rank bridge, C3
winding/index anomaly packet, and neutrino Dirac/Majorana/seesaw packets into one
auditable theorem surface. Preserve explicit nondegenerate witnesses:
`physicalPhases 2 = 0`, `physicalPhases 3 = 1`, the exact nonzero Jarlskog
witness `6912 / 78125`, the C3 nondegenerate witness, and the seesaw suppression
payload.

Preferred namespace/theorems:

```lean
namespace KMNeutrinoFamilyAnomalyCapstone

theorem cp_rank_anomaly_packet
    (K : Type*) [Field K] (N w : Nat) (hN : 1 <= N) : ...
theorem neutrino_mass_packet : ...
theorem km_neutrino_family_anomaly_capstone
    (K : Type*) [Field K] (N w : Nat) (hN : 1 <= N) : ...

end KMNeutrinoFamilyAnomalyCapstone
```

If typeclass burden from the general `K` is unhelpful, specialize only the C3
packet as needed and document the narrower statement. Do not weaken away the
N=2 control, N=3 witness, or nonzero-Jarlskog facts. Add guard pins for all
headline theorems.

Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/KMNeutrinoFamilyAnomalyCapstone.lean
lake build PhysicsSM.Draft.NullEdge.KMNeutrinoFamilyAnomalyCapstone
```

Return exact theorem names and the finite claim boundary.
