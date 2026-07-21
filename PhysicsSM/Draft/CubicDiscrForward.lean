import Mathlib

/-!
# Forward cubic-discriminant direction: real-rooted implies `0 <= discr` (P7)

**Status: DRAFT (P7 flagship brick A).** The landed J4 module
(`PhysicsSM.Draft.CubicRealSpectrum`, Aristotle harvest, verified) proves
`0 <= discr -> three real roots`. This module proves the (elementary)
converse used to IMPORT discriminant nonnegativity from a real-rooted
witness: the discriminant of the monic Vieta cubic of real roots `r s t` is
the SQUARE of the Vandermonde product `(r-s)(s-t)(r-t)`.

Downstream (flagship composition): the Aristotle job
`h3o-reduction-lemmas-20260718` (d3298b14) produces real `r s t` whose
elementary symmetric functions equal the `h3(O)` invariant triple; by this
module the characteristic cubic then has `0 <= discr`; the landed
`h3o_real_spectrum_of_discr_nonneg` closes the UNCONDITIONAL real-spectrum
theorem for `h3(O)`.

Provenance: classical symmetric-function identity (discriminant =
Vandermonde squared); clean-room, kernel-checked by `ring`.
-/

namespace PhysicsSM.Draft.CubicDiscrForward

/-- The discriminant of the monic Vieta cubic of real roots `r s t` IS the
squared Vandermonde product. -/
theorem discr_vieta_eq_sq (r s t : ℝ) :
    (⟨1, -(r + s + t), r * s + r * t + s * t, -(r * s * t)⟩ : Cubic ℝ).discr
      = ((r - s) * (s - t) * (r - t)) ^ 2 := by
  unfold Cubic.discr
  ring

/-- **Real-rooted (Vieta form) implies nonnegative discriminant.** -/
theorem discr_vieta_nonneg (r s t : ℝ) :
    0 ≤ (⟨1, -(r + s + t), r * s + r * t + s * t,
          -(r * s * t)⟩ : Cubic ℝ).discr := by
  rw [discr_vieta_eq_sq]; positivity

/-- info: 'PhysicsSM.Draft.CubicDiscrForward.discr_vieta_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.CubicDiscrForward.discr_vieta_nonneg

end PhysicsSM.Draft.CubicDiscrForward
