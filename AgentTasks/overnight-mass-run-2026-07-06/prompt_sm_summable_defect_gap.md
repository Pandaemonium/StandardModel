Formalize the SUMMABLE-DEFECT GAP TRANSPORT lemma inspired by the multiscale
interlacing part of Faizal-Shabir arXiv:2606.19362.

The core scalar theorem is:

```text
Delta_{k+1} >= Delta_k - eps_k
sum_k eps_k < Delta_0
--------------------------------
forall k, Delta_k >= Delta_0 - sum_{j < k} eps_j
and inf_k Delta_k >= Delta_0 - sum_j eps_j > 0
```

This should be reusable for YM4/YM5 and is independent of the analytic details
that produce the `eps_k`.

Context:

- `AgentTasks/paper-units/faizal-shabir-2606-19362-mining.md`
- `AgentTasks/context-packs/sm-summable-defect-gap-20260706-061916.md`
- Existing gap bookkeeping in `TransferGapDefinition.lean`,
  `SlabTransferGap.lean`, and nearby GateYM modules.

Target:

- Prefer a new module
  `PhysicsSM/Draft/NullEdge/GateYM/SummableDefectGap.lean`.
- Prove the finite-prefix scalar theorem first using `Finset.range` sums.
- If feasible, prove an infinite-series version using Mathlib summability.
- Optional harder extension: state/prove an operator-level corollary from an
  interlacing inequality such as `T_{k+1} = V^* T_k^b V - D_k + E_k`, with
  `D_k >= 0` and `||E_k|| <= eps_k`, to the scalar recurrence.

Constraints:

- No continuum claim; this is an abstract transport lemma.
- No new `a x i o m`, `o p a q u e`, `u n s a f e`, or statement weakening.
- Keep time-spacing normalization explicit; do not conflate contraction gaps
  with generator gaps unless a separate logarithmic lemma is stated.
- Check with
  `lake env lean PhysicsSM/Draft/NullEdge/GateYM/SummableDefectGap.lean`.
  If broad `lake build` stalls, skip it and report.

Finish with a concise report: proved lemmas, remaining extensions, and exact
commands run.

```yaml
aristotle:
  project_id: 567d98d0-b9bc-4a2e-a746-0dbab1f0283a
  task_id: f67b9eae-be93-42fe-a96e-502d3426ad5c
  target_file: PhysicsSM/Draft/NullEdge/GateYM/SummableDefectGap.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.SummableDefectGap
  submission_project: AgentTasks/aristotle-submit/sm-summable-defect-gap-20260706-project
  output_dir: AgentTasks/aristotle-output/567d98d0-b9bc-4a2e-a746-0dbab1f0283a
  status: submitted 2026-07-06 06:25 PDT
```
