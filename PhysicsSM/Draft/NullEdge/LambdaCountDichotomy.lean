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
# The λ-count dichotomy: do constraints make the edge count sub-Poissonian?

Finite, explicit rational-probability witnesses for the fork:

* **FREE** model: `n` independent edges, occupancy `p`. `Var(N) = n p (1-p)` — *extensive*.
* **CONSTRAINED** model: a Gauss-type sum constraint (uniform `k`-of-`n`) gives `Var(N) = 0`
  for every `n`; a soft two-value mixture gives `Var(N) = w(1-w)`, an `n`-independent constant.

Both constrained cases are *sub-extensive*: `Var(N)/n → 0`.

The `dichotomy_criterion` packages the pre-registered kill: free ⇒ extensive ⇒ everpresent
(`Λ² > 0`); hard-constrained ⇒ `Var = 0` ⇒ `Λ² = 0`, suppressing the everpresent
identification entirely. `which_count_matters` shows the resolution depends on *which* count
`Λ` is conjugate to: a two-register model whose Gauss constraint fixes total *charge*
(charge variance `0`) while the bare *edge* count stays free (variance `n p(1-p)`).

These are finite witnesses establishing the FORK and its criterion, not a computation of the
physical ensemble's statistics (that is the follow-up oracle probe).
-/

namespace LambdaCountDichotomy

/-! ## Expectation and variance over a finite rational probability space -/

/-- Expectation of `f` under weights `w` on a finite space. -/
def E {Ω : Type*} [Fintype Ω] (w : Ω → ℚ) (f : Ω → ℚ) : ℚ := ∑ x, w x * f x

/-- Variance of `f` under weights `w`: `E[f²] - (E[f])²`. -/
def Var {Ω : Type*} [Fintype Ω] (w : Ω → ℚ) (f : Ω → ℚ) : ℚ :=
  E w (fun x => f x ^ 2) - (E w f) ^ 2

/-! ## Generic building blocks: linearity and independence -/

section Prod
variable {Ω₁ Ω₂ : Type*} [Fintype Ω₁] [Fintype Ω₂]

/-- Cross expectation factorizes over a product distribution (independence). -/
lemma E_prod_cross (w₁ : Ω₁ → ℚ) (w₂ : Ω₂ → ℚ) (f₁ : Ω₁ → ℚ) (f₂ : Ω₂ → ℚ) :
    E (fun x : Ω₁ × Ω₂ => w₁ x.1 * w₂ x.2) (fun x => f₁ x.1 * f₂ x.2)
      = (E w₁ f₁) * (E w₂ f₂) := by
  unfold E; rw [Fintype.sum_prod_type, Finset.sum_mul_sum]
  exact Finset.sum_congr rfl fun a _ => Finset.sum_congr rfl fun b _ => by ring

/-- Expectation of a first-coordinate function under a product distribution, `w₂` normalized. -/
lemma E_prod_fst (w₁ : Ω₁ → ℚ) (w₂ : Ω₂ → ℚ) (f₁ : Ω₁ → ℚ) (hw₂ : ∑ b, w₂ b = 1) :
    E (fun x : Ω₁ × Ω₂ => w₁ x.1 * w₂ x.2) (fun x => f₁ x.1) = E w₁ f₁ := by
  have h := E_prod_cross w₁ w₂ f₁ (fun _ => 1)
  simp only [mul_one] at h
  rw [h]
  have h2 : E w₂ (fun _ => 1) = 1 := by unfold E; simpa using hw₂
  rw [h2, mul_one]

/-- Expectation of a second-coordinate function under a product distribution, `w₁` normalized. -/
lemma E_prod_snd (w₁ : Ω₁ → ℚ) (w₂ : Ω₂ → ℚ) (f₂ : Ω₂ → ℚ) (hw₁ : ∑ a, w₁ a = 1) :
    E (fun x : Ω₁ × Ω₂ => w₁ x.1 * w₂ x.2) (fun x => f₂ x.2) = E w₂ f₂ := by
  have h := E_prod_cross w₁ w₂ (fun _ => 1) f₂
  simp only [one_mul] at h
  rw [h]
  have h1 : E w₁ (fun _ => 1) = 1 := by unfold E; simpa using hw₁
  rw [h1, one_mul]

/-- Expectation is additive in the random variable (same weight). -/
lemma E_add_same (w : Ω₁ → ℚ) (f g : Ω₁ → ℚ) : E w (fun x => f x + g x) = E w f + E w g := by
  unfold E; rw [← Finset.sum_add_distrib]; exact Finset.sum_congr rfl fun x _ => by ring

/-- Expectation is homogeneous in the random variable. -/
lemma E_smul (w : Ω₁ → ℚ) (c : ℚ) (f : Ω₁ → ℚ) : E w (fun x => c * f x) = c * E w f := by
  unfold E; rw [Finset.mul_sum]; exact Finset.sum_congr rfl fun x _ => by ring

/-- Expectation of a sum of coordinatewise functions adds (both weights normalized). -/
lemma E_add (w₁ : Ω₁ → ℚ) (w₂ : Ω₂ → ℚ) (f₁ : Ω₁ → ℚ) (f₂ : Ω₂ → ℚ)
    (hw₁ : ∑ a, w₁ a = 1) (hw₂ : ∑ b, w₂ b = 1) :
    E (fun x : Ω₁ × Ω₂ => w₁ x.1 * w₂ x.2) (fun x => f₁ x.1 + f₂ x.2)
      = E w₁ f₁ + E w₂ f₂ := by
  unfold E
  rw [Fintype.sum_prod_type]
  have expand : ∀ a, ∑ b, w₁ a * w₂ b * (f₁ a + f₂ b)
      = w₁ a * f₁ a * (∑ b, w₂ b) + w₁ a * (∑ b, w₂ b * f₂ b) := by
    intro a
    rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun b _ => by ring
  simp_rw [expand, hw₂, mul_one]
  rw [Finset.sum_add_distrib, ← Finset.sum_mul, hw₁, one_mul]

/-- Variance of a first-coordinate function equals the marginal variance (`w₂` normalized). -/
lemma Var_prod_fst (w₁ : Ω₁ → ℚ) (w₂ : Ω₂ → ℚ) (f₁ : Ω₁ → ℚ) (hw₂ : ∑ b, w₂ b = 1) :
    Var (fun x : Ω₁ × Ω₂ => w₁ x.1 * w₂ x.2) (fun x => f₁ x.1) = Var w₁ f₁ := by
  unfold Var
  rw [E_prod_fst w₁ w₂ (fun y => (f₁ y) ^ 2) hw₂, E_prod_fst w₁ w₂ f₁ hw₂]

/-- Variance of a second-coordinate function equals the marginal variance (`w₁` normalized). -/
lemma Var_prod_snd (w₁ : Ω₁ → ℚ) (w₂ : Ω₂ → ℚ) (f₂ : Ω₂ → ℚ) (hw₁ : ∑ a, w₁ a = 1) :
    Var (fun x : Ω₁ × Ω₂ => w₁ x.1 * w₂ x.2) (fun x => f₂ x.2) = Var w₂ f₂ := by
  unfold Var
  rw [E_prod_snd w₁ w₂ (fun y => (f₂ y) ^ 2) hw₁, E_prod_snd w₁ w₂ f₂ hw₁]

/-- Variance of a sum of independent coordinatewise functions adds. -/
lemma Var_add (w₁ : Ω₁ → ℚ) (w₂ : Ω₂ → ℚ) (f₁ : Ω₁ → ℚ) (f₂ : Ω₂ → ℚ)
    (hw₁ : ∑ a, w₁ a = 1) (hw₂ : ∑ b, w₂ b = 1) :
    Var (fun x : Ω₁ × Ω₂ => w₁ x.1 * w₂ x.2) (fun x => f₁ x.1 + f₂ x.2)
      = Var w₁ f₁ + Var w₂ f₂ := by
  have hsq : E (fun x : Ω₁ × Ω₂ => w₁ x.1 * w₂ x.2) (fun x => (f₁ x.1 + f₂ x.2) ^ 2)
      = E w₁ (fun y => (f₁ y) ^ 2) + 2 * (E w₁ f₁) * (E w₂ f₂) + E w₂ (fun y => (f₂ y) ^ 2) := by
    have expand : (fun x : Ω₁ × Ω₂ => (f₁ x.1 + f₂ x.2) ^ 2)
        = (fun x => (f₁ x.1) ^ 2 + (2 * (f₁ x.1 * f₂ x.2) + (f₂ x.2) ^ 2)) := by
      funext x; ring
    rw [expand, E_add_same, E_add_same]
    rw [E_prod_fst w₁ w₂ (fun y => (f₁ y) ^ 2) hw₂]
    rw [E_prod_snd w₁ w₂ (fun y => (f₂ y) ^ 2) hw₁]
    rw [show (fun x : Ω₁ × Ω₂ => 2 * (f₁ x.1 * f₂ x.2))
          = (fun x => 2 * ((fun z => f₁ z.1 * f₂ z.2) x)) from rfl]
    rw [E_smul, E_prod_cross]; ring
  unfold Var
  rw [hsq, E_add w₁ w₂ f₁ f₂ hw₁ hw₂]
  ring

end Prod

/-- The variance of a constant random variable is zero (under a normalized weight). -/
lemma Var_const_zero {Ω : Type*} [Fintype Ω] (w : Ω → ℚ) (c : ℚ) (hw : ∑ x, w x = 1) :
    Var w (fun _ => c) = 0 := by
  unfold Var E; simp only []; simp_rw [← Finset.sum_mul, hw]; ring

/-! ## FREE model: `n` independent edges with occupancy `p` -/

/-- Product weight of `n` independent edges, occupancy `p` each. -/
def freeW (n : ℕ) (p : ℚ) : (Fin n → Bool) → ℚ :=
  fun ω => ∏ i, (if ω i then p else 1 - p)

/-- The bare edge count: number of occupied edges. -/
def edgeCount (n : ℕ) : (Fin n → Bool) → ℚ :=
  fun ω => ∑ i, (if ω i then (1 : ℚ) else 0)

/-- Total probability of the free model is `1`. -/
lemma freeW_sum_one (n : ℕ) (p : ℚ) : ∑ ω, freeW n p ω = 1 := by
  unfold freeW
  rw [show (Finset.univ : Finset (Fin n → Bool)) = Fintype.piFinset (fun _ => Finset.univ) from
    (Fintype.piFinset_univ).symm]
  rw [← Finset.prod_univ_sum (fun _ => Finset.univ)
        (fun (_ : Fin n) (b : Bool) => if b then p else 1 - p)]
  simp

/-- Reindexing an expectation over `Fin (n+1) → Bool` as a `Bool × (Fin n → Bool)` product. -/
lemma E_cons (n : ℕ) (w : (Fin (n + 1) → Bool) → ℚ) (f : (Fin (n + 1) → Bool) → ℚ) :
    E w f = E (fun x : Bool × (Fin n → Bool) => w (Fin.cons x.1 x.2))
              (fun x : Bool × (Fin n → Bool) => f (Fin.cons x.1 x.2)) := by
  unfold E
  rw [← (Fin.consEquiv (fun _ => Bool)).sum_comp (fun i => w i * f i)]
  exact Finset.sum_congr rfl fun i _ => rfl

/-- Reindexing a variance over `Fin (n+1) → Bool` as a `Bool × (Fin n → Bool)` product. -/
lemma Var_cons (n : ℕ) (w : (Fin (n + 1) → Bool) → ℚ) (f : (Fin (n + 1) → Bool) → ℚ) :
    Var w f = Var (fun x : Bool × (Fin n → Bool) => w (Fin.cons x.1 x.2))
                  (fun x : Bool × (Fin n → Bool) => f (Fin.cons x.1 x.2)) := by
  unfold Var
  rw [E_cons n w (fun i => (f i) ^ 2), E_cons n w f]

/-- Splitting off the first edge in the free weight. -/
lemma freeW_cons (n : ℕ) (p : ℚ) (b : Bool) (ω : Fin n → Bool) :
    freeW (n + 1) p (Fin.cons b ω) = (if b then p else 1 - p) * freeW n p ω := by
  unfold freeW; rw [Fin.prod_univ_succ]; simp [Fin.cons_zero, Fin.cons_succ]

/-- Splitting off the first edge in the edge count. -/
lemma edgeCount_cons (n : ℕ) (b : Bool) (ω : Fin n → Bool) :
    edgeCount (n + 1) (Fin.cons b ω) = (if b then (1 : ℚ) else 0) + edgeCount n ω := by
  unfold edgeCount; rw [Fin.sum_univ_succ]; simp [Fin.cons_zero, Fin.cons_succ]

/-- Free-model expected edge count: `⟨N⟩ = n p`. -/
lemma free_E (n : ℕ) (p : ℚ) : E (freeW n p) (edgeCount n) = (n : ℚ) * p := by
  induction n with
  | zero => simp [E, freeW, edgeCount]
  | succ m ih =>
    rw [E_cons]
    simp only [freeW_cons, edgeCount_cons]
    rw [E_add (fun x : Bool => if x = true then p else 1 - p) (freeW m p)
        (fun x : Bool => if x = true then (1 : ℚ) else 0) (edgeCount m)
        (by simp) (freeW_sum_one m p), ih]
    have hhead : E (fun x : Bool => if x = true then p else 1 - p)
             (fun x : Bool => if x = true then (1 : ℚ) else 0) = p := by
      simp [E]
    rw [hhead]; push_cast; ring

/-- **Target 1** — `free_variance_extensive`: `Var(N) = n p (1-p)`, proportional to `n`. -/
theorem free_variance_extensive (n : ℕ) (p : ℚ) :
    Var (freeW n p) (edgeCount n) = (n : ℚ) * p * (1 - p) := by
  induction n with
  | zero => simp [Var, E, freeW, edgeCount]
  | succ m ih =>
    rw [Var_cons]
    simp only [freeW_cons, edgeCount_cons]
    rw [Var_add (fun x : Bool => if x = true then p else 1 - p) (freeW m p)
        (fun x : Bool => if x = true then (1 : ℚ) else 0) (edgeCount m)
        (by simp) (freeW_sum_one m p), ih]
    have hhead : Var (fun x : Bool => if x = true then p else 1 - p)
             (fun x : Bool => if x = true then (1 : ℚ) else 0) = p * (1 - p) := by
      simp [Var, E]; ring
    rw [hhead]; push_cast; ring

/-! ## HARD-constrained model: uniform `k`-of-`n` (microcanonical / neutrality) -/

/-- The support of the hard constraint: `k`-subsets of `Fin n` (total occupancy fixed to `k`). -/
abbrev HardΩ (n k : ℕ) := {s : Finset (Fin n) // s.card = k}

/-- Uniform weight over `k`-of-`n` configurations. -/
def hardW (n k : ℕ) : HardΩ n k → ℚ := fun _ => 1 / (Fintype.card (HardΩ n k) : ℚ)

/-- The edge count on the constrained space. -/
def hardN (n k : ℕ) : HardΩ n k → ℚ := fun s => (s.val.card : ℚ)

/-- On the constrained space the count is identically `k`. -/
lemma hardN_eq (n k : ℕ) (s : HardΩ n k) : hardN n k s = (k : ℚ) := by
  simp [hardN, s.property]

/-- The constrained model is well-populated when `k ≤ n`. -/
lemma hard_card_pos (n k : ℕ) (hkn : k ≤ n) : 0 < Fintype.card (HardΩ n k) := by
  rw [Fintype.card_subtype]
  have hset : (Finset.univ.filter (fun s : Finset (Fin n) => s.card = k))
      = Finset.univ.powersetCard k := by
    ext s; simp [Finset.mem_powersetCard]
  rw [hset, Finset.card_powersetCard]
  simp only [Finset.card_univ, Fintype.card_fin]
  exact Nat.choose_pos hkn

/-- The hard model is a probability distribution (`k ≤ n`). -/
lemma hardW_sum_one (n k : ℕ) (hkn : k ≤ n) : ∑ s, hardW n k s = 1 := by
  have hpos := hard_card_pos n k hkn
  unfold hardW
  rw [Finset.sum_const, Finset.card_univ, nsmul_eq_mul, mul_one_div, div_self]
  exact Nat.cast_ne_zero.mpr hpos.ne'

/-- Hard-model expected count: `⟨N⟩ = k` exactly. -/
lemma hard_E (n k : ℕ) (hkn : k ≤ n) : E (hardW n k) (hardN n k) = (k : ℚ) := by
  unfold E
  have hval : ∀ s : HardΩ n k, hardW n k s * hardN n k s = hardW n k s * (k : ℚ) := by
    intro s; rw [hardN_eq]
  simp_rw [hval, ← Finset.sum_mul, hardW_sum_one n k hkn, one_mul]

/-- **Target 2a** — `constrained_variance_hard`: `Var(N) = 0` for every `n` (with `k ≤ n`). -/
theorem constrained_variance_hard (n k : ℕ) (hkn : k ≤ n) :
    Var (hardW n k) (hardN n k) = 0 := by
  have hfun : hardN n k = (fun _ => (k : ℚ)) := funext (hardN_eq n k)
  rw [hfun]
  exact Var_const_zero _ _ (hardW_sum_one n k hkn)

/-! ## SOFT-constrained model: a two-value mixture of `k` and `k+1` -/

/-- Two-point weight: value carrying `k` gets weight `wt`, value carrying `k+1` gets `1-wt`. -/
def softW (wt : ℚ) : Bool → ℚ := fun b => if b then wt else 1 - wt

/-- The count of the soft model: `k` or `k+1`. -/
def softN (k : ℕ) : Bool → ℚ := fun b => if b then (k : ℚ) else (k + 1 : ℚ)

/-- **Target 2b** — soft mixture: `Var(N) = wt (1-wt)`, an explicit constant independent of `n`. -/
theorem soft_variance (wt : ℚ) (k : ℕ) : Var (softW wt) (softN k) = wt * (1 - wt) := by
  simp only [Var, E, softW, softN, Fintype.sum_bool, Bool.false_eq_true, if_true, if_false]
  ring

/-! ## The pre-registered kill criterion -/

/-- Extensive fluctuation: `Var(n)/n` equals a fixed positive constant. -/
def Extensive (V : ℕ → ℚ) : Prop := ∃ c : ℚ, 0 < c ∧ ∀ n : ℕ, 1 ≤ n → V n / (n : ℚ) = c

/-- Sub-extensive fluctuation: `Var(n)/n ≤ C/n → 0`. -/
def Subextensive (V : ℕ → ℚ) : Prop :=
  ∃ C : ℚ, 0 ≤ C ∧ ∀ n : ℕ, 1 ≤ n → V n / (n : ℚ) ≤ C / (n : ℚ)

/-- The free-model variance sequence. -/
def freeVarSeq (p : ℚ) : ℕ → ℚ := fun n => (n : ℚ) * p * (1 - p)

/-- The hard-constrained variance sequence (identically `0`). -/
def hardVarSeq : ℕ → ℚ := fun _ => 0

/-- The soft-constrained variance sequence (a constant). -/
def softVarSeq (wt : ℚ) : ℕ → ℚ := fun _ => wt * (1 - wt)

/-- The free model is extensive for `0 < p < 1`. -/
theorem free_extensive (p : ℚ) (hp0 : 0 < p) (hp1 : p < 1) : Extensive (freeVarSeq p) := by
  refine ⟨p * (1 - p), mul_pos hp0 (by linarith), ?_⟩
  intro n hn
  have hn0 : (n : ℚ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  unfold freeVarSeq; field_simp

/-- The hard-constrained model is sub-extensive. -/
theorem hard_subextensive : Subextensive hardVarSeq := by
  refine ⟨0, le_refl 0, ?_⟩; intro n hn; unfold hardVarSeq; simp

/-- The soft-constrained model is sub-extensive for `0 ≤ wt ≤ 1`. -/
theorem soft_subextensive (wt : ℚ) (h0 : 0 ≤ wt) (h1 : wt ≤ 1) :
    Subextensive (softVarSeq wt) := by
  refine ⟨wt * (1 - wt), mul_nonneg h0 (by linarith), ?_⟩
  intro n hn; unfold softVarSeq; exact le_refl _

/-- **Target 3** — `dichotomy_criterion`: free ⇒ extensive; hard & soft ⇒ sub-extensive. -/
theorem dichotomy_criterion (p wt : ℚ) (hp0 : 0 < p) (hp1 : p < 1)
    (h0 : 0 ≤ wt) (h1 : wt ≤ 1) :
    Extensive (freeVarSeq p) ∧ Subextensive hardVarSeq ∧ Subextensive (softVarSeq wt) :=
  ⟨free_extensive p hp0 hp1, hard_subextensive, soft_subextensive wt h0 h1⟩

/-- **Target 3 (corollary)** — `everpresent_iff_extensive`: with `Λ²_rms = Var/⟨N⟩²`, a nonzero
everpresent signal is present iff the fluctuation is nonzero (given `⟨N⟩ ≠ 0`). Hence the free
model (`Var = n p(1-p) > 0`) is everpresent while the hard model (`Var = 0`) is suppressed. -/
theorem everpresent_iff_extensive {Ω : Type*} [Fintype Ω] (w f : Ω → ℚ) (hE : E w f ≠ 0) :
    0 < Var w f / (E w f) ^ 2 ↔ 0 < Var w f := by
  have hsq : 0 < (E w f) ^ 2 := by positivity
  constructor
  · intro h
    exact (div_pos_iff.mp h).elim (·.1) (fun hh => absurd hh.2 (not_lt.mpr hsq.le))
  · intro h; exact div_pos h hsq

/-- Free model: the everpresent signal is genuinely present (`Λ² > 0`) for `0 < p < 1`, `n ≥ 1`. -/
theorem free_everpresent (n : ℕ) (p : ℚ) (hn : 1 ≤ n) (hp0 : 0 < p) (hp1 : p < 1) :
    0 < Var (freeW n p) (edgeCount n) / (E (freeW n p) (edgeCount n)) ^ 2 := by
  have hnpos : (0 : ℚ) < (n : ℚ) := by exact_mod_cast hn
  have hE : E (freeW n p) (edgeCount n) ≠ 0 := by
    rw [free_E]; exact (mul_pos hnpos hp0).ne'
  rw [everpresent_iff_extensive _ _ hE, free_variance_extensive]
  exact mul_pos (mul_pos hnpos hp0) (by linarith)

/-- Hard model: the everpresent signal is fully suppressed (`Λ² = 0`). -/
theorem hard_suppressed (n k : ℕ) (hkn : k ≤ n) :
    Var (hardW n k) (hardN n k) / (E (hardW n k) (hardN n k)) ^ 2 = 0 := by
  rw [constrained_variance_hard n k hkn, zero_div]

/-! ## Which count matters: a two-register (edge × charge) model -/

/-- Two registers: bare edge occupancy (`n` free edges, prob `p`) × an internal charge register
(`m` sites) whose Gauss constraint fixes total charge to `j`. -/
abbrev TwoRegΩ (n m j : ℕ) := (Fin n → Bool) × HardΩ m j

/-- Product weight: free edges times uniform-charge constraint. -/
def tworegW (n : ℕ) (p : ℚ) (m j : ℕ) : TwoRegΩ n m j → ℚ :=
  fun x => freeW n p x.1 * hardW m j x.2

/-- The bare edge count (function of the edge register only). -/
def tworegEdge (n : ℕ) (m j : ℕ) : TwoRegΩ n m j → ℚ := fun x => edgeCount n x.1

/-- The total charge (function of the charge register only), Gauss-fixed. -/
def tworegCharge (n : ℕ) (m j : ℕ) : TwoRegΩ n m j → ℚ := fun x => hardN m j x.2

/-- **Target 4** — `which_count_matters`: in the same two-register model, the Gauss-constrained
*charge* has variance `0` while the bare *edge* count keeps its free, extensive variance
`n p(1-p)`. So the fork's resolution depends on *which* count `Λ` is conjugate to. -/
theorem which_count_matters (n : ℕ) (p : ℚ) (m j : ℕ) (hjm : j ≤ m) :
    Var (tworegW n p m j) (tworegCharge n m j) = 0 ∧
    Var (tworegW n p m j) (tworegEdge n m j) = (n : ℚ) * p * (1 - p) := by
  unfold tworegW tworegCharge tworegEdge
  refine ⟨?_, ?_⟩
  · rw [Var_prod_snd (freeW n p) (hardW m j) (hardN m j) (freeW_sum_one n p)]
    exact constrained_variance_hard m j hjm
  · rw [Var_prod_fst (freeW n p) (hardW m j) (edgeCount n) (hardW_sum_one m j hjm)]
    exact free_variance_extensive n p

/-! ## MANDATORY non-degeneracy: explicit rational witnesses -/

/-- Free witness: `n = 3, p = 1/2 ⇒ ⟨N⟩ = 3/2, Var = 3/4` (extensive, `Var/n = 1/4`). -/
theorem free_witness :
    E (freeW 3 (1 / 2)) (edgeCount 3) = 3 / 2 ∧
    Var (freeW 3 (1 / 2)) (edgeCount 3) = 3 / 4 ∧
    Var (freeW 3 (1 / 2)) (edgeCount 3) / (3 : ℚ) = 1 / 4 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [free_E]; norm_num
  · rw [free_variance_extensive]; norm_num
  · rw [free_variance_extensive]; norm_num

/-- Hard witness: uniform `2`-of-`3` ⇒ `⟨N⟩ = 2, Var = 0`. -/
theorem hard_witness :
    E (hardW 3 2) (hardN 3 2) = 2 ∧ Var (hardW 3 2) (hardN 3 2) = 0 := by
  refine ⟨?_, constrained_variance_hard 3 2 (by norm_num)⟩
  rw [hard_E 3 2 (by norm_num)]; norm_num

/-- Soft witness: `wt = 1/3` mixture ⇒ `Var = 2/9` (independent of `n`, here for count `k`). -/
theorem soft_witness (k : ℕ) : Var (softW (1 / 3)) (softN k) = 2 / 9 := by
  rw [soft_variance]; norm_num

/-- Two-register witness: `n=3, p=1/2` edges × `2`-of-`3` charge ⇒ charge-Var `0`, edge-Var `3/4`. -/
theorem tworeg_witness :
    Var (tworegW 3 (1 / 2) 3 2) (tworegCharge 3 3 2) = 0 ∧
    Var (tworegW 3 (1 / 2) 3 2) (tworegEdge 3 3 2) = 3 / 4 := by
  have h := which_count_matters 3 (1 / 2) 3 2 (by norm_num)
  exact ⟨h.1, by rw [h.2]; norm_num⟩

/-! ## Axiom audit: every headline uses only `propext`, `Classical.choice`, `Quot.sound`. -/

/-- info: 'LambdaCountDichotomy.free_variance_extensive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms free_variance_extensive
/-- info: 'LambdaCountDichotomy.constrained_variance_hard' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms constrained_variance_hard
/-- info: 'LambdaCountDichotomy.soft_variance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms soft_variance
/-- info: 'LambdaCountDichotomy.dichotomy_criterion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms dichotomy_criterion
/-- info: 'LambdaCountDichotomy.everpresent_iff_extensive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms everpresent_iff_extensive
/-- info: 'LambdaCountDichotomy.free_everpresent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms free_everpresent
/-- info: 'LambdaCountDichotomy.hard_suppressed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hard_suppressed
/-- info: 'LambdaCountDichotomy.which_count_matters' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms which_count_matters
/-- info: 'LambdaCountDichotomy.free_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms free_witness
/-- info: 'LambdaCountDichotomy.hard_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hard_witness
/-- info: 'LambdaCountDichotomy.soft_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms soft_witness
/-- info: 'LambdaCountDichotomy.tworeg_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms tworeg_witness

end LambdaCountDichotomy
