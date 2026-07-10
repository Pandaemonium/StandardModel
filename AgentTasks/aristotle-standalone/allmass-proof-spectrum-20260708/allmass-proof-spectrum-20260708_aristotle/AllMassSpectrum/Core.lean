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

/-- The characteristic determinant `det (r•1 - B)` factors as
`(r - lam) * ((r - lam)^2 - kappa^2)`, the product form of the carrier-block
characteristic polynomial evaluated at a real scalar `r`. -/
theorem B_det_sub (lam kappa r : ℝ) :
    (algebraMap ℝ (Matrix (Fin 3) (Fin 3) ℂ) r - B lam kappa).det
      = ((r : ℂ) - lam) * (((r : ℂ) - lam) ^ 2 - (kappa : ℂ) ^ 2) := by
  rw [Matrix.det_fin_three]
  simp only [algebraMap, Algebra.algebraMap, Matrix.sub_apply, B,
    Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_fin_one, Matrix.empty_val']
  simp [Matrix.diagonal]
  ring_nf
  rw [Complex.I_sq]
  ring

/-- **Full spectrum of the carrier mass block.** The `ℝ`-spectrum (set of
eigenvalues) of the `3×3` Hermitian block `B lam kappa` is exactly
`{lam - kappa, lam, lam + kappa}`: aperture-minus-closure, aperture, and
aperture-plus-closure. -/
theorem B_spectrum (lam kappa : ℝ) :
    spectrum ℝ (B lam kappa) = {lam - kappa, lam, lam + kappa} := by
  ext r
  rw [spectrum.mem_iff, Matrix.isUnit_iff_isUnit_det, isUnit_iff_ne_zero, not_ne_iff,
    B_det_sub]
  rw [Set.mem_insert_iff, Set.mem_insert_iff, Set.mem_singleton_iff]
  have hfac : ((r : ℂ) - lam) * (((r : ℂ) - lam) ^ 2 - (kappa : ℂ) ^ 2)
      = ((((r - (lam - kappa)) * (r - lam) * (r - (lam + kappa))) : ℝ) : ℂ) := by
    push_cast; ring
  rw [hfac, Complex.ofReal_eq_zero, mul_eq_zero, mul_eq_zero]
  constructor
  · rintro ((h | h) | h)
    · left; linarith [sub_eq_zero.mp h]
    · right; left; linarith [sub_eq_zero.mp h]
    · right; right; linarith [sub_eq_zero.mp h]
  · rintro (h | h | h) <;> subst h
    · left; left; ring
    · left; right; ring
    · right; ring

end AllMassSpectrum
