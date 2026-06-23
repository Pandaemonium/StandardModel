# Aristotle prompt: P9 everpresent-Lambda suppression tension

Please fill the proof holes in:

```text
NullEdgeP9EverpresentLambdaTension/Core.lean
```

This is a focused standalone Mathlib-only package. Do not import the full
PhysicsSM repo.

## Goal

Prove (or refute, with a counterexample) the two finite suppression claims:

```lean
uniformSecondMoment_antitone
uniformSuppression_below_everpresent
```

`everpresentSecondMoment N = N` is the everpresent-Lambda variance; spreading a
fixed total scale `A` over `N` independent sign cells gives
`uniformSecondMoment A N = A^2 / N`. The claims are that the suppressed residual
is antitone in `N` and, when the total scale is sub-extensive (`A^2 < N^2`),
strictly below the everpresent residual.

## Constraints

- Preserve theorem statements exactly unless a statement is genuinely false.
- If a statement is false, give the explicit counterexample and the corrected
  hypothesis (this is a useful result, not a failure).
- Do not add assumptions, axioms, or escape hatches to force a proof.
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
