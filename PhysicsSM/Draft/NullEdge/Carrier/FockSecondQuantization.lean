import Mathlib

/-!
# Finite second-quantization identities

This module records small, kernel-checked finite shadows of the Q08
second-quantization program.  The flagship exterior-algebra quotient theorem
and the general `dGamma` square identity are intentionally left to the active
Aristotle lanes; here we pin a minimal two-mode diagonal witness:

`dGamma(D)^2 = dGamma(D^2) + 2 dGamma_2(Lambda^2 D)`.

For two fermion modes and a diagonal one-particle operator with entries `d 0`
and `d 1`, the second-quantized diagonal action on an occupation state is the
sum of occupied one-particle eigenvalues.  Squaring it produces the one-body
square plus exactly the two-body cross term when both modes are occupied.

Provenance: Q08 Fable answer, Section 4 / ladder `L-Q8-3`, clean-room finite
formalization of the diagonal two-mode sanity check.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.FockSecondQuantization

/-- Two fermion modes, represented by their occupation bits. -/
abbrev Fock2State := Fin 2 -> Bool

/-- Diagonal second quantization on the two-mode occupation basis:
sum the eigenvalues of the occupied modes. -/
def dGammaDiag {R : Type*} [Zero R] [Add R] (d : Fin 2 -> R) (occ : Fock2State) : R :=
  (if occ 0 then d 0 else 0) + (if occ 1 then d 1 else 0)

/-- The two-body diagonal contribution, present exactly on the doubly occupied state. -/
def dGammaPairDiag {R : Type*} [Zero R] [Mul R] (d : Fin 2 -> R) (occ : Fock2State) :
    R :=
  if occ 0 && occ 1 then d 0 * d 1 else 0

/-- Two-mode diagonal `dGamma` square identity.

This is the finite occupation-basis witness for the Q08 interaction slogan:
squaring the second-quantized one-particle operator gives the second
quantization of the square plus the canonical two-body cross term. -/
theorem dGammaDiag_square_two_mode {R : Type*} [CommSemiring R] (d : Fin 2 -> R)
    (occ : Fock2State) :
    dGammaDiag d occ ^ 2 =
      dGammaDiag (fun i => d i ^ 2) occ + 2 * dGammaPairDiag d occ := by
  by_cases h0 : occ 0
  · by_cases h1 : occ 1
    · simp [dGammaDiag, dGammaPairDiag, h0, h1]
      ring
    · simp [dGammaDiag, dGammaPairDiag, h0, h1]
  · by_cases h1 : occ 1
    · simp [dGammaDiag, dGammaPairDiag, h0, h1]
    · simp [dGammaDiag, dGammaPairDiag, h0, h1]

/-- On the doubly occupied state, the two-body term is the product of the two
one-particle eigenvalues. -/
theorem dGammaPairDiag_both_occupied {R : Type*} [Zero R] [Mul R] (d : Fin 2 -> R) :
    dGammaPairDiag d (fun _ => true) = d 0 * d 1 := by
  simp [dGammaPairDiag]

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FockSecondQuantization.dGammaDiag_square_two_mode' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms dGammaDiag_square_two_mode

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FockSecondQuantization.dGammaPairDiag_both_occupied' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms dGammaPairDiag_both_occupied

end PhysicsSM.Draft.NullEdge.Carrier.FockSecondQuantization
