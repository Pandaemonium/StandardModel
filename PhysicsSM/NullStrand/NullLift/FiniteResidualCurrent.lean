import Mathlib
import PhysicsSM.NullStrand.Conventions

/-!
# NullStrand.NullLift.FiniteResidualCurrent

Elementary finite-null-lift bookkeeping: a finite direction resolution,
its extended density, and a residual current with explicit divergence form.

This file is intentionally conservative: it makes only the algebraic
definitions required to state and prove finite-sum identities.
-/

noncomputable section

namespace PhysicsSM.NullStrand.NullLift

open scoped BigOperators
open Finset

/-- Finite angular resolution used by the discrete null-lift layer. -/
structure FiniteNullResolution (Z Ω : Type*) [Fintype Ω] where
  weight : Z → Ω → ℝ
  normalized : ∀ z, (∑ ω : Ω, weight z ω) = 1

/-- Extended density on an angular branch of each base state. -/
def extendedDensity {Z Ω : Type*} [Fintype Ω]
    (rho : Z → ℝ) (R : FiniteNullResolution Z Ω) (z : Z) (ω : Ω) : ℝ :=
  rho z * R.weight z ω

/-- Zero-mean residual source over directions. -/
structure ResidualSource (Z Ω : Type*) [Fintype Ω] where
  residual : Z → Ω → ℝ
  zeroMean : ∀ z, ∑ ω : Ω, residual z ω = 0

/-- Surplus-deficit residual current used in finite bookkeeping. -/
def residualCurrent {Z Ω : Type*} [Fintype Ω]
    (rho : Z → ℝ) (R : FiniteNullResolution Z Ω) (S : ResidualSource Z Ω) :
    Z → Ω → ℝ :=
  fun z ω => extendedDensity rho R z ω + S.residual z ω

/-- Directional divergence of the residual current. -/
def residualDivergence {Z Ω : Type*} [Fintype Ω]
    (rho : Z → ℝ) (R : FiniteNullResolution Z Ω) (S : ResidualSource Z Ω) :
    Z → ℝ :=
  fun z => ∑ ω : Ω, residualCurrent rho R S z ω

/-- Summing extended density over a resolution gives back the base density. -/
theorem extendedDensity_sum_eq {Z Ω : Type*} [Fintype Ω]
    (rho : Z → ℝ) (R : FiniteNullResolution Z Ω) (z : Z) :
    (∑ ω : Ω, extendedDensity rho R z ω) = rho z := by
  unfold extendedDensity
  rw [← Finset.mul_sum]
  simpa [R.normalized z]

/-- Residual current divergence is base source plus residual mean. -/
theorem residualCurrent_divergence_eq {Z Ω : Type*} [Fintype Ω]
    (rho : Z → ℝ) (R : FiniteNullResolution Z Ω) (S : ResidualSource Z Ω) (z : Z) :
    residualDivergence rho R S z = rho z := by
  unfold residualDivergence residualCurrent
  rw [Finset.sum_add_distrib]
  rw [extendedDensity_sum_eq, S.zeroMean]
  ring

end PhysicsSM.NullStrand.NullLift
