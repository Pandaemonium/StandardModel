import PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz

/-!
# Exact Dirac flow time-group law

This focused target proves the missing pointwise time-group structure for the
live four-by-four exact Dirac flow. It is the finite-dimensional algebraic rung
needed before the already prepared representative-safe `L2` composition theorem
can be specialized to a momentum-space one-parameter group.

The target concerns the existing `Compact3Plus1DiracRate.exactFlow` definition.
It does not yet prove strong time continuity on `L2`, identify the generator,
apply Fourier transport, or state a position-space PDE.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup

open Compact3Plus1DiracRate

/-- **Immutable target.** The exact Dirac flow is a time-additive matrix
one-parameter group at every fixed momentum and mass. -/
theorem exactFlow_add_time (kx ky kz m s t : Real) :
    exactFlow kx ky kz m (s + t) =
      exactFlow kx ky kz m s * exactFlow kx ky kz m t := by
  unfold exactFlow
  convert Matrix.exp_add_of_commute _ _ _ using 2
  · rw [← add_smul, ← neg_add, Complex.ofReal_add]
  · infer_instance
  · infer_instance
  · exact Commute.smul_left (Commute.smul_right (Commute.refl _) _) _

/-- **Immutable inverse control.** Opposite elapsed times multiply to the
identity in the displayed order. -/
theorem exactFlow_mul_neg_time (kx ky kz m t : Real) :
    exactFlow kx ky kz m t * exactFlow kx ky kz m (-t) = 1 := by
  have := exactFlow_add_time kx ky kz m t (-t)
  simp_all +decide [exactFlow]

/-- **Immutable reverse-order inverse control.** This prevents a proof that
silently establishes only a one-sided inverse in the noncommutative matrix
algebra. -/
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

end PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup
