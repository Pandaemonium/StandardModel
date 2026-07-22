import Mathlib

/-!
# A no-go result for the moving-projector telescope route

This module studies a particular proof technique, not physical sector leakage itself.  For a
rank-one band which rotates through a fixed nonzero angle, the sum of the norms of successive
projector mismatches does not tend to zero.  A commuting unitary dynamics does not change each
mismatch norm.  Thus a proof which applies the triangle inequality at every substep cannot pass
a gate requiring that sum to vanish.

This does **not** refute adiabaticity.  Genuine adiabatic estimates obtain their
`O(1 / (T * gap))` smallness from oscillatory cancellation (for example, integration by parts
and resolvent-commutator identities), which this triangle-inequality telescope discards.  Kato,
Nenciu, or Hastings-style quasi-adiabatic generators are appropriate replacements for the
route tested here.
-/

open scoped BigOperators Real
open Filter Finset

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace MovingProjectorNoGo

abbrev Plane := EuclideanSpace ℝ (Fin 2)
abbrev Operator := Plane →L[ℝ] Plane

/-- The rotating unit vector `(cos θ, sin θ)`. -/
noncomputable def u (θ : ℝ) : Plane := WithLp.toLp 2 ![Real.cos θ, Real.sin θ]

/-- The orthogonal rank-one projector onto the line spanned by `u θ`. -/
noncomputable def P (θ : ℝ) : Operator := (InnerProductSpace.rankOne ℝ (u θ)) (u θ)

lemma u_norm (θ : ℝ) : ‖u θ‖ = 1 := by
  convert EuclideanSpace.norm_eq _;
  norm_num [ u ]

lemma inner_u_u (θ φ : ℝ) : inner ℝ (u θ) (u (θ + φ)) = Real.cos φ := by
  unfold u;
  simp +decide [ EuclideanSpace.inner_eq_star_dotProduct, dotProduct ];
  rw [ ← Complex.ofReal_inj ] ; norm_num [ Complex.cos_add, Complex.sin_add ] ; ring;
  rw [ Complex.sin_sq, Complex.cos_sq ] ; ring

lemma projector_mismatch_vector_norm (θ φ : ℝ) :
    ‖(1 - P (θ + φ)) (u θ)‖ = |Real.sin φ| := by
  convert congr_arg Norm.norm ?_ using 1;
  rotate_left;
  exact u θ - inner ℝ ( u ( θ + φ ) ) ( u θ ) • u ( θ + φ );
  · unfold P; norm_num [ mul_comm ] ;
  · norm_num [ EuclideanSpace.norm_eq, Real.sin_add, Real.cos_add, inner ] ; ring;
    unfold u; norm_num [ Real.sin_add, Real.cos_add ] ; ring;
    rw [ ← Real.sqrt_sq_eq_abs ] ; rw [ show Real.sin θ ^ 4 = ( Real.sin θ ^ 2 ) ^ 2 by ring, show Real.sin θ ^ 6 = ( Real.sin θ ^ 2 ) ^ 3 by ring, Real.sin_sq ] ; ring;
    rw [ show Real.sin θ ^ 4 = ( Real.sin θ ^ 2 ) ^ 2 by ring, show Real.sin θ ^ 6 = ( Real.sin θ ^ 2 ) ^ 3 by ring, Real.sin_sq ] ; ring

/-- Exact geometric mismatch of two successive rotating rank-one bands. -/
theorem rotating_band_mismatch (θ φ : ℝ) :
    ‖(1 - P (θ + φ)) * P θ‖ = |Real.sin φ| := by
  have h_comp : (1 - P (θ + φ)) * P θ = (InnerProductSpace.rankOne ℝ ((1 - P (θ + φ)) (u θ))) (u θ) := by
    convert InnerProductSpace.comp_rankOne ( E := Plane ) ( u θ ) ( u θ ) ( 1 - P ( θ + φ ) ) using 1;
  rw [ h_comp, InnerProductSpace.norm_rankOne ];
  rw [ projector_mismatch_vector_norm, u_norm, mul_one ]

/--
A commuting unitary drops out exactly.  Here `U ∈ unitary Operator` is Mathlib's algebraic
unitarity condition.  A phase (or any other unitary action) on the old band therefore does not
alter the operator norm of the one-step mismatch.
-/
theorem dynamics_drop_out (θ φ : ℝ) (U : Operator)
    (hU : U ∈ unitary Operator) (hcomm : U * P θ = P θ * U) :
    ‖(1 - P (θ + φ)) * U * P θ‖ = |Real.sin φ| := by
  rw [ ← rotating_band_mismatch ];
  rw [ mul_assoc, hcomm, ← mul_assoc ];
  convert CStarRing.norm_mul_mem_unitary _ hU using 1

/-- The equal-step telescope is a sum of `N` identical geometric terms. -/
theorem telescope_sum (Θ : ℝ) (N : ℕ) :
    ∑ _k ∈ range N, |Real.sin (Θ / (N : ℝ))| =
      (N : ℝ) * |Real.sin (Θ / (N : ℝ))| := by
  simp +zetaDelta at *

/-- Jordan's inequality gives an `N`-independent positive lower bound. -/
theorem no_go_lower_bound (Θ : ℝ) (N : ℕ) (hΘ0 : 0 < Θ)
    (hΘpi : Θ ≤ Real.pi / 2) (hN : 1 ≤ N) :
    (2 / Real.pi) * Θ ≤ (N : ℝ) * Real.sin (Θ / (N : ℝ)) := by
  have := Real.mul_le_sin ( show 0 ≤ Θ / N by positivity ) ( show Θ / N ≤ Real.pi / 2 by rw [ div_le_iff₀ ( by positivity ) ] ; nlinarith [ Real.pi_pos, show ( N : ℝ ) ≥ 1 by norm_cast ] );
  rw [ mul_div, div_le_iff₀ ] at this <;> first | positivity | linarith;

/-- The lower-bound constant in the no-go theorem is strictly positive. -/
theorem no_go_constant_pos (Θ : ℝ) (hΘ0 : 0 < Θ) :
    0 < (2 / Real.pi) * Θ := by
  positivity

/--
The triangle-inequality telescope is uniformly bounded away from zero at every positive depth.
Consequently it cannot satisfy a gate requiring these bounds to tend to zero.
-/
theorem telescope_uniformly_positive (Θ : ℝ) (hΘ0 : 0 < Θ)
    (hΘpi : Θ ≤ Real.pi / 2) :
    ∀ N : ℕ, 1 ≤ N →
      0 < (2 / Real.pi) * Θ ∧
        (2 / Real.pi) * Θ ≤ (N : ℝ) * Real.sin (Θ / (N : ℝ)) := by
  exact fun N hN => ⟨ by positivity, no_go_lower_bound Θ N hΘ0 hΘpi hN ⟩

/-- The actual absolute-value telescope has the same positive uniform lower bound. -/
theorem telescope_sum_lower_bound (Θ : ℝ) (N : ℕ) (hΘ0 : 0 < Θ)
    (hΘpi : Θ ≤ Real.pi / 2) (hN : 1 ≤ N) :
    (2 / Real.pi) * Θ ≤
      ∑ _k ∈ range N, |Real.sin (Θ / (N : ℝ))| := by
  convert no_go_lower_bound Θ N hΘ0 hΘpi hN |> le_trans <| ?_;
  norm_num [ abs_of_nonneg, Real.sin_nonneg_of_nonneg_of_le_pi ( show 0 ≤ Θ / N by positivity ) ( by rw [ div_le_iff₀ ( by positivity ) ] ; nlinarith [ Real.pi_pos, show ( N : ℝ ) ≥ 1 by norm_cast ] ) ]

