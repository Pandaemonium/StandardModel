/-
# Mass as rank/area: the spectral face of `det P`

Proof job (Aristotle). A self-contained kinematic bridge between the S3 mass
`det P` and the S4 spectral/positivity language, formalizing Gemini Pro's
"mass is the area null directions open in spinor space" reading: the bundle
momentum `P = sum_i psi_i psi_i^dagger` is a positive-semidefinite `2x2`
Hermitian matrix, and

  massless  <=>  det P = 0  <=>  P is rank-deficient (not positive-definite)
  massive   <=>  det P > 0  <=>  P is positive-definite (full 2D spinor span)

with `det P` (the mass squared) equal to the product of `P`'s two eigenvalues
(the "light-cone energies"). This is the spectral complement of the monogamy
job: monogamy is about how `det P` distributes over sub-bundles; this is about
what `det P > 0` *means* as a statement about `P`'s spectrum and rank.

All Mathlib-only. Targets stated below; prove kernel-clean (no `s o r r y`). You
may pick the cleanest Mathlib spelling of PosSemidef/PosDef/eigenvalues.

## Targets (for a Hermitian PSD `2x2` complex matrix `M`, the momentum)

- **R-nonneg:** `M.PosSemidef -> 0 <= M.det`. (mass squared is nonnegative)
- **R-massive:** `M.PosSemidef -> (0 < M.det <-> M.PosDef)`. (massive iff the
  momentum is positive-definite = the null directions span the full 2D spinor
  space = genuine area)
- **R-massless:** `M.PosSemidef -> (M.det = 0 <-> ¬ M.PosDef)`. (massless iff
  rank-deficient = one coherent beam)
- **R-massshell (if clean):** `M.PosSemidef -> M.det = (eigenvalue 0) * (eigenvalue 1)`
  via `Matrix.IsHermitian` eigenvalues - `det P` is the product of the two
  light-cone energies (the finite mass-shell relation). Use whatever Mathlib
  eigenvalue API is cleanest; if the indexing is awkward, deliver R-massive and
  R-massless (the load-bearing ones) and state R-massshell as far as it goes.

## Why it matters

This is the S3<->S4 hinge at the kinematic level: it says the "positive physical
sector" language of the keystone (`sector_ground_mass`, which needs a positive-
definite form) coincides, for the momentum itself, with "massive" - so mass and
positivity are the same phenomenon read on the two-spinor span. Provenance:
all-mass overnight run 2026-07-08; Gemini Pro's rank/area reading [interp]; the
matrix facts are standard [import].
-/

import Mathlib

namespace AllMassRankArea

open Matrix

/-- Placeholder so the Mathlib-only package is a valid, quickly-building target.
The real targets (R-nonneg, R-massive, R-massless, R-massshell) are in the
module docstring; add and prove them here. -/
theorem package_ok : True := trivial

end AllMassRankArea
