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

/-! ## Minimal-coupling least-action uniqueness (ZZ least-action of rates)

The minimal rates are *one-sided*: at any point at most one chiral direction is
active, so the two rates never fire simultaneously. Among all nonnegative rate
pairs realizing the same net source current, this no-simultaneous-flow condition
singles out a unique minimal coupling, which is exactly `(rateLtoR, rateRtoL)`. -/

-- `realPos_mul_realPos_neg` now lives in the shared module
-- `PhysicsSM.NullStrand.RealPositivePart` (resolved here via parent-namespace lookup).

/-- The two minimal rates never fire simultaneously: their product vanishes. -/
theorem minimalRates_product_zero {X : Type*} (d : ChiralTransferData X) (x : X) :
    rateLtoR d x * rateRtoL d x = 0 := by
  unfold rateLtoR rateRtoL
  rw [div_mul_div_comm, realPos_mul_realPos_neg, zero_div]

/-- **Least-action rate uniqueness.** With strictly positive densities, the minimal
rates `(rateLtoR, rateRtoL)` are the unique nonnegative pair that both realizes the
net source current and carries no simultaneous two-way flow (`a * b = 0`). -/
theorem minimalRates_unique {X : Type*} (d : ChiralTransferData X) (x : X)
    (hLpos : 0 < d.rhoL x) (hRpos : 0 < d.rhoR x)
    (a b : ℝ) (_ha : 0 ≤ a) (_hb : 0 ≤ b)
    (hnet : a * d.rhoL x - b * d.rhoR x = d.F x) (hmin : a * b = 0) :
    a = rateLtoR d x ∧ b = rateRtoL d x := by
  rcases mul_eq_zero.mp hmin with ha0 | hb0
  · subst ha0
    have hF : d.F x = -(b * d.rhoR x) := by linarith
    have hFle : d.F x ≤ 0 := by rw [hF]; nlinarith
    refine ⟨?_, ?_⟩
    · unfold rateLtoR realPos
      rw [max_eq_right hFle]; simp
    · unfold rateRtoL realPos
      have hneg : -d.F x = b * d.rhoR x := by rw [hF]; ring
      rw [hneg, max_eq_left (by nlinarith)]
      field_simp
  · subst hb0
    have hF : d.F x = a * d.rhoL x := by linarith
    have hFge : 0 ≤ d.F x := by rw [hF]; nlinarith
    refine ⟨?_, ?_⟩
    · unfold rateLtoR realPos
      rw [hF, max_eq_left (by nlinarith)]
      field_simp
    · unfold rateRtoL realPos
      have hneg : -d.F x ≤ 0 := by linarith
      rw [max_eq_right hneg]; simp

end PhysicsSM.NullStrand.ZigZag
