# Aristotle prompt: P9 finite fluctuation scaling

Please fill the proof holes in:

```text
NullEdgeP9FluctuationScaling/Core.lean
```

This is a focused standalone Mathlib-only package. Do not import the full
PhysicsSM repo.

## Goal

Prove the finite sign-source fluctuation identities in the provided file. The
physics motivation is the P9 cosmological-constant/source-visibility branch:
before making any continuum claim, we need a kernel-checked finite theorem that
a sign-changing source has zero ensemble mean but variance proportional to the
number of cells.

The main target is:

```lean
ensembleSecondMoment_eq_card_times_configs
```

which says:

```text
sum_cfg totalSource(cfg)^2 = N * 2^N
```

Equivalently, after normalizing by the number of configurations, the variance is
`N` and the RMS fluctuation scales like `sqrt(N)`.

## Constraints

- Preserve every theorem statement exactly unless you find a genuine falsehood.
- Do not add new assumptions, axioms, or escape hatches.
- If a target is false, explain the issue instead of weakening it silently.
- Prefer small helper lemmas inside the same file if they simplify the proof.
- Keep the package standalone: Mathlib plus the definitions already in the file.

## Completion report

End your response with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
