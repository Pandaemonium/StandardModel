import Mathlib

/-!
# NullStrand.BellQFT.FiniteCurrent

Finite-dimensional Bell-current algebra used by the null-strand roadmap.
-/

noncomputable section

namespace PhysicsSM.NullStrand.BellQFT

open scoped BigOperators
open Matrix

/-- Positive part of a real scalar. -/
def realPos (z : Real) : Real := max z 0

@[simp] theorem realPos_nonneg (z : Real) : 0 <= realPos z := le_max_right _ _

/-- Apply a finite matrix to a vector. -/
def matVec {Q : Type*} [Fintype Q] (A : Matrix Q Q Complex) (v : Q -> Complex) : Q -> Complex :=
  fun q => ∑ q', A q q' * v q'

/-- Standard finite complex inner product, conjugate-linear in the first slot. -/
def vectorInner {Q : Type*} [Fintype Q] (u v : Q -> Complex) : Complex :=
  ∑ q, star (u q) * v q

/-- Bell current associated to the block `P q * H * P q'`. -/
def quantumCurrent {Q : Type*} [Fintype Q] (q q' : Q) (psi : Q -> Complex)
    (H : Matrix Q Q Complex) (P : Q -> Matrix Q Q Complex) : Real :=
  2 * Complex.im (vectorInner psi (matVec (P q * H * P q') psi))

/-- A zero block contributes zero Bell current. -/
theorem quantumCurrent_zero_of_block_zero {Q : Type*} [Fintype Q] (q q' : Q)
    (psi : Q -> Complex) (H : Matrix Q Q Complex) (P : Q -> Matrix Q Q Complex)
    (hblock : P q * H * P q' = 0) :
    quantumCurrent q q' psi H P = 0 := by
  simp [quantumCurrent, matVec, vectorInner, hblock]

end PhysicsSM.NullStrand.BellQFT
