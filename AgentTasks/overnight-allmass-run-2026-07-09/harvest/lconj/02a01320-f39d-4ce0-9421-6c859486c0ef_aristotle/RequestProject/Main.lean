import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Lambda conjugate to the count, natively: a finite Fourier uncertainty theorem

We make "Lambda is conjugate to the volume/count" native finite information theory.  The
"volume register" is a function `f : ZMod 4 → ℂ`; the "Lambda register" is its discrete
Fourier transform `dft f`, taken over `ZMod 4` with primitive root of unity `ω = Complex.I`
(so every value lives in the Gaussian integers `ℤ[i]`; no transcendental analysis).

Main results (namespace `LambdaConjugacy`):

* `delta_maps_to_uniform` — a sharp-count state `delta N0` maps to a function of constant
  modulus `1` (uniform over the Lambda register).  [general over `ZMod 4`]
* `uniform_maps_to_delta` — the uniform state maps to a delta at `0` (value `4`).  [general]
* `support_uncertainty` — Donoho–Stark for `n = 4`: for nonzero `f`,
  `4 ≤ |supp f| * |supp (dft f)|`.  [full theorem for `n = 4`]
* `conjugacy_verdict` — the package.

The identification of the conjugate variable with the physical cosmological constant stays
imported/`[C]`; the conjugacy and uncertainty statements here are fully machine-checked `M`.
-/

namespace LambdaConjugacy

open Complex Finset

/-- The primitive 4th root of unity as a character on `ZMod 4`: `w m = i ^ m.val`. -/
noncomputable def w (m : ZMod 4) : ℂ := Complex.I ^ m.val

/-- Discrete Fourier transform over `ZMod 4` with `ω = i`. -/
noncomputable def dft (f : ZMod 4 → ℂ) (k : ZMod 4) : ℂ := ∑ j : ZMod 4, f j * w (j * k)

/-- Inverse discrete Fourier transform. -/
noncomputable def idft (g : ZMod 4 → ℂ) (j : ZMod 4) : ℂ :=
  (4 : ℂ)⁻¹ * ∑ k : ZMod 4, g k * w (-(j * k))

/-- Sharp-count ("volume") state supported at a single value `N0`. -/
noncomputable def delta (N0 : ZMod 4) : ZMod 4 → ℂ := fun j => if j = N0 then 1 else 0

/-- Uniform state, constant `1`. -/
noncomputable def uniform : ZMod 4 → ℂ := fun _ => 1

/-- Support of a state as a `Finset` of `ZMod 4`. -/
noncomputable def supp (f : ZMod 4 → ℂ) : Finset (ZMod 4) :=
  Finset.univ.filter (fun j => f j ≠ 0)

/-! ## Character lemmas for `w` -/

lemma w0 : w 0 = 1 := by simp [w]
lemma w1 : w 1 = Complex.I := by simp [w, show (1 : ZMod 4).val = 1 from rfl]
lemma w2 : w 2 = -1 := by
  rw [w, show (2 : ZMod 4).val = 2 from rfl, pow_two, Complex.I_mul_I]
lemma w3 : w 3 = -Complex.I := by
  rw [w, show (3 : ZMod 4).val = 3 from rfl, show (3 : ℕ) = 2 + 1 from rfl, pow_succ,
    pow_two, Complex.I_mul_I]; ring

lemma I_pow_mod4 (k : ℕ) : Complex.I ^ (k % 4) = Complex.I ^ k := by
  conv_rhs => rw [← Nat.div_add_mod k 4, pow_add, pow_mul, Complex.I_pow_four, one_pow, one_mul]

lemma w_add (a b : ZMod 4) : w (a + b) = w a * w b := by
  simp only [w, ZMod.val_add, I_pow_mod4, ← pow_add]

lemma w_zero : w 0 = 1 := w0

lemma w_ne (m : ZMod 4) : w m ≠ 0 := by
  simp only [w]; exact pow_ne_zero _ Complex.I_ne_zero

lemma normSq_w (m : ZMod 4) : Complex.normSq (w m) = 1 := by
  simp only [w, map_pow, Complex.normSq_I, one_pow]

/-- Enumeration of `ZMod 4`. -/
lemma zmod4_cases : ∀ m : ZMod 4, m = 0 ∨ m = 1 ∨ m = 2 ∨ m = 3 := by decide

/-- Sum over `ZMod 4` expands into four terms. -/
lemma sum_zmod4 (g : ZMod 4 → ℂ) : ∑ x : ZMod 4, g x = g 0 + g 1 + g 2 + g 3 := by
  rw [show (Finset.univ : Finset (ZMod 4)) = {0, 1, 2, 3} from by decide,
    Finset.sum_insert (by decide), Finset.sum_insert (by decide),
    Finset.sum_insert (by decide), Finset.sum_singleton]; ring

/-- Orthogonality of the characters. -/
lemma orth (m : ZMod 4) : ∑ k : ZMod 4, w (m * k) = (if m = 0 then 4 else 0) := by
  rw [sum_zmod4]
  rcases zmod4_cases m with h | h | h | h <;> subst h
  · rw [if_pos rfl, show (0 : ZMod 4) * 0 = 0 from by decide,
      show (0 : ZMod 4) * 1 = 0 from by decide, show (0 : ZMod 4) * 2 = 0 from by decide,
      show (0 : ZMod 4) * 3 = 0 from by decide, w0]; ring
  · rw [if_neg (by decide), show (1 : ZMod 4) * 0 = 0 from by decide,
      show (1 : ZMod 4) * 1 = 1 from by decide, show (1 : ZMod 4) * 2 = 2 from by decide,
      show (1 : ZMod 4) * 3 = 3 from by decide, w0, w1, w2, w3]; ring
  · rw [if_neg (by decide), show (2 : ZMod 4) * 0 = 0 from by decide,
      show (2 : ZMod 4) * 1 = 2 from by decide, show (2 : ZMod 4) * 2 = 0 from by decide,
      show (2 : ZMod 4) * 3 = 2 from by decide, w0, w2]; ring
  · rw [if_neg (by decide), show (3 : ZMod 4) * 0 = 0 from by decide,
      show (3 : ZMod 4) * 1 = 3 from by decide, show (3 : ZMod 4) * 2 = 2 from by decide,
      show (3 : ZMod 4) * 3 = 1 from by decide, w0, w1, w2, w3]; ring

/-! ## Fourier inversion -/

