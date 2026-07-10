# codex-carrier-dynamics-rg-information-1220-20260709

aristotle:
  project_id: 1c07ed70-12a6-4bcc-8336-97d1f96fa91f
  target_file: PhysicsSM/Draft/NullEdge/CarrierDynamicsRGInformationCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.CarrierDynamicsRGInformationCapstone
  submission_project: AgentTasks/aristotle-submit/codex-ambitious-wave-1220-20260709-project
  output_dir: AgentTasks/aristotle-output/1c07ed70-12a6-4bcc-8336-97d1f96fa91f
  status: harvested and landed 2026-07-09

You are Aristotle. Build a finite dynamics / RG / information capstone using
the PhysLean-modeled dynamics layer and the public Lean information references
already clean-roomed into this project.

Target file:

```text
PhysicsSM/Draft/NullEdge/CarrierDynamicsRGInformationCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone
import PhysicsSM.Draft.NullEdge.MassPhaseRGCapstone
import PhysicsSM.Draft.NullEdge.InformationResourceBridge
import PhysicsSM.Draft.NullEdge.ParticleInformationCapstone
import PhysicsSM.Draft.NullEdge.MassThermodynamics
import PhysicsSM.Draft.NullEdge.ModularSelection
import PhysicsSM.Draft.NullEdge.LeanQuantumDPIMass
import PhysicsSM.Draft.NullEdge.KraftCompressionMass
```

Mission: state and prove a theorem packet saying the finite program now has:
D1 finite action/EOM, D2-D3 conserved finite evolution, D4 finite RG invariant
propagation, D5 finite canonical ensemble normalization, finite mass-phase/RG
structure, and finite information/resource monotone packets. This should be a
composition theorem, but push it as far as the imported APIs allow.

Preferred namespace/theorems:

```lean
namespace CarrierDynamicsRGInformationCapstone

theorem dynamics_rg_packet : ...
theorem information_thermo_packet : ...
theorem carrier_dynamics_rg_information_capstone : ...

end CarrierDynamicsRGInformationCapstone
```

Honest boundary: finite dynamics only. No continuum field theory, no physical
Hamiltonian derivation, no thermodynamic limit. Add guard pins for all headlines.

Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/CarrierDynamicsRGInformationCapstone.lean
lake build PhysicsSM.Draft.NullEdge.CarrierDynamicsRGInformationCapstone
```
