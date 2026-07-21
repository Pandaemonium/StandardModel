import PhysicsSM.Draft.NullEdge.PairExponentialCanonicalBridge

/-!
# Paper E successor: the operational two-particle transition law

Target statements for the Aristotle job `pair-transition-observables-20260719`.

Context.  The canonical bridge landed TONIGHT (included, PROVEN, guarded):
the canonical pair evolution `PlueckerPairGenerator.Uop` IS the exact
matrix exponential of the canonical generator.  The portfolio's remaining
Paper E gate asks for ONE operational two-particle quantity.  This module
states it: the pair-sector transition law.  The low pair `{0,1}` transits
to the high pair `{2,3}` with amplitude `-i sin(a‖z‖) (conj z/‖z‖)` -
a Rabi oscillation whose PROBABILITY is `sin²(a‖z‖)` (controlled by the
Pluecker modulus) and whose PHASE pairs exactly against the complex
Pluecker coordinate (the phase-pairing identity below) - while every
one-particle state is exactly immobile (selection rule).  This turns the
complex Pluecker coordinate into an interference-measurable observable of
the two-particle sector.

Pre-registered honesty license: if a sign or conjugation differs from the
stated closed forms (the included `Uop_low`/`Uop_high` fix the
convention), prove the true value, rename, and record the mismatch
prominently.  Every `s o r r y` below is a documented Aristotle handoff
hole.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PairTransitionObservables

open PhysicsSM.Draft.NullEdge
open PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction

/-- The low-pair basis state. -/
def basisLow : FullFockPairExponential.Fock :=
  fun T => if T = PlueckerQuarticInteraction.lowPair then 1 else 0

/-- **Transition amplitude.**  Acting on the low-pair basis state, the
canonical evolution deposits amplitude
`-i s (conj z / m)` on the high pair. -/
theorem uop_basisLow_highPair (c s : ℝ) (z : ℂ) (m : ℝ) :
    PlueckerPairGenerator.Uop c s z m basisLow
        PlueckerQuarticInteraction.highPair
      = -Complex.I * (s : ℂ) * ((starRingEnd ℂ) z / (m : ℂ)) := by
  unfold basisLow
  simp +decide

/-- **Rabi probability law.**  With the on-shell normalization
`m² = z conj z`, `m > 0`, the transition probability is exactly `s²`. -/
theorem pair_transition_prob (c s : ℝ) (z : ℂ) (m : ℝ)
    (hm : (m : ℂ) ^ 2 = z * (starRingEnd ℂ) z) (hm_pos : 0 < m) :
    ‖PlueckerPairGenerator.Uop c s z m basisLow
        PlueckerQuarticInteraction.highPair‖ ^ 2 = s ^ 2 := by
  rw [PlueckerPairGenerator.Uop]
  simp +decide [basisLow]
  simp_all +decide [abs_of_pos hm_pos, sq]
  ring_nf at *
  norm_num [Complex.normSq, Complex.sq_norm] at *
  norm_num [Complex.ext_iff, sq] at *
  grind

/-- **Phase-pairing identity.**  The transition amplitude multiplied by the
complex Pluecker coordinate is `-i s m`: the amplitude's phase is exactly
the conjugate Pluecker phase (shifted by `-π/2`).  This is the operational
interferometric readout of the Pluecker phase. -/
theorem pair_transition_phase_pairing (c s : ℝ) (z : ℂ) (m : ℝ) :
    PlueckerPairGenerator.Uop c s z m basisLow
        PlueckerQuarticInteraction.highPair * z
      = -Complex.I * (s : ℂ) * ((starRingEnd ℂ) z * z) / (m : ℂ) := by
  rw [uop_basisLow_highPair]
  ring

/-- **Selection rule.**  Every one-particle (singleton-occupation) state is
exactly fixed by the pair evolution. -/
theorem singleton_immobile (c s : ℝ) (z : ℂ) (m : ℝ)
    (psi : FullFockPairExponential.Fock) (i : Fin 4) :
    PlueckerPairGenerator.Uop c s z m psi {i} = psi {i} := by
  fin_cases i <;> simp +decide [PlueckerPairGenerator.Uop]

/-- **Exponential-form transition law (the headline).**  Composing with the
landed bridge: the exact operator exponential of the canonical generator
transits low pair to high pair with amplitude
`-i sin(a‖z‖) (conj z/‖z‖)`. -/
theorem exponential_pair_transition (z : ℂ) (a : ℝ) (hz : z ≠ 0) :
    (NormedSpace.exp
        ((-(a : ℂ) * Complex.I) • FullFockPairExponential.KopMatrix z)).mulVec
        basisLow PlueckerQuarticInteraction.highPair
      = -Complex.I * (Real.sin (a * ‖z‖) : ℂ) *
          ((starRingEnd ℂ) z / (‖z‖ : ℂ)) := by
  convert congrArg (fun f : FullFockPairExponential.Fock => f highPair)
    (PairExponentialCanonicalBridge.canonical_pair_evolution_is_exponential z a hz basisLow) using 1
  rw [uop_basisLow_highPair]

end PhysicsSM.Draft.NullEdge.PairTransitionObservables