lemma idft_dft (f : ZMod 4 → ℂ) (j : ZMod 4) : idft (dft f) j = f j := by
  simp only [idft, dft, Finset.sum_mul]
  rw [Finset.sum_comm]
  have key : ∀ l : ZMod 4, ∑ k : ZMod 4, f l * w (l * k) * w (-(j * k))
      = f l * (if l - j = 0 then 4 else 0) := by
    intro l
    rw [← orth (l - j), Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro k _
    rw [show (l - j) * k = l * k + (-(j * k)) by ring, w_add]; ring
  rw [Finset.sum_congr rfl (fun l _ => key l)]
  simp only [sub_eq_zero, mul_ite, mul_zero]
  rw [Finset.sum_ite_eq' Finset.univ j (fun l => f l * 4)]
  simp only [Finset.mem_univ, if_true]
  field_simp

lemma idft_zero (j : ZMod 4) : idft (0 : ZMod 4 → ℂ) j = 0 := by
  simp [idft]

/-- The DFT is injective on nonzero states: if `f ≠ 0` then `dft f ≠ 0`. -/
lemma dft_ne_zero {f : ZMod 4 → ℂ} (hf : f ≠ 0) : dft f ≠ 0 := by
  intro h
  apply hf
  funext j
  show f j = 0
  rw [← idft_dft f j, h, idft_zero]

/-! ## Target 1 & 2: the conjugacy and its dual -/

lemma dft_delta (N0 k : ZMod 4) : dft (delta N0) k = w (N0 * k) := by
  simp only [dft, delta]
  rw [Finset.sum_eq_single N0]
  · simp
  · intro b _ hb; simp [hb]
  · simp

/-- **Target 1 (the conjugacy).**  A sharp-count state `delta N0` maps under the DFT to a
function of *constant modulus* `1` — sharp volume forces a maximally unsharp Lambda register. -/
theorem delta_maps_to_uniform (N0 k : ZMod 4) : Complex.normSq (dft (delta N0) k) = 1 := by
  rw [dft_delta, normSq_w]

/-- **Target 2 (dual).**  The uniform state maps to a delta at `0` (value `4`) — sharp Lambda
forces a maximally unsharp count. -/
theorem uniform_maps_to_delta (k : ZMod 4) : dft uniform k = if k = 0 then 4 else 0 := by
  simp only [dft, uniform, one_mul]
  rw [show (∑ j : ZMod 4, w (j * k)) = ∑ j : ZMod 4, w (k * j) from by
    apply Finset.sum_congr rfl; intro j _; rw [mul_comm]]
  exact orth k

/-! ## Target 3: Donoho–Stark support uncertainty for `n = 4` -/

lemma mem_supp {f : ZMod 4 → ℂ} {j : ZMod 4} : j ∈ supp f ↔ f j ≠ 0 := by
  simp [supp]

lemma card_supp_pos {f : ZMod 4 → ℂ} (hf : f ≠ 0) : 1 ≤ (supp f).card := by
  obtain ⟨j, hj⟩ : ∃ j, f j ≠ 0 := by
    by_contra h
    push_neg at h
    exact hf (funext h)
  exact Finset.card_pos.mpr ⟨j, mem_supp.mpr hj⟩

lemma card_supp_le (f : ZMod 4 → ℂ) : (supp f).card ≤ 4 := by
  calc (supp f).card ≤ (Finset.univ : Finset (ZMod 4)).card := Finset.card_le_univ _
    _ = 4 := by decide

/-- **Fact A.**  If `f` has support of size exactly one, its DFT has full support (size `4`). -/
lemma supp_dft_card_of_supp_card_one {f : ZMod 4 → ℂ} (h : (supp f).card = 1) :
    (supp (dft f)).card = 4 := by
  obtain ⟨N0, hN0⟩ := Finset.card_eq_one.mp h
  have hfN0 : f N0 ≠ 0 := by
    have : N0 ∈ supp f := by rw [hN0]; exact Finset.mem_singleton_self N0
    exact mem_supp.mp this
  have hzero : ∀ j, j ≠ N0 → f j = 0 := by
    intro j hj
    by_contra hfj
    have : j ∈ supp f := mem_supp.mpr hfj
    rw [hN0, Finset.mem_singleton] at this
    exact hj this
  have hval : ∀ k, dft f k = f N0 * w (N0 * k) := by
    intro k
    simp only [dft]
    rw [Finset.sum_eq_single_of_mem N0 (Finset.mem_univ N0)
      (fun b _ hb => by rw [hzero b hb, zero_mul])]
  have hall : supp (dft f) = Finset.univ := by
    apply Finset.eq_univ_of_forall
    intro k
    rw [mem_supp, hval k]
    exact mul_ne_zero hfN0 (w_ne _)
  rw [hall]; decide

/-- **Fact B.**  If the DFT has support of size exactly one, `f` has full support (size `4`). -/
lemma supp_card_of_supp_dft_card_one {f : ZMod 4 → ℂ} (h : (supp (dft f)).card = 1) :
    (supp f).card = 4 := by
  obtain ⟨k0, hk0⟩ := Finset.card_eq_one.mp h
  have hgk0 : dft f k0 ≠ 0 := by
    have : k0 ∈ supp (dft f) := by rw [hk0]; exact Finset.mem_singleton_self k0
    exact mem_supp.mp this
  have hzero : ∀ k, k ≠ k0 → dft f k = 0 := by
    intro k hk
    by_contra hgk
    have : k ∈ supp (dft f) := mem_supp.mpr hgk
    rw [hk0, Finset.mem_singleton] at this
    exact hk this
  have hval : ∀ j, f j = (4 : ℂ)⁻¹ * (dft f k0 * w (-(j * k0))) := by
    intro j
    rw [← idft_dft f j]
    simp only [idft]
    congr 1
    rw [Finset.sum_eq_single_of_mem k0 (Finset.mem_univ k0)
      (fun b _ hb => by rw [hzero b hb, zero_mul])]
  have hall : supp f = Finset.univ := by
    apply Finset.eq_univ_of_forall
    intro j
    rw [mem_supp, hval j]
    apply mul_ne_zero
    · simp
    · exact mul_ne_zero hgk0 (w_ne _)
  rw [hall]; decide

/-- **Target 3 (payload — Donoho–Stark for `n = 4`).**  For any nonzero state `f`, the product
of the count-register support size and the Lambda-register support size is at least `n = 4`. -/
theorem support_uncertainty (f : ZMod 4 → ℂ) (hf : f ≠ 0) :
    4 ≤ (supp f).card * (supp (dft f)).card := by
  have ha1 : 1 ≤ (supp f).card := card_supp_pos hf
  have haU : (supp f).card ≤ 4 := card_supp_le f
  have hb1 : 1 ≤ (supp (dft f)).card := card_supp_pos (dft_ne_zero hf)
  have hbU : (supp (dft f)).card ≤ 4 := card_supp_le (dft f)
  by_cases hA : (supp f).card = 1
  · rw [hA, supp_dft_card_of_supp_card_one hA]
  · have ha2 : 2 ≤ (supp f).card := by omega
    by_cases hB : (supp (dft f)).card = 1
    · rw [supp_card_of_supp_dft_card_one hB, hB]
    · have hb2 : 2 ≤ (supp (dft f)).card := by omega
      calc 4 = 2 * 2 := by norm_num
        _ ≤ (supp f).card * (supp (dft f)).card := Nat.mul_le_mul ha2 hb2

/-! ## Non-degeneracy: explicit witnesses on `ZMod 4` (all values in `ℤ[i]`) -/

/-- Entrywise DFT of the sharp-count state `delta 1`: the four Gaussian values `1, i, -1, -i`,
all of modulus `1`. -/
theorem delta_one_dft_entries :
    dft (delta 1) 0 = 1 ∧ dft (delta 1) 1 = Complex.I ∧
    dft (delta 1) 2 = -1 ∧ dft (delta 1) 3 = -Complex.I := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [dft_delta, show (1 : ZMod 4) * 0 = 0 from by decide, w0]
  · rw [dft_delta, show (1 : ZMod 4) * 1 = 1 from by decide, w1]
  · rw [dft_delta, show (1 : ZMod 4) * 2 = 2 from by decide, w2]
  · rw [dft_delta, show (1 : ZMod 4) * 3 = 3 from by decide, w3]

/-- Entrywise DFT of the uniform state: `(4, 0, 0, 0)`. -/
theorem uniform_dft_entries :
    dft uniform 0 = 4 ∧ dft uniform 1 = 0 ∧ dft uniform 2 = 0 ∧ dft uniform 3 = 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [uniform_maps_to_delta, if_pos rfl]
  · rw [uniform_maps_to_delta, if_neg (by decide)]
  · rw [uniform_maps_to_delta, if_neg (by decide)]
  · rw [uniform_maps_to_delta, if_neg (by decide)]

/-- The extremal states saturate Donoho–Stark:
`|supp (delta 1)| * |supp (dft (delta 1))| = 1 * 4 = 4`. -/
theorem delta_saturates : (supp (delta 1)).card * (supp (dft (delta 1))).card = 4 := by
  have h1 : supp (delta 1) = {1} := by
    apply Finset.ext; intro j
    simp only [mem_supp, Finset.mem_singleton, delta]
    rcases zmod4_cases j with h | h | h | h <;> subst h <;> simp
  have hc1 : (supp (delta 1)).card = 1 := by rw [h1, Finset.card_singleton]
  rw [hc1, supp_dft_card_of_supp_card_one hc1]

/-- A middle witness of support size `2`: `mid j = 1` for `j ∈ {0,1}`, else `0`. -/
noncomputable def mid : ZMod 4 → ℂ := fun j => if j = 0 then 1 else if j = 1 then 1 else 0

lemma mid0 : mid 0 = 1 := by simp [mid]
lemma mid1 : mid 1 = 1 := by simp [mid]
lemma mid2 : mid 2 = 0 := by simp only [mid]; rw [if_neg (by decide), if_neg (by decide)]
lemma mid3 : mid 3 = 0 := by simp only [mid]; rw [if_neg (by decide), if_neg (by decide)]

/-- Entrywise DFT of the middle witness: `(2, 1+i, 0, 1-i)`, all in `ℤ[i]`. -/
theorem mid_dft_entries :
    dft mid 0 = 2 ∧ dft mid 1 = 1 + Complex.I ∧ dft mid 2 = 0 ∧
    dft mid 3 = 1 - Complex.I := by
  have hmid : ∀ k, dft mid k = w (0 * k) + w (1 * k) := by
    intro k
    simp only [dft]
    rw [sum_zmod4, mid0, mid1, mid2, mid3]; ring
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [hmid, show (0 : ZMod 4) * 0 = 0 from by decide, show (1 : ZMod 4) * 0 = 0 from by decide,
      w0]; norm_num
  · rw [hmid, show (0 : ZMod 4) * 1 = 0 from by decide, show (1 : ZMod 4) * 1 = 1 from by decide,
      w0, w1]
  · rw [hmid, show (0 : ZMod 4) * 2 = 0 from by decide, show (1 : ZMod 4) * 2 = 2 from by decide,
      w0, w2]; norm_num
  · rw [hmid, show (0 : ZMod 4) * 3 = 0 from by decide, show (1 : ZMod 4) * 3 = 3 from by decide,
      w0, w3]; ring

/-- The middle witness satisfies Donoho–Stark concretely: support sizes `2` and `3`,
product `6 ≥ 4`. -/
theorem mid_uncertainty :
    (supp mid).card = 2 ∧ (supp (dft mid)).card = 3 ∧
    4 ≤ (supp mid).card * (supp (dft mid)).card := by
  have hsupp : supp mid = {0, 1} := by
    apply Finset.ext; intro j
    rw [mem_supp]
    rcases zmod4_cases j with h | h | h | h <;> subst h
    · rw [mid0]; simp
    · rw [mid1]; simp
    · rw [mid2]; simp; decide
    · rw [mid3]; simp; decide
  have hc : (supp mid).card = 2 := by rw [hsupp]; decide
  obtain ⟨e0, e1, e2, e3⟩ := mid_dft_entries
  have hsuppd : supp (dft mid) = {0, 1, 3} := by
    apply Finset.ext; intro k
    rw [mem_supp]
    rcases zmod4_cases k with h | h | h | h <;> subst h
    · rw [e0]; simp
    · rw [e1]; simp [Complex.ext_iff]
    · rw [e2]; simp; decide
    · rw [e3]; simp [Complex.ext_iff]
  have hcd : (supp (dft mid)).card = 3 := by rw [hsuppd]; decide
  refine ⟨hc, hcd, ?_⟩
  rw [hc, hcd]; norm_num

/-! ## Target 4: the verdict -/

/-- **Target 4 (verdict).**  The count register and the Lambda register form a finite
Fourier-conjugate pair on `ZMod 4`:

* (conjugacy) the sharp-count state maps to a constant-modulus Lambda state;
* (dual) the uniform state maps to a delta;
* (Donoho–Stark) sharpness of the two registers trades off exactly: the support-size product
  is always at least `n = 4`.

Hence "Lambda is the phase conjugate of the null-edge count" is native finite mathematics.
The everpresent reading — a universe with a large, nearly-sharp count retains conjugate-phase
noise with RMS `~ 1/√count` — has this finite backbone; the *identification* of the conjugate
variable with the physical cosmological constant remains imported (`[C]`). -/
theorem conjugacy_verdict :
    (∀ N0 k : ZMod 4, Complex.normSq (dft (delta N0) k) = 1) ∧
    (∀ k : ZMod 4, dft uniform k = if k = 0 then 4 else 0) ∧
    (∀ f : ZMod 4 → ℂ, f ≠ 0 → 4 ≤ (supp f).card * (supp (dft f)).card) :=
  ⟨delta_maps_to_uniform, uniform_maps_to_delta, support_uncertainty⟩

/-! ## Axiom footprint of the headline results (kernel-checked, no `sorry`/`native_decide`) -/

/-- info: 'LambdaConjugacy.delta_maps_to_uniform' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms delta_maps_to_uniform

/-- info: 'LambdaConjugacy.uniform_maps_to_delta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms uniform_maps_to_delta

/-- info: 'LambdaConjugacy.support_uncertainty' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms support_uncertainty

/-- info: 'LambdaConjugacy.conjugacy_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms conjugacy_verdict

/-- info: 'LambdaConjugacy.delta_saturates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms delta_saturates

/-- info: 'LambdaConjugacy.mid_uncertainty' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms mid_uncertainty

end LambdaConjugacy
