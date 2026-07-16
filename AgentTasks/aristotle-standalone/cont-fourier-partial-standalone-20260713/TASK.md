# Codex Fourier partial-derivative target

Prove `FourierPartialStandalone.fourier_partial_correspondence` without changing
its statement, Fourier-transform direction, sign, scalar field, or explicit
`2 * pi` factor.

Run first:

```text
lake env lean FourierPartialStandalone.lean
```

Use Mathlib's Schwartz/Fourier API, especially the full Frechet-derivative
Fourier theorem and the theorem moving a continuous-linear-map application
inside the Fourier integral. Small reusable helper lemmas are welcome. Do not
replace the theorem by a differently normalized transform. Return a file with
no proof holes or trust-expanding declarations and report any statement change.
