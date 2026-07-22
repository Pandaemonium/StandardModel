import Mathlib

/-!
# Moving-projector triangle-telescope no-go

This module tests a specific proof technique for transporting a changing band.
For a rank-one projector rotating through a fixed nonzero angle, the sum of the
norms of successive projector mismatches does not tend to zero. A unitary that
commutes with the old projector drops out of each mismatch norm exactly.

The result does not refute adiabaticity or prove physical sector leakage.
Genuine adiabatic estimates exploit oscillatory cancellation, integration by
parts, or resolvent-commutator identities. Applying the triangle inequality at
every substep discards that structure, and it is only that lossy route which is
ruled out here.

Provenance: Aristotle project `9e7d0e96-4b07-42b1-b90c-a5cff826368e`, task
`6039149b-8513-4495-86cf-f996ec512f89`, integrated after local semantic review.
The mathematical model is a clean-room finite rank-one control motivated by
Kato/Nenciu/Hastings-style adiabatic and quasi-adiabatic alternatives.
-/

open scoped BigOperators Real
open Filter Finset

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo

abbrev Plane := EuclideanSpace Real (Fin 2)
abbrev Operator := Plane →L[Real] Plane

/-- The rotating unit vector `(cos theta, sin theta)`. -/
noncomputable def u (theta : Real) : Plane :=
  WithLp.toLp 2 ![Real.cos theta, Real.sin theta]

/-- The orthogonal rank-one projector onto the line spanned by `u theta`. -/
noncomputable def P (theta : Real) : Operator :=
  (InnerProductSpace.rankOne Real (u theta)) (u theta)

lemma u_norm (theta : Real) : norm (u theta) = 1 := by
  convert EuclideanSpace.norm_eq _
  norm_num [u]

lemma inner_u_u (theta phi : Real) :
    inner Real (u theta) (u (theta + phi)) = Real.cos phi := by
  unfold u
  simp +decide [EuclideanSpace.inner_eq_star_dotProduct, dotProduct]
  rw [← Complex.ofReal_inj]
  norm_num [Complex.cos_add, Complex.sin_add]
  ring
  rw [Complex.sin_sq, Complex.cos_sq]
  ring

lemma projector_mismatch_vector_norm (theta phi : Real) :
    norm ((1 - P (theta + phi)) (u theta)) = abs (Real.sin phi) := by
  convert congr_arg Norm.norm ?_ using 1
  rotate_left
  exact u theta - inner Real (u (theta + phi)) (u theta) • u (theta + phi)
  · unfold P
    norm_num [mul_comm]
  · norm_num [EuclideanSpace.norm_eq, Real.sin_add, Real.cos_add, inner]
    ring
    unfold u
    norm_num [Real.sin_add, Real.cos_add]
    ring
    rw [← Real.sqrt_sq_eq_abs]
    rw [show Real.sin theta ^ 4 = (Real.sin theta ^ 2) ^ 2 by ring,
      show Real.sin theta ^ 6 = (Real.sin theta ^ 2) ^ 3 by ring,
      Real.sin_sq]
    ring
    rw [show Real.sin theta ^ 4 = (Real.sin theta ^ 2) ^ 2 by ring,
      show Real.sin theta ^ 6 = (Real.sin theta ^ 2) ^ 3 by ring,
      Real.sin_sq]
    ring

/-- Exact geometric mismatch of two successive rotating rank-one bands. -/
theorem rotating_band_mismatch (theta phi : Real) :
    norm ((1 - P (theta + phi)) * P theta) = abs (Real.sin phi) := by
  have hcomp :
      (1 - P (theta + phi)) * P theta =
        (InnerProductSpace.rankOne Real
          ((1 - P (theta + phi)) (u theta))) (u theta) := by
    convert InnerProductSpace.comp_rankOne
      (E := Plane) (u theta) (u theta) (1 - P (theta + phi)) using 1
  rw [hcomp, InnerProductSpace.norm_rankOne]
  rw [projector_mismatch_vector_norm, u_norm, mul_one]

/-- A unitary commuting with the old band drops out of the mismatch norm. -/
theorem dynamics_drop_out (theta phi : Real) (U : Operator)
    (hU : U ∈ unitary Operator) (hcomm : U * P theta = P theta * U) :
    norm ((1 - P (theta + phi)) * U * P theta) = abs (Real.sin phi) := by
  rw [← rotating_band_mismatch]
  rw [mul_assoc, hcomm, ← mul_assoc]
  convert CStarRing.norm_mul_mem_unitary _ hU using 1

/-- The equal-step triangle telescope is a sum of identical terms. -/
theorem telescope_sum (totalAngle : Real) (N : Nat) :
    ∑ _k ∈ range N, abs (Real.sin (totalAngle / (N : Real))) =
      (N : Real) * abs (Real.sin (totalAngle / (N : Real))) := by
  simp +zetaDelta at *

/-- Jordan's inequality gives an `N`-independent positive lower bound. -/
theorem no_go_lower_bound (totalAngle : Real) (N : Nat)
    (hAngle0 : 0 < totalAngle) (hAnglePi : totalAngle <= Real.pi / 2)
    (hN : 1 <= N) :
    (2 / Real.pi) * totalAngle <=
      (N : Real) * Real.sin (totalAngle / (N : Real)) := by
  have hsin := Real.mul_le_sin
    (show 0 <= totalAngle / N by positivity)
    (show totalAngle / N <= Real.pi / 2 by
      rw [div_le_iff₀ (by positivity)]
      nlinarith [Real.pi_pos, show (N : Real) >= 1 by norm_cast])
  rw [mul_div, div_le_iff₀] at hsin <;> first | positivity | linarith

/-- The lower-bound constant is strictly positive for nonzero rotation. -/
theorem no_go_constant_pos (totalAngle : Real) (hAngle0 : 0 < totalAngle) :
    0 < (2 / Real.pi) * totalAngle := by
  positivity

/-- The triangle telescope is uniformly bounded away from zero. -/
theorem telescope_uniformly_positive (totalAngle : Real)
    (hAngle0 : 0 < totalAngle) (hAnglePi : totalAngle <= Real.pi / 2) :
    forall N : Nat, 1 <= N ->
      0 < (2 / Real.pi) * totalAngle /\
        (2 / Real.pi) * totalAngle <=
          (N : Real) * Real.sin (totalAngle / (N : Real)) := by
  exact fun N hN =>
    ⟨by positivity, no_go_lower_bound totalAngle N hAngle0 hAnglePi hN⟩

/-- The absolute-value telescope has the same positive lower bound. -/
theorem telescope_sum_lower_bound (totalAngle : Real) (N : Nat)
    (hAngle0 : 0 < totalAngle) (hAnglePi : totalAngle <= Real.pi / 2)
    (hN : 1 <= N) :
    (2 / Real.pi) * totalAngle <=
      ∑ _k ∈ range N, abs (Real.sin (totalAngle / (N : Real))) := by
  convert no_go_lower_bound totalAngle N hAngle0 hAnglePi hN |> le_trans <| ?_
  norm_num [abs_of_nonneg, Real.sin_nonneg_of_nonneg_of_le_pi
    (show 0 <= totalAngle / N by positivity)
    (by
      rw [div_le_iff₀ (by positivity)]
      nlinarith [Real.pi_pos, show (N : Real) >= 1 by norm_cast])]

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

/-- A nonzero fixed rotation makes the zero-limit triangle gate impossible. -/
theorem telescope_gate_fails (totalAngle : Real) (hAngle0 : 0 < totalAngle)
    (hAnglePi : totalAngle <= Real.pi / 2) :
    Not (Tendsto
      (fun N : Nat =>
        ∑ _k ∈ range N, abs (Real.sin (totalAngle / (N : Real))))
      atTop (nhds 0)) := by
  rw [Metric.tendsto_nhds]
  norm_num
  exact ⟨(2 / Real.pi) * totalAngle, by positivity, fun n =>
    ⟨n + 1, by linarith, by
      simpa using telescope_sum_lower_bound totalAngle (n + 1)
        hAngle0 hAnglePi (by linarith)⟩⟩

/-- The equal-step telescope has sharp limit equal to the total rotation. -/
theorem telescope_tendsto (totalAngle : Real) :
    Tendsto
      (fun N : Nat =>
        (N : Real) * Real.sin (totalAngle / (N : Real)))
      atTop (nhds totalAngle) := by
  have hderiv :
      Tendsto (fun x : Real => Real.sin x / x)
        (nhdsWithin 0 {0}ᶜ) (nhds 1) := by
    simpa [div_eq_inv_mul] using
      Real.hasDerivAt_sin 0 |> HasDerivAt.tendsto_slope_zero
  by_cases hAngle : totalAngle = 0 <;>
    simp_all +decide [div_eq_inv_mul, mul_comm]
  convert hderiv.comp
      (show Tendsto (fun N : Nat => totalAngle * (N : Real)⁻¹)
          atTop (nhdsWithin 0 {0}ᶜ) from ?_) |>.const_mul totalAngle using 2 <;>
    norm_num [mul_assoc, mul_comm, mul_left_comm, hAngle]
  rw [tendsto_nhdsWithin_iff]
  exact ⟨tendsto_const_nhds.div_atTop tendsto_natCast_atTop_atTop,
    Filter.eventually_ne_atTop 0 |>.mono <| by aesop⟩

end PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo
