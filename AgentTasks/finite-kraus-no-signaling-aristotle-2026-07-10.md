# Aristotle target: finite Kraus no-signaling

Prove every theorem in `FiniteNoSignaling/Core.lean` without changing any
definition, weakening any statement, or adding assumptions. Run:

```text
lake env lean FiniteNoSignaling/Core.lean
```

The prize is `partialTraceB_applyLocalKrausB`: an arbitrary finite
trace-preserving Kraus family acting only on register `B` leaves the `A`
marginal exactly unchanged. Close the explicit reset-channel fixture as a
nonidentity local operation whose joint state changes while the remote marginal
does not.

This is finite matrix algebra and a clean-room theorem shape informed by
lean-quantum's channel/partial-trace APIs. It is not a Bell theorem, a causal
spacetime construction, or a derivation of quantum probability.

Context pack:
`AgentTasks/context-packs/finite-kraus-no-signaling-20260710-20260709-221417.md`
(repo/Lean semantic hits only; paper embedding was skipped after a local paging
file exhaustion).

```yaml
aristotle:
  project_id: 17674ce6-b10a-474a-931f-d0237d539f0b
  target_file: FiniteNoSignaling/Core.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteNoSignaling
  submission_project: AgentTasks/aristotle-submit/codex-finite-kraus-no-signaling-20260710-project
  output_dir: AgentTasks/aristotle-output/17674ce6-b10a-474a-931f-d0237d539f0b
  status: integrated and guarded 2026-07-09 23:06 PDT
```
