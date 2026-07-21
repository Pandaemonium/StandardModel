import Mathlib

/-!
# MC5 ultraviolet tail bound against unitary objects (Opus, verified bba8646c)

Abstract Mathlib-only brick discharging MC5 hidden-assumption item 3 of
`AutonomousLab/work/NE-3PLUS1/OPUS_HNU_MASSIVE_CONTINUUM_AUDIT_2026-07-20.md`:
the changing-lattice UV tail step must be applied to GENUINELY UNITARY objects
(an exponential surrogate is not unitary unless proved). Contents: ||U-V||<=2 for
unitaries with NO regularity or mass hypothesis; the tail multiplier estimate
||(U-V)f||_{L2(T)} <= 2||f||_{L2(T)}; L2 tail vanishing by dominated convergence;
and the unitary tail error tending to 0 with the MASS-INDEPENDENT constant 2.
CORRECTION (docstring audit `6d88b22a`): the CONSTANT is mass-independent, but the
TAIL SET must be fixed independently of the mass for the tail ENERGY to be so - a
witness with an identity-unitary field and a mass-dependent tail set gives tail
energies 0 and 1. Fix the tail set independently of mass, or prove uniform control
over the mass-dependent family separately.
The measurability hypothesis is stated explicitly (AEStronglyMeasurable on the
restricted measure) rather than assumed.

Offered to Codex for the MC5 integration (walk-agnostic; touches no MC file).
Namespace kept as the prover's UltravioletTail. Provenance: verified at pin from
task 08d6e894. Standard three. Claim grade M, [comp]. -/

open Filter MeasureTheory
open scoped ENNReal Matrix.Norms.L2Operator Topology

set_option autoImplicit false

namespace UltravioletTail

variable {𝕜 n Q : Type*} [RCLike 𝕜] [Fintype n] [DecidableEq n]
variable [MeasurableSpace Q]

/-
Two genuinely unitary matrices are at operator-norm distance at most two.
No regularity, spectral, or mass assumption occurs in this statement.
-/
theorem norm_sub_le_two_of_mem_unitary (U V : Matrix n n 𝕜)
    (hU : U ∈ unitary (Matrix n n 𝕜)) (hV : V ∈ unitary (Matrix n n 𝕜)) :
    ‖U - V‖ ≤ 2 := by
  classical
  cases isEmpty_or_nonempty n with
  | inl _ =>
      rw [Subsingleton.elim (U - V) 0, norm_zero]
      norm_num
  | inr _ =>
      calc
        ‖U - V‖ ≤ ‖U‖ + ‖V‖ := norm_sub_le U V
        _ = 2 := by
          rw [CStarRing.norm_of_mem_unitary hU, CStarRing.norm_of_mem_unitary hV]
          norm_num

/-- The pointwise matrix action, expressed on Euclidean space so that its norm is the L2
norm on the finite-dimensional fibre. -/
noncomputable def matrixAction (A : Matrix n n 𝕜) (x : EuclideanSpace 𝕜 n) :
    EuclideanSpace 𝕜 n := Matrix.toEuclideanCLM (n := n) (𝕜 := 𝕜) A x

/-
The exact ultraviolet estimate on a measurable tail set.

The measurability assumption actually used is `hAction`: the product map
`q ↦ (U q - V q) (f q)` is a.e. strongly measurable.  This is the minimal useful
hypothesis for the real-valued `lpNorm`; it follows, in particular, from strong
measurability of `U`, `V`, and `f` because matrix evaluation is continuous in these
finite-dimensional normed spaces.
-/
theorem lpNorm_matrixAction_restrict_le_two
    (μ : Measure Q) (T : Set Q)
    (U V : Q → Matrix n n 𝕜) (f : Q → EuclideanSpace 𝕜 n)
    (hU : ∀ q, U q ∈ unitary (Matrix n n 𝕜))
    (hV : ∀ q, V q ∈ unitary (Matrix n n 𝕜))
    (hAction : AEStronglyMeasurable (fun q => matrixAction (U q - V q) (f q))
      (μ.restrict T))
    (hf : MemLp f 2 (μ.restrict T)) :
    lpNorm (fun q => matrixAction (U q - V q) (f q)) 2 (μ.restrict T) ≤
      2 * lpNorm f 2 (μ.restrict T) := by
  have h_pointwise : ∀ q, ‖matrixAction (U q - V q) (f q)‖ ≤ 2 * ‖f q‖ := by
    intro q
    have h_norm : ‖U q - V q‖ ≤ 2 := by
      apply_rules [ norm_sub_le_two_of_mem_unitary ]
    have h_apply : ‖matrixAction (U q - V q) (f q)‖ ≤ ‖U q - V q‖ * ‖f q‖ := by
      convert ContinuousLinearMap.le_opNorm ( Matrix.toEuclideanCLM ( n := n ) ( 𝕜 := 𝕜 ) ( U q - V q ) ) ( f q ) using 1
    exact le_trans h_apply (mul_le_mul_of_nonneg_right h_norm (norm_nonneg (f q)));
  have h_eLpNorm : eLpNorm (fun q => matrixAction (U q - V q) (f q)) 2 (μ.restrict T) ≤ 2 * eLpNorm f 2 (μ.restrict T) := by
    have := @eLpNorm_le_mul_eLpNorm_of_ae_le_mul;
    convert this ( Filter.Eventually.of_forall h_pointwise ) 2 using 1 ; norm_num;
  convert ENNReal.toReal_mono _ h_eLpNorm using 1 <;> norm_num [ lpNorm ];
  · exact fun h => False.elim <| h hAction;
  · exact fun h => False.elim <| h <| hf.1;
  · exact ENNReal.mul_ne_top ENNReal.coe_ne_top ( hf.eLpNorm_lt_top.ne )

