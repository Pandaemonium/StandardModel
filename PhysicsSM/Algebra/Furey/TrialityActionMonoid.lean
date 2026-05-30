import Mathlib
import PhysicsSM.Algebra.Furey.TrialityTripleModule

/-!
# Triality action data as a monoid

This module upgrades `TrialityActionData` with a monoid structure under
componentwise composition and proves that `toLinearEnd` is a monoid
homomorphism into the endomorphism algebra of `TrialityTriple M`.

Main declarations:
- `instOneTrialityActionData` — identity action datum.
- `instMulTrialityActionData` — componentwise composition.
- `instMonoidTrialityActionData` — monoid instance.
- `TrialityActionData.toLinearEndMonoidHom` — monoid homomorphism into
  `Module.End K (TrialityTriple M)`.

Source motivation:
- Cohl Furey and Mia Hughes, "Three Generations and a Trio of Trialities",
  arXiv:2409.17948.

Claim boundary:
- This is a formal API theorem about the project scaffold.
- We do not claim these actions are the full `tri(C) + tri(H) + tri(O)` Lie
  algebra or the Standard Model internal symmetry action.

Status: trusted module; all proofs are kernel-checked without placeholder
declarations.
-/

namespace PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold

open PhysicsSM.Algebra.Furey

variable {K : Type*} [CommSemiring K]
variable {M : Type*} [AddCommMonoid M] [Module K M]

/-! ## `One` and `Mul` instances -/

instance instOneTrialityActionData :
    One (TrialityActionData K M) where
  one := TrialityActionData.id

instance instMulTrialityActionData :
    Mul (TrialityActionData K M) where
  mul rho sigma := rho.comp sigma

@[simp] theorem TrialityActionData.one_def :
    (1 : TrialityActionData K M) = TrialityActionData.id :=
  rfl

@[simp] theorem TrialityActionData.mul_def
    (rho sigma : TrialityActionData K M) :
    rho * sigma = rho.comp sigma :=
  rfl

/-! ## Monoid instance -/

instance instMonoidTrialityActionData :
    Monoid (TrialityActionData K M) where
  mul_assoc rho sigma tau := by
    ext <;> simp [TrialityActionData.comp]
  one_mul rho := by
    ext <;> simp [TrialityActionData.comp, TrialityActionData.id]
  mul_one rho := by
    ext <;> simp [TrialityActionData.comp, TrialityActionData.id]

/-! ## Monoid homomorphism to linear endomorphisms -/

/--
The monoid homomorphism from `TrialityActionData K M` to the endomorphism
monoid `Module.End K (TrialityTriple M)`, sending each action datum to the
linear map that applies its three endomorphisms componentwise.
-/
def TrialityActionData.toLinearEndMonoidHom :
    TrialityActionData K M →* Module.End K (TrialityTriple M) where
  toFun := TrialityActionData.toLinearEnd
  map_one' := TrialityActionData.toLinearEnd_id
  map_mul' rho sigma := TrialityActionData.toLinearEnd_comp rho sigma

end PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold
