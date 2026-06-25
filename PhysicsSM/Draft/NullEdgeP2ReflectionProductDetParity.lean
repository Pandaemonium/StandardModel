import Mathlib

/-!
# Draft.NullEdgeP2ReflectionProductDetParity

This module formalizes a determinant-collapse guardrail for products of P2
branch reflections.

A single on-shell branch reflection has determinant `-1`. Therefore determinant
of a product of branch reflections carries only reflection-count parity: two
reflections have determinant `+1`, and a finite product of determinant `-1`
matrices has determinant `(-1) ^ length`.

This is useful as a negative theorem: determinant-only path products cannot by
themselves encode rich proper-time or geometric data.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP2ReflectionProductDetParity

open Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real

/-- Two-level chiral Hamiltonian for fixed helicity sign `h`. -/
def chiralHamiltonian (h p m : Real) : RMat2 :=
  !![-h * p, m; m, h * p]

/-- Branch reflection in scalar form. -/
def branchReflection (h p m E : Real) : RMat2 :=
  E⁻¹ • chiralHamiltonian h p m

/-- Explicit determinant for a real `2 x 2` matrix. -/
def det2 (M : RMat2) : Real :=
  M 0 0 * M 1 1 - M 0 1 * M 1 0

/-- Explicit determinant is multiplicative on real `2 x 2` matrices. -/
theorem det2_mul (A B : RMat2) :
    det2 (A * B) = det2 A * det2 B := by
  unfold det2
  norm_num [Matrix.mul_apply, Fin.sum_univ_two, Matrix.det_fin_two]
  ring

/-- On shell, the branch reflection has determinant `-1`. -/
theorem branchReflection_det2_eq_neg_one_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    det2 (branchReflection h p m E) = -1 := by
  simp only [det2, branchReflection, chiralHamiltonian, smul_apply, smul_eq_mul,
    cons_val', cons_val_zero, cons_val_one, empty_val', cons_val_fin_one, of_apply]
  field_simp
  nlinarith [hh, hshell, sq_nonneg E]

/-- The product of two on-shell branch reflections has determinant `+1`. -/
theorem det2_mul_two_branchReflections_eq_one_on_massShell
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real)
    (hh1 : h1 * h1 = 1) (hE10 : E1 ≠ 0)
    (hshell1 : E1 ^ 2 = p1 ^ 2 + m1 ^ 2)
    (hh2 : h2 * h2 = 1) (hE20 : E2 ≠ 0)
    (hshell2 : E2 ^ 2 = p2 ^ 2 + m2 ^ 2) :
    det2 (branchReflection h1 p1 m1 E1 * branchReflection h2 p2 m2 E2) = 1 := by
  rw [det2_mul]
  rw [branchReflection_det2_eq_neg_one_on_massShell h1 p1 m1 E1 hh1 hE10 hshell1]
  rw [branchReflection_det2_eq_neg_one_on_massShell h2 p2 m2 E2 hh2 hE20 hshell2]
  norm_num

/-- Product of a list of matrices. -/
def matListProd : List RMat2 -> RMat2
  | [] => 1
  | M :: Ms => M * matListProd Ms

/-- Determinant of a finite product is the product of determinants. -/
theorem det2_matListProd (Ms : List RMat2) :
    det2 (matListProd Ms) = (Ms.map det2).prod := by
  induction Ms with
  | nil => simp [matListProd, det2]
  | cons M Ms ih =>
      simp [matListProd, det2_mul, ih]

/--
If every matrix in a finite list has determinant `-1`, then the determinant of
the product is the parity sign `(-1) ^ length`.
-/
theorem det2_matListProd_eq_neg_one_pow_length
    (Ms : List RMat2) (hdet : forall M, M ∈ Ms -> det2 M = -1) :
    det2 (matListProd Ms) = (-1 : Real) ^ Ms.length := by
  induction Ms with
  | nil => simp [matListProd, det2]
  | cons M Ms ih =>
      have hM : det2 M = -1 := hdet M (by simp)
      have hMs : forall N, N ∈ Ms -> det2 N = -1 := by
        intro N hN
        exact hdet N (by simp [hN])
      have hprod : (Ms.map det2).prod = (-1 : Real) ^ Ms.length := by
        rw [← det2_matListProd]
        exact ih hMs
      rw [det2_matListProd]
      simp [hM, hprod, pow_succ]

end PhysicsSM.Draft.NullEdgeP2ReflectionProductDetParity

end
