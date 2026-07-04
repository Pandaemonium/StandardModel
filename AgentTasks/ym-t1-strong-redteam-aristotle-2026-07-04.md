# Aristotle task note: T1 zero-cut Wilson RP semantic red-team

```yaml
aristotle:
  project_id: 3e2051c3-21f5-48c9-9a4f-9282bb19dd28
  task_id: e58986a6-050f-4355-aac4-86acfb18c13f
  target_file: PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.WilsonReflectionPositivity
  submission_project: AgentTasks/aristotle-submit/ym-t1-strong-redteam-20260704-project
  output_dir: AgentTasks/aristotle-output/3e2051c3-21f5-48c9-9a4f-9282bb19dd28
  status: harvested+integrated
```

## Purpose

Semantic red-team audit for the newly integrated T1 zero-cut strong tier:

- Route-B reflection convention in `reflectLinkField`.
- General mirror-coordinate Wilson identity in `MirrorHolonomyResolution.lean`.
- Ensemble identification theorem
  `doubledWilsonWeight_eq_ensembleWeight_mirrorConfig`.
- Claim boundary: zero-cut baseline plus ensemble-identification closed, full
  cut-plaquette RP-LINK still open.

## Local Evidence Before Submission

- `lake build PhysicsSM.Draft.NullEdge.GateYM` rerun by Codex after commit
  `1acf4f2`: passed, 8075 jobs, existing warnings plus known Q6 draft
  placeholders.
- `PhysicsSM/Draft/NullEdge/GateYM.lean` and `DAY_1_REPORT.md` were locally
  claim-language-synced before submission so the audit sees the intended
  current claim rather than stale wording.

## Context Pack

```text
AgentTasks/context-packs/ym-t1-strong-redteam-20260704-142346.md
```

## Submission Record

Prompt:

```text
AgentTasks/aristotle-prompts/ym-t1-strong-redteam-20260704.prompt.md
```

Submission package:

```text
AgentTasks/aristotle-submit/ym-t1-strong-redteam-20260704-project
```

Package command:

```text
pwsh Scripts/prepare_aristotle_submission.ps1 -JobName ym-t1-strong-redteam-20260704 -TaskNote AgentTasks/ym-t1-strong-redteam-aristotle-2026-07-04.md -ExtraPath AgentTasks/aristotle-prompts/ym-t1-strong-redteam-20260704.prompt.md,AgentTasks/context-packs/ym-t1-strong-redteam-20260704-142346.md,AgentTasks/paper-units/reflection-positivity-outline.md,AgentTasks/fourday-ym-run-2026-07-05/DAY_1_REPORT.md,AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md -CheckPath PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity.lean,PhysicsSM/Draft/NullEdge/GateYM.lean -NoRemoteSpherePacking
```

The first package attempt without `-NoRemoteSpherePacking` failed because this
repo has no active SpherePacking dependency for the helper to patch. The
rerun with `-NoRemoteSpherePacking` passed package checks. The submit command
warned that the package has no `.lake` folder; acceptable here because this is
a semantic audit/red-team package, not a proof build claim.

Live local check after claim-language sync:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean
```

Result: passed.

Submission:

```text
Project created: 3e2051c3-21f5-48c9-9a4f-9282bb19dd28
Task: e58986a6-050f-4355-aac4-86acfb18c13f
Project status after submit: RUNNING
```

## Harvest Record

Result: COMPLETE, verdict ACCEPT WITH CHANGES.

Returned report copied to:

```text
AgentTasks/context-packs/ym-t1-strong-redteam-audit-20260704.md
```

Key findings:

- The zero-cut baseline plus ensemble-identification claim is sound and
  honestly scoped.
- Full RP-LINK / cut-plaquette RP remains open.
- The T1 status label should not be read as full RP-LINK closure; the live
  ledger status now uses the explicit cut-plaquette-open wording.
- `ReflectionWalk.lean` had stale pre-Route-B opposite-group doc wording.
- A named corollary should state the RP inequality directly for the genuine
  two-plaquette `PlaquetteEnsemble.weight` at `mirrorConfig`.

Integrated follow-up:

- Updated `ReflectionWalk.lean` module docstring to name the current
  same-group Route-B theorem and mark `opLinkField` as retained historical
  scaffolding.
- Added
  `WilsonReflectionPositivity.doubled_wilson_ensembleWeight_reflectionForm_nonneg`.
- Updated `GateYM.lean` live map.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/ReflectionWalk.lean
lake env lean PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.ReflectionWalk
lake build PhysicsSM.Draft.NullEdge.GateYM.WilsonReflectionPositivity
lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean
lake build PhysicsSM.Draft.NullEdge.GateYM
rg -n "sorry|admit|axiom|opaque|unsafe|native_decide" PhysicsSM/Draft/NullEdge/GateYM/ReflectionWalk.lean PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity.lean
stdin #print axioms PhysicsSM.Draft.NullEdge.GateYM.WilsonReflectionPositivity.doubled_wilson_ensembleWeight_reflectionForm_nonneg
```

The new corollary's axiom footprint is `[propext, Classical.choice,
Quot.sound]`. The aggregate build still reports known pre-existing warnings
and the intended Q6 draft proof handoffs in `PolymerKPConclusion.lean`.
