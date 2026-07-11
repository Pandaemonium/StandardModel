import PhysicsSM.Draft.NullEdge.CarrierRigidity

namespace PhysicsSM.Draft.NullEdge.ChannelSolderDegreeNoGoCheck

open CarrierRigidity.Concrete

def solderProjector : N := c1 * kadj c1

theorem solderProjector_value :
    solderProjector = !![1,0,0,0; 0,1,0,0; 0,0,0,0; 0,0,0,0] := by
  rw [solderProjector, kadj_c1]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [c1, Matrix.mul_apply, Fin.sum_univ_four]

theorem solderProjector_idempotent :
    solderProjector * solderProjector = solderProjector := by
  rw [solderProjector_value]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem solderProjector_nonzero : solderProjector ≠ 0 := by
  rw [solderProjector_value]
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num at h00

theorem no_additive_solder_degree_selector :
    ¬ ∃ S : N →+ N,
      S solderProjector = (2 : ℚ) • solderProjector ∧
      S (solderProjector * solderProjector) =
        (4 : ℚ) • (solderProjector * solderProjector) := by
  rintro ⟨S, htwo, hfour⟩
  rw [solderProjector_idempotent] at hfour
  rw [htwo] at hfour
  have h00 := congrFun (congrFun hfour 0) 0
  rw [solderProjector_value] at h00
  norm_num at h00

end PhysicsSM.Draft.NullEdge.ChannelSolderDegreeNoGoCheck
