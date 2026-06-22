import PhysicsSM.Spinor.PluckerMass

/-!
# Bargmann phase port

This draft module ports the finite Bargmann/Pancharatnam phase algebra to the
canonical trusted Pluecker primitives in `PhysicsSM.Spinor.PluckerMass`.

The key consolidation point is that `complexAbsSq`, `spinorWedge`, and
`rankOneHermitian` are shared with the trusted Pluecker mass theorem, while
`spinorInner`, `rankOneKetBra`, and Bargmann triple traces form a phase
companion layer.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeBargmannPhasePort

open BigOperators
open Matrix Complex
open PhysicsSM.Spinor.PluckerMass

/-- Hermitian spinor pairing, conjugate-linear in the first argument. -/
def spinorInner (psi phi : CSpinor) : Complex :=
  Finset.univ.sum fun a : Fin 2 =>
    starRingEnd Complex (psi a) * phi a

/-- Squared Hermitian norm of a spinor. -/
def spinorNormSq (psi : CSpinor) : Complex :=
  spinorInner psi psi

/-- Rank-one ket-bra matrix `|psi><phi|`. -/
def rankOneKetBra (psi phi : CSpinor) : Matrix (Fin 2) (Fin 2) Complex :=
  Matrix.vecMulVec psi fun a => starRingEnd Complex (phi a)

/-- Rank-one spinor projector `|psi><psi|`. -/
def rankOneProjector (psi : CSpinor) : Matrix (Fin 2) (Fin 2) Complex :=
  rankOneKetBra psi psi

/-- Trace of a `2 x 2` complex matrix. -/
def trace2 (M : Matrix (Fin 2) (Fin 2) Complex) : Complex :=
  M 0 0 + M 1 1

/-- The trusted Hermitian momentum is the self ket-bra. -/
theorem rankOneHermitian_eq_rankOneKetBra_self (psi : CSpinor) :
    rankOneHermitian psi = rankOneKetBra psi psi := by
  exact Matrix.ext fun i => congrFun rfl

/--
Two-spinor Lagrange identity using the canonical trusted Pluecker wedge and
complex squared modulus.
-/
theorem plucker_lagrange_identity (psi phi : CSpinor) :
    complexAbsSq (spinorInner psi phi) +
        complexAbsSq (spinorWedge psi phi) =
      spinorNormSq psi * spinorNormSq phi := by
  unfold complexAbsSq spinorInner spinorWedge spinorNormSq
  unfold spinorInner
  norm_num [Fin.sum_univ_two]
  ring

/-- The trace of a ket-bra rank-one matrix is the reversed Hermitian pairing. -/
theorem trace_rankOneKetBra (psi phi : CSpinor) :
    trace2 (rankOneKetBra psi phi) = spinorInner phi psi := by
  unfold trace2 rankOneKetBra spinorInner
  simp +decide [mul_comm, vecMulVec]

/-- Product of two finite ket-bra rank-one matrices. -/
theorem rankOneKetBra_mul
    (psi phi chi eta : CSpinor) :
    rankOneKetBra psi phi * rankOneKetBra chi eta =
      spinorInner phi chi • rankOneKetBra psi eta := by
  unfold rankOneKetBra spinorInner
  ext i j
  simp +decide [Matrix.mul_apply, vecMulVec]
  ring

/-- Product of two spinor projectors keeps the complex overlap amplitude. -/
theorem rankOneProjector_mul (psi phi : CSpinor) :
    rankOneProjector psi * rankOneProjector phi =
      spinorInner psi phi • rankOneKetBra psi phi := by
  convert rankOneKetBra_mul psi psi phi phi using 1

/--
Finite Bargmann/Pancharatnam triple: the trace of three rank-one spinor
projectors is the cyclic product of Hermitian overlaps.
-/
theorem bargmannTripleTrace_rankOne
    (psi phi chi : CSpinor) :
    trace2 (rankOneProjector psi * rankOneProjector phi *
        rankOneProjector chi) =
      spinorInner psi phi * spinorInner phi chi * spinorInner chi psi := by
  unfold rankOneProjector
  unfold rankOneKetBra
  unfold trace2 spinorInner
  simp +decide [Matrix.mul_apply, vecMulVec]
  ring

/--
Normalized two-spinor corollary: for unit spinors, the Pluecker squared modulus
is the complement of the squared Hermitian overlap.
-/
theorem normalized_plucker_eq_one_sub_overlap
    (psi phi : CSpinor)
    (hpsi : spinorNormSq psi = 1)
    (hphi : spinorNormSq phi = 1) :
    complexAbsSq (spinorWedge psi phi) =
      1 - complexAbsSq (spinorInner psi phi) := by
  grind +suggestions

end PhysicsSM.Draft.NullEdgeBargmannPhasePort

end
