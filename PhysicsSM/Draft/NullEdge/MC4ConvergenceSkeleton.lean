import Mathlib

/-!
# MC4 one-step -> many-step convergence skeleton (Opus, verified 05caba69)

Abstract Mathlib-only skeleton for the ladder audited in
`AutonomousLab/work/NE-3PLUS1/OPUS_HNU_MASSIVE_CONTINUUM_AUDIT_2026-07-20.md`.
A walk supplies its one-step constant TOGETHER WITH the hypotheses below; the
fixed-time rate then follows. CORRECTION (docstring audit `6d88b22a`): the earlier
phrasing 'supplies ONLY its one-step constant' was an overclaim - a one-step constant
ALONE does not determine later steps (witness: W 1 = id but W 2 x = x+1). A
propagation hypothesis is required: the exact group law plus a one-step bound UNIFORM
in the starting point (under which unitarity is not additionally needed), or
unitarity to transport a bound available only at a distinguished state. The theorem
below assumes the group law and unitarity, so it is sound; only the prose was loose.
telescoping ||U^n - V^n|| <= n ||U - V|| - stated here for unitaries, which is
STRONGER THAN NEEDED. Audit wave 2 (`703405f6`) noted contractions suffice; meta-audit
`a21c13e4` sharpens further: a uniform power bound `C` gives `C^2 n ||U-V||`, separate
bounds give `CU * CV * n * ||U-V||`, and the EXACT telescoping-sum estimate requires NO
contraction or power-bound hypothesis at all. Then
one_step_to_many_step: unitary W,E with ||W eps - E eps|| <= c eps^2 and E an exact
one-parameter group give ||(W (t/n))^n - E t|| <= c t^2 / n, plus the Tendsto form.

LOAD-BEARING HYPOTHESES (do not drop): both families unitary, and E an EXACT
one-parameter group. A composition audit (54b11569) is checking whether the
block/conjugation lift actually delivers these - a block-diagonal is unitary only
if each block is, and a conjugated exponential satisfies the group law only for an
eps-INDEPENDENT conjugator.

Offered to Codex for the MC4 integration (walk-agnostic; no MC file touched).
Namespace kept as the prover's MC4Convergence. Provenance: verified at pin from
task 7ab18a95. Standard three. Claim grade M, [comp]. -/

open scoped Matrix.Norms.L2Operator
open Filter

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace MC4Convergence

abbrev Mat4 := Matrix (Fin 4) (Fin 4) ℂ

/-
Powers of two unitary `4 × 4` complex matrices are at most linearly farther
apart than the matrices themselves, in the L2 operator norm.
-/
theorem unitary_pow_sub_pow_norm_le (U V : Mat4) (n : ℕ)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hV : V ∈ Matrix.unitaryGroup (Fin 4) ℂ) :
    ‖U ^ n - V ^ n‖ ≤ (n : ℝ) * ‖U - V‖ := by
  induction' n with n ih;
  · norm_num [ Norm.norm ];
  · -- By the properties of the L2 operator norm, we can expand the left-hand side.
    have h_expand : ‖U ^ (n + 1) - V ^ (n + 1)‖ ≤ ‖U ^ n * (U - V)‖ + ‖(U ^ n - V ^ n) * V‖ := by
      convert norm_add_le ( U ^ n * ( U - V ) ) ( ( U ^ n - V ^ n ) * V ) using 1 ; simp +decide [ pow_succ, mul_sub, sub_mul ];
    -- By the properties of the L2 operator norm, we can bound each term in the expansion.
    have h_bound : ‖U ^ n * (U - V)‖ ≤ ‖U ^ n‖ * ‖U - V‖ ∧ ‖(U ^ n - V ^ n) * V‖ ≤ ‖U ^ n - V ^ n‖ * ‖V‖ := by
      exact ⟨ by simpa using Matrix.l2_opNorm_mul ( U ^ n ) ( U - V ), by simpa using Matrix.l2_opNorm_mul ( U ^ n - V ^ n ) V ⟩;
    -- By the properties of the L2 operator norm, we know that ‖U^n‖ ≤ 1 and ‖V‖ ≤ 1.
    have h_norm_le_one : ‖U ^ n‖ ≤ 1 ∧ ‖V‖ ≤ 1 := by
      constructor;
      · have h_norm_U : ∀ n : ℕ, ‖U ^ n‖ ≤ 1 := by
          intro n
          have h_norm_U : ∀ n : ℕ, U ^ n ∈ Matrix.unitaryGroup (Fin 4) ℂ := by
            exact fun n => Submonoid.pow_mem _ hU n;
          convert CStarRing.norm_of_mem_unitary ( h_norm_U n ) |> le_of_eq;
        exact h_norm_U n;
      · convert CStarRing.norm_of_mem_unitary hV |> le_of_eq;
    push_cast; nlinarith [ norm_nonneg ( U - V ), norm_nonneg ( U ^ n - V ^ n ) ] ;

/-
The fixed-time one-step-to-many-step estimate.  A walk family only needs to
supply the quadratic one-step estimate; the other assumptions say that both
families are unitary on the relevant interval and that `E` is an exact
one-parameter group.
-/
theorem one_step_to_many_step
    (W E : ℝ → Mat4) (c t : ℝ) (n : ℕ)
    (hW : ∀ eps : ℝ, 0 ≤ eps → eps ≤ 1 →
      W eps ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hE : ∀ eps : ℝ, 0 ≤ eps → eps ≤ 1 →
      E eps ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hstep : ∀ eps : ℝ, 0 ≤ eps → eps ≤ 1 →
      ‖W eps - E eps‖ ≤ c * eps ^ 2)
    (hgroup : ∀ s t : ℝ, E s * E t = E (s + t))
    (ht : 0 < t) (hn : 0 < n) (hsmall : t / (n : ℝ) ≤ 1) :
    ‖W (t / (n : ℝ)) ^ n - E t‖ ≤ c * t ^ 2 / (n : ℝ) := by
  convert MC4Convergence.unitary_pow_sub_pow_norm_le ( W ( t / n ) ) ( E ( t / n ) ) n _ _ |> le_trans <| ?_ using 1;
  · -- By induction on $n$, we can show that $E(t/n)^n = E(t)$.
    have h_ind : ∀ k : ℕ, 0 < k → E (t / n) ^ k = E (k * (t / n)) := by
      intro k hk; induction hk <;> simp_all +decide [ pow_succ, add_mul ] ;
    rw [ h_ind n hn, mul_div_cancel₀ _ ( by positivity ) ];
  · exact hW _ ( by positivity ) hsmall;
  · exact hE _ ( by positivity ) hsmall;
  · convert mul_le_mul_of_nonneg_left ( hstep ( t / n ) ( by positivity ) hsmall ) ( Nat.cast_nonneg n ) using 1 ; ring_nf ; norm_num [ sq, mul_assoc, mul_comm, mul_left_comm, hn.ne' ]

/-
Under the same walk-agnostic assumptions, the fixed-time approximants
converge to the exact evolution.
-/
theorem one_step_to_many_step_tendsto
    (W E : ℝ → Mat4) (c t : ℝ)
    (hW : ∀ eps : ℝ, 0 ≤ eps → eps ≤ 1 →
      W eps ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hE : ∀ eps : ℝ, 0 ≤ eps → eps ≤ 1 →
      E eps ∈ Matrix.unitaryGroup (Fin 4) ℂ)
    (hstep : ∀ eps : ℝ, 0 ≤ eps → eps ≤ 1 →
      ‖W eps - E eps‖ ≤ c * eps ^ 2)
    (hgroup : ∀ s t : ℝ, E s * E t = E (s + t))
    (ht : 0 < t) :
    Tendsto (fun n : ℕ => W (t / (n : ℝ)) ^ n) atTop (nhds (E t)) := by
  rw [ tendsto_iff_norm_sub_tendsto_zero ];
  refine' squeeze_zero_norm' _ _;
  use fun n => c * t ^ 2 / n;
  · filter_upwards [ Filter.eventually_gt_atTop ⌈t⌉₊, Filter.eventually_gt_atTop 0 ] with n hn hn';
    convert one_step_to_many_step W E c t n hW hE hstep hgroup ht hn' ( by rw [ div_le_iff₀ ( by positivity ) ] ; nlinarith [ Nat.le_ceil t, show ( n : ℝ ) ≥ ⌈t⌉₊ + 1 by exact_mod_cast hn ] ) using 1;
    norm_num;
  · exact tendsto_const_nhds.div_atTop tendsto_natCast_atTop_atTop

end MC4Convergence
