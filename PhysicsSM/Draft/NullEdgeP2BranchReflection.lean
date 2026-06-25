import PhysicsSM.Draft.NullEdgeP2BranchResolution

/-!
# Draft.NullEdgeP2BranchReflection

This module packages the finite branch resolution of the two-level chiral
Hamiltonian into the reflection operator `R = P+ - P-`.

The reflection reconstructs the Hamiltonian after multiplying by the energy
scalar, is traceless, squares to the identity on shell, commutes with the
Hamiltonian, acts as `+1` and `-1` on the positive and negative branches, and is
rigidly determined by the reconstruction equation when `E` is nonzero.

This is finite real `2 x 2` matrix algebra. It is a draft-facing P2/P4/P7
operator shard, not a continuum Dirac limit.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP2BranchReflection

open Matrix

abbrev RMat2 := PhysicsSM.Draft.NullEdgeP2BranchResolution.RMat2

abbrev chiralHamiltonian := PhysicsSM.Draft.NullEdgeP2BranchResolution.chiralHamiltonian
abbrev positiveBranch := PhysicsSM.Draft.NullEdgeP2BranchResolution.positiveBranch
abbrev negativeBranch := PhysicsSM.Draft.NullEdgeP2BranchResolution.negativeBranch

/-- Branch reflection `R = P+ - P-`. -/
def branchReflection (h p m E : Real) : RMat2 :=
  positiveBranch h p m E - negativeBranch h p m E

/-- The branch reflection is the inverse-energy scalar multiple of the Hamiltonian. -/
theorem branchReflection_eq_inv_smul_hamiltonian
    (h p m E : Real) :
    branchReflection h p m E = E⁻¹ • chiralHamiltonian h p m := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [branchReflection, positiveBranch, negativeBranch, chiralHamiltonian,
      PhysicsSM.Draft.NullEdgeP2BranchResolution.positiveBranch,
      PhysicsSM.Draft.NullEdgeP2BranchResolution.negativeBranch,
      PhysicsSM.Draft.NullEdgeP2BranchResolution.chiralHamiltonian] <;>
    ring

/-- Spectral reconstruction of the Hamiltonian from the branch reflection. -/
theorem branchReflection_reconstructs_hamiltonian
    (h p m E : Real) (hE0 : E ≠ 0) :
    E • branchReflection h p m E = chiralHamiltonian h p m := by
  simpa [branchReflection] using
    PhysicsSM.Draft.NullEdgeP2BranchResolution.spectral_reconstruction h p m E hE0

/-- The branch reflection is traceless. -/
theorem branchReflection_trace_eq_zero
    (h p m E : Real) :
    Matrix.trace (branchReflection h p m E) = 0 := by
  rw [branchReflection, Matrix.trace_sub]
  rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.positiveBranch_trace_eq_one,
    PhysicsSM.Draft.NullEdgeP2BranchResolution.negativeBranch_trace_eq_one]
  norm_num

/-- On shell, the branch reflection is an involution. -/
theorem branchReflection_sq_eq_one_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    branchReflection h p m E * branchReflection h p m E = (1 : RMat2) := by
  calc
    branchReflection h p m E * branchReflection h p m E =
        positiveBranch h p m E * positiveBranch h p m E
          - positiveBranch h p m E * negativeBranch h p m E
          - negativeBranch h p m E * positiveBranch h p m E
          + negativeBranch h p m E * negativeBranch h p m E := by
            rw [branchReflection]
            noncomm_ring
    _ = positiveBranch h p m E + negativeBranch h p m E := by
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.positiveBranch_idempotent_on_massShell h p m E hh hE0 hshell]
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.positive_mul_negative_eq_zero_on_massShell h p m E hh hE0 hshell]
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.negative_mul_positive_eq_zero_on_massShell h p m E hh hE0 hshell]
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.negativeBranch_idempotent_on_massShell h p m E hh hE0 hshell]
      simp
    _ = (1 : RMat2) :=
      PhysicsSM.Draft.NullEdgeP2BranchResolution.positive_add_negative_eq_one h p m E

/-- The branch reflection commutes with its Hamiltonian generator. -/
theorem branchReflection_commutes_hamiltonian
    (h p m E : Real) :
  branchReflection h p m E * chiralHamiltonian h p m =
      chiralHamiltonian h p m * branchReflection h p m E := by
  rw [branchReflection_eq_inv_smul_hamiltonian]
  simp

/-- The positive branch is the `+1` sector of the branch reflection. -/
theorem branchReflection_mul_positive_eq_positive_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    branchReflection h p m E * positiveBranch h p m E =
      positiveBranch h p m E := by
  calc
    branchReflection h p m E * positiveBranch h p m E =
        positiveBranch h p m E * positiveBranch h p m E
          - negativeBranch h p m E * positiveBranch h p m E := by
            rw [branchReflection]
            noncomm_ring
    _ = positiveBranch h p m E := by
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.positiveBranch_idempotent_on_massShell h p m E hh hE0 hshell]
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.negative_mul_positive_eq_zero_on_massShell h p m E hh hE0 hshell]
      simp

/-- The negative branch is the `-1` sector of the branch reflection. -/
theorem branchReflection_mul_negative_eq_neg_negative_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    branchReflection h p m E * negativeBranch h p m E =
      -negativeBranch h p m E := by
  calc
    branchReflection h p m E * negativeBranch h p m E =
        positiveBranch h p m E * negativeBranch h p m E
          - negativeBranch h p m E * negativeBranch h p m E := by
            rw [branchReflection]
            noncomm_ring
    _ = -negativeBranch h p m E := by
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.positive_mul_negative_eq_zero_on_massShell h p m E hh hE0 hshell]
      rw [PhysicsSM.Draft.NullEdgeP2BranchResolution.negativeBranch_idempotent_on_massShell h p m E hh hE0 hshell]
      simp

/--
The reconstruction equation rigidly determines the branch reflection when the
energy scalar is nonzero.
-/
theorem branchReflection_unique_of_reconstructs
    (h p m E : Real) (R : RMat2) (hE0 : E ≠ 0)
    (hR : E • R = chiralHamiltonian h p m) :
    R = branchReflection h p m E := by
  have hR' := congr_arg (fun M : RMat2 => E⁻¹ • M) hR
  have hB' :=
    congr_arg (fun M : RMat2 => E⁻¹ • M)
      (branchReflection_reconstructs_hamiltonian h p m E hE0)
  simpa [smul_smul, hE0] using hR'.trans hB'.symm

end PhysicsSM.Draft.NullEdgeP2BranchReflection

end
