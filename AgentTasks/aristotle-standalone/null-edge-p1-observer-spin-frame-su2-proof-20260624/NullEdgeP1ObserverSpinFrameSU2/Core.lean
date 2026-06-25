import Mathlib

/-!
# P1 observer spin frame is well-defined up to SU(2)

This standalone target turns the design scaffold
`observerSpinFrame_wellDefined_up_to_SU2` into a proof-only Aristotle job.

Physics context: in the observer-channel version of P1, the unnormalized
visible momentum block transforms by `SL(2,C)` congruence. Once the observer's
rest/timelike block is fixed, the remaining freedom in the spin frame should be
unitary with determinant one: the residual compact `SU(2)` little group. This is
the finite frame-audit guardrail behind the statement that invariant mass is
held by the unnormalized determinant, while normalized celestial data remain
observer-frame dependent.
-/

noncomputable section

namespace NullEdgeP1ObserverSpinFrameSU2.Core

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

end NullEdgeP1ObserverSpinFrameSU2.Core
