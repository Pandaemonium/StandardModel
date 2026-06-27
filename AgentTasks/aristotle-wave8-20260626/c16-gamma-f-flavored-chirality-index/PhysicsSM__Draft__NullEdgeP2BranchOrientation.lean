import Mathlib

/-!
# Draft.NullEdgeP2BranchOrientation

This module certifies that the finite branch reflection `R = H / E` is not
merely norm-preserving: on shell it is an orientation-reversing real reflection.

The determinant and trace certificate records trace zero, determinant `-1`, and
therefore non-identity. This is finite `2 x 2` real algebra only, not a
chirality, zitterbewegung, Pluecker-ray, shift, walk, or continuum claim.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP2BranchOrientation

open Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real

/-- Two-level chiral Hamiltonian for fixed helicity sign `h`. -/
def chiralHamiltonian (h p m : Real) : RMat2 :=
  !![-h * p, m; m, h * p]

/-- Branch reflection in scalar form. -/
def branchReflection (h p m E : Real) : RMat2 :=
  E⁻¹ • chiralHamiltonian h p m

/-- Explicit trace for a real `2 x 2` matrix. -/
def trace2 (M : RMat2) : Real :=
  M 0 0 + M 1 1

/-- Explicit determinant for a real `2 x 2` matrix. -/
def det2 (M : RMat2) : Real :=
  M 0 0 * M 1 1 - M 0 1 * M 1 0

/-- The branch reflection is traceless. -/
theorem branchReflection_trace2_eq_zero
    (h p m E : Real) :
    trace2 (branchReflection h p m E) = 0 := by
  simp [trace2, branchReflection, chiralHamiltonian]

/-- On shell, the branch reflection has determinant `-1`. -/
theorem branchReflection_det2_eq_neg_one_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    det2 (branchReflection h p m E) = -1 := by
  simp only [det2, branchReflection, chiralHamiltonian, smul_apply, smul_eq_mul,
    cons_val', cons_val_zero, cons_val_one, empty_val', cons_val_fin_one, of_apply]
  field_simp
  nlinarith [hh, hshell, sq_nonneg E]

/-- The explicit determinant of the identity is `1`. -/
theorem det2_one : det2 (1 : RMat2) = 1 := by
  simp [det2]

/-- On shell, the branch reflection is not the identity. -/
theorem branchReflection_ne_one_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    branchReflection h p m E ≠ (1 : RMat2) := by
  intro hcontra
  have hdet : det2 (branchReflection h p m E) = det2 (1 : RMat2) := by
    rw [hcontra]
  rw [branchReflection_det2_eq_neg_one_on_massShell h p m E hh hE0 hshell,
    det2_one] at hdet
  norm_num at hdet

end PhysicsSM.Draft.NullEdgeP2BranchOrientation

end
