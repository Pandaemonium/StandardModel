import Mathlib

/-!
# A finite measurement-instrument API: outcomes, repeatability, no-disturbance

Smallest honest finite instrument layer for the null-information program's
measurement row.  A finite instrument is a family of Kraus operators, one per
outcome, with the completeness relation `∑ Aₒ† Aₒ = 1`.  Outcome
probabilities are DEFINED by the trace rule; this module does not derive the
Born rule and says so.  What it proves is the operational consistency of that
definition: normalization, positivity, stable records for projective
instruments, and non-disturbance of every compatible coarse observable —
plus an explicit qubit witness and a noncommuting disturbance control.

Clean-room reference shapes: lean-quantum's `CPTPMap` API (Kraus
constructor, trace preservation) was consulted for theorem shapes only; no
code or statement text is imported (version-pinned away from this build).
The no-signaling tensor-marginal theorem is a SEPARATE lane (Codex job) and
is deliberately not restated here.

## Targets

1. `outcome_prob_sum_one` — completeness + `tr ρ = 1` give normalized
   outcome probabilities.
2. `outcome_prob_nonneg` — probabilities are nonnegative on PSD states.
3. `post_state_posSemidef` — branch outputs stay PSD.
4. `projective_repeatable` — for orthogonal projective instruments the
   sequential outcome distribution is diagonal: measuring twice gives the
   same record (`p(o, then o') = δ_{o o'} p(o)`).
5. `compatible_no_disturbance` — if every Kraus operator commutes with a
   projector `P`, the unread instrument does not change `P`'s outcome
   probability.
6. `qubit_witness` — the computational-basis instrument on the plus state:
   probabilities `(1/2, 1/2)`, repeatability, and the explicit disturbance
   of the noncommuting plus-projector distribution (`1` before, `1/2`
   after): the compatibility hypothesis in target 5 is necessary.

Do not weaken the statements.  Helper lemmas welcome.  Run the narrow check
`lake env lean FiniteInstrument/InstrumentAPI.lean` first; avoid a full lake
build until the holes are closed.
-/

namespace FiniteInstrument

open Matrix
open scoped ComplexOrder

variable {n k : ℕ}

/-- A finite instrument: one Kraus operator per outcome, complete. -/
structure Instrument (n k : ℕ) where
  kraus : Fin k → Matrix (Fin n) (Fin n) ℂ
  complete : ∑ o : Fin k, (kraus o)ᴴ * kraus o = 1

/-- Outcome probability of an instrument on a state (trace rule; the rule is
a definition imported from standard quantum theory, not a derivation). -/
noncomputable def outcomeProb (I : Instrument n k) (ρ : Matrix (Fin n) (Fin n) ℂ)
    (o : Fin k) : ℂ :=
  Matrix.trace (I.kraus o * ρ * (I.kraus o)ᴴ)

/-- Target 1: outcome probabilities are normalized on unit-trace states. -/
theorem outcome_prob_sum_one (I : Instrument n k)
    (ρ : Matrix (Fin n) (Fin n) ℂ) (hρ : Matrix.trace ρ = 1) :
    ∑ o : Fin k, outcomeProb I ρ o = 1 := by
  sorry

/-- Target 2: outcome probabilities are nonnegative reals on PSD states. -/
theorem outcome_prob_nonneg (I : Instrument n k)
    (ρ : Matrix (Fin n) (Fin n) ℂ) (hρ : ρ.PosSemidef) (o : Fin k) :
    0 ≤ (outcomeProb I ρ o).re ∧ (outcomeProb I ρ o).im = 0 := by
  sorry

/-- Target 3: branch outputs remain positive semidefinite. -/
theorem post_state_posSemidef (I : Instrument n k)
    (ρ : Matrix (Fin n) (Fin n) ℂ) (hρ : ρ.PosSemidef) (o : Fin k) :
    (I.kraus o * ρ * (I.kraus o)ᴴ).PosSemidef := by
  sorry

/-- Target 4: projective instruments are repeatable.  If the Kraus family
consists of pairwise-orthogonal Hermitian projections, the probability of
outcome `o'` after an outcome-`o` branch is `δ_{o o'}` times the branch
weight: records are stable. -/
theorem projective_repeatable (I : Instrument n k)
    (hproj : ∀ o, (I.kraus o)ᴴ = I.kraus o ∧ I.kraus o * I.kraus o = I.kraus o)
    (horth : ∀ o o', o ≠ o' → I.kraus o * I.kraus o' = 0)
    (ρ : Matrix (Fin n) (Fin n) ℂ) (o o' : Fin k) :
    outcomeProb I (I.kraus o * ρ * (I.kraus o)ᴴ) o' =
      if o = o' then outcomeProb I ρ o else 0 := by
  sorry

/-- Target 5: compatible observables are undisturbed.  If a projector `P`
commutes with every Kraus operator, its outcome probability after the unread
instrument equals its probability before. -/
theorem compatible_no_disturbance (I : Instrument n k)
    (P : Matrix (Fin n) (Fin n) ℂ)
    (hcomm : ∀ o, P * I.kraus o = I.kraus o * P)
    (ρ : Matrix (Fin n) (Fin n) ℂ) :
    Matrix.trace (P * (∑ o : Fin k, I.kraus o * ρ * (I.kraus o)ᴴ)) =
      Matrix.trace (P * ρ) := by
  sorry

/-- Target 6: the qubit witness and the necessity control.  The
computational-basis instrument on the plus state has outcome probabilities
`(1/2, 1/2)`; and the noncommuting plus-projector probability is disturbed
from `1` to `1/2`, so the compatibility hypothesis of target 5 is necessary. -/
theorem qubit_witness :
    ∃ (I : Instrument 2 2),
      I.kraus 0 = !![1, 0; 0, 0] ∧ I.kraus 1 = !![0, 0; 0, 1] ∧
      (∀ o, outcomeProb I !![1/2, 1/2; 1/2, 1/2] o = 1/2) ∧
      (Matrix.trace ((!![1/2, 1/2; 1/2, 1/2] : Matrix (Fin 2) (Fin 2) ℂ) *
          !![1/2, 1/2; 1/2, 1/2]) = 1 ∧
        Matrix.trace ((!![1/2, 1/2; 1/2, 1/2] : Matrix (Fin 2) (Fin 2) ℂ) *
          (∑ o : Fin 2, I.kraus o * !![1/2, 1/2; 1/2, 1/2] * (I.kraus o)ᴴ)) =
          1/2) := by
  sorry

end FiniteInstrument
