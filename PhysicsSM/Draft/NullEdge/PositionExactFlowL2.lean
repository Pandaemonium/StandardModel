import PhysicsSM.Draft.NullEdge.MomMultL2StrongContinuity

/-!
# Fourier-conjugated exact Dirac flow on position-space L2

This module transports the live exact momentum multiplier through Mathlib's
vector-valued Fourier-Plancherel isometry.  The resulting map is an exact
complex-linear isometry on position-space `L2`.  For every fixed state, its
time orbit is norm-continuous.

This is the bounded evolution layer only.  It does not yet prove the additive
time-group law, identify an unbounded generator, establish Schwartz
preservation, or state the position-space Dirac PDE.  Those require the
separate exact-flow group, Fourier-derivative, generator, and temperate-growth
targets.

Provenance: clean-room composition of Mathlib's
`MeasureTheory.Lp.fourierTransformLI`, the project multiplier isometry in
`ChangingCellFourierPDE`, and the strong-orbit theorem in
`MomMultL2StrongContinuity`, July 13, 2026. The complete module was accepted by
an independent Claude-family semantic audit recorded in
`AutonomousLab/work/NE-CONTINUUM/CLAUDE_REVIEW_PositionExactFlowL2_2026-07-13.md`.
-/

noncomputable section

open MeasureTheory

namespace PhysicsSM.Draft.NullEdge.PositionExactFlowL2

open ChangingCellFourierL2
open ChangingCellFourierPDE
open ChangingCellScaledLiveWalk
open MomMultL2StrongContinuity

/-- The common momentum/position Hilbert space.  The two readings are related
by the explicit Fourier-Plancherel equivalence below; no pointwise value is
assigned to an `Lp` equivalence class. -/
abbrev SpinorL2 :=
  Lp Spinor 2 (volume : Measure FourierMomentum3)

/-- Exact position-space `L2` evolution, defined by Fourier conjugation of the
live exact momentum multiplier. -/
noncomputable def positionExactFlowL2Isometry (m t : Real) :
    SpinorL2 →ₗᵢ[Complex] SpinorL2 :=
  (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor).symm.toLinearIsometry.comp
    ((momMultL2Isometry m t).comp
      (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor).toLinearIsometry)

/-- The definition expands to Fourier transform, exact momentum evolution,
and inverse Fourier transform in that order. -/
theorem positionExactFlowL2Isometry_apply (m t : Real) (f : SpinorL2) :
    positionExactFlowL2Isometry m t f =
      (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor).symm
        (momMultL2Isometry m t
          (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor f)) :=
  rfl

/-- Fourier transform intertwines the position-space evolution with the live
momentum multiplier exactly. -/
theorem fourier_positionExactFlowL2Isometry (m t : Real) (f : SpinorL2) :
    MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor
        (positionExactFlowL2Isometry m t f) =
      momMultL2Isometry m t
        (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor f) := by
  rw [positionExactFlowL2Isometry_apply]
  exact
    (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor).apply_symm_apply _

/-- The Fourier-conjugated evolution preserves the full position-space `L2`
norm exactly. -/
theorem positionExactFlowL2Isometry_norm (m t : Real) (f : SpinorL2) :
    norm (positionExactFlowL2Isometry m t f) = norm f :=
  (positionExactFlowL2Isometry m t).norm_map f

/-- At zero elapsed time the position-space evolution is the identity. -/
theorem positionExactFlowL2Isometry_zero_time (m : Real) (f : SpinorL2) :
    positionExactFlowL2Isometry m 0 f = f := by
  rw [positionExactFlowL2Isometry_apply, momMultL2Isometry_zero_time]
  exact
    (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor).symm_apply_apply f

/-- Every fixed position-space `L2` state has a strongly continuous exact-flow
orbit.  This is strong continuity, not operator-norm continuity. -/
theorem positionExactFlowL2Orbit_continuous (m : Real) (f : SpinorL2) :
    Continuous (fun t : Real => positionExactFlowL2Isometry m t f) := by
  have h := momMultL2Orbit_continuous m
    (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor f)
  exact
    (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor).symm.continuous.comp
      (by simpa [momMultL2Orbit] using h)

/-- Non-degeneracy control: a nonzero state cannot be collapsed to zero by the
Fourier-conjugated exact flow. -/
theorem positionExactFlowL2Isometry_ne_zero (m t : Real) (f : SpinorL2)
    (hf : f ≠ 0) :
    positionExactFlowL2Isometry m t f ≠ 0 := by
  intro hout
  apply hf
  apply norm_eq_zero.mp
  calc
    norm f = norm (positionExactFlowL2Isometry m t f) :=
      (positionExactFlowL2Isometry_norm m t f).symm
    _ = 0 := by rw [hout, norm_zero]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PositionExactFlowL2.fourier_positionExactFlowL2Isometry' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourier_positionExactFlowL2Isometry

/-- info: 'PhysicsSM.Draft.NullEdge.PositionExactFlowL2.positionExactFlowL2Isometry_zero_time' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positionExactFlowL2Isometry_zero_time

/-- info: 'PhysicsSM.Draft.NullEdge.PositionExactFlowL2.positionExactFlowL2Orbit_continuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positionExactFlowL2Orbit_continuous

/-- info: 'PhysicsSM.Draft.NullEdge.PositionExactFlowL2.positionExactFlowL2Isometry_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positionExactFlowL2Isometry_ne_zero

end PhysicsSM.Draft.NullEdge.PositionExactFlowL2
