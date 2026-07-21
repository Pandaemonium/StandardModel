import PhysicsSM.Draft.H3OReductionLemmas
import PhysicsSM.Draft.H3OSigmaClosedForm
import PhysicsSM.Draft.CubicDiscrForward

/-!
# The unconditional real-spectrum theorem for `h3(O)` (P7 flagship, brick D)

**Status: FLAGSHIP COMPOSITION.** Every Hermitian `3x3` octonionic matrix
has a REAL eigenvalue triple realizing its Freudenthal invariants - with NO
discriminant hypothesis. Composition of:

1. `exists_complex_witness` (Aristotle d3298b14, verified): the off-diagonal
   octonion triple is replaced by a complex triple with the same norms and
   real triple product (composition law + free phase);
2. `hermitian_cubic_real_rooted` (same job): the complex Hermitian matrix
   with that data has three real numbers realizing the invariant
   combinations (Mathlib `IsHermitian.charpoly_eq`);
3. `sigmaH3O_closed_form` + the definitional `detH3O`/`trace` forms;
4. corollary: `0 <= (charCubic X).discr` via the landed Vandermonde-square
   identity (`discr_vieta_eq_sq`) - closing the "remaining analytic step"
   pre-registered in `H3OSpectralInvariants`.

Claim label: `M [orig formalization; comp Dray-Manogue math-ph/9910004
(the classical reality statement); route original to this campaign
(complex-witness reduction, not Dray-Manogue's construction and not SOS)]`.
Dray-Manogue prove eigenvalue reality for the Jordan eigenvalue problem;
this module proves the characteristic-cubic version through the invariant
triple, kernel-checked end to end.
-/

noncomputable section

namespace PhysicsSM.Draft.H3ORealSpectrumUnconditional

open PhysicsSM.Algebra.Jordan.H3O
open PhysicsSM.Draft.H3OCharacteristicEquation
open PhysicsSM.Draft.H3OSpectralInvariants
open PhysicsSM.Draft.H3OReductionLemmas
open PhysicsSM.Draft.H3OSigmaClosedForm
open PhysicsSM.Draft.CubicDiscrForward

/-- **The unconditional `h3(O)` real-spectrum theorem**: every element has a
real triple `(r, s, t)` whose elementary symmetric functions are EXACTLY the
Freudenthal invariants `(trace, sigma, det)` - no hypothesis. -/
theorem h3o_real_spectrum (X : H3O) :
    ∃ r s t : ℝ, trace X = r + s + t ∧
      sigmaH3O X = r * s + r * t + s * t ∧ detH3O X = r * s * t := by
  obtain ⟨x', y', z', hx, hy, hz, htriple⟩ :=
    exists_complex_witness X.x X.y X.z
  obtain ⟨r, s, t, h1, h2, h3⟩ :=
    hermitian_cubic_real_rooted X.alpha X.beta X.gamma x' y' z'
  refine ⟨r, s, t, ?_, ?_, ?_⟩
  · simp [trace, h1]
  · rw [sigmaH3O_closed_form, ← hx, ← hy, ← hz, h2]
  · unfold detH3O
    rw [← hx, ← hy, ← hz, ← htriple, h3]

/-- **Discriminant nonnegativity for `h3(O)`** - the analytic step
pre-registered in `H3OSpectralInvariants` is now a THEOREM: the
characteristic cubic of every element has nonnegative discriminant. -/
theorem h3o_charCubic_discr_nonneg (X : H3O) :
    0 ≤ (charCubic X).discr := by
  obtain ⟨r, s, t, h1, h2, h3⟩ := h3o_real_spectrum X
  have hcubic : charCubic X
      = ⟨1, -(r + s + t), r * s + r * t + s * t, -(r * s * t)⟩ := by
    unfold charCubic
    rw [h1, h2, h3]
  rw [hcubic]
  exact discr_vieta_nonneg r s t

/-- info: 'PhysicsSM.Draft.H3ORealSpectrumUnconditional.h3o_real_spectrum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.H3ORealSpectrumUnconditional.h3o_real_spectrum

/-- info: 'PhysicsSM.Draft.H3ORealSpectrumUnconditional.h3o_charCubic_discr_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.H3ORealSpectrumUnconditional.h3o_charCubic_discr_nonneg

end PhysicsSM.Draft.H3ORealSpectrumUnconditional
