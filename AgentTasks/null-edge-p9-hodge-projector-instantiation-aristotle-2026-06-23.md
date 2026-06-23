# Aristotle focused job: P9 Hodge-projector instantiation

```yaml
job_name: null-edge-p9-hodge-projector-instantiation-20260623
status: integrated
project_id: 8f067f6a-5b77-47ed-be85-0bbe9c22b7db
task_id: d09cdb60-5a9f-4d66-8089-fc940dd2e80a
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-hodge-projector-instantiation-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-hodge-projector-instantiation-20260623-project
target_module: NullEdgeP9HodgeProjectorInstantiation.Core
target_file: NullEdgeP9HodgeProjectorInstantiation/Core.lean
integrated_module: PhysicsSM.Draft.NullEdgeP9HodgeProjectorInstantiation
integrated_file: PhysicsSM/Draft/NullEdgeP9HodgeProjectorInstantiation.lean
expected_check: lake env lean NullEdgeP9HodgeProjectorInstantiation/Core.lean
```

## Task

Fill the four proof holes in
`NullEdgeP9HodgeProjectorInstantiation/Core.lean` without changing definitions
or theorem statements.

This is the finite Hodge instantiation that Bohr/Spark recommended after the
C4 P9 triage. It bridges abstract self-adjoint projector algebra to the
weighted finite Hodge route: if a projector is self-adjoint, idempotent, and
its range lies in the harmonic sector `coclosed and closed`, then it
annihilates exact boundary bookkeeping and makes projected pairings/responses
boundary-invariant.

## Targets

```lean
hodgeProjector_annihilates_exact
hodgeProjector_boundary_invariant
hodgeProjector_projectedResponse_boundary_invariant
hodgeProjector_pairing_boundary_invariant
```

## Constraints

- Do not weaken, rename, or restate the theorems.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- The two helper lemmas above the targets are already proved in the staged file;
  reuse them.
- Verify with:

```bash
lake env lean NullEdgeP9HodgeProjectorInstantiation/Core.lean
```

## Proof sketch

For `hodgeProjector_annihilates_exact`, let
`z = lin PiH (coboundary d0 a)`. The range assumption gives `Coclosed z`.
Use self-adjointness and idempotence to rewrite
`dotW w1 z z` as `dotW w1 (coboundary d0 a) z`. Then use the weighted-adjoint
lemma to rewrite this as `dotW w0 a (codiff w0 w1 d0 z)`, which vanishes
because `z` is coclosed. Positivity of `w1` then forces `z = 0` by
`dotW_self_eq_zero_iff_of_pos`.

The remaining theorems should reduce to the annihilation theorem plus linearity
of `lin PiH` over `addCochain`, and then rewrite the projected response or
weighted pairing by equality of projected vectors.

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission note

Submitted on 2026-06-23 as Aristotle project
`8f067f6a-5b77-47ed-be85-0bbe9c22b7db`, task
`d09cdb60-5a9f-4d66-8089-fc940dd2e80a`.

Local preflight in the main project:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-hodge-projector-instantiation-20260623/NullEdgeP9HodgeProjectorInstantiation/Core.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" AgentTasks/aristotle-standalone/null-edge-p9-hodge-projector-instantiation-20260623/NullEdgeP9HodgeProjectorInstantiation/Core.lean AgentTasks/null-edge-p9-hodge-projector-instantiation-aristotle-2026-06-23.md
rg -n "[^\x00-\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-hodge-projector-instantiation-20260623/NullEdgeP9HodgeProjectorInstantiation/Core.lean AgentTasks/null-edge-p9-hodge-projector-instantiation-aristotle-2026-06-23.md
```

The Lean preflight found exactly the four intended proof-hole warnings and no
other errors. Non-ASCII scan was clean. The placeholder scan found exactly the
four executable proof holes in the staged Lean file.

## Integration

Integrated on 2026-06-23 into
`PhysicsSM.Draft.NullEdgeP9HodgeProjectorInstantiation`.

Aristotle reported all four targets solved, with no statement or definition
changes and no remaining proof holes. Statement-identity review against the
staged standalone source showed only proof-body changes. The returned proof
used Unicode bullets; the integrated version was translated to ASCII Lean
syntax and project namespace conventions.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9HodgeProjectorInstantiation.lean
lake build PhysicsSM.Draft.NullEdgeP9HodgeProjectorInstantiation
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9HodgeProjectorInstantiation.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9HodgeProjectorInstantiation.lean
```

The targeted file check, module build, draft-root import check, placeholder
scan, and non-ASCII scan passed. The first draft-root import check raced the
targeted build and failed before the `.olean` existed; rerunning after the
targeted build passed.
