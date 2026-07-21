import Mathlib

/-!
# End-to-end ladder audit (Opus, verified Aristotle 45ee7130)

Adversarial audit of the ASSEMBLED continuum claim, run because twelve
individually-true rungs do not by themselves license the end-to-end statement.

VERDICT: the conclusion is justified ONLY as a FIXED-MASS, FIXED-DATA,
LOCAL-ON-COMPACT statement - constants may depend on the compact momentum box, and
the ultraviolet cutoff must be chosen BEFORE the lattice scale.

Kernel witnesses: (1) local C(K)/(n+1) bounds with box-unbounded constants, and the
failure of any single global all-momentum constant; (2) the C t^2/(n+1) form DOES
promote to uniform convergence on [0,T] (monotone in t), together with a
moving-spike family converging pointwise - even with eventual pointwise rates - but
NOT uniformly, showing what the monotonicity buys; (3) the bulk/tail bound with the
required 'choose K, then N' epsilon argument and a shrinking-cutoff witness whose
tail stays 1.

EXPLICITLY NOT ESTABLISHED by the ladder: mass-uniformity; interacting dynamics;
uniqueness of the walk; anything about doubling/mirror sectors.

Provenance: verified at the pinned toolchain from Aristotle project 45ee7130.
Standard three axioms. Claim grade M. -/

open Filter
open scoped Topology

set_option autoImplicit false

namespace LadderAudit

/-! ## 1. Quantifier order -/

/-- A concrete error profile whose constant on `[0,K]` is `K`, hence is not
controlled by one constant on all momenta. -/
noncomputable def boxError (n : ℕ) (q : ℝ) : ℝ := q / (n + 1)

theorem boxError_uniform_on_each_box (K : ℝ) (n : ℕ)
    {q : ℝ} (hqK : q ≤ K) :
    boxError n q ≤ K / (n + 1) := by
  exact div_le_div_of_nonneg_right hqK <| by positivity

theorem box_constants_unbounded : ¬ ∃ M : ℝ, ∀ K : ℝ, 0 ≤ K → K ≤ M := by
  exact fun ⟨ M, hM ⟩ => by linarith [ hM ( M + 1 ) ( by linarith [ hM 0 le_rfl ] ) ] ;

/-
Despite an exact `K/(n+1)` estimate on every fixed box, no single
constant gives a `C/(n+1)` estimate at every nonnegative momentum.
-/
theorem boxError_no_global_rate :
    ¬ ∃ C : ℝ, ∀ (n : ℕ) (q : ℝ), 0 ≤ q →
      boxError n q ≤ C / (n + 1) := by
  simp +zetaDelta at *;
  intro C
  use 0
  use max (C + 1) 0
  simp [boxError]

/-- The local-on-boxes quantifier order.  The predicate `InBox K q` may encode
membership in any chosen compact momentum box. -/
def LocalBoxRate (err : ℕ → ℝ → ℝ) (InBox : ℝ → ℝ → Prop) : Prop :=
  ∀ K : ℝ, ∃ C : ℝ, ∃ N : ℕ, ∀ n ≥ N, ∀ q : ℝ,
    InBox K q → err n q ≤ C / (n + 1)

theorem boxError_has_local_box_rate :
    LocalBoxRate boxError (fun K q => 0 ≤ q ∧ q ≤ K) := by
  intro K
  use K, 0
  intro n hn q hq
  exact boxError_uniform_on_each_box K n hq.right

/-- The genuinely global order is stronger: `C,N` occur before the box. -/
def GlobalMomentumRate (err : ℕ → ℝ → ℝ) (InBox : ℝ → ℝ → Prop) : Prop :=
  ∃ C : ℝ, ∃ N : ℕ, ∀ K : ℝ, ∀ n ≥ N, ∀ q : ℝ,
    InBox K q → err n q ≤ C / (n + 1)

/-! ## 2. Fixed time versus uniform time -/

/-
The monotone polynomial estimate immediately becomes a uniform estimate
on `[0,T]`.
-/
theorem quadratic_bound_uniform_on_interval
    (e : ℕ → ℝ → ℝ) (C T : ℝ) (hC : 0 ≤ C)
    (h : ∀ (n : ℕ) (t : ℝ), 0 ≤ t → t ≤ T →
      |e n t| ≤ C * t ^ 2 / (n + 1)) :
    ∀ (n : ℕ) (t : ℝ), 0 ≤ t → t ≤ T →
      |e n t| ≤ C * T ^ 2 / (n + 1) := by
  exact fun n t ht ht' => le_trans ( h n t ht ht' ) ( by gcongr )

/-
Epsilon form of uniform convergence on every fixed finite interval.
-/
theorem quadratic_bound_tends_uniformly
    (e : ℕ → ℝ → ℝ) (C T : ℝ) (hC : 0 ≤ C)
    (h : ∀ (n : ℕ) (t : ℝ), 0 ≤ t → t ≤ T →
      |e n t| ≤ C * t ^ 2 / (n + 1)) :
    ∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, ∀ t : ℝ, 0 ≤ t → t ≤ T → |e n t| < ε := by
  intro ε hεpos
  by_cases hCT : C * T^2 = 0;
  · use 0; intros n hn t ht ht'; by_cases hC : C = 0 <;> by_cases hT : T = 0 <;> simp_all +decide ;
    grind;
  · obtain ⟨N, hN⟩ : ∃ N : ℕ, ∀ n ≥ N, C * T^2 / (n + 1) < ε := by
      exact ⟨ Nat.ceil ( ε⁻¹ * ( C * T ^ 2 ) ), fun n hn => by rw [ div_lt_iff₀ ] <;> nlinarith [ Nat.ceil_le.mp hn, inv_mul_cancel₀ hεpos.ne', show 0 < C * T ^ 2 by positivity ] ⟩;
    exact ⟨ N, fun n hn t ht₁ ht₂ => lt_of_le_of_lt ( h n t ht₁ ht₂ ) ( lt_of_le_of_lt ( by gcongr ) ( hN n hn ) ) ⟩

/-- A moving unit spike.  It converges pointwise to zero, but not uniformly on
`[0,1]`. -/
noncomputable def movingSpike (n : ℕ) (t : ℝ) : ℝ :=
  if t = (1 : ℝ) / (n + 1) then 1 else 0

theorem movingSpike_pointwise (t : ℝ) :
    ∃ N : ℕ, ∀ n ≥ N, movingSpike n t = 0 := by
  by_cases ht : t = 0;
  · exact ⟨ 1, fun n hn => by unfold movingSpike; norm_num [ ht ] ; linarith ⟩;
  · exact ⟨ ⌈|t|⁻¹⌉₊, fun n hn => if_neg fun h => ht <| by cases abs_cases t <;> nlinarith [ Nat.ceil_le.mp hn, mul_inv_cancel₀ ( ne_of_gt <| abs_pos.mpr ht ), mul_div_cancel₀ 1 ( by linarith : ( n : ℝ ) + 1 ≠ 0 ) ] ⟩

/-
Thus the counterexample even has an eventual pointwise `C(t)/(n+1)`
rate (take `C(t)=0` after a time-dependent threshold).
-/
theorem movingSpike_has_pointwise_rate (t : ℝ) :
    ∃ C : ℝ, ∃ N : ℕ, ∀ n ≥ N, |movingSpike n t| ≤ C / (n + 1) := by
  obtain ⟨N, hN⟩ := movingSpike_pointwise t
  use 0, N
  intro n hn
  simp [hN n hn]

theorem movingSpike_not_uniform :
    ∀ n : ℕ, ∃ t : ℝ, 0 ≤ t ∧ t ≤ 1 ∧ |movingSpike n t| = 1 := by
  exact fun n => ⟨ 1 / ( n + 1 ), by positivity, by rw [ div_le_iff₀ ] <;> linarith, by unfold movingSpike; aesop ⟩

/-! ## 3. Compact bulk plus tail -/

/-
If the bulk is at most `a_n` and the tail contribution is at most twice
the norm of the datum's tail, the total has the advertised combined bound.
-/
theorem combined_bulk_tail_bound
    {total bulk tailContribution datumTail a : ℝ}
    (htotal : total ≤ bulk + tailContribution)
    (hbulk : bulk ≤ a)
    (htail : tailContribution ≤ 2 * datumTail) :
    total ≤ a + 2 * datumTail := by
  linarith

/-
Abstract epsilon proof with the necessary order: choose the cutoff `K`
from the fixed datum's tail first, and only then choose `N` for that `K`.
-/
theorem compact_then_lattice_limit
    (E : ℕ → ℝ) (bulk : ℕ → ℕ → ℝ) (tail : ℕ → ℝ)
    (hcombine : ∀ n K, E n ≤ bulk n K + 2 * tail K)
    (htail : ∀ ε > 0, ∃ K : ℕ, tail K < ε)
    (hbulk : ∀ K : ℕ, ∀ ε > 0, ∃ N : ℕ, ∀ n ≥ N, bulk n K < ε) :
    ∀ ε > 0, ∃ K : ℕ, tail K < ε / 4 ∧
      ∃ N : ℕ, ∀ n ≥ N, E n < ε := by
  exact fun ε hε => by rcases htail ( ε / 8 ) ( by positivity ) with ⟨ K, hK ⟩ ; obtain ⟨ N, hN ⟩ := hbulk K ( ε / 4 ) ( by positivity ) ; exact ⟨ K, by linarith, N, fun n hn => by linarith [ hcombine n K, hN n hn ] ⟩ ;

/-- Tail profile of a fixed unit vector at momentum index `1` in a discrete
momentum model: outside a radius below `1` the entire norm remains, while every
radius at least `1` captures it. -/
noncomputable def unitMassTail (K : ℝ) : ℝ := if K < 1 then 1 else 0

theorem unitMassTail_eventually_zero : ∀ K : ℝ, 1 ≤ K → unitMassTail K = 0 := by
  intros K hK
  simp [unitMassTail, hK]

/-
Choosing shrinking boxes `K_n=1/(n+1)` is the wrong direction: the tail
never decreases at all.
-/
theorem shrinking_boxes_leave_full_tail :
    ∀ n : ℕ, unitMassTail ((1 : ℝ) / (n + 1 + 1)) = 1 := by
  exact fun n => if_pos <| by rw [ div_lt_iff₀ ] <;> linarith;

end LadderAudit
