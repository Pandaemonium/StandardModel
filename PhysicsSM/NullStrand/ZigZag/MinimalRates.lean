import Mathlib
import PhysicsSM.NullStrand.ZigZag.TransferCurrent

/-!
# NullStrand.ZigZag.MinimalRates

Ready finite identities for the minimal-rate decomposition
`rateLtoR = F⁺/ρL`, `rateRtoL = (-F)⁺/ρR`.
-/

noncomputable section

namespace PhysicsSM.NullStrand.ZigZag

open scoped BigOperators

/-- Positive rate and source fields are nonnegative. -/
theorem minimalRates_nonneg {X : Type*} (d : ChiralTransferData X) (x : X) :
    0 ≤ rateLtoR d x ∧ 0 ≤ rateRtoL d x := by
  constructor
  · unfold rateLtoR
    exact div_nonneg (realPos_nonneg (d.F x)) (d.rhoL_nonneg x)
  · unfold rateRtoL
    exact div_nonneg (realPos_nonneg (-d.F x)) (d.rhoR_nonneg x)

/-- Zero source current gives zero rates. -/
theorem minimalRates_zero_rates_of_zero_source {X : Type*} (d : ChiralTransferData X) (x : X) :
    d.F x = 0 → rateLtoR d x = 0 ∧ rateRtoL d x = 0 := by
  intro hFx
  constructor <;> simp [rateLtoR, rateRtoL, hFx, realPos]

/-- Net transfer recovers the signed source current. -/
theorem minimalRates_netTransfer {X : Type*} (d : ChiralTransferData X) (x : X) :
    rateLtoR d x * d.rhoL x - rateRtoL d x * d.rhoR x = d.F x := by
  by_cases hFx : d.F x = 0
  · have hZero := minimalRates_zero_rates_of_zero_source d x hFx
    rw [hZero.1, hZero.2, hFx]
    ring
  · have hLne : d.rhoL x ≠ 0 := by
      intro hL
      exact hFx (d.transfer_zero_of_rhoL_zero x hL)
    have hRne : d.rhoR x ≠ 0 := by
      intro hR
      exact hFx (d.transfer_zero_of_rhoR_zero x hR)
    have hposdiff : realPos (d.F x) - realPos (-d.F x) = d.F x := by
      exact realPos_sub_realPos_neg (d.F x)
    have hL : rateLtoR d x * d.rhoL x = realPos (d.F x) := by
      exact rateLtoR_mul_density d x hLne
    have hR : rateRtoL d x * d.rhoR x = realPos (-d.F x) := by
      exact rateRtoL_mul_density d x hRne
    rw [hL, hR, hposdiff]

/-- Net transfer with nonzero source is equivalent to numerator subtraction. -/
theorem minimalRates_netTransfer_of_source_ne_zero {X : Type*} (d : ChiralTransferData X) (x : X)
    (_hFx : d.F x ≠ 0) :
    rateLtoR d x * d.rhoL x - rateRtoL d x * d.rhoR x = d.F x := by
  exact minimalRates_netTransfer d x

end PhysicsSM.NullStrand.ZigZag
