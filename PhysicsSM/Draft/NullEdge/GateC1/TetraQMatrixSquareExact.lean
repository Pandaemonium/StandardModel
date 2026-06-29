import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.TetraQSquareExact

/-!
# Gate C1: abstract Euclidean tetrahedral matrix slash square

This Draft module follows the 2026-06-28 Pro guidance:

* prove the matrix identity abstractly from Euclidean anticommutator / Gram
  hypotheses;
* do not make the mainline depend on a concrete `4 x 4` gamma representation;
* export the lower-bound / norm-facing API for later `TetraSymbolGap` work.

The substrate is deliberately concrete enough for Lean:

`Matrix Spin Spin C`

for an arbitrary finite spin index type `Spin`.  The representation data is
abstracted into `TetraEuclideanSlashData`.

The exact identity proved here is representation-independent:

`Q(s)^2 = qExact(s) • I`

provided the four slash matrices satisfy

`B_A B_B + B_B B_A = 2 * tetraGram(A,B) • I`.
-/

open scoped BigOperators

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraQMatrixSquareExact

/-- The Euclidean tetrahedral Gram matrix for the four slash directions. -/
noncomputable def tetraGram (A B : Fin 4) : ℝ :=
  if A = B then (5 / 8 : ℝ) else (-1 / 8 : ℝ)

/-- Abstract Euclidean slash data on a finite spin matrix space. -/
structure TetraEuclideanSlashData
    (Spin : Type*) [Fintype Spin] [DecidableEq Spin] where
  /-- The four tetrahedral slash matrices. -/
  B : Fin 4 -> Matrix Spin Spin ℂ
  /-- Euclidean/Hilbert convention: each slash matrix is Hermitian. -/
  B_hermitian : ∀ A, star (B A) = B A
  /-- Euclidean Clifford/Gram anticommutator. -/
  B_anticomm : ∀ A Bidx,
    B A * B Bidx + B Bidx * B A =
      (((2 : ℝ) * tetraGram A Bidx : ℝ) : ℂ) •
        (1 : Matrix Spin Spin ℂ)

namespace TetraEuclideanSlashData

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- The tetrahedral Euclidean slash `Q(s) = sum_A s_A B_A`. -/
noncomputable def Q (D : TetraEuclideanSlashData Spin) (s : Fin 4 -> ℝ) :
    Matrix Spin Spin ℂ :=
  ∑ A : Fin 4, ((s A : ℝ) : ℂ) • D.B A

theorem anticomm_self (D : TetraEuclideanSlashData Spin) (A : Fin 4) :
    D.B A * D.B A = ((tetraGram A A : ℝ) : ℂ) •
      (1 : Matrix Spin Spin ℂ) := by
  have h := D.B_anticomm A A
  ext i j
  have hij := congr_fun (congr_fun h i) j
  by_cases hdiag : i = j
  · subst j
    simp [tetraGram] at hij ⊢
    linear_combination (1 / 2 : ℂ) * hij
  · simp [tetraGram, hdiag] at hij ⊢
    exact hij

theorem anticomm_cross (D : TetraEuclideanSlashData Spin)
    (A Bidx : Fin 4) (hAB : A ≠ Bidx) :
    D.B A * D.B Bidx + D.B Bidx * D.B A =
      ((-1 / 4 : ℂ)) • (1 : Matrix Spin Spin ℂ) := by
  have h := D.B_anticomm A Bidx
  norm_num [tetraGram, hAB] at h ⊢
  exact h

/-- Exact finite expansion of the abstract tetrahedral slash square.

This is intentionally proved by reducing the finite `Fin 4` sum to the six
cross anticommutators plus four square terms.  It is the representation-free
matrix identity that validates the scalar proxy used downstream. -/
theorem Q_square_exact (D : TetraEuclideanSlashData Spin) (s : Fin 4 -> ℝ) :
    Q D s * Q D s =
      ((TetraQSquareExact.qExact s : ℝ) : ℂ) •
        (1 : Matrix Spin Spin ℂ) := by
  let b0 := D.B 0
  let b1 := D.B 1
  let b2 := D.B 2
  let b3 := D.B 3
  let c0 : ℂ := (s 0 : ℝ)
  let c1 : ℂ := (s 1 : ℝ)
  let c2 : ℂ := (s 2 : ℝ)
  let c3 : ℂ := (s 3 : ℝ)
  have h00 : b0 * b0 = ((5 / 8 : ℂ)) • (1 : Matrix Spin Spin ℂ) := by
    simpa [b0, tetraGram] using D.anticomm_self 0
  have h11 : b1 * b1 = ((5 / 8 : ℂ)) • (1 : Matrix Spin Spin ℂ) := by
    simpa [b1, tetraGram] using D.anticomm_self 1
  have h22 : b2 * b2 = ((5 / 8 : ℂ)) • (1 : Matrix Spin Spin ℂ) := by
    simpa [b2, tetraGram] using D.anticomm_self 2
  have h33 : b3 * b3 = ((5 / 8 : ℂ)) • (1 : Matrix Spin Spin ℂ) := by
    simpa [b3, tetraGram] using D.anticomm_self 3
  have h01 : b0 * b1 + b1 * b0 = ((-1 / 4 : ℂ)) •
      (1 : Matrix Spin Spin ℂ) := by
    simpa [b0, b1] using D.anticomm_cross 0 1 (by decide)
  have h02 : b0 * b2 + b2 * b0 = ((-1 / 4 : ℂ)) •
      (1 : Matrix Spin Spin ℂ) := by
    simpa [b0, b2] using D.anticomm_cross 0 2 (by decide)
  have h03 : b0 * b3 + b3 * b0 = ((-1 / 4 : ℂ)) •
      (1 : Matrix Spin Spin ℂ) := by
    simpa [b0, b3] using D.anticomm_cross 0 3 (by decide)
  have h12 : b1 * b2 + b2 * b1 = ((-1 / 4 : ℂ)) •
      (1 : Matrix Spin Spin ℂ) := by
    simpa [b1, b2] using D.anticomm_cross 1 2 (by decide)
  have h13 : b1 * b3 + b3 * b1 = ((-1 / 4 : ℂ)) •
      (1 : Matrix Spin Spin ℂ) := by
    simpa [b1, b3] using D.anticomm_cross 1 3 (by decide)
  have h23 : b2 * b3 + b3 * b2 = ((-1 / 4 : ℂ)) •
      (1 : Matrix Spin Spin ℂ) := by
    simpa [b2, b3] using D.anticomm_cross 2 3 (by decide)
  have hgroup :
      Q D s * Q D s =
        (c0 * c0) • (b0 * b0)
        + (c1 * c1) • (b1 * b1)
        + (c2 * c2) • (b2 * b2)
        + (c3 * c3) • (b3 * b3)
        + (c0 * c1) • (b0 * b1 + b1 * b0)
        + (c0 * c2) • (b0 * b2 + b2 * b0)
        + (c0 * c3) • (b0 * b3 + b3 * b0)
        + (c1 * c2) • (b1 * b2 + b2 * b1)
        + (c1 * c3) • (b1 * b3 + b3 * b1)
        + (c2 * c3) • (b2 * b3 + b3 * b2) := by
    unfold Q
    simp [Fin.sum_univ_four, b0, b1, b2, b3, c0, c1, c2, c3,
      mul_add, add_mul, smul_add, mul_smul]
    module
  rw [hgroup]
  rw [h00, h11, h22, h33, h01, h02, h03, h12, h13, h23]
  ext i j
  by_cases hij : i = j
  · subst j
    simp [TetraQSquareExact.qExact, Fin.sum_univ_four, c0, c1, c2, c3]
    ring_nf
  · simp [hij]

/-- The tetrahedral Euclidean slash is Hermitian for real coefficients. -/
theorem Q_hermitian (D : TetraEuclideanSlashData Spin) (s : Fin 4 -> ℝ) :
    star (Q D s) = Q D s := by
  unfold Q
  simp [D.B_hermitian]

/-- Exact `Q†Q` form.  This is the matrix/operator-facing version consumed by
the later symbol-gap theorem. -/
theorem Q_star_mul_exact (D : TetraEuclideanSlashData Spin) (s : Fin 4 -> ℝ) :
    star (Q D s) * Q D s =
      ((TetraQSquareExact.qExact s : ℝ) : ℂ) •
        (1 : Matrix Spin Spin ℂ) := by
  rw [Q_hermitian, Q_square_exact]

/-- Scalar lower bound exported beside the exact matrix identity. -/
theorem qLower_le_Q_square_coeff (s : Fin 4 -> ℝ) :
    TetraQSquareExact.qLower s ≤ TetraQSquareExact.qExact s :=
  TetraQSquareExact.qLower_le_qExact s

/--
Away from the scalar branch locus `qExact(s) = 0`, the abstract tetrahedral
slash has the expected Clifford inverse. This is the algebraic no-kernel
statement needed before turning the pointwise symbol identity into an operator
gap.
-/
theorem Q_inverse_formula (D : TetraEuclideanSlashData Spin) (s : Fin 4 -> ℝ)
    (h : (((TetraQSquareExact.qExact s : ℝ) : ℂ)) ≠ 0) :
    let c : ℂ := ((TetraQSquareExact.qExact s : ℝ) : ℂ)
    (((c⁻¹) • Q D s) * Q D s = (1 : Matrix Spin Spin ℂ)) ∧
      (Q D s * ((c⁻¹) • Q D s) = (1 : Matrix Spin Spin ℂ)) := by
  dsimp
  constructor
  · calc
      (((((TetraQSquareExact.qExact s : ℝ) : ℂ))⁻¹) • Q D s) * Q D s
          = (((TetraQSquareExact.qExact s : ℝ) : ℂ))⁻¹ •
              (Q D s * Q D s) := by
            simp
      _ = (((TetraQSquareExact.qExact s : ℝ) : ℂ))⁻¹ •
              ((((TetraQSquareExact.qExact s : ℝ) : ℂ)) •
                (1 : Matrix Spin Spin ℂ)) := by
            rw [Q_square_exact]
      _ = (1 : Matrix Spin Spin ℂ) := by
            ext i j
            by_cases hij : i = j
            · subst j
              simp [h]
            · simp [hij]
  · calc
      Q D s * (((((TetraQSquareExact.qExact s : ℝ) : ℂ))⁻¹) • Q D s)
          = (((TetraQSquareExact.qExact s : ℝ) : ℂ))⁻¹ •
              (Q D s * Q D s) := by
            simp
      _ = (((TetraQSquareExact.qExact s : ℝ) : ℂ))⁻¹ •
              ((((TetraQSquareExact.qExact s : ℝ) : ℂ)) •
                (1 : Matrix Spin Spin ℂ)) := by
            rw [Q_square_exact]
      _ = (1 : Matrix Spin Spin ℂ) := by
            ext i j
            by_cases hij : i = j
            · subst j
              simp [h]
            · simp [hij]

/-- If at least one tetrahedral coefficient is nonzero, the abstract
tetrahedral slash has the explicit Clifford inverse. -/
theorem Q_inverse_formula_of_exists_ne_zero
    (D : TetraEuclideanSlashData Spin) (s : Fin 4 -> ℝ)
    (h : ∃ A : Fin 4, s A ≠ 0) :
    let c : ℂ := ((TetraQSquareExact.qExact s : ℝ) : ℂ)
    (((c⁻¹) • Q D s) * Q D s = (1 : Matrix Spin Spin ℂ)) ∧
      (Q D s * ((c⁻¹) • Q D s) = (1 : Matrix Spin Spin ℂ)) := by
  apply Q_inverse_formula
  exact_mod_cast TetraQSquareExact.qExact_ne_zero_of_exists_ne_zero s h

/-- The abstract tetrahedral slash has nonzero determinant whenever the
coefficient vector is nonzero. This is the determinant-level branch statement
for the Euclidean sign-kernel block. -/
theorem Q_det_ne_zero_of_exists_ne_zero
    (D : TetraEuclideanSlashData Spin) (s : Fin 4 -> ℝ)
    (h : ∃ A : Fin 4, s A ≠ 0) : Matrix.det (Q D s) ≠ 0 := by
  have hleft := (Q_inverse_formula_of_exists_ne_zero D s h).1
  have hdet := congrArg Matrix.det hleft
  rw [Matrix.det_mul, Matrix.det_one] at hdet
  intro hzero
  rw [hzero] at hdet
  simp at hdet

end TetraEuclideanSlashData

end TetraQMatrixSquareExact
end GateC1
end NullEdge
end Draft
end PhysicsSM
