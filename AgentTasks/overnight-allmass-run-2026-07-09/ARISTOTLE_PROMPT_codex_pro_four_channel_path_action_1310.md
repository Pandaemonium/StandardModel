# codex-pro-four-channel-path-action-1310-20260709

aristotle:
  project_id: a788df9f-d85a-42cf-b29b-869fd8a1c877
  target_file: PhysicsSM/Draft/NullEdge/FourChannelPathActionCapstone.lean
  expected_module: PhysicsSM.Draft.NullEdge.FourChannelPathActionCapstone
  submission_project: AgentTasks/aristotle-submit/codex-pro-followup-1310-20260709-project
  output_dir: AgentTasks/aristotle-output/a788df9f-d85a-42cf-b29b-869fd8a1c877
  status: harvested and landed 2026-07-09

You are Aristotle. Follow up Pro's top-ranked direction: turn the static
four-channel mass budget into the nearest finite path-sum/action theorem we can
honestly prove now.

Target file:

```text
PhysicsSM/Draft/NullEdge/FourChannelPathActionCapstone.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.PathSumSemantics
import PhysicsSM.Draft.NullEdge.CheckerboardCarrierBridge
import PhysicsSM.Draft.NullEdge.SuiteBCl4Walk
import PhysicsSM.Draft.NullEdge.Carrier.CarrierDynamicsCapstone
import PhysicsSM.Draft.NullEdge.CarrierDynamicsRGInformationCapstone
import PhysicsSM.Draft.NullEdge.Carrier.FiniteQuadraticAction
import PhysicsSM.Draft.NullEdge.MassPhaseRGCapstone
```

Mission:

1. Add a small finite four-channel action API if useful. For example, a structure
   or plain functions with aperture/closure/turn/soldering real contributions,
   total action = their sum, and phase = `Complex.exp (Complex.I * action)`.
2. Prove the finite bookkeeping theorems: total action decomposes into four
   channels; phase factorizes over channel sums; adding an action difference
   multiplies the phase by the relative phase.
3. Bundle the landed path-sum semantics: coherent histories give the pure/massless
   packet, decohered histories expose retained which-direction information, and
   the checkerboard/Cl4 carrier packets are available as the finite path carrier.
4. Bundle the finite dynamics/RG information capstone so this becomes a citable
   "static budget -> finite history/action scaffold" theorem.

Preferred namespace and theorem names:

```lean
namespace FourChannelPathActionCapstone

theorem four_channel_action_decomposition : ...
theorem four_channel_phase_factorization : ...
theorem path_sum_information_packet : ...
theorem checkerboard_dynamics_packet : ...
theorem four_channel_path_action_capstone : ...

end FourChannelPathActionCapstone
```

Do not claim the checkerboard-to-continuum Dirac propagator. That remains a
paper-level limit theorem. This target is finite: it should say that the program
now has a local four-channel action/phase scaffold plus the existing finite
path-sum and carrier packets. Add guard pins for headline theorems.

Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/FourChannelPathActionCapstone.lean
lake build PhysicsSM.Draft.NullEdge.FourChannelPathActionCapstone
```

Return exact theorem names, any helper definitions, and the honest claim
boundary.
