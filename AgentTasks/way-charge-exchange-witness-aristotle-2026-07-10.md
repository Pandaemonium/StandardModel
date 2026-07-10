# Aristotle target: constructive WAY charge-exchange witness

Prove every theorem in `WAYChargeExchange/Core.lean` without changing any
definition, weakening any statement, or adding assumptions. Run:

```text
lake env lean WAYChargeExchange/Core.lean
```

The target complements the existing trivial-ancilla WAY no-go. Prove that the
explicit two-qubit swap gate is unitary, commutes with total binary charge, and
maps `|0>_system |1>_ancilla` to `|1>_system |0>_ancilla`. Prove it is not the
trivial `flip tensor I`, and prove that trivial gate fails total-charge
conservation.

Honest boundary: this is constructive sufficiency for one basis charge exchange.
It is not a universal coherent system-only flip, does not return the ancilla
unchanged, and does not derive the Higgs representation, Yukawa coupling, or
scalar mass.

References consulted clean-room: Ahmadi-Jennings-Rudolph arXiv:1209.0921 and
Kuramochi-Tajima arXiv:2208.13494 for WAY/asymmetry boundaries; Mathlib
`Matrix.swap` and Kronecker/unitary APIs for theorem shapes. PhysLean
`packages=["Physlib"]` returned no directly relevant WAY/reference-frame API.

Context pack:
`AgentTasks/context-packs/way-charge-exchange-witness-20260710-20260709-231337.md`.

```yaml
aristotle:
  project_id: 78cc049a-8896-4a8d-a322-dbb8b480a2de
  target_file: WAYChargeExchange/Core.lean
  expected_module: PhysicsSM.Draft.NullEdge.WAYChargeExchangeWitness
  submission_project: AgentTasks/aristotle-submit/codex-way-charge-exchange-witness-20260710-project
  output_dir: AgentTasks/aristotle-output/78cc049a-8896-4a8d-a322-dbb8b480a2de
  status: integrated and guarded 2026-07-09 23:35 PDT
```
