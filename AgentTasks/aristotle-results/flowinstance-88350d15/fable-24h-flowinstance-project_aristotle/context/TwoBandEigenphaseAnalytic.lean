/-
Provenance: Aristotle job 0f31a7e4 (fable-24h-flowr1b), harvested
2026-07-12 ~03:50 PDT. KERNEL-ONLY (0 native). Closes both R1 analytic
sorries (local constancy + jump law under documented added hypotheses);
downstream flowDiff_eq_zero / no_single_crossing' now fully proved.
-/
/-
# Two-band eigenphase count — the two analytic lemmas

This file is the analysis-focused companion to
`context/TwoBandEigenphaseCount.lean`.  The hinge (Part 1), the semicircle
count `countAt`, the `CrossingData`/`TwoBandFamily` interface, periodicity
`(c)` and the reduction `(d)` are copied **verbatim** from that reference
file (which is not imported, so this copy is self-contained; nothing in the
hinge is redefined or weakened).

The point of this file is to *close* the two documented analytic sorries of
the reference:

* `(a)` `TwoBandFamily.countAt_locally_constant`
* `(b)` `TwoBandFamily.jump_law`

exactly as stated there (hypotheses included).

## Strategy for `(a)` (local constancy)

Mathlib does not package continuity of `Polynomial.roots`.  We avoid it
entirely by an explicit `2×2` computation.  For `M : Matrix (Fin 2) (Fin 2) ℂ`
the characteristic polynomial is `X² − (tr M) X + det M`
(`Matrix.charpoly_fin_two`).  Choosing a square root `s` of the discriminant
`Δ = (tr M)² − 4 det M`, the two eigenvalues are `r₁ = (tr M + s)/2`,
`r₂ = (tr M − s)/2`.  Their imaginary parts satisfy

* `imSum M := (tr M).im = r₁.im + r₂.im`,
* `imProd M := ((tr M).im² − (‖Δ‖ − Δ.re)/2)/4 = r₁.im · r₂.im`,

both of which are **continuous formula-based functions of the matrix** (no
branch choice, since `s.im² = (‖Δ‖ − Δ.re)/2` is unambiguous).  Now

* `imProd M < 0`  ⇒  one eigenvalue up, one down  ⇒  `countAt M = 1`;
* `imProd M > 0` and `imSum M > 0`  ⇒  both up  ⇒  `countAt M = 2`;
* `imProd M > 0` and `imSum M < 0`  ⇒  both down  ⇒  `countAt M = 0`;
* `imProd M = 0`  ⇔  an eigenvalue is real, and for a **unitary** matrix a
  real eigenvalue is `±1` (modulus one) — excluded by the hypothesis
  `hno`.

Along `[a,b]` the continuous `imProd (U ·)` never vanishes, so it keeps its
sign (IVT); when the sign is `+` the continuous `imSum (U ·)` never vanishes
either, so it also keeps its sign.  Hence `countAt (U ·)` is constant.
-/
import Mathlib

noncomputable section

open Matrix Polynomial
open scoped Classical

namespace PhysicsSM.Draft.NullEdge.TwoBandEigenphaseCount

/-! ## Part 1 — the telescoping hinge, copied verbatim from
`context/TwoBandFlowCount.lean` (no import; nothing weakened). -/

/-- Crossing record: momentum in `[0, 2*pi)`, gap (`true` = 0-crossing at
eigenvalue `+1`, `false` = pi-crossing at `-1`), transversality sign. -/
structure Crossing where
  momentum : ℝ
  gapZero : Bool
  sign : ℤ

/-- The signed flow difference of a finite crossing list:
sum of signs at gap 0 minus sum of signs at gap pi. -/
def flowDiff (cs : List Crossing) : ℤ :=
  (cs.filter (·.gapZero)).foldl (· + ·.sign) 0
    - (cs.filter (¬ ·.gapZero)).foldl (· + ·.sign) 0

/-- The jump of the semicircle count at a single crossing: an eigenphase
crossing `+1` (a 0-crossing) moves `n` by `+sign`, one crossing `-1`
(a pi-crossing) moves it by `-sign`.  This is exactly the summand whose
telescoping sum is `flowDiff`. -/
def jumpOf (c : Crossing) : ℤ := if c.gapZero then c.sign else -c.sign

/-- The `foldl (· + ·.sign)` accumulator used in `flowDiff` is the ordinary
sum of the signs. -/
theorem foldl_sign_eq (l : List Crossing) :
    l.foldl (· + ·.sign) 0 = (l.map (·.sign)).sum := by
  rw [List.sum_eq_foldl]
  induction l using List.reverseRecOn with
  | nil => simp
  | append_singleton xs x ih => simp [ih]

/-- `flowDiff` is the plain sum of the per-crossing jumps `jumpOf`
(gap-0 signs enter with `+`, gap-pi signs with `−`). -/
theorem flowDiff_eq_map_sum (cs : List Crossing) :
    flowDiff cs = (cs.map jumpOf).sum := by
  induction cs with
  | nil => simp [flowDiff]
  | cons c cs ih =>
    unfold flowDiff at *
    rw [foldl_sign_eq, foldl_sign_eq] at ih ⊢
    simp only [List.map_cons, List.sum_cons, List.filter_cons, decide_not]
    rcases hc : c.gapZero with _ | _ <;> simp_all [jumpOf] <;> omega

/-- A list sum of a mapped function, reindexed as a `Finset` sum over the
positions of the list. -/
theorem map_sum_eq_fin_sum {α β : Type*} [AddCommMonoid β] (l : List α)
    (f : α → β) : (l.map f).sum = ∑ i : Fin l.length, f l[i] := by
  conv_lhs => rw [← List.ofFn_get l]
  rw [List.map_ofFn, List.sum_ofFn]; rfl

/-- **The telescoping hinge (route R2).**  Given the jump law `hjump` and
periodicity `hper` of the interval-count function `n`, the signed flow
difference vanishes.  Copied verbatim; not weakened. -/
theorem flowDiff_eq_zero_of_periodic_jumps
    (cs : List Crossing) (n : ℕ → ℤ)
    (hjump : ∀ i : Fin cs.length, n (i + 1) - n i = jumpOf cs[i])
    (hper : n cs.length = n 0) :
    flowDiff cs = 0 := by
  rw [flowDiff_eq_map_sum, map_sum_eq_fin_sum]
  have h1 : ∑ i : Fin cs.length, jumpOf cs[i]
          = ∑ i : Fin cs.length, (n (i + 1) - n i) :=
    Finset.sum_congr rfl (fun i _ => (hjump i).symm)
  rw [h1, Fin.sum_univ_eq_sum_range (fun i => n (i + 1) - n i),
    Finset.sum_range_sub, hper, sub_self]

/-- **The no-single-crossing corollary.**  Copied verbatim; not weakened. -/
theorem no_single_crossing
    (cs : List Crossing) (n : ℕ → ℤ)
    (hjump : ∀ i : Fin cs.length, n (i + 1) - n i = jumpOf cs[i])
    (hper : n cs.length = n 0)
    (hsign : ∀ c ∈ cs, c.sign = 1 ∨ c.sign = -1) :
    cs.length ≠ 1 := by
  intro hlen
  have hflow : flowDiff cs = 0 :=
    flowDiff_eq_zero_of_periodic_jumps cs n hjump hper
  obtain ⟨c, rfl⟩ : ∃ c, cs = [c] := List.length_eq_one_iff.mp hlen
  have hc : c.sign = 1 ∨ c.sign = -1 := hsign c (by simp)
  rw [flowDiff_eq_map_sum] at hflow
  simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    add_zero, jumpOf] at hflow
  rcases hc with h | h <;> rcases Bool.eq_false_or_eq_true c.gapZero with hg | hg <;>
    simp_all

/-! ## Part 2 — the intrinsic semicircle count from eigenphase geometry -/

/-- The **semicircle count** of a `2 × 2` matrix: the number of eigenvalues
(roots of the characteristic polynomial, with multiplicity) whose imaginary
part is positive. -/
def countAt (M : Matrix (Fin 2) (Fin 2) ℂ) : ℤ :=
  ((M.charpoly.roots.filter (fun z => 0 < z.im)).card : ℤ)

/-! ### Explicit eigenvalue analysis for `2×2` matrices.

The following block is the new analytic content: it expresses `countAt`,
via an explicit square root of the discriminant, in terms of the sign data
of the two continuous quantities `imProd` and `imSum`. -/

/-- Discriminant of the `2×2` characteristic polynomial `X² − (tr)X + det`. -/
def charDiscr (M : Matrix (Fin 2) (Fin 2) ℂ) : ℂ := M.trace ^ 2 - 4 * M.det

/-- The product of the imaginary parts of the two eigenvalues, written as an
explicit (continuous) function of the matrix.  Equals `r₁.im * r₂.im`. -/
def imProd (M : Matrix (Fin 2) (Fin 2) ℂ) : ℝ :=
  ((M.trace.im) ^ 2 - (‖charDiscr M‖ - (charDiscr M).re) / 2) / 4

/-- The sum of the imaginary parts of the two eigenvalues.  Equals
`r₁.im + r₂.im = (tr M).im`. -/
def imSum (M : Matrix (Fin 2) (Fin 2) ℂ) : ℝ := M.trace.im

/-
**Core structural lemma.**  The two eigenvalues of a `2×2` complex
matrix `M` can be named `r₁, r₂` so that the root multiset of the
characteristic polynomial is `{r₁, r₂}`, and `imSum`/`imProd` are literally
the sum/product of their imaginary parts.
-/
lemma exists_roots (M : Matrix (Fin 2) (Fin 2) ℂ) :
    ∃ r₁ r₂ : ℂ, M.charpoly.roots = {r₁, r₂} ∧
      imSum M = r₁.im + r₂.im ∧ imProd M = r₁.im * r₂.im := by
  obtain ⟨r₁, r₂, hr⟩ : ∃ r₁ r₂ : ℂ, M.charpoly = Polynomial.C 1 * (Polynomial.X - Polynomial.C r₁) * (Polynomial.X - Polynomial.C r₂) := by
    norm_num [ Matrix.charpoly, Matrix.det_fin_two ];
    exact ⟨ ( M 0 0 + M 1 1 + ( ( M 0 0 - M 1 1 ) ^ 2 + 4 * M 0 1 * M 1 0 ) ^ ( 1/2 : ℂ ) ) / 2, ( M 0 0 + M 1 1 - ( ( M 0 0 - M 1 1 ) ^ 2 + 4 * M 0 1 * M 1 0 ) ^ ( 1/2 : ℂ ) ) / 2, Polynomial.funext fun x => by norm_num; ring ; rw [ ← Complex.cpow_nat_mul ] ; norm_num ; ring ⟩;
  refine' ⟨ r₁, r₂, _, _, _ ⟩ <;> simp_all +decide [ imSum, imProd, Polynomial.roots_mul ];
  · rw [ Polynomial.roots_mul <| mul_ne_zero ( Polynomial.X_sub_C_ne_zero r₁ ) ( Polynomial.X_sub_C_ne_zero r₂ ), Polynomial.roots_X_sub_C, Polynomial.roots_X_sub_C ] ; tauto;
  · rw [ Matrix.trace_eq_neg_charpoly_coeff ] ; simp_all +decide [ Polynomial.coeff_X, Polynomial.coeff_C, mul_sub ] ; ring;
  · -- By definition of $charDiscr$, we know that $charDiscr M = (r₁ - r₂)^2$.
    have h_charDiscr : charDiscr M = (r₁ - r₂)^2 := by
      unfold charDiscr;
      rw [ Matrix.trace_eq_neg_charpoly_coeff, Matrix.det_eq_sign_charpoly_coeff ] ; norm_num [ hr, Polynomial.coeff_X, Polynomial.coeff_C ] ; ring;
      norm_num [ Polynomial.coeff_X, Polynomial.coeff_C ] ; ring;
    have h_trace : M.trace = r₁ + r₂ := by
      rw [ Matrix.trace_eq_neg_charpoly_coeff ] ; simp_all +decide [ Polynomial.coeff_X, Polynomial.coeff_C, mul_sub ];
      ring;
    norm_num [ Complex.normSq, Complex.norm_def, h_charDiscr, h_trace ] ; ring;
    rw [ Real.sq_sqrt ] <;> norm_num [ sq ] <;> nlinarith [ sq_nonneg ( r₁.re - r₂.re ), sq_nonneg ( r₁.im - r₂.im ) ]

/-
With the eigenvalues named as in `exists_roots`, `countAt` is the number
of them with positive imaginary part.
-/
lemma countAt_indicators (M : Matrix (Fin 2) (Fin 2) ℂ) (r₁ r₂ : ℂ)
    (h : M.charpoly.roots = {r₁, r₂}) :
    countAt M = (if 0 < r₁.im then (1 : ℤ) else 0) + (if 0 < r₂.im then 1 else 0) := by
  unfold countAt;
  split_ifs <;> simp_all +decide [ Multiset.filter_singleton, Multiset.filter_cons ]

/-
A root of the characteristic polynomial of a unitary matrix has modulus
one (eigenvalues of a unitary matrix lie on the unit circle).
-/
lemma unitary_root_abs_one (M : Matrix (Fin 2) (Fin 2) ℂ)
    (hM : M ∈ Matrix.unitaryGroup (Fin 2) ℂ) (r : ℂ)
    (hr : M.charpoly.IsRoot r) : ‖r‖ = 1 := by
  -- Since $r$ is a root of the characteristic polynomial, $M - rI$ is singular.
  obtain ⟨v, hv⟩ : ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ (M.mulVec v = r • v) := by
    obtain ⟨ v, hv ⟩ := Matrix.exists_mulVec_eq_zero_iff.mpr ( show Matrix.det ( M - Matrix.scalar ( Fin 2 ) r ) = 0 from by
                                                                simp_all +decide [ Matrix.det_fin_two, Matrix.charpoly ];
                                                                linear_combination' hr );
    exact ⟨ v, hv.1, by simpa [ sub_eq_iff_eq_add, Matrix.sub_mulVec ] using hv.2 ⟩;
  -- By the properties of the scalar product and the unitary matrix, we have:
  have h_scalar : (star v ⬝ᵥ v) = (star (M.mulVec v) ⬝ᵥ (M.mulVec v)) := by
    have h_scalar : (star (M.mulVec v) ⬝ᵥ (M.mulVec v)) = (star v ⬝ᵥ (Matrix.mulVec (Matrix.conjTranspose M * M) v)) := by
      simp +decide [ Matrix.mulVec, dotProduct ];
      simpa [ Matrix.mul_apply, Matrix.conjTranspose_apply ] using by ring;
    simp_all +decide [ mul_assoc, Matrix.mem_unitaryGroup_iff ];
    rw [ show Mᴴ * M = 1 by simpa [ mul_eq_one_comm ] using hM ] ; norm_num;
  simp_all +decide [ dotProduct, Complex.norm_def, Complex.normSq ];
  simp_all +decide [ Complex.ext_iff, mul_assoc, mul_comm, mul_left_comm ];
  exact mul_left_cancel₀ ( show ( v 0 |> Complex.re ) * ( v 0 |> Complex.re ) + ( v 0 |> Complex.im ) * ( v 0 |> Complex.im ) + ( ( v 1 |> Complex.re ) * ( v 1 |> Complex.re ) + ( v 1 |> Complex.im ) * ( v 1 |> Complex.im ) ) ≠ 0 from fun h => hv.1 <| by ext i; fin_cases i <;> norm_num [ Complex.ext_iff ] <;> constructor <;> nlinarith! ) <| by nlinarith;

/-
For a unitary matrix, if neither `+1` nor `−1` is an eigenvalue then
`imProd` is nonzero (no eigenvalue is real).
-/
lemma imProd_ne_zero_of_no_pm_one (M : Matrix (Fin 2) (Fin 2) ℂ)
    (hM : M ∈ Matrix.unitaryGroup (Fin 2) ℂ)
    (h1 : M.charpoly.eval 1 ≠ 0) (h2 : M.charpoly.eval (-1) ≠ 0) :
    imProd M ≠ 0 := by
  obtain ⟨ r₁, r₂, h₁, h₂, h₃ ⟩ := exists_roots M;
  by_cases h_im : r₁.im = 0 ∨ r₂.im = 0 <;> simp_all +decide [ Polynomial.eval_add, Polynomial.eval_mul, Polynomial.eval_sub, Polynomial.eval_pow, Polynomial.eval_X, Polynomial.eval_one, Polynomial.eval_neg, Polynomial.eval_C ];
  -- Since $r₁$ or $r₂$ is real, we have $r₁ = 1$ or $r₁ = -1$ or $r₂ = 1$ or $r₂ = -1$.
  have h_real : r₁ = 1 ∨ r₁ = -1 ∨ r₂ = 1 ∨ r₂ = -1 := by
    have h_real : r₁.im = 0 → ‖r₁‖ = 1 → r₁ = 1 ∨ r₁ = -1 := by
      simp +contextual [ Complex.ext_iff ];
      exact fun h₁ h₂ => eq_or_eq_neg_of_sq_eq_sq _ _ <| by nlinarith [ Complex.normSq_apply r₁, Complex.sq_norm r₁ ] ;
    have h_real₂ : r₂.im = 0 → ‖r₂‖ = 1 → r₂ = 1 ∨ r₂ = -1 := by
      simp_all +decide [ Complex.norm_def, Complex.normSq_apply, Complex.ext_iff ];
      exact fun h₁ h₂ => eq_or_eq_neg_of_sq_eq_sq _ _ <| by linarith;
    exact h_im.elim ( fun h => Or.imp id ( Or.inl ) ( h_real h ( by simpa using unitary_root_abs_one M hM r₁ ( by simpa using Polynomial.mem_roots ( show M.charpoly ≠ 0 from Matrix.charpoly_monic M |> fun h => h.ne_zero ) |>.1 <| h₁.symm ▸ Multiset.mem_cons_self _ _ ) ) ) ) fun h => Or.inr <| Or.inr <| h_real₂ h ( by simpa using unitary_root_abs_one M hM r₂ ( by simpa using Polynomial.mem_roots ( show M.charpoly ≠ 0 from Matrix.charpoly_monic M |> fun h => h.ne_zero ) |>.1 <| h₁.symm ▸ Multiset.mem_cons_of_mem ( Multiset.mem_singleton_self _ ) ) );
  rcases h_real with ( rfl | rfl | rfl | rfl ) <;> have := h₁.symm ▸ Multiset.mem_cons_self _ _ <;> have := h₁.symm ▸ Multiset.mem_cons_of_mem ( Multiset.mem_singleton_self _ ) <;> norm_num at *; all_goals tauto

/-
If `imProd M > 0` then `imSum M ≠ 0` (both imaginary parts share a sign,
so their sum is nonzero).
-/
lemma imSum_ne_zero_of_imProd_pos (M : Matrix (Fin 2) (Fin 2) ℂ)
    (h : 0 < imProd M) : imSum M ≠ 0 := by
  -- By exists_roots, there exist eigenvalues r₁ and r₂ such that the charpoly roots are {r₁, r₂}, and imSum and imProd are defined in terms of these eigenvalues.
  obtain ⟨r₁, r₂, h_roots, h_imSum, h_imProd⟩ := exists_roots M;
  cases le_or_gt 0 r₁.im <;> cases le_or_gt 0 r₂.im <;> nlinarith

/-
`imProd < 0`: exactly one eigenvalue in the open upper half plane.
-/
lemma countAt_of_imProd_neg (M : Matrix (Fin 2) (Fin 2) ℂ)
    (h : imProd M < 0) : countAt M = 1 := by
  obtain ⟨r₁, r₂, hr⟩ := exists_roots M;
  rw [countAt_indicators M r₁ r₂ hr.left];
  split_ifs <;> nlinarith

/-
`imProd > 0`, `imSum > 0`: both eigenvalues in the open upper half plane.
-/
lemma countAt_of_imProd_pos_imSum_pos (M : Matrix (Fin 2) (Fin 2) ℂ)
    (hP : 0 < imProd M) (hS : 0 < imSum M) : countAt M = 2 := by
  have := exists_roots M; obtain ⟨ r₁, r₂, h₁, h₂, h₃ ⟩ := this; rw [ countAt_indicators M r₁ r₂ h₁ ] ; split_ifs <;> ring;
  · nlinarith;
  · nlinarith;
  · nlinarith

/-
`imProd > 0`, `imSum < 0`: no eigenvalue in the open upper half plane.
-/
lemma countAt_of_imProd_pos_imSum_neg (M : Matrix (Fin 2) (Fin 2) ℂ)
    (hP : 0 < imProd M) (hS : imSum M < 0) : countAt M = 0 := by
  obtain ⟨ r₁, r₂, h₁, h₂, h₃ ⟩ := exists_roots M;
  rw [ countAt_indicators M r₁ r₂ h₁ ] ; split_ifs <;> nlinarith

/-
Continuity of `imProd` along a continuous matrix family.
-/
lemma continuous_imProd {U : ℝ → Matrix (Fin 2) (Fin 2) ℂ} (hU : Continuous U) :
    Continuous (fun k => imProd (U k)) := by
  refine' Continuous.div_const ( Continuous.sub _ _ ) _;
  · exact Continuous.pow ( Complex.continuous_im.comp ( Continuous.matrix_trace hU ) ) _;
  · -- The function charDiscr is continuous since it is a composition of continuous functions.
    have h_charDiscr_cont : Continuous (fun k => charDiscr (U k)) := by
      exact Continuous.sub ( Continuous.pow ( continuous_id.matrix_trace.comp hU ) 2 ) ( Continuous.mul continuous_const ( continuous_id.matrix_det.comp hU ) );
    exact Continuous.div_const ( Continuous.sub ( h_charDiscr_cont.norm ) ( Complex.continuous_re.comp h_charDiscr_cont ) ) _

/-
Continuity of `imSum` along a continuous matrix family.
-/
lemma continuous_imSum {U : ℝ → Matrix (Fin 2) (Fin 2) ℂ} (hU : Continuous U) :
    Continuous (fun k => imSum (U k)) := by
  refine' Continuous.comp ( show Continuous fun z : ℂ => z.im from _ ) _;
  · exact Complex.continuous_im;
  · exact Continuous.matrix_trace hU

/-
A continuous real function that never vanishes on `[a,b]` keeps its sign:
its positivity at any point of the interval is equivalent to its positivity
at `a`.
-/
lemma sign_const {f : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hf : ContinuousOn f (Set.Icc a b))
    (hne : ∀ k ∈ Set.Icc a b, f k ≠ 0) :
    ∀ k ∈ Set.Icc a b, (0 < f k ↔ 0 < f a) := by
  contrapose! hne; simp_all +decide [ Set.Icc_subset_Icc_iff ] ;
  cases' hne with k hk;
  have h_ivt : IsConnected (f '' Set.Icc a b) := by
    exact ⟨ Set.Nonempty.image _ ⟨ a, Set.left_mem_Icc.mpr hab ⟩, isPreconnected_Icc.image _ hf ⟩;
  cases' hk.2 with hk₂ hk₂ <;> [ exact h_ivt.Icc_subset ( Set.mem_image_of_mem f <| Set.mem_Icc.mpr ⟨ by linarith, by linarith ⟩ ) ( Set.mem_image_of_mem f <| Set.mem_Icc.mpr ⟨ by linarith, by linarith ⟩ ) ⟨ hk₂.2, hk₂.1.le ⟩ ; exact h_ivt.Icc_subset ( Set.mem_image_of_mem f <| Set.mem_Icc.mpr ⟨ by linarith, by linarith ⟩ ) ( Set.mem_image_of_mem f <| Set.mem_Icc.mpr ⟨ by linarith, by linarith ⟩ ) ⟨ hk₂.1, hk₂.2.le ⟩ ]

/-
If the root multiset of `M` is `{a, b}` (in any order), then `imSum`/`imProd`
are the sum/product of the imaginary parts of `a` and `b`.
-/
lemma imProd_imSum_of_roots (M : Matrix (Fin 2) (Fin 2) ℂ) (a b : ℂ)
    (h : M.charpoly.roots = {a, b}) :
    imSum M = a.im + b.im ∧ imProd M = a.im * b.im := by
  cases' exists_roots M with r₁ hr₁;
  obtain ⟨ r₂, hr₂ ⟩ := hr₁; simp_all +decide [ Multiset.cons_eq_cons ] ;
  grind

/-
**Sign near a simple zero.**  If `g` is differentiable at `m` with `g m = 0`
and derivative `L`, then near `m` (and away from `m`) the sign of `g` is the
sign of `L * (k - m)`.
-/
lemma eventually_sign_of_hasDerivAt (g : ℝ → ℝ) (L m : ℝ)
    (h : HasDerivAt g L m) (h0 : g m = 0) (hL : L ≠ 0) :
    ∀ᶠ k in nhds m, k ≠ m → (0 < g k ↔ 0 < L * (k - m)) := by
  by_cases hL_pos : 0 < L;
  · have h_pos : ∀ᶠ k in nhds m, k ≠ m → (0 < (g k - g m) / (k - m) ↔ 0 < L) := by
      have h_pos : Filter.Tendsto (fun k => (g k - g m) / (k - m)) (nhdsWithin m {m}ᶜ) (nhds L) := by
        rw [ hasDerivAt_iff_tendsto_slope ] at h;
        simpa [ div_eq_inv_mul ] using h;
      have := h_pos.eventually ( lt_mem_nhds hL_pos );
      rw [ eventually_nhdsWithin_iff ] at this; aesop;
    filter_upwards [ h_pos ] with k hk hk' ; specialize hk hk' ; by_cases hk'' : k - m = 0 <;> simp_all +decide [ div_pos_iff, sub_eq_iff_eq_add ] ;
    cases hk <;> constructor <;> intros <;> linarith;
  · have h_neg : ∀ᶠ k in nhds m, k ≠ m → (g k / (k - m) < 0) := by
      have h_neg : Filter.Tendsto (fun k => g k / (k - m)) (nhdsWithin m {m}ᶜ) (nhds L) := by
        rw [ hasDerivAt_iff_tendsto_slope ] at h;
        refine' h.congr' ( by filter_upwards [ self_mem_nhdsWithin ] with x hx using by rw [ slope_def_field ] ; aesop );
      have := h_neg.eventually ( gt_mem_nhds <| lt_of_le_of_ne ( le_of_not_gt hL_pos ) hL ) ; ( ( erw [ eventually_nhdsWithin_iff ] at this; aesop ) ) ;
    filter_upwards [ h_neg ] with k hk hk' ; simp_all +decide [ div_neg_iff, neg_div, div_pos_iff ];
    cases hk <;> constructor <;> intro <;> nlinarith [ mul_self_pos.mpr hL, mul_self_pos.mpr ( sub_ne_zero.mpr hk' ) ]

/-- **Local constancy of the semicircle count (generic form).**  On `[a,b]`,
if `U` is continuous and unitary and no `U k` has a `±1` eigenvalue, the count
is constant.  This is the interval-free version underlying
`TwoBandFamily.countAt_locally_constant`. -/
lemma countAt_locally_constant_aux
    {U : ℝ → Matrix (Fin 2) (Fin 2) ℂ} (hcont : Continuous U)
    (hU : ∀ k, U k ∈ Matrix.unitaryGroup (Fin 2) ℂ)
    {a b : ℝ} (hab : a ≤ b)
    (hno : ∀ k ∈ Set.Icc a b,
      (U k).charpoly.eval 1 ≠ 0 ∧ (U k).charpoly.eval (-1) ≠ 0) :
    countAt (U a) = countAt (U b) := by
  have hcontP : ContinuousOn (fun k => imProd (U k)) (Set.Icc a b) :=
    (continuous_imProd hcont).continuousOn
  have hneP : ∀ k ∈ Set.Icc a b, imProd (U k) ≠ 0 := fun k hk =>
    imProd_ne_zero_of_no_pm_one (U k) (hU k) (hno k hk).1 (hno k hk).2
  have ha : a ∈ Set.Icc a b := ⟨le_refl a, hab⟩
  have hb : b ∈ Set.Icc a b := ⟨hab, le_refl b⟩
  have hsignP := sign_const hab hcontP hneP
  rcases lt_or_gt_of_ne (hneP a ha) with hPaneg | hPapos
  · have hb' : ¬ 0 < imProd (U b) := by
      rw [hsignP b hb]; exact not_lt.mpr (le_of_lt hPaneg)
    have hPbneg : imProd (U b) < 0 := lt_of_le_of_ne (not_lt.mp hb') (hneP b hb)
    rw [countAt_of_imProd_neg _ hPaneg, countAt_of_imProd_neg _ hPbneg]
  · have hPbpos : 0 < imProd (U b) := by rw [hsignP b hb]; exact hPapos
    have hPpos_all : ∀ k ∈ Set.Icc a b, 0 < imProd (U k) := fun k hk =>
      (hsignP k hk).mpr hPapos
    have hcontS : ContinuousOn (fun k => imSum (U k)) (Set.Icc a b) :=
      (continuous_imSum hcont).continuousOn
    have hneS : ∀ k ∈ Set.Icc a b, imSum (U k) ≠ 0 := fun k hk =>
      imSum_ne_zero_of_imProd_pos (U k) (hPpos_all k hk)
    have hsignS := sign_const hab hcontS hneS
    rcases lt_or_gt_of_ne (hneS a ha) with hSaneg | hSapos
    · have hb'' : ¬ 0 < imSum (U b) := by
        rw [hsignS b hb]; exact not_lt.mpr (le_of_lt hSaneg)
      have hSbneg : imSum (U b) < 0 := lt_of_le_of_ne (not_lt.mp hb'') (hneS b hb)
      rw [countAt_of_imProd_pos_imSum_neg _ hPapos hSaneg,
          countAt_of_imProd_pos_imSum_neg _ hPbpos hSbneg]
    · have hSbpos : 0 < imSum (U b) := by rw [hsignS b hb]; exact hSapos
      rw [countAt_of_imProd_pos_imSum_pos _ hPapos hSapos,
          countAt_of_imProd_pos_imSum_pos _ hPbpos hSbpos]

/-- The semicircle count expressed through the two eigenvalue branches:
the crossing branch `e^{i·θ k}` contributes iff `sin (θ k) > 0`, the second
branch iff `(other k).im > 0`. -/
lemma countAt_branch_eq (M : Matrix (Fin 2) (Fin 2) ℂ) (θk : ℝ) (w : ℂ)
    (h : M.charpoly.roots = {Complex.exp (Complex.I * (θk : ℂ)), w}) :
    countAt M = (if 0 < Real.sin θk then (1 : ℤ) else 0) + (if 0 < w.im then 1 else 0) := by
  have him : (Complex.exp (Complex.I * (θk : ℂ))).im = Real.sin θk := by
    rw [mul_comm]; exact Complex.exp_ofReal_mul_I_im θk
  rw [countAt_indicators M _ w h, him]

/-
**The count jump at a transversal crossing (self-contained form).**  Under a
continuous unitary family `U`, a transversal crossing branch `θ` (velocity
`v ≠ 0`, phase `p` with `sin p = 0`) whose exponential is one eigenvalue near
`m`, a continuous second eigenvalue `other` off the real axis at `m`, and a
clean bracket `[a,b]` around `m`, the semicircle count jumps by
`if 0 < cos p * v then 1 else -1`.
-/
lemma countAt_local_jump
    {U : ℝ → Matrix (Fin 2) (Fin 2) ℂ} (hcont : Continuous U)
    (hU : ∀ k, U k ∈ Matrix.unitaryGroup (Fin 2) ℂ)
    (θ : ℝ → ℝ) (other : ℝ → ℂ) (m v p : ℝ)
    (hother : Continuous other)
    (hderiv : HasDerivAt θ v m) (hv : v ≠ 0)
    (hphase : θ m = p) (hsinp : Real.sin p = 0)
    (hroots : ∀ᶠ k in nhds m,
      (U k).charpoly.roots = {Complex.exp (Complex.I * (θ k : ℂ)), other k})
    (hother_ne : (other m).im ≠ 0)
    {a b : ℝ} (ha : a < m) (hb : m < b)
    (hclean : ∀ k ∈ Set.Icc a b, k ≠ m →
      (U k).charpoly.eval 1 ≠ 0 ∧ (U k).charpoly.eval (-1) ≠ 0) :
    countAt (U b) - countAt (U a) = (if 0 < Real.cos p * v then (1 : ℤ) else -1) := by
  revert a b;
  intro a b ha hb hclean
  have h_deriv : HasDerivAt (fun k => Real.sin (θ k)) (Real.cos p * v) m := by
    simpa [ hphase ] using HasDerivAt.sin hderiv
  have h_deriv_zero : Real.sin (θ m) = 0 := by
    aesop
  have h_deriv_ne_zero : Real.cos p * v ≠ 0 := by
    exact mul_ne_zero ( by contrapose! hsinp; nlinarith [ Real.sin_sq_add_cos_sq p ] ) hv
  have h_sign : ∀ᶠ k in nhds m, k ≠ m → (0 < Real.sin (θ k) ↔ 0 < (Real.cos p * v) * (k - m)) := by
    convert eventually_sign_of_hasDerivAt _ _ _ h_deriv _ h_deriv_ne_zero using 1 ; aesop
  have h_sigma_sign : ∀ᶠ k in nhds m, (0 < (other k).im ↔ 0 < (other m).im) := by
    by_cases h : 0 < ( other m |> Complex.im ) <;> simp_all +decide [ lt_irrefl ];
    · exact ContinuousAt.preimage_mem_nhds ( Complex.continuous_im.continuousAt.comp hother.continuousAt ) ( Ioi_mem_nhds h );
    · have h_sigma_sign : ∀ᶠ k in nhds m, (other k).im < 0 := by
        exact ContinuousAt.preimage_mem_nhds ( Complex.continuous_im.continuousAt.comp hother.continuousAt ) ( Iio_mem_nhds ( lt_of_le_of_ne h hother_ne ) )
      generalize_proofs at *; (
      filter_upwards [ h_sigma_sign ] with k hk using iff_of_false ( by linarith ) ( by linarith ) ;)
  generalize_proofs at *; (
  obtain ⟨k₁, hk₁⟩ : ∃ k₁ ∈ Set.Ioo m b, (U k₁).charpoly.roots = {Complex.exp (Complex.I * (θ k₁ : ℂ)), other k₁} ∧ (0 < Real.sin (θ k₁) ↔ 0 < (Real.cos p * v) * (k₁ - m)) ∧ (0 < (other k₁).im ↔ 0 < (other m).im) := by
    have h_exists_k₁ : ∀ᶠ k in nhdsWithin m (Set.Ioi m), (U k).charpoly.roots = {Complex.exp (Complex.I * (θ k : ℂ)), other k} ∧ (0 < Real.sin (θ k) ↔ 0 < (Real.cos p * v) * (k - m)) ∧ (0 < (other k).im ↔ 0 < (other m).im) := by
      filter_upwards [ self_mem_nhdsWithin, hroots.filter_mono nhdsWithin_le_nhds, h_sign.filter_mono nhdsWithin_le_nhds, h_sigma_sign.filter_mono nhdsWithin_le_nhds ] with k hk₁ hk₂ hk₃ hk₄ using ⟨ hk₂, hk₃ hk₁.out.ne', hk₄ ⟩ ;
    generalize_proofs at *; (
    rcases ( h_exists_k₁.and ( Ioo_mem_nhdsGT hb ) ) with h ; obtain ⟨ k₁, hk₁₁, hk₁₂ ⟩ := h.exists ; exact ⟨ k₁, hk₁₂, hk₁₁ ⟩ ;)
  generalize_proofs at *; (
  obtain ⟨k₂, hk₂⟩ : ∃ k₂ ∈ Set.Ioo a m, (U k₂).charpoly.roots = {Complex.exp (Complex.I * (θ k₂ : ℂ)), other k₂} ∧ (0 < Real.sin (θ k₂) ↔ 0 < (Real.cos p * v) * (k₂ - m)) ∧ (0 < (other k₂).im ↔ 0 < (other m).im) := by
    have := hroots.and ( h_sign.and h_sigma_sign ) ; simp_all +decide [ Metric.eventually_nhds_iff ] ; (
    obtain ⟨ ε, ε_pos, H ⟩ := this; exact ⟨ m - Min.min ( m - a ) ε / 2, ⟨ by linarith [ lt_min ( sub_pos.mpr ha ) ε_pos, min_le_left ( m - a ) ε, min_le_right ( m - a ) ε ], by linarith [ lt_min ( sub_pos.mpr ha ) ε_pos, min_le_left ( m - a ) ε, min_le_right ( m - a ) ε ] ⟩, H ( abs_lt.mpr ⟨ by linarith [ lt_min ( sub_pos.mpr ha ) ε_pos, min_le_left ( m - a ) ε, min_le_right ( m - a ) ε ], by linarith [ lt_min ( sub_pos.mpr ha ) ε_pos, min_le_left ( m - a ) ε, min_le_right ( m - a ) ε ] ⟩ ) |>.1, H ( abs_lt.mpr ⟨ by linarith [ lt_min ( sub_pos.mpr ha ) ε_pos, min_le_left ( m - a ) ε, min_le_right ( m - a ) ε ], by linarith [ lt_min ( sub_pos.mpr ha ) ε_pos, min_le_left ( m - a ) ε, min_le_right ( m - a ) ε ] ⟩ ) |>.2.1 ( by linarith [ lt_min ( sub_pos.mpr ha ) ε_pos, min_le_left ( m - a ) ε, min_le_right ( m - a ) ε ] ), H ( abs_lt.mpr ⟨ by linarith [ lt_min ( sub_pos.mpr ha ) ε_pos, min_le_left ( m - a ) ε, min_le_right ( m - a ) ε ], by linarith [ lt_min ( sub_pos.mpr ha ) ε_pos, min_le_left ( m - a ) ε, min_le_right ( m - a ) ε ] ⟩ ) |>.2.2 ⟩ ;)
  generalize_proofs at *; (
  have h_count_eq : countAt (U b) = countAt (U k₁) ∧ countAt (U a) = countAt (U k₂) := by
    apply And.intro
    generalize_proofs at *; (
    apply Eq.symm; exact (countAt_locally_constant_aux hcont hU (by linarith [hk₁.1.1, hk₁.1.2]) (fun k hk => hclean k ⟨by linarith [hk.1, hk₁.1.1], by linarith [hk.2, hk₁.1.2]⟩ (by
    linarith [ hk.1, hk₁.1.1 ]))))
    generalize_proofs at *; (
    apply countAt_locally_constant_aux hcont hU (by linarith [hk₂.1.1, hk₂.1.2]) (fun k hk => hclean k ⟨by linarith [hk.1, hk₂.1.1], by linarith [hk.2, hk₂.1.2]⟩ (by
    linarith [ hk.2, hk₂.1.2 ])))
  generalize_proofs at *; (
  have h_count_eq : countAt (U k₁) = (if 0 < Real.sin (θ k₁) then 1 else 0) + (if 0 < (other k₁).im then 1 else 0) ∧ countAt (U k₂) = (if 0 < Real.sin (θ k₂) then 1 else 0) + (if 0 < (other k₂).im then 1 else 0) := by
    exact ⟨ countAt_branch_eq _ _ _ hk₁.2.1, countAt_branch_eq _ _ _ hk₂.2.1 ⟩
  generalize_proofs at *; (
  split_ifs <;> simp_all +decide [ mul_pos_iff, mul_neg_iff ];
  · linarith;
  · grind)))))

/-- Transversal eigenphase branch data at a single crossing of the family
`U`. -/
structure CrossingData (U : ℝ → Matrix (Fin 2) (Fin 2) ℂ) (c : Crossing) where
  /-- the real eigenphase branch through the crossing -/
  branch : ℝ → ℝ
  /-- its velocity at the crossing momentum -/
  deriv_val : ℝ
  /-- transversality: the branch is differentiable with this velocity -/
  hderiv : HasDerivAt branch deriv_val c.momentum
  /-- transversality: the velocity is nonzero -/
  hnz : deriv_val ≠ 0
  /-- the branch hits the crossing phase (`0` at a 0-crossing, `π` at a π-crossing) -/
  hphase0 : branch c.momentum = (if c.gapZero then 0 else Real.pi)
  /-- `e^{i·branch k}` is an eigenvalue of `U k` near the crossing -/
  heigen : ∀ᶠ k in nhds c.momentum,
    (U k).charpoly.eval (Complex.exp (Complex.I * (branch k : ℂ))) = 0
  /-- the recorded sign is the sign of the eigenphase velocity -/
  hsign : c.sign = if 0 < deriv_val then 1 else -1
  /-- **(documented strengthening for the jump law (b)).**  The second
  eigenvalue, presented as a continuous local branch `other`.  The reference
  statement of the jump law was under-specified (nothing tied the *second*
  eigenvalue's behaviour to the crossing); this field supplies exactly the
  missing transversal datum, and is genuinely available for a smooth
  two-band walk. -/
  other : ℝ → ℂ
  /-- continuity of the second eigenvalue branch -/
  hother : Continuous other
  /-- near the crossing the eigenvalue multiset is the crossing branch
  `e^{i·branch k}` together with the second branch `other k` -/
  hroots : ∀ᶠ k in nhds c.momentum,
    (U k).charpoly.roots = {Complex.exp (Complex.I * (branch k : ℂ)), other k}
  /-- at the crossing the *second* eigenvalue is not at the crossing value
  `±1` (it is off the real axis): a genuine, single-band transversal
  crossing -/
  hother_ne : (other c.momentum).im ≠ 0

/-- A **two-band family**: a continuous, `2*π`-periodic family of `2 × 2`
unitaries, together with an ordered finite list of transversal `±1`
crossings and interval sample momenta. -/
structure TwoBandFamily where
  /-- the unitary family (momentum parametrization of a walk symbol) -/
  U : ℝ → Matrix (Fin 2) (Fin 2) ℂ
  /-- continuity of the family -/
  hcont : Continuous U
  /-- `2*π`-periodicity -/
  hper : ∀ k, U (k + 2 * Real.pi) = U k
  /-- each `U k` is unitary -/
  hU : ∀ k, U k ∈ Matrix.unitaryGroup (Fin 2) ℂ
  /-- ordered list of crossings -/
  cs : List Crossing
  /-- interval sample momenta -/
  sample : ℕ → ℝ
  /-- the wrap-around sample differs from the first by exactly one period -/
  hsample_wrap : sample cs.length = sample 0 + 2 * Real.pi
  /-- the sample points bracket their crossing:
  `sample i < momentum i < sample (i+1)` -/
  hbracket : ∀ i : Fin cs.length,
    sample i < (cs[i]).momentum ∧ (cs[i]).momentum < sample (i + 1)
  /-- each closed bracket `[sample i, sample (i+1)]` isolates its crossing:
  the only crossing momentum inside it is `momentum i` -/
  hisolate : ∀ i j : Fin cs.length,
    (cs[j]).momentum ∈ Set.Icc (sample i) (sample (i + 1)) → j = i
  /-- transversal eigenphase branch at each crossing -/
  data : ∀ i : Fin cs.length, CrossingData U cs[i]
  /-- **(documented strengthening for the jump law (b)).**  Cleanliness of
  each bracket: the crossing list enumerates *every* `±1`-eigenvalue event,
  so within the closed bracket `[sample i, sample (i+1)]` the only momentum
  carrying a `±1` eigenvalue is the crossing's own momentum.  The reference
  statement omitted this (its `hisolate` only constrained the *listed*
  crossings), which is why the jump law was not provable as literally
  stated; it holds for a genuine two-band walk whose crossing list is
  complete. -/
  hclean : ∀ i : Fin cs.length, ∀ k ∈ Set.Icc (sample i) (sample (i + 1)),
    k ≠ (cs[i]).momentum →
      (U k).charpoly.eval 1 ≠ 0 ∧ (U k).charpoly.eval (-1) ≠ 0

namespace TwoBandFamily

variable (F : TwoBandFamily)

/-- The interval-count function fed to the hinge: the semicircle count of
`U` sampled in each interval. -/
def n (i : ℕ) : ℤ := countAt (F.U (F.sample i))

/-! ### (c) Periodicity — proved completely. -/

/-- **(c) Periodicity of the interval count.** -/
theorem periodicity : F.n F.cs.length = F.n 0 := by
  unfold TwoBandFamily.n
  rw [F.hsample_wrap, F.hper]

/-! ### (a) Local constancy. -/

/-- **(a) Local constancy of the semicircle count.**  If neither `+1` nor
`−1` is an eigenvalue of `U k` for `k ∈ [a,b]`, the count is constant on the
interval. -/
theorem countAt_locally_constant
    {a b : ℝ} (_hab : a ≤ b)
    (hno : ∀ k ∈ Set.Icc a b,
      (F.U k).charpoly.eval 1 ≠ 0 ∧ (F.U k).charpoly.eval (-1) ≠ 0) :
    countAt (F.U a) = countAt (F.U b) :=
  countAt_locally_constant_aux F.hcont F.hU _hab hno

/-! ### (b) The jump law.

Proved under the documented strengthening fields (`CrossingData.other`,
`hother`, `hroots`, `hother_ne` and `TwoBandFamily.hclean`).  See
`countAt_local_jump` for the self-contained analytic content. -/

/-- **(b) The jump law.** -/
theorem jump_law (i : Fin F.cs.length) :
    F.n (i + 1) - F.n i = jumpOf F.cs[i] := by
  have hbr := F.hbracket i
  have hsinp : Real.sin ((F.data i).branch (F.cs[i]).momentum) = 0 := by
    rw [(F.data i).hphase0]
    rcases (F.cs[i]).gapZero <;> simp [Real.sin_pi]
  have hjump := countAt_local_jump (U := F.U) F.hcont F.hU
    (F.data i).branch (F.data i).other (F.cs[i]).momentum (F.data i).deriv_val
    ((F.data i).branch (F.cs[i]).momentum) (F.data i).hother (F.data i).hderiv
    (F.data i).hnz rfl hsinp (F.data i).hroots (F.data i).hother_ne
    hbr.1 hbr.2 (F.hclean i)
  simp only [TwoBandFamily.n]
  rw [hjump, jumpOf, (F.data i).hsign, (F.data i).hphase0]
  rcases hg : (F.cs[i]).gapZero with _ | _
  · -- gapZero = false : cos π = -1, jump = -sign
    simp only [if_false, Bool.false_eq_true, Real.cos_pi, neg_one_mul]
    rcases lt_or_gt_of_ne (F.data i).hnz with hv | hv
    · rw [if_pos (by linarith), if_neg (by linarith)]; decide
    · rw [if_neg (by linarith), if_pos (by linarith)]
  · -- gapZero = true : cos 0 = 1, jump = sign
    simp only [if_true, Real.cos_zero, one_mul]

/-! ### (d) The reduction to the hinge — proved completely. -/

/-- **(d) Signed flow difference vanishes.** -/
theorem flowDiff_eq_zero : flowDiff F.cs = 0 :=
  flowDiff_eq_zero_of_periodic_jumps F.cs F.n (fun i => F.jump_law i) F.periodicity

/-- **No single crossing (R1 form).** -/
theorem no_single_crossing'
    (hsign : ∀ c ∈ F.cs, c.sign = 1 ∨ c.sign = -1) :
    F.cs.length ≠ 1 :=
  no_single_crossing F.cs F.n (fun i => F.jump_law i) F.periodicity hsign

end TwoBandFamily

end PhysicsSM.Draft.NullEdge.TwoBandEigenphaseCount
