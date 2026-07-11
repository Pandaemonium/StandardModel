import PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge

noncomputable section

open Matrix Complex
open scoped ZMod

namespace PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge

theorem test_isUnitary_mul (U V : Mat4)
    (hU : SuccessiveAxisDiracWalk.IsUnitary U)
    (hV : SuccessiveAxisDiracWalk.IsUnitary V) :
    SuccessiveAxisDiracWalk.IsUnitary (U * V) := by
  constructor
  · rw [Matrix.conjTranspose_mul, Matrix.mul_assoc,
      ← Matrix.mul_assoc Uᴴ U V, hU.1, one_mul, hV.1]
  · rw [Matrix.conjTranspose_mul, Matrix.mul_assoc,
      ← Matrix.mul_assoc V Vᴴ Uᴴ, hV.2, one_mul, hU.2]

theorem test_phaseDiag_unitary {L : Nat} [NeZero L]
    (axis : Axis) (k : Position L) :
    SuccessiveAxisDiracWalk.IsUnitary (phaseDiag axis k) := by
  constructor <;>
    rw [phaseDiag, Matrix.diagonal_conjTranspose,
      Matrix.diagonal_mul_diagonal, ← Matrix.diagonal_one] <;>
    congr 1 <;>
    funext a
  · change (starRingEnd ℂ) (shiftPhase axis k a) * shiftPhase axis k a = 1
    rw [← Complex.normSq_eq_conj_mul_self]
    change ((Complex.normSq (shiftPhase axis k a) : Real) : Complex) = 1
    norm_cast
    rw [Complex.normSq_eq_norm_sq, shiftPhase_norm]
    norm_num
  · change shiftPhase axis k a * (starRingEnd ℂ) (shiftPhase axis k a) = 1
    rw [mul_comm, ← Complex.normSq_eq_conj_mul_self]
    change ((Complex.normSq (shiftPhase axis k a) : Real) : Complex) = 1
    norm_cast
    rw [Complex.normSq_eq_norm_sq, shiftPhase_norm]
    norm_num

theorem test_finiteAxisSymbol_unitary {L : Nat} [NeZero L]
    (axis : Axis) (k : Position L) :
    SuccessiveAxisDiracWalk.IsUnitary (finiteAxisSymbol axis k) := by
  unfold finiteAxisSymbol
  exact test_isUnitary_mul _ _
    (test_isUnitary_mul _ _
      (CliffordDiagonalPositionBridge.axisBasis_unitary axis)
      (test_phaseDiag_unitary axis k))
    (CliffordDiagonalPositionBridge.conjTranspose_unitary _
      (CliffordDiagonalPositionBridge.axisBasis_unitary axis))

theorem test_finiteLocalSymbol_unitary {L : Nat} [NeZero L]
    (m eps : Real) (k : Position L) :
    SuccessiveAxisDiracWalk.IsUnitary (finiteLocalSymbol m eps k) := by
  unfold finiteLocalSymbol
  exact test_isUnitary_mul _ _
    (test_isUnitary_mul _ _
      (test_isUnitary_mul _ _
        (test_finiteAxisSymbol_unitary 0 k)
        (test_finiteAxisSymbol_unitary 1 k))
      (test_finiteAxisSymbol_unitary 2 k))
    (Local3Plus1RateBridge.massFactor_unitary m eps)

end PhysicsSM.Draft.NullEdge.Finite3Plus1FourierBridge
