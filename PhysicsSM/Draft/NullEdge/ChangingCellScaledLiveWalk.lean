import PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongScaffold
import PhysicsSM.Draft.NullEdge.ScaledChangingMomentumWalk

/-!
# Scaled live-walk convergence for changing-cell coefficients

This module composes the two previously separate halves of the changing-
lattice momentum program:

1. representative-safe normalized cell coefficients extracted from an actual
   four-component `L2(R^3)` field;
2. the live quartic-step `3+1` split walk evaluated at the physical center of
   every scheduled momentum cell.

The main theorem proves that the live-versus-exact coefficient error, embedded
back into the same normalized momentum cells, converges strongly to zero in
the sum of the four component `L2` norms. The coefficient family is defined
from the input field by `cellCoefficient`; it is not an arbitrary sequence or
an assumed convergent discretization.

Honest scope: the exact comparison flow is the landed momentum-space Dirac
multiplier. This module does not apply a continuum inverse Fourier transform,
identify a position-space PDE solution, or prove Lorentz restoration.

Provenance: clean-room composition of
`ChangingMomentumCellCoefficientBridge`, `ScaledChangingMomentumWalk`, and
Mathlib's Euclidean-spinor norm, July 12, 2026.
-/

noncomputable section

open scoped BigOperators ENNReal Matrix.Norms.L2Operator
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk

open ChangingMomentumCellIsometry
open ChangingMomentumCellCoefficientBridge
open ChangingMomentumCellProjectionStrongScaffold
open ChangingModeEmbedding
open ScaledChangingMomentumWalk
open Compact3Plus1DiracRate

/-- Four-component coefficient space used by the live matrix walk. -/
abbrev Spinor := EuclideanSpace Complex (Fin 4)

/-- Coordinate bridge between the cell code's functional `Z^3` presentation
and the walk code's nested-product presentation. -/
def mode3Equiv : Mode3 ≃ Mode where
  toFun k := ((k 0, k 1), k 2)
  invFun k := ![k.1.1, k.1.2, k.2]
  left_inv k := by
    funext i
    fin_cases i <;> rfl
  right_inv k := rfl

/-- The scheduled functional cube is exactly the walk's nested-product mode
box after the coordinate bridge. -/
theorem mem_scheduledModes_iff_modeBox (N : Nat) (k : Mode3) :
    k ∈ scheduledModes N ↔
      mode3Equiv k ∈ modeBox (physicalCutoff N) := by
  rw [mem_scheduledModes_iff, mem_modeBox_iff]
  constructor
  · intro h
    exact ⟨h 0, h 1, h 2⟩
  · rintro ⟨h0, h1, h2⟩ i
    fin_cases i
    · exact h0
    · exact h1
    · exact h2

/-- The actual normalized spinor coefficient extracted from one momentum
cell, component by component. -/
def spinorCellCoefficient (N : Nat) (F : Momentum3 -> Spinor)
    (k : Mode3) : Spinor :=
  (EuclideanSpace.equiv (Fin 4) Complex).symm
    (fun j => cellCoefficient (physicalSpacing N) k (fun x => F x j))

/-- Euclidean spinor norm squared is the sum of its four coordinate norm
squares. -/
theorem spinor_norm_sq_eq_sum (v : Spinor) :
    ‖v‖ ^ 2 = ∑ j : Fin 4, ‖v j‖ ^ 2 := by
  rw [EuclideanSpace.norm_eq]
  exact Real.sq_sqrt (Finset.sum_nonneg fun _ _ => sq_nonneg _)

/-- The normalized spinor cell coefficient has exactly the sum of the four
scalar coefficient energies. -/
theorem spinorCellCoefficient_norm_sq (N : Nat)
    (F : Momentum3 -> Spinor) (k : Mode3) :
    ‖spinorCellCoefficient N F k‖ ^ 2 =
      ∑ j : Fin 4,
        ‖cellCoefficient (physicalSpacing N) k (fun x => F x j)‖ ^ 2 := by
  rw [spinor_norm_sq_eq_sum]
  rfl

/-- The scheduled spinor coefficients inherit the sum of the four scalar
`L2` energy bounds. -/
theorem spinorCellCoefficient_energy_le
    (N : Nat) (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    (∑ k ∈ scheduledModes N, ‖spinorCellCoefficient N F k‖ ^ 2) <=
      ∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2 := by
  calc
    (∑ k ∈ scheduledModes N, ‖spinorCellCoefficient N F k‖ ^ 2) =
        ∑ k ∈ scheduledModes N, ∑ j : Fin 4,
          ‖cellCoefficient (physicalSpacing N) k (fun x => F x j)‖ ^ 2 := by
      apply Finset.sum_congr rfl
      intro k hk
      exact spinorCellCoefficient_norm_sq N F k
    _ = ∑ j : Fin 4, ∑ k ∈ scheduledModes N,
          ‖cellCoefficient (physicalSpacing N) k (fun x => F x j)‖ ^ 2 := by
      rw [Finset.sum_comm]
    _ <= ∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2 := by
      apply Finset.sum_le_sum
      intro j hj
      exact coefficient_energy_le_input (physicalSpacing_pos N)
        (scheduledModes N) (fun x => F x j)
        (fun k hk => memLp_two_integrableOn_momentumCell
          (hF j) (physicalSpacing N) k)
        (memLp_two_integrable_norm_sq (hF j))

/-- The explicit common operator-error rate for the scaled scheduled box. -/
def scaledCellRate (t : Real) (M N : Nat) : Real :=
  2 * t ^ 2 / (scaledWindow M N : Real) ^ 2 *
    Real.exp (|t| / (scaledWindow M N : Real) ^ 3)

theorem scaledCellRate_nonneg (t : Real) (M N : Nat) :
    0 <= scaledCellRate t M N := by
  unfold scaledCellRate
  positivity

theorem scaledCellRate_tendsto_zero (t : Real) (M : Nat) :
    Tendsto (fun N => scaledCellRate t M N) atTop (nhds 0) := by
  simpa [scaledCellRate] using scaled_box_rate_tendsto_zero t M

/-- Live split-versus-exact error for the coefficient extracted from one
scheduled cell. -/
def scaledCellModeError (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) (k : Mode3) : Spinor :=
  let q := mode3Equiv k
  let A :=
    (splitStep (scaledMomentum N q 0) (scaledMomentum N q 1)
      (scaledMomentum N q 2) m
      (t / (scaledSteps M N : Real))) ^ scaledSteps M N
  let B := exactFlow (scaledMomentum N q 0) (scaledMomentum N q 1)
    (scaledMomentum N q 2) m t
  (EuclideanSpace.equiv (Fin 4) Complex).symm
    ((A - B).mulVec (spinorCellCoefficient N F k))

/-- Each actual cell-derived coefficient error obeys the common scaled-box
operator rate. -/
theorem scaledCellModeError_norm_le
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (F : Momentum3 -> Spinor) (k : Mode3) (hk : k ∈ scheduledModes N) :
    ‖scaledCellModeError m t M N F k‖ <=
      scaledCellRate t M N * ‖spinorCellCoefficient N F k‖ := by
  have hbox : mode3Equiv k ∈ modeBox (physicalCutoff N) :=
    (mem_scheduledModes_iff_modeBox N k).1 hk
  have hmatrix := scaled_box_many_step_bound m t M N hm (mode3Equiv k) hbox
  have hop := Matrix.l2_opNorm_mulVec
    ((splitStep
      (scaledMomentum N (mode3Equiv k) 0)
      (scaledMomentum N (mode3Equiv k) 1)
      (scaledMomentum N (mode3Equiv k) 2) m
      (t / (scaledSteps M N : Real))) ^ scaledSteps M N -
      exactFlow
        (scaledMomentum N (mode3Equiv k) 0)
        (scaledMomentum N (mode3Equiv k) 1)
        (scaledMomentum N (mode3Equiv k) 2) m t)
    (spinorCellCoefficient N F k)
  exact le_trans (by simpa [scaledCellModeError] using hop)
    (mul_le_mul_of_nonneg_right hmatrix (norm_nonneg _))

/-- The total scheduled coefficient error is bounded by the common live rate
times the actual field-derived coefficient energy. -/
theorem scaledCellModeError_energy_le
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    (∑ k ∈ scheduledModes N, ‖scaledCellModeError m t M N F k‖ ^ 2) <=
      (scaledCellRate t M N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2) := by
  calc
    (∑ k ∈ scheduledModes N, ‖scaledCellModeError m t M N F k‖ ^ 2) <=
        ∑ k ∈ scheduledModes N,
          (scaledCellRate t M N * ‖spinorCellCoefficient N F k‖) ^ 2 := by
      apply Finset.sum_le_sum
      intro k hk
      exact pow_le_pow_left₀ (norm_nonneg _)
        (scaledCellModeError_norm_le m t M N hm F k hk) 2
    _ = (scaledCellRate t M N) ^ 2 *
        (∑ k ∈ scheduledModes N, ‖spinorCellCoefficient N F k‖ ^ 2) := by
      simp_rw [mul_pow, Finset.mul_sum]
    _ <= (scaledCellRate t M N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2) := by
      exact mul_le_mul_of_nonneg_left
        (spinorCellCoefficient_energy_le N F hF) (sq_nonneg _)

/-- The actual scaled live-walk coefficient error tends strongly to zero for
the normalized coefficients extracted from every four-coordinate `L2` field. -/
theorem scaledCellModeError_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    Tendsto
      (fun N => ∑ k ∈ scheduledModes N,
        ‖scaledCellModeError m t M N F k‖ ^ 2)
      atTop (nhds 0) := by
  let C : Real := ∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2
  refine squeeze_zero
    (fun N => Finset.sum_nonneg fun _ _ => sq_nonneg _)
    (fun N => scaledCellModeError_energy_le m t M N hm F hF) ?_
  have hr := (scaledCellRate_tendsto_zero t M).pow 2
  simpa [C] using hr.mul_const C

/-- Re-embed one scalar coordinate of the live coefficient error into the
same normalized momentum cells used by the input projection. -/
def embeddedErrorComponent (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) (j : Fin 4) : Momentum3 -> Complex :=
  embedFinite (physicalSpacing N) (scheduledModes N)
    (fun k => scaledCellModeError m t M N F k j)

/-- Componentwise cell isometry identifies the embedded error energy with
the spinor coefficient error exactly. -/
theorem embeddedError_energy_eq
    (m t : Real) (M N : Nat) (F : Momentum3 -> Spinor) :
    (∑ j : Fin 4, ∫ x, ‖embeddedErrorComponent m t M N F j x‖ ^ 2) =
      ∑ k ∈ scheduledModes N, ‖scaledCellModeError m t M N F k‖ ^ 2 := by
  simp_rw [embeddedErrorComponent,
    embedFinite_isometry (physicalSpacing_pos N)]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro k hk
  exact (spinor_norm_sq_eq_sum (scaledCellModeError m t M N F k)).symm

/-- **Changing-cell live-walk composition.** The actual cell-derived live
error, embedded in the refining momentum cells, converges strongly to zero. -/
theorem embeddedScaledLiveError_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    Tendsto
      (fun N => ∑ j : Fin 4,
        ∫ x, ‖embeddedErrorComponent m t M N F j x‖ ^ 2)
      atTop (nhds 0) := by
  apply (scaledCellModeError_tendsto_zero m t M hm F hF).congr'
  exact Filter.Eventually.of_forall fun N =>
    (embeddedError_energy_eq m t M N F).symm

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk.mem_scheduledModes_iff_modeBox' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mem_scheduledModes_iff_modeBox

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk.spinorCellCoefficient_energy_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spinorCellCoefficient_energy_le

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk.scaledCellModeError_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scaledCellModeError_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk.embeddedScaledLiveError_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms embeddedScaledLiveError_tendsto_zero

end PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk
