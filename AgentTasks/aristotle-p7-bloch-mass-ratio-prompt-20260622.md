# Aristotle prompt: P7 Bloch mass ratio and observer monotonicity

Please fill the proof holes in:

```text
NullEdgeP7BlochMassRatio/Core.lean
```

This is a focused standalone Mathlib-only package. Do not import the full
PhysicsSM repo.

## Goal

Prove (or refute with a counterexample):

```lean
massRatio_eq_sqrt_one_minus_blochNormSq
massRatio_monotone_under_bloch_contraction
```

`detRho r = lamPlus r * lamMinus r = (1 - |r|^2)/4` since
`(Real.sqrt (blochNormSq r))^2 = blochNormSq r` (the radius is nonnegative).
Hence `massRatio r = 2 sqrt(detRho r) = sqrt(1 - |r|^2)` on the Bloch ball, and
contracting `|r|` raises `1 - |r|^2`, so the mass ratio is monotone under Bloch
contraction.

## Constraints

- Preserve theorem statements exactly unless a statement is genuinely false.
- If false, give the explicit counterexample and corrected hypothesis.
- Do not add assumptions, axioms, or escape hatches.
- Keep the package standalone: Mathlib plus the definitions already in the file.

## Completion report

End with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
