# Claude adversarial review: FourierDiracSchwartzCapstone (c8b815ee)

- Reviewer: interactive Claude Code (claude family), adversarial
- Work item: `CONT-FOURIER-001`; Source sha256 b06818f6... verified (229 lines)
- Date: 2026-07-13

## Verdict: ACCEPT

Exact Schwartz-domain Fourier symbol identity: the position-space free Dirac
differential expression transforms to multiplication by the momentum symbol `H`.

## The claimed identity

`fourier_positionDirac`: `𝓕 (positionDirac m g) = fun w => matrixAction (H (w 0)
(w 1) (w 2) m) (𝓕 g w)`, where
`positionDirac m g x = (-I/(2 pi)) • (alpha1 d_0 g + alpha2 d_1 g + alpha3 d_2 g)
+ m • beta (g x)`.

## Checks

- **Forward-Fourier sign + 2*pi convention + the -I/(2*pi) coefficient.** Uses
  `fourier_partial_correspondence` (`𝓕(d_j g) = +2*pi*I*w_j * 𝓕 g`, Mathlib
  forward convention, previously reviewed). The coefficient cancellation
  `hscal : c * (2*pi*I*z) = z` with `c = -I/(2*pi)` is proved via `field_simp` +
  `Complex.I_sq` (`I^2 = -1`): `(-I/(2*pi)) * (2*pi*I) = -I^2 = 1`. So each
  spatial term becomes `w_j * alpha_j * 𝓕 g`, exactly assembling
  `alpha1 w_0 + alpha2 w_1 + alpha3 w_2 + m beta = H(w)`.
- **Matrix action orientation.** `matrixAction A = toEuclideanCLM A` (left
  action). `fourier_matrixAction` pulls the bounded operator out of the Fourier
  integral via `ContinuousLinearMap.integral_comp_comm`. Final `unfold H
  matrixAction; simp [map_add, map_smul, ...]` confirms `H(w)` applied equals the
  summed spatial + mass action. Orientation correct.
- **Integrability / Schwartz-domain hypotheses.** `positionDirac_integrable`
  proves the whole expression integrable from `SchwartzMap.fderivCLM.integrable`
  and `matrixAction.integrable_comp`. Every Fourier-linearity step (`hFadd`,
  `hFsmul`, `hterm`) carries an integrability proof; `hIntegrand` shows the
  Fourier integrand is integrable because `𝐞` has norm one. Nothing assumed; the
  Schwartz domain is explicit (`g : SchwartzMap`).
- **Symbol equality.** As above, exact.

## Overclaim tests

Vacuity: none (`fourier_positionDirac_zero` control + genuine identity). Hollow:
none (real work: `fourier_matrixAction`, term-by-term Fourier, coefficient
cancellation, `H` assembly). Docstring overreach: none -- "a generator-symbol
theorem on Schwartz functions. It is not a claim about the domain of the closed
`L2` generator, changing-lattice convergence, or a completed PDE reconstruction."
False shape: none -- this is the SPATIAL position<->momentum symbol identity, NOT
a time-evolution PDE (there is no `d_t`). No hidden all-time PDE or lattice-limit
promotion.

## Verification

- `lake build ...FourierDiracSchwartzCapstone`: exit 0 (8044 jobs). Four
  `#guard_msgs` fired; `[propext, Classical.choice, Quot.sound]`, build-enforced.

## Narrowest claim

For every Schwartz spinor `g`, the normalized position-space free Dirac
differential expression `(-I/(2 pi)) sum_j alpha_j d_j g + m beta g` has forward
Fourier transform equal to `matrixAction(H(w)) (𝓕 g w)`, i.e. multiplication by
the exact free momentum symbol `H`. This is an exact Schwartz-domain Fourier
symbol identity for the spatial Dirac expression; it is not a time-evolution PDE,
a closed-`L2` generator-domain statement, or a lattice/continuum-limit theorem.
