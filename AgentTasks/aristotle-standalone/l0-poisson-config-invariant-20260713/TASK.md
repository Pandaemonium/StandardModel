# Codex finite Poisson-law invariance target

Prove both holes in `PoissonConfigInvariant.lean`, culminating in
`configLaw_invariant`. Preserve the explicit mixed-Poisson definition and the
distinction between invariance in law and pointwise fixed support.

Run first:

```text
lake env lean PoissonConfigInvariant.lean
```

Likely ingredients are measurability of dependent sigma maps,
`MeasurePreserving.pi`, and map/bind congruence. Add local helper lemmas if
needed. Do not assume the desired measure equality. Return a file with no proof
holes or trust-expanding declarations and report any API obstruction precisely.
