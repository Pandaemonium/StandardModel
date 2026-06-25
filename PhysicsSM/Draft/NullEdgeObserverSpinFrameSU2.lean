import Mathlib

/-!
# Observer spin frame is well-defined up to `SU(2)`

This draft module integrates Aristotle project
`7a6ac35f-f9ce-43ae-8f6c-f4ef3bc60298`.

Physics context: in the observer-channel version of P1, the unnormalized
visible momentum block transforms by `SL(2,C)` congruence. Once the observer's
rest/timelike Hermitian block is fixed, the remaining spin-frame freedom is the
compact residual `SU(2)` little group.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeObserverSpinFrameSU2

open Matrix

/-- The observer/rest Hermitian block presented by a spin frame. -/
def observerBlock (A : Matrix (Fin 2) (Fin 2) Complex) :
    Matrix (Fin 2) (Fin 2) Complex :=
  A * A.conjTranspose

/--
If two determinant-one spin frames present the same observer block, their
relative transformation is in `SU(2)`.

This is the finite stabilizer statement for the P1 frame audit: fixing the
observer block leaves exactly the compact residual spin-frame freedom.
-/
theorem observerSpinFrame_wellDefined_up_to_SU2
    (A B : Matrix (Fin 2) (Fin 2) Complex)
    (hA : A.det = 1) (hB : B.det = 1)
    (hobs : observerBlock A = observerBlock B) :
    B⁻¹ * A ∈ Matrix.specialUnitaryGroup (Fin 2) Complex := by
  refine ⟨?_, ?_⟩
  · simp_all +decide [observerBlock, unitaryGroup]
    constructor <;> simp_all +decide [Matrix.mul_assoc]
    · simp_all +decide [star, Matrix.conjTranspose_nonsing_inv]
      simp_all +decide [← mul_assoc, ← Matrix.mul_inv_rev]
      simp_all +decide [← hobs, Matrix.mul_inv_rev]
    · simp_all +decide [← mul_assoc, Matrix.nonsing_inv_mul, star]
      simp_all +decide [← Matrix.conjTranspose_mul, Matrix.inv_def]
      simp_all +decide [Matrix.adjugate_mul]
  · simp +decide [hA, hB, Matrix.det_mul]

end PhysicsSM.Draft.NullEdgeObserverSpinFrameSU2
