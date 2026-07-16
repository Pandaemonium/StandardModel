import Mathlib

/-!
# Aristotle target: full-Fock exponential of the pair-transfer generator

The occupation basis has sixteen states, indexed by finite subsets of `Fin 4`.
The matrix `KopMatrix z` has one active two-by-two block coupling `lowPair` and
`highPair` and vanishes elsewhere. Prove that its genuine matrix exponential,
acting by `mulVec`, equals the displayed closed-form `Uop` on every occupation
coordinate.

This is stronger than an active-sector restriction: the theorem includes the
identity action on all fourteen inactive basis states. Keep every definition
and the target statement unchanged. Run
`lake env lean FullFockPairExponential.lean`.
-/

noncomputable section

namespace FullFockPairExponential

open Matrix

abbrev Occ := Finset (Fin 4)
abbrev Fock := Occ -> Complex

def lowPair : Occ := {0, 1}
def highPair : Occ := {2, 3}

/-- The Hermitian pair-transfer matrix on the full occupation basis. -/
def KopMatrix (z : Complex) : Matrix Occ Occ Complex := fun S T =>
  if S = lowPair ∧ T = highPair then z
  else if S = highPair ∧ T = lowPair then (starRingEnd Complex) z
  else 0

/-- Closed-form full-Fock evolution: a cosine-sine block on the active pair
sector and identity on its complement. -/
def Uop (c s : Real) (z : Complex) (m : Real) (psi : Fock) : Fock := fun S =>
  if S = lowPair then
    (c : Complex) * psi lowPair -
      Complex.I * (s : Complex) * (z / (m : Complex)) * psi highPair
  else if S = highPair then
    (c : Complex) * psi highPair -
      Complex.I * (s : Complex) *
        ((starRingEnd Complex) z / (m : Complex)) * psi lowPair
  else psi S

/-- **TARGET.** The full occupation-basis exponential is exactly `Uop`. -/
theorem exp_mulVec_eq_Uop (z : Complex) (a : Real) (hz : z ≠ 0) (psi : Fock) :
    (NormedSpace.exp
        ((-(a : Complex) * Complex.I) • KopMatrix z)).mulVec psi =
      Uop (Real.cos (a * ‖z‖)) (Real.sin (a * ‖z‖)) z ‖z‖ psi := by
  sorry

end FullFockPairExponential
