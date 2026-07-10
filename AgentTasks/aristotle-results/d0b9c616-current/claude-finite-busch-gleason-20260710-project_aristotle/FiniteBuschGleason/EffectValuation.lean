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

/-- The identity is an effect. -/
theorem IsEffect_one : IsEffect (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  refine ⟨PosSemidef.one, ?_⟩
  simp [PosSemidef.zero]

/-- The zero matrix is an effect. -/
theorem IsEffect_zero : IsEffect (0 : Matrix (Fin 2) (Fin 2) ℂ) :=
  ⟨PosSemidef.zero, by simp [PosSemidef.one]⟩

/-- If `A` is an effect, so is `1 - A`. -/
theorem IsEffect.one_sub {A : Matrix (Fin 2) (Fin 2) ℂ} (hA : IsEffect A) :
    IsEffect (1 - A) := by
  refine ⟨hA.2, ?_⟩
  simpa using hA.1

/-- A real scalar multiple `c • A` with `0 ≤ c ≤ 1` of an effect is an effect. -/
theorem IsEffect_smul {A : Matrix (Fin 2) (Fin 2) ℂ} {c : ℝ} (h0 : 0 ≤ c)
    (h1 : c ≤ 1) (hA : IsEffect A) : IsEffect ((c : ℂ) • A) := by
  refine ⟨hA.1.smul (by exact_mod_cast h0), ?_⟩
  have h1c : (0 : ℝ) ≤ 1 - c := by linarith
  have hpsd1 : (((1 - c : ℝ) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ)).PosSemidef :=
    PosSemidef.one.smul (by exact_mod_cast h1c)
  have hpsd2 : ((c : ℂ) • (1 - A)).PosSemidef := hA.2.smul (by exact_mod_cast h0)
  have heq : (1 : Matrix (Fin 2) (Fin 2) ℂ) - (c : ℂ) • A
      = ((1 - c : ℝ) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) + (c : ℂ) • (1 - A) := by
    push_cast; module
  rw [heq]; exact hpsd1.add hpsd2

/-- If `n • A` is an effect and `k ≤ n`, then `k • A` is an effect. -/
theorem IsEffect_nat_smul_le {A : Matrix (Fin 2) (Fin 2) ℂ} {n k : ℕ}
    (hA : IsEffect A) (hnA : IsEffect ((n : ℂ) • A)) (hkn : k ≤ n) :
    IsEffect ((k : ℂ) • A) := by
  refine ⟨hA.1.smul (by exact_mod_cast Nat.cast_nonneg k), ?_⟩
  have hdiff : ((n : ℂ) • A) - ((k : ℂ) • A) = (((n - k : ℕ) : ℂ)) • A := by
    rw [← sub_smul]; congr 1; push_cast [Nat.cast_sub hkn]; ring
  have hpsd : (((n - k : ℕ) : ℂ) • A).PosSemidef :=
    hA.1.smul (by exact_mod_cast Nat.cast_nonneg _)
  have heq : (1 : Matrix (Fin 2) (Fin 2) ℂ) - (k : ℂ) • A
      = (1 - (n : ℂ) • A) + (((n - k : ℕ) : ℂ) • A) := by rw [← hdiff]; abel
  rw [heq]; exact hnA.2.add hpsd

/-- Target 1: the zero effect has value zero. -/
theorem valuation_zero (hf : IsValuation f) : f 0 = 0 := by
  have H2 := hf.add 0 0 IsEffect_zero IsEffect_zero (by simpa using IsEffect_zero)
  simpa using H2

/-- Target 2: monotonicity, and every effect value lies in `[0, 1]`. -/
theorem valuation_monotone (hf : IsValuation f) (A B : Matrix (Fin 2) (Fin 2) ℂ)
    (hA : IsEffect A) (hB : IsEffect B) (hAB : IsEffect (B - A))
    (hsum : B = A + (B - A)) :
    f A ≤ f B ∧ (∀ E, IsEffect E → f E ≤ 1) := by
  constructor
  · have key := hf.add A (B - A) hA hAB (hsum ▸ hB)
    have hpos := hf.pos _ hAB
    rw [hsum]; linarith
  · intro E hE
    have hone : (1 : Matrix (Fin 2) (Fin 2) ℂ) = E + (1 - E) := by abel
    have key := hf.add E (1 - E) hE hE.one_sub (hone ▸ IsEffect_one)
    rw [← hone, hf.norm] at key
    have hpos := hf.pos _ hE.one_sub
    linarith

/-- Target 3: natural-number homogeneity from iterated additivity. -/
theorem valuation_nat_smul (hf : IsValuation f) (A : Matrix (Fin 2) (Fin 2) ℂ)
    (n : ℕ) (hA : IsEffect A) (hnA : IsEffect ((n : ℂ) • A)) :
    f ((n : ℂ) • A) = n * f A := by
  induction n with
  | zero => simpa using valuation_zero hf
  | succ m ih =>
    have hmeff : IsEffect ((m : ℂ) • A) := IsEffect_nat_smul_le hA hnA (Nat.le_succ m)
    have hsplit : ((m + 1 : ℕ) : ℂ) • A = (m : ℂ) • A + A := by push_cast; module
    have key := hf.add ((m : ℂ) • A) A hmeff hA (by rw [← hsplit]; exact_mod_cast hnA)
    rw [hsplit, key, ih hmeff]
    push_cast; ring

/-- Target 4: rational homogeneity on `[0, 1]`. -/
theorem valuation_rat_smul (hf : IsValuation f) (A : Matrix (Fin 2) (Fin 2) ℂ)
    (q : ℚ) (h0 : 0 ≤ q) (h1 : q ≤ 1) (hA : IsEffect A) :
    f ((q : ℂ) • A) = q * f A := by
  have hn1 : 1 ≤ q.den := q.pos
  have hnum_nonneg : 0 ≤ q.num := Rat.num_nonneg.mpr h0
  set n := q.den with hn
  set p := q.num.toNat with hp
  have hpr : ((p : ℝ)) = (q.num : ℝ) := by
    rw [hp]; exact_mod_cast Int.toNat_of_nonneg hnum_nonneg
  have hqreal : (q : ℝ) = (p : ℝ) / (n : ℝ) := by rw [Rat.cast_def, hpr, hn]
  set c : ℝ := (n : ℝ)⁻¹ with hc
  have hc0 : 0 ≤ c := by positivity
  have hc1 : c ≤ 1 := by rw [hc, inv_le_one_iff₀]; right; exact_mod_cast hn1
  set B : Matrix (Fin 2) (Fin 2) ℂ := (c : ℂ) • A with hB
  have hBeff : IsEffect B := IsEffect_smul hc0 hc1 hA
  have hnB : (n : ℂ) • B = A := by
    rw [hB, smul_smul]
    have : (n : ℂ) * (c : ℂ) = 1 := by rw [hc]; push_cast; field_simp
    rw [this, one_smul]
  have hval1 : f A = n * f B := by
    have h := valuation_nat_smul hf B n hBeff (by rw [hnB]; exact hA)
    rw [hnB] at h; exact h
  have hpq : (p : ℂ) • B = (q : ℂ) • A := by
    rw [hB, smul_smul]; congr 1
    have : (q : ℝ) = (p : ℝ) * c := by rw [hqreal, hc]; ring
    exact_mod_cast this.symm
  have hqeff : IsEffect ((q : ℂ) • A) := by
    have hcast : ((q : ℝ) : ℂ) = (q : ℂ) := by push_cast; ring
    rw [← hcast]; exact IsEffect_smul (by exact_mod_cast h0) (by exact_mod_cast h1) hA
  have hval2 := valuation_nat_smul hf B p hBeff (by rw [hpq]; exact hqeff)
  rw [hpq] at hval2
  rw [hval2, hval1, hqreal]
  have hnpos : (0 : ℝ) < n := by exact_mod_cast q.pos
  field_simp

/-- Monotonicity of `s ↦ f (s • A)` for real scalars in `[0, 1]`. -/
theorem valuation_real_mono (hf : IsValuation f) (A : Matrix (Fin 2) (Fin 2) ℂ)
    (hA : IsEffect A) {s s' : ℝ} (h0 : 0 ≤ s) (hss : s ≤ s') (h1 : s' ≤ 1) :
    f ((s : ℂ) • A) ≤ f ((s' : ℂ) • A) := by
  have hseff : IsEffect ((s : ℂ) • A) := IsEffect_smul h0 (le_trans hss h1) hA
  have hdeff : IsEffect (((s' - s : ℝ) : ℂ) • A) :=
    IsEffect_smul (by linarith) (by linarith) hA
  have hsplit : (s' : ℂ) • A = (s : ℂ) • A + ((s' - s : ℝ) : ℂ) • A := by push_cast; module
  have hs'eff : IsEffect ((s' : ℂ) • A) := IsEffect_smul (le_trans h0 hss) h1 hA
  have key := hf.add ((s : ℂ) • A) (((s' - s : ℝ) : ℂ) • A) hseff hdeff
    (by rw [← hsplit]; exact hs'eff)
  rw [hsplit, key]
  have := hf.pos _ hdeff
  linarith

/-- Target 5: real homogeneity on `[0, 1]` by the monotone squeeze — no
continuity assumption. -/
theorem valuation_real_smul (hf : IsValuation f) (A : Matrix (Fin 2) (Fin 2) ℂ)
    (t : ℝ) (h0 : 0 ≤ t) (h1 : t ≤ 1) (hA : IsEffect A) :
    f ((t : ℂ) • A) = t * f A := by
  have hfA : 0 ≤ f A := hf.pos _ hA
  have hftA : 0 ≤ f ((t : ℂ) • A) := hf.pos _ (IsEffect_smul h0 h1 hA)
  have ratval : ∀ r : ℚ, 0 ≤ (r : ℝ) → (r : ℝ) ≤ 1 →
      f (((r : ℝ) : ℂ) • A) = (r : ℝ) * f A := by
    intro r hr0 hr1
    have h := valuation_rat_smul hf A r (by exact_mod_cast hr0) (by exact_mod_cast hr1) hA
    rw [show ((r : ℚ) : ℂ) = (((r : ℝ)) : ℂ) by push_cast; ring] at h
    rw [h]
  have upper : f ((t : ℂ) • A) ≤ t * f A := by
    by_contra hcon
    push_neg at hcon
    have hmono_top : f ((t : ℂ) • A) ≤ f A := by
      have := valuation_real_mono hf A hA h0 h1 (le_refl 1); simpa using this
    rcases eq_or_lt_of_le hfA with hfA0 | hfApos
    · have : t * f A = 0 := by rw [← hfA0]; ring
      linarith
    · have hbound : t < f ((t : ℂ) • A) / f A := by rw [lt_div_iff₀ hfApos]; linarith
      obtain ⟨r', hr1, hr2⟩ := exists_rat_btwn hbound
      have hr'le1 : (r' : ℝ) ≤ 1 := by
        have : f ((t : ℂ) • A) / f A ≤ 1 := by rw [div_le_one hfApos]; exact hmono_top
        linarith
      have hr'pos : (0 : ℝ) ≤ r' := le_of_lt (lt_of_le_of_lt h0 hr1)
      have hmono := valuation_real_mono hf A hA h0 (le_of_lt hr1) hr'le1
      rw [ratval r' hr'pos hr'le1] at hmono
      have : (r' : ℝ) * f A < f ((t : ℂ) • A) := (lt_div_iff₀ hfApos).mp hr2
      linarith
  have lower : t * f A ≤ f ((t : ℂ) • A) := by
    by_contra hcon
    push_neg at hcon
    rcases eq_or_lt_of_le hfA with hfA0 | hfApos
    · have : t * f A = 0 := by rw [← hfA0]; ring
      linarith
    · have hbound : f ((t : ℂ) • A) / f A < t := by rw [div_lt_iff₀ hfApos]; linarith
      have hnn : (0 : ℝ) ≤ f ((t : ℂ) • A) / f A := by
        have := hf.pos _ (IsEffect_smul h0 h1 hA); positivity
      obtain ⟨r, hr1, hr2⟩ := exists_rat_btwn hbound
      have hrpos : (0 : ℝ) ≤ r := le_of_lt (lt_of_le_of_lt hnn hr1)
      have hrle1 : (r : ℝ) ≤ 1 := le_of_lt (lt_of_lt_of_le hr2 h1)
      have hmono := valuation_real_mono hf A hA hrpos (le_of_lt hr2) h1
      rw [ratval r hrpos hrle1] at hmono
      have : f ((t : ℂ) • A) < (r : ℝ) * f A := (div_lt_iff₀ hfApos).mp hr1
      linarith
  linarith

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
  have traceform : ∀ A : Matrix (Fin 2) (Fin 2) ℂ,
      (((!![(3 : ℂ) / 4, 0; 0, 1 / 4]) * A).trace).re
        = 3 / 4 * (A 0 0).re + 1 / 4 * (A 1 1).re := by
    intro A
    simp [Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two, Matrix.diag]
  refine ⟨⟨?_, ?_, ?_⟩, ?_⟩
  · intro A hA
    rw [traceform]
    have h0 : 0 ≤ (A 0 0).re := by
      have := hA.1.diag_nonneg (i := 0); rw [Complex.le_def] at this; simpa using this.1
    have h1 : 0 ≤ (A 1 1).re := by
      have := hA.1.diag_nonneg (i := 1); rw [Complex.le_def] at this; simpa using this.1
    positivity
  · intro A B _ _ _
    rw [traceform, traceform, traceform]
    simp [Matrix.add_apply]; ring
  · rw [traceform]; norm_num [Matrix.one_apply]
  · simp [Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two, Matrix.diag]
    norm_num

end FiniteBuschGleason
