# Codex Aristotle target: fixed-momentum many-step Dirac-walk convergence

Prove every theorem in `ManyStep/Continuum.lean` without changing definitions,
weakening statements, or replacing explicit constants by assumptions. Run:

```text
lake env lean ManyStep/Continuum.lean
```

## Prize theorem

For the explicit split-step walk

```text
W(eps) = exp(-i k eps sigma_z) exp(-i m eps sigma_x),
H = k sigma_z + m sigma_x,
V(t) = exp(-i t H),
```

prove in Mathlib's `Matrix.Norms.L2Operator` norm that

```text
||W(t/n)^n - V(t)|| <= D(k,m) t^2/n
```

and then the corresponding `Tendsto` theorem at fixed `(k,m,t)`.

## Required proof structure

- Prove the explicit walk and exact flow are unitary.
- Prove the local `O(eps^2)` comparison with the displayed generous `Dkm`.
- Prove the unitary power telescope with coefficient exactly `n`, with no
  exponential growth factor.
- Prove the exact flow semigroup/power identity.
- Preserve the fixed-momentum boundary: no spacetime kernel, PDE, uniform
  momentum, or `3+1` claim.
- The local comparison may use the standard Banach-algebra exponential-series
  remainder bound, the explicit entries, or a stronger intermediate estimate.
- If `Dkm` is mathematically insufficient, demonstrate the exact failed bound
  before proposing a larger explicit constant. Do not silently alter it.

This target follows Fable's 2026-07-09 manuscript review and the landed
one-step `QuantitativeDiracWalkContinuum` result. Clean-room Mathlib proof only.

Context pack:
`AgentTasks/context-packs/fixed-momentum-many-step-20260709-20260709-184652.md`.

```yaml
aristotle:
  project_id: 8984157c-93a5-4cc2-98f5-56aa0ae16d6b
  target_file: ManyStep/Continuum.lean
  expected_module: ManyStep.Continuum
  submission_project: AgentTasks/aristotle-submit/codex-fixed-momentum-many-step-20260709-1847-project
  output_dir: AgentTasks/aristotle-output/8984157c-93a5-4cc2-98f5-56aa0ae16d6b
  snapshot: AgentTasks/aristotle-output/8984157c-93a5-4cc2-98f5-56aa0ae16d6b-snapshot.tar.gz
  status: canceled_partial_after_two_hour_stall
```

Snapshot audit: six targets are proof-complete; four remain open
(`walk_sub_firstOrder_bound`, `one_step_to_exact_flow_bound`,
`fixed_time_many_step_bound`, and `fixed_time_many_step_tendsto`). The completed
unitarity, local-entry, exponential-remainder, unitary-telescope, and exact-flow
power lemmas are preserved for a smaller follow-up. No many-step convergence
claim has landed.
