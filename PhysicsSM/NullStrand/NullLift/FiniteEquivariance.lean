import Mathlib
import PhysicsSM.NullStrand.NullLift.FiniteResidualCurrent

/-!
# NullStrand.NullLift.FiniteEquivariance

Finite equivariance statements for the residual current lift.

This module packages the key READY roadmap target:
- finiteNullLift_equivariant.

The proof is purely algebraic once residual directions are normalized on each base
state.
-/

noncomputable section

namespace PhysicsSM.NullStrand.NullLift

open scoped BigOperators

/-- Base-to-lift equivariance is exactly the finite residual divergence identity. -/
theorem finiteNullLift_equivariant {Z Ω : Type*} [Fintype Ω]
    (rho : Z → ℝ) (R : FiniteNullResolution Z Ω) (S : ResidualSource Z Ω) :
    residualDivergence rho R S = rho := by
  funext z
  simpa using (residualCurrent_divergence_eq rho R S z)

/-- A convenient reformulation used by downstream finite-null-lift modules. -/
theorem finiteNullLift_targetMarginal_eq_source
    {Z Ω : Type*} [Fintype Ω]
    (rho : Z → ℝ) (R : FiniteNullResolution Z Ω) (S : ResidualSource Z Ω) :
    residualDivergence rho R S = rho := finiteNullLift_equivariant (rho := rho) (R := R) (S := S)

end PhysicsSM.NullStrand.NullLift
