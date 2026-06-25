import Mathlib

/-!
# P2 reflection product determinant parity

This standalone target formalizes the determinant-collapse guardrail for branch
reflection path products.

Physics context: a single on-shell P2 branch reflection has determinant `-1`.
Therefore determinant of a product of branch reflections carries only parity
information. A two-reflection product has determinant `+1`, and a finite list
of reflections has determinant `(-1) ^ length`. This is useful precisely
because it blocks an overstrong claim that determinant path sums by themselves
encode proper time.
-/

noncomputable section

namespace NullEdgeP2ReflectionProductDetParity

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

/-
Explicit determinant is multiplicative on real `2 x 2` matrices.
-/
theorem det2_mul (A B : RMat2) :
    det2 (A * B) = det2 A * det2 B := by
  unfold det2; norm_num [ Matrix.mul_apply, Fin.sum_univ_two, Matrix.det_fin_two ] ; ring;

/-
On shell, the branch reflection has determinant `-1`.
-/
theorem branchReflection_det2_eq_neg_one_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    det2 (branchReflection h p m E) = -1 := by
  norm_num [ det2, branchReflection, chiralHamiltonian ];
  grind

/-
The product of two on-shell branch reflections has determinant `+1`.
-/
theorem det2_mul_two_branchReflections_eq_one_on_massShell
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real)
    (hh1 : h1 * h1 = 1) (hE10 : E1 ≠ 0)
    (hshell1 : E1 ^ 2 = p1 ^ 2 + m1 ^ 2)
    (hh2 : h2 * h2 = 1) (hE20 : E2 ≠ 0)
    (hshell2 : E2 ^ 2 = p2 ^ 2 + m2 ^ 2) :
    det2 (branchReflection h1 p1 m1 E1 * branchReflection h2 p2 m2 E2) = 1 := by
  rw [ det2_mul ] ; exact by rw [ branchReflection_det2_eq_neg_one_on_massShell _ _ _ _ hh1 hE10 hshell1, branchReflection_det2_eq_neg_one_on_massShell _ _ _ _ hh2 hE20 hshell2 ] ; norm_num;

/-- Product of a list of matrices. -/
def matListProd : List RMat2 -> RMat2
  | [] => 1
  | M :: Ms => M * matListProd Ms

/-
Determinant of a finite product is the product of determinants.
-/
theorem det2_matListProd (Ms : List RMat2) :
    det2 (matListProd Ms) = (Ms.map det2).prod := by
  induction Ms with
  | nil => simp [matListProd, det2]
  | cons M Ms ih =>
    simp [matListProd, det2_mul, List.map_cons, List.prod_cons, ih]

/-
If every matrix in a finite list has determinant `-1`, then the determinant of
the product is the parity sign `(-1) ^ length`.
-/
theorem det2_matListProd_eq_neg_one_pow_length
    (Ms : List RMat2) (hdet : forall M, M ∈ Ms -> det2 M = -1) :
    det2 (matListProd Ms) = (-1 : Real) ^ Ms.length := by
  rw [ det2_matListProd, ← List.prod_replicate ];
  exact congr_arg _ ( List.eq_replicate_iff.mpr ⟨ by aesop, by aesop ⟩ )

end NullEdgeP2ReflectionProductDetParity

end
