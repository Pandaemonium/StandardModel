# codex-carrier-dynamics-capstone-1115-20260709

aristotle:
  project_id: 7c5b124e-b05c-4f75-b737-a26633550ac9
  target_file: PhysicsSM/Draft/NullEdge/Carrier/CarrierDynamicsCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone
  submission_project: AgentTasks/aristotle-submit/codex-ambitious-wave-1115-20260709-project
  output_dir: pending
  status: submitted 2026-07-09

You are Aristotle, proving an ambitious finite dynamics capstone for the
null-edge carrier lane. Use PhysLean only as clean-room API inspiration already
recorded in the source docstrings; do not add a new dependency.

Target file:

```text
PhysicsSM/Draft/NullEdge/Carrier/CarrierDynamicsCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteUnitaryEvolution
import PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow
import PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinFlow
import PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow
import PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble
import PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness
```

Mission:

1. Compose the D1 action/EOM theorems:
   `FiniteCarrierAction.stationaryPair_iff_eom_pair`,
   `FiniteQuadraticAction.quadraticStationary_iff_eom`,
   `FiniteQuadraticAction.massShellStationary_iff_eigen`, and
   `FiniteQuadraticAction.massShell_equation_symmetry`.
2. Compose the D2/D3 dynamics theorems:
   `FiniteUnitaryEvolution.norm_conserved_orbit`,
   `FiniteUnitaryEvolution.energy_conserved_orbit`,
   `CarrierUnitaryFlow.B_flow_unitary`,
   `CarrierUnitaryFlow.carrier_orbit_norm_conserved`,
   `CarrierUnitaryFlow.carrier_orbit_energy_conserved`, and
   `CarrierKreinFlow.HAC_flow_Jmet_unitary`.
3. Compose the D4/D5 scaffolds:
   `FiniteRGFlow.invariant_orbit`,
   `FiniteRGFlow.observable_invariant_orbit`,
   `FiniteRGFlow.observable_antitone_orbit`,
   `FiniteCanonicalEnsemble.sum_probability_eq_one`, and
   `FiniteCanonicalEnsemble.energyVariance_nonneg`.
4. Add a capstone theorem that honestly states the current dynamics layer:
   finite action principles give Euler equations, unitary/Krein transfer gives
   conserved quantities, finite RG propagates one-step invariants, and finite
   canonical probabilities normalize.

Preferred namespace and theorem names:

```lean
namespace PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone

theorem finite_action_eom_packet : ...
theorem finite_transfer_conservation_packet : ...
theorem finite_rg_ensemble_packet : ...
theorem carrier_dynamics_capstone : ...

end PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone
```

If theorem-name shorthand is not a proposition, restate the exact proposition
proved by the imported theorem and discharge it with that proof term. Do not
weaken the payload. Add guard pins for every headline:

```lean
#guard_msgs (whitespace := lax) in
#print axioms ...
```

Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/Carrier/CarrierDynamicsCapstone.lean
lake build PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone
```

Return solved theorem names, statement adjustments, axiom footprints, and the
semantic caveat that this is finite dynamics, not a continuum field theory.
