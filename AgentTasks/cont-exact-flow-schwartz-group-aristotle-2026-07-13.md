# Aristotle task: exact Dirac flow on Schwartz spinors

- Work item: `CONT-FOURIER-001`
- Role: Builder
- Aristotle project: `debcfc09-3a35-4091-be59-97335fa521bd`
- Target: `AgentTasks/aristotle-targets/afpl_exact_flow_schwartz_group.lean`
- Priority: P95 continuum reconstruction

## Objective

Fill the three proof handoff markers without changing any theorem statement.
The target composes two already kernel-checked inputs:

1. `momMultForGrowth_hasTemperateGrowth`, which permits the exact
   operator-valued multiplier to act continuously on Schwartz spinors through
   `SchwartzMap.bilinLeftCLM`;
2. `exactFlow_add_time`, the exact pointwise matrix time-group law.

The intended result is the exact zero-time, additive-time, and inverse law for
the resulting continuous linear operator on Schwartz space.

## Semantic constraints

- Preserve the order `U(s + t) = U(s) comp U(t)` induced by left matrix action.
- Prove equality of Schwartz maps extensionally; do not add assumptions.
- Do not replace the exact multiplier by an approximation.
- Do not claim an infinitesimal generator, Fourier-conjugated PDE, continuum
  limit, Lorentz invariance, or operator-norm continuity.
- Use no trust-expanding declarations or evaluator shortcuts.

## Verification

Run:

```text
lake env lean AgentTasks/aristotle-targets/afpl_exact_flow_schwartz_group.lean
```

Return the completed target plus a short note on the multiplication/composition
orientation used in the additive-time proof.
