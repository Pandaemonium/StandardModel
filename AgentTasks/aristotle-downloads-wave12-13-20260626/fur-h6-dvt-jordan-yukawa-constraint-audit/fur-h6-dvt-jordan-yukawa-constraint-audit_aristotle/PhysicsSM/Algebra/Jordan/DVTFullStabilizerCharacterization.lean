import Mathlib
import PhysicsSM.Algebra.Jordan.DVTTwoSidedImageEquiv

/-!
# Algebra.Jordan.DVTFullStabilizerCharacterization

Full algebraic stabilizer characterization for the DVT/Yokota quotient
action on the complement of `h₃(ℂ)` in `h₃(𝕆)`.

## Mathematical context

The Dubois-Violette–Todorov (DVT) / Yokota framework provides a two-sided
matrix action `X ↦ A * X * B` of `SU(3) × SU(3)ᵐᵒᵖ` on the complement
of `h₃(ℂ)` inside the exceptional Jordan algebra `h₃(𝕆)`. Previous modules
established:

- **Faithful quotient action**: the quotient `(SU(3) × SU(3)ᵐᵒᵖ) / ℤ₃`
  embeds injectively into `AddAut H3OComplement`
  (`DVTTwoSidedStabilizerMoonshot`).
- **Image equivalence**: the quotient is multiplicatively equivalent to its
  image subgroup (`DVTTwoSidedImageEquiv`).

This module completes the picture by providing a **natural algebraic
characterization** of the image: an additive automorphism of the complement
lies in the image if and only if, in the `M₃(ℂ)` coordinate model, it has
the form `X ↦ AXB` for invertible matrices `A, B` with `det A = 1` and
`det B = 1`.

## Main declarations

- `IsDVTTwoSidedCompatible` — predicate: the automorphism has the form
  `X ↦ AXB` in the `M₃(ℂ)` model with `det A = det B = 1`.
- `dvtPairAddEquiv_coordinate` — coordinate equation for the pair action
  through `h3oComplementEquivM3C`.
- `dvtQuotientImage_isDVTTwoSidedCompatible` — forward: every image
  element is DVT-compatible.
- `isDVTTwoSidedCompatible_mem_dvtQuotientImageSubgroup` — backward:
  every DVT-compatible automorphism lies in the image.
- `dvtQuotientImageSubgroup_mem_iff_twoSidedCompatible` — the iff
  characterization.
- `dvtCompatibleComplementStabilizer` — the subgroup of DVT-compatible
  automorphisms.
- `dvtCompatibleComplementStabilizer_eq` — this subgroup equals the
  image subgroup.
- `dvtFullStabilizerEquiv` — the multiplicative equivalence
  `DVTTwoSidedSU3Quotient ≃* dvtCompatibleComplementStabilizer`.
- `dvtImage_det_preserving` — every image automorphism preserves the
  matrix determinant in the `M₃(ℂ)` model.
- `DVTFullStabilizerCharacterizationPackage` — bundled package.

## Claim boundary

This is an algebraic stabilizer characterization in the coordinate/matrix
model. It does NOT prove:
- Jordan-product preservation by the two-sided action,
- topological Lie-group structure, compactness, or smoothness,
- the full exceptional Jordan automorphism theorem `Aut(h₃(𝕆)) ≅ F₄`,
- that `SU(3)` is the same as the *unitary* group (the formalization
  uses `det = 1` invertible matrices, i.e. `SL(3,ℂ)`-style data).

## Sources

- Dubois-Violette and Todorov, arXiv:1806.09450.
- Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
- Yokota, "Exceptional Lie Groups", arXiv:0902.0431, Chapter 3.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O
open Matrix Complex

/-! ## The DVT-compatible predicate -/

/-- An additive automorphism of the complement is **DVT two-sided
    compatible** if, in the `M₃(ℂ)` coordinate model, it has the form
    `X ↦ AXB` for invertible matrices `A, B` with
    `det A = 1` and `det B = 1`. -/
def IsDVTTwoSidedCompatible (f : AddAut H3OComplement) : Prop :=
  ∃ (A B : Units (Matrix (Fin 3) (Fin 3) ℂ)),
    (A : Matrix (Fin 3) (Fin 3) ℂ).det = 1 ∧
    (B : Matrix (Fin 3) (Fin 3) ℂ).det = 1 ∧
    ∀ w : H3OComplement,
      h3oComplementEquivM3C (f w) =
        (A : Matrix (Fin 3) (Fin 3) ℂ) *
          h3oComplementEquivM3C w *
            (B : Matrix (Fin 3) (Fin 3) ℂ)

