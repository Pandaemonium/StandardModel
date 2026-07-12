import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongScaffold

/-!
# Compact-support geometry for changing momentum-cell projections

This module closes the geometric part of the strong-convergence argument for
the explicit refining/exhausting cell schedule. It proves that compact support
is eventually covered by the scheduled cells and, crucially, that the union of
the *active* cells has uniformly bounded volume. The corresponding statement
for the entire scheduled box would be false because that box expands.

The proofs were produced by Aristotle task
`ab9f7ee5-6588-4305-a3d6-d2aac7021141` and reviewed locally without changing
the target statements.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionGeometry

open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling
open ChangingMomentumCellProjection
open ChangingMomentumCellProjectionStrongScaffold
open ScaledChangingMomentumWalk

/-- A point whose coordinates lie within the physical cutoff belongs to a
scheduled momentum cell. -/
lemma mem_cellUnion_scheduledModes_of_coord_le (N : Nat) {x : Momentum3}
    (hx : forall i, |x i| <= (physicalCutoff N : Real) * physicalSpacing N) :
    x ∈ cellUnion (physicalSpacing N) (scheduledModes N) := by
  unfold cellUnion
  simp +decide [mem_scheduledModes_iff]
  refine ⟨fun i => ⌊x i / physicalSpacing N + 1 / 2⌋, ?_, ?_⟩ <;>
    norm_num [momentumCell]
  · intro i
    constructor <;> refine Int.le_of_lt_add_one ?_ <;>
      rw [← @Int.cast_lt Real] <;> norm_num
    · have hxi := hx i
      rw [abs_le] at hxi
      nlinarith [show (0 : Real) < physicalSpacing N from
          div_pos zero_lt_one (Nat.cast_add_one_pos N),
        Int.lt_floor_add_one (x i / physicalSpacing N + 1 / 2),
        mul_div_cancel₀ (x i) (ne_of_gt (show (0 : Real) < physicalSpacing N from
          div_pos zero_lt_one (Nat.cast_add_one_pos N)))]
    · exact lt_of_le_of_lt (Int.floor_le _) (by
        nlinarith [abs_le.mp (hx i),
          show (0 : Real) < physicalSpacing N from one_div_pos.mpr (by positivity),
          mul_div_cancel₀ (x i) (ne_of_gt
            (show (0 : Real) < physicalSpacing N from one_div_pos.mpr (by positivity)))])
  · intro i
    unfold cellLower cellUpper
    norm_num [physicalSpacing]
    constructor <;>
      nlinarith [Int.floor_le (x i * (N + 1) + 1 / 2),
        Int.lt_floor_add_one (x i * (N + 1) + 1 / 2),
        mul_inv_cancel_left₀ (by linarith : (N : Real) + 1 ≠ 0) (x i),
        mul_inv_cancel₀ (by linarith : (N : Real) + 1 ≠ 0)]

/-- Two points in one momentum cell differ coordinatewise by at most its side
length. -/
lemma coord_dist_le_of_mem_cell {h : Real} {k : Mode3}
    {x y : Momentum3} (hx : x ∈ momentumCell h k) (hy : y ∈ momentumCell h k)
    (i : Fin 3) : |y i - x i| <= h := by
  unfold momentumCell at hx hy
  simp_all +decide [cellLower, cellUpper]
  grind

/-- If the support is contained in a coordinate box of radius `R`, every
active cell lies in the box of radius `R + 1`. -/
lemma active_cellUnion_subset_box (N : Nat) {g : Momentum3 -> Complex}
    {R : Real}
    (hR : forall x, x ∈ Function.support g -> forall i, |x i| <= R) :
    cellUnion (physicalSpacing N) (activeModes N g) ⊆
      Set.pi Set.univ (fun _ : Fin 3 => Set.Icc (-(R + 1)) (R + 1)) := by
  intro y hy
  simp [cellUnion, activeModes] at *
  obtain ⟨k, ⟨hk, x, hxCell, hxSupport⟩, hyCell⟩ := hy
  constructor <;> intro i <;>
    have hdist := coord_dist_le_of_mem_cell hxCell hyCell i <;>
    have hxBound := hR x hxSupport i <;>
    norm_num at * <;>
    linarith [abs_le.mp hxBound,
      abs_le.mp (show |y i - x i| <= 1 from by
        linarith [show physicalSpacing N <= 1 from
          div_le_one_of_le₀ (by linarith) (by linarith)])]

/-- The real volume of the three-dimensional coordinate box of half-width
`a`. -/
lemma volume_box_toReal {a : Real} (ha : 0 <= a) :
    (volume (Set.pi Set.univ (fun _ : Fin 3 => Set.Icc (-a) a))).toReal
      = (2 * a) ^ 3 := by
  erw [MeasureTheory.Measure.pi_pi]
  norm_num [two_mul, ha]

/-- A compactly supported field is eventually covered by the explicit
refining/exhausting schedule. -/
theorem compactSupport_eventually_covered {g : Momentum3 -> Complex}
    (hgK : HasCompactSupport g) :
    ∀ᶠ N in atTop,
      Function.support g ⊆
        cellUnion (physicalSpacing N) (scheduledModes N) := by
  obtain ⟨R, hR⟩ := hgK.isCompact.isBounded.subset_closedBall (0 : Momentum3)
  have hrad : ∀ᶠ N in atTop,
      R <= (physicalCutoff N : Real) * physicalSpacing N :=
    physicalRadius_tendsto_atTop.eventually_ge_atTop R
  filter_upwards [hrad] with N hN
  intro x hx
  apply mem_cellUnion_scheduledModes_of_coord_le N
  intro i
  have hxsup : x ∈ tsupport g := subset_tsupport g hx
  have hball : x ∈ Metric.closedBall (0 : Momentum3) R := hR hxsup
  have hnorm : ‖x‖ <= R := by
    simpa [Metric.mem_closedBall, dist_eq_norm] using hball
  have hcoord : |x i| <= ‖x‖ := by
    simpa [Real.norm_eq_abs] using norm_le_pi_norm x i
  exact le_trans (le_trans hcoord hnorm) hN

/-- The volume of active cells is eventually bounded uniformly in the schedule
index for every compactly supported field. -/
theorem active_cellUnion_volume_eventually_bounded
    {g : Momentum3 -> Complex} (hgK : HasCompactSupport g) :
    exists V : Real, 0 <= V ∧
      ∀ᶠ N in atTop,
        (volume
          (cellUnion (physicalSpacing N) (activeModes N g))).toReal <= V := by
  obtain ⟨r, hr⟩ := hgK.isCompact.isBounded.subset_closedBall (0 : Momentum3)
  set R : Real := max r 0 with hRdef
  have hR0 : 0 <= R := le_max_right _ _
  have hR : forall x, x ∈ Function.support g -> forall i, |x i| <= R := by
    intro x hx i
    have hxsup : x ∈ tsupport g := subset_tsupport g hx
    have hnorm : ‖x‖ <= r := by
      simpa [Metric.mem_closedBall, dist_eq_norm] using hr hxsup
    have hcoord : |x i| <= ‖x‖ := by
      simpa [Real.norm_eq_abs] using norm_le_pi_norm x i
    exact le_trans (le_trans hcoord hnorm) (le_max_left _ _)
  refine ⟨(2 * (R + 1)) ^ 3, by positivity, ?_⟩
  filter_upwards with N
  have hsub := active_cellUnion_subset_box N (g := g) (R := R) hR
  have hmono :
      volume (cellUnion (physicalSpacing N) (activeModes N g)) <=
        volume (Set.pi Set.univ (fun _ : Fin 3 => Set.Icc (-(R + 1)) (R + 1))) :=
    measure_mono hsub
  have hfin :
      volume (Set.pi Set.univ (fun _ : Fin 3 => Set.Icc (-(R + 1)) (R + 1))) ≠ ∞ := by
    rw [volume_pi_pi]
    exact ENNReal.prod_ne_top (fun _ _ => by
      rw [Real.volume_Icc]
      exact ENNReal.ofReal_ne_top)
  calc
    (volume (cellUnion (physicalSpacing N) (activeModes N g))).toReal
        <= (volume (Set.pi Set.univ
          (fun _ : Fin 3 => Set.Icc (-(R + 1)) (R + 1)))).toReal :=
          ENNReal.toReal_mono hfin hmono
    _ = (2 * (R + 1)) ^ 3 := volume_box_toReal (by positivity)

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionGeometry
