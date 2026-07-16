# Aristotle task: exact Schwartz Fourier/Dirac capstone

## Objective

Complete all three proof holes in
`AgentTasks/aristotle-targets/afpl_fourier_dirac_schwartz_capstone.lean`
without changing any declaration statement or definition.

The capstone must prove that the displayed position-space differential
expression, normalized by `-I / (2*pi)` for Mathlib's forward Fourier
convention, transforms exactly to the repository matrix symbol
`H (w 0) (w 1) (w 2) m` on Schwartz spinors.

## Semantic requirements

- Preserve the explicit `2*pi` normalization.
- Preserve all three spatial coordinates and the mass term.
- Do not assume the desired Fourier identity.
- Do not replace the statement by a componentwise restatement of the already
  landed derivative lemma.
- The result is only a Schwartz-domain generator-symbol identity. Do not claim
  a closed `L2` generator theorem, changing-lattice PDE convergence, or Lorentz
  restoration.

## Useful landed inputs

- `FourierPartialCorrespondence.fourier_partial_correspondence`
- `Compact3Plus1DiracRate.H`
- `Matrix.toEuclideanCLM`
- `ContinuousLinearMap.integral_comp_comm`
- Fourier additivity and scalar linearity from Mathlib notation

## Success criteria

- The target file builds under the pinned project toolchain.
- No proof holes or trust-expanding declarations remain.
- The four declaration statements and both definitions remain unchanged.
- Report the exact Fourier convention and any Mathlib API obstruction.

## Aristotle metadata

- Work item: `CONT-FOURIER-001`
- Hat: Builder
- Priority: P0
- Requested trust: kernel-checked standard-three footprint only
- Aristotle project: `c8b815ee-f0fa-44ca-af6d-2ad3cf4bae86`
