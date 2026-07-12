# Aristotle task: pure product-cover block kernel core

Status: landed as a guarded draft algebra module.

Target:
`JCBlockKernelCore/JCBlockKernelCore.lean` in the focused package generated
from
`AgentTasks/aristotle-standalone/codex-24h-jc-block-kernel-core-20260711/`.

Prove both declarations without weakening their statements. Run the target file
first. The main theorem is pure matrix algebra: the pointwise relation is the
entrywise form of `A tensorProduct B = 1`; it should force reciprocal scalar
blocks. The determinant-one factors and the common powers `p^3` and `p^-2`
then force the scalar to be one.

Small helper lemmas about diagonal entries, matrix determinants, scalar
matrices, or finite extensionality are welcome. Do not add new assumptions.

The control theorem must remain nontrivial: it shows exactly why the
determinant/common-phase hypotheses matter.

Manuscript consequence after integration with the already harvested exterior
minor lemma: closes the pure algebraic hinge of the exact continuous `Z6`
kernel theorem. It does not by itself prove the exterior-action reduction,
topological quotient, Lie-group smoothness, Furey intertwining, or a physical
gauge-group derivation.

```yaml
aristotle:
  project_id: 9775ac99-270a-4f19-99ed-b9236b715491
  target_file: JCBlockKernelCore/JCBlockKernelCore.lean
  expected_module: focused handoff only
  submission_project: AgentTasks/aristotle-submit/codex-24h-jc-block-kernel-core-20260711-project
  output_dir: AgentTasks/aristotle-output/9775ac99-270a-4f19-99ed-b9236b715491
  status: landed
```

## 2026-07-11 15:18 PDT harvest

Both returned declarations are proof-complete and independently compiled in
the live pinned toolchain. They were integrated as
`PhysicsSM.Draft.JordanCliffordBlockKernelCore`, with the reciprocal-scalar
control and build-enforced axiom pins. Targeted module build passed.

This closes the pure matrix hinge only. The exact exterior-action kernel still
requires the exterior-square-to-block relation and final composition with the
trusted true product-cover kernel theorem.