/-- Refining the equal-step discretization cannot decrease the telescope bound. -/
theorem telescope_monotone (Θ : ℝ) (hΘ0 : 0 < Θ) (hΘpi : Θ ≤ Real.pi / 2) :
    Monotone fun N : ℕ => (N : ℝ) * Real.sin (Θ / (N : ℝ)) := by
  intro n m hnm;
  by_cases hn : n = 0 <;> by_cases hm : m = 0 <;> simp_all +decide [ div_eq_mul_inv ];
  · exact mul_nonneg ( Nat.cast_nonneg _ ) ( Real.sin_nonneg_of_nonneg_of_le_pi ( by positivity ) ( by rw [ mul_inv_le_iff₀ ( by positivity ) ] ; ring_nf at *; nlinarith [ Real.pi_pos, show ( m : ℝ ) ≥ 1 by exact Nat.one_le_cast.mpr ( Nat.pos_of_ne_zero hm ) ] ) );
  · have h_sin_concave : Real.sin (Θ * (m : ℝ)⁻¹) / (Θ * (m : ℝ)⁻¹) ≥ Real.sin (Θ * (n : ℝ)⁻¹) / (Θ * (n : ℝ)⁻¹) := by
      have h_sin_concave : StrictConcaveOn ℝ (Set.Icc 0 Real.pi) Real.sin := by
        exact strictConcaveOn_sin_Icc;
      by_cases hmn : m = n;
      · rw [ hmn ];
      · have := h_sin_concave.secant_strict_mono ( show 0 ∈ Set.Icc 0 Real.pi by norm_num; positivity ) ( show Θ * ( m : ℝ ) ⁻¹ ∈ Set.Icc 0 Real.pi by constructor <;> nlinarith [ Real.pi_pos, show ( m : ℝ ) ≥ 1 by norm_cast; exact Nat.one_le_iff_ne_zero.mpr hm, inv_mul_cancel₀ ( by positivity : ( m : ℝ ) ≠ 0 ) ] ) ( show Θ * ( n : ℝ ) ⁻¹ ∈ Set.Icc 0 Real.pi by constructor <;> nlinarith [ Real.pi_pos, show ( n : ℝ ) ≥ 1 by norm_cast; exact Nat.one_le_iff_ne_zero.mpr hn, inv_mul_cancel₀ ( by positivity : ( n : ℝ ) ≠ 0 ) ] ) ?_ ?_ ?_ <;> norm_num at *;
        · grind;
        · grind +revert;
        · aesop;
        · exact mul_lt_mul_of_pos_left ( inv_strictAnti₀ ( by positivity ) ( mod_cast lt_of_le_of_ne hnm ( Ne.symm hmn ) ) ) hΘ0;
    field_simp at h_sin_concave ⊢;
    exact h_sin_concave

/--
The gate requiring the absolute-value telescope to tend to zero is impossible for nonzero
rotation in the stated range.
-/
theorem telescope_gate_fails (Θ : ℝ) (hΘ0 : 0 < Θ)
    (hΘpi : Θ ≤ Real.pi / 2) :
    ¬ Tendsto (fun N : ℕ => ∑ _k ∈ range N, |Real.sin (Θ / (N : ℝ))|)
        atTop (nhds 0) := by
  rw [ Metric.tendsto_nhds ] ; norm_num;
  exact ⟨ ( 2 / Real.pi ) * Θ, by positivity, fun n => ⟨ n + 1, by linarith, by simpa using telescope_sum_lower_bound Θ ( n + 1 ) hΘ0 hΘpi ( by linarith ) ⟩ ⟩

/-- The sharp asymptotic value of the equal-step telescope is the total rotation angle. -/
theorem telescope_tendsto (Θ : ℝ) :
    Tendsto (fun N : ℕ => (N : ℝ) * Real.sin (Θ / (N : ℝ))) atTop (nhds Θ) := by
  have h_deriv : Filter.Tendsto (fun x : ℝ => Real.sin x / x) (nhdsWithin 0 {0}ᶜ) (nhds 1) := by
    simpa [ div_eq_inv_mul ] using Real.hasDerivAt_sin 0 |> HasDerivAt.tendsto_slope_zero;
  by_cases hΘ : Θ = 0 <;> simp_all +decide [div_eq_inv_mul, mul_comm];
  convert h_deriv.comp ( show Filter.Tendsto ( fun N : ℕ => Θ * ( N : ℝ ) ⁻¹ ) Filter.atTop ( nhdsWithin 0 { 0 } ᶜ ) from ?_ ) |> ( ·.const_mul Θ ) using 2 <;> norm_num [ mul_assoc, mul_comm, mul_left_comm, hΘ ];
  rw [ tendsto_nhdsWithin_iff ];
  exact ⟨ tendsto_const_nhds.div_atTop tendsto_natCast_atTop_atTop, Filter.eventually_ne_atTop 0 |> Filter.Eventually.mono <| by aesop ⟩

#print axioms rotating_band_mismatch
#print axioms dynamics_drop_out
#print axioms telescope_sum
#print axioms no_go_lower_bound
#print axioms no_go_constant_pos
#print axioms telescope_uniformly_positive
#print axioms telescope_sum_lower_bound
#print axioms telescope_monotone
#print axioms telescope_gate_fails
#print axioms telescope_tendsto

end MovingProjectorNoGo
