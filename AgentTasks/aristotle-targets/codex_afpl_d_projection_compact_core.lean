import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionGeometry

/-!
# AFPL Gate D compact-core projection glue

This isolated target factors the first remaining Gate D convergence theorem
through four explicit statements:

1. pointwise cell-average error on the represented union;
2. support coverage by the active cells;
3. a global squared-error estimate using active-cell volume;
4. convergence by the explicit mesh limit and uniform active-volume bound.

It does not address arbitrary `L2` density transfer, live-walk coefficients,
inverse Fourier transport, or a position-space PDE limit.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionCompactCore

open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling
open ChangingMomentumCellProjection
open ChangingMomentumCellProjectionStrongScaffold
open ChangingMomentumCellProjectionGeometry
open ScaledChangingMomentumWalk

/-- The landed single-cell estimate extends to the represented cell union. -/
lemma projectFinite_pointwise_error_on_cellUnion
    {h L : Real} (hh : 0 < h) (hL : 0 <= L)
    (s : Finset Mode3) (g : Momentum3 -> Complex)
    (hLip : forall x y, ‖g x - g y‖ <= L * ‖x - y‖)
    {x : Momentum3} (hx : x ∈ cellUnion h s) :
    ‖projectFinite h s g x - g x‖ <= L * h := by
  obtain ⟨k, hk, hxk⟩ : ∃ k ∈ s, x ∈ momentumCell h k := by
    unfold cellUnion at hx
    aesop
  exact projectFinite_pointwise_error_on_cell hh hL s g hLip hk hxk

/-- Once scheduled cells cover the support, active cells cover it as well. -/
lemma support_subset_active_cellUnion (N : Nat) {g : Momentum3 -> Complex}
    (hcover : Function.support g ⊆
      cellUnion (physicalSpacing N) (scheduledModes N)) :
    Function.support g ⊆
      cellUnion (physicalSpacing N) (activeModes N g) := by
  intro x hx
  unfold cellUnion at hcover ⊢
  obtain ⟨k, hk, hxk⟩ := Set.mem_iUnion₂.mp (hcover hx)
  refine Set.mem_iUnion₂.mpr ⟨k, ?_, hxk⟩
  simp only [activeModes, Finset.mem_filter]
  exact ⟨hk, x, hxk, hx⟩

/-- A finite cell-average projection has global squared error controlled by
the represented volume and the squared Lipschitz mesh error whenever its cells
cover the field's support. -/
lemma projectFinite_integral_sq_error_global_le
    {h L : Real} (hh : 0 < h) (hL : 0 <= L)
    (s : Finset Mode3) (g : Momentum3 -> Complex)
    (hLip : forall x y, ‖g x - g y‖ <= L * ‖x - y‖)
    (hcover : Function.support g ⊆ cellUnion h s) :
    ∫ x, ‖projectFinite h s g x - g x‖ ^ 2 <=
      (volume (cellUnion h s)).toReal * (L * h) ^ 2 := by
  set C : Real := (L * h) ^ 2 with hC
  have hC_nonneg : 0 <= C := sq_nonneg _
  have hlocal :
      ∫ x in cellUnion h s, ‖projectFinite h s g x - g x‖ ^ 2 <=
        ∫ _x in cellUnion h s, C := by
    refine MeasureTheory.integral_mono_of_nonneg ?_ ?_ ?_
    · exact Filter.Eventually.of_forall fun x => sq_nonneg _
    · refine integrableOn_const ?_
      rw [cellUnion]
      exact ne_of_lt <| lt_of_le_of_lt
        (MeasureTheory.measure_biUnion_finset_le (μ := volume) s
          (fun k => momentumCell h k)) <|
        ENNReal.sum_lt_top.mpr fun k hk =>
          lt_top_iff_ne_top.mpr (volume_momentumCell_ne_top h k)
    · filter_upwards [MeasureTheory.ae_restrict_mem (cellUnion_measurable h s)]
        with x hx
      exact pow_le_pow_left₀ (norm_nonneg _)
        (projectFinite_pointwise_error_on_cellUnion hh hL s g hLip hx) 2
  have hglobal :
      ∫ x, ‖projectFinite h s g x - g x‖ ^ 2 =
        ∫ x in cellUnion h s, ‖projectFinite h s g x - g x‖ ^ 2 := by
    rw [MeasureTheory.setIntegral_eq_integral_of_forall_compl_eq_zero]
    intro x hx
    have hgx : g x = 0 := by
      by_contra hne
      exact hx (hcover (by simpa [Function.mem_support] using hne))
    have hproj : projectFinite h s g x = 0 := by
      unfold projectFinite
      exact Finset.sum_eq_zero fun k hk =>
        Set.indicator_of_notMem
          (fun hxk => hx (Set.mem_iUnion₂.mpr ⟨k, hk, hxk⟩)) _
    simp [hproj, hgx]
  rw [hglobal]
  calc
    ∫ x in cellUnion h s, ‖projectFinite h s g x - g x‖ ^ 2
        <= ∫ _x in cellUnion h s, C := hlocal
    _ = (volume (cellUnion h s)).toReal * C := by
      simp [MeasureTheory.measureReal_def, mul_comm]
    _ = (volume (cellUnion h s)).toReal * (L * h) ^ 2 := by rw [hC]

/-- Compactly supported globally Lipschitz fields form a strong-convergence
core for the explicit scheduled cell-average projections. -/
theorem compact_lipschitz_projectAt_tendsto_sq_error_zero
    (g : Momentum3 -> Complex) (L : Real)
    (hgK : HasCompactSupport g) (hL : 0 <= L)
    (hLip : forall x y, ‖g x - g y‖ <= L * ‖x - y‖) :
    Tendsto
      (fun N => ∫ x, ‖projectAt N g x - g x‖ ^ 2)
      atTop (nhds 0) := by
  obtain ⟨V, hV, hvolume⟩ :=
    active_cellUnion_volume_eventually_bounded hgK
  have hcover := compactSupport_eventually_covered hgK
  refine squeeze_zero' (g := fun N => V * (L * physicalSpacing N) ^ 2)
    (Filter.Eventually.of_forall fun N =>
      MeasureTheory.integral_nonneg fun x => sq_nonneg _)
    ?_ ?_
  · filter_upwards [hcover, hvolume] with N hscheduled hvol
    rw [projectAt_eq_active]
    exact le_trans
      (projectFinite_integral_sq_error_global_le
        (physicalSpacing_pos N) hL (activeModes N g) g hLip
        (support_subset_active_cellUnion N hscheduled))
      (mul_le_mul_of_nonneg_right hvol (sq_nonneg _))
  · have hlim :
        Tendsto (fun N => V * (L * physicalSpacing N) ^ 2) atTop
          (nhds (V * (L * 0) ^ 2)) :=
      tendsto_const_nhds.mul
        (Filter.Tendsto.pow
          (tendsto_const_nhds.mul physicalSpacing_tendsto_zero) 2)
    simpa using hlim

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionCompactCore
