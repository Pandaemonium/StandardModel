/-
# The carrier sector mass gap is aperture minus closure

DRAFT. Kernel-checks the phase-diagram result of the dynamics spectrum simulator
(`Scripts/oracle/carrier_spectrum_sim.py`) and generalizes `T2_positive_mass`
from the fixed point `(lam,kappa) = (2,1)` to the whole coupling plane.

On the two-edge `Cl(4)` carrier the physical-sector mass form is block-diagonal
with the `3x3` Hermitian block

  B(lam, kappa) = !![lam, kappa*I, 0; -kappa*I, lam, 0; 0, 0, lam]   (I = Complex.I)

(aperture strength `lam`, closure strength `kappa`, both real). Its determinant
is `lam*(lam^2 - kappa^2) = lam*(lam - kappa)*(lam + kappa)`, so the block is
singular exactly on `lam = 0` or `kappa = +-lam` - the **massless critical line
`kappa = lam`** for the physical branch `0 < lam`, `0 <= kappa`. Off that line
the squared mass gap (least eigenvalue) is `lam - kappa` = *aperture minus
closure*, and the state is massive iff `|kappa| < lam`.

## Status of the four targets

- `B_isHermitian`  - **landed** (this file, kernel-clean).
- `B_det`          - **landed** (this file, kernel-clean): `det = lam*(lam^2-kappa^2)`.
- `B_massless_iff` - **landed** (this file, kernel-clean): the critical line, from
  `B_det` under the physical hypothesis `0 < lam`.
- `B_posDef_iff`   - the positive-definiteness equivalence `B.PosDef <-> |kappa| < lam`.
  Handed to Aristotle (standalone package `AgentTasks/aristotle-standalone/
  allmass-massgap-20260708`); this file states it and leaves a documented
  `s o r r y` handoff until that proof lands. The elementary route: for Hermitian
  `B`, `B.PosDef` iff the quadratic form is positive, and
  `x^H B x = lam*‖x‖^2 - 2*kappa*Im(conj x0 * x1)`, which is `>= (lam-|kappa|)*‖x‖^2`
  by `|Im(conj x0 x1)| <= (|x0|^2+|x1|^2)/2`; the converse uses the eigenvector
  `(1, -I, 0)` (eigenvalue `lam - kappa`).

This is a **draft handoff**, not a landed flagship: `B_posDef_iff` carries a
`s o r r y`. Do not cite the PosDef branch as **M** until the handoff closes and
the guard pin is added.

## Provenance

All-mass solo run 2026-07-08 [orig]; kernel-checks `carrier_spectrum_sim.py` and
generalizes `T2_positive_mass` (`SectorGroundMassWitness`). Uses Mathlib
`Matrix.det_fin_three`, `Matrix.IsHermitian` [import].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness

open Matrix Complex
open scoped ComplexOrder

/-- The physical-sector mass block `B(lam, kappa)` of the two-edge `Cl(4)`
carrier: aperture `lam` on the diagonal, closure `kappa` as the skew imaginary
off-diagonal of the first `2x2` block. -/
def B (lam kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![(lam : ℂ), (kappa : ℂ) * Complex.I, 0;
     -((kappa : ℂ) * Complex.I), (lam : ℂ), 0;
     0, 0, (lam : ℂ)]

/-- **`B` is Hermitian.** The closure entry `kappa*I` is skew (`conj (kappa*I) =
-kappa*I`), the diagonal is real, so `B^H = B`. -/
theorem B_isHermitian (lam kappa : ℝ) : (B lam kappa).IsHermitian := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [B, Matrix.conjTranspose]

/-- **Determinant of `B`.** `det B = lam*(lam^2 - kappa^2)`. The block-diagonal
`[[lam, kappa I], [-kappa I, lam]] (+) [lam]` has `det = lam * (lam^2 - kappa^2)`
because `(kappa I)*(-kappa I) = kappa^2`. -/
theorem B_det (lam kappa : ℝ) :
    (B lam kappa).det = (lam : ℂ) * ((lam : ℂ) ^ 2 - (kappa : ℂ) ^ 2) := by
  rw [B, Matrix.det_fin_three]
  simp only [Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.head_fin_const, Matrix.empty_val', Matrix.cons_val_fin_one,
    Matrix.cons_val_two, Matrix.tail_cons]
  linear_combination ((lam : ℂ) * (kappa : ℂ) ^ 2) * Complex.I_sq

/-- **The massless critical line.** On the physical branch `0 < lam`, the block is
singular exactly when `kappa = lam` or `kappa = -lam` - i.e. closure equals
aperture in magnitude. For `0 <= kappa` this is the single line `kappa = lam`. -/
theorem B_massless_iff (lam kappa : ℝ) (hlam : 0 < lam) :
    (B lam kappa).det = 0 ↔ kappa = lam ∨ kappa = -lam := by
  rw [B_det]
  have hlamC : (lam : ℂ) ≠ 0 := by exact_mod_cast hlam.ne'
  rw [mul_eq_zero, sub_eq_zero]
  constructor
  · rintro (h | h)
    · exact absurd h hlamC
    · -- (lam:ℂ)^2 = (kappa:ℂ)^2  ⇒  kappa = ±lam, by factoring over ℝ
      have hr : kappa ^ 2 = lam ^ 2 := by exact_mod_cast h.symm
      have hfac : (kappa - lam) * (kappa + lam) = 0 := by nlinarith [hr]
      rcases mul_eq_zero.mp hfac with h1 | h1
      · exact Or.inl (by linarith)
      · exact Or.inr (by linarith)
  · rintro (rfl | rfl)
    · right; ring
    · right; push_cast; ring

/-- **Positive-definiteness of `B` (aperture dominance).** `B` is positive
definite - the state is massive, squared mass gap `lam - kappa > 0` - exactly when
aperture dominates closure, `|kappa| < lam`.

HANDOFF (`s o r r y`): proof delegated to Aristotle (standalone package
`allmass-massgap-20260708`). See the module docstring for the elementary route. -/
theorem B_posDef_iff (lam kappa : ℝ) :
    (B lam kappa).PosDef ↔ kappa < lam ∧ -lam < kappa := by
  sorry

end PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness
