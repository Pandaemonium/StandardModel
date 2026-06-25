import Mathlib

/-!
# Branch reflection for the two-level chiral Hamiltonian

This focused target packages the branch resolution into the finite reflection
operator `R = P+ - P-`.  On shell, this reflection squares to the identity,
is traceless, reconstructs the Hamiltonian after multiplying by `E`, commutes
with the Hamiltonian, and is rigidly determined by `E • R = H`.
-/

noncomputable section

namespace NullEdgeP2BranchReflection

open Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real

/-- Two-level chiral Hamiltonian for fixed helicity sign `h`. -/
def chiralHamiltonian (h p m : Real) : RMat2 :=
  !![-h * p, m; m, h * p]

/-- Positive branch `(1/2)(I + H/E)` of the two-level chiral Hamiltonian. -/
def positiveBranch (h p m E : Real) : RMat2 :=
  (1 / 2 : Real) •
    ((1 : RMat2) + E⁻¹ • chiralHamiltonian h p m)

/-- Negative branch `(1/2)(I - H/E)` of the two-level chiral Hamiltonian. -/
def negativeBranch (h p m E : Real) : RMat2 :=
  (1 / 2 : Real) •
    ((1 : RMat2) - E⁻¹ • chiralHamiltonian h p m)

/-- Branch reflection `R = P+ - P-`. -/
def branchReflection (h p m E : Real) : RMat2 :=
  positiveBranch h p m E - negativeBranch h p m E

/-- The chiral Hamiltonian squares to the scalar mass-shell block. -/
theorem chiralHamiltonian_sq_eq_massShell
    (h p m : Real) (hh : h * h = 1) :
    chiralHamiltonian h p m * chiralHamiltonian h p m =
      (p ^ 2 + m ^ 2) • (1 : RMat2) := by
  unfold chiralHamiltonian
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two] <;>
    nlinarith [hh]

/-
Spectral reconstruction of the Hamiltonian from the branch reflection.
-/
theorem branchReflection_reconstructs_hamiltonian
    (h p m E : Real) (hE0 : E ≠ 0) :
    E • branchReflection h p m E = chiralHamiltonian h p m := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ *, branchReflection, positiveBranch, negativeBranch ] <;> ring;
  · aesop;
  · norm_num [ hE0 ];
  · norm_num [ hE0 ];
  · rw [ mul_inv_cancel₀ hE0, one_mul ]

/-
The branch reflection is traceless.
-/
theorem branchReflection_trace_eq_zero
    (h p m E : Real) :
    Matrix.trace (branchReflection h p m E) = 0 := by
  unfold branchReflection; norm_num [ positiveBranch, negativeBranch, chiralHamiltonian ] ;

/-
On shell, the branch reflection is an involution.
-/
theorem branchReflection_sq_eq_one_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    branchReflection h p m E * branchReflection h p m E = (1 : RMat2) := by
  unfold branchReflection;
  unfold negativeBranch; unfold positiveBranch; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply ] <;> ring;
  · unfold chiralHamiltonian; norm_num ; ring_nf ;
    grind;
  · unfold chiralHamiltonian; norm_num ; ring;
  · unfold chiralHamiltonian; aesop;
  · unfold chiralHamiltonian; norm_num; ring_nf at *;
    grind

/-
The branch reflection commutes with its Hamiltonian generator.
-/
theorem branchReflection_commutes_hamiltonian
    (h p m E : Real) :
    branchReflection h p m E * chiralHamiltonian h p m =
      chiralHamiltonian h p m * branchReflection h p m E := by
  unfold branchReflection positiveBranch negativeBranch;
  ext i j ; norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] ; ring!;

/-
The positive branch is the `+1` sector of the branch reflection.
-/
theorem branchReflection_mul_positive_eq_positive_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    branchReflection h p m E * positiveBranch h p m E =
      positiveBranch h p m E := by
  unfold branchReflection positiveBranch;
  unfold negativeBranch;
  simp +decide [ ← smul_add, ← smul_sub, ← Matrix.smul_mul, ← Matrix.mul_smul, Matrix.mul_add, Matrix.add_mul, Matrix.mul_one, Matrix.one_mul ];
  rw [ chiralHamiltonian_sq_eq_massShell h p m hh ];
  ext i j ; norm_num ; ring;
  grind

/-
The negative branch is the `-1` sector of the branch reflection.
-/
theorem branchReflection_mul_negative_eq_neg_negative_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    branchReflection h p m E * negativeBranch h p m E =
      -negativeBranch h p m E := by
  unfold negativeBranch; ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ ] ; ring; (
  unfold branchReflection; norm_num [ chiralHamiltonian ] ; ring;
  unfold negativeBranch; unfold positiveBranch; norm_num [ chiralHamiltonian ] ; ring;
  grind);
  · unfold branchReflection positiveBranch negativeBranch chiralHamiltonian; norm_num [ Matrix.mul_apply, Matrix.one_apply ] ; ring;
  · unfold branchReflection; norm_num [ positiveBranch, negativeBranch, chiralHamiltonian ] ; ring;
  · unfold branchReflection positiveBranch negativeBranch chiralHamiltonian; norm_num [ Matrix.mul_apply, Matrix.one_apply ] ; ring;
    grind

/-
The reconstruction equation rigidly determines the branch reflection when the
energy scalar is nonzero.
-/
theorem branchReflection_unique_of_reconstructs
    (h p m E : Real) (R : RMat2) (hE0 : E ≠ 0)
    (hR : E • R = chiralHamiltonian h p m) :
    R = branchReflection h p m E := by
  convert congr_arg ( fun x => ( E : ℝ ) ⁻¹ • x ) hR using 1;
  · norm_num [ hE0 ];
  · convert congr_arg ( fun x => ( E : ℝ ) ⁻¹ • x ) ( branchReflection_reconstructs_hamiltonian h p m E hE0 ) using 1;
    simp +decide [ hE0, smul_smul ]

end NullEdgeP2BranchReflection

end