/-! ## Coordinate equation for the pair action -/

/-- The pair action, transported to the `M₃(ℂ)` coordinate model, is
    the two-sided matrix multiplication `X ↦ AXB`. -/
theorem dvtPairAddEquiv_coordinate
    (p : DVTTwoSidedSU3Pair) (w : H3OComplement) :
    h3oComplementEquivM3C (dvtTwoSidedSU3PairAddEquiv p w) =
      (p.1.unit : Matrix (Fin 3) (Fin 3) ℂ) *
        h3oComplementEquivM3C w *
          (p.2.unop.unit : Matrix (Fin 3) (Fin 3) ℂ) :=
  h3oComplementEquivM3C_twoSidedAction _ _ _

/-! ## Forward direction: image elements are DVT-compatible -/

/-
Every element of the image subgroup is DVT two-sided compatible.
-/
theorem dvtQuotientImage_isDVTTwoSidedCompatible
    (f : AddAut H3OComplement)
    (hf : f ∈ dvtQuotientImageSubgroup) :
    IsDVTTwoSidedCompatible f := by
  obtain ⟨p, rfl⟩ := MonoidHom.mem_range.mp hf
  obtain ⟨q, rfl⟩ := Quotient.exists_rep p
  exact ⟨_, _, q.1.det_one, q.2.unop.det_one,
    fun w => dvtPairAddEquiv_coordinate q w⟩

/-! ## Backward direction: DVT-compatible → in image -/

/-
Every DVT two-sided compatible automorphism lies in the image
    subgroup.
-/
theorem isDVTTwoSidedCompatible_mem_dvtQuotientImageSubgroup
    (f : AddAut H3OComplement)
    (hf : IsDVTTwoSidedCompatible f) :
    f ∈ dvtQuotientImageSubgroup := by
  obtain ⟨A, B, hdetA, hdetB, hcoord⟩ := hf
  let p : DVTTwoSidedSU3Pair :=
    (⟨A, hdetA⟩, MulOpposite.op ⟨B, hdetB⟩)
  refine ⟨dvtTwoSidedSU3KerCon.mk' p, ?_⟩
  refine AddEquiv.ext fun w => ?_
  exact h3oComplementEquivM3C.injective
    (by rw [dvtQuotientStabilizerHom_mk,
            dvtPairAddEquiv_coordinate]; exact (hcoord w).symm)

/-! ## Iff characterization -/

/-- An additive automorphism lies in the image subgroup if and only if
    it is DVT two-sided compatible. -/
theorem dvtQuotientImageSubgroup_mem_iff_twoSidedCompatible
    (f : AddAut H3OComplement) :
    f ∈ dvtQuotientImageSubgroup ↔ IsDVTTwoSidedCompatible f :=
  ⟨dvtQuotientImage_isDVTTwoSidedCompatible f,
   isDVTTwoSidedCompatible_mem_dvtQuotientImageSubgroup f⟩

/-! ## DVT-compatible stabilizer subgroup -/

/-
The subgroup of DVT two-sided compatible automorphisms.
-/
noncomputable def dvtCompatibleComplementStabilizer :
    Subgroup (AddAut H3OComplement) where
  carrier := { f | IsDVTTwoSidedCompatible f }
  mul_mem' := by
    intro a b ha hb
    obtain ⟨A₁, B₁, hA₁, hB₁, h₁⟩ := ha
    obtain ⟨A₂, B₂, hA₂, hB₂, h₂⟩ := hb
    exact ⟨A₁ * A₂, B₂ * B₁,
      by simp [hA₁, hA₂], by simp [hB₁, hB₂],
      fun w => by simp [h₁, h₂, mul_assoc]⟩
  one_mem' :=
    ⟨1, 1, by simp, by simp, fun w => by simp⟩
  inv_mem' := by
    intro a ha
    obtain ⟨A, B, hA, hB, h⟩ := ha
    refine ⟨A⁻¹, B⁻¹, by simp [hA], by simp [hB],
      fun w => ?_⟩
    have := h ( a⁻¹ w ) ; simp_all +decide [ mul_assoc ] ;

/-- The DVT-compatible stabilizer subgroup equals the image
    subgroup. -/
