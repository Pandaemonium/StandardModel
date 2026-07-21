import PhysicsSM.Draft.NullEdge.ChangingMomentumCellIsometry

/-!
# Concrete cell-sampling convergence on `R^3`

This is the dense-core analytic rung of D-R3-4.  The existing changing-cell
module proves the exact coefficient-to-function isometry.  Here we approximate
a compactly supported Lipschitz momentum field by its values at the centers of
the occupied half-open cells.

The explicit `h / 2` geometric estimate yields a global squared-`L2` rate. The
final theorem is deliberately scoped to a fixed Lipschitz field and an
arbitrary changing finite cover with uniformly bounded physical volume.
Density and inverse-Fourier composition remain successor rungs.

Provenance: target architecture by Codex; proofs by Aristotle project
`6895852f-593b-4ab1-8832-9b1b424d3e20`, independently rebuilt locally on
July 11, 2026.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling

open ChangingMomentumCellIsometry

/-- Physical center `h k` of a changing momentum cell. -/
def cellCenter (h : Real) (k : Mode3) : Momentum3 :=
  fun i => h * (k i : Real)

/-- Finite piecewise-constant sampling of a continuum momentum field. -/
def sampleFinite (h : Real) (s : Finset Mode3)
    (f : Momentum3 -> Complex) : Momentum3 -> Complex :=
  fun x => ∑ k ∈ s,
    (momentumCell h k).indicator (fun _ => f (cellCenter h k)) x

/-- The finite physical region represented by the selected cells. -/
def cellUnion (h : Real) (s : Finset Mode3) : Set Momentum3 :=
  ⋃ k ∈ s, momentumCell h k

/-- A cell center belongs to its own half-open cell. -/
lemma cellCenter_mem {h : Real} (hh : 0 < h) (k : Mode3) :
    cellCenter h k ∈ momentumCell h k := by
  exact fun i _ => ⟨ by norm_num [ cellCenter, cellLower ] ; linarith, by norm_num [ cellCenter, cellUpper ] ; linarith ⟩

/-- Every coordinate of a cell point is within `h/2` of its center. -/
lemma mem_momentumCell_coord_error {h : Real} {k : Mode3} {x : Momentum3}
    (hx : x ∈ momentumCell h k) (i : Fin 3) :
    |x i - cellCenter h k i| <= h / 2 := by
  rw [ abs_le ] ; constructor <;> linarith! [ Set.mem_Ico.mp ( hx i ( Set.mem_univ i ) ), show cellCenter h k i = h * ( k i : ℝ ) from rfl, show cellLower h k i = h * ( ( k i : ℝ ) - 1 / 2 ) from rfl, show cellUpper h k i = h * ( ( k i : ℝ ) + 1 / 2 ) from rfl ] ;

/-- With the product sup norm, a cell has radius at most `h/2`. -/
lemma mem_momentumCell_norm_error {h : Real} (hh : 0 < h)
    {k : Mode3} {x : Momentum3} (hx : x ∈ momentumCell h k) :
    ‖x - cellCenter h k‖ <= h / 2 := by
  exact pi_norm_le_iff_of_nonneg ( by linarith ) |>.2 fun i => by simpa using mem_momentumCell_coord_error hx i;

/-- On a selected cell, disjointness reduces the finite sampler to the value
at that cell's center. -/
lemma sampleFinite_eq_center {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 -> Complex) {k : Mode3}
    (hk : k ∈ s) {x : Momentum3} (hx : x ∈ momentumCell h k) :
    sampleFinite h s f x = f (cellCenter h k) := by
  unfold sampleFinite;
  rw [ Finset.sum_eq_single k ];
  · exact Set.indicator_of_mem hx _;
  · exact fun q hq hqk => Set.indicator_of_notMem ( fun hq' => Set.disjoint_left.mp ( momentumCell_disjoint hh hqk.symm ) hx hq' ) _;
  · aesop

lemma cellUnion_measurable (h : Real) (s : Finset Mode3) :
    MeasurableSet (cellUnion h s) := by
  exact MeasurableSet.biUnion ( Finset.countable_toSet s ) fun k hk => momentumCell_measurable h k

