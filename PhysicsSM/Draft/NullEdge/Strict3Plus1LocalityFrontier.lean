import PhysicsSM.Draft.NullEdge.WilsonCayleyWalk

/-!
# Strict finite-Fourier locality and the repaired 3+1 frontier

This module makes the locality missing from `AdmissibleWalk` explicit.  A
translation-invariant walk is strictly local when its Bloch symbol is a finite
Fourier sum with integer lattice frequencies.  The finite set and every matrix
coefficient are part of the witness.

The Wilson--Cayley walk is excluded: although its Wilson Hamiltonian is a
finite Fourier symbol, taking the Cayley inverse introduces the denominator
`3 - cos t` on a coordinate axis, and that rational function is not a finite
Laurent polynomial.  The live successive-axis walk is strictly local.

Strict locality is deliberately not identified with a charge-balance law.  The
last theorem is the corrected torus statement: locality is carried explicitly,
while finite crossing census, balanced integer charge, nonzero origin charge,
and fundamental-domain control remain separate hypotheses.

Provenance: clean-room Aristotle return
`e8b5248b-6f50-44e3-9fc3-2d33877f6e5d` (task
`3758948f-ff32-4f41-adfd-9f41424675ca`), locally reviewed and rebuilt under
the pinned project toolchain.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier

/-- Integer momenta of the spatial lattice. -/
abbrev LatticeFrequency := Fin 3 → ℤ

/-- The character `q ↦ exp(i n·q)` of the three-dimensional momentum torus. -/
def fourierCharacter (n : LatticeFrequency) (q : Fin 3 → ℝ) : ℂ :=
  Complex.exp (Complex.I * ∑ j, (n j : ℂ) * (q j : ℂ))

/-- A finite Fourier/Laurent symbol, with an explicit finite support witness. -/
def HasFiniteFourierSupport (U : Sym) : Prop :=
  ∃ (S : Finset LatticeFrequency) (A : LatticeFrequency → Mat4),
    ∀ q, U q = ∑ n ∈ S, fourierCharacter n q • A n

/-- The strict translation-invariant QCA locality field used in this module. -/
abbrev StrictLocality := HasFiniteFourierSupport

/-
Strict locality is closed under pointwise multiplication of symbols.
-/
lemma HasFiniteFourierSupport.mul {U V : Sym}
    (hU : HasFiniteFourierSupport U) (hV : HasFiniteFourierSupport V) :
    HasFiniteFourierSupport (fun q => U q * V q) := by
  obtain ⟨ S₁, A₁, hS₁ ⟩ := hU
  obtain ⟨ S₂, A₂, hS₂ ⟩ := hV;
  -- The product of two finite sums is a finite sum.
  have h_prod : ∀ q, (U q) * (V q) = ∑ n ∈ S₁ ×ˢ S₂, (fourierCharacter n.1 q * fourierCharacter n.2 q) • (A₁ n.1 * A₂ n.2) := by
    simp +decide [ hS₁, hS₂, Finset.sum_mul _ _ _, Finset.mul_sum, Finset.sum_product, mul_assoc, mul_left_comm, smul_smul ];
    exact fun q => Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by rw [ mul_comm ] ;
  -- Apply the lemma that states the product of two finite sums is a finite sum.
  have h_prod_finite : ∀ q, (U q) * (V q) = ∑ n ∈ S₁ ×ˢ S₂, fourierCharacter (n.1 + n.2) q • (A₁ n.1 * A₂ n.2) := by
    intro q; rw [ h_prod q ] ; refine' Finset.sum_congr rfl fun n hn => _ ; simp +decide [ fourierCharacter ] ; ring;
    rw [ ← Complex.exp_add, Finset.sum_add_distrib, mul_add ];
  use Finset.image (fun n => n.1 + n.2) (S₁ ×ˢ S₂);
  use fun n => ∑ m ∈ Finset.filter (fun m => m.1 + m.2 = n) (S₁ ×ˢ S₂), A₁ m.1 * A₂ m.2;
  simp +decide [ h_prod_finite, Finset.sum_image' ];
  intro q; rw [ Finset.sum_image' ] ; simp +decide [ Finset.sum_smul ] ;
  intro a b ha hb; rw [ Finset.smul_sum ] ; exact Finset.sum_congr rfl fun x hx => by aesop;

/-
A constant onsite matrix is strictly local.
-/
lemma hasFiniteFourierSupport_const (M : Mat4) :
    HasFiniteFourierSupport (fun _ => M) := by
  refine' ⟨ { 0 }, fun _ => M, fun q => _ ⟩ ; simp +decide;
  unfold fourierCharacter; norm_num;

/-
Each exact Dirac factor in one coordinate has support on the two nearest
neighbour lattice displacements `±e_j`.
-/
lemma factor_axis_hasFiniteFourierSupport (j : Fin 3) (g : Mat4) :
    HasFiniteFourierSupport
      (fun q => Compact3Plus1DiracRate.factor (q j) g) := by
  use {Pi.single j 1, Pi.single j (-1)};
  use fun n => if n = Pi.single j 1 then (1 / 2 : ℂ) • (1 - g) else (1 / 2 : ℂ) • (1 + g);
  intro q; fin_cases j <;> simp +decide [ fourierCharacter, Compact3Plus1DiracRate.factor ] ; ring;
  · simp +decide [ Fin.sum_univ_three, Complex.ext_iff, Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin ] ; ring;
    ext i j ; norm_num ; ring;
  · simp +decide [ Fin.sum_univ_three, Complex.ext_iff, Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin ] ; ring;
    ext i j ; norm_num ; ring;
  · simp +decide [ Fin.sum_univ_three, Complex.cos, Complex.sin ] ; ring;
    ext i j ; norm_num ; ring

/-
**Required locality rung.**  The live successive-axis walk has an explicit
finite Fourier witness (obtained by multiplying its three two-point supports).
-/
theorem splitU_strictLocality : StrictLocality splitU := by
  -- Apply the factor_axis_hasFiniteFourierSupport lemma to each of the three factors.
  have h_factors : ∀ j : Fin 3, HasFiniteFourierSupport (fun q => Compact3Plus1DiracRate.factor (q j) (diracAlpha j)) := by
    exact fun j => factor_axis_hasFiniteFourierSupport j _;
  unfold splitU;
  convert HasFiniteFourierSupport.mul ( h_factors 0 ) ( HasFiniteFourierSupport.mul ( h_factors 1 ) ( h_factors 2 ) ) using 1;
  unfold Finite3Plus1BrillouinAudit.masslessWalk diracAlpha; norm_num [ Compact3Plus1DiracRate.splitStep ] ;
  unfold Compact3Plus1DiracRate.factor; norm_num [ mul_assoc ] ;

/-
The `(0,0)` entry of the Wilson--Cayley symbol on the first coordinate
axis.  This exact formula exposes the Cayley denominator.
-/
set_option maxHeartbeats 800000 in
lemma wilsonCayley_axis_entry00 (t : ℝ) :
    (wilsonCayleyWalk.U (axisRay 0 t)) 0 0 =
      ((1 + Real.cos t : ℂ) - 2 * Complex.I * (1 - Real.cos t)) /
        (3 - Real.cos t) := by
  unfold wilsonCayleyWalk;
  unfold cayley wilsonK;
  simp +decide [ axisRay, Compact3Plus1DiracRate.alpha1, Compact3Plus1DiracRate.alpha2, Compact3Plus1DiracRate.alpha3, Compact3Plus1DiracRate.beta, Matrix.inv_def ];
  simp +decide [ Matrix.det_succ_row_zero, Matrix.adjugate_apply, Matrix.mul_apply, Fin.sum_univ_succ ];
  simp +decide [ Fin.succAbove, Matrix.one_apply ];
  unfold wilsonS; norm_num [ Fin.sum_univ_succ ] ; ring;
  rw [ show ( I : ℂ ) ^ 4 = ( I ^ 2 ) ^ 2 by ring, show ( I : ℂ ) ^ 3 = ( I ^ 2 ) * I by ring ] ; norm_num ; ring;
  rw [ show ( sin t : ℂ ) ^ 4 = ( sin t ^ 2 ) ^ 2 by ring, show ( sin t : ℂ ) ^ 2 = 1 - ( cos t : ℂ ) ^ 2 by rw [ Complex.sin_sq ] ] ; ring;
  grind

/-
Orthogonality of integer Fourier modes on one period.
-/
lemma integral_fourier_mode (k : ℤ) :
    ∫ t : ℝ in (0 : ℝ)..2 * Real.pi,
      Complex.exp (Complex.I * (k : ℂ) * (t : ℂ)) =
        if k = 0 then 2 * Real.pi else 0 := by
  by_cases hk : k = 0 <;> simp +decide [ hk ];
  convert integral_exp_mul_complex ( show ( I * k : ℂ ) ≠ 0 by simpa [ Complex.ext_iff ] using hk ) using 1 ; norm_num;
  exact Eq.symm ( div_eq_zero_iff.mpr <| Or.inl <| sub_eq_zero.mpr <| Complex.exp_eq_one_iff.mpr ⟨ k, by ring ⟩ )

/-
Coefficients of a finite integer Fourier sum are unique.
-/
lemma finite_fourier_coefficients_unique
    (S T : Finset ℤ) (a b : ℤ → ℂ)
    (h : ∀ t : ℝ,
      ∑ n ∈ S, a n * Complex.exp (Complex.I * (n : ℂ) * (t : ℂ)) =
      ∑ n ∈ T, b n * Complex.exp (Complex.I * (n : ℂ) * (t : ℂ))) :
    ∀ k : ℤ, (if k ∈ S then a k else 0) = (if k ∈ T then b k else 0) := by
  intro k
  have h_int : ∫ t in (Set.Icc 0 (2 * Real.pi)), (∑ n ∈ S, a n * cexp (I * n * t)) * (starRingEnd ℂ (cexp (I * k * t))) = ∫ t in (Set.Icc 0 (2 * Real.pi)), (∑ n ∈ T, b n * cexp (I * n * t)) * (starRingEnd ℂ (cexp (I * k * t))) := by
    simpa only [ h ];
  -- Evaluate the integrals using the orthogonality of the Fourier modes.
  have h_eval : ∀ (S : Finset ℤ) (a : ℤ → ℂ), ∫ t in (Set.Icc 0 (2 * Real.pi)), (∑ n ∈ S, a n * cexp (I * n * t)) * (starRingEnd ℂ (cexp (I * k * t))) = 2 * Real.pi * (if k ∈ S then a k else 0) := by
    intros S a
    have h_eval : ∀ (n : ℤ), ∫ t in (Set.Icc 0 (2 * Real.pi)), cexp (I * n * t) * (starRingEnd ℂ (cexp (I * k * t))) = if n = k then 2 * Real.pi else 0 := by
      intro n
      have h_eval : ∫ t in (Set.Icc 0 (2 * Real.pi)), cexp (I * (n - k) * t) = if n = k then 2 * Real.pi else 0 := by
        split_ifs <;> simp_all +decide [ MeasureTheory.integral_Icc_eq_integral_Ioc, ← intervalIntegral.integral_of_le Real.two_pi_pos.le ];
        · norm_num [ Real.pi_pos.le ];
        · have := integral_fourier_mode ( n - k ) ; simp_all +decide [ sub_eq_iff_eq_add ] ;
      convert h_eval using 3 ; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ] ; ring;
      exact ⟨ by rw [ Real.cos_sub ], by rw [ Real.sin_sub ] ; ring ⟩;
    simp +decide only [Finset.sum_mul _ _ _];
    rw [ MeasureTheory.integral_finset_sum ];
    · simp_all +decide [ mul_assoc, MeasureTheory.integral_const_mul ];
      split_ifs <;> simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ];
      · rw [ Finset.sum_eq_single k ] <;> aesop;
      · exact Finset.sum_eq_zero fun x hx => by aesop;
    · exact fun _ _ => Continuous.integrableOn_Icc ( by continuity );
  rw [ h_eval S a, h_eval T b ] at h_int;
  exact mul_left_cancel₀ ( by norm_num [ Real.pi_ne_zero ] : ( 2 * Real.pi : ℂ ) ≠ 0 ) h_int

/-
The finite-support recurrence produced by the Cayley denominator has no
solution.  This is the discrete outermost-coefficient argument.
-/
lemma no_finite_cayley_recurrence :
    ¬ ∃ (S : Finset ℤ) (a : ℤ → ℂ),
      (∀ k, k ∉ S → a k = 0) ∧
      ∀ k,
        (if k = 0 then 1 - 2 * Complex.I
          else if k = 1 ∨ k = -1 then (1 + 2 * Complex.I) / 2 else 0) =
        3 * a k - (a (k - 1) + a (k + 1)) / 2 := by
  by_contra h_contra
  obtain ⟨S, a, ha⟩ := h_contra;
  -- By induction, we can show that $a_k = 0$ for all $k > 1$.
  have h_ind_pos : ∀ k > 1, a k = 0 := by
    intro k hk;
    by_contra h_contra;
    -- Let $m$ be the largest integer such that $a_m \neq 0$.
    obtain ⟨m, hm⟩ : ∃ m, a m ≠ 0 ∧ ∀ n > m, a n = 0 := by
      have h_finite : Set.Finite {k | a k ≠ 0} := by
        exact Set.Finite.subset ( Finset.finite_toSet S ) fun x hx => Classical.not_not.1 fun hx' => hx <| ha.1 x hx';
      exact ⟨ Finset.max' ( h_finite.toFinset ) ⟨ k, h_finite.mem_toFinset.mpr h_contra ⟩, h_finite.mem_toFinset.mp ( Finset.max'_mem _ _ ), fun n hn => Classical.not_not.1 fun hnn => not_lt_of_ge ( Finset.le_max' _ _ ( h_finite.mem_toFinset.mpr hnn ) ) hn ⟩;
    grind;
  have := ha.2 2; norm_num [ h_ind_pos ] at this;
  have := ha.2 1; norm_num [ ‹a 1 = 0› ] at this; norm_num [ Complex.ext_iff ] at this;
  have := ha.2 0; norm_num [ h_ind_pos ] at this;
  norm_num [ Complex.ext_iff ] at this;
  have := ha.2 ( -1 ) ; norm_num [ ‹a 1 = 0› ] at this; norm_num [ Complex.ext_iff ] at this;
  have h_a_neg3_zero : ∃ N : ℤ, ∀ k < N, a k = 0 := by
    exact ⟨ S.min' ( Finset.nonempty_of_ne_empty ( by rintro rfl; norm_num [ ha.1 ] at * ) ) - 1, fun k hk => ha.1 k <| by exact fun hk' => by linarith [ Finset.min'_le _ _ hk' ] ⟩;
  obtain ⟨ N, hN ⟩ := h_a_neg3_zero;
  induction' N using Int.induction_on with N ih N ih;
  · grind;
  · exact ih fun k hk => hN k <| by linarith;
  · grind

/-
A scalar finite Fourier sum cannot equal the displayed Cayley-axis entry.
This is the algebraic Laurent-polynomial obstruction: after multiplying by
`3-cos t`, comparison of the outermost Laurent coefficients recursively kills
all coefficients, contradicting the nonzero numerator.
-/
lemma cayley_axis_entry_not_finite_fourier :
    ¬ ∃ (S : Finset ℤ) (a : ℤ → ℂ), ∀ t : ℝ,
      ((1 + Real.cos t : ℂ) - 2 * Complex.I * (1 - Real.cos t)) /
          (3 - Real.cos t) =
        ∑ n ∈ S, a n * Complex.exp (Complex.I * (n : ℂ) * (t : ℂ)) := by
  intro h
  obtain ⟨S, a, h_eq⟩ := h
  have h_clear : ∀ t : ℝ, (1 + Real.cos t - 2 * Complex.I * (1 - Real.cos t)) = (3 - Real.cos t) * ∑ n ∈ S, a n * Complex.exp (Complex.I * n * t) := by
    exact fun t => by rw [ ← h_eq t, mul_div_cancel₀ _ ( by norm_cast; linarith [ Real.cos_le_one t ] ) ] ;
  -- Expand the right-hand side using the distributive property.
  have h_expand : ∀ t : ℝ, (1 + Real.cos t - 2 * Complex.I * (1 - Real.cos t)) = 3 * ∑ n ∈ S, a n * Complex.exp (Complex.I * n * t) - ∑ n ∈ S, a n * (Complex.exp (Complex.I * (n + 1) * t) + Complex.exp (Complex.I * (n - 1) * t)) / 2 := by
    intro t; rw [ h_clear t ] ; norm_num [ Complex.cos, Complex.exp_add, mul_add, mul_sub, Finset.mul_sum _ _ _, Finset.sum_mul ] ; ring;
    rw [ ← Finset.sum_sub_distrib ] ; congr ; ext ; norm_num [ Complex.exp_add ] ; ring;
  -- Apply the finite_fourier_coefficients_unique lemma to obtain the contradiction.
  have h_contradiction : ∀ k : ℤ, (if k = 0 then 1 - 2 * Complex.I else if k = 1 ∨ k = -1 then (1 + 2 * Complex.I) / 2 else 0) = 3 * (if k ∈ S then a k else 0) - ((if k - 1 ∈ S then a (k - 1) else 0) + (if k + 1 ∈ S then a (k + 1) else 0)) / 2 := by
    have h_contradiction : ∀ t : ℝ, ∑ k ∈ ({0, 1, -1} : Finset ℤ), (if k = 0 then 1 - 2 * Complex.I else if k = 1 ∨ k = -1 then (1 + 2 * Complex.I) / 2 else 0) * Complex.exp (Complex.I * k * t) = ∑ k ∈ S ∪ (S.image (fun n => n + 1)) ∪ (S.image (fun n => n - 1)), (3 * (if k ∈ S then a k else 0) - ((if k - 1 ∈ S then a (k - 1) else 0) + (if k + 1 ∈ S then a (k + 1) else 0)) / 2) * Complex.exp (Complex.I * k * t) := by
      intro t; convert h_expand t using 1; ring;
      · norm_num [ Complex.cos, Complex.exp_neg ] ; ring;
      · simp +decide [ Finset.sum_add_distrib, Finset.mul_sum _ _ _, Finset.sum_mul, sub_mul, add_mul, div_eq_mul_inv, mul_assoc, mul_left_comm, Finset.sum_add_distrib, Finset.sum_mul _ _ _, Finset.mul_sum _ _ _, Finset.sum_div, Finset.sum_const_zero, zero_add, add_zero, mul_zero, zero_mul, Finset.sum_ite, Finset.filter_mem_eq_inter, Finset.filter_not ];
        rw [ show ( S ∪ ( S.preimage ( fun x => x + -1 ) _ ∪ Finset.image ( fun n => n - 1 ) S ) ).filter ( fun x => x - 1 ∈ S ) = S.image ( fun n => n + 1 ) from ?_, show ( S ∪ ( S.preimage ( fun x => x + -1 ) _ ∪ Finset.image ( fun n => n - 1 ) S ) ).filter ( fun x => x + 1 ∈ S ) = S.image ( fun n => n - 1 ) from ?_ ];
        · rw [ Finset.sum_image, Finset.sum_image ] <;> norm_num [ Finset.sum_add_distrib, mul_add, add_mul, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Finset.sum_div, Finset.sum_const_zero, zero_add, add_zero, mul_zero, zero_mul, Finset.sum_ite, Finset.filter_mem_eq_inter, Finset.filter_not ] ; ring;
        · grind;
        · ext; simp [Finset.mem_image];
          lia;
    have := finite_fourier_coefficients_unique {0, 1, -1} (S ∪ (S.image (fun n => n + 1)) ∪ (S.image (fun n => n - 1))) (fun k => if k = 0 then 1 - 2 * Complex.I else if k = 1 ∨ k = -1 then (1 + 2 * Complex.I) / 2 else 0) (fun k => (3 * (if k ∈ S then a k else 0) - ((if k - 1 ∈ S then a (k - 1) else 0) + (if k + 1 ∈ S then a (k + 1) else 0)) / 2)) h_contradiction;
    grind;
  convert no_finite_cayley_recurrence ⟨ S, fun k => if k ∈ S then a k else 0, ?_, ?_ ⟩ using 1 <;> norm_num [ h_contradiction ];
  tauto

/-
Restricting a finite three-dimensional Fourier symbol to a coordinate axis
and then taking one matrix entry still gives a finite one-dimensional Fourier
sum.
-/
lemma finiteFourier_axis_entry
    {U : Sym} (hU : HasFiniteFourierSupport U) (j : Fin 3) (r c : Fin 4) :
    ∃ (S : Finset ℤ) (a : ℤ → ℂ), ∀ t : ℝ,
      U (axisRay j t) r c =
        ∑ n ∈ S, a n * Complex.exp (Complex.I * (n : ℂ) * (t : ℂ)) := by
  obtain ⟨ S, A, hS ⟩ := hU;
  -- Let's choose the finite set S' and coefficients a' for the restricted function.
  use Finset.image (fun n => n j) S, fun n => ∑ m ∈ S.filter (fun x => x j = n), (A m) r c;
  simp +decide [ hS, Finset.sum_filter, Finset.sum_image, fourierCharacter ];
  intro t; rw [ Finset.sum_image' ] ; simp +decide [ Finset.sum_mul _ _ _, Finset.mul_sum, Finset.sum_smul, Matrix.sum_apply ] ;
  congr! 1;
  intro n hn; rw [ Finset.sum_mul _ _ _ ] ; rw [ Finset.sum_filter ] ; congr! 1; simp +decide [ axisRay ] ; ring;
  rw [ Finset.sum_eq_single j ] <;> aesop

/-
**Required exclusion rung.**  The Wilson--Cayley counterexample to the old
locality-free theorem is not a strict finite-range translation-invariant QCA.
-/
theorem wilsonCayley_not_strictLocality :
    ¬ StrictLocality wilsonCayleyWalk.U := by
  intro h;
  -- Apply the finiteFourier_axis_entry lemma to the Wilson--Cayley model at axis 0 entry 0,0.
  obtain ⟨S, a, hS⟩ := finiteFourier_axis_entry h 0 0 0;
  exact cayley_axis_entry_not_finite_fourier ⟨ S, a, fun t => by rw [ ← hS t, wilsonCayley_axis_entry00 ] ⟩

/-- Admissibility together with the explicit strict-locality field. -/
structure StrictLocalAdmissibleWalk extends AdmissibleWalk where
  strictLocality : StrictLocality U

/-- The repaired interface is exactly nonvacuous: the live successive-axis walk
supplies all admissibility fields and a finite Fourier witness. -/
def splitStepStrictLocalWalk : StrictLocalAdmissibleWalk where
  toAdmissibleWalk := splitStepWalk
  strictLocality := splitU_strictLocality

/-
The Wilson--Cayley walk cannot inhabit the repaired strict-local interface.
-/
theorem wilsonCayley_excluded_from_strictLocalInterface :
    ¬ ∃ W : StrictLocalAdmissibleWalk,
      W.toAdmissibleWalk = wilsonCayleyWalk := by
  rintro ⟨ W, hW ⟩;
  convert wilsonCayley_not_strictLocality _;
  exact hW ▸ W.strictLocality

/-- **Corrected torus theorem.**  Strict locality is recorded as a genuine QCA
hypothesis, but it is not silently substituted for the independent global
charge-balance input.  A finite balanced combined-crossing census with the
usual origin and fundamental-domain conditions forces a torus-distinct
zero-or-pi crossing. -/
theorem strictLocal_admissible_doubling_torus_of_combined_balance
    (W : StrictLocalAdmissibleWalk)
    (S : Finset (Fin 3 → ℝ)) (chi : (Fin 3 → ℝ) → ℤ)
    (hS : ∀ q ∈ S, ZeroOrPiAlias (W.U q))
    (hbal : ∑ q ∈ S, chi q = 0)
    (h0 : (fun _ => (0 : ℝ)) ∈ S)
    (hchi0 : chi (fun _ => 0) ≠ 0)
    (hfund : ∀ q ∈ S, LatticeCongruentZero q → q = fun _ => 0) :
    ∃ q : Fin 3 → ℝ, ¬ LatticeCongruentZero q ∧ ZeroOrPiAlias (W.U q) := by
  exact admissible_doubling_torus_of_combined_balance W.toAdmissibleWalk
    S chi hS hbal h0 hchi0 hfund

/-! ## Assumption-footprint guards and exact nonvacuity witness -/

#guard splitStepStrictLocalWalk.strictLocality = splitU_strictLocality

/-- info: 'PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier.splitU_strictLocality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms splitU_strictLocality

/-- info: 'PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier.wilsonCayley_not_strictLocality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wilsonCayley_not_strictLocality

/-- info: 'PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier.strictLocal_admissible_doubling_torus_of_combined_balance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms strictLocal_admissible_doubling_torus_of_combined_balance

end PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier
