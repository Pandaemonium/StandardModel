import Mathlib
import PhysicsSM.Algebra.Jordan.DVTAction

/-!
# Algebra.Jordan.DVTBlockActionMonoid

Monoid structure on `DVTBlockAction`, proving that the identity and
composition data from `DVTAction.lean` satisfy the monoid axioms.

## Main results

- `toStandardBPart_add_complement` — projection onto `h₃(C)` recovers the
  standard-B summand when adding a complement element.
- `extractComplement_add_standardB` — complement extraction recovers the
  complement summand when adding a standard-B element.
- `DVTBlockAction.comp_act` — composition of block actions is compatible
  with the action on `h₃(O)`.
- `Monoid DVTBlockAction` — the monoid instance.
- `DVTBlockAction.one_act`, `DVTBlockAction.mul_act` — simp lemmas.

## Sources

- Dubois-Violette and Todorov, arXiv:1806.09450.
- Baez, "Can We Understand the Standard Model Using Octonions?", 2021.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O

/-! ## Projection helper lemmas -/

/-- If `b ∈ h₃(C)` and `c` lies in the complement, then projecting `b + c`
    onto `h₃(C)` recovers `b`. -/
theorem toStandardBPart_add_complement
    {b c : H3O} (hb : InStandardB b) (hc : InH3OComplement c) :
    toStandardBPart (b + c) = b := by
  obtain ⟨hb_alpha, hb_beta, hb_gamma, hb_x, hb_y, hb_z⟩ := hb
  obtain ⟨hc_alpha, hc_beta, hc_gamma, hc_x, hc_y, hc_z⟩ := hc
  simp [toStandardBPart, hc_alpha, hc_beta, hc_gamma]
  congr <;>
    simp_all +decide [Octonion.toChosenComplex, ChosenComplex.toOctonion]
  · congr <;>
      simp_all +decide [H3O.InChosenComplexLine, InChosenComplexComplement]
  · cases hb_beta; cases hc_y; aesop
  · cases b_z : b.z; cases c_z : c.z
    simp_all +decide [H3O.InChosenComplexLine, InChosenComplexComplement]

/-- If `b ∈ h₃(C)` and `c` lies in the complement, then extracting the
    complement of `b + c` equals the complement of `c`. -/
theorem extractComplement_add_standardB
    {b c : H3O} (hb : InStandardB b) (hc : InH3OComplement c) :
    extractComplement (b + c) = extractComplement c := by
  cases b; cases c
  simp_all +decide [extractComplement]
  cases hb; cases hc
  simp_all +decide [Octonion.toComplexTriple]
  unfold H3O.InChosenComplexLine at *; aesop

/-! ## Composition respects the action -/

/-- Composing two DVT block actions and then acting is the same as acting
    with the second and then the first. -/
theorem DVTBlockAction.comp_act
    (sigma tau : DVTBlockAction) (a : H3O) :
    (sigma.comp tau).act a = sigma.act (tau.act a) := by
  simp only [DVTBlockAction.comp]
  simp +decide only [DVTBlockAction.act]
  rw [toStandardBPart_add_complement,
    extractComplement_add_standardB] <;>
    norm_num [tau.actB_preserves, tau.actC_zero,
      H3OComplement.toH3O_inH3OComplement]
  · rw [H3OComplement.roundtrip]
  · exact tau.actB_preserves _ (toStandardBPart_inStandardB _)
  · exact tau.actB_preserves _ (toStandardBPart_inStandardB _)

/-! ## Monoid structure -/

instance : One DVTBlockAction := ⟨dvtBlockAction_identity⟩

instance : Mul DVTBlockAction := ⟨DVTBlockAction.comp⟩

@[simp] theorem DVTBlockAction.one_act (a : H3O) :
    (1 : DVTBlockAction).act a = a :=
  dvtBlockAction_identity_act a

@[simp] theorem DVTBlockAction.mul_act
    (sigma tau : DVTBlockAction) (a : H3O) :
    (sigma * tau).act a = sigma.act (tau.act a) :=
  sigma.comp_act tau a

/-- `DVTBlockAction` equality is determined by the `actB` and `actC` fields
    (the proof fields are propositional and thus equal by proof
    irrelevance). -/
theorem DVTBlockAction.ext_act {σ τ : DVTBlockAction}
    (hB : σ.actB = τ.actB) (hC : σ.actC = τ.actC) :
    σ = τ := by
  cases σ; cases τ
  simp only [DVTBlockAction.mk.injEq] at *
  exact ⟨hB, hC⟩

instance : Monoid DVTBlockAction where
  mul_assoc a b c := by
    apply DVTBlockAction.ext_act <;> ext <;> rfl
  one_mul a := by
    apply DVTBlockAction.ext_act <;> ext <;> rfl
  mul_one a := by
    apply DVTBlockAction.ext_act <;> ext <;> rfl

end PhysicsSM.Algebra.Jordan.DVTAction
