import Mathlib
import PhysicsSM.NullStrand.Conventions
import PhysicsSM.NullStrand.RealPositivePart

/-!
# NullStrand.ZigZag.TransferCurrent

Abstract one-particle chiral transfer data and safe rate conventions.

Conventions:
- all quantities are real-valued unless explicitly typed
- positive-part convention `a⁰ := max a 0`
- rates use the safe convention `r(x) = a⁰ / ρ(x)` with zero-density fallback to `0`
- no physical postulates beyond algebraic API signatures are introduced
-/

noncomputable section

namespace PhysicsSM.NullStrand.ZigZag

open scoped BigOperators

abbrev RealRate (X : Type*) := X → ℝ

-- `realPos`, `realPos_nonneg`, and `realPos_sub_realPos_neg` now live in the
-- shared module `PhysicsSM.NullStrand.RealPositivePart` and are resolved here via
-- parent-namespace lookup.

/-- Abstract two-chiral transfer interface used by several finite APIs. -/
structure ChiralTransferData (X : Type*) where
  rhoR : RealRate X
  rhoL : RealRate X
  jR : X → Minkowski4
  jL : X → Minkowski4
  F : RealRate X
  continuityR : X → ℝ
  continuityL : X → ℝ
  transfer_zero_of_rhoR_zero : ∀ x, rhoR x = 0 → F x = 0
  transfer_zero_of_rhoL_zero : ∀ x, rhoL x = 0 → F x = 0
  rhoR_nonneg : ∀ x, 0 ≤ rhoR x
  rhoL_nonneg : ∀ x, 0 ≤ rhoL x

/-- Source-to-target minimal right-to-left transfer rate. -/
def rateLtoR {X : Type*} (d : ChiralTransferData X) (x : X) : ℝ :=
  realPos (d.F x) / d.rhoL x

/-- Source-to-target minimal left-to-right transfer rate. -/
def rateRtoL {X : Type*} (d : ChiralTransferData X) (x : X) : ℝ :=
  realPos (- d.F x) / d.rhoR x

/-- Zero left-density forces zero left-to-right source rate. -/
theorem rateLtoR_eq_zero_of_rhoL_zero {X : Type*} (d : ChiralTransferData X) (x : X)
    (hL : d.rhoL x = 0) : rateLtoR d x = 0 := by
  have hF : d.F x = 0 := d.transfer_zero_of_rhoL_zero x hL
  simp [rateLtoR, hL, hF, realPos]

/-- Zero right-density forces zero right-to-left source rate. -/
theorem rateRtoL_eq_zero_of_rhoR_zero {X : Type*} (d : ChiralTransferData X) (x : X)
    (hR : d.rhoR x = 0) : rateRtoL d x = 0 := by
  have hF : d.F x = 0 := d.transfer_zero_of_rhoR_zero x hR
  simp [rateRtoL, hR, hF, realPos]

/-- Clearing a nonzero left density factor recovers the positive-part numerator. -/
theorem rateLtoR_mul_density {X : Type*} (d : ChiralTransferData X) (x : X)
    (hL : d.rhoL x ≠ 0) : rateLtoR d x * d.rhoL x = realPos (d.F x) := by
  unfold rateLtoR
  field_simp [hL]

/-- Clearing a nonzero right density factor recovers the positive-part numerator. -/
theorem rateRtoL_mul_density {X : Type*} (d : ChiralTransferData X) (x : X)
    (hR : d.rhoR x ≠ 0) : rateRtoL d x * d.rhoR x = realPos (- d.F x) := by
  unfold rateRtoL
  field_simp [hR]

end PhysicsSM.NullStrand.ZigZag
