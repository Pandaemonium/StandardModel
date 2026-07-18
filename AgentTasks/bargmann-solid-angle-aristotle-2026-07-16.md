# Aristotle job: Bargmann phase = half solid angle, VOS-arctan law (spiral wave 3, job A)

Date: 2026-07-16
Status: PREPARED, NOT SUBMITTED (fleet at 8/8 cap when prepared; submit when
a slot frees, e.g. after wave-2 harvest).
Context: spiral-layer wave 3; sharpened C1-triangle gate from the program
note `AutonomousLab/work/SPIRAL-LAYER/CLAUDE_SPIRAL_LAYER_PROGRAM_NOTE_2026-07-16.md`.

```yaml
aristotle:
  project_id: 9ba69cff-0383-4052-81fb-4927fd0b3a12
  task_id: TBD
  target_file: BargmannSolidAngle/BargmannSolidAngle.lean
  expected_module: BargmannSolidAngle.BargmannSolidAngle
  submission_project: AgentTasks/aristotle-submit/bargmann-solid-angle-20260716-project
  source_root: AgentTasks/aristotle-standalone/bargmann-solid-angle-20260716
  output_dir: AgentTasks/aristotle-output/9ba69cff-0383-4052-81fb-4927fd0b3a12
  status: integrated
  integration_target: PhysicsSM/Draft/NullEdge/BargmannSolidAngleAristotle.lean
```

## Goal

Kernel-check the trace side of the Van Oosterom-Strackee correspondence: on
the principal domain (1 + a.b + b.c + c.a > 0), the argument of the
three-cycle Bargmann invariant equals
arctan(triple / (1 + pairwise dots)). With the cited VOS formula
(tan(Omega/2) = triple/(1+dots) for unit vectors) this makes "corner phase
= signed half solid angle" exact for triangles, with exactly one imported
classical identity. Witnesses: octant arg = pi/4; planar arg = 0; reversal
negates arg.

## Statements (4, placeholder-proof targets, do not weaken)

`bargmann_arg_eq_arctan`, `bargmann_arg_octant`, `bargmann_arg_planar`,
`bargmann_arg_neg`.

## Preflight

- Statement file typechecked 2026-07-16: `lake env lean` EXIT=0, only
  placeholder warnings.
- Hand-checks: octant Re = 1/4 > 0, Im/Re = 1, arctan 1 = pi/4 = half of
  the octant solid angle pi/2 (consistent with wave-1 witness (1+I)/4);
  planar witness c = (1/2,1/2,0): Re = 2/4 > 0, triple = 0, arg = 0.
- Submission command pattern: the standard focused-package helper
  (`prepare_aristotle_focused_submission.ps1 -JobName
  bargmann-solid-angle-20260716 -RootModule BargmannSolidAngle -SourceRoot
  AgentTasks/aristotle-standalone/bargmann-solid-angle-20260716 -LeanPath
  BargmannSolidAngle/BargmannSolidAngle.lean -TaskNote <this note>`), then
  `aristotle submit` with a single-quoted prompt and `labctl.py
  job-register` immediately after.

## Semantic review checklist (for integration)

- The positivity hypothesis is the branch guard - it must not be weakened
  or dropped; obtuse configurations are explicitly out of scope.
- The solid-angle READING stays [import]-tagged (VOS 1983); the Lean
  theorem is about arg and arctan only. Docstring must keep that split.
- Orientation: arctan argument is triple/(1+dots) with the right-handed
  triple; a sign flip here flips the handedness convention.
- Axiom audit per theorem; no compiled-evaluator tactic.
