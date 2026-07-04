# Aristotle task note: Q1 cut-plaquette assembly strategy

```yaml
aristotle:
  project_id: 8271a64b-c45b-4f31-8c76-5c6fdc93bcd8
  task_id: e152ffe8-6bb7-4fae-8781-f274a6a53bd9
  target_file: PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel
  submission_project: AgentTasks/aristotle-submit/ym-q1-cut-plaquette-assembly-strategy-20260704-project
  output_dir: AgentTasks/aristotle-output/8271a64b-c45b-4f31-8c76-5c6fdc93bcd8
  status: submitted
```

## Purpose

Ask Aristotle for a proof-design and semantic-audit artifact for Q1's actual
Wilson cut-plaquette reflection-positivity assembly, using the newly landed
product/Hadamard/PSD connector lemmas in `ReflectionPositivityKernel.lean`.

This is not a claim that full RP-LINK is closed. The target is to identify the
smallest semantically correct next Lean theorem and proof DAG for the
non-degenerate cut-plaquette geometry.

## Local preflight

- `lake env lean PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel`
- `lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateYM`
- Placeholder scan on `ReflectionPositivityKernel.lean`
- Stdin axiom audits for the new connector lemmas

All above passed before this submission was prepared. The aggregate build
still reports known pre-existing warnings and the intended Q6 draft proof
handoffs in `PolymerKPConclusion.lean`.

## Context pack

`AgentTasks/context-packs/ym-q1-cut-plaquette-assembly-20260704-20260704-161145.md`

The doc-index refresh attempted before generating the context pack timed out
after roughly two minutes, so the prompt explicitly names the authoritative
Lean/run-note files instead of relying on context-pack relevance.

## Submission log

- 2026-07-04: Prepared package with
  `Scripts/prepare_aristotle_submission.ps1` using `-NoRemoteSpherePacking`
  because this project has no active SpherePacking dependency to patch.
  Package structural checks passed for
  `ReflectionPositivityKernel.lean`, `WilsonReflectionPositivity.lean`, and
  `MirrorHolonomyResolution.lean`.
- 2026-07-04: Submitted with
  `aristotle submit --project-dir AgentTasks/aristotle-submit/ym-q1-cut-plaquette-assembly-strategy-20260704-project`.
  CLI warned that the package contains Lean files but no `.lake` folder; this
  is accepted for a semantic/proof-design audit package. Project
  `8271a64b-c45b-4f31-8c76-5c6fdc93bcd8`, task
  `e152ffe8-6bb7-4fae-8781-f274a6a53bd9`, initially `QUEUED`.
