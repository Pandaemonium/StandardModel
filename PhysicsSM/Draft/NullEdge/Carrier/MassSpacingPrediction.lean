/-
# A within-carrier dimensionless prediction: the three mass levels are equally spaced

DRAFT (kernel-clean; no `s o r r y`). The carrier sector block `MassGapWitness.B
λ κ` has squared-mass spectrum `{λ-κ, λ, λ+κ}` (`MassGapWitness.B_spectrum`). Those
three levels form an **arithmetic progression** — the central level is the mean of
the outer two — so the model makes one sharp, *scale-free* dimensionless prediction:

  `(m²_mid − m²_lo) / (m²_hi − m²_mid) = 1`   (for closure `κ ≠ 0`),

independent of the unknown overall scale (`spec_spacing_ratio_scale_invariant`).

**Kill condition.** If the two within-sector squared-mass gaps of a single carrier
measure to a ratio `≠ 1`, that carrier's structural model is falsified.

## Scope (the neutrino-ratio boundary, honest)

This is a *within-carrier* prediction. It is **not** the neutrino mass ratio: that
is a *cross-generation* quantity (`m₂/m₃` of three distinct mass eigenstates) and
is an honest **boundary** of the program, not a pending calculation — the finite
structural data of one carrier has no family/replication index selecting three
carriers, and no cross-carrier scale relating their normalizations; both are
external (Yukawa-like) inputs the theory does not derive (Aristotle no-go,
`allmass-strategy-neutrino-20260708`). Naively identifying the three levels of one
block with three generations fails twice: they are one sector's closure/mean/
aperture (not a replication), and they would predict an *arithmetic* `Δm²` ratio of
`1`, contradicting the observed hierarchical neutrino splittings.

## Provenance

All-mass solo run 2026-07-08 [orig]. Proofs from Aristotle (standalone package
`AgentTasks/aristotle-standalone/allmass-strategy-neutrino-20260708`), reviewed for
semantic alignment and re-based here; the three levels match
`MassGapWitness.B_spectrum = {λ-κ, λ, λ+κ}`. Mathlib-only + `MassGapWitness`.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness

namespace PhysicsSM.Draft.NullEdge.Carrier.MassSpacingPrediction

/-- The lowest squared-mass level `λ − κ` (= the mass gap, aperture − closure). -/
def specLo (lam kappa : ℝ) : ℝ := lam - kappa
/-- The central squared-mass level `λ` (aperture). -/
def specMid (lam kappa : ℝ) : ℝ := lam
/-- The highest squared-mass level `λ + κ` (aperture + closure). -/
def specHi (lam kappa : ℝ) : ℝ := lam + kappa

/-- The three levels match the carrier block's kernel-checked spectrum
`MassGapWitness.B_spectrum = {λ-κ, λ, λ+κ}`. -/
theorem levels_eq_spectrum (lam kappa : ℝ) :
    ({specLo lam kappa, specMid lam kappa, specHi lam kappa} : Set ℝ)
      = spectrum ℝ (MassGapWitness.B lam kappa) := by
  rw [MassGapWitness.B_spectrum]; rfl

/-- **Arithmetic-progression law.** The central level is the arithmetic mean of the
outer two — a dimensionless, scale-free structural constraint. -/
theorem specMid_eq_mean (lam kappa : ℝ) :
    specMid lam kappa = (specLo lam kappa + specHi lam kappa) / 2 := by
  unfold specLo specMid specHi; ring

/-- **Equal spacing.** The two adjacent squared-mass gaps are equal. -/
theorem spec_equal_spacing (lam kappa : ℝ) :
    specMid lam kappa - specLo lam kappa
      = specHi lam kappa - specMid lam kappa := by
  unfold specLo specMid specHi; ring

/-- **The dimensionless prediction.** For closure `κ ≠ 0`, the ratio of the two
adjacent squared-mass gaps is exactly `1`. -/
theorem spec_spacing_ratio (lam kappa : ℝ) (hk : kappa ≠ 0) :
    (specMid lam kappa - specLo lam kappa)
      / (specHi lam kappa - specMid lam kappa) = 1 := by
  unfold specLo specMid specHi
  rw [div_eq_one_iff_eq] <;> [ring; simpa using hk]

/-- **Scale invariance.** The prediction survives any common rescaling `s ≠ 0` of
the couplings — it is a genuinely dimensionless structural claim. -/
theorem spec_spacing_ratio_scale_invariant
    (lam kappa s : ℝ) (hk : kappa ≠ 0) (hs : s ≠ 0) :
    (specMid (s * lam) (s * kappa) - specLo (s * lam) (s * kappa))
      / (specHi (s * lam) (s * kappa) - specMid (s * lam) (s * kappa)) = 1 := by
  apply spec_spacing_ratio
  exact mul_ne_zero hs hk

end PhysicsSM.Draft.NullEdge.Carrier.MassSpacingPrediction
