# Claude adversarial review: PositionDiracSchwartzOperator (b064c004)

- Reviewer: interactive Claude Code (claude family), adversarial
- Work item: `CONT-FOURIER-001`; Source sha256 765d6ed0... verified (111 lines)
- Date: 2026-07-13

## Verdict: ACCEPT

Continuum rung T2-A: packages the position-space free Dirac differential
expression as a genuine continuous linear endomorphism of Schwartz spinors and
upgrades the Fourier symbol theorem to the packaged operator.

## Checks

- **Continuity packaging.** `matrixActionSchwartzCLM A = bilinLeftCLM (apply)
  (HasTemperateGrowth.const (matrixAction A))` -- the constant matrix action is
  trivially temperate, so `bilinLeftCLM` packages it as a Schwartz->Schwartz CLM.
  `positionDiracSchwartzCLM` is then a sum/scalar-multiple/composition of CLMs
  (`matrixActionSchwartzCLM alpha_j` composed with `lineDerivOpCLM (basisDirection
  j)`, plus `m * matrixActionSchwartzCLM beta`), hence a genuine continuous
  endomorphism of `SpinorSchwartz`.
- **Coordinate directions.** `basisDirection j = EuclideanSpace.single j 1` (unit
  vector in direction `j`); the three spatial terms use `j = 0, 1, 2`. Correct.
- **Exact `-I/(2*pi)` normalization.** Retained verbatim as the scalar in front
  of the spatial block. Matches the audited raw expression.
- **Pointwise agreement.** `positionDiracSchwartzCLM_apply`: the packaged operator
  evaluates to the raw `positionDirac m g x` at every point (via
  `bilinLeftCLM_apply`, `lineDerivOpCLM_apply`, then `rfl`).
- **Fourier orientation.** `fourier_positionDiracSchwartzCLM`: reduces
  `SchwartzMap.fourierTransformCLM` to the raw `𝓕` (via `fourierTransformCLM_apply`
  + `fourier_coe`), then applies the audited `fourier_positionDirac` capstone, so
  the packaged operator's transform equals `matrixAction (H w) (𝓕 g w)`.
- **Prose below generator/PDE/L2.** Docstring: "still a fixed-continuum
  Schwartz-domain result. It does not yet prove that the exact time group is
  differentiable in the Schwartz topology, identify the closed `L2` generator, or
  establish the changing-lattice limit." Correct -- this packages the SPATIAL
  Dirac operator + symbol identity, not a time generator, closed-L2 generator, or
  PDE.

## Overclaim tests

Vacuity: none (`positionDiracSchwartzCLM_zero` control + genuine packaging).
Hollow: none (CLM packaging + symbol upgrade are real). Docstring overreach:
none. False shape: none -- a continuous Schwartz endomorphism plus its Fourier
symbol identity, explicitly not a generator/PDE.

## Verification

- `lake build ...PositionDiracSchwartzOperator`: exit 0. Three `#guard_msgs`
  fired; `[propext, Classical.choice, Quot.sound]`, build-enforced.

## Narrowest claim

The free position-space Dirac differential expression, with Mathlib's `-I/(2*pi)`
normalization, is a continuous linear endomorphism of four-component Schwartz
space whose forward Fourier transform equals multiplication by the affine
momentum symbol `H(w)`. Fixed-continuum, Schwartz-domain; no differentiability of
the time group in the Schwartz topology, no closed-`L2` generator, no PDE, and no
changing-lattice limit is claimed.