/-- Disjoint half-open cells make the represented physical volume exactly
`card(s) * h^3`. -/
theorem volume_cellUnion_toReal {h : Real} (hh : 0 < h)
    (s : Finset Mode3) :
    (volume (cellUnion h s)).toReal = (s.card : Real) * h ^ 3 := by
  have h_volume : volume (cellUnion h s) = ∑ k ∈ s, volume (momentumCell h k) := by
    convert MeasureTheory.measure_biUnion_finset _ _;
    · exact fun x hx y hy hxy => momentumCell_disjoint hh hxy;
    · exact fun _ _ => momentumCell_measurable h _;
  rw [ h_volume, ENNReal.toReal_sum, Finset.sum_congr rfl fun x hx => volume_momentumCell_toReal hh x ] ; norm_num;
  exact fun k hk => volume_momentumCell_ne_top h k

/-- Pointwise Lipschitz error on every represented cell. -/
theorem sampleFinite_pointwise_error {h L : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 -> Complex)
    (hLip : ∀ x y, ‖f x - f y‖ <= L * ‖x - y‖)
    {x : Momentum3} (hx : x ∈ cellUnion h s) :
    ‖sampleFinite h s f x - f x‖ <= L * (h / 2) := by
  obtain ⟨k, hk, hxk⟩ : ∃ k ∈ s, x ∈ momentumCell h k := by
    unfold cellUnion at hx; aesop;
  rw [ sampleFinite_eq_center hh s f hk hxk ];
  refine' le_trans ( hLip _ _ ) _;
  gcongr;
  · contrapose! hLip;
    refine' ⟨ 0, fun _ => 1, _ ⟩ ; norm_num [ hLip ];
    exact hLip.trans_le ( norm_nonneg _ );
  · simpa only [ norm_sub_rev ] using mem_momentumCell_norm_error hh hxk

/-- Explicit local squared-`L2` sampling error. -/
theorem integral_sq_error_cellUnion_le {h L : Real} (hh : 0 < h)
    (hL : 0 <= L) (s : Finset Mode3) (f : Momentum3 -> Complex)
    (hLip : ∀ x y, ‖f x - f y‖ <= L * ‖x - y‖) :
    ∫ x in cellUnion h s, ‖sampleFinite h s f x - f x‖ ^ 2 <=
      ((s.card : Real) * h ^ 3) * (L * (h / 2)) ^ 2 := by
  -- Let C := (L*(h/2))^2 ≥ 0 (positivity, using hL, hh). Write g := fun x => ‖sampleFinite h s f x - f x‖^2.
  set C := (L * (h / 2)) ^ 2 with hC_def
  have hC_nonneg : 0 ≤ C := by
    positivity;
  -- Step 1 (continuity/measurability of f): f is Lipschitz from hLip with constant L (L ≥ 0 by hL), hence Continuous; extract hcontf : Continuous f (build LipschitzWith L.toNNReal f via edist_dist/dist_eq_norm as usual, then .continuous). So f is measurable.
  have hcontf : Continuous f := by
    refine' Metric.continuous_iff.mpr _;
    exact fun x ε εpos => ⟨ ε / ( L + 1 ), div_pos εpos ( by positivity ), fun y hy => by rw [ dist_eq_norm ] at *; exact lt_of_le_of_lt ( hLip _ _ ) ( by rw [ lt_div_iff₀ ] at * <;> nlinarith [ norm_nonneg ( y - x ) ] ) ⟩;
  have h_integral_mono : ∫ x in cellUnion h s, ‖sampleFinite h s f x - f x‖ ^ 2 ≤ ∫ x in cellUnion h s, C := by
    refine' MeasureTheory.integral_mono_of_nonneg _ _ _;
    · exact Filter.Eventually.of_forall fun x => sq_nonneg _;
    · apply_rules [ MeasureTheory.integrable_const ];
      constructor ; norm_num;
      refine' lt_of_le_of_lt ( MeasureTheory.measure_biUnion_finset_le _ _ ) _;
      refine' ENNReal.sum_lt_top.mpr _;
      exact fun k hk => lt_top_iff_ne_top.mpr ( volume_momentumCell_ne_top h k );
    · filter_upwards [ MeasureTheory.ae_restrict_mem ( cellUnion_measurable h s ) ] with x hx using pow_le_pow_left₀ ( norm_nonneg _ ) ( sampleFinite_pointwise_error hh s f hLip hx ) 2;
  convert h_integral_mono using 1;
  simp +decide [ mul_assoc ];
  rw [ show volume.real ( cellUnion h s ) = s.card * h ^ 3 by simpa [ mul_assoc, mul_comm, mul_left_comm ] using volume_cellUnion_toReal hh s ] ; ring

/-- If the selected cells cover the support, the same estimate is global. -/
theorem integral_sq_error_global_le {h L : Real} (hh : 0 < h)
    (hL : 0 <= L) (s : Finset Mode3) (f : Momentum3 -> Complex)
    (hLip : ∀ x y, ‖f x - f y‖ <= L * ‖x - y‖)
    (hcover : Function.support f ⊆ cellUnion h s) :
    ∫ x, ‖sampleFinite h s f x - f x‖ ^ 2 <=
      ((s.card : Real) * h ^ 3) * (L * (h / 2)) ^ 2 := by
  convert integral_sq_error_cellUnion_le hh hL s f hLip using 1;
  rw [ MeasureTheory.setIntegral_eq_integral_of_forall_compl_eq_zero ];
  intro x hx; rw [ show sampleFinite h s f x = 0 from ?_ ] ; simp +decide [ show f x = 0 from by_contra fun h => hx <| hcover <| by simpa using h ] ;
  exact Finset.sum_eq_zero fun k hk => Set.indicator_of_notMem ( fun hk' => hx <| Set.mem_iUnion₂.mpr ⟨ k, hk, hk' ⟩ ) _

/-- **Dense-core changing-cell convergence.**  Any positive mesh tending to
zero gives strong squared-`L2` convergence for a fixed compactly supported
Lipschitz field, provided the chosen finite cells cover its support and have
uniformly bounded physical volume.

The theorem is nonvacuous for the explicit schedule used by
`ScaledChangingMomentumWalk`; constructing that schedule's finite cover and
then extending by `L2` density are the next composition steps. -/
theorem sampleFinite_tendsto_sq_error_zero
    (h : Nat -> Real) (s : Nat -> Finset Mode3)
    (f : Momentum3 -> Complex) (L V : Real)
    (hh : ∀ n, 0 < h n) (hh0 : Tendsto h atTop (nhds 0))
    (hL : 0 <= L)
    (hLip : ∀ x y, ‖f x - f y‖ <= L * ‖x - y‖)
    (hcover : ∀ n, Function.support f ⊆ cellUnion (h n) (s n))
    (hvolume : ∀ n, ((s n).card : Real) * (h n) ^ 3 <= V) :
    Tendsto
      (fun n => ∫ x, ‖sampleFinite (h n) (s n) f x - f x‖ ^ 2)
      atTop (nhds 0) := by
  refine squeeze_zero (g := fun n => V * (L * (h n / 2)) ^ 2)
    (fun n => MeasureTheory.integral_nonneg fun x => by positivity)
    (fun n => ?_) ?_
  · exact le_trans (integral_sq_error_global_le (hh n) hL (s n) f hLip (hcover n))
      (mul_le_mul_of_nonneg_right (hvolume n) (sq_nonneg _))
  · have hlim :
        Tendsto (fun n => V * (L * (h n / 2)) ^ 2) atTop (nhds (V * (L * (0 / 2)) ^ 2)) :=
      tendsto_const_nhds.mul (Filter.Tendsto.pow (tendsto_const_nhds.mul (hh0.div_const 2)) 2)
    simpa using hlim

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling.integral_sq_error_global_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms integral_sq_error_global_le

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling.sampleFinite_tendsto_sq_error_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sampleFinite_tendsto_sq_error_zero

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling
