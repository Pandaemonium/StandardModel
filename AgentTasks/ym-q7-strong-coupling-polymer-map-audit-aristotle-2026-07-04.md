# Aristotle harvest: Q7 strong-coupling polymer map audit

```yaml
aristotle:
  project_id: 52f42dd5-c768-47b6-9ecd-6583d600af85
  task_id: 9630de36-b02d-4d6d-ba2b-eb5355f0d221
  target_file: PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean
  output_dir: AgentTasks/aristotle-output/ym-q7-strong-coupling-polymer-map-audit-20260704
  status: harvested
```

## Verdict

ACCEPT WITH CHANGES.

The Q7 statement layer is honest as a freeze: it does not claim a
volume-uniform KP theorem, does not fake a finite-irrep API, and uses the
conservative overlap-or-touch incompatibility relation in the safe direction.

The main latent bug is the current `PlaquettePolymer` label carrier:
`P -> Rlab` is total and constrained only on the support, so off-support labels
create multiple Lean values for one physical polymer. This is harmless for the
current wrappers, but it would inflate a future `KPCondition` sum by a
volume-dependent factor. Fix this before any KP instantiation over Q7 polymers.

## Integrated

The small proof package from the audit was integrated into
`StrongCouplingPolymerMap.lean`:

- `SupportsOverlap.orTouch`
- `SupportsTouch.orTouch`
- `plaquettePolymerSystem_weight_nonneg`
- `tanh_nonneg_of_nonneg`
- `z2_plaquettePolymer_weight_eq_tanh_area`

These are support-level or definitional facts. They do not derive KP from
finite oracle rows or from beta/alpha parameters.

## Deferred

Recommended next Q7 package:

1. Redesign `PlaquettePolymer` to use support-indexed labels, or otherwise
   canonicalize off-support labels after a distinguished trivial label exists.
2. Add decidability for `SupportsOverlapOrTouch` under a decidable touch
   relation.
3. Only after that, state an honest `KPCondition` restatement that carries the
   finite KP sum bound as an explicit hypothesis.

Do not cite the v0.3 oracle's small torus rows as evidence of a volume-uniform
KP theorem. They are convention guards only.
