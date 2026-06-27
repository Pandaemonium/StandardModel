import Mathlib
import PhysicsSM.Algebra.Jordan.DVTTwoSidedStabilizerMoonshot
import PhysicsSM.Algebra.Jordan.DVTTwoSidedSU3QuotientStabilizer
import PhysicsSM.Algebra.Jordan.DVTTwoSidedActionKernelZ3Iff

/-!
# Algebra.Jordan.DVTTwoSidedImageEquiv

The quotient `(SU(3) × SU(3)ᵐᵒᵖ) / ℤ₃` is multiplicatively equivalent to its
image inside `AddAut H3OComplement`, via the faithful quotient action
`dvtQuotientStabilizerHom`.

## Main declarations

- `dvtQuotientImageSubgroup` - the image (range) of the quotient homomorphism
  as a subgroup of `AddAut H3OComplement`.
- `dvtQuotientImageEquiv` - the multiplicative equivalence
  `DVTTwoSidedSU3Quotient ≃* dvtQuotientImageSubgroup`.
- `dvtQuotientImageEquiv_apply` - evaluation: the equivalence agrees with
  the quotient homomorphism.
- `dvtQuotientImageSubgroup_mem_iff` - membership characterization: an
  automorphism lies in the image subgroup iff it is in the range of
  `dvtQuotientStabilizerHom`.
- `dvtQuotientStabilizerHom_identityFiber_z3_clean` - the identity fiber of
  the pair-level homomorphism is exactly the central `ℤ₃`, restated to
  compose cleanly with the image equivalence.

## Claim boundary

This is an algebraic image/quotient theorem. It does not claim topology,
smoothness, or the full exceptional Jordan stabilizer theorem.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O
open Matrix Complex

/-! ### Image subgroup -/

/-- The image of the quotient homomorphism as a subgroup of
    `AddAut H3OComplement`. -/
noncomputable def dvtQuotientImageSubgroup : Subgroup (AddAut H3OComplement) :=
  dvtQuotientStabilizerHom.range

/-! ### Multiplicative equivalence -/

/-- The multiplicative equivalence between the quotient
    `DVTTwoSidedSU3Quotient = (SU(3) × SU(3)ᵐᵒᵖ) / ℤ₃` and its image
    inside `AddAut H3OComplement`. -/
noncomputable def dvtQuotientImageEquiv :
    DVTTwoSidedSU3Quotient ≃* dvtQuotientImageSubgroup :=
  MonoidHom.ofInjective dvtQuotientStabilizerHom_injective

/-! ### Evaluation lemma -/

/-- The image equivalence agrees with the quotient homomorphism on
    underlying automorphisms. -/
theorem dvtQuotientImageEquiv_apply (x : DVTTwoSidedSU3Quotient) :
    (dvtQuotientImageEquiv x : AddAut H3OComplement) =
      dvtQuotientStabilizerHom x :=
  MonoidHom.ofInjective_apply dvtQuotientStabilizerHom_injective

/-! ### Membership characterization -/

/-- An additive automorphism lies in the image subgroup if and only if it
    is in the range of the quotient homomorphism. -/
theorem dvtQuotientImageSubgroup_mem_iff (f : AddAut H3OComplement) :
    f ∈ dvtQuotientImageSubgroup ↔
      ∃ x : DVTTwoSidedSU3Quotient, dvtQuotientStabilizerHom x = f := by
  simp [dvtQuotientImageSubgroup, MonoidHom.mem_range]

/-! ### Identity fiber (clean restatement) -/

/-- The identity fiber of the pair-level automorphism homomorphism is exactly
    the central `ℤ₃` scalar, restated for clean composition with the image
    equivalence.

    If a pair `(A, Bᵐᵒᵖ)` maps to the identity in `AddAut H3OComplement`,
    then `A = z • I` and `B = z⁻¹ • I` for a cube root of unity `z`. -/
theorem dvtQuotientStabilizerHom_identityFiber_z3_clean
    (p : DVTTwoSidedSU3Pair)
    (hp : dvtTwoSidedSU3AutHom p = 1) :
    ∃ z : DVTZ3CentralScalar,
      (p.1.unit : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
      (p.2.unop.unit : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
      dvtQuotientStabilizerHom (dvtTwoSidedSU3KerCon.mk' p) = 1 := by
  obtain ⟨z, hA, hB⟩ := dvtQuotientStabilizerHom_identityFiber_z3 p hp
  exact ⟨z, hA, hB, by rw [dvtQuotientStabilizerHom_mk]; exact hp⟩

/-! ### Bundled package -/

/-- The bundled DVT quotient-to-image equivalence package. -/
structure DVTTwoSidedImageEquivPackage where
  /-- The image of the quotient action as a subgroup of the automorphism
      group. -/
  imageSubgroup : Subgroup (AddAut H3OComplement)
  /-- Multiplicative equivalence from the quotient to its image. -/
  quotientEquivImage : DVTTwoSidedSU3Quotient ≃* imageSubgroup
  /-- The equivalence agrees with the quotient homomorphism. -/
  quotientEquivImage_apply :
    ∀ x : DVTTwoSidedSU3Quotient,
      (quotientEquivImage x : AddAut H3OComplement) =
        dvtQuotientStabilizerHom x
  /-- An automorphism lies in the image subgroup iff it is hit by the
      quotient homomorphism. -/
  image_membership :
    ∀ f : AddAut H3OComplement,
      f ∈ imageSubgroup ↔
        ∃ x : DVTTwoSidedSU3Quotient,
          dvtQuotientStabilizerHom x = f
  /-- The identity fiber of the pair-level homomorphism is the central ℤ₃. -/
  identityFiber_z3 :
    ∀ p : DVTTwoSidedSU3Pair,
      dvtTwoSidedSU3AutHom p = 1 →
        ∃ z : DVTZ3CentralScalar,
          (p.1.unit : Matrix (Fin 3) (Fin 3) ℂ) =
            (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
          (p.2.unop.unit : Matrix (Fin 3) (Fin 3) ℂ) =
            (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)

/-- The DVT quotient-to-image equivalence package, witnessing that
    `(SU(3) × SU(3)ᵐᵒᵖ) / ℤ₃` is multiplicatively equivalent to its
    image inside `AddAut H3OComplement`. -/
noncomputable def dvtTwoSidedImageEquivPackage :
    DVTTwoSidedImageEquivPackage where
  imageSubgroup := dvtQuotientImageSubgroup
  quotientEquivImage := dvtQuotientImageEquiv
  quotientEquivImage_apply := dvtQuotientImageEquiv_apply
  image_membership := dvtQuotientImageSubgroup_mem_iff
  identityFiber_z3 := dvtQuotientStabilizerHom_identityFiber_z3

end PhysicsSM.Algebra.Jordan.DVTAction
