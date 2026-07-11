# Aristotle design job: noncircular Pluecker winding to compression index bridge

Name this project `codex-pub-c-index-bridge-design-20260711`.

Read the supplied exact Lean modules and Paper C claim/gate rows. Design the
strongest noncircular theorem connecting the spinor-derived winding data in
`PlueckerWindingDerived` to the involutive-compression signature/mode count in
`ModeInvariantHalfWinding`.

The current result is fixture-level only: one displayed two-wall walk has exact
sign modes, complete displayed zero/four controls have none, and a separate
eight-site family has explicit localized modes. There is no formal half-winding
invariant, quantified wall family, stability theorem, or bridge between the
derived Pluecker field and the compression.

Requirements:

1. Define the proposed common object and both maps without reading the
   compression signature back into the winding definition.
2. State an exact Lean theorem with all hypotheses visible, plus the displayed
   two-wall witness and zero/four controls.
3. Audit whether the theorem is mathematically true for the supplied fixtures.
4. If a general identity is false or circular, return an explicit
   counterexample or the precise missing compatibility axiom.
5. Give a minimal focused Aristotle proof package plan: definitions to copy,
   exact theorem order, likely Mathlib APIs, and prohibited weakenings.

Do not call any result protected, topological, stable, or a wall-count
classification unless the corresponding theorem is actually stated. Return a
design report, not manuscript rhetoric.

```yaml
aristotle:
  project_id: 32a89f02-49f4-4198-bc22-93f1316f9aae
  target_file: review/design
  expected_module: review/design
  submission_project: AgentTasks/aristotle-submit/codex-pub-c-index-bridge-design-20260711-project
  output_dir: AgentTasks/aristotle-output/32a89f02-49f4-4198-bc22-93f1316f9aae
  status: harvested-counterexample-integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```
