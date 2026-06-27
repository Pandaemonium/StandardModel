import Mathlib
import PhysicsSM.Algebra.Jordan.DVTTwoSidedStabilizerMoonshot
import PhysicsSM.Algebra.Jordan.DVTTwoSidedImageEquiv
import PhysicsSM.Algebra.Jordan.DVTBlockActionMonoid

/-!
# Algebra.Jordan.DVTQuotientBlockActionBridge

Bridge between the two-sided `(SU(3) × SU(3)ᵐᵒᵖ) / ℤ₃` quotient action and
the `DVTBlockAction` monoid.

## Mathematical context

The existing quotient action `dvtTwoSidedSU3ActionHom` lands in
`AddMonoid.End H3OComplement`. The `DVTBlockAction` monoid captures the full
`h₃(C) ⊕ complement` splitting by packaging separate actions on each summand.

This bridge constructs a monoid homomorphism from `DVTTwoSidedSU3Pair` (and
its quotient) into `DVTBlockAction`, using the identity on the `h₃(C)` part
and the existing two-sided action on the complement. The identity on `h₃(C)`
is a conservative choice; the full adjoint action on `h₃(C)` can be plugged
in later.

## Main declarations

- `dvtTwoSidedPairBlockAction` — block action induced by an SU(3) pair.
- `dvtTwoSidedPairBlockAction_actC` — the complement part agrees with
  `dvtTwoSidedSU3ActionHom`.
- `dvtTwoSidedPairBlockActionHom` — monoid homomorphism from pairs to
  `DVTBlockAction`.
- `dvtQuotientBlockActionHom` — monoid homomorphism from the quotient to
  `DVTBlockAction`.
- `dvtQuotientBlockActionHom_injective` — injectivity.
- `DVTQuotientBlockActionBridgePackage` — bundled package.

## Claim boundary

Conservative: uses identity on `h₃(C)`. Does not claim Jordan-product
preservation, surjectivity, topology, or smoothness.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O

/-! ## Block action from an SU(3) pair -/

/-- The `DVTBlockAction` induced by a two-sided SU(3) pair. The `h₃(C)` part
    uses the identity action (conservative); the complement part uses the
    existing two-sided action `dvtTwoSidedSU3ActionHom`. -/
noncomputable def dvtTwoSidedPairBlockAction
    (p : DVTTwoSidedSU3Pair) : DVTBlockAction where
  actB := id
  actC := dvtTwoSidedSU3ActionHom p
  actB_preserves := fun _ h => h
  actB_zero := rfl
  actC_zero := (dvtTwoSidedSU3ActionHom p).map_zero

/-- The `actB` field of the block action is always `id`. -/
theorem dvtTwoSidedPairBlockAction_actB (p : DVTTwoSidedSU3Pair) :
    (dvtTwoSidedPairBlockAction p).actB = id := rfl

/-! ## actC compatibility -/

/-- The complement action of the block action agrees with the two-sided
    action homomorphism (as bare functions). -/
theorem dvtTwoSidedPairBlockAction_actC
    (p : DVTTwoSidedSU3Pair) :
    (dvtTwoSidedPairBlockAction p).actC =
      dvtTwoSidedSU3ActionHom p := rfl

/-! ## Monoid homomorphism from pairs -/

/-- The map `dvtTwoSidedPairBlockAction` is a monoid homomorphism. -/
noncomputable def dvtTwoSidedPairBlockActionHom :
    DVTTwoSidedSU3Pair →* DVTBlockAction where
  toFun := dvtTwoSidedPairBlockAction
  map_one' := by
    apply DVTBlockAction.ext_act
    · rfl
    · change ⇑(dvtTwoSidedSU3ActionHom 1) = id
      rw [map_one]; rfl
  map_mul' p q := by
    apply DVTBlockAction.ext_act
    · rfl
    · change ⇑(dvtTwoSidedSU3ActionHom (p * q)) =
           ⇑(dvtTwoSidedSU3ActionHom p) ∘ ⇑(dvtTwoSidedSU3ActionHom q)
      rw [map_mul]; rfl

/-! ## Kernel characterization -/

/-- Two pairs induce the same block action iff they induce the same
    complement action, which is the defining relation of the quotient. -/
theorem dvtTwoSidedPairBlockActionHom_ker_eq :
    Con.ker dvtTwoSidedPairBlockActionHom = dvtTwoSidedSU3KerCon := by
  ext x y
  constructor
  · intro h
    change dvtTwoSidedSU3ActionHom x = dvtTwoSidedSU3ActionHom y
    have hC : (dvtTwoSidedPairBlockAction x).actC =
              (dvtTwoSidedPairBlockAction y).actC := by
      have : dvtTwoSidedPairBlockAction x = dvtTwoSidedPairBlockAction y := h
      rw [this]
    simp only [dvtTwoSidedPairBlockAction_actC] at hC
    exact AddMonoidHom.ext fun w => congr_fun hC w
  · intro h
    change dvtTwoSidedPairBlockAction x = dvtTwoSidedPairBlockAction y
    apply DVTBlockAction.ext_act
    · rfl
    · change ⇑(dvtTwoSidedSU3ActionHom x) = ⇑(dvtTwoSidedSU3ActionHom y)
      have : dvtTwoSidedSU3ActionHom x = dvtTwoSidedSU3ActionHom y := h
      rw [this]

/-! ## Descent to the quotient -/

/-- The kernel congruence of the block-action homomorphism contains the
    quotient kernel. -/
theorem dvtTwoSidedPairBlockActionHom_ker_le :
    dvtTwoSidedSU3KerCon ≤ Con.ker dvtTwoSidedPairBlockActionHom :=
  dvtTwoSidedPairBlockActionHom_ker_eq ▸ le_refl _

/-- The quotient homomorphism from `DVTTwoSidedSU3Quotient` to
    `DVTBlockAction`. -/
noncomputable def dvtQuotientBlockActionHom :
    DVTTwoSidedSU3Quotient →* DVTBlockAction :=
  Con.lift dvtTwoSidedSU3KerCon dvtTwoSidedPairBlockActionHom
    dvtTwoSidedPairBlockActionHom_ker_le

/-- Evaluation: the quotient homomorphism applied to the class of a pair
    equals the block action of that pair. -/
theorem dvtQuotientBlockActionHom_mk (p : DVTTwoSidedSU3Pair) :
    dvtQuotientBlockActionHom (dvtTwoSidedSU3KerCon.mk' p) =
      dvtTwoSidedPairBlockAction p :=
  Con.lift_mk' dvtTwoSidedPairBlockActionHom_ker_le p

/-! ## Injectivity -/

/-- The quotient-to-block-action homomorphism is injective. -/
theorem dvtQuotientBlockActionHom_injective :
    Function.Injective dvtQuotientBlockActionHom := by
  intro x y hxy
  induction x using Quotient.inductionOn' with | _ p => ?_
  induction y using Quotient.inductionOn' with | _ q => ?_
  have hpq : dvtTwoSidedPairBlockAction p = dvtTwoSidedPairBlockAction q := by
    change dvtQuotientBlockActionHom (dvtTwoSidedSU3KerCon.mk' p) =
           dvtQuotientBlockActionHom (dvtTwoSidedSU3KerCon.mk' q) at hxy
    rwa [dvtQuotientBlockActionHom_mk, dvtQuotientBlockActionHom_mk] at hxy
  have hC : ⇑(dvtTwoSidedSU3ActionHom p) = ⇑(dvtTwoSidedSU3ActionHom q) := by
    have := congr_arg DVTBlockAction.actC hpq
    exact this
  have hAct : dvtTwoSidedSU3ActionHom p = dvtTwoSidedSU3ActionHom q :=
    AddMonoidHom.ext fun w => congr_fun hC w
  change (dvtTwoSidedSU3KerCon.mk' p : DVTTwoSidedSU3Quotient) =
         dvtTwoSidedSU3KerCon.mk' q
  exact (Con.eq _).mpr hAct

/-! ## actC agreement at the quotient level -/

/-- For any quotient element, the complement action of the corresponding
    block action equals the quotient stabilizer homomorphism value
    (as functions). -/
theorem dvtQuotientBlockActionHom_actC
    (q : DVTTwoSidedSU3Quotient) (w : H3OComplement) :
    (dvtQuotientBlockActionHom q).actC w =
      dvtQuotientStabilizerHom q w := by
  induction q using Quotient.inductionOn' with | _ p => ?_
  change (dvtTwoSidedPairBlockAction p).actC w =
       dvtQuotientStabilizerHom (dvtTwoSidedSU3KerCon.mk' p) w
  rw [dvtQuotientStabilizerHom_mk, dvtTwoSidedPairBlockAction_actC,
      dvtTwoSidedSU3PairAddEquiv_apply]

/-! ## Bundled package -/

/-- The bundled DVT quotient-to-block-action bridge package. -/
structure DVTQuotientBlockActionBridgePackage where
  /-- Monoid homomorphism from the quotient to block actions. -/
  quotientToBlockAction : DVTTwoSidedSU3Quotient →* DVTBlockAction
  /-- The quotient homomorphism is injective. -/
  quotientToBlockAction_injective : Function.Injective quotientToBlockAction
  /-- The complement action agrees with the quotient stabilizer homomorphism. -/
  actC_agrees :
    ∀ (q : DVTTwoSidedSU3Quotient) (w : H3OComplement),
      (quotientToBlockAction q).actC w =
        dvtQuotientStabilizerHom q w

/-- The DVT quotient-to-block-action bridge package. -/
noncomputable def dvtQuotientBlockActionBridgePackage :
    DVTQuotientBlockActionBridgePackage where
  quotientToBlockAction := dvtQuotientBlockActionHom
  quotientToBlockAction_injective := dvtQuotientBlockActionHom_injective
  actC_agrees := dvtQuotientBlockActionHom_actC

end PhysicsSM.Algebra.Jordan.DVTAction
