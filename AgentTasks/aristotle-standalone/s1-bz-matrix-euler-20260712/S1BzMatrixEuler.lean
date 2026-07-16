import Mathlib

/-!
# S1 target: the 2x2 matrix Euler formula for the rest block `B_z`

Aristotle target (DYN-MODULAR-001 successor S1). Prove `bz_matrix_euler`: the
matrix exponential of `(-(a) i) • B_z` is `cos(a|z|) • 1 - (i sin(a|z|)/|z|) • B_z`.

The key algebraic input `Bz_sq` (`B_z^2 = |z|^2 • 1`) is PROVED below; the target
`bz_matrix_euler` is the single hole.

Intended reading: `B_z = [[0, z], [conj z, 0]]` squares to the real scalar
`|z|^2 = z * conj z` times the identity, so `J := B_z / |z|` is an involution
(`J^2 = 1`) and the exponential is the involution Euler formula
`exp(-(a) i |z| J) = cos(a|z|) 1 - i sin(a|z|) J`.

Proof route (suggested): split the `NormedSpace.exp` power series of
`M = (-(a) i) • B_z` into even and odd terms using `M^2 = (-(a) i)^2 |z|^2 • 1`
(a scalar multiple of `1`, from `Bz_sq`); the even part sums to
`cosh((-(a) i)|z|) • 1 = cos(a|z|) • 1` and the odd part to
`(sinh((-(a) i)|z|)/|z|) • B_z = -(i sin(a|z|)/|z|) • B_z`. Mathlib scalar
identities: `Complex.cos`, `Complex.sin`, `Complex.exp_mul_I`,
`Complex.cosh`/`Complex.sinh` and their relation to `cos`/`sin` on the imaginary
axis. Alternatively diagonalize `B_z` (eigenvalues `+-|z|`) via an explicit
unitary and push `NormedSpace.exp` through conjugation with
`Matrix.exp_conj`/`Matrix.exp_diagonal`.

Run: `lake env lean S1BzMatrixEuler.lean`. Please close only the `sorry` in
`bz_matrix_euler`; keep `Bz` and the `Bz_sq` statement byte-identical.
-/

noncomputable section

namespace S1BzMatrixEuler

open Matrix

/-- The pair-sector rest block `B_z = [[0, z], [conj z, 0]]`. -/
def Bz (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, z; (starRingEnd ℂ) z, 0]

/-- `B_z^2 = |z|^2 • 1` with `|z|^2 = z * conj z` (a real scalar). PROVED. -/
theorem Bz_sq (z : ℂ) :
    Bz z * Bz z = (z * (starRingEnd ℂ) z) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Bz, Matrix.mul_apply, Fin.sum_univ_two, Matrix.smul_apply,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.of_apply, mul_comm]

/-- **S1 TARGET (the hole).**  The `2x2` matrix Euler formula for `B_z`:
`exp((-(a) i) • B_z) = cos(a|z|) • 1 - (i sin(a|z|)/|z|) • B_z`. -/
theorem bz_matrix_euler (z : ℂ) (a : ℝ) (hz : z ≠ 0) :
    NormedSpace.exp ((-(a : ℂ) * Complex.I) • Bz z)
      = (Real.cos (a * ‖z‖) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
        - (Complex.I * ((Real.sin (a * ‖z‖) / ‖z‖) : ℂ)) • Bz z := by
  sorry

end S1BzMatrixEuler
