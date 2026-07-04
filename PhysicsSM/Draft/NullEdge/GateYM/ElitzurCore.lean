import Mathlib

/-!
# Gate YM1: the Elitzur pairing bound (abstract core)

Harvested from Aristotle job f501f8c8
(`AgentTasks/aristotle-standalone/ym1-elitzur-core-20260703`); both
statements were authored in-repo, hand-verified, and proved by Aristotle
with NO statement changed - no falsity encountered.

This is the abstract mathematical core of Elitzur's theorem (statement
freeze: `AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`,
Theorem 1): a LOCAL gauge symmetry cannot break spontaneously, uniformly in
the lattice volume. Reduced to two pieces of finite/real-analysis
mathematics:

* `abs_one_sub_exp_le_tanh`: the pointwise hyperbolic pairing inequality
  `|1 - exp(-2a)| <= (1 + exp(-2a)) * tanh b` for `|a| <= b` (proved via
  `t = exp(-a)`, the sinh/cosh expansion of `tanh`, and `nlinarith`).
* `abstract_elitzur_bound`: the abstract pairing bound over a finite
  configuration space with an involution `phi`, positive weights with
  source-covariance `w(phi s) = w(s) exp(-2 K s)`, and a `phi`-odd bounded
  observable `f`: `|sum f w| <= c tanh(b) sum w` - the volume-uniform core
  of the whole theorem. Proved by reindexing through the involution
  (`Equiv.sum_comp`) to get the paired forms
  `2 sum f w = sum f w (1 - exp(-2K))` and
  `2 sum w = sum w (1 + exp(-2K))`, bounding termwise via the first
  theorem, and closing with the triangle inequality.

The lattice instantiation (the involution = the one-site gauge flip; Wilson-
action invariance under it is the already-kernel-checked
`Z2GaugeCore.plaqSpins_gauge`) is bookkeeping for a successor module, not
part of this one.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked,
axiom footprint `[propext, Classical.choice, Quot.sound]`.
Claim label: **finite/analytic identity** (Elitzur pairing core).
Prerequisites: Mathlib only. Successor: PKG-YM1-lattice (thread the
one-site flip involution and Wilson-term invariance through this bound to
recover the full quantitative, volume-uniform Elitzur theorem).
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ElitzurCore

/-
**Target 1: the pointwise pairing inequality.**
For `|a| <= b`: `|1 - e^{-2a}| <= (1 + e^{-2a}) tanh b`.
-/
theorem abs_one_sub_exp_le_tanh (a b : ℝ) (hab : |a| ≤ b) :
    |1 - Real.exp (-2 * a)| ≤ (1 + Real.exp (-2 * a)) * Real.tanh b := by
  -- Set t = exp(-a) > 0. Then exp(-2a) = t^2. We have |1 - t^2| ≤ (1 + t^2) * tanh b.
  set t := Real.exp (-a)
  have ht : 0 < t := by
    positivity
  have ht_sq : Real.exp (-2 * a) = t^2 := by
    rw [sq, ← Real.exp_add]; congr 1; ring
  rw [ht_sq];
  -- Since $|a| \leq b$, we have $t = \exp(-a) \leq \exp(b)$ and $t = \exp(-a) \geq \exp(-b)$.
  have ht_bounds : Real.exp (-b) ≤ t ∧ t ≤ Real.exp b := by
    exact ⟨ Real.exp_le_exp.mpr ( by linarith [ abs_le.mp hab ] ), Real.exp_le_exp.mpr ( by linarith [ abs_le.mp hab ] ) ⟩;
  rw [ Real.tanh_eq_sinh_div_cosh, Real.sinh_eq, Real.cosh_eq ];
  rw [ abs_le ] ; constructor <;> nlinarith [ Real.exp_pos b, Real.exp_pos ( -b ), mul_div_cancel₀ ( ( Real.exp b - Real.exp ( -b ) ) / 2 ) ( by positivity : ( Real.exp b + Real.exp ( -b ) ) / 2 ≠ 0 ), mul_le_mul_of_nonneg_left ht_bounds.1 ht.le, mul_le_mul_of_nonneg_left ht_bounds.2 ht.le, Real.exp_neg b, mul_inv_cancel₀ ( ne_of_gt ( Real.exp_pos b ) ) ] ;

/-
**Target 2: the abstract Elitzur pairing bound.**
Finite configuration space, involution `phi`, positive weights with the
source-covariance `w (phi s) = w s * exp (-2 K s)`, `phi`-odd bounded
observable: the weighted average is bounded by `c * tanh b`, uniformly in
everything else - the volume-uniform core of Elitzur's theorem.
-/
theorem abstract_elitzur_bound {Ω : Type*} [Fintype Ω]
    (φ : Ω → Ω) (hφ : Function.Involutive φ)
    (f w K : Ω → ℝ) (c b : ℝ)
    (hw : ∀ s, 0 < w s) (hb : 0 ≤ b)
    (hK : ∀ s, |K s| ≤ b)
    (hodd : ∀ s, f (φ s) = - f s)
    (hcov : ∀ s, w (φ s) = w s * Real.exp (-2 * K s))
    (hfb : ∀ s, |f s| ≤ c) :
    |∑ s, f s * w s| ≤ c * Real.tanh b * ∑ s, w s := by
  -- By the properties of the involution and the covariance, we can rewrite the sums.
  have h_sum_rewrite : ∑ s, f s * w s = -∑ s, f s * w s * Real.exp (-2 * K s) := by
    rw [ ← Equiv.sum_comp ( Equiv.ofBijective φ ⟨ hφ.injective, hφ.surjective ⟩ ) ];
    simp +decide [ *, mul_assoc, Finset.sum_neg_distrib ]
  have h_sum_rewrite' : 2 * ∑ s, w s = ∑ s, w s * (1 + Real.exp (-2 * K s)) := by
    have h_sum_rewrite' : ∑ s, w s = ∑ s, w (φ s) := by
      conv_lhs => rw [ ← Equiv.sum_comp ( Equiv.ofBijective φ ⟨ hφ.injective, hφ.surjective ⟩ ) ] ;
      rfl;
    simp_all +decide [ mul_add, Finset.sum_add_distrib ] ; linarith;
  -- Apply the pointwise inequality to each term in the sum.
  have h_pointwise : ∀ s, |f s * w s * (1 - Real.exp (-2 * K s))| ≤ c * w s * (1 + Real.exp (-2 * K s)) * Real.tanh b := by
    intro s
    have h_pointwise : |1 - Real.exp (-2 * K s)| ≤ (1 + Real.exp (-2 * K s)) * Real.tanh b := by
      exact abs_one_sub_exp_le_tanh (K s) b (hK s)
    rw [ abs_mul, abs_mul, abs_of_nonneg ( le_of_lt ( hw s ) ) ];
    simpa only [ mul_assoc ] using mul_le_mul ( mul_le_mul_of_nonneg_right ( hfb s ) ( le_of_lt ( hw s ) ) ) h_pointwise ( by positivity ) ( by nlinarith [ abs_le.mp ( hfb s ), hw s ] );
  -- Apply the triangle inequality to the sum.
  have h_triangle : |∑ s, f s * w s * (1 - Real.exp (-2 * K s))| ≤ ∑ s, c * w s * (1 + Real.exp (-2 * K s)) * Real.tanh b := by
    exact le_trans ( Finset.abs_sum_le_sum_abs _ _ ) ( Finset.sum_le_sum fun s _ => h_pointwise s );
  simp_all +decide [ mul_sub, ← Finset.sum_mul ];
  simp_all +decide [ ← Finset.mul_sum _ _ _, mul_assoc, abs_sub_comm ];
  rw [ ← two_mul, abs_mul, abs_two ] at h_triangle ; rw [ ← h_sum_rewrite' ] at * ; nlinarith [ Real.tanh_eq_sinh_div_cosh b, Real.sinh_sq b, Real.cosh_pos b, mul_div_cancel₀ ( Real.sinh b ) ( ne_of_gt ( Real.cosh_pos b ) ) ] ;

end ElitzurCore
end GateYM
end NullEdge
end Draft
end PhysicsSM
