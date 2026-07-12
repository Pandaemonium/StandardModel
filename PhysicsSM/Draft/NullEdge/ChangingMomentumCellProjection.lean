import PhysicsSM.Draft.NullEdge.ChangingMomentumPointSamplerNoGo

/-!
# Finite normalized cell-average projection

This module replaces center values by normalized cell averages in the finite
piecewise-constant momentum reconstruction.  Unlike the center sampler, the
result is invariant under almost-everywhere equality.  It also reproduces the
constant-one function on every selected cell and carries an explicit wrong-
scaling control for an unnormalized integral.

The `L2` contraction and strong changing-mesh convergence are successor
theorems.  No live-walk or inverse-Fourier composition is claimed here.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjection

open ChangingMomentumCellIsometry
open ChangingMomentumPointSamplerNoGo

/-- Piecewise-constant finite projection using one normalized average per
selected half-open momentum cell. -/
def projectFinite (h : Real) (s : Finset Mode3)
    (f : Momentum3 → Complex) : Momentum3 → Complex :=
  fun x => ∑ k ∈ s,
    (momentumCell h k).indicator (fun _ => cellAverage h k f) x

/-- The finite projection is representative-independent. -/
theorem projectFinite_congr_ae {h : Real} {s : Finset Mode3}
    {f g : Momentum3 → Complex} (hfg : f =ᵐ[volume] g) :
    projectFinite h s f = projectFinite h s g := by
  funext x
  unfold projectFinite
  apply Finset.sum_congr rfl
  intro k hk
  rw [cellAverage_congr_ae hfg]

/-- On a selected cell, disjointness reduces the projection to that cell's
normalized average. -/
theorem projectFinite_eq_average {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 → Complex) {k : Mode3}
    (hk : k ∈ s) {x : Momentum3} (hx : x ∈ momentumCell h k) :
    projectFinite h s f x = cellAverage h k f := by
  unfold projectFinite
  rw [Finset.sum_eq_single k]
  · exact Set.indicator_of_mem hx _
  · intro q hq hqk
    exact Set.indicator_of_notMem
      (fun hxq => Set.disjoint_left.mp (momentumCell_disjoint hh hqk.symm) hx hxq) _
  · exact fun hn => (hn hk).elim

/-- Nonzero normalization: the projection of one is exactly one on every
selected cell. -/
theorem projectFinite_const_one_on_cell {h : Real} (hh : 0 < h)
    (s : Finset Mode3) {k : Mode3} (hk : k ∈ s)
    {x : Momentum3} (hx : x ∈ momentumCell h k) :
    projectFinite h s (fun _ => (1 : Complex)) x = 1 := by
  rw [projectFinite_eq_average hh s _ hk hx, cellAverage_const_one hh]

/-- Unnormalized integral of the constant-one function over one cell. -/
def rawCellIntegral (h : Real) (k : Mode3) : Complex :=
  ∫ _ in momentumCell h k, (1 : Complex)

theorem rawCellIntegral_const_one {h : Real} (hh : 0 < h) (k : Mode3) :
    rawCellIntegral h k = (h ^ 3 : Real) := by
  unfold rawCellIntegral
  rw [MeasureTheory.setIntegral_const, MeasureTheory.measureReal_def,
    volume_momentumCell_toReal hh k]
  simp

/-- Wrong-scaling control: at mesh two the unnormalized integral is eight,
not one. -/
theorem rawCellIntegral_two_control (k : Mode3) :
    rawCellIntegral 2 k = 8 ∧ rawCellIntegral 2 k ≠ 1 := by
  constructor
  · norm_num [rawCellIntegral_const_one (by norm_num : (0 : Real) < 2) k]
  · rw [rawCellIntegral_const_one (by norm_num : (0 : Real) < 2) k]
    norm_num

/-! ## Assumption-footprint audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjection.projectFinite_congr_ae' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectFinite_congr_ae

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjection.projectFinite_const_one_on_cell' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectFinite_const_one_on_cell

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjection.rawCellIntegral_two_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rawCellIntegral_two_control

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjection
