import Mathlib
import PhysicsSM.Gauge.QunitQubitQutritRepresentation
import PhysicsSM.Gauge.QunitQubitQutritDictionary
import PhysicsSM.Gauge.StandardModelUnitZ6SMBlockEquiv
import PhysicsSM.Gauge.StandardModelUnitZ6Kernel
import PhysicsSM.Gauge.StandardModelProductCoveringTrueZ6Kernel

/-!
# Gauge.QunitQubitQutritQuotientRepresentation

The block action of `UnitCoveringTriple` on `QubitPlusQutrit` factors
through the Standard Model quotient `SMCoveringQuotient` because the
Z₆ kernel acts trivially.

## Mathematical context

The covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))`
sends `(α, g, h)` to `(α³ · g, α⁻² · h)`. Since the block-diagonal
action on ℂ² ⊕ ℂ³ depends only on the image pair `(α³ · g, α⁻² · h)`,
any two covering triples with the same image produce the same action.
In particular, all six Z₆ kernel elements act as the identity.

This yields a well-defined monoid homomorphism
`quotientAction : SMCoveringQuotient →* Function.End QubitPlusQutrit`
such that `quotientAction ⟦x⟧ = actQubitPlusQutrit x.toUnitCoveringTriple`
for every `SMCoveringTriple x`.

## Main declarations

* `smCoveringTripleActQubitPlusQutrit` - action via `SMCoveringTriple`.
* `smCoveringTriple_imageEquiv_act_eq` - image-equivalent triples act the same.
* `quotientActQubitPlusQutrit` - the factored action on `SMCoveringQuotient`.
* `quotientActQubitPlusQutritHom` - monoid homomorphism from the quotient.
* `quotientAction_compatible_blockEquiv` - compatibility with the block
  subgroup equivalence (stretch target).
* `QunitQubitQutritQuotientRepresentationPackage` - bundled evidence.

## Claim boundary

This is a representation/dictionary theorem only; it does not claim
quantum computing dynamics or physical Hilbert-space interpretation.

Status: trusted - no `sorry`.
-/

set_option linter.style.longLine false
set_option linter.style.show false

namespace PhysicsSM.Gauge.QunitQubitQutritDictionary

open Complex Matrix PhysicsSM.Gauge.StandardModelSubgroup

/-! ## Action via SMCoveringTriple -/

/--
The block-diagonal action of an `SMCoveringTriple` on `QubitPlusQutrit`,
obtained by composing with the coercion to `UnitCoveringTriple`.
-/
noncomputable def smCoveringTripleActQubitPlusQutrit
    (x : SMCoveringTriple) : QubitPlusQutrit → QubitPlusQutrit :=
  actQubitPlusQutrit x.toUnitCoveringTriple

/-! ## Image-equivalent triples act the same -/

/-
The action `actQubitPlusQutrit` depends only on `x.image`.
If two `UnitCoveringTriple`s have the same image, they produce the same
action on `QubitPlusQutrit`.
-/
theorem actQubitPlusQutrit_eq_of_image_eq
    (x y : UnitCoveringTriple)
    (h : x.image = y.image) :
    actQubitPlusQutrit x = actQubitPlusQutrit y := by
  unfold actQubitPlusQutrit;
  aesop

/-
Image-equivalent `SMCoveringTriple`s produce the same action on
`QubitPlusQutrit`.
-/
theorem smCoveringTriple_imageEquiv_act_eq
    (x y : SMCoveringTriple)
    (h : SMCoveringTriple.ImageEquiv x y) :
    smCoveringTripleActQubitPlusQutrit x =
      smCoveringTripleActQubitPlusQutrit y := by
  exact actQubitPlusQutrit_eq_of_image_eq _ _ h

/-! ## Factored action on the quotient -/

/--
The block-diagonal action factored through `SMCoveringQuotient`.
Well-defined because image-equivalent triples act identically.
-/
noncomputable def quotientActQubitPlusQutrit
    (q : SMCoveringQuotient) : QubitPlusQutrit → QubitPlusQutrit :=
  Quotient.lift smCoveringTripleActQubitPlusQutrit
    (fun a b h => smCoveringTriple_imageEquiv_act_eq a b h) q

/--
The factored action agrees with the original on representatives.
-/
theorem quotientActQubitPlusQutrit_mk
    (x : SMCoveringTriple) :
    quotientActQubitPlusQutrit (Quotient.mk _ x) =
      actQubitPlusQutrit x.toUnitCoveringTriple := by
  rfl

/-! ## Quotient monoid homomorphism -/

/--
The factored action as a monoid homomorphism from `SMCoveringQuotient`
to `Function.End QubitPlusQutrit`.
-/
noncomputable def quotientActQubitPlusQutritHom :
    SMCoveringQuotient →* Function.End QubitPlusQutrit where
  toFun := quotientActQubitPlusQutrit
  map_one' := by
    show quotientActQubitPlusQutrit ⟦SMCoveringTriple.one⟧ = id
    rw [quotientActQubitPlusQutrit_mk]
    exact actQubitPlusQutrit_one
  map_mul' a b := by
    induction a using Quotient.ind
    induction b using Quotient.ind
    show quotientActQubitPlusQutrit ⟦SMCoveringTriple.mul _ _⟧ =
      quotientActQubitPlusQutrit ⟦_⟧ ∘ quotientActQubitPlusQutrit ⟦_⟧
    simp only [quotientActQubitPlusQutrit_mk]
    exact actQubitPlusQutrit_mul _ _

/-! ## Kernel triviality (lifted) -/

/--
Every Z₆ kernel element (as a `UnitCoveringKernelElt`) acts trivially
on `QubitPlusQutrit`. (Re-exported from `QunitQubitQutritRepresentation`.)
-/
theorem kernel_trivial (i : Fin 6) :
    actQubitPlusQutrit
      (sixUnitCoveringKernelElts i).toUnitCoveringTriple = id :=
  sixUnitCoveringKernelElts_actQubitPlusQutrit_eq_id i

/-! ## Stretch: compatibility with block subgroup equivalence -/

/-
The quotient action is compatible with the block subgroup equivalence
`smCoveringQuotientMulEquivSMBlockUnits`: for every quotient class `q`,
the action computed from `q` agrees with the `GUTMatrix` mulVec action
of the corresponding block-diagonal matrix.

Concretely, for `q = ⟦x⟧`, the block-matrix in the SM block subgroup
is `fromBlocks x.image.1.val 0 0 x.image.2.val`, and its `mulVec`
action on `QubitPlusQutrit` is exactly `quotientActQubitPlusQutrit q`.
-/
theorem quotientAction_compatible_blockEquiv
    (q : SMCoveringQuotient)
    (v : QubitPlusQutrit) :
    quotientActQubitPlusQutrit q v =
      (smCoveringQuotientMulEquivSMBlockUnits q : Units GUTMatrix).val.mulVec v := by
  obtain ⟨ x, rfl ⟩ := Quotient.exists_rep q;
  simp +decide [ quotientActQubitPlusQutrit_mk, smCoveringQuotientMulEquivSMBlockUnits ];
  unfold actQubitPlusQutrit;
  ext i; cases i <;> simp +decide [ Matrix.mulVec, dotProduct ] ; ring;
  · simp +decide [ smCoveringQuotientToSMBlockUnits, smCoveringTripleToSMBlockUnit ] ; ring!;
    simp +decide [ pairToGUTUnit ];
  · unfold smCoveringQuotientToSMBlockUnits; simp +decide [ smCoveringTripleToSMBlockUnit, pairToGUTUnit ] ;
    rfl

/-! ## Bundled package -/

/--
Bundled evidence that the block action of `UnitCoveringTriple` on
`QubitPlusQutrit` factors through the Standard Model quotient
`SMCoveringQuotient`.
-/
structure QunitQubitQutritQuotientRepresentationPackage where
  /-- The factored action as a monoid homomorphism. -/
  quotientAction : SMCoveringQuotient →* Function.End QubitPlusQutrit
  /-- The factored action agrees with the original on representatives. -/
  quotientAction_mk :
    ∀ x : SMCoveringTriple,
      quotientAction (Quotient.mk _ x) =
        actQubitPlusQutrit x.toUnitCoveringTriple
  /-- All six Z₆ kernel elements act trivially. -/
  kernel_trivial :
    ∀ i : Fin 6,
      actQubitPlusQutrit
        (sixUnitCoveringKernelElts i).toUnitCoveringTriple = id

/--
The canonical quotient representation package.
-/
noncomputable def qunitQubitQutritQuotientRepresentationPackage :
    QunitQubitQutritQuotientRepresentationPackage where
  quotientAction := quotientActQubitPlusQutritHom
  quotientAction_mk := quotientActQubitPlusQutrit_mk
  kernel_trivial := kernel_trivial

end PhysicsSM.Gauge.QunitQubitQutritDictionary
