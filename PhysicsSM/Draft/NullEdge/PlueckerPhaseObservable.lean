import PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction
import PhysicsSM.Draft.NullEdge.PluckerMassOperator

/-!
# An operational two-particle discriminator for the Pluecker phase

DRAFT (kernel-clean).  Paper E operational pillar of the 2026-07-11
overnight publication run.

The standing reparametrization objection (register R1) is that a constant
Pluecker coordinate is spectrally an assigned Dirac mass `m = |z|`.  This
module states the escape as a measurement.  For the equal-modulus witness
pair `z1 = 3 + 4i` and `z2 = 5`:

* `witness_equal_modulus`, `witness_conjugate_restOperators`,
  `chiralPhase_u12_unitary` - the two rest operators are exactly unitarily
  conjugate, so no one-particle quantity distinguishes the two fields;
* `doubleKick_return_amplitude` - the two-kick loop (kick with the unit
  phase of one field, then the other) returns the distinguished pair with
  exact amplitude `u2 * conj u1`, reading the relative Pluecker phase;
* `pairKick_fixes_vacuum` - the vacuum branch is an untouched
  interferometric reference, so the relative phase is measurable as a
  probability;
* `doubleKick_interference_amplitude` - the vacuum+pair superposition
  returns with amplitude `(1 + u2 * conj u1) / 2` for any kick parameters;
* `witness_survival_probability` - the survival probability is exactly
  `4/5` at the `(z1, z2)` unit phases and exactly `1` for the equal-field
  control: an exact finite two-particle interference quantity that no
  single assigned scalar mass reproduces.

The definitions of `Fock`-amplitude vectors, the pair kick, and the inner
product are reproduced verbatim from `PlueckerQuarticInteraction`, and the
rest operator from `PluckerMassOperator`; definitional agreement with the
live project objects is pinned by the `*_eq_project` lemmas below, so the
theorems transfer to the project definitions by rewriting.

Claim label: finite identity (operational discriminator witness).  This is
a two-particle interference statement inside the finite four-mode system;
it is not yet a scattering theory, a bound state, or a derivation of the
interaction from the free walk (register R7 demands 1-3 remain open).

Provenance: seed statements by Fable (typecheck-verified before
submission); proofs by Aristotle project
`a4420507-98f4-4e55-88af-1b8e940c1e93` (run `0968d32e`), statements
unchanged; integrated with local kernel re-check.  Lean 4.28.0.
-/

noncomputable section

open scoped BigOperators
open Matrix
open scoped Matrix

namespace PhysicsSM.Draft.NullEdge.PlueckerPhaseObservable

/-- Finite fermionic Fock amplitudes over four modes (occupation basis). -/
abbrev Fock := Finset (Fin 4) -> Complex

/-- Occupation-basis vector. -/
def basisVec (S : Finset (Fin 4)) : Fock := fun T => if T = S then 1 else 0

def lowPair : Finset (Fin 4) := {0, 1}

def highPair : Finset (Fin 4) := {2, 3}

/-- The exactly reversible pair kick (reproduced from
`PlueckerQuarticInteraction`; definitional agreement pinned below). -/
def pairKick (u : Complex) (psi : Fock) : Fock := fun S =>
  if S = lowPair then u * psi highPair
  else if S = highPair then (starRingEnd Complex) u * psi lowPair
  else psi S

/-- Occupation-basis inner product, conjugate linear in the first slot. -/
def fockInner (psi phi : Fock) : Complex :=
  ∑ S : Finset (Fin 4), (starRingEnd Complex) (psi S) * phi S

/-- The odd Hermitian Pluecker rest operator (reproduced from
`PluckerMassOperator`; definitional agreement pinned below). -/
def massOperator (z : Complex) : Matrix (Fin 2) (Fin 2) Complex :=
  !![0, z; (starRingEnd Complex) z, 0]

/-- Diagonal chiral phase unitary. -/
def chiralPhase (u : Complex) : Matrix (Fin 2) (Fin 2) Complex :=
  !![u, 0; 0, 1]

/-! ## Definitional agreement with the live project objects -/

theorem basisVec_eq_project (S : Finset (Fin 4)) :
    basisVec S = PlueckerQuarticInteraction.basisVec S := rfl

theorem lowPair_eq_project : lowPair = PlueckerQuarticInteraction.lowPair := rfl

theorem highPair_eq_project :
    highPair = PlueckerQuarticInteraction.highPair := rfl

theorem pairKick_eq_project (u : Complex) (psi : Fock) :
    pairKick u psi = PlueckerQuarticInteraction.pairKick u psi := rfl

theorem fockInner_eq_project (psi phi : Fock) :
    fockInner psi phi = PlueckerQuarticInteraction.fockInner psi phi := rfl

theorem massOperator_eq_project (z : Complex) :
    massOperator z = PluckerMassOperator.massOperator z := rfl

