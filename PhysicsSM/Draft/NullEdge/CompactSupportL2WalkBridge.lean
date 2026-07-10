import PhysicsSM.Draft.NullEdge.ContinuumL2MultiplierBridge
import PhysicsSM.Draft.NullEdge.FiniteTorus3WalkWavepacket

/-!
# Compact-support L2 bridge for the complex 3+1 walk

This module supplies the walk-specific instantiation missing between the
compact-box symbol estimate and the abstract measure-theoretic multiplier
theorem.  For an `L2` momentum-space spinor supported almost everywhere inside
the controlled box, the `(n+1)`-step complex walk error converges to zero in
`eLpNorm` at every fixed time.  The arbitrary-time theorem discards the finite
prefix before the step size enters the local estimate; sequence limits are
unchanged by that index shift.

The result is still a momentum-space multiplier theorem.  It does not identify
the measure space with a lattice/continuum Fourier limit or prove convergence
to a position-space Dirac PDE.  Those are the remaining physical bridges.
-/

noncomputable section

open Filter MeasureTheory
open scoped Matrix.Norms.L2Operator Topology

namespace PhysicsSM.Draft.NullEdge.CompactSupportL2WalkBridge

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex
abbrev Spinor := EuclideanSpace Complex (Fin 4)

def approximateOperator (kx ky kz : Real) (z : Complex) (t : Real) (n : Nat) :
    Spinor →L[Complex] Spinor :=
  PhysicsSM.Draft.NullEdge.FiniteTorus3WalkWavepacket.matrixOperator
    ((PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.complexSplitStep
      kx ky kz z (t / (n : Real))) ^ n)

def exactOperator (kx ky kz : Real) (z : Complex) (t : Real) :
    Spinor →L[Complex] Spinor :=
  PhysicsSM.Draft.NullEdge.FiniteTorus3WalkWavepacket.matrixOperator
    (PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.complexExactFlow
      kx ky kz z t)

/-- Pointwise multiplier error applied to a momentum-space spinor. -/
def walkError {X : Type*}
    (kx ky kz : X -> Real) (z : X -> Complex) (f : X -> Spinor)
    (t : Real) (n : Nat) (x : X) : Spinor :=
  approximateOperator (kx x) (ky x) (kz x) (z x) t n (f x) -
    exactOperator (kx x) (ky x) (kz x) (z x) t (f x)

theorem walkError_norm_le_on_box {X : Type*}
    (kx ky kz : X -> Real) (z : X -> Complex) (f : X -> Spinor)
    (K M t : Real) (n : Nat) (x : X)
    (hn : 0 < n) (hsmall : |t / (n : Real)| <= 1)
    (hK : 0 <= K) (hM : 0 <= M)
    (hx : |kx x| <= K) (hy : |ky x| <= K) (hz : |kz x| <= K)
    (hm : ‖z x‖ <= M) :
    ‖walkError kx ky kz z f t n x‖ <=
      (PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.realDbox K M *
        t ^ 2 / n) * ‖f x‖ := by
  change ‖approximateOperator (kx x) (ky x) (kz x) (z x) t n (f x) -
      exactOperator (kx x) (ky x) (kz x) (z x) t (f x)‖ <= _
  rw [← ContinuousLinearMap.sub_apply]
  calc
    ‖(approximateOperator (kx x) (ky x) (kz x) (z x) t n -
        exactOperator (kx x) (ky x) (kz x) (z x) t) (f x)‖ <=
        ‖approximateOperator (kx x) (ky x) (kz x) (z x) t n -
          exactOperator (kx x) (ky x) (kz x) (z x) t‖ * ‖f x‖ :=
      ContinuousLinearMap.le_opNorm _ _
    _ = ‖(PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.complexSplitStep
          (kx x) (ky x) (kz x) (z x)
          (t / (n : Real))) ^ n -
        PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.complexExactFlow
          (kx x) (ky x) (kz x) (z x) t‖ * ‖f x‖ := by
      rw [approximateOperator, exactOperator,
        PhysicsSM.Draft.NullEdge.FiniteTorus3WalkWavepacket.norm_matrixOperator_sub]
    _ <= (PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.realDbox K M *
        t ^ 2 / n) * ‖f x‖ := by
      gcongr
      exact PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.complex_fixed_time_many_step_bound_on_box
        (kx x) (ky x) (kz x) K M t (z x) n hn hsmall hK hM hx hy hz hm

theorem small_step_of_abs_time_le_one (t : Real) (ht : |t| <= 1) (n : Nat) :
    |t / ((n + 1 : Nat) : Real)| <= 1 := by
  have hdenabs : |(((n + 1 : Nat) : Real))| = ((n + 1 : Nat) : Real) :=
    abs_of_nonneg (Nat.cast_nonneg _)
  rw [abs_div, hdenabs]
  apply (div_le_one (by positivity)).2
  exact ht.trans (by norm_num)

theorem small_step_of_nat_offset
    (t : Real) (N n : Nat) (hNpos : 0 < N) (hN : |t| <= (N : Real)) :
    |t / ((n + N : Nat) : Real)| <= 1 := by
  have hdenpos : 0 < ((n + N : Nat) : Real) := by
    exact_mod_cast Nat.add_pos_right n hNpos
  have hden : (N : Real) <= ((n + N : Nat) : Real) := by
    exact_mod_cast (show N <= n + N by omega)
  have hdenabs : |(((n + N : Nat) : Real))| = ((n + N : Nat) : Real) :=
    abs_of_pos hdenpos
  rw [abs_div, hdenabs]
  exact (div_le_one hdenpos).2 (hN.trans hden)

/-- Walk-specific compact-support `L2` convergence.  Only modes on which `f`
is nonzero need satisfy the compact momentum and Pluecker bounds. -/
theorem walk_error_eLpNorm_tendsto_zero_on_compact_support
    {X : Type*} [MeasurableSpace X] (mu : Measure X)
    (kx ky kz : X -> Real) (z : X -> Complex) (f : X -> Spinor)
    (K M t : Real)
    (hf : MemLp f 2 mu) (ht : |t| <= 1)
    (hK : 0 <= K) (hM : 0 <= M)
    (hbox : ∀ᵐ x ∂mu, f x ≠ 0 ->
      |kx x| <= K ∧ |ky x| <= K ∧ |kz x| <= K ∧ ‖z x‖ <= M) :
    Tendsto
      (fun n => eLpNorm (walkError kx ky kz z f t (n + 1)) 2 mu)
      atTop (nhds 0) := by
  let eps : Nat -> Real :=
    fun n =>
      PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.realDbox K M *
        t ^ 2 / (n + 1 : Real)
  apply
    PhysicsSM.Draft.NullEdge.ContinuumL2MultiplierBridge.eLpNorm_two_tendsto_zero_of_uniform_relative_bound
    (fun n => walkError kx ky kz z f t (n + 1)) f eps hf
  · intro n
    dsimp [eps, PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.realDbox,
      PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.Dbox]
    positivity
  · dsimp [eps, PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.realDbox]
    exact
      PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.box_error_envelope_tendsto_zero
        K M t
  · intro n
    filter_upwards [hbox] with x hx
    by_cases hfx : f x = 0
    · simp [walkError, hfx]
    · rcases hx hfx with ⟨hkx, hky, hkz, hz⟩
      simpa [eps, Nat.cast_add, Nat.cast_one] using
        (walkError_norm_le_on_box kx ky kz z f K M t (n + 1) x
          (Nat.succ_pos n) (small_step_of_abs_time_le_one t ht n)
          hK hM hkx hky hkz hz)

/-- The compact-support convergence theorem at arbitrary fixed time.  A finite
index shift makes the small-step hypothesis automatic and does not change a
sequence limit. -/
theorem walk_error_eLpNorm_tendsto_zero_on_compact_support_any_time
    {X : Type*} [MeasurableSpace X] (mu : Measure X)
    (kx ky kz : X -> Real) (z : X -> Complex) (f : X -> Spinor)
    (K M t : Real)
    (hf : MemLp f 2 mu) (hK : 0 <= K) (hM : 0 <= M)
    (hbox : ∀ᵐ x ∂mu, f x ≠ 0 ->
      |kx x| <= K ∧ |ky x| <= K ∧ |kz x| <= K ∧ ‖z x‖ <= M) :
    Tendsto
      (fun n => eLpNorm (walkError kx ky kz z f t (n + 1)) 2 mu)
      atTop (nhds 0) := by
  obtain ⟨N, hN⟩ := exists_nat_gt |t|
  rw [← tendsto_add_atTop_iff_nat N]
  let eps : Nat -> Real := fun n =>
    PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.realDbox K M *
      t ^ 2 / ((n + N) + 1 : Real)
  apply
    PhysicsSM.Draft.NullEdge.ContinuumL2MultiplierBridge.eLpNorm_two_tendsto_zero_of_uniform_relative_bound
      (fun n => walkError kx ky kz z f t ((n + N) + 1)) f eps hf
  · intro n
    dsimp [eps, PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.realDbox,
      PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.Dbox]
    positivity
  · dsimp [eps, PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.realDbox]
    have hbase :=
      PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.box_error_envelope_tendsto_zero
        K M t
    simpa [Nat.cast_add, Nat.cast_one, add_assoc] using
      ((tendsto_add_atTop_iff_nat N).2 hbase)
  · intro n
    filter_upwards [hbox] with x hx
    by_cases hfx : f x = 0
    · simp [walkError, hfx]
    · rcases hx hfx with ⟨hkx, hky, hkz, hz⟩
      have hstep :
          |t / ((((n + N) + 1 : Nat)) : Real)| <= 1 := by
        apply small_step_of_nat_offset t (N + 1) n (Nat.succ_pos N)
        exact (le_of_lt hN).trans (by norm_num)
      simpa [eps, Nat.cast_add, Nat.cast_one, Nat.add_assoc, add_assoc] using
        (walkError_norm_le_on_box kx ky kz z f K M t ((n + N) + 1) x
          (by omega) hstep hK hM hkx hky hkz hz)

/-- A one-point finite-measure control shows that the compact-support theorem
applies to explicitly nonzero spinors, not only to the zero function. -/
theorem one_point_nonzero_control (v : Spinor) (hv : v ≠ 0) :
    v ≠ 0 ∧
      Tendsto
        (fun n => eLpNorm
          (walkError (fun _ : Unit => 0) (fun _ : Unit => 0)
            (fun _ : Unit => 0) (fun _ : Unit => 1) (fun _ : Unit => v)
            (1 / 2) (n + 1)) 2 (Measure.dirac ()))
        atTop (nhds 0) := by
  refine ⟨hv, ?_⟩
  apply walk_error_eLpNorm_tendsto_zero_on_compact_support
    (Measure.dirac ()) (fun _ : Unit => 0) (fun _ : Unit => 0)
    (fun _ : Unit => 0) (fun _ : Unit => 1) (fun _ : Unit => v)
    1 1 (1 / 2)
  · exact memLp_const v
  · norm_num [abs_of_nonneg]
  · norm_num
  · norm_num
  · filter_upwards with x
    intro
    norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2WalkBridge.walk_error_eLpNorm_tendsto_zero_on_compact_support' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms walk_error_eLpNorm_tendsto_zero_on_compact_support

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2WalkBridge.one_point_nonzero_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms one_point_nonzero_control

/-- info: 'PhysicsSM.Draft.NullEdge.CompactSupportL2WalkBridge.walk_error_eLpNorm_tendsto_zero_on_compact_support_any_time' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms walk_error_eLpNorm_tendsto_zero_on_compact_support_any_time

end PhysicsSM.Draft.NullEdge.CompactSupportL2WalkBridge