/-
L2 mass on measurable shrinking tails vanishes.  The precise shrinking condition is
pointwise a.e. convergence of the indicators to zero.
-/
omit [DecidableEq n] in
theorem tendsto_lpNorm_restrict_zero_of_ae_tendsto_indicator
    (μ : Measure Q) (T : ℕ → Set Q) (f : Q → EuclideanSpace 𝕜 n)
    (hT : ∀ k, MeasurableSet (T k)) (hf : MemLp f 2 μ)
    (hshrink : ∀ᵐ q ∂μ, Tendsto (fun k => (T k).indicator f q) atTop (𝓝 0)) :
    Tendsto (fun k => lpNorm f 2 (μ.restrict (T k))) atTop (𝓝 0) := by
  -- By definition of lpNorm, we know that
  suffices h_suff : Filter.Tendsto (fun k => (∫⁻ q in T k, ‖f q‖ₑ ^ 2 ∂μ) ^ (1 / 2 : ℝ)) Filter.atTop (nhds 0) by
    convert ENNReal.tendsto_toReal ( show ( 0 : ENNReal ) ≠ ⊤ by simp ) |>.comp h_suff using 2 ; norm_num [ lpNorm ];
    rw [ eLpNorm_eq_lintegral_rpow_enorm_toReal ] ; norm_num [ hf.1.restrict ]; all_goals norm_num;
  -- Apply the Dominated Convergence Theorem to the sequence of functions $(T_k).indicator (‖f‖^2)$.
  have h_dominated : Filter.Tendsto (fun k => ∫⁻ q, (T k).indicator (fun q => ‖f q‖ₑ ^ 2) q ∂μ) Filter.atTop (nhds (∫⁻ q, 0 ∂μ)) := by
    refine' MeasureTheory.tendsto_lintegral_of_dominated_convergence' _ _ _ _ _;
    refine' fun q => ‖f q‖ₑ ^ 2;
    · exact fun k => AEMeasurable.indicator ( hf.1.enorm.pow_const _ ) ( hT k );
    · intro k; filter_upwards [ ] with q; by_cases hq : q ∈ T k <;> simp [hq] ;
    · have := hf.2;
      rw [ eLpNorm_eq_lintegral_rpow_enorm_toReal ] at this <;> norm_num at *;
      exact fun h => this.ne <| by rw [ h ] ; norm_num;
    · filter_upwards [ hshrink ] with q hq;
      convert Tendsto.comp ( show Filter.Tendsto ( fun x : EuclideanSpace 𝕜 n => ‖x‖ₑ ^ 2 ) ( nhds 0 ) ( nhds 0 ) from ?_ ) hq using 2;
      · by_cases h : q ∈ T ‹_› <;> simp [h];
      · refine' Continuous.tendsto' _ _ _ _ <;> norm_num;
        fun_prop;
  convert ENNReal.continuous_rpow_const.continuousAt.tendsto.comp h_dominated using 2 ; norm_num [ MeasureTheory.lintegral_indicator, hT ];
  exacts [rfl, by simp]

/-
Consequently, any sequence of unitary multiplier differences has vanishing tail error.
The constant is exactly `2` and is uniform in every external parameter (in particular mass).
-/
theorem tendsto_unitary_tail_error
    (μ : Measure Q) (T : ℕ → Set Q)
    (U V : ℕ → Q → Matrix n n 𝕜) (f : Q → EuclideanSpace 𝕜 n)
    (hT : ∀ k, MeasurableSet (T k)) (hf : MemLp f 2 μ)
    (hshrink : ∀ᵐ q ∂μ, Tendsto (fun k => (T k).indicator f q) atTop (𝓝 0))
    (hU : ∀ k q, U k q ∈ unitary (Matrix n n 𝕜))
    (hV : ∀ k q, V k q ∈ unitary (Matrix n n 𝕜))
    (hAction : ∀ k, AEStronglyMeasurable
      (fun q => matrixAction (U k q - V k q) (f q)) (μ.restrict (T k))) :
    Tendsto
      (fun k => lpNorm (fun q => matrixAction (U k q - V k q) (f q))
        2 (μ.restrict (T k))) atTop (𝓝 0) := by
  refine' squeeze_zero ( fun x => _ ) ( fun k => _ ) _;
  use fun k => 2 * lpNorm f 2 ( μ.restrict ( T k ) );
  · exact lpNorm_nonneg;
  · apply lpNorm_matrixAction_restrict_le_two μ (T k) (U k) (V k) f (fun q => hU k q) (fun q => hV k q) (hAction k) (hf.mono_measure (Measure.restrict_le_self));
  · convert tendsto_const_nhds.mul ( tendsto_lpNorm_restrict_zero_of_ae_tendsto_indicator μ T f hT hf hshrink ) using 2 ; norm_num

end UltravioletTail
