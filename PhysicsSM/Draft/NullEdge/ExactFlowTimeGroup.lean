import PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz

/-!
# Exact Dirac flow time-group law

This module proves the pointwise one-parameter-group structure of the live
four-by-four exact Dirac flow. It is the algebraic rung required before the
representative-safe `L2` composition theorem can be specialized to a
momentum-space time group.

The result is finite-dimensional and pointwise in momentum. It does not by
itself prove strong continuity on `L2`, identify the unbounded generator,
perform Fourier transport, or establish a position-space PDE.

The proof was returned by Aristotle project
`0704b7da-df6b-4dba-bc5c-fc22168d931f` and replayed locally under the pinned
Lean 4.28 toolchain. No theorem statement was changed.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup

open Compact3Plus1DiracRate

/-- The exact Dirac flow is a time-additive matrix one-parameter group at every
fixed momentum and mass. -/
theorem exactFlow_add_time (kx ky kz m s t : Real) :
    exactFlow kx ky kz m (s + t) =
      exactFlow kx ky kz m s * exactFlow kx ky kz m t := by
  unfold exactFlow
  convert Matrix.exp_add_of_commute _ _ _ using 2
  · rw [← add_smul, ← neg_add, Complex.ofReal_add]
  · infer_instance
  · infer_instance
  · exact Commute.smul_left (Commute.smul_right (Commute.refl _) _) _

/-- Opposite elapsed times multiply to the identity in the displayed order. -/
theorem exactFlow_mul_neg_time (kx ky kz m t : Real) :
    exactFlow kx ky kz m t * exactFlow kx ky kz m (-t) = 1 := by
  have := exactFlow_add_time kx ky kz m t (-t)
  simp_all +decide [exactFlow]

/-- Reverse-order inverse control in the noncommutative matrix algebra. -/
theorem exactFlow_neg_time_mul (kx ky kz m t : Real) :
    exactFlow kx ky kz m (-t) * exactFlow kx ky kz m t = 1 := by
  convert exactFlow_mul_neg_time kx ky kz m (-t) using 1 <;> ring

/-! ## Boundary and non-vacuity controls -/

/-- The group law specializes to the already proved zero-time identity. -/
theorem exactFlow_zero_time_control (kx ky kz m t : Real) :
    exactFlow kx ky kz m (0 + t) =
      exactFlow kx ky kz m 0 * exactFlow kx ky kz m t := by
  simpa using exactFlow_add_time kx ky kz m 0 t

/-- The target applies to a genuinely momentum-dependent generator rather than
only the zero matrix. -/
theorem nonconstant_generator_control : H 1 0 0 0 ≠ H 0 0 0 0 :=
  ExactFlowMomentumLipschitz.H_x_witness_ne

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup.exactFlow_add_time' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlow_add_time

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup.exactFlow_mul_neg_time' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlow_mul_neg_time

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup.exactFlow_neg_time_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlow_neg_time_mul

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup.exactFlow_zero_time_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlow_zero_time_control

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup.nonconstant_generator_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonconstant_generator_control

end PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup
