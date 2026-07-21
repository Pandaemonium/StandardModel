import PhysicsSM.Draft.NullEdge.CliffordDiagonalPositionBridge
import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate

/-!
# Local finite 3+1 walk and compact-rate symbol bridge

The finite position walk and the compact-momentum product estimate were proved
in separate modules. This file composes them with an explicit order convention.
Because the spatial generators do not commute, matrix order is load-bearing.

The local update below applies the mass coin first, followed on states by the
z-, y-, and x-axis conditional shifts. Its matrix symbol is therefore the
displayed x/y/z/mass product used by `Compact3Plus1DiracRate.splitStep`.
Every position-space factor is local and exactly norm preserving, and the
symbol inherits the compact-box `O(1/n)` estimate.

This aligns the finite local and compact-symbol layers through the same
explicit bases and factor order. It does not yet prove that the full discrete
Fourier transform conjugates the finite position operator to `localSymbol`,
nor prove an infinite-volume Dirac PDE limit.
-/

noncomputable section

open Matrix Complex
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.Local3Plus1RateBridge

abbrev Mat4 := SuccessiveAxisDiracWalk.Mat4
abbrev State (L : ℕ) := SuccessiveAxisPositionWalk.State L

/-- The mass factor in the same normalization as the local axis factors. -/
def massFactor (m eps : ℝ) : Mat4 :=
  SuccessiveAxisDiracWalk.normalizedFactor
    (Real.cos (m * eps)) (Real.sin (m * eps))
    SuccessiveAxisDiracWalk.beta

theorem massFactor_unitary (m eps : ℝ) :
    SuccessiveAxisDiracWalk.IsUnitary (massFactor m eps) := by
  apply SuccessiveAxisDiracWalk.normalized_factor_unitary
  · exact SuccessiveAxisDiracWalk.generators_hermitian.2.2.2
  · exact SuccessiveAxisDiracWalk.generators_square_one.2.2.2
  · exact Real.cos_sq_add_sin_sq (m * eps)

/-- Matrix symbol assembled from the exact conjugated conditional shifts. -/
def localSymbol (kx ky kz m eps : ℝ) : Mat4 :=
  CliffordDiagonalPositionBridge.axisSymbol 0 (kx * eps) *
    CliffordDiagonalPositionBridge.axisSymbol 1 (ky * eps) *
    CliffordDiagonalPositionBridge.axisSymbol 2 (kz * eps) *
    massFactor m eps

/-- The local-factor symbol is exactly the symbol used by the compact-rate
theorem, including its noncommuting factor order. -/
theorem localSymbol_eq_splitStep (kx ky kz m eps : ℝ) :
    localSymbol kx ky kz m eps =
      Compact3Plus1DiracRate.splitStep kx ky kz m eps := by
  rw [localSymbol,
    CliffordDiagonalPositionBridge.axisSymbol_closed_form,
    CliffordDiagonalPositionBridge.axisSymbol_closed_form,
    CliffordDiagonalPositionBridge.axisSymbol_closed_form]
  rfl

/-- A local finite-torus update with the exact x/y/z/mass symbol order. -/
def localStep {L : ℕ} (m eps : ℝ) (psi : State L) : State L :=
  CliffordDiagonalPositionBridge.cliffordAxisShift 0
    (CliffordDiagonalPositionBridge.cliffordAxisShift 1
      (CliffordDiagonalPositionBridge.cliffordAxisShift 2
        (SuccessiveAxisPositionWalk.pointwiseCoin (massFactor m eps) psi)))

/-- The complete finite position update, including its mass coin, exactly
preserves the finite inner product. -/
theorem localStep_preserves_norm {L : ℕ} [NeZero L]
    (m eps : ℝ) (psi : State L) :
    SuccessiveAxisPositionWalk.inner (localStep m eps psi)
        (localStep m eps psi) =
      SuccessiveAxisPositionWalk.inner psi psi := by
  unfold localStep
  rw [CliffordDiagonalPositionBridge.cliffordAxisShift_inner,
    CliffordDiagonalPositionBridge.cliffordAxisShift_inner,
    CliffordDiagonalPositionBridge.cliffordAxisShift_inner,
    SuccessiveAxisPositionWalk.pointwiseCoin_inner]
  exact massFactor_unitary m eps

/-- The local symbol inherits the explicit compact-momentum first-order rate. -/
theorem localSymbol_many_step_bound_on_box
    (kx ky kz m K M t : ℝ) (n : ℕ)
    (hn : 0 < n) (hsmall : |t / (n : ℝ)| ≤ 1)
    (hK : 0 ≤ K) (hM : 0 ≤ M)
    (hx : |kx| ≤ K) (hy : |ky| ≤ K) (hz : |kz| ≤ K)
    (hm : |m| ≤ M) :
    ‖(localSymbol kx ky kz m (t / (n : ℝ))) ^ n -
        Compact3Plus1DiracRate.exactFlow kx ky kz m t‖ ≤
      Compact3Plus1DiracRate.Dbox K M * t ^ 2 / n := by
  rw [localSymbol_eq_splitStep]
  exact Compact3Plus1DiracRate.fixed_time_many_step_bound_on_box
    kx ky kz m K M t n hn hsmall hK hM hx hy hz hm

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Local3Plus1RateBridge.localSymbol_eq_splitStep' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms localSymbol_eq_splitStep

/-- info: 'PhysicsSM.Draft.NullEdge.Local3Plus1RateBridge.localStep_preserves_norm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms localStep_preserves_norm

/-- info: 'PhysicsSM.Draft.NullEdge.Local3Plus1RateBridge.localSymbol_many_step_bound_on_box' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms localSymbol_many_step_bound_on_box

end PhysicsSM.Draft.NullEdge.Local3Plus1RateBridge
