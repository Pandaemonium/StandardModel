# codex constructive WAY reservoir, 2026-07-09 14:00

aristotle:
  project_id: f1c70ec0-06bd-476f-b7e2-f4884993706c
  target_file: PhysicsSM/Draft/NullEdge/WAYConstructiveReservoir.lean
  expected_module: PhysicsSM.Draft.NullEdge.WAYConstructiveReservoir
  submission_project: AgentTasks/aristotle-submit/codex-impact-wave-1400-20260709-project
  output_dir: AgentTasks/aristotle-output/f1c70ec0-06bd-476f-b7e2-f4884993706c
  status: submitted 2026-07-09

You are Aristotle. Complete the constructive half of the finite WAY turn
dichotomy. The negative half is already landed in `WAYTurnNoGo`.

Target:

```text
PhysicsSM/Draft/NullEdge/WAYConstructiveReservoir.lean
```

Imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.WAYTurnNoGo
import PhysicsSM.Draft.NullEdge.ZigzagWeyl
import PhysicsSM.Draft.NullEdge.CheckerboardCarrierBridge
import PhysicsSM.Draft.NullEdge.FiniteKMCP
```

Context pack:

```text
AgentTasks/context-packs/way-constructive-reservoir-20260709-135729.md
```

Construct explicit two-level system and two-level reservoir matrices over
`Complex` or exact rational matrices where possible. Let the additive total
charge be `WAY.isospin tensor 1 + 1 tensor Q_a`.

Required payload:

1. Define the exact excitation-exchange permutation on the four-dimensional
   system-reservoir space. Prove it is unitary, commutes with additive total
   charge, and maps `|0>_s |1>_a` to `|1>_s |0>_a`. Thus an exact system
   chirality turn is possible by charge transfer to a nontrivial reservoir.
2. Define an exact `3-4-5` unitary block on the one-excitation sector. Prove it
   commutes with total charge and has a nonzero off-diagonal turn amplitude.
   This supplies a coherent partial-turn witness, not merely a permutation.
3. Combine these constructions with
   `WAY.chirality_requires_nontrivial_ancilla` into a dichotomy theorem:
   trivial-ancilla implementation is impossible, while an explicit
   charge-carrying reservoir supports exact exchange and coherent partial turn.
4. Retain explicit basis-state and nonzero-amplitude witnesses in the final
   theorem. Do not encode the conclusion only as an existential.

Preferred names:

```lean
exchangeUnitary
exchangeUnitary_unitary
exchange_conserves_total_isospin
exchange_transfers_one_charge
coherentTurn345
coherentTurn345_unitary
coherentTurn345_conserves_total_isospin
coherentTurn345_nonzero_transition
way_turn_reservoir_dichotomy
```

Honest boundary: this is a finite resource-theory mechanism for the turn gate.
It does not derive the Standard Model Higgs field, a vacuum expectation value,
or a physical Yukawa coupling. Add footprint guard pins and run the targeted
Lean and Lake checks.
