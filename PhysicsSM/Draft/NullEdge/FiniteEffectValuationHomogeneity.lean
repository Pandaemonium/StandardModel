import Mathlib

/-!
# Finite effect valuation homogeneity

This file factors out the homogeneity and monotonicity machinery for finite
dimension-2 effect valuations used in the finite Busch-Gleason line of development.

The placeholder theorem `born_representation` is intentionally omitted here and
remains an active successor target in the broader development.

Hypotheses and proofs below use only positivity, additivity on coexistent effects,
and normalization. No continuity is assumed; real homogeneity on `[0, 1]` is
derived via rational squeeze and monotonicity.
-/

namespace PhysicsSM.Draft.NullEdge.FiniteEffectValuationHomogeneity

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
theorem IsEffect_one_sub {A : Matrix (Fin 2) (Fin 2) ℂ} (hA : IsEffect A) :
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

/-- The zero effect has value zero. -/
theorem valuation_zero (hf : IsValuation f) : f 0 = 0 := by
  have H2 := hf.add 0 0 IsEffect_zero IsEffect_zero (by simpa using IsEffect_zero)
  simpa using H2

/-- Monotonicity, and every effect value lies in `[0, 1]`. -/
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
    have key := hf.add E (1 - E) hE (IsEffect_one_sub hE) (hone ▸ IsEffect_one)
    rw [← hone, hf.norm] at key
    have hpos := hf.pos _ (IsEffect_one_sub hE)
    linarith

/-- Natural-number homogeneity from iterated additivity. -/
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

/-- Rational homogeneity on `[0, 1]`. -/
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

/-- Real homogeneity on `[0, 1]` by the monotone squeeze; no continuity assumed. -/
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

/-- A concrete non-vacant valuation witness, giving `f X = 1 / 2`. -/
noncomputable def rho0 : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(3 : ℂ) / 4, 0; 0, 1 / 4]

noncomputable def xproj : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(1 : ℂ) / 2, (1 : ℂ) / 2; (1 : ℂ) / 2, (1 : ℂ) / 2]

theorem nonvacuity :
    IsValuation (fun A => (rho0 * A).trace.re) ∧ (rho0 * xproj).trace.re = (1 : ℝ) / 2 := by
  have traceform : ∀ A : Matrix (Fin 2) (Fin 2) ℂ,
      (rho0 * A).trace.re = 3 / 4 * (A 0 0).re + 1 / 4 * (A 1 1).re := by
    intro A
    simp [rho0, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two, Matrix.diag]
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
  · simp [rho0, xproj, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two, Matrix.diag]
    norm_num

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteEffectValuationHomogeneity.valuation_real_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms valuation_real_smul

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteEffectValuationHomogeneity.nonvacuity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonvacuity

end PhysicsSM.Draft.NullEdge.FiniteEffectValuationHomogeneity