theorem dvtCompatibleComplementStabilizer_eq :
    dvtCompatibleComplementStabilizer =
      dvtQuotientImageSubgroup := by
  ext f
  simp [dvtCompatibleComplementStabilizer,
    dvtQuotientImageSubgroup_mem_iff_twoSidedCompatible]

/-! ## Full stabilizer equivalence -/

/-- The multiplicative equivalence between the DVT quotient and the
    DVT-compatible complement stabilizer. This is the main stabilizer
    characterization theorem: the quotient `(SU(3) × SU(3)ᵐᵒᵖ) / ℤ₃`
    is isomorphic, as a group, to the subgroup of complement
    automorphisms that have the form `X ↦ AXB` in the `M₃(ℂ)` model
    with `det A = det B = 1`. -/
noncomputable def dvtFullStabilizerEquiv :
    DVTTwoSidedSU3Quotient ≃*
      dvtCompatibleComplementStabilizer :=
  dvtQuotientImageEquiv.trans
    (MulEquiv.subgroupCongr
      dvtCompatibleComplementStabilizer_eq.symm)

/-! ## Determinant preservation -/

/-- Every DVT-compatible automorphism preserves the matrix determinant
    in the `M₃(ℂ)` coordinate model. -/
theorem dvtImage_det_preserving
    (f : AddAut H3OComplement)
    (hf : IsDVTTwoSidedCompatible f)
    (w : H3OComplement) :
    (h3oComplementEquivM3C (f w)).det =
      (h3oComplementEquivM3C w).det := by
  obtain ⟨A, B, hA, hB, h⟩ := hf
  simp [h, hA, hB]

/-! ## Bundled package -/

/-- The bundled DVT full stabilizer characterization package. -/
structure DVTFullStabilizerCharacterizationPackage where
  /-- The natural algebraic predicate for DVT-compatible
      automorphisms. -/
  predicate : AddAut H3OComplement → Prop
  /-- The predicate subgroup. -/
  stabilizerSubgroup : Subgroup (AddAut H3OComplement)
  /-- The image subgroup equals the predicate subgroup. -/
  image_eq_stabilizer :
    dvtQuotientImageSubgroup = stabilizerSubgroup
  /-- Multiplicative equivalence from the quotient to the
      stabilizer. -/
  quotientEquivStabilizer :
    DVTTwoSidedSU3Quotient ≃* stabilizerSubgroup
  /-- Iff characterization: membership in the image is equivalent
      to the predicate. -/
  mem_iff :
    ∀ f : AddAut H3OComplement,
      f ∈ dvtQuotientImageSubgroup ↔ predicate f
  /-- The quotient homomorphism is injective. -/
  quotientHom_injective :
    Function.Injective dvtQuotientStabilizerHom
  /-- The identity fiber of the pair-level homomorphism is the
      central ℤ₃. -/
  identityFiber_z3 :
    ∀ x : DVTTwoSidedSU3Pair,
      dvtTwoSidedSU3AutHom x = 1 →
        ∃ z : DVTZ3CentralScalar,
          (x.1.unit : Matrix (Fin 3) (Fin 3) ℂ) =
            (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
          (x.2.unop.unit : Matrix (Fin 3) (Fin 3) ℂ) =
            (z : ℂ)⁻¹ •
              (1 : Matrix (Fin 3) (Fin 3) ℂ)
  /-- Determinant preservation by DVT-compatible automorphisms. -/
  det_preserving :
    ∀ f : AddAut H3OComplement,
      predicate f →
        ∀ w : H3OComplement,
          (h3oComplementEquivM3C (f w)).det =
            (h3oComplementEquivM3C w).det

/-- The canonical DVT full stabilizer characterization package. -/
noncomputable def dvtFullStabilizerCharacterizationPackage :
    DVTFullStabilizerCharacterizationPackage where
  predicate := IsDVTTwoSidedCompatible
  stabilizerSubgroup := dvtCompatibleComplementStabilizer
  image_eq_stabilizer :=
    dvtCompatibleComplementStabilizer_eq.symm
  quotientEquivStabilizer := dvtFullStabilizerEquiv
  mem_iff :=
    dvtQuotientImageSubgroup_mem_iff_twoSidedCompatible
  quotientHom_injective :=
    dvtQuotientStabilizerHom_injective
  identityFiber_z3 :=
    dvtQuotientStabilizerHom_identityFiber_z3
  det_preserving := dvtImage_det_preserving

end PhysicsSM.Algebra.Jordan.DVTAction
