import Mathlib

/-!
# An operational two-particle discriminator for the Pluecker phase

Paper E pillar (overnight publication run 2026-07-11, Fable lane F3).

Context.  In the null-edge program the Dirac rest gap is the modulus of the
complex Pluecker coordinate `z = psi /\ phi` of two primitive null spinors,
and the one-particle spectrum depends on `|z|` alone: rest operators with
equal modulus are exactly unitarily conjugate (phase covariance).  The
program's standing referee objection R1 is that everything with constant `z`
is then a reparametrized Dirac mass.  This module states the escape as an
operational theorem: two Pluecker fields with the SAME modulus but different
phases produce (i) provably conjugate one-particle rest operators, yet
(ii) an exact two-particle interference loop whose return amplitude and
vacuum-referenced transition probability differ.  The pair kick used here is
the exactly reversible Fock-norm-preserving operation already landed in the
project (`pairKick`); all definitions are reproduced verbatim so the package
is self-contained over Mathlib.

Success = all seven theorems below proved with no proof holes
(kernel-checked; expected axioms only `propext`, `Classical.choice`,
`Quot.sound`).

Prohibited weakenings:
- do not change the witness pair `z1 = 3 + 4i`, `z2 = 5` (equal modulus is
  the point);
- do not replace the fockInner-based amplitudes by unnormalized component
  reads;
- do not restate T7 with amplitudes in place of the squared-modulus
  probability;
- do not assume unit modulus in T4/T5 beyond the stated hypotheses.
-/

noncomputable section

open scoped BigOperators
open Matrix
open scoped Matrix

namespace PhaseObservable

/-- Finite fermionic Fock amplitudes over four modes (occupation basis). -/
abbrev Fock := Finset (Fin 4) -> Complex

/-- Occupation-basis vector. -/
def basisVec (S : Finset (Fin 4)) : Fock := fun T => if T = S then 1 else 0

def lowPair : Finset (Fin 4) := {0, 1}

def highPair : Finset (Fin 4) := {2, 3}

/-- The exactly reversible pair kick: swaps the two distinguished pair
amplitudes with conjugate phase weights and fixes every other occupation
amplitude (reproduced from the project; do not modify). -/
def pairKick (u : Complex) (psi : Fock) : Fock := fun S =>
  if S = lowPair then u * psi highPair
  else if S = highPair then (starRingEnd Complex) u * psi lowPair
  else psi S

/-- Occupation-basis inner product, conjugate linear in the first slot. -/
def fockInner (psi phi : Fock) : Complex :=
  ∑ S : Finset (Fin 4), (starRingEnd Complex) (psi S) * phi S

/-- The odd Hermitian Pluecker rest operator (reproduced from the project). -/
def massOperator (z : Complex) : Matrix (Fin 2) (Fin 2) Complex :=
  !![0, z; (starRingEnd Complex) z, 0]

/-- Diagonal chiral phase unitary. -/
def chiralPhase (u : Complex) : Matrix (Fin 2) (Fin 2) Complex :=
  !![u, 0; 0, 1]

/-- The equal-modulus witness pair: `z1 = 3 + 4i` and `z2 = 5`. -/
def z1 : Complex := 3 + 4 * Complex.I

def z2 : Complex := 5

/-- The relative phase unit `u12 = z2 / z1 = (3 - 4i) / 5`. -/
def u12 : Complex := (3 - 4 * Complex.I) / 5

/-- **T1 (equal free invariant).**  The two witnesses have the same modulus
squared, hence the same rest gap and the same one-particle dispersion. -/
theorem witness_equal_modulus :
    z1 * (starRingEnd Complex) z1 = z2 * (starRingEnd Complex) z2 := by
  sorry

/-- **T2 (exact one-particle conjugacy).**  The two rest operators are
conjugate by the explicit chiral phase unitary: one-particle physics cannot
distinguish the witnesses. -/
theorem witness_conjugate_restOperators :
    chiralPhase u12 * massOperator z1 * (chiralPhase u12)ᴴ =
      massOperator z2 := by
  sorry

/-- **T3 (the conjugator is unitary).** -/
theorem chiralPhase_u12_unitary :
    chiralPhase u12 * (chiralPhase u12)ᴴ = 1 := by
  sorry

/-- **T4 (two-kick return amplitude).**  Kicking with `u1` then `u2` returns
the low pair to itself with exact amplitude `u2 * conj u1`: the loop reads
the relative Pluecker phase. -/
theorem doubleKick_return_amplitude (u1 u2 : Complex) :
    fockInner (basisVec lowPair)
      (pairKick u2 (pairKick u1 (basisVec lowPair))) =
      u2 * (starRingEnd Complex) u1 := by
  sorry

/-- **T5 (vacuum reference).**  Every kick fixes the vacuum amplitude, so the
vacuum branch is an untouched interferometric reference. -/
theorem pairKick_fixes_vacuum (u : Complex) :
    pairKick u (basisVec ∅) = basisVec ∅ := by
  sorry

/-- The vacuum-referenced interference state `(vacuum + low pair)/sqrt 2`. -/
def interferenceState : Fock :=
  (1 / Real.sqrt 2 : Complex) • (basisVec ∅ + basisVec lowPair)

/-- **T6 (interference amplitude).**  For any kick parameters, the
double-kick overlap of the interference state is
`(1 + u2 * conj u1) / 2`. -/
theorem doubleKick_interference_amplitude (u1 u2 : Complex) :
    fockInner interferenceState
      (pairKick u2 (pairKick u1 interferenceState)) =
      (1 + u2 * (starRingEnd Complex) u1) / 2 := by
  sorry

/-- **T7 (operational discriminator).**  At the equal-modulus witnesses, the
double-kick survival probability of the interference state is exactly `4/5`
when the two kicks carry the unit phases of `z1` and `z2`, while the
equal-field control (both kicks from `z1`) gives probability `1`.  A
one-particle assigned mass `m = |z| = 5` contains no such quantity. -/
theorem witness_survival_probability :
    Complex.normSq
      (fockInner interferenceState
        (pairKick (z2 / 5)
          (pairKick (z1 / 5) interferenceState))) = 4 / 5 ∧
    Complex.normSq
      (fockInner interferenceState
        (pairKick (z1 / 5)
          (pairKick (z1 / 5) interferenceState))) = 1 := by
  sorry

end PhaseObservable
