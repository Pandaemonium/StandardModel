import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# The neutrino-ratio gap: within-carrier ratio prediction and a cross-generation no-go

This file accompanies the strategy note `NEUTRINO_RATIO_STRATEGY.md`.

## Setup

On the carrier sector block `B(lam, kappa)` the squared-mass spectrum is the
three-element level set

  `{ lam - kappa , lam , lam + kappa }`   (closure, mean, aperture)

The *only* finite data attached to one carrier are the two real couplings
`(lam, kappa)` together with a three-valued *sector level index* selecting one of
the three levels. There is no further discrete decoration (no generation index,
no cross-carrier scale) in the current data.

We formalise, from this spectrum alone and using Mathlib only:

* the honest **within-carrier positive prediction**: the three levels are an
  arithmetic progression, so the *dimensionless spacing ratio* is exactly `1`,
  scale-invariantly and shape-invariantly (`spec_spacing_ratio`,
  `spec_spacing_ratio_scale_invariant`); and

* the honest **no-go**: the structural data fixes only ratios *within* one block
  and *up to overall scale*; it pins down no absolute value and no cross-block
  ratio (`specMid_surjective`, `spectrum_scale_underdetermined`).
-/

namespace NeutrinoRatio

/-! ## The carrier sector spectrum `B(lam, kappa)` -/

/-- Lowest squared-mass level of `B(lam, kappa)` — the *closure* level.
This is the mass gap `lam - kappa` of the block. -/
def specLo (lam kappa : ℝ) : ℝ := lam - kappa

/-- Middle squared-mass level of `B(lam, kappa)` — the *mean* level.
It is independent of `kappa` (the closure/aperture coupling), which is why the
argument is unused: structurally, the central level is set by `lam` alone. -/
def specMid (lam _kappa : ℝ) : ℝ := lam

/-- Highest squared-mass level of `B(lam, kappa)` — the *aperture* level. -/
def specHi (lam kappa : ℝ) : ℝ := lam + kappa

/-- The three levels, packaged as a function of a three-valued sector index. -/
def spectrum (lam kappa : ℝ) : Fin 3 → ℝ
  | 0 => specLo lam kappa
  | 1 => specMid lam kappa
  | 2 => specHi lam kappa

/-! ## The honest positive: an exact within-carrier dimensionless prediction -/

/-- **Arithmetic-progression law.** The central level is the arithmetic mean of the
outer two. This is a *dimensionless, scale-free* structural constraint: it survives
any common rescaling of the couplings. -/
theorem specMid_eq_mean (lam kappa : ℝ) :
    specMid lam kappa = (specLo lam kappa + specHi lam kappa) / 2 := by
  unfold specLo specMid specHi; ring

/-- **Equal spacing.** The two gaps of the spectrum are equal (both `= kappa`). -/
theorem spec_equal_spacing (lam kappa : ℝ) :
    specMid lam kappa - specLo lam kappa
      = specHi lam kappa - specMid lam kappa := by
  unfold specLo specMid specHi; ring

/-- **The sharpest honest ratio prediction.** For any nonzero closure/aperture
coupling `kappa`, the dimensionless spacing ratio of the block equals exactly `1`.

*Kill condition:* if the two squared-mass gaps within a single carrier's sector are
measured to differ (ratio `≠ 1` beyond error), the structural model of that carrier
is falsified. -/
theorem spec_spacing_ratio (lam kappa : ℝ) (hk : kappa ≠ 0) :
    (specMid lam kappa - specLo lam kappa)
      / (specHi lam kappa - specMid lam kappa) = 1 := by
  unfold specLo specMid specHi
  rw [show lam - (lam - kappa) = kappa by ring,
      show lam + kappa - lam = kappa by ring, div_self hk]

/-- **Scale invariance of the prediction.** Rescaling *both* couplings by any nonzero
`s` (an absolute-scale change) leaves the spacing ratio at `1`. Hence the ratio is a
genuine dimensionless prediction: it does not depend on the unknown overall scale. -/
theorem spec_spacing_ratio_scale_invariant
    (lam kappa s : ℝ) (hk : kappa ≠ 0) (hs : s ≠ 0) :
    (specMid (s * lam) (s * kappa) - specLo (s * lam) (s * kappa))
      / (specHi (s * lam) (s * kappa) - specMid (s * lam) (s * kappa)) = 1 := by
  unfold specLo specMid specHi
  rw [show s * lam - (s * lam - s * kappa) = s * kappa by ring,
      show s * lam + s * kappa - s * lam = s * kappa by ring,
      div_self (mul_ne_zero hs hk)]

/-! ## The no-go: structural data fixes no absolute value and no cross-block scale -/

/-- **No absolute value is predicted.** The central level can be made equal to *any*
real number by a choice of couplings; the structural data alone therefore fixes no
mass value. (Take `lam = m`, `kappa` arbitrary.) -/
theorem specMid_surjective (m : ℝ) : ∃ lam kappa : ℝ, specMid lam kappa = m :=
  ⟨m, 0, rfl⟩

/-- **The spectrum is determined only up to overall scale.** Given any target
spectrum `B(lam, kappa)` with `lam ≠ 0` and any desired positive ratio `r` between a
second block's central level and this one's, there is a genuinely *different* carrier
whose spectrum is `r`-times this one, level by level. Two carriers thus cannot be
compared without an external scale choice: no cross-block (hence no cross-generation)
ratio is fixed by the structural data. -/
theorem spectrum_scale_underdetermined
    (lam kappa r : ℝ) :
    ∃ lam' kappa' : ℝ,
      (∀ i : Fin 3, spectrum lam' kappa' i = r * spectrum lam kappa i) := by
  refine ⟨r * lam, r * kappa, ?_⟩
  intro i
  fin_cases i <;> (unfold spectrum specLo specMid specHi; ring)

/-! ## Reading of the no-go for the neutrino mass ratio

A **mass-value map** would be a function

  `M : (lam kappa : ℝ) → (extra finite decorations) → (particle label) → ℝ`

returning a mass (or a mass ratio). The finite input actually available for one
carrier is exhausted by `(lam, kappa)` and the three-valued sector index
`Fin 3` of `spectrum` above.

* A neutrino mass **ratio** `m₂/m₃` (or `Δm²₂₁/Δm²₃₁`) needs *three generation
  eigenstates* plus a scale relating them. The tempting move — identify the three
  levels `spectrum lam kappa 0,1,2` with three generations — is blocked twice:
  those three levels are the closure/mean/aperture of *one* block (an internal
  Clifford-graded triple), not a family replication; and even if forced, the
  predicted `Δm²` ratio would be `1` (`spec_spacing_ratio`), i.e. arithmetic,
  whereas the observed neutrino `Δm²` splittings are strongly hierarchical.

* `spectrum_scale_underdetermined` shows there is no canonical scale relating two
  distinct carriers, so a genuine three-generation ratio (three distinct carriers)
  is not fixed. Supplying such a scale/texture is external input, not a prediction.

Hence: the within-carrier ratio `spec_spacing_ratio` is an honest prediction; the
cross-generation neutrino ratio is a category error at this generality. The precise
missing ingredient is a **generation index with an accompanying cross-carrier scale
map** (a Yukawa-like texture), which the current finite data does not contain and
cannot derive.
-/

end NeutrinoRatio