/-! ## The witness pair -/

/-- The equal-modulus witness pair: `z1 = 3 + 4i` and `z2 = 5`. -/
def z1 : Complex := 3 + 4 * Complex.I

def z2 : Complex := 5

/-- The relative phase unit `u12 = z2 / z1 = (3 - 4i) / 5`. -/
def u12 : Complex := (3 - 4 * Complex.I) / 5

/-- **T1 (equal free invariant).**  The two witnesses have the same modulus
squared, hence the same rest gap and the same one-particle dispersion. -/
theorem witness_equal_modulus :
    z1 * (starRingEnd Complex) z1 = z2 * (starRingEnd Complex) z2 := by
  norm_num [ Complex.ext_iff, z1, z2 ]

/-- **T2 (exact one-particle conjugacy).**  The two rest operators are
conjugate by the explicit chiral phase unitary: one-particle physics cannot
distinguish the witnesses. -/
theorem witness_conjugate_restOperators :
    chiralPhase u12 * massOperator z1 * (chiralPhase u12)ᴴ =
      massOperator z2 := by
  ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff, Matrix.mul_apply ];
  · unfold chiralPhase massOperator; norm_num [ u12, z1, z2 ] ;
  · unfold chiralPhase massOperator; norm_num [ z1, z2, u12 ] ;
  · unfold chiralPhase massOperator; norm_num [ u12, z1, z2 ] ;
  · unfold chiralPhase massOperator; norm_num [ u12, z1, z2 ] ;

/-- **T3 (the conjugator is unitary).** -/
theorem chiralPhase_u12_unitary :
    chiralPhase u12 * (chiralPhase u12)ᴴ = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff, Matrix.mul_apply ] ;
  · unfold chiralPhase; norm_num [ u12 ] ;
  · unfold chiralPhase; norm_num [ u12 ] ;
  · unfold chiralPhase; norm_num;
  · unfold chiralPhase; norm_num [ u12 ] ;

/-- **T4 (two-kick return amplitude).**  Kicking with `u1` then `u2` returns
the low pair to itself with exact amplitude `u2 * conj u1`: the loop reads
the relative Pluecker phase. -/
theorem doubleKick_return_amplitude (u1 u2 : Complex) :
    fockInner (basisVec lowPair)
      (pairKick u2 (pairKick u1 (basisVec lowPair))) =
      u2 * (starRingEnd Complex) u1 := by
  unfold fockInner pairKick basisVec ;
  rw [ Finset.sum_eq_single lowPair ] <;> simp +decide [ lowPair, highPair ];
  grind

/-- **T5 (vacuum reference).**  Every kick fixes the vacuum amplitude, so the
vacuum branch is an untouched interferometric reference. -/
theorem pairKick_fixes_vacuum (u : Complex) :
    pairKick u (basisVec ∅) = basisVec ∅ := by
  ext S; unfold pairKick basisVec; aesop;

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
  have hs : ((Real.sqrt 2 : Complex))⁻¹ ^ 2 = 1 / 2 := by
    rw [inv_pow, ← Complex.ofReal_pow, pow_two,
      Real.mul_self_sqrt (by norm_num : (0:ℝ) ≤ 2)]
    norm_num
  have h1 : (∅ : Finset (Fin 4)) ≠ {0, 1} := by decide
  unfold fockInner interferenceState pairKick
  simp +decide [ Finset.sum_ite, Finset.filter_eq', Finset.filter_ne', lowPair, highPair, basisVec ]
  erw [Finset.sum_eq_add ∅ ({0, 1} : Finset (Fin 4))]
  · simp only [if_neg h1, if_neg (Ne.symm h1), if_true, add_zero, zero_add]
    linear_combination (1 + u2 * (starRingEnd Complex) u1) * hs
  · exact h1
  · intro c _ hc
    simp only [if_neg hc.1, if_neg hc.2, add_zero, mul_zero]
  · intro hc; exact absurd (Finset.mem_univ _) hc
  · intro hc; exact absurd (Finset.mem_univ _) hc

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
  constructor <;> rw [ doubleKick_interference_amplitude ] <;> norm_num [ Complex.normSq ];
  · norm_num [ Complex.normSq, Complex.div_re, Complex.div_im, z1, z2 ];
  · norm_num [ Complex.normSq, Complex.div_re, Complex.div_im, z1 ]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPhaseObservable.witness_conjugate_restOperators' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_conjugate_restOperators

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPhaseObservable.doubleKick_return_amplitude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms doubleKick_return_amplitude

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPhaseObservable.doubleKick_interference_amplitude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms doubleKick_interference_amplitude

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPhaseObservable.witness_survival_probability' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_survival_probability

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerPhaseObservable.pairKick_fixes_vacuum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairKick_fixes_vacuum

end PhysicsSM.Draft.NullEdge.PlueckerPhaseObservable
