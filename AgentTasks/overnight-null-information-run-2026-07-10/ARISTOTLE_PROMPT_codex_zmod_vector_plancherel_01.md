# Codex proof job: vector-valued finite Plancherel and wave packets

Prove all four theorems in `ZModVectorPlancherel/Core.lean` without changing
the DFT normalization, theorem quantifiers, or the `1/N` inverse-transform
factor. This is the analytic bridge from the paper's compact symbol estimates
to finite periodic `L2` wave-packet propagation.

Priority is `dft_energy`, then `invDFT_energy`, then
`inverseDFT_wavepacket_error`. Use Mathlib's `ZMod.dft_apply`,
`ZMod.invDFT_apply`, additive-character orthogonality, and finite inner-product
sum identities. The theorem is vector-valued; do not weaken it to scalar
complex functions. Preserve the one-mode control so normalization errors are
caught.

If the displayed normalization is false under Mathlib's DFT convention, return
the exact corrected equality and an explicit `N=2` scalar calculation rather
than silently changing it. Run
`lake env lean ZModVectorPlancherel/Core.lean` first.

```yaml
aristotle:
  project_id: 3fb4cfc5-b4d0-4888-9472-85c0f516a3c1
  target_file: AgentTasks/aristotle-standalone/zmod-vector-plancherel-20260710/ZModVectorPlancherel/Core.lean
  expected_module: ZModVectorPlancherel.Core
  submission_project: AgentTasks/aristotle-submit/codex-zmod-vector-plancherel-20260710-project
  output_dir: AgentTasks/aristotle-output/3fb4cfc5-b4d0-4888-9472-85c0f516a3c1
  status: in-progress snapshot landed and locally verified; remote task still running
```

## 2026-07-10 snapshot harvest

Downloaded an in-progress snapshot after roughly forty minutes.  All four
requested declarations were complete with unchanged statements and no proof
placeholders.  The extracted target passed
`lake env lean .../ZModVectorPlancherel/Core.lean` under the repository
toolchain.  The proof was cleaned into
`PhysicsSM/Draft/NullEdge/FiniteZModPlancherel.lean`, given build-enforced
assumption-footprint guards, and added to the draft root.  The remote task was
left running so Aristotle can finish its own verification and packaging.
