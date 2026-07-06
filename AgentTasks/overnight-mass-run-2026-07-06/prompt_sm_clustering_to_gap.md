Formalize the finite-dimensional CLUSTERING-TO-GAP bridge suggested by the
Faizal-Shabir arXiv:2606.19362 transfer-operator argument.

Desired mathematical content:

For a finite-dimensional positive self-adjoint contraction `T` with a vacuum
eigenvector/eigenspace, prove that temporal exponential decay of matrix
coefficients on a spanning class of vacuum-orthogonal vectors bounds the
non-vacuum spectral radius away from `1`. Equivalently, in finite dimension,
if all relevant vacuum-orthogonal vectors satisfy

```text
|<psi, T^n psi>| <= C psi * exp(-mu n)
```

and those vectors span the vacuum-orthogonal sector, then every non-vacuum
eigenvalue of `T` is at most `exp(-mu)` (or a precisely stated finite variant
with whatever constants Lean naturally supports).

Context:

- `AgentTasks/paper-units/faizal-shabir-2606-19362-mining.md`
- `AgentTasks/context-packs/sm-clustering-to-gap-20260706-061916.md`
- Existing GateYM transfer/gap files, especially `TransferGapDefinition.lean`,
  `SlabTransferGap.lean`, `SlabFullSpectrumGap.lean`, and
  `TwoStateTransferZ2*` modules.

Target:

- Prefer a new module
  `PhysicsSM/Draft/NullEdge/GateYM/ClusteringToGap.lean`.
- Start with the smallest finite theorem that compiles. A scalar/eigenvalue
  lemma is acceptable if the full matrix theorem is too heavy.
- Make the cyclicity/spanning hypothesis explicit. Do not hide it inside prose.
- If possible, add a corollary tailored to a finite transfer block: a proved
  non-vacuum spectral-radius bound implies a positive contraction/generator gap.

Constraints:

- No physical or continuum mass-gap claim.
- No new `a x i o m`, `o p a q u e`, `u n s a f e`, or statement weakening.
- If a proof cannot be closed, leave a precise documented draft handoff rather
  than weakening the theorem.
- Check with `lake env lean PhysicsSM/Draft/NullEdge/GateYM/ClusteringToGap.lean`.
  If broader `lake build` stalls, skip it and report.

Finish with a concise report: theorem statements proved, remaining proof holes,
assumption footprint if checked, and exact commands run.

```yaml
aristotle:
  project_id: cee37f54-1c0e-4a60-b2fa-a71104f69934
  task_id: 8bfeb197-1c81-4461-a25f-80374b87bcaf
  target_file: PhysicsSM/Draft/NullEdge/GateYM/ClusteringToGap.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.ClusteringToGap
  submission_project: AgentTasks/aristotle-submit/sm-clustering-to-gap-20260706-project
  output_dir: AgentTasks/aristotle-output/cee37f54-1c0e-4a60-b2fa-a71104f69934
  status: submitted 2026-07-06 06:25 PDT
```
