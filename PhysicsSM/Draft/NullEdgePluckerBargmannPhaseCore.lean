import Mathlib

/-!
# Draft.NullEdgePluckerBargmannPhaseCore

Finite algebra for the complex phase companion to the Pluecker mass theorem.

The real Pluecker theorem keeps `|psi wedge phi|^2`.  This draft module
retains nearby first-order phase data: the two-spinor Lagrange identity, the
rank-one ket-bra contraction law, and the finite Bargmann/Pancharatnam triple
trace for spinor projectors.

Provenance: integrated from the focused Aristotle job
`null-edge-plucker-bargmann-phase-core-20260621`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgePluckerBargmannPhaseCore

open BigOperators
open Matrix Complex

abbrev CSpinor := Fin 2 -> Complex

/-- Complex squared modulus, kept as a complex scalar for matrix comparisons. -/
def complexAbsSq (z : Complex) : Complex :=
  z * starRingEnd Complex z

/-- Spinor wedge / Pluecker coordinate of two complex two-spinors. -/
def spinorWedge (psi phi : CSpinor) : Complex :=
  psi 0 * phi 1 - psi 1 * phi 0

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

/--
Two-spinor Lagrange identity: the Hermitian inner-product overlap and the
Pluecker wedge split the product of spinor norms.
-/
theorem plucker_lagrange_identity (psi phi : CSpinor) :
    complexAbsSq (spinorInner psi phi) +
        complexAbsSq (spinorWedge psi phi) =
      spinorNormSq psi * spinorNormSq phi := by
  unfold complexAbsSq spinorNormSq spinorInner spinorWedge
  simp only [Complex.ext_iff, Fin.sum_univ_two]
  constructor <;> simp <;> ring

/-- The trace of a ket-bra rank-one matrix is the reversed Hermitian pairing. -/
theorem trace_rankOneKetBra (psi phi : CSpinor) :
    trace2 (rankOneKetBra psi phi) = spinorInner phi psi := by
  unfold trace2 rankOneKetBra spinorInner
  simp [mul_comm, Matrix.vecMulVec]

/-- Product of two finite ket-bra rank-one matrices. -/
theorem rankOneKetBra_mul
    (psi phi chi eta : CSpinor) :
    rankOneKetBra psi phi * rankOneKetBra chi eta =
      spinorInner phi chi • rankOneKetBra psi eta := by
  unfold rankOneKetBra spinorInner
  ext i j
  simp [Matrix.mul_apply, Matrix.vecMulVec]
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
  unfold trace2 rankOneProjector rankOneKetBra spinorInner
  simp +decide [Fin.sum_univ_two, Matrix.mul_apply, Matrix.vecMulVec]
  ring!

/--
Normalized two-spinor corollary: for unit spinors, the Pluecker squared modulus
is the complement of the squared Hermitian overlap.  This is the finite
Fubini-Study/chordal-distance bridge used by the null-edge program.
-/
theorem normalized_plucker_eq_one_sub_overlap
    (psi phi : CSpinor)
    (hpsi : spinorNormSq psi = 1)
    (hphi : spinorNormSq phi = 1) :
    complexAbsSq (spinorWedge psi phi) =
      1 - complexAbsSq (spinorInner psi phi) := by
  have h := plucker_lagrange_identity psi phi
  rw [hpsi, hphi] at h
  linear_combination h

end PhysicsSM.Draft.NullEdgePluckerBargmannPhaseCore

end
