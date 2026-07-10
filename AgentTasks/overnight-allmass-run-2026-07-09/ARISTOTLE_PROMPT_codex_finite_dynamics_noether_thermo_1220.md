# codex-finite-dynamics-noether-thermo-1220-20260709

aristotle:
  project_id: 7f679d78-bb17-4ed2-86ff-983ecc4e1139
  target_file: PhysicsSM/Draft/NullEdge/FiniteDynamicsNoetherThermoCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteDynamicsNoetherThermoCapstone
  submission_project: AgentTasks/aristotle-submit/codex-ambitious-wave-1220-20260709-project
  output_dir: AgentTasks/aristotle-output/7f679d78-bb17-4ed2-86ff-983ecc4e1139
  status: canceled after >2h stall; proof-complete snapshot harvested and landed 2026-07-09

You are Aristotle. Push the finite dynamics layer one level beyond the existing
composition packet, using the PhysLean-modeled action/EOM/conservation/ensemble
shape already landed in the carrier files.

Target file:

```text
PhysicsSM/Draft/NullEdge/FiniteDynamicsNoetherThermoCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.FiniteCarrierAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction
import PhysicsSM.Draft.NullEdge.Carrier.FiniteUnitaryEvolution
import PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow
import PhysicsSM.Draft.NullEdge.Carrier.FiniteCanonicalEnsemble
import PhysicsSM.Draft.NullEdge.Carrier.CarrierUnitaryFlow
import PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone
```

Mission: prove the strongest generic finite "Noether/thermo" packet available
from these APIs:
- stationary finite action iff finite EOM / mass-shell equation;
- symmetry commuting with the operator transports mass-shell solutions;
- finite unitary evolution conserves norm and commuting-observable expectation;
- finite RG propagates invariants and antitone observables along iterates;
- finite canonical ensemble probabilities normalize and variance is nonnegative;
- one capstone theorem conjoining the generic and concrete carrier flow facts.

Preferred namespace/theorems:

```lean
namespace FiniteDynamicsNoetherThermoCapstone

theorem action_symmetry_conservation_packet : ...
theorem rg_ensemble_packet : ...
theorem finite_dynamics_noether_thermo_capstone : ...

end FiniteDynamicsNoetherThermoCapstone
```

This is finite linear algebra/probability only. No continuum Noether theorem, no
field measure, no thermodynamic limit. Add guard pins.

Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/FiniteDynamicsNoetherThermoCapstone.lean
lake build PhysicsSM.Draft.NullEdge.FiniteDynamicsNoetherThermoCapstone
```
