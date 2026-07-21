import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionL2

/-!
# Exact coefficient bridge for changing momentum-cell projections

The representative-safe projection stores a constant cell average on each
selected momentum cell. The normalized coefficient seen by the landed
`L2(R^3)` cell embedding is therefore not the bare average: it is the average
multiplied by the square root of the cell volume.

This module proves that normalization exactly. The resulting coefficient
embedding is pointwise equal to `projectFinite`, and its finite coefficient
energy is exactly the projected `L2` energy. A mesh-two control shows that the
bare average has energy one while the represented constant cell has energy
eight, so omitting the square-root-volume factor is a genuine normalization
error.

This is the first rung of `CONT-LIVE-001`. It identifies the coefficients that
must be supplied to the scaled live walk, but it does not yet evolve them,
apply an inverse Fourier transform, or prove a position-space PDE limit.

Provenance: clean-room composition of the project definitions
`cellAverage`, `cellPacket`, `embedFinite`, and `projectFinite`, July 12, 2026.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge

open ChangingMomentumCellIsometry
open ChangingMomentumPointSamplerNoGo
open ChangingMomentumCellProjection
open ChangingMomentumCellProjectionL2

/-- The normalized coefficient represented by one constant momentum cell. -/
def cellCoefficient (h : Real) (k : Mode3)
    (f : Momentum3 -> Complex) : Complex :=
  (Real.sqrt (h ^ 3) : Complex) * cellAverage h k f

/-- One normalized coefficient packet is exactly the corresponding constant
cell-average contribution to `projectFinite`. -/
theorem cellPacket_cellCoefficient {h : Real} (hh : 0 < h)
    (k : Mode3) (f : Momentum3 -> Complex) :
    cellPacket h k (cellCoefficient h k f) =
      (momentumCell h k).indicator (fun _ => cellAverage h k f) := by
  funext x
  by_cases hx : x ∈ momentumCell h k
  · rw [cellPacket, Set.indicator_of_mem hx, Set.indicator_of_mem hx]
    have hs : Real.sqrt (h ^ 3) ≠ 0 :=
      ne_of_gt (Real.sqrt_pos.2 (pow_pos hh 3))
    have hsC : (Real.sqrt (h ^ 3) : Complex) ≠ 0 := by
      exact_mod_cast hs
    unfold cellScale cellCoefficient
    push_cast
    rw [← mul_assoc]
    rw [inv_mul_cancel₀ hsC, one_mul]
  · simp [cellPacket, hx]

/-- The normalized finite coefficient embedding reconstructs the
representative-safe cell-average projection pointwise. -/
theorem embedFinite_cellCoefficient {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 -> Complex) :
    embedFinite h s (fun k => cellCoefficient h k f) =
      projectFinite h s f := by
  funext x
  unfold embedFinite projectFinite
  apply Finset.sum_congr rfl
  intro k hk
  rw [cellPacket_cellCoefficient hh k f]

/-- The squared norm of one normalized coefficient is cell volume times the
squared norm of its average. -/
theorem norm_sq_cellCoefficient {h : Real} (hh : 0 < h)
    (k : Mode3) (f : Momentum3 -> Complex) :
    ‖cellCoefficient h k f‖ ^ 2 =
      (volume (momentumCell h k)).toReal * ‖cellAverage h k f‖ ^ 2 := by
  rw [volume_momentumCell_toReal hh k]
  simp only [cellCoefficient, norm_mul, Complex.norm_real,
    mul_pow]
  rw [Real.norm_eq_abs, abs_of_nonneg (Real.sqrt_nonneg _)]
  rw [Real.sq_sqrt (le_of_lt (pow_pos hh 3))]

/-- Finite coefficient energy is exactly the projected continuum `L2`
energy. -/
theorem coefficient_energy_eq_projectFinite {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 -> Complex) :
    (∑ k ∈ s, ‖cellCoefficient h k f‖ ^ 2) =
      ∫ x, ‖projectFinite h s f x‖ ^ 2 := by
  rw [integral_norm_sq_projectFinite_eq_sum hh s f]
  apply Finset.sum_congr rfl
  intro k hk
  exact norm_sq_cellCoefficient hh k f

/-- The exact coefficient family inherits the projection's `L2` contraction. -/
theorem coefficient_energy_le_input {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 -> Complex)
    (hf : ∀ k, k ∈ s -> IntegrableOn f (momentumCell h k))
    (hf2 : Integrable (fun x => ‖f x‖ ^ 2)) :
    (∑ k ∈ s, ‖cellCoefficient h k f‖ ^ 2) <=
      ∫ x, ‖f x‖ ^ 2 := by
  rw [coefficient_energy_eq_projectFinite hh s f]
  exact projectFinite_L2_contraction hh s f hf hf2

/-- Nonzero normalization witness: a constant field gives coefficient
`sqrt(h^3)` on every cell. -/
theorem cellCoefficient_const_one {h : Real} (hh : 0 < h) (k : Mode3) :
    cellCoefficient h k (fun _ => (1 : Complex)) = Real.sqrt (h ^ 3) := by
  rw [cellCoefficient, cellAverage_const_one hh]
  simp

/-- The constant-cell normalization witness is genuinely nonzero at every
positive mesh size. -/
theorem cellCoefficient_const_one_ne_zero {h : Real} (hh : 0 < h)
    (k : Mode3) :
    cellCoefficient h k (fun _ => (1 : Complex)) ≠ 0 := by
  rw [cellCoefficient_const_one hh]
  exact_mod_cast ne_of_gt (Real.sqrt_pos.2 (pow_pos hh 3))

/-- Wrong-normalization control. At mesh two, the bare cell average has
coefficient energy one, while the constant represented cell has `L2` energy
eight. -/
theorem bare_average_wrong_energy_two (k : Mode3) :
    ‖cellAverage 2 k (fun _ => (1 : Complex))‖ ^ 2 = 1 ∧
      (∫ x, ‖projectFinite 2 {k} (fun _ => (1 : Complex)) x‖ ^ 2) = 8 := by
  constructor
  · rw [cellAverage_const_one (by norm_num : (0 : Real) < 2)]
    norm_num
  · rw [integral_norm_sq_projectFinite_eq_sum
      (by norm_num : (0 : Real) < 2)]
    simp [cellAverage_const_one (by norm_num : (0 : Real) < 2),
      volume_momentumCell_toReal (by norm_num : (0 : Real) < 2)]
    norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge.embedFinite_cellCoefficient' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms embedFinite_cellCoefficient

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge.coefficient_energy_eq_projectFinite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coefficient_energy_eq_projectFinite

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge.coefficient_energy_le_input' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coefficient_energy_le_input

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge.bare_average_wrong_energy_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bare_average_wrong_energy_two

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge.cellCoefficient_const_one_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cellCoefficient_const_one_ne_zero

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge
