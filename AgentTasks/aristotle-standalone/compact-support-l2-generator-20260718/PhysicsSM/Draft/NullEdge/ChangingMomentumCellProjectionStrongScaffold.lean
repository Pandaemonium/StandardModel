import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionL2
import PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density
import PhysicsSM.Draft.NullEdge.ScaledChangingMomentumWalk

/-!
# Strong `L2` changing-cell projection scaffold

This target composes the normalized cell-average `L2` contraction, compact
smooth globally Lipschitz density, and the explicit Gate D schedule

`h_N = 1 / (N + 1)`, `K_N = (N + 1)^2`.

The resulting finite projections use every cell with integer center in
`[-K_N, K_N]^3`.  Their mesh tends to zero and their physical radius tends to
infinity.  The total represented volume is not uniformly bounded, so the
compact-core proof must localize to cells meeting the compact support; applying
the earlier center-sampler theorem to the entire expanding box is invalid.

The final theorem is the strong squared-`L2(R^3)` convergence statement for an
arbitrary complex `MemLp` representative.  It does not compose live dynamics,
the inverse Fourier transform, or identify a position-space Dirac flow.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongScaffold

open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling
open ChangingMomentumCellProjection
open ChangingMomentumCellProjectionL2
open ChangingMomentumL2Density
open ScaledChangingMomentumWalk

/-- Integer labels in the explicit Gate D cube at refinement level `N`. -/
def scheduledModes (N : Nat) : Finset Mode3 :=
  Finset.Icc
    (fun _ : Fin 3 => -(physicalCutoff N : Int))
    (fun _ : Fin 3 => (physicalCutoff N : Int))

/-- Membership in the scheduled cube is coordinatewise. -/
lemma mem_scheduledModes_iff (N : Nat) (k : Mode3) :
    k ∈ scheduledModes N ↔
      ∀ i : Fin 3,
        -(physicalCutoff N : Int) ≤ k i ∧
          k i ≤ (physicalCutoff N : Int) := by
  rw [scheduledModes, Finset.mem_Icc]
  constructor
  · rintro ⟨hlower, hupper⟩ i
    exact ⟨hlower i, hupper i⟩
  · intro hbounds
    exact ⟨fun i => (hbounds i).1, fun i => (hbounds i).2⟩

/-- The concrete finite cell-average projection on the Gate D mesh and box. -/
def projectAt (N : Nat) (f : Momentum3 -> Complex) : Momentum3 -> Complex :=
  projectFinite (physicalSpacing N) (scheduledModes N) f

/-- Only scheduled cells on which `g` is nonzero can contribute to its
cell-average projection. -/
def activeModes (N : Nat) (g : Momentum3 -> Complex) : Finset Mode3 :=
  by
    classical
    exact (scheduledModes N).filter fun k =>
      ∃ x ∈ momentumCell (physicalSpacing N) k, g x ≠ 0

/-- `L2` membership supplies the globally integrable squared norm consumed by
the contraction theorem. -/
lemma memLp_two_integrable_norm_sq {f : Momentum3 -> Complex}
    (hf : MemLp f 2 volume) :
    Integrable (fun x => ‖f x‖ ^ 2) := by
  exact hf.integrable_norm_pow (by norm_num)

/-- On each finite-volume momentum cell, an `L2` field is Bochner integrable.

Proof handoff:
Use the finite cell measure and the `L2`-to-`L1` Holder estimate on the
restricted measure.  This is the local hypothesis needed by `cellAverage` and
`projectFinite_L2_contraction`; it must not be added to the final theorem as an
independent assumption.
-/
lemma memLp_two_integrableOn_momentumCell {f : Momentum3 -> Complex}
    (hf : MemLp f 2 volume) (h : Real) (k : Mode3) :
    IntegrableOn f (momentumCell h k) := by
  have h1 : MemLp f 2 (volume.restrict (momentumCell h k)) := hf.restrict _
  have : IsFiniteMeasure (volume.restrict (momentumCell h k)) :=
    ⟨by
      rw [Measure.restrict_apply_univ]
      exact lt_top_iff_ne_top.2 (volume_momentumCell_ne_top h k)⟩
  exact h1.integrable (by norm_num)

/-- The concrete scheduled projections inherit the landed `L2` contraction. -/
theorem projectAt_L2_contraction (N : Nat) (f : Momentum3 -> Complex)
    (hf : MemLp f 2 volume) :
    ∫ x, ‖projectAt N f x‖ ^ 2 <= ∫ x, ‖f x‖ ^ 2 := by
  exact projectFinite_L2_contraction (physicalSpacing_pos N) (scheduledModes N) f
    (fun k _ => memLp_two_integrableOn_momentumCell hf _ k)
    (memLp_two_integrable_norm_sq hf)

/-- The finite cell-average projection of an `L2` field is again `L2`.

Proof handoff:
`projectFinite` is a finite sum over `scheduledModes N` of
`(momentumCell h k).indicator (fun _ => cellAverage h k f)`.  Each summand is a
constant on a finite-measure measurable set, hence `MemLp _ 2 volume`
(`memLp_indicator_const` / `MemLp.indicator` with `volume_momentumCell_ne_top`).
A finite sum of `MemLp` functions is `MemLp` (`memLp_finset_sum`). -/
lemma projectAt_memLp (N : Nat) (f : Momentum3 -> Complex) :
    MemLp (projectAt N f) 2 volume := by
  unfold projectAt projectFinite
  apply memLp_finset_sum
  intro k hk
  exact memLp_indicator_const 2 (momentumCell_measurable _ k) _
    (Or.inr (volume_momentumCell_ne_top _ k))

/-- The squared-`L2` error of the projection is integrable. -/
lemma projectAt_sub_sq_integrable (N : Nat) (f : Momentum3 -> Complex)
    (hf : MemLp f 2 volume) :
    Integrable (fun x => ‖projectAt N f x - f x‖ ^ 2) := by
  exact ((projectAt_memLp N f).sub hf).integrable_norm_pow (by norm_num)

/-
Cell averages and finite projections respect subtraction on `L2` inputs.

Proof handoff:
Apply `integral_sub` on each selected cell using
`memLp_two_integrableOn_momentumCell`, then distribute the finite indicator
sum.  Keep this as an equality of representatives; AE-invariance is already
landed separately.
-/
lemma projectAt_sub (N : Nat) (f g : Momentum3 -> Complex)
    (hf : MemLp f 2 volume) (hg : MemLp g 2 volume) :
    projectAt N (f - g) = projectAt N f - projectAt N g := by
  unfold projectAt;
  -- By definition of `projectFinite`, we can write it as a sum over the scheduled modes.
  unfold projectFinite;
  ext x; simp +decide [ Set.indicator ] ;
  rw [ ← Finset.sum_sub_distrib ] ; congr ; ext ; split_ifs <;> simp +decide [ *, ChangingMomentumPointSamplerNoGo.cellAverage ] ;
  rw [ ← mul_sub, MeasureTheory.integral_sub ];
  · exact memLp_two_integrableOn_momentumCell hf _ _;
  · exact memLp_two_integrableOn_momentumCell hg _ _

/-
Removing inactive cells does not change the projection of the fixed field.

Proof handoff:
For an omitted cell, `g` is identically zero there, hence its set integral and
normalized average vanish.  Expand both finite sums and remove zero terms.
-/
lemma projectAt_eq_active (N : Nat) (g : Momentum3 -> Complex) :
    projectAt N g =
      projectFinite (physicalSpacing N) (activeModes N g) g := by
  funext x; simp [projectAt, projectFinite, activeModes];
  rw [ Finset.sum_filter ];
  refine' Finset.sum_congr rfl fun k hk => _;
  split_ifs <;> simp_all +decide [ ChangingMomentumPointSamplerNoGo.cellAverage ];
  exact fun hx => Or.inr <| MeasureTheory.setIntegral_eq_zero_of_forall_eq_zero fun y hy => by solve_by_elim;

/-
On a selected cell, averaging a globally Lipschitz field incurs at most
`L * h` pointwise error: two points of the same sup-norm cell are at distance
at most its side length.

Proof handoff:
Rewrite with `projectFinite_eq_average`, move the constant `g x` inside the
normalized integral, apply `norm_integral_le_integral_norm`, and use the cell
diameter estimate obtained coordinatewise from `Set.mem_Ico`.  Normalize with
`volume_momentumCell_toReal`.
-/
lemma projectFinite_pointwise_error_on_cell
    {h L : Real} (hh : 0 < h) (hL : 0 <= L)
    (s : Finset Mode3) (g : Momentum3 -> Complex)
    (hLip : ∀ x y, ‖g x - g y‖ <= L * ‖x - y‖)
    {k : Mode3} (hk : k ∈ s) {x : Momentum3}
    (hx : x ∈ momentumCell h k) :
    ‖projectFinite h s g x - g x‖ <= L * h := by
  -- By Taking the norm of the difference between the cell average and g x, we get:
  have h_norm_diff : ‖(∫ y in momentumCell h k, g y ∂volume) - (g x) * (volume (momentumCell h k)).toReal‖ ≤ L * h * (volume (momentumCell h k)).toReal := by
    have h_norm_diff : ‖∫ y in momentumCell h k, (g y - g x) ∂volume‖ ≤ L * h * (volume (momentumCell h k)).toReal := by
      refine' le_trans ( MeasureTheory.norm_setIntegral_le_of_norm_le_const _ _ ) _;
      exact L * h;
      · exact lt_top_iff_ne_top.mpr ( volume_momentumCell_ne_top h k );
      · intro y hy
        have h_dist : ‖y - x‖ ≤ h := by
          have h_dist : ‖y - cellCenter h k‖ ≤ h / 2 ∧ ‖x - cellCenter h k‖ ≤ h / 2 := by
            exact ⟨ mem_momentumCell_norm_error hh hy, mem_momentumCell_norm_error hh hx ⟩;
          simpa using norm_sub_le ( y - cellCenter h k ) ( x - cellCenter h k ) |> le_trans <| by linarith;
        exact le_trans (hLip y x) (mul_le_mul_of_nonneg_left h_dist hL);
      · rfl;
    convert h_norm_diff using 1;
    rw [ MeasureTheory.integral_sub ] <;> norm_num;
    · simp +decide [ mul_comm, MeasureTheory.measureReal_def ];
    · exact ContinuousOn.integrableOn_compact ( show IsCompact ( closure ( momentumCell h k ) ) from by
                                                  refine' ( Metric.isCompact_iff_isClosed_bounded.mpr _ );
                                                  simp +decide [ momentumCell ];
                                                  exact isCompact_univ_pi ( fun i => CompactIccSpace.isCompact_Icc ) |> IsCompact.isBounded |> fun h => h.subset <| Set.pi_mono fun i _ => Set.Ico_subset_Icc_self ) ( show ContinuousOn g ( closure ( momentumCell h k ) ) from by
                                                                                                                    refine' Continuous.continuousOn _;
                                                                                                                    rw [ Metric.continuous_iff ];
                                                                                                                    exact fun x ε ε_pos => ⟨ ε / ( L + 1 ), div_pos ε_pos ( by positivity ), fun y hy => by rw [ dist_eq_norm ] at *; exact lt_of_le_of_lt ( hLip _ _ ) ( by nlinarith [ norm_nonneg ( y - x ), mul_div_cancel₀ ε ( by positivity : ( L + 1 ) ≠ 0 ) ] ) ⟩ ) |> fun h => h.mono_set <| subset_closure;
    · apply_rules [ MeasureTheory.integrable_const ];
      constructor ; norm_num [ volume_momentumCell_ne_top ];
      exact lt_top_iff_ne_top.mpr ( volume_momentumCell_ne_top h k );
  have h_norm_diff : ‖(volume (momentumCell h k)).toReal⁻¹ • (∫ y in momentumCell h k, g y ∂volume) - g x‖ ≤ L * h := by
    have h_norm_diff : ‖(volume (momentumCell h k)).toReal⁻¹ • ((∫ y in momentumCell h k, g y ∂volume) - (g x) * (volume (momentumCell h k)).toReal)‖ ≤ L * h := by
      rw [ norm_smul, Real.norm_of_nonneg ( by positivity ) ];
      rw [ inv_mul_le_iff₀ ] <;> nlinarith [ show 0 < ( volume ( momentumCell h k ) |> ENNReal.toReal ) from by rw [ volume_momentumCell_toReal hh k ] ; positivity ];
    convert h_norm_diff using 2 ; norm_num [ mul_sub, sub_mul, mul_assoc, mul_comm, mul_left_comm, ne_of_gt ( show 0 < ( volume ( momentumCell h k ) |> ENNReal.toReal ) from by rw [ volume_momentumCell_toReal hh k ] ; positivity ) ];
  convert h_norm_diff using 2;
  convert congr_arg ( fun y => y - g x ) ( projectFinite_eq_average hh s g hk hx ) using 1

/-
The landed smooth-density theorem can be expressed in the squared-integral
form used by the contraction and three-epsilon argument.

Proof handoff:
Apply `memLp_exists_compact_global_lipschitz_eLpNorm_approx` with a square-root
tolerance.  Convert the `eLpNorm` bound at exponent two using
`MemLp.eLpNorm_eq_integral_rpow_norm`, and retain the same compact smooth
globally Lipschitz approximant.  Establish `MemLp g 2 volume` from compact
support and continuity, or from the triangle inequality with `f - g`.
-/
theorem memLp_exists_compact_smooth_lipschitz_sq_approx
    {f : Momentum3 -> Complex} (hf : MemLp f 2 volume)
    {ε : Real} (hε : 0 < ε) :
    ∃ g : Momentum3 -> Complex, ∃ L : Real,
      HasCompactSupport g ∧
      ContDiff Real (↑(⊤ : ENat)) g ∧
      0 <= L ∧
      (∀ x y, ‖g x - g y‖ <= L * ‖x - y‖) ∧
      MemLp g 2 volume ∧
      (∫ x, ‖f x - g x‖ ^ 2) <= ε := by
  obtain ⟨g, L, hgK, hgC, hL, hLip, hg⟩ := ChangingMomentumL2Density.memLp_exists_compact_global_lipschitz_eLpNorm_approx hf (show (0:ℝ) < Real.sqrt ε from Real.sqrt_pos.2 hε);
  refine' ⟨ g, L, hgK, hgC, hL, hLip, _, _ ⟩;
  · have hfg : MemLp (f - g) 2 volume := by
      constructor;
      · exact hf.1.sub ( hgC.continuous.aestronglyMeasurable );
      · exact lt_of_le_of_lt hg ( ENNReal.ofReal_lt_top );
    convert hf.sub hfg using 1 ; ext ; simp +decide [ sub_eq_add_neg ];
  · have h_integrable : MemLp (f - g) 2 volume := by
      constructor;
      · exact hf.1.sub ( hgC.continuous.aestronglyMeasurable );
      · exact lt_of_le_of_lt hg ( ENNReal.ofReal_lt_top );
    have h_integrable : eLpNorm (f - g) 2 volume = ENNReal.ofReal ((∫ x, ‖(f - g) x‖ ^ (2:ℝ)) ^ (1/2:ℝ)) := by
      convert h_integrable.eLpNorm_eq_integral_rpow_norm using 1 ; norm_num;
    rw [ h_integrable, ENNReal.ofReal_le_ofReal_iff ] at hg;
    · rw [ ← Real.sqrt_eq_rpow, Real.sqrt_le_sqrt_iff ] at hg <;> first | positivity | aesop;
    · positivity

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongScaffold
