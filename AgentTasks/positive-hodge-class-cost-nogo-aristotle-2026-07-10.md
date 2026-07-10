# Aristotle target: nilpotent positive-Hodge class-cost no-go

Prove every theorem in `PositiveHodgeClassCost/Core.lean` without changing any
definition, weakening any statement, or adding assumptions. Run the narrow
check:

```text
lake env lean PositiveHodgeClassCost/Core.lean
```

Scientific target: correct a false-shape risk in the proposed variational mass
over representatives `h + Q chi`. With a genuine differential `Q^2 = 0`, the
Kugo-Ojima radical property, and `[S,Q]=0`, `S(Q chi)` is exact and `Q chi` is
closed. Therefore its spectral pairing vanishes and cost is constant across the
cohomology class. The explicit witness must retain `Q != 0`, `Q^2 = 0`, a
positive surviving class, and exact cost `4/25`.

This does not kill the spectral mass of the class. It kills the claim that
minimization over exact representatives is nontrivial under the displayed
descent/radical hypotheses. A nontrivial variational problem requires varying
positive sectors, decoder moduli, non-exact representatives, or relaxing one of
those hypotheses explicitly.

Context pack:
`AgentTasks/context-packs/positive-hodge-class-cost-nogo-20260710-20260709-230849.md`.

```yaml
aristotle:
  project_id: 8d0c1db2-6555-48f6-9cd6-e58555b245e9
  target_file: PositiveHodgeClassCost/Core.lean
  expected_module: PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo
  submission_project: AgentTasks/aristotle-submit/codex-positive-hodge-class-cost-nogo-20260710-project
  output_dir: AgentTasks/aristotle-output/8d0c1db2-6555-48f6-9cd6-e58555b245e9
  status: integrated and guarded 2026-07-09 23:49 PDT; independent audit running as `8e7bf01f-ddf1-479c-95d0-623ebf0bdb08`
```
