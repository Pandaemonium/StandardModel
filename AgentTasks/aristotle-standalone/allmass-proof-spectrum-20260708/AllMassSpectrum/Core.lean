/-
# The full spectrum of the carrier mass block is {lam-kappa, lam, lam+kappa}

Proof job (Aristotle). Mathlib-only. The carrier sector mass block

  B(lam, kappa) = !![lam, kappa*I, 0; -kappa*I, lam, 0; 0, 0, lam]

(aperture lam, closure kappa, both real) is Hermitian. Its determinant is
lam*(lam^2 - kappa^2) and its LEAST eigenvalue is lam-kappa (already known). This
job asks for the COMPLETE spectrum as a set.

## Target (prove kernel-clean, no `sorry`)

- **B_spectrum:** `spectrum ℝ (B lam kappa) = {lam - kappa, lam, lam + kappa}`
  (as a `Set ℝ`), i.e. the eigenvalues are exactly aperture-minus-closure,
  aperture, and aperture-plus-closure. Equivalently, deliver the characteristic
  polynomial factorization `charpoly = (X - lam)(X - (lam-kappa))(X - (lam+kappa))`
  and/or `Set.range (B_isHermitian lam kappa).eigenvalues = {lam-kappa, lam,
  lam+kappa}` — whichever Mathlib's Hermitian-eigenvalue / spectrum API supports
  most cleanly. Keep `B` and `B_isHermitian` as given.

This completes the spectral picture of the mass phase diagram (the least
eigenvalue lam-kappa is the squared mass gap = aperture - closure; the full
spectrum shows the three physical-sector mass levels). Report semantic alignment.

Provenance: all-mass solo run 2026-07-08 [orig]; strengthens B_least_eigenvalue
of MassGapWitness. Run `lake env lean AllMassSpectrum/Core.lean`. Commit + push.
-/

import Mathlib

namespace AllMassSpectrum

open Matrix Complex
open scoped ComplexOrder

/-- The carrier-sector `3x3` Hermitian mass block. -/
noncomputable def B (lam kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![(lam : ℂ), (kappa : ℂ) * Complex.I, 0;
     -((kappa : ℂ) * Complex.I), (lam : ℂ), 0;
     0, 0, (lam : ℂ)]

theorem B_isHermitian (lam kappa : ℝ) : (B lam kappa).IsHermitian := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp +decide [ B ]

/-- Placeholder. Replace with `B_spectrum` (and any helper lemmas), kernel-clean. -/
theorem package_ok : True := trivial

end AllMassSpectrum
