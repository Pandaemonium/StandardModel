import PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUMassiveSpectralReciprocity

/-- Momentum reversal preserves the exact trace of the two-component HNU
endpoint. -/
theorem endpoint_neg_trace_eq (k : Fin 3 -> Real) :
    (endpoint (fun i => -k i)).trace = (endpoint k).trace := by
  simp [trace_endpoint, neg_div]

set_option maxHeartbeats 6000000 in
/-- General spectral-parameter version of the live massive HNU shifted
determinant reduction. -/
theorem massiveHNU_general_shifted_det_reduction (a : Real)
    (k : Fin 3 -> Real) (lambda : Complex) :
    (massiveHNU (1 : Complex) a k -
        lambda • (1 : Matrix (Fin 4) (Fin 4) Complex)).det =
      (endpoint k * endpoint (fun i => -k i) -
        (lambda * Real.cos a) •
          (endpoint k + endpoint (fun i => -k i)) +
        lambda ^ 2 • (1 : Matrix (Fin 2) (Fin 2) Complex)).det := by
  unfold massiveHNU diracHNU
    PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.massCoin4
    PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.mass4
    PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.beta
    PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.beta5
    PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.gamma5
  unfold diracBasis doubledChiralEndpoint
  norm_num [Matrix.det_succ_row_zero]
  simp +decide [Fin.sum_univ_succ, Fin.succAbove, Matrix.mul_apply,
    Matrix.one_apply] at *
  simp +decide [Matrix.vecMul, Matrix.vecHead, Matrix.vecTail] at *
  ring_nf at *
  norm_cast
  norm_num [show (Real.sqrt 2 : Real) ^ 6 = (Real.sqrt 2 ^ 2) ^ 3 by ring,
    show (Real.sqrt 2 : Real) ^ 8 = (Real.sqrt 2 ^ 2) ^ 4 by ring]
  ring_nf
  norm_cast
  norm_num [show (Real.sqrt 2 : Real) ^ 4 = (Real.sqrt 2 ^ 2) ^ 2 by ring,
    show (Real.sqrt 2 : Real) ^ 2 = 2 by norm_num]
  norm_num [Complex.sin_sq]
  have hsin4 : Complex.sin (a : Complex) ^ 4 =
      (1 - Complex.cos (a : Complex) ^ 2) ^ 2 := by
    rw [show Complex.sin (a : Complex) ^ 4 =
      (Complex.sin (a : Complex) ^ 2) ^ 2 by ring]
    rw [Complex.sin_sq]
  rw [hsin4]
  ring

end PhysicsSM.Draft.NullEdge.HNUMassiveSpectralReciprocity
