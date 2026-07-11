# Aristotle audit task: finite Pluecker interaction and paper claim

Adversarially audit the exact included `FiniteCARFockBasic.lean`,
`PlueckerQuarticInteraction.lean`, and current Paper I.

The live target passes `lake env lean
PhysicsSM/Draft/NullEdge/PlueckerQuarticInteraction.lean`; this focused package
is for semantic review, not reproduction of the full import graph.

Check:

- whether `pairForward` and `pairBackward` have the stated occupation and sign
  conventions;
- whether the forward/reverse amplitudes really are `z` and `conj z`;
- whether the `3+4i` primitive-spinor witness is nondegenerate;
- whether `pairKick_involutive` plus `pairKick_preserves_fockNormSq` supports
  the manuscript phrase “finite unitary interacting operation”;
- whether the kick is actually derived from, equal to, or the exponential of
  `quarticPairTransfer` (the paper must not imply this if it is unproved);
- whether the reparametrization table accurately separates a constructed
  Pluecker-sensitive extension from a consequence forced by the free action.

Apply the four overclaim tests and return severity-ordered findings with exact
declaration and manuscript references.  State the strongest precise theorem
still needed to connect the quartic operator, the kick, and the spatial Fock
lift.  Do not edit or weaken source statements.

```yaml
aristotle:
  project_id: 5866ef65-5307-491b-bd20-9b6c9e4d2a0c
  task_id: 2eef9aad-051b-4c4d-b07d-370f17ab326e
  target_file: PlueckerInteractionAudit/Main.lean
  expected_module: PlueckerInteractionAudit.Main
  submission_project: AgentTasks/aristotle-submit/pluecker-interaction-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/5866ef65-5307-491b-bd20-9b6c9e4d2a0c
  status: completed-and-harvested
  report: AgentTasks/aristotle-output/5866ef65-5307-491b-bd20-9b6c9e4d2a0c/extracted/project-files.tar/pluecker-interaction-audit-20260710-project_aristotle/AUDIT_REPORT.md
```
