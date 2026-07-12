/-
Provenance: harvested from Aristotle job
`e22d0fe7-fc6a-4607-bd16-97fe5c2a2b96` (`lambda-uncertainty-generalN`, 2026-07-12).
Reviewed for semantic alignment before integration: `support_uncertainty` has the
exact submitted statement (general-N Donoho--Stark support bound over `ZMod N`,
`N <= (supp f).card * (supp (ZMod.dft f)).card`), proved via a genuine Plancherel +
Cauchy--Schwarz route (no `sorry`/`native_decide`). This is the general-N successor
to `LambdaConjugacy.support_uncertainty` (ZMod 4 only) named in the cosmological-
constant manuscript Section 6. Only edit from the returned file is this note.
-/
/-
# General-`N` finite Fourier support-uncertainty (Donoho--Stark)

Standalone Aristotle target. Imports ONLY Mathlib.

## What this generalizes and why

The null-edge cosmological-constant manuscript
(`Sources/Null_Edge_Cosmological_Constant_Manuscript_Draft_2026-07-12.tex`,
Section 6) makes the "`Lambda` is conjugate to volume" statement native to a
finite information theory by proving a support-uncertainty relation for the
discrete Fourier transform. The landed result
(`PhysicsSM/Draft/NullEdge/LambdaConjugacy.lean`,
`LambdaConjugacy.support_uncertainty`) is proved ONLY for `ZMod 4`, and by a
case-specific argument (either support is a singleton -- forcing the transform to
be everywhere nonzero -- or both supports have card >= 2, so the product is >= 4).
That argument does not scale.

The manuscript names the general-`N` relation as "the natural successor". This
file states it and asks for the honest general proof:

  for every `N >= 1` and every nonzero `f : ZMod N -> C`,
      `N <= (support f).card * (support (DFT f)).card`.

This is the Donoho--Stark support-uncertainty inequality (Donoho & Stark, SIAM
J. Appl. Math. 49 (1989), 906-931; see also Tao's "An uncertainty principle for
cyclic groups of prime order" for the sharper prime-`N` bound, which is NOT what
we ask here -- we want the general-`N` product bound, valid for all `N`).

Proving this retires the "`ZMod 4` witness only" scope caveat in Section 6 and
upgrades the finite-conjugacy claim from a single small register to the whole
family.

## Convention / faithfulness note

We use Mathlib's bundled transform `ZMod.dft` (notation `𝓕`), the counting-measure
DFT on `ZMod N`. The manuscript's `LambdaConjugacy.dft` uses the character
`w (j*k) = i^(j*k).val` on `ZMod 4`; the two agree up to the standard root-of-unity
convention and a global scaling, and -- crucially for THIS statement -- the
support cardinalities `(support f).card` and `(support (𝓕 f)).card` are invariant
under any nonzero rescaling and any relabelling of the frequency index by a group
automorphism. So the inequality proved here transfers verbatim to the manuscript's
convention. (A short lemma `dft_support_card_eq` witnessing "same support cards as
`LambdaConjugacy.dft` at `N = 4`" is optional and NOT required for the headline.)

## Target

Prove `support_uncertainty` below. The two `example`s at the bottom are sanity
checks (non-vacuity: the sharp `delta` register saturates the bound with product
exactly `N`).

## Suggested proof (standard, self-contained)

Write `k = (support f).card`, `m = (support (𝓕 f)).card`. Note `k >= 1` since
`f <> 0`. Goal `N <= k * m`.

1. Plancherel / unitarity of the counting-measure DFT:
       `sum_x ‖𝓕 f x‖^2 = N * sum_x ‖f x‖^2`.
2. `‖𝓕 f‖_infty <= ‖f‖_1`.
3. Cauchy--Schwarz on the support: `‖f‖_1^2 <= k * ‖f‖_2^2`.
4. `‖𝓕 f‖_2^2 <= m * ‖𝓕 f‖_infty^2`.

Chain and cancel `‖f‖_2^2 > 0`.
-/
import Mathlib

open scoped BigOperators ComplexConjugate
open Finset ZMod

namespace LambdaUncertaintyGeneralN

variable {N : ℕ} [NeZero N]

/-- Support of a function on `ZMod N`, as a `Finset` (finite type). Matches
`LambdaConjugacy.supp` at `N = 4`. -/
noncomputable def supp (f : ZMod N → ℂ) : Finset (ZMod N) :=
  Finset.univ.filter (fun j => f j ≠ 0)

theorem mem_supp {f : ZMod N → ℂ} {j : ZMod N} : j ∈ supp f ↔ f j ≠ 0 := by
  simp [supp]

/-
A nonzero function has nonempty support.
-/
theorem one_le_card_supp {f : ZMod N → ℂ} (hf : f ≠ 0) : 1 ≤ (supp f).card := by
  exact Finset.card_pos.mpr ( by obtain ⟨ x, hx ⟩ := Function.ne_iff.mp hf; exact ⟨ x, Finset.mem_filter.mpr ⟨ Finset.mem_univ _, hx ⟩ ⟩ )

/-
The standard additive character has unit modulus.
-/
theorem norm_stdAddChar (j : ZMod N) : ‖stdAddChar j‖ = 1 := by
  convert Circle.norm_coe _

/-
Pointwise bound: each Fourier coefficient is bounded by the `l1` norm.
-/
theorem dft_apply_norm_le (f : ZMod N → ℂ) (k : ZMod N) :
    ‖ZMod.dft f k‖ ≤ ∑ j : ZMod N, ‖f j‖ := by
  convert norm_sum_le _ _ using 2 ; norm_num [ norm_smul ]

/-
Character orthogonality: `∑_k χ(t k) = N` if `t = 0`, else `0`.
-/
theorem char_orthogonality (t : ZMod N) :
    ∑ k : ZMod N, stdAddChar (t * k) = if t = 0 then (N : ℂ) else 0 := by
  -- Split on whether `t = 0`.
  by_cases ht : t = 0;
  · aesop;
  · convert AddChar.sum_eq_zero_of_ne_one ( ZMod.isPrimitive_stdAddChar N ht ) using 1;
    aesop

/-
Plancherel identity for the counting-measure DFT.
-/
theorem plancherel (f : ZMod N → ℂ) :
    ∑ k : ZMod N, ‖ZMod.dft f k‖ ^ 2 = (N : ℝ) * ∑ j : ZMod N, ‖f j‖ ^ 2 := by
  have h_fourier_transform : ∑ k : ZMod N, (𝓕 f k) * (starRingEnd ℂ (𝓕 f k)) = ∑ j : ZMod N, ∑ l : ZMod N, f j * (starRingEnd ℂ (f l)) * ∑ k : ZMod N, (stdAddChar (-(j * k))) * (stdAddChar (l * k)) := by
    have h_fourier_transform : ∀ k : ZMod N, (𝓕 f k) * (starRingEnd ℂ (𝓕 f k)) = ∑ j : ZMod N, ∑ l : ZMod N, f j * (starRingEnd ℂ (f l)) * (stdAddChar (-(j * k))) * (stdAddChar (l * k)) := by
      intro k
      have h_sum_k : (𝓕 f k) * (starRingEnd ℂ (𝓕 f k)) = (∑ j : ZMod N, f j * (stdAddChar (-(j * k)))) * (∑ l : ZMod N, starRingEnd ℂ (f l) * (stdAddChar (l * k))) := by
        simp +decide [ ZMod.dft_apply, mul_comm ];
        simp +decide [ stdAddChar, AddChar.map_neg_eq_conj ];
      exact h_sum_k.trans ( by rw [ Finset.sum_mul ] ; exact Finset.sum_congr rfl fun _ _ => by rw [ Finset.mul_sum ] ; exact Finset.sum_congr rfl fun _ _ => by ring );
    simp +decide only [h_fourier_transform, mul_assoc, Finset.mul_sum _ _ _];
    exact Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_comm );
  -- By the orthogonality of characters, we know that $\sum_{k=0}^{N-1} \chi(-(j-k)k) = N$ if $j = l$, and $0$ otherwise.
  have h_orthogonality : ∀ j l : ZMod N, ∑ k : ZMod N, (stdAddChar (-(j * k))) * (stdAddChar (l * k)) = if j = l then (N : ℂ) else 0 := by
    intro j l; split_ifs with h; simp_all +decide [ ← AddChar.map_add_eq_mul ] ;
    convert char_orthogonality ( l - j ) using 1 ; simp +decide [ sub_mul ];
    · exact Finset.sum_congr rfl fun _ _ => by rw [ ← AddChar.map_add_eq_mul ] ; congr 1 ; ring;
    · rw [ if_neg ( sub_ne_zero_of_ne <| Ne.symm h ) ];
  convert congr_arg Complex.re h_fourier_transform using 1;
  · norm_num [ Complex.mul_conj, Complex.normSq_eq_norm_sq ];
    norm_cast;
  · simp_all +decide [ Complex.normSq, Complex.sq_norm ];
    rw [ mul_comm, Finset.sum_mul ]

/-
Cauchy--Schwarz on the support: `‖f‖_1^2 ≤ k * ‖f‖_2^2`.
-/
theorem l1_sq_le (f : ZMod N → ℂ) :
    (∑ j : ZMod N, ‖f j‖) ^ 2
      ≤ ((supp f).card : ℝ) * ∑ j : ZMod N, ‖f j‖ ^ 2 := by
  -- Apply the Cauchy-Schwarz inequality to the sum of $\|f(j)\|$ over the support of $f$.
  have h_cauchy_schwarz : (∑ j ∈ supp f, ‖f j‖) ^ 2 ≤ (∑ j ∈ supp f, 1 ^ 2) * (∑ j ∈ supp f, ‖f j‖ ^ 2) := by
    convert ( Finset.sum_mul_sq_le_sq_mul_sq _ _ _ ) using 1 ; aesop; all_goals infer_instance;
  simp_all +decide;
  convert h_cauchy_schwarz using 2 <;> rw [ ← Finset.sum_subset ( Finset.subset_univ <| supp f ) ] <;> simp +decide [ supp ]

/-
`‖𝓕 f‖_2^2 ≤ m * ‖f‖_1^2`.
-/
theorem dft_l2_le (f : ZMod N → ℂ) :
    ∑ k : ZMod N, ‖ZMod.dft f k‖ ^ 2
      ≤ ((supp (ZMod.dft f)).card : ℝ) * (∑ j : ZMod N, ‖f j‖) ^ 2 := by
  -- Apply the Cauchy-Schwarz inequality to the Fourier transform.
  have h_cauchy_schwarz : ∀ k : ZMod N, ‖𝓕 f k‖ ^ 2 ≤ (∑ j : ZMod N, ‖f j‖) ^ 2 := by
    exact fun k => pow_le_pow_left₀ ( norm_nonneg _ ) ( dft_apply_norm_le f k ) _;
  refine' le_trans ( Finset.sum_le_sum fun k _ => show ‖𝓕 f k‖ ^ 2 ≤ if k ∈ supp ( 𝓕 f ) then ( ∑ j, ‖f j‖ ) ^ 2 else 0 from _ ) _;
  · split_ifs with hk
    · exact h_cauchy_schwarz k
    · have hz : 𝓕 f k = 0 := by simpa [mem_supp] using hk
      simp [hz]
  · simp +decide

/-
The `l2` norm squared is positive for a nonzero function.
-/
theorem l2sq_pos {f : ZMod N → ℂ} (hf : f ≠ 0) :
    0 < ∑ j : ZMod N, ‖f j‖ ^ 2 := by
  obtain ⟨ j, hj ⟩ := Function.ne_iff.mp hf; exact lt_of_lt_of_le ( by aesop ) ( Finset.single_le_sum ( fun x _ => sq_nonneg ( ‖f x‖ ) ) ( Finset.mem_univ j ) ) ;

/-- **Donoho--Stark support uncertainty on `ZMod N`.**
A nonzero function on `ZMod N` and its discrete Fourier transform cannot both be
sharply localized: the product of their support sizes is at least `N`.

This is the general-`N` successor to `LambdaConjugacy.support_uncertainty`
(which handles only `N = 4`). -/
theorem support_uncertainty (f : ZMod N → ℂ) (hf : f ≠ 0) :
    (N : ℕ) ≤ (supp f).card * (supp (ZMod.dft f)).card := by
  have hplan := plancherel f
  have hdft := dft_l2_le f
  have hcs := l1_sq_le f
  have hpos := l2sq_pos hf
  have hmnn : (0 : ℝ) ≤ ((supp (ZMod.dft f)).card : ℝ) := by positivity
  have hchain : (N : ℝ) * (∑ j : ZMod N, ‖f j‖ ^ 2)
      ≤ (((supp f).card : ℝ) * ((supp (ZMod.dft f)).card : ℝ))
        * (∑ j : ZMod N, ‖f j‖ ^ 2) := by
    calc (N : ℝ) * (∑ j : ZMod N, ‖f j‖ ^ 2)
        = ∑ k : ZMod N, ‖ZMod.dft f k‖ ^ 2 := hplan.symm
      _ ≤ ((supp (ZMod.dft f)).card : ℝ) * (∑ j : ZMod N, ‖f j‖) ^ 2 := hdft
      _ ≤ ((supp (ZMod.dft f)).card : ℝ)
            * (((supp f).card : ℝ) * ∑ j : ZMod N, ‖f j‖ ^ 2) :=
            mul_le_mul_of_nonneg_left hcs hmnn
      _ = (((supp f).card : ℝ) * ((supp (ZMod.dft f)).card : ℝ))
            * (∑ j : ZMod N, ‖f j‖ ^ 2) := by ring
  have hNle : (N : ℝ) ≤ ((supp f).card : ℝ) * ((supp (ZMod.dft f)).card : ℝ) :=
    le_of_mul_le_mul_right hchain hpos
  have : (N : ℝ) ≤ (((supp f).card * (supp (ZMod.dft f)).card : ℕ) : ℝ) := by
    push_cast; exact hNle
  exact_mod_cast this

/-! ## Non-vacuity: the sharp "volume" register saturates the bound. -/

/-- The delta register at `a`. -/
noncomputable def delta (a : ZMod N) : ZMod N → ℂ := fun j => if j = a then 1 else 0

/-
A delta register is nonzero.
-/
example (a : ZMod N) : delta a ≠ 0 := by
  exact fun h => by simpa [ delta ] using congr_fun h a;

/-
Saturation: the delta register realizes the bound with product exactly `N`.
-/
example (a : ZMod N) :
    (supp (delta a)).card * (supp (ZMod.dft (delta a))).card = N := by
  -- First, show that the support of `delta a` is `{a}`.
  have h_supp_delta : supp (delta a) = {a} := by
    ext j; simp [supp, delta]
  have h_card_supp_delta : (supp (delta a)).card = 1 := by
    aesop
  simp_all +decide [ supp ];
  -- Next, compute ZMod.dft (delta a) k. Using `ZMod.dft_apply`, it is `∑ j, stdAddChar (-(j*k)) • delta a j`.
  have h_dft_delta : ∀ k : ZMod N, 𝓕 (delta a) k = stdAddChar (-(a * k)) := by
    simp +decide [ ZMod.dft_apply, delta ];
  simp_all +decide [ Finset.ext_iff, stdAddChar ]

end LambdaUncertaintyGeneralN
