import PhysicsSM.Draft.NullEdge.FullBlochSplitDeterminants

namespace PhysicsSM.Draft.NullEdge.FullBlochSplitMinus

open FullBlochSplitDeterminants

/-! Focused `-1` Floquet determinant target using the harvested expansion. -/

set_option maxHeartbeats 12000000
set_option maxRecDepth 10000

/-- Exact all-momentum determinant formula at eigenvalue `-1`. -/
theorem det_splitStep_add_one (qx qy qz theta : Real) :
    Matrix.det (splitStep qx qy qz theta + (1 : Mat4)) =
      (4 * piModePolynomial qx qy qz theta : Real) := by
  rw [piModePolynomial];
  convert det_fin_four _ using 1;
  rw [ splitStep_eq ];
  simp +decide [ Complex.ext_iff, Matrix.one_apply ];
  norm_cast; ring_nf;
  rw [ show Real.sin qx ^ 4 = ( Real.sin qx ^ 2 ) ^ 2 by ring, show Real.sin qy ^ 4 = ( Real.sin qy ^ 2 ) ^ 2 by ring, show Real.sin qz ^ 4 = ( Real.sin qz ^ 2 ) ^ 2 by ring, show Real.sin theta ^ 4 = ( Real.sin theta ^ 2 ) ^ 2 by ring, Real.sin_sq, Real.sin_sq, Real.sin_sq, Real.sin_sq ] ; ring;
  exact ⟨ by unfold spectralBase; ring, trivial ⟩

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.FullBlochSplitMinus.det_splitStep_add_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_splitStep_add_one

end PhysicsSM.Draft.NullEdge.FullBlochSplitMinus
