import Mathlib

/-!
# Algebraic neutrality of a mass-admitting Dirac tangent

This draft module isolates the finite Clifford calculation behind the corrected
strict 3+1 strategy. It proves an algebraic gapped interpolation, an explicit
nonvacuity fixture, and a missing-anticommutation control. It does not define a
Chern class or claim a topological classification API.

Provenance: clean-room formalization of the mass-homotopy argument supplied in
the July 11, 2026 strict-3+1 analysis. Focused proof completion by Aristotle
project `86d33c00-765b-4e50-869d-271690b820f8`, task
`49f47050-9c5c-4378-b096-377b9859308d`; statements were preserved.
-/

namespace PhysicsSM.Draft.NullEdge.DiracLocalChargeNeutrality

abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

/-- The algebraic circle interpolation between a flattened tangent and an
anticommuting mass involution. -/
def massBlend (c s : Complex) (F beta : M4) : M4 :=
  c • F + s • beta

/-- The cross term vanishes, so every point of the circle interpolation remains
an involution. This is the finite algebraic core of full-Dirac neutrality. -/
theorem massBlend_sq
    (c s : Complex) (F beta : M4)
    (hF : F * F = 1)
    (hbeta : beta * beta = 1)
    (hanti : F * beta + beta * F = 0)
    (hcircle : c * c + s * s = 1) :
    massBlend c s F beta * massBlend c s F beta = 1 := by
  unfold massBlend
  have expand : (c • F + s • beta) * (c • F + s • beta)
      = (c * c) • (F * F) + (c * s) • (F * beta + beta * F) +
        (s * s) • (beta * beta) := by
    simp only [Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul, Matrix.mul_smul,
      smul_add, smul_smul]
    module
  rw [expand, hF, hbeta, hanti]
  simp only [smul_zero, add_zero]
  rw [← add_smul, hcircle, one_smul]

theorem massBlend_start (F beta : M4) : massBlend 1 0 F beta = F := by
  simp [massBlend]

theorem massBlend_end (F beta : M4) : massBlend 0 1 F beta = beta := by
  simp [massBlend]

/-- Nonvacuity fixture: distinct anticommuting involutions exist in four complex
dimensions. -/
theorem exists_distinct_anticommuting_involutions :
    Exists fun F : M4 => Exists fun beta : M4 =>
      F * F = 1 ∧ beta * beta = 1 ∧
      F * beta + beta * F = 0 ∧ F ≠ beta := by
  refine ⟨!![0,1,0,0;1,0,0,0;0,0,0,1;0,0,1,0],
    !![1,0,0,0;0,-1,0,0;0,0,1,0;0,0,0,-1], ?_, ?_, ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_four]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_four]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.add_apply]
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    simp at h00

/-- Negative control: without anticommutation, circle normalization alone does
not force the blend to square to the identity. -/
theorem exists_nonanticommuting_blend_failure :
    Exists fun c : Complex => Exists fun s : Complex =>
      c * c + s * s = 1 ∧
      Exists fun F : M4 => Exists fun beta : M4 =>
        F * F = 1 ∧ beta * beta = 1 ∧
        massBlend c s F beta * massBlend c s F beta ≠ 1 := by
  refine ⟨3 / 5, 4 / 5, by norm_num, 1, 1, by simp, by simp, ?_⟩
  intro h
  have h00 := congrFun (congrFun h 0) 0
  simp [massBlend, Matrix.mul_apply, Fin.sum_univ_four, Matrix.one_apply] at h00
  norm_num at h00

end PhysicsSM.Draft.NullEdge.DiracLocalChargeNeutrality
