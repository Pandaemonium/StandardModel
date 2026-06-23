# Aristotle task: P9 harmonic-kernel core

```yaml
aristotle:
  project_id: 0a6aa9da-d023-4af4-a70a-d966975b8b84
  target_file: NullEdgeP9HarmonicKernelCore/Core.lean
  expected_module: NullEdgeP9HarmonicKernelCore
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-harmonic-kernel-core-20260623-project
  output_dir: AgentTasks/aristotle-output/0a6aa9da-d023-4af4-a70a-d966975b8b84
  status: integrated
  integrated_file: PhysicsSM/Draft/NullEdgeP9HarmonicKernelCore.lean
  integrated_module: PhysicsSM.Draft.NullEdgeP9HarmonicKernelCore
```

Focused standalone proof job.

Scientific role: prove the Tier-B finite Hodge kernel theorem for P9. With
positive diagonal metric weights, the kernel of the weighted finite 1-Laplacian
should coincide with closed and coclosed 1-cochains. This is the theorem that
turns the P9 slogan `ker d cap ker delta` into a concrete finite algebra target.

## Local target

```text
AgentTasks/aristotle-standalone/null-edge-p9-harmonic-kernel-core-20260623/
  NullEdgeP9HarmonicKernelCore/Core.lean
```

Local check before submission:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-harmonic-kernel-core-20260623/NullEdgeP9HarmonicKernelCore/Core.lean
```

This target currently has intentional proof handoff holes in standalone code.

## Submission note

Submitted as Aristotle project `0a6aa9da-d023-4af4-a70a-d966975b8b84`.

## Integration note

Integrated on 2026-06-23 as
`PhysicsSM.Draft.NullEdgeP9HarmonicKernelCore`.

The integrated theorems are:

- `dotW_self_eq_zero_iff_of_pos`
- `weighted_adjoint_coboundary_codiff`
- `weighted_lap1_energy_eq_down_plus_up`
- `harmonic_iff_closed_and_coclosed`

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9HarmonicKernelCore.lean
lake build PhysicsSM.Draft.NullEdgeP9HarmonicKernelCore
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9HarmonicKernelCore.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9HarmonicKernelCore.lean
```

All targeted checks passed. Aristotle's returned proof used Unicode tactic
syntax and symbols; the integrated proof was translated to ASCII Lean control
flow and notation.
