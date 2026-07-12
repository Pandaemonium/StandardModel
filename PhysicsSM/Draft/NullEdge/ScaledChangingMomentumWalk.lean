import PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate
import PhysicsSM.Draft.NullEdge.ChangingModeEmbedding
import PhysicsSM.Draft.NullEdge.ChangingMomentumBoxExhaustion
import PhysicsSM.Draft.NullEdge.SobolevTailRate

/-!
# Scaled live walk on an exhausting momentum grid

This module closes the modewise part of D-R3-3 with one explicit joint
schedule. At level `N`, the momentum spacing is `1 / (N + 1)`, the integer
cutoff is `(N + 1)^2`, and the physical box radius is therefore exactly
`N + 1`. The live split walk uses a quartic number of microscopic substeps in
a window large enough to contain every scaled retained momentum.

The result is a uniform, vanishing matrix-error bound over the complete
changing momentum box. It does not yet construct cell-average coefficients,
prove convergence of the piecewise-constant embedding to an arbitrary
`L2(R^3)` field, or apply the inverse Fourier isometry. Those are D-R3-4.

Provenance: clean-room composition of the repository's exact refined
many-step estimate and changing-box infrastructure, July 11, 2026.
-/

noncomputable section

open Filter Topology
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.ScaledChangingMomentumWalk

open ChangingModeEmbedding
open Compact3Plus1DiracRate
open Compact3Plus1GrowingWindowRate
open SobolevTailRate

/-- Momentum spacing at refinement level `N`. -/
def physicalSpacing (N : Nat) : Real := 1 / (N + 1 : Real)

/-- Integer-mode cutoff at refinement level `N`. -/
def physicalCutoff (N : Nat) : Nat := (N + 1) ^ 2

/-- A positive `B4` window containing the scaled cutoff and a mass bound. -/
def scaledWindow (M N : Nat) : Nat := 3 * (N + 1) + M + 1

/-- Quartic microscopic substep count for the scaled window. -/
def scaledSteps (M N : Nat) : Nat := scaledWindow M N ^ 4

/-- The physical momentum represented by an integer mode. -/
def scaledMomentum (N : Nat) (k : Mode) : Fin 3 -> Real :=
  fun
  | 0 => physicalSpacing N * (k.1.1 : Real)
  | 1 => physicalSpacing N * (k.1.2 : Real)
  | 2 => physicalSpacing N * (k.2 : Real)

/-- Positive x-face mode of the changing integer box. -/
def boundaryMode (N : Nat) : Mode :=
  ((((physicalCutoff N : Nat) : Int), 0), 0)

theorem physicalSpacing_pos (N : Nat) : 0 < physicalSpacing N := by
  unfold physicalSpacing
  positivity

/-- The momentum spacing tends to zero. -/
theorem physicalSpacing_tendsto_zero :
    Tendsto physicalSpacing atTop (nhds 0) := by
  simpa [physicalSpacing] using tendsto_one_div_add_atTop_nhds_zero_nat

/-- The physical radius of the represented momentum box is exactly `N+1`. -/
theorem physicalCutoff_mul_spacing (N : Nat) :
    (physicalCutoff N : Real) * physicalSpacing N = (N + 1 : Real) := by
  have h : (N + 1 : Real) ≠ 0 := by positivity
  simp only [physicalCutoff, physicalSpacing, Nat.cast_pow, Nat.cast_add,
    Nat.cast_one]
  field_simp

/-- The represented physical momentum boxes exhaust `R^3`. -/
theorem physicalRadius_tendsto_atTop :
    Tendsto (fun N : Nat =>
      (physicalCutoff N : Real) * physicalSpacing N) atTop atTop := by
  simp_rw [physicalCutoff_mul_spacing]
  exact Filter.tendsto_atTop_add_const_right _ _ tendsto_natCast_atTop_atTop

lemma abs_scaled_coord_le_level (N : Nat) (x : Int)
    (hx : x.natAbs <= physicalCutoff N) :
    |physicalSpacing N * (x : Real)| <= (N + 1 : Real) := by
  have hxR : |(x : Real)| <= (physicalCutoff N : Real) := by
    rw [← Int.cast_abs, Int.abs_eq_natAbs]
    exact_mod_cast hx
  have hs0 : 0 <= physicalSpacing N := (physicalSpacing_pos N).le
  rw [abs_mul, abs_of_nonneg hs0]
  calc
    physicalSpacing N * |(x : Real)| <=
        physicalSpacing N * (physicalCutoff N : Real) :=
      mul_le_mul_of_nonneg_left hxR hs0
    _ = (N + 1 : Real) := by rw [mul_comm, physicalCutoff_mul_spacing]

/-- Every retained integer mode lies in the declared scaled `B4` window. -/
theorem scaled_mode_B4_le_window
    (m : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (k : Mode) (hk : k ∈ modeBox (physicalCutoff N)) :
    B4 (scaledMomentum N k 0) (scaledMomentum N k 1)
        (scaledMomentum N k 2) m <= (scaledWindow M N : Real) := by
  have hr : modeRadius k <= physicalCutoff N :=
    (mem_modeBox_iff_radius_le k (physicalCutoff N)).1 hk
  have hxNat : k.1.1.natAbs <= physicalCutoff N :=
    (Nat.le_max_left _ _).trans ((Nat.le_max_left _ _).trans hr)
  have hyNat : k.1.2.natAbs <= physicalCutoff N :=
    (Nat.le_max_right _ _).trans ((Nat.le_max_left _ _).trans hr)
  have hzNat : k.2.natAbs <= physicalCutoff N :=
    (Nat.le_max_right _ _).trans hr
  have hx := abs_scaled_coord_le_level N k.1.1 hxNat
  have hy := abs_scaled_coord_le_level N k.1.2 hyNat
  have hz := abs_scaled_coord_le_level N k.2 hzNat
  simp only [B4, scaledMomentum, scaledWindow, Nat.cast_add,
    Nat.cast_mul, Nat.cast_ofNat]
  norm_num at hx hy hz hm ⊢
  linarith

theorem scaledWindow_pos (M N : Nat) : 0 < scaledWindow M N := by
  unfold scaledWindow
  omega

/-- Uniform live matrix error over the complete scaled momentum box. -/
theorem scaled_box_many_step_bound
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (k : Mode) (hk : k ∈ modeBox (physicalCutoff N)) :
    ‖(splitStep (scaledMomentum N k 0) (scaledMomentum N k 1)
          (scaledMomentum N k 2) m
          (t / (scaledSteps M N : Real))) ^ scaledSteps M N -
        exactFlow (scaledMomentum N k 0) (scaledMomentum N k 1)
          (scaledMomentum N k 2) m t‖ <=
      2 * t ^ 2 / (scaledWindow M N : Real) ^ 2 *
        Real.exp (|t| / (scaledWindow M N : Real) ^ 3) := by
  exact quartic_window_many_step_bound
    (scaledMomentum N k 0) (scaledMomentum N k 1) (scaledMomentum N k 2)
    m t (scaledSteps M N) (scaledWindow M N) rfl
    (scaledWindow_pos M N) (scaled_mode_B4_le_window m M N hm k hk)

/-- The common scaled-window rate tends to zero. -/
theorem scaled_box_rate_tendsto_zero (t : Real) (M : Nat) :
    Tendsto
      (fun N : Nat =>
        2 * t ^ 2 / (scaledWindow M N : Real) ^ 2 *
          Real.exp (|t| / (scaledWindow M N : Real) ^ 3))
      atTop (nhds 0) := by
  refine squeeze_zero
    (g := fun N : Nat =>
      (2 * t ^ 2 * Real.exp |t|) / (scaledWindow M N : Real))
    (fun _ => by positivity) (fun N => ?_) ?_
  · exact quartic_rate_le_reciprocal_envelope t (scaledWindow M N)
      (scaledWindow_pos M N)
  · have htop : Tendsto (fun N : Nat => (scaledWindow M N : Real))
        atTop atTop := by
      have hcast : Tendsto (fun N : Nat => (N : Real)) atTop atTop :=
        tendsto_natCast_atTop_atTop
      refine tendsto_atTop_mono (fun N => ?_) hcast
      have hnat : N <= scaledWindow M N := by
        unfold scaledWindow
        omega
      exact_mod_cast hnat
    exact tendsto_const_nhds.div_atTop htop

/-- Uniform convergence for any sequence of retained modes, including modes
moving out to physical momentum of order `N`. -/
theorem scaled_box_error_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (k : Nat -> Mode)
    (hk : forall N, k N ∈ modeBox (physicalCutoff N)) :
    Tendsto
      (fun N : Nat =>
        ‖(splitStep (scaledMomentum N (k N) 0)
              (scaledMomentum N (k N) 1) (scaledMomentum N (k N) 2) m
              (t / (scaledSteps M N : Real))) ^ scaledSteps M N -
            exactFlow (scaledMomentum N (k N) 0)
              (scaledMomentum N (k N) 1) (scaledMomentum N (k N) 2) m t‖)
      atTop (nhds 0) := by
  refine squeeze_zero (fun _ => norm_nonneg _) (fun N => ?_)
    (scaled_box_rate_tendsto_zero t M)
  exact scaled_box_many_step_bound m t M N hm (k N) (hk N)

/-- Boundary fixture: the positive x-face mode represents physical momentum
exactly `N+1`, so the theorem is not a fixed-compact-momentum statement. -/
theorem scaled_boundary_momentum (N : Nat) :
    scaledMomentum N (boundaryMode N) 0 =
      (N + 1 : Real) := by
  simp only [boundaryMode]
  change physicalSpacing N * (physicalCutoff N : Real) = (N + 1 : Real)
  rw [mul_comm, physicalCutoff_mul_spacing]

/-- The moving boundary witness is retained at every refinement level. -/
theorem boundaryMode_mem (N : Nat) :
    boundaryMode N ∈ modeBox (physicalCutoff N) := by
  rw [mem_modeBox_iff]
  simp [boundaryMode]

/-- The live walk converges even along a mode sequence whose physical
momentum tends to infinity at the edge of the represented box. -/
theorem scaled_boundary_error_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real)) :
    Tendsto
      (fun N : Nat =>
        ‖(splitStep (scaledMomentum N (boundaryMode N) 0)
              (scaledMomentum N (boundaryMode N) 1)
              (scaledMomentum N (boundaryMode N) 2) m
              (t / (scaledSteps M N : Real))) ^ scaledSteps M N -
            exactFlow (scaledMomentum N (boundaryMode N) 0)
              (scaledMomentum N (boundaryMode N) 1)
              (scaledMomentum N (boundaryMode N) 2) m t‖)
      atTop (nhds 0) := by
  exact scaled_box_error_tendsto_zero m t M hm boundaryMode boundaryMode_mem

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ScaledChangingMomentumWalk.physicalRadius_tendsto_atTop' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physicalRadius_tendsto_atTop

/-- info: 'PhysicsSM.Draft.NullEdge.ScaledChangingMomentumWalk.scaled_box_error_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scaled_box_error_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.ScaledChangingMomentumWalk.scaled_boundary_momentum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scaled_boundary_momentum

/-- info: 'PhysicsSM.Draft.NullEdge.ScaledChangingMomentumWalk.scaled_boundary_error_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scaled_boundary_error_tendsto_zero

end PhysicsSM.Draft.NullEdge.ScaledChangingMomentumWalk
