import Mathlib
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate

/-!
# Gate C2: EXISTENCE of a certified overlap sign

This Draft module closes the existence half of the finite overlap sign-certificate
story (the uniqueness half is `OverlapSignCertificate.certifiedSign_unique`).  It
proves that for every gapped (invertible) Hermitian `H` a certificate EXISTS, by
exhibiting the explicit candidate

    epsCFC H := CFC.sqrt (H ^ 2) * H⁻¹        -- i.e. |H| H⁻¹

and proving `SignCertificate H (epsCFC H)` (`certifiedSign_exists`).  Combined with
`certifiedSign_unique`, the certified overlap sign of any gapped Hermitian `H` is
both well-defined and explicitly `|H| H⁻¹` (`certifiedSign_eq_epsCFC`) - answering
the red-team (ee95ba08) "existence not formalized" gap.

The core proof was produced by Aristotle (project 66972f62, kernel-checked, axiom
footprint `[propext, Classical.choice, Quot.sound]`) following the strategy: with
`A := CFC.sqrt (H^2)`, `A^2 = H^2` (`CFC.sq_sqrt`), `A` PSD (`CFC.sqrt_nonneg`),
and the load-bearing commutation `Commute A H` (`Commute.cfcₙ_nnreal`, since
`CFC.sqrt = cfcₙ NNReal.sqrt` and `H` commutes with `H^2`); then `epsCFC H * H = A`
gives all three certificate conditions.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (finite certified-sign existence).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapSignExistence

open Matrix
open scoped ComplexOrder
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate

-- The Loewner order + CFC instances on complex matrices are `abbrev`/scoped;
-- activate them locally for the positive-semidefinite square-root API.
attribute [local instance] Matrix.instPartialOrder Matrix.instStarOrderedRing
  Matrix.instNonnegSpectrumClass

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- The explicit candidate certified sign `|H| * H⁻¹`. -/
def epsCFC (H : Matrix n n ℂ) [Invertible H] : Matrix n n ℂ :=
  CFC.sqrt (H ^ 2) * (⅟H)

/-- **EXISTENCE of a certified sign.**  For a gapped (invertible) Hermitian `H`,
the explicit candidate `epsCFC H = |H| H⁻¹` is a sign certificate for `H`.
Together with `certifiedSign_unique` this shows the overlap sign is well-defined
for every gapped Hermitian `H`.  (Aristotle project 66972f62.) -/
theorem certifiedSign_exists (H : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) :
    SignCertificate H (epsCFC H) := by
  set A := CFC.sqrt (H ^ 2) with hA
  have hpsd2 : (H ^ 2).PosSemidef := by
    have hsq : H ^ 2 = Hᴴ * H := by rw [hHherm.eq, sq]
    rw [hsq]; exact Matrix.posSemidef_conjTranspose_mul_self H
  have hA_sq : A ^ 2 = H ^ 2 := CFC.sq_sqrt (a := H ^ 2) (nonneg_iff_posSemidef.mpr hpsd2)
  have hApsd : A.PosSemidef := nonneg_iff_posSemidef.mp (CFC.sqrt_nonneg (H ^ 2))
  have hcomm : Commute A H := by
    have hc : Commute (H ^ 2) H := (Commute.refl H).pow_left 2
    rw [hA]; unfold CFC.sqrt; exact hc.cfcₙ_nnreal NNReal.sqrt
  have hcommInv : Commute A (⅟H) := hcomm.invOf_right
  have hepsH : epsCFC H * H = A := by
    unfold epsCFC; rw [← hA, mul_assoc, invOf_mul_self, mul_one]
  refine ⟨?_, ?_, ?_⟩
  · -- involution: (A * ⅟H) * (A * ⅟H) = 1
    unfold epsCFC; rw [← hA]
    have h1 : A * ⅟H * (A * ⅟H) = A * A * (⅟H * ⅟H) := by
      rw [mul_assoc, ← mul_assoc (⅟H), ← hcommInv.eq, mul_assoc, mul_assoc]
    rw [h1, ← sq, ← sq, hA_sq, sq, sq]
    rw [mul_assoc H H, ← mul_assoc H (⅟H), mul_invOf_self, one_mul, mul_invOf_self]
  · -- commutation: (A * ⅟H) * H = H * (A * ⅟H), both equal A
    rw [hepsH]
    unfold epsCFC; rw [← hA, ← mul_assoc, ← hcomm.eq, mul_assoc, mul_invOf_self, mul_one]
  · -- positivity: (epsCFC H) * H = A is PSD
    rw [hepsH]; exact hApsd

/-- **The certified overlap sign is well-defined and explicit.**  For a gapped
Hermitian `H`, every sign certificate equals `epsCFC H = |H| H⁻¹` (existence +
uniqueness). -/
theorem certifiedSign_eq_epsCFC (H eps : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) (hc : SignCertificate H eps) :
    eps = epsCFC H :=
  certifiedSign_unique H eps (epsCFC H) hHherm hc (certifiedSign_exists H hHherm)

end OverlapSignExistence
end GateC2
end NullEdge
end Draft
end PhysicsSM
