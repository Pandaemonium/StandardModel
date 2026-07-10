# codex-km-c3-flagship-capstone-1115-20260709

aristotle:
  project_id: bcbc8ee3-30e2-49f8-aba6-6bf09a969fda
  target_file: PhysicsSM/Draft/NullEdge/KMC3FlagshipCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.KMC3FlagshipCapstone
  submission_project: AgentTasks/aristotle-submit/codex-ambitious-wave-1115-20260709-project
  output_dir: pending
  status: submitted 2026-07-09

You are Aristotle, proving a consolidated Goal II/Suite C3 flagship capstone.
The aim is to make the KM/CP/family-rank/anomaly story easy to cite from the
manuscript and later audit.

Target file:

```text
PhysicsSM/Draft/NullEdge/KMC3FlagshipCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteKMCP
import PhysicsSM.Draft.NullEdge.KMPhaseCounting
import PhysicsSM.Draft.NullEdge.KMFamilyRankBridge
import PhysicsSM.Draft.NullEdge.KMFlagship
import PhysicsSM.Draft.NullEdge.C3IndexAnomalyCapstone
import PhysicsSM.Draft.NullEdge.IndexProtectionBridge
```

Mission:

1. Prove `km_cp_witness_packet`: explicit N=2 no-phase control, N=3 one-phase
   result, 3-4-5 rational unitary witness, and nonzero Jarlskog.
2. Prove `family_rank_bridge_packet`: bundle the `KMFamilyRankBridge` result and
   the `KMFlagship` result that supplies the generation-structure rung.
3. Prove `c3_index_anomaly_packet`: bundle
   `C3IndexAnomalyCapstone.km_winding_lowN_bridge`,
   `general_incidence_index_packet`, `c3_nondegenerate_witness`, and
   `c3_control_zero`, plus the relevant `IndexProtectionBridge` theorem.
4. Prove `km_c3_flagship_capstone`: finite KM phase counting, family-rank bridge,
   and C3 winding/index anomaly are a single kernel-checked finite theorem mesh
   with explicit nondegenerate and control witnesses.

Inline imported theorem propositions where shorthand theorem names do not
typecheck as propositions. Preserve nonzero rational witnesses. Add guard pins.

Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/KMC3FlagshipCapstone.lean
lake build PhysicsSM.Draft.NullEdge.KMC3FlagshipCapstone
```

Return theorem names, adaptations, axiom footprints, and exact caveat.
