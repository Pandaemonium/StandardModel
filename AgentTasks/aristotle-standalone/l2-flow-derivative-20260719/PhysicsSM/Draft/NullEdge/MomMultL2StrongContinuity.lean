import PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE

/-!
# Strong time continuity of the exact momentum-space L2 multiplier

The live continuum lane now has a representative-safe linear isometry
`momMultL2Isometry m t` for each elapsed time. This target proves strong
continuity of each orbit `t |-> momMultL2Isometry m t f`, rather than the much
stronger and generally false claim of operator-norm continuity on the full
unbounded momentum space.

The proof uses pointwise continuity of the finite-dimensional matrix
exponential, exact norm preservation, and an `Lp` dominated-convergence
argument with domination by a constant multiple of the fixed representative's
norm.

Provenance: proof returned by Aristotle project
`844d7dcd-25dd-4ace-9331-70e3f1f0531e` and independently accepted by the
Claude family in AFPL review `msg-20260713-032659-ee19b530` after direct replay
under the pinned Lean 4.28.0 toolchain.
-/

noncomputable section

open Matrix Complex
open MeasureTheory
open scoped Matrix.Norms.L2Operator ENNReal

namespace PhysicsSM.Draft.NullEdge.MomMultL2StrongContinuity

open ChangingCellScaledLiveWalk
open ChangingCellFourierL2
open ChangingCellFourierPDE
open Compact3Plus1DiracRate
open VariablePointwiseL2Isometry

/-- **Immutable zero-time fibre control.** The actual exact multiplier at zero
elapsed time is the continuous-linear identity on every momentum fibre. -/
theorem momMult_zero_time (m : Real) (k : FourierMomentum3) :
    momMult m 0 k = ContinuousLinearMap.id Complex Spinor := by
  have h1 : exactFlow (k 0) (k 1) (k 2) m 0 = 1 := by
    simp [exactFlow]
  unfold momMult
  rw [h1, map_one, ContinuousLinearMap.one_def]

/-- The exact Dirac multiplier varies continuously with the elapsed time, for a
fixed momentum, through continuity of the matrix exponential. -/
theorem momMult_continuous_time (m : Real) (k : FourierMomentum3) :
    Continuous (fun t : Real => momMult m t k) := by
  have hexpc : Continuous (NormedSpace.exp : Mat4 → Mat4) := by
    rw [← continuousOn_univ, ← Metric.eball_top_eq_univ (0 : Mat4),
      ← NormedSpace.expSeries_radius_eq_top ℂ Mat4]
    exact NormedSpace.continuousOn_exp
  have h_toCLM : Isometry (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)) := by
    apply Isometry.of_dist_eq
    intro A B
    simpa [dist_eq_norm, map_sub] using Matrix.l2_opNorm_toEuclideanCLM (A - B)
  have hinner : Continuous
      (fun t : Real => (-(t : ℂ)) • (I • H (k 0) (k 1) (k 2) m)) :=
    (Complex.continuous_ofReal.neg).smul continuous_const
  have hexp : Continuous
      (fun t : Real => exactFlow (k 0) (k 1) (k 2) m t) := by
    unfold exactFlow
    exact hexpc.comp hinner
  unfold momMult
  exact h_toCLM.continuous.comp hexp

/-- **Immutable zero-time L2 control.** The representative-safe lift is the
identity on every momentum-space `L2` class at zero elapsed time. -/
theorem momMultL2Isometry_zero_time (m : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    momMultL2Isometry m 0 f = f := by
  refine Lp.ext ?_
  filter_upwards [momMultL2Isometry_coeFn m 0 f] with k hk
  rw [hk, momMult_zero_time m k]
  rfl

/-- The pointwise action of the exact multiplier on a fixed `L2` representative
is almost-everywhere strongly measurable. -/
theorem momMult_apply_aestronglyMeasurable (m t : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    AEStronglyMeasurable (fun k => momMult m t k (f k))
      (volume : Measure FourierMomentum3) :=
  appliedRepresentative_aestronglyMeasurable (volume : Measure FourierMomentum3)
    (momMult m t) (momMult_aestronglyMeasurable m t) f

/-- Exact norm preservation transported to the extended nonnegative norm. -/
theorem momMult_enorm (m t : Real) (k : FourierMomentum3) (v : Spinor) :
    ‖momMult m t k v‖ₑ = ‖v‖ₑ := by
  rw [enorm_eq_nnnorm, enorm_eq_nnnorm]
  congr 1
  exact NNReal.coe_injective (by simpa using momMult_isometry m t k v)

/-- Key convergence: as the elapsed time approaches `t0`, the `L2` seminorm of
the pointwise difference of exact-multiplier actions tends to zero, by
dominated convergence with pointwise matrix-exponential continuity and the
integrable domination `(2‖f·‖)^2`. -/
theorem orbit_eLpNorm_tendsto (m : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3))
    (t0 : Real) (u : ℕ → Real) (hu : Filter.Tendsto u Filter.atTop (nhds t0)) :
    Filter.Tendsto
      (fun n => eLpNorm
        (fun k => momMult m (u n) k (f k) - momMult m t0 k (f k)) 2
        (volume : Measure FourierMomentum3))
      Filter.atTop (nhds 0) := by
  set c : ℝ := (2 : ℝ≥0∞).toReal with hc_def
  have hc2 : c = 2 := by rw [hc_def]; norm_num
  have hc_pos : 0 < c := by rw [hc2]; norm_num
  have hc_nonneg : 0 ≤ c := hc_pos.le
  set D : ℕ → FourierMomentum3 → Spinor :=
    fun n k => momMult m (u n) k (f k) - momMult m t0 k (f k) with hD
  have hDaem : ∀ n, AEStronglyMeasurable (D n) volume := fun n =>
    (momMult_apply_aestronglyMeasurable m (u n) f).sub
      (momMult_apply_aestronglyMeasurable m t0 f)
  have hF_meas : ∀ n, AEMeasurable (fun k => ‖D n k‖ₑ ^ c) volume := fun n =>
    ENNReal.continuous_rpow_const.measurable.comp_aemeasurable (hDaem n).enorm
  have h_bound : ∀ n, (fun k => ‖D n k‖ₑ ^ c) ≤ᵐ[volume]
      (fun k => (2 * ‖f k‖ₑ) ^ c) := by
    intro n
    refine Filter.Eventually.of_forall (fun k => ?_)
    have hpt : ‖D n k‖ₑ ≤ 2 * ‖f k‖ₑ := by
      calc ‖D n k‖ₑ ≤ ‖momMult m (u n) k (f k)‖ₑ + ‖momMult m t0 k (f k)‖ₑ :=
            enorm_sub_le
        _ = ‖f k‖ₑ + ‖f k‖ₑ := by rw [momMult_enorm, momMult_enorm]
        _ = 2 * ‖f k‖ₑ := (two_mul _).symm
    exact ENNReal.rpow_le_rpow hpt hc_nonneg
  have h_fin : ∫⁻ k, (2 * ‖f k‖ₑ) ^ c ∂volume ≠ ∞ := by
    have hmul : (fun k => (2 * ‖f k‖ₑ) ^ c)
        = (fun k => (2:ℝ≥0∞) ^ c * ‖f k‖ₑ ^ c) := by
      funext k; exact ENNReal.mul_rpow_of_nonneg 2 (‖f k‖ₑ) hc_nonneg
    rw [hmul, lintegral_const_mul' _ _
        (ENNReal.rpow_ne_top_of_nonneg hc_nonneg (by norm_num))]
    apply ENNReal.mul_ne_top
    · exact ENNReal.rpow_ne_top_of_nonneg hc_nonneg (by norm_num)
    · exact (lintegral_rpow_enorm_lt_top_of_eLpNorm_lt_top (by norm_num) (by norm_num)
        (Lp.eLpNorm_lt_top f)).ne
  have h_lim : ∀ᵐ k ∂volume, Filter.Tendsto (fun n => ‖D n k‖ₑ ^ c)
      Filter.atTop (nhds 0) := by
    refine Filter.Eventually.of_forall (fun k => ?_)
    have hev : Filter.Tendsto (fun n => momMult m (u n) k (f k))
        Filter.atTop (nhds (momMult m t0 k (f k))) := by
      have hL : Filter.Tendsto (fun n => momMult m (u n) k)
          Filter.atTop (nhds (momMult m t0 k)) :=
        ((momMult_continuous_time m k).tendsto t0).comp hu
      have hcont := (ContinuousLinearMap.apply Complex Spinor (f k)).continuous
      exact (hcont.tendsto _).comp hL
    have hD0 : Filter.Tendsto (fun n => D n k) Filter.atTop (nhds 0) := by
      have := hev.sub (tendsto_const_nhds (x := momMult m t0 k (f k)))
      simpa [hD, sub_self] using this
    have henorm : Filter.Tendsto (fun n => ‖D n k‖ₑ) Filter.atTop (nhds 0) := by
      have := (continuous_enorm.tendsto (0 : Spinor)).comp hD0
      simpa using this
    have := henorm.ennrpow_const c
    simpa [ENNReal.zero_rpow_of_pos hc_pos] using this
  have hL0 : Filter.Tendsto (fun n => ∫⁻ k, ‖D n k‖ₑ ^ c ∂volume)
      Filter.atTop (nhds 0) := by
    have := tendsto_lintegral_of_dominated_convergence'
      (fun k => (2 * ‖f k‖ₑ) ^ c) hF_meas h_bound h_fin h_lim
    simpa using this
  have hrw : ∀ n, eLpNorm (D n) 2 volume
      = (∫⁻ k, ‖D n k‖ₑ ^ c ∂volume) ^ (1 / c) := by
    intro n
    rw [eLpNorm_eq_lintegral_rpow_enorm_toReal (by norm_num) (by norm_num)]
  have hfinal : Filter.Tendsto (fun n => eLpNorm (D n) 2 volume)
      Filter.atTop (nhds 0) := by
    simp_rw [hrw]
    have := hL0.ennrpow_const (1 / c)
    simpa [one_div, ENNReal.zero_rpow_of_pos (inv_pos.mpr hc_pos)] using this
  exact hfinal

/-- Orbit of one fixed momentum-space `L2` state under the exact multiplier. -/
def momMultL2Orbit (m : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) (t : Real) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  momMultL2Isometry m t f

/-- **Immutable analytic target.** Every state has a strongly continuous
time orbit under the exact momentum-space multiplier. -/
theorem momMultL2Orbit_continuous (m : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    Continuous (momMultL2Orbit m f) := by
  rw [continuous_iff_seqContinuous]
  intro u t0 hu
  simp only [Function.comp_def, momMultL2Orbit]
  rw [Lp.tendsto_Lp_iff_tendsto_eLpNorm' (fun n => momMultL2Isometry m (u n) f)
        (momMultL2Isometry m t0 f)]
  have hcongr : (fun n => eLpNorm
        (⇑(momMultL2Isometry m (u n) f) - ⇑(momMultL2Isometry m t0 f)) 2
        (volume : Measure FourierMomentum3))
      = (fun n => eLpNorm
        (fun k => momMult m (u n) k (f k) - momMult m t0 k (f k)) 2
        (volume : Measure FourierMomentum3)) := by
    funext n
    apply eLpNorm_congr_ae
    filter_upwards [momMultL2Isometry_coeFn m (u n) f,
      momMultL2Isometry_coeFn m t0 f] with k h1 h2
    simp only [Pi.sub_apply, h1, h2]
  rw [hcongr]
  exact orbit_eLpNorm_tendsto m f t0 u hu

/-! ## Non-degeneracy and scope controls -/

/-- The strong-continuity target concerns norm-preserving nonzero-time orbits,
not a constant zero map. -/
theorem momMultL2Orbit_norm (m t : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    norm (momMultL2Orbit m f t) = norm f :=
  momMultL2Isometry_norm m t f

/-- At the nonzero rest witness and nonzero time, the orbit still uses the
actual live multiplier family. -/
theorem rest_orbit_representative (f : Lp Spinor 2
    (volume : Measure FourierMomentum3)) :
    momMultL2Orbit 4 f 1 =ᵐ[(volume : Measure FourierMomentum3)]
      fun k => momMult 4 1 k (f k) :=
  momMultL2Isometry_coeFn 4 1 f

end PhysicsSM.Draft.NullEdge.MomMultL2StrongContinuity
