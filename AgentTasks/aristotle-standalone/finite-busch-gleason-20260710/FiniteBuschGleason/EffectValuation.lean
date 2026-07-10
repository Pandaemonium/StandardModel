import Mathlib

/-!
# A finite Busch-Gleason theorem: additive effect valuations on a qubit
# are Born

The program imports the Born rule as postulate P4 and says so.  This package
attacks the honest reconstruction rung: on a qubit, any probability
assignment to EFFECTS (POVM elements) that is additive on coexistent effects
and normalized is necessarily the trace rule for a density matrix.  This is
the finite core of Busch's theorem (the POVM extension of Gleason that is
valid in dimension two, where projective Gleason fails).

Framing discipline (load-bearing): the hypotheses are OPERATIONAL
(positivity, additivity, normalization); what is derived is the FORM of the
probability rule.  This does not derive why nature assigns probabilities at
all, and the additivity hypothesis on coexistent effects is where the
physical content lives — both facts stated here, not hidden.

## Setup

An effect is `A : Matrix (Fin 2) (Fin 2) ℂ` with `A.PosSemidef` and
`(1 - A).PosSemidef` (scoped `ComplexOrder` is opened for `PosSemidef`).  A
valuation is `f : Matrix (Fin 2) (Fin 2) ℂ → ℝ` with

* `hpos  : IsEffect A → 0 ≤ f A`
* `hadd  : IsEffect A → IsEffect B → IsEffect (A + B) → f (A+B) = f A + f B`
* `hnorm : f 1 = 1`.

## Targets

1. `valuation_zero` — `f 0 = 0`.
2. `valuation_monotone` — `A ≤ B` (both effects, `B - A` an effect) implies
   `f A ≤ f B`; in particular `f A ≤ 1` for every effect.
3. `valuation_nat_smul` — `f (n • A) = n * f A` whenever `A` and `n • A`
   are effects (iterated additivity).
4. `valuation_rat_smul` — rational homogeneity: for `q : ℚ`, `0 ≤ q ≤ 1`,
   `f (q • A) = q * f A` for effects `A` (with `q • A` an effect —
   automatic for `0 ≤ q ≤ 1`).
5. `valuation_real_smul` — real homogeneity on `[0,1]` by the monotone
   squeeze: for `t : ℝ`, `0 ≤ t ≤ 1`, `f (t • A) = t * f A` (rationals
   below and above `t`, monotonicity between).
6. `born_representation` — the theorem: there exists `ρ : Matrix (Fin 2)
   (Fin 2) ℂ` with `ρ.PosSemidef`, `ρ.trace = 1`, and
   `f A = (ρ * A).trace.re` for every effect `A`.  Route: define the Bloch
   coordinates of the valuation, `r i := 2 * f ((1 + pauli i)/2) - 1`, set
   `ρ := (1 + Σ r i • pauli i)/2`, and verify agreement on effects via the
   homogeneity/additivity structure (every effect is a `[0,1]`-combination
   of `1` and at most two spectral projections; reduce by the spectral
   decomposition of the Hermitian part).  Positivity of `ρ`: for every unit
   Bloch direction the projector effect has `f ∈ [0,1]`, forcing the Bloch
   vector into the closed ball.
7. `nonvacuity` — an explicit non-Born-free check: the valuation
   `f A = (ρ₀ * A).trace.re` for `ρ₀ = diag(3/4, 1/4)` satisfies all three
   hypotheses (so the hypothesis class is nonempty and the theorem is about
   a real class), and assigns the `X`-projector effect the value `1/2`.

Honest scope: dimension two, single system; no continuity is ASSUMED — the
squeeze derives it from positivity+additivity, which is the mathematical
content; the tensor/composition axioms of the full program reconstruction
are not needed here and not claimed.  This is a hard multi-lemma target: if
target 6 resists within budget, land targets 1-5 and 7 completely, leave 6
as a documented hole with the exact blocker, and report — do NOT weaken
statement 6.  Run
`lake env lean FiniteBuschGleason/EffectValuation.lean` first.
-/

namespace FiniteBuschGleason

open Matrix
open scoped ComplexOrder

/-- An effect: positive semidefinite and below the identity. -/
def IsEffect (A : Matrix (Fin 2) (Fin 2) ℂ) : Prop :=
  A.PosSemidef ∧ (1 - A).PosSemidef

/-- The valuation hypotheses, packaged. -/
structure IsValuation (f : Matrix (Fin 2) (Fin 2) ℂ → ℝ) : Prop where
  pos : ∀ A, IsEffect A → 0 ≤ f A
  add : ∀ A B, IsEffect A → IsEffect B → IsEffect (A + B) →
    f (A + B) = f A + f B
  norm : f 1 = 1

variable {f : Matrix (Fin 2) (Fin 2) ℂ → ℝ}

/-- Target 1: the zero effect has value zero. -/
theorem valuation_zero (hf : IsValuation f) : f 0 = 0 := by
  sorry

/-- Target 2: monotonicity, and every effect value lies in `[0, 1]`. -/
theorem valuation_monotone (hf : IsValuation f) (A B : Matrix (Fin 2) (Fin 2) ℂ)
    (hA : IsEffect A) (hB : IsEffect B) (hAB : IsEffect (B - A))
    (hsum : B = A + (B - A)) :
    f A ≤ f B ∧ (∀ E, IsEffect E → f E ≤ 1) := by
  sorry

/-- Target 3: natural-number homogeneity from iterated additivity. -/
theorem valuation_nat_smul (hf : IsValuation f) (A : Matrix (Fin 2) (Fin 2) ℂ)
    (n : ℕ) (hA : IsEffect A) (hnA : IsEffect ((n : ℂ) • A)) :
    f ((n : ℂ) • A) = n * f A := by
  sorry

/-- Target 4: rational homogeneity on `[0, 1]`. -/
theorem valuation_rat_smul (hf : IsValuation f) (A : Matrix (Fin 2) (Fin 2) ℂ)
    (q : ℚ) (h0 : 0 ≤ q) (h1 : q ≤ 1) (hA : IsEffect A) :
    f ((q : ℂ) • A) = q * f A := by
  sorry

/-- Target 5: real homogeneity on `[0, 1]` by the monotone squeeze — no
continuity assumption. -/
theorem valuation_real_smul (hf : IsValuation f) (A : Matrix (Fin 2) (Fin 2) ℂ)
    (t : ℝ) (h0 : 0 ≤ t) (h1 : t ≤ 1) (hA : IsEffect A) :
    f ((t : ℂ) • A) = t * f A := by
  sorry

/-- Target 6: the finite Busch-Gleason representation — every additive
normalized effect valuation on a qubit is the Born rule of a density
matrix. -/
theorem born_representation (hf : IsValuation f) :
    ∃ ρ : Matrix (Fin 2) (Fin 2) ℂ, ρ.PosSemidef ∧ ρ.trace = 1 ∧
      ∀ A, IsEffect A → f A = ((ρ * A).trace).re := by
  sorry

/-- Target 7: nonvacuity — an explicit valuation satisfying the hypotheses,
with the `X`-projector effect valued `1/2`. -/
theorem nonvacuity :
    IsValuation (fun A => (((!![(3 : ℂ) / 4, 0; 0, 1 / 4]) * A).trace).re) ∧
    ((((!![(3 : ℂ) / 4, 0; 0, 1 / 4]) *
        !![1 / 2, 1 / 2; 1 / 2, 1 / 2]).trace).re = 1 / 2) := by
  sorry

end FiniteBuschGleason
