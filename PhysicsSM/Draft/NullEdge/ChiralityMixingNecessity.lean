import Mathlib

/-!
# Chirality-even and chirality-odd coefficient projections

This draft module isolates the exact coefficient algebra behind the statement
that a correct Dirac first jet has no chirality-odd constant or linear term. It
does not infer a global no-doubling theorem; that implication requires a
separately verified total-charge theorem.

Provenance: clean-room formalization of the projection argument supplied in the
July 11, 2026 strict-3+1 analysis. Focused proof completion by Aristotle project
`a096d3ca-fcd4-45f8-9e3d-6dc85789872f`, task
`49d6bec0-889b-44d4-b7d5-f62806c4bd66`; statements were preserved.
-/

namespace PhysicsSM.Draft.NullEdge.ChiralityMixingNecessity

abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

noncomputable def parallelPart (Xi U : M4) : M4 :=
  (2 : Complex)⁻¹ • (U + Xi * U * Xi)

noncomputable def perpPart (Xi U : M4) : M4 :=
  (2 : Complex)⁻¹ • (U - Xi * U * Xi)

theorem parallelPart_add_perpPart (Xi U : M4) :
    parallelPart Xi U + perpPart Xi U = U := by
  unfold parallelPart perpPart
  rw [← smul_add]
  rw [show (U + Xi * U * Xi) + (U - Xi * U * Xi) = (2 : Complex) • U by module]
  rw [smul_smul]
  norm_num

theorem Xi_mul_parallelPart_eq
    (Xi U : M4) (hXi : Xi * Xi = 1) :
    Xi * parallelPart Xi U = parallelPart Xi U * Xi := by
  unfold parallelPart
  rw [Matrix.mul_smul, Matrix.smul_mul]
  congr 1
  rw [Matrix.mul_add, Matrix.add_mul]
  have h1 : Xi * (Xi * U * Xi) = U * Xi := by
    rw [← Matrix.mul_assoc, ← Matrix.mul_assoc, hXi, Matrix.one_mul]
  have h2 : (Xi * U * Xi) * Xi = Xi * U := by
    rw [Matrix.mul_assoc, hXi, Matrix.mul_one]
  rw [h1, h2, add_comm]

theorem Xi_mul_perpPart_eq_neg
    (Xi U : M4) (hXi : Xi * Xi = 1) :
    Xi * perpPart Xi U = -(perpPart Xi U * Xi) := by
  unfold perpPart
  rw [Matrix.mul_smul, Matrix.smul_mul, ← smul_neg]
  congr 1
  rw [Matrix.mul_sub, Matrix.sub_mul]
  have h1 : Xi * (Xi * U * Xi) = U * Xi := by
    rw [← Matrix.mul_assoc, ← Matrix.mul_assoc, hXi, Matrix.one_mul]
  have h2 : (Xi * U * Xi) * Xi = Xi * U := by
    rw [Matrix.mul_assoc, hXi, Matrix.mul_one]
  rw [h1, h2]
  abel

theorem perpPart_eq_zero_of_commutes
    (Xi U : M4) (hXi : Xi * Xi = 1)
    (hcomm : Xi * U = U * Xi) :
    perpPart Xi U = 0 := by
  unfold perpPart
  have h : Xi * U * Xi = U := by
    rw [hcomm, Matrix.mul_assoc, hXi, Matrix.mul_one]
  rw [h, sub_self, smul_zero]

theorem perpPart_one_eq_zero (Xi : M4) (hXi : Xi * Xi = 1) :
    perpPart Xi 1 = 0 := by
  apply perpPart_eq_zero_of_commutes Xi 1 hXi
  rw [Matrix.mul_one, Matrix.one_mul]

/-- If all three Dirac tangent coefficients commute with chirality, their odd
first jet vanishes coefficient by coefficient. -/
theorem diracFirstJet_perp_eq_zero
    (Xi A1 A2 A3 : M4) (hXi : Xi * Xi = 1)
    (h1 : Xi * A1 = A1 * Xi)
    (h2 : Xi * A2 = A2 * Xi)
    (h3 : Xi * A3 = A3 * Xi) :
    perpPart Xi A1 = 0 ∧ perpPart Xi A2 = 0 ∧ perpPart Xi A3 = 0 :=
  ⟨perpPart_eq_zero_of_commutes Xi A1 hXi h1,
   perpPart_eq_zero_of_commutes Xi A2 hXi h2,
   perpPart_eq_zero_of_commutes Xi A3 hXi h3⟩

/-- Nonvacuity fixture: an involutory chirality has a genuinely nonzero odd
coefficient. -/
theorem exists_nonzero_perpPart :
    Exists fun Xi : M4 => Exists fun G : M4 =>
      Xi * Xi = 1 ∧ perpPart Xi G ≠ 0 := by
  refine ⟨!![1,0,0,0;0,1,0,0;0,0,-1,0;0,0,0,-1],
    !![0,0,1,0;0,0,0,0;0,0,0,0;0,0,0,0], ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_four]
  · intro h
    have h02 := congrFun (congrFun h 0) 2
    simp [perpPart] at h02

end PhysicsSM.Draft.NullEdge.ChiralityMixingNecessity
