# Codex non-equivariant decoration kill target

Prove `PoissonDecorationKill.arbitrary_decoration_breaks_invariance` with a
fully explicit finite witness, preferably `Y = Bool`, the uniform probability
measure, and `T = Bool.not`.

Run first:

```text
lake env lean PoissonDecorationKill.lean
```

The witness must be nontrivial: prove the bare law is preserved and the two
decorated pushforwards differ on an explicit measurable singleton or diagonal
event. Do not weaken the conclusion to unequal functions. Return a file with no
proof holes or trust-expanding declarations.
