# P11 channel-sector strategy report

Source Aristotle job: `40413c03-ef9e-4692-be1e-7a60df4ce689`.

## High-level result

Aristotle understood the assignment and returned a useful scaffold rather than
trying to prove the whole ontology. The strongest recommendation is to make the
particle-sector lane depend on a calibrated readout:

```text
unnormalized momentum block P
normalization rho = P / Tr(P)
scale = Tr(P)
readout = (rho, scale)
reconstruct(readout) = scale * rho
```

This is the clean guardrail for P11: a normalized channel state can preserve
probability while losing the absolute energy scale. Particle mass cannot be
defined from the normalized state alone.

## Minimal data

- `MomentumBlock`: an unnormalized `2 x 2` complex momentum block.
- `massSq(P) = det(P)`: invariant mass-square candidate.
- `normalize(P) = (Tr P)^(-1) P`: observer/channel normalized state.
- `Readout`: normalized state plus discarded scale.
- `reconstruct`: returns the unnormalized block from readout data.
- `T`: finite transfer operator/channel for spectral sector analysis.
- Peripheral sector: eigenvalue modulus `1`.
- Metastable sector: eigenvalue modulus strictly between `0` and `1`.
- Lifetime: `tau = -Delta t / log |lambda|`.
- Branch form: `lambda(k) ~= exp(-((Gamma(k)/2) + i E(k)) Delta t)`.
- On-shell energy: `E(k)^2 = |k|^2 + m^2`.

## Best theorem targets

1. `det_normalize_eq_det_div_trace_sq`: normalization rescales determinant by
   the squared trace.
2. `reconstruct_readout`: if `Tr(P)` is nonzero, calibrated readout reconstructs
   `P`.
3. `normalized_channel_loses_energy_scale`: two blocks can have the same
   normalized state but different determinant mass.
4. `peripheral_preserves_norm`: a peripheral eigenmode preserves norm in one
   step.
5. `peripheral_iterate_preserves_norm`: a peripheral eigenmode preserves norm
   under iteration.
6. `sector_compose_eigenvalue`: composed transfers multiply eigenvalues.
7. `lifetime_pos`: a metastable eigenvalue gives positive lifetime.
8. `branch_lifetime_eq_inverse_width`: for a decay branch, lifetime is `2/Gamma`.
9. `energy_massShell`: `sqrt(k^2 + m^2)` satisfies the mass-shell identity.

## Most important warning

Do not define mass, particle identity, or charge on a bare normalized state or a
generic CPTP output. A normalized channel can describe information flow, but it
does not preserve the absolute momentum/energy scale needed for invariant mass.
Every P11 theorem should consume either `P` itself or `(rho, Tr(P))`.

## Next Aristotle job

Run a focused proof package for the calibrated-readout core:

```text
null-edge-p11-readout-core
```

Targets:

- determinant rescaling under normalization;
- exact reconstruction from `(normalize(P), Tr(P))`;
- explicit counterexample showing normalized state alone loses mass scale.

This should come before spectral-sector theorems, because the readout scale is
the part that prevents the particle-sector ontology from silently becoming an
`m/E`-only theory.
