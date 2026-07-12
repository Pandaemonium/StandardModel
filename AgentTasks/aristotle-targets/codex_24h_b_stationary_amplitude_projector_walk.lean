import Mathlib

/-!
# Stationary-amplitude projector walk

Clean-room theorem shape motivated by Gupta-Short, arXiv:2601.15885v2,
equations (29)-(31) and Appendix B. This file translates the mathematics, not
their implementation.

Complete every proof without changing signatures. The key result is generic:
two arbitrary orthogonal projectors need not commute, yet the displayed
range-one Laurent walk is exactly unitary on the circle because it factors into
two projector-controlled phases. Preserve the nonzero onsite witness.
-/

open Matrix Complex

noncomputable section

namespace StationaryAmplitudeProjectorWalk

variable {n : Type*} [Fintype n] [DecidableEq n]

abbrev Mat (n : Type*) [Fintype n] := Matrix n n Complex

def complement (P : Mat n) : Mat n := 1 - P

def forwardPhase (z : Complex) (P : Mat n) : Mat n :=
  z • P + complement P

def backwardPhase (z : Complex) (P : Mat n) : Mat n :=
  P + z⁻¹ • complement P

def gammaPlus (P Q : Mat n) : Mat n := P * Q
def gammaZero (P Q : Mat n) : Mat n :=
  P * complement Q + complement P * Q
def gammaMinus (P Q : Mat n) : Mat n := complement P * complement Q

def stationaryWalk (z : Complex) (P Q : Mat n) : Mat n :=
  forwardPhase z P * backwardPhase z Q

def IsUnitary (U : Mat n) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

/-- Exact range-one Laurent expansion, with a generally nonzero onsite term. -/
theorem stationaryWalk_expansion (z : Complex) (P Q : Mat n) :
    stationaryWalk z P Q =
      z • gammaPlus P Q + gammaZero P Q + z⁻¹ • gammaMinus P Q := by
  sorry

theorem forwardPhase_conjTranspose (z : Complex) (P : Mat n)
    (hp : IsStarProjection P)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    (forwardPhase z P).conjTranspose = backwardPhase z P := by
  sorry

theorem backwardPhase_conjTranspose (z : Complex) (P : Mat n)
    (hp : IsStarProjection P)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    (backwardPhase z P).conjTranspose = forwardPhase z P := by
  sorry

theorem forwardPhase_unitary (z : Complex) (P : Mat n)
    (hz : z ≠ 0) (hp : IsStarProjection P)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary (forwardPhase z P) := by
  sorry

theorem backwardPhase_unitary (z : Complex) (P : Mat n)
    (hz : z ≠ 0) (hp : IsStarProjection P)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary (backwardPhase z P) := by
  sorry

theorem isUnitary_mul {U V : Mat n}
    (hU : IsUnitary U) (hV : IsUnitary V) : IsUnitary (U * V) := by
  sorry

/-- Exact unitarity without assuming the two projectors commute. -/
theorem stationaryWalk_unitary (z : Complex) (P Q : Mat n)
    (hz : z ≠ 0) (hp : IsStarProjection P) (hq : IsStarProjection Q)
    (hcircle : starRingEnd Complex z = z⁻¹) :
    IsUnitary (stationaryWalk z P Q) := by
  sorry

/-! ## Exact noncommuting two-band witness -/

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

def projA : M2 := !![1, 0; 0, 0]
def projB : M2 := !![9 / 25, 12 / 25; 12 / 25, 16 / 25]

theorem projA_isStarProjection : IsStarProjection projA := by
  sorry

theorem projB_isStarProjection : IsStarProjection projB := by
  sorry

theorem projectors_do_not_commute : projA * projB ≠ projB * projA := by
  sorry

/-- The onsite amplitude is genuine, not a rewritten pure shift. -/
theorem gammaZero_nonzero :
    gammaZero projA projB = !![16 / 25, -12 / 25; 12 / 25, 16 / 25] ∧
      gammaZero projA projB ≠ 0 := by
  sorry

/-- Nonvacuous exact unitary with a nonzero stationary amplitude. -/
theorem explicit_stationary_walk_unitary :
    IsUnitary (stationaryWalk I projA projB) ∧ gammaZero projA projB ≠ 0 := by
  sorry

end StationaryAmplitudeProjectorWalk
