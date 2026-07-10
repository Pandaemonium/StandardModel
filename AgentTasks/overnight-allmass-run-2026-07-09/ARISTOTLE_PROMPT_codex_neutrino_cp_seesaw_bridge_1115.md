# codex-neutrino-cp-seesaw-bridge-1115-20260709

aristotle:
  project_id: f02faec3-03b0-455d-a97d-91e2b2e2a126
  target_file: PhysicsSM/Draft/NullEdge/NeutrinoCPSeesawBridge.lean
  expected_module: PhysicsSM.Draft.NullEdge.NeutrinoCPSeesawBridge
  submission_project: AgentTasks/aristotle-submit/codex-ambitious-wave-1115-20260709-project
  output_dir: pending
  status: submitted 2026-07-09

You are Aristotle, replacing the overlong neutrino mass-mechanism job with a
smaller but more ambitious bridge: finite CP/family structure plus Dirac,
Majorana, type-I seesaw, and Schur-seesaw suppression.

Target file:

```text
PhysicsSM/Draft/NullEdge/NeutrinoCPSeesawBridge.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteKMCP
import PhysicsSM.Draft.NullEdge.KMFlagship
import PhysicsSM.Draft.NullEdge.C3IndexAnomalyCapstone
import PhysicsSM.Draft.NullEdge.NeutrinoDiracMajorana
import PhysicsSM.Draft.NullEdge.NeutrinoSeesaw
import PhysicsSM.Draft.NullEdge.SchurSeesaw
import PhysicsSM.Draft.NullEdge.CPTAntiparticleZigzag
```

Mission:

1. Prove a `cp_family_witness_packet` theorem bundling `FiniteKM.Vwitness`
   unitarity, nonzero Jarlskog, `physicalPhases 2 = 0`,
   `physicalPhases 3 = 1`, and the C3 nondegenerate witness.
2. Prove a `dirac_majorana_seesaw_packet` theorem bundling the Dirac/Majorana
   branch facts, the type-I seesaw inequalities, and the Schur-seesaw
   suppression/zero-overlap facts.
3. Prove a final `neutrino_cp_seesaw_bridge` theorem: finite CP/family rank and
   anomaly data coexist with a finite neutrino mass-mechanism hierarchy. Scope:
   structural finite bridge only, no physical PMNS fit and no measured neutrino
   mass.

Use exact imported theorem statements where possible:
`FiniteKM.Vwitness_unitary`, `FiniteKM.jarlskog_Vwitness`,
`FiniteKM.jarlskog_Vwitness_ne_zero`,
`C3IndexAnomalyCapstone.c3_nondegenerate_witness`,
`NeutrinoDiracMajorana.neutrino_verdict`,
`NeutrinoSeesaw.seesaw_verdict`, `NeutrinoSeesaw.nondegen_suppressed`,
`NeutrinoSeesaw.nondegen_control`,
`SchurSeesaw.seesaw_suppression`, and
`SchurSeesaw.seesaw_zero_iff_no_overlap`.

If a theorem name is a proof term rather than a proposition, restate its exact
type. Add guard pins for all headline theorems. Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/NeutrinoCPSeesawBridge.lean
lake build PhysicsSM.Draft.NullEdge.NeutrinoCPSeesawBridge
```

Return theorem names, any statement adaptations, axiom footprints, and caveats.
