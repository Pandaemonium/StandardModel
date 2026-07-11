# Aristotle hostile audit: Jordan-Clifford finite cover kernel

Name this project `codex-24h-jc-kernel-hostile-audit-20260711`.

Audit the live file
`PhysicsSM/Draft/JordanCliffordFermionKernel.lean` adversarially. Read its
definitions verbatim and independently recompute the center phase from:

```text
SU(3) center phase = exp(2 pi i k3 q / 3)
SU(2) center phase = (-1)^(k2 p)
6Y = 3 p - 2 q
U(1) sixth-root phase = exp(2 pi i m (6Y) / 6).
```

Required checks:

1. Verify that the six listed weak/color bidegrees are exactly the even
   sectors of `exterior(W direct_sum V)` for dimensions two and three.
2. Verify the sign and normalization of `centralPhase`.
3. Verify that `fermionCentralKernel_eq_standardPowers` proves exact equality,
   not only cardinality, and that `standardKernelPower` is injective.
4. Attempt to falsify all three controls and find any omitted central control.
5. State precisely what is still missing before this becomes a theorem about
   the actual covering-group representation on the repository's five-mode
   fermion module.
6. Audit the claim that `S(U(2) x U(3))` acts faithfully and that `Z6` belongs
   to the cover kernel, using the repository gauge modules. Flag any scope or
   convention mismatch.

Do not edit or weaken the theorem. Return `AUDIT.md` with findings ordered by
severity and one exact manuscript-safe sentence. If a mathematical error is
found, provide the smallest corrected phase/kernel statement.

```yaml
aristotle:
  project_id: 83a0b810-896e-4166-b997-5f953874d93e
  task_id: pending
  target_file: PhysicsSM/Draft/JordanCliffordFermionKernel.lean
  expected_module: PhysicsSM.Draft.JordanCliffordFermionKernel
  submission_project: AgentTasks/aristotle-submit/codex-24h-jc-kernel-hostile-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/83a0b810-896e-4166-b997-5f953874d93e
  status: harvested-addressed
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
