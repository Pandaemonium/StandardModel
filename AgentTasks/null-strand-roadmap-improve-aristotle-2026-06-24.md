# Aristotle job: improve the null-strand Lean roadmap

```yaml
aristotle:
  project_id: 00000000-0000-0000-0000-000000000000   # fill in after submit
  target_file: Sources/NullStrand_Lean_Roadmap.md
  submission_project: AgentTasks/aristotle-submit/null-strand-roadmap-improve-20260624-project
  output_dir: AgentTasks/aristotle-output/<project-id>
  status: prepared        # not yet submitted (see blocker)
```

## Goal

Submit the entire `Sources/NullStrand_Lean_Roadmap.md` to Aristotle as a
document-improvement / mathematical-review task (not a single-theorem proof):
audit correctness, tighten Lean statements, re-audit BANKED/READY/CONDITIONAL/
OPEN/NO-GO classifications, check the dependency graph, name Mathlib hooks, and
sharpen claim boundaries. Aristotle returns an improved roadmap plus a review.

## Package

Lightweight, deliberately NOT the full PhysicsSM build (avoids the
"spends budget on a project build, times out before useful work" failure mode;
this is a doc task, nothing to compile):

```text
AgentTasks/aristotle-submit/null-strand-roadmap-improve-20260624-project/
  NullStrand_Lean_Roadmap.md   # copy of Sources/NullStrand_Lean_Roadmap.md
  AGENTS.md                    # project conventions/rules for Aristotle to respect
  PROMPT.txt                   # the submission prompt
```

## Blocker (2026-06-24)

`aristotle list` fails inside Claude Code's Bash/PowerShell tool shells with
"Invalid Aristotle API key" even though `ARISTOTLE_API_KEY` is present
(49 chars, `arst...cNgM`, no whitespace). The user's own interactive shell runs
`aristotle list` fine. Conclusion: stale key cached in the tool-launched
environment, not a revoked key. Submit from the user's shell.

## Submit command (run from repo root in the user's shell)

PowerShell:

```powershell
aristotle submit `
  --project-dir "AgentTasks\aristotle-submit\null-strand-roadmap-improve-20260624-project" `
  (Get-Content "AgentTasks\aristotle-submit\null-strand-roadmap-improve-20260624-project\PROMPT.txt" -Raw)
```

Record the returned project ID as `project_id` above, then:

```powershell
aristotle list --limit 5
aristotle show <project-id> --limit 20
```

## Integration (after IDLE)

```powershell
python Scripts/aristotle/integrate_completed.py `
  --task-note AgentTasks/null-strand-roadmap-improve-aristotle-2026-06-24.md `
  <project-id>
```

Expected deliverables: `NullStrand_Lean_Roadmap_Improved.md` and
`NullStrand_Roadmap_Review.md`. Review before replacing the live roadmap.

## Focused theorem job (2026-06-25)

- Submitted focused proof job for the finite BellQFT/Graph/Entanglement/finite-master
  modules:
  - Project: `81428b35-c328-4f98-96fa-49c479146f47`
  - Package: `AgentTasks/aristotle-submit/null-strand-finite-core-proof-20260625-project`
  - Target module group:
    - `PhysicsSM.NullStrand.BellQFT.FiniteCurrent`
    - `PhysicsSM.NullStrand.BellQFT.MinimalJumpRates`
    - `PhysicsSM.NullStrand.Graph.BellSupport`
    - `PhysicsSM.NullStrand.BellQFT.FockCutoff`
    - `PhysicsSM.NullStrand.Entanglement.ProductNullRepresentation`
    - `PhysicsSM.NullStrand.Entanglement.SeparabilityObstruction`
    - `PhysicsSM.NullStrand.Master.FiniteModel`
    - `PhysicsSM.NullStrand.Master.FoliatedManyParticle`

Status: `QUEUED`
