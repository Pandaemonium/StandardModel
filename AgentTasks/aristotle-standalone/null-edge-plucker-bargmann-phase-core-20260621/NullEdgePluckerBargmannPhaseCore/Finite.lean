import Mathlib

/-!
# Plucker/Bargmann phase core

Standalone finite algebra for the complex phase companion to the Plucker mass
theorem.

The real Plucker theorem keeps `|psi wedge phi|^2`.  This file asks Aristotle
to prove the finite identities that retain the complex first-order phase data:
the two-spinor Lagrange identity and the Bargmann triple trace for rank-one
spinor projectors.
-/

noncomputable section

namespace NullEdgePluckerBargmannPhaseCore

open BigOperators
open Matrix Complex

abbrev CSpinor := Fin 2 -> Complex

def complexAbsSq (z : Complex) : Complex :=
  z * starRingEnd Complex z

def spinorWedge (psi phi : CSpinor) : Complex :=
  psi 0 * phi 1 - psi 1 * phi 0

def spinorInner (psi phi : CSpinor) : Complex :=
  Finset.univ.sum fun a : Fin 2 =>
    starRingEnd Complex (psi a) * phi a

def spinorNormSq (psi : CSpinor) : Complex :=
  spinorInner psi psi

def rankOneKetBra (psi phi : CSpinor) : Matrix (Fin 2) (Fin 2) Complex :=
  Matrix.vecMulVec psi fun a => starRingEnd Complex (phi a)

def rankOneProjector (psi : CSpinor) : Matrix (Fin 2) (Fin 2) Complex :=
  rankOneKetBra psi psi

def trace2 (M : Matrix (Fin 2) (Fin 2) Complex) : Complex :=
  M 0 0 + M 1 1

/--
Two-spinor Lagrange identity: the Hermitian inner-product overlap and the
Plucker wedge split the product of spinor norms.
-/
theorem plucker_lagrange_identity (psi phi : CSpinor) :
    complexAbsSq (spinorInner psi phi) +
        complexAbsSq (spinorWedge psi phi) =
      spinorNormSq psi * spinorNormSq phi := by
  sorry

/-- The trace of a ket-bra rank-one matrix is the reversed Hermitian pairing. -/
theorem trace_rankOneKetBra (psi phi : CSpinor) :
    trace2 (rankOneKetBra psi phi) = spinorInner phi psi := by
  sorry

/-- Product of two finite ket-bra rank-one matrices. -/
theorem rankOneKetBra_mul
    (psi phi chi eta : CSpinor) :
    rankOneKetBra psi phi * rankOneKetBra chi eta =
      spinorInner phi chi • rankOneKetBra psi eta := by
  sorry

/-- Product of two spinor projectors keeps the complex overlap amplitude. -/
theorem rankOneProjector_mul (psi phi : CSpinor) :
    rankOneProjector psi * rankOneProjector phi =
      spinorInner psi phi • rankOneKetBra psi phi := by
  sorry

/--
Finite Bargmann/Pancharatnam triple: the trace of three rank-one spinor
projectors is the cyclic product of Hermitian overlaps.
-/
theorem bargmannTripleTrace_rankOne
    (psi phi chi : CSpinor) :
    trace2 (rankOneProjector psi * rankOneProjector phi *
        rankOneProjector chi) =
      spinorInner psi phi * spinorInner phi chi * spinorInner chi psi := by
  sorry

/--
Normalized two-spinor corollary: for unit spinors, the Plucker squared modulus
is the complement of the squared Hermitian overlap.  This is the finite
Fubini-Study/chordal-distance bridge used by the null-edge program.
-/
theorem normalized_plucker_eq_one_sub_overlap
    (psi phi : CSpinor)
    (hpsi : spinorNormSq psi = 1)
    (hphi : spinorNormSq phi = 1) :
    complexAbsSq (spinorWedge psi phi) =
      1 - complexAbsSq (spinorInner psi phi) := by
  sorry

end NullEdgePluckerBargmannPhaseCore

end
