import Mathlib
import PhysicsSM.Spinor.KrasnovQubitCoordinateFlattening

/-!
# Spinor.KrasnovQubitHermitian

Define the standard Hermitian form and squared norm on the flattened
`Fin 8 -> Complex` coordinates of the octonionic qubit, and prove that the
diagonal form of right multiplication by `e111` preserves this norm.

This is a clean formal shadow of Krasnov's point that the chosen octonionic
imaginary unit defines a complex structure on `O^2`.

## Claim boundary

This file proves norm/Hermitian facts about the coordinate operator only.
No `Spin(9)` or `Spin(10)` centralizer theorem or Standard Model subgroup
theorem is claimed.

## Sources

- Kirill Krasnov, "SO(9) characterisation of the Standard Model gauge group",
  arXiv:1912.11282.
- Kirill Krasnov, "Octonions, complex structures and Standard Model fermions",
  arXiv:2504.16465.

Provenance: integrated from Aristotle job
`1b237619-fc1e-45a9-be78-f60c06229cda`, with local review and provenance
cleanup.

Status: trusted and placeholder-free.
-/

namespace PhysicsSM.Spinor.KrasnovComplexStructure

open Complex
open PhysicsSM.Spinor.OctonionicQubit

/-! ## Hermitian form and norm -/

/--
The standard Hermitian form on `Complex^8`, given by
`<v, w> = sum_i conjugate(v_i) * w_i`.
-/
noncomputable def QubitComplexCoordinates.flatHermitian
    (v w : Fin 8 -> Complex) : Complex :=
  Finset.univ.sum (fun i => starRingEnd Complex (v i) * w i)

/-- The squared norm on `Complex^8`, given by `norm(v)^2 = re <v, v>`. -/
noncomputable def QubitComplexCoordinates.flatNormSq
    (v : Fin 8 -> Complex) : Real :=
  Complex.re (QubitComplexCoordinates.flatHermitian v v)

/-! ## Basic norm properties -/

/-- The squared norm is nonnegative. -/
theorem QubitComplexCoordinates.flatNormSq_nonneg
    (v : Fin 8 -> Complex) : 0 <= QubitComplexCoordinates.flatNormSq v := by
  unfold QubitComplexCoordinates.flatNormSq QubitComplexCoordinates.flatHermitian
  norm_num [mul_comm]
  exact Finset.sum_nonneg fun _ _ =>
    add_nonneg (mul_self_nonneg _) (mul_self_nonneg _)

/-- The squared norm of zero is zero. -/
theorem QubitComplexCoordinates.flatNormSq_zero :
    QubitComplexCoordinates.flatNormSq 0 = 0 := by
  unfold QubitComplexCoordinates.flatNormSq
  unfold QubitComplexCoordinates.flatHermitian
  norm_num

/-- The squared norm is zero iff the vector is zero. -/
theorem QubitComplexCoordinates.flatNormSq_eq_zero_iff
    (v : Fin 8 -> Complex) :
    Iff (QubitComplexCoordinates.flatNormSq v = 0) (v = 0) := by
  constructor
  case mp =>
    intro hv
    have h_sum_zero :
        Finset.univ.sum (fun i => Complex.normSq (v i)) = 0 := by
      unfold QubitComplexCoordinates.flatNormSq at hv
      unfold QubitComplexCoordinates.flatHermitian at hv
      simp_all +decide [Complex.normSq, Complex.mul_re]
    exact funext fun i => by
      simpa [Complex.ext_iff] using
        (Finset.sum_eq_zero_iff_of_nonneg
          (fun _ _ => Complex.normSq_nonneg _)).1 h_sum_zero i
  case mpr =>
    intro h
    rw [h]
    exact QubitComplexCoordinates.flatNormSq_zero

/-! ## Diagonal-unitary facts -/

/-- The diagonal action of `rightMulE111` preserves the Hermitian form. -/
theorem QubitComplexCoordinates.flatHermitian_diagonal_left
    (v w : Fin 8 -> Complex) :
    QubitComplexCoordinates.flatHermitian
      (QubitComplexCoordinates.rightMulE111Diagonal v)
      (QubitComplexCoordinates.rightMulE111Diagonal w) =
      QubitComplexCoordinates.flatHermitian v w := by
  unfold rightMulE111Diagonal
  unfold flatHermitian
  simp +decide [Fin.sum_univ_succ]
  ring_nf
  norm_num
  ring

/-- The diagonal action of `rightMulE111` preserves the squared norm. -/
theorem QubitComplexCoordinates.flatNormSq_diagonal
    (v : Fin 8 -> Complex) :
    QubitComplexCoordinates.flatNormSq
      (QubitComplexCoordinates.rightMulE111Diagonal v) =
      QubitComplexCoordinates.flatNormSq v := by
  exact congr_arg Complex.re (flatHermitian_diagonal_left v v)

end PhysicsSM.Spinor.KrasnovComplexStructure
