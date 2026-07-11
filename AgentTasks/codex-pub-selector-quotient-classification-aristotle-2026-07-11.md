# Aristotle proof job: selector-preserving quotient classification

Name this project `codex-pub-selector-quotient-classification-20260711`.

Prove all five theorem holes in `ChannelSelectorQuotient/Main.lean` with the
definitions and statements unchanged. Run the narrow file first.

Scientific purpose: close Paper F's abstract quotient-definition gate. For a
supplied additive selector on the channel ambiguity group, define the exact
selector-resolved quotient by its kernel, identify equality of quotient classes
with equality of selector values, and classify when the quotient is trivial or
nontrivial. `quotientEquivRange` already invokes the additive first isomorphism
theorem and must remain the canonical equivalence.

Do not call this quotient physical in the proof or add assumptions. It becomes
a physical quotient only after the selector is independently justified. Do not
replace the quotient by the range or remove the explicit class equality
theorems.

```yaml
aristotle:
  project_id: 24d6b0ef-6de2-424c-90fc-349efa0f0dfe
  target_file: ChannelSelectorQuotient/Main.lean
  expected_module: ChannelSelectorQuotient.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-selector-quotient-classification-20260711-project
  output_dir: AgentTasks/aristotle-output/24d6b0ef-6de2-424c-90fc-349efa0f0dfe
  status: integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```
