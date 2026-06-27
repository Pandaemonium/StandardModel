import Mathlib
import PhysicsSM.Algebra.Jordan.DVTTwoSidedSU3QuotientStabilizer
import PhysicsSM.Algebra.Jordan.DVTTwoSidedActionKernelZ3Iff

/-!
# Algebra.Jordan.DVTTwoSidedStabilizerMoonshot

DVT/Yokota quotient-to-stabilizer theorem: the two-sided `SU(3) × SU(3)ᵐᵒᵖ`
action on the DVT complement lifts to an injective group homomorphism from the
quotient `(SU(3) × SU(3)ᵐᵒᵖ) / ℤ₃` into the automorphism group of the
complement.

## Mathematical context

In the Dubois-Violette–Todorov (DVT) / Yokota framework, the two-sided matrix
action `X ↦ A * X * B` on the complement of `h₃(ℂ)` inside the exceptional
Jordan algebra `h₃(𝕆)` provides a faithful representation of the quotient
group `(SU(3) × SU(3)ᵐᵒᵖ) / ℤ₃` as additive automorphisms of the
complement. This is a coordinate-algebraic stabilizer theorem that captures
the key group-theoretic content of the DVT decomposition.

## Main declarations

- `dvtTwoSidedSU3PairAddEquiv` — the two-sided action of an SU(3) pair as
  an additive equivalence (automorphism) of the complement.
- `dvtTwoSidedSU3AutHom` — group homomorphism from `DVTTwoSidedSU3Pair` to
  `AddAut H3OComplement`.
- `dvtTwoSidedSU3AutHom_ker_le` — the kernel congruence of the action
  homomorphism is contained in the kernel of the automorphism homomorphism.
- `dvtTwoSidedSU3AutHom_ker_ge` — the converse containment.
- `dvtQuotientStabilizerHom` — the induced group homomorphism from the
  quotient `DVTTwoSidedSU3Quotient` to `AddAut H3OComplement`.
- `dvtQuotientStabilizerHom_injective` — injectivity of the quotient
  homomorphism: the quotient acts faithfully on the complement.
- `dvtQuotientStabilizerHom_identityFiber_z3` — the identity fiber of the
  full action (before quotienting) is exactly the central `ℤ₃`.
- `DVTTwoSidedStabilizerPackage` — bundled package of all stabilizer results.

## Claim boundary

This is a coordinate-algebraic stabilizer/faithful-action theorem. It proves
that `(SU(3) × SU(3)ᵐᵒᵖ) / ℤ₃` embeds injectively into the additive
automorphism group of the DVT complement. It does NOT prove:
- surjectivity (that the image is exactly the DVT-compatible automorphisms),
- topological Lie-group structure,
- compactness or smoothness,
- Jordan-product preservation by the two-sided action,
- the full exceptional Jordan automorphism stabilizer theorem.

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

/-! ## Invertibility of the two-sided complement action

Each `SU(3)` pair `(A, B)` gives an invertible additive map on the
complement via `X ↦ A * X * B`, with inverse `X ↦ A⁻¹ * X * B⁻¹`.
-/

/-
Left-inverse property: composing the inverse action with the forward
    action yields the identity.
-/
theorem h3oComplementTwoSidedAction_left_inv
    (A B : Units (Matrix (Fin 3) (Fin 3) ℂ)) (w : H3OComplement) :
    h3oComplementTwoSidedAction (↑A⁻¹) (↑B⁻¹)
      (h3oComplementTwoSidedAction (↑A) (↑B) w) = w := by
  -- By the composition law, applying the inverse action to the forward action gives the identity.
  have h_comp :
      h3oComplementTwoSidedAction (A⁻¹ * A) (B * B⁻¹) =
        AddMonoidHom.id H3OComplement := by
    convert h3oComplementTwoSidedAction_one_one using 2
    · aesop
    · exact Units.mul_inv _
  generalize_proofs at *; (
  convert congr_arg ( fun f => f w ) h_comp using 1
  generalize_proofs at *; (
  rw [ h3oComplementTwoSidedAction_mul ] ; norm_num;))

/-
Right-inverse property: composing the forward action with the inverse
    action yields the identity.
-/
theorem h3oComplementTwoSidedAction_right_inv
    (A B : Units (Matrix (Fin 3) (Fin 3) ℂ)) (w : H3OComplement) :
    h3oComplementTwoSidedAction (↑A) (↑B)
      (h3oComplementTwoSidedAction (↑A⁻¹) (↑B⁻¹) w) = w := by
  convert h3oComplementTwoSidedAction_left_inv A⁻¹ B⁻¹ w using 1

/-! ## Additive equivalence from SU(3) pairs -/

/-- The two-sided action of an SU(3) pair as an additive equivalence
    (automorphism) of the complement. The forward map is `X ↦ A * X * B`
    and the inverse is `X ↦ A⁻¹ * X * B⁻¹`. -/
noncomputable def dvtTwoSidedSU3PairAddEquiv (p : DVTTwoSidedSU3Pair) :
    H3OComplement ≃+ H3OComplement :=
  { h3oComplementTwoSidedAction (↑p.1.unit) (↑p.2.unop.unit) with
    invFun := h3oComplementTwoSidedAction (↑p.1.unit⁻¹) (↑p.2.unop.unit⁻¹)
    left_inv := h3oComplementTwoSidedAction_left_inv p.1.unit p.2.unop.unit
    right_inv := h3oComplementTwoSidedAction_right_inv p.1.unit p.2.unop.unit }

/-- The forward map of the additive equivalence agrees with the action
    homomorphism. -/
@[simp]
theorem dvtTwoSidedSU3PairAddEquiv_apply (p : DVTTwoSidedSU3Pair)
    (w : H3OComplement) :
    dvtTwoSidedSU3PairAddEquiv p w =
      dvtTwoSidedSU3ActionHom p w := rfl

/-! ## Group homomorphism to the automorphism group -/

/-
The two-sided SU(3) action as a group homomorphism to the additive
    automorphism group of the complement.
-/
noncomputable def dvtTwoSidedSU3AutHom :
    DVTTwoSidedSU3Pair →* AddAut H3OComplement where
  toFun := dvtTwoSidedSU3PairAddEquiv
  map_one' := by
    aesop
  map_mul' p q := by
    ext w;
    all_goals simp +decide [dvtTwoSidedSU3PairAddEquiv_apply]

/-! ## Kernel characterization -/

/-
The kernel congruence of the original action homomorphism is contained
    in the kernel of the automorphism homomorphism.
-/
theorem dvtTwoSidedSU3AutHom_ker_le :
    dvtTwoSidedSU3KerCon ≤ Con.ker dvtTwoSidedSU3AutHom := by
  intro x y hxy;
  convert AddEquiv.ext ?_;
  exact fun w => congr_arg ( fun f => f w ) hxy

/-
The kernel of the automorphism homomorphism is contained in the kernel
    congruence of the original action homomorphism.
-/
theorem dvtTwoSidedSU3AutHom_ker_ge :
    Con.ker dvtTwoSidedSU3AutHom ≤ dvtTwoSidedSU3KerCon := by
  intro x y hxy;
  apply AddMonoidHom.ext;
  intro w;
  convert congr_arg ( fun f => f w ) hxy using 1

/-- The two kernel congruences are equal: two SU(3) pairs induce the
    same automorphism if and only if they induce the same endomorphism. -/
theorem dvtTwoSidedSU3AutHom_ker_eq :
    Con.ker dvtTwoSidedSU3AutHom = dvtTwoSidedSU3KerCon :=
  le_antisymm dvtTwoSidedSU3AutHom_ker_ge dvtTwoSidedSU3AutHom_ker_le

/-! ## Quotient homomorphism and injectivity -/

/-- The induced group homomorphism from the quotient
    `DVTTwoSidedSU3Quotient = (SU(3) × SU(3)ᵐᵒᵖ) / ker` to the additive
    automorphism group of the complement. -/
noncomputable def dvtQuotientStabilizerHom :
    DVTTwoSidedSU3Quotient →* AddAut H3OComplement :=
  Con.lift dvtTwoSidedSU3KerCon dvtTwoSidedSU3AutHom dvtTwoSidedSU3AutHom_ker_le

/-- Evaluation lemma: the quotient homomorphism applied to the class of a
    pair `p` equals the automorphism of `p`. -/
theorem dvtQuotientStabilizerHom_mk (p : DVTTwoSidedSU3Pair) :
    dvtQuotientStabilizerHom (dvtTwoSidedSU3KerCon.mk' p) =
      dvtTwoSidedSU3PairAddEquiv p := by
  exact Con.lift_mk' dvtTwoSidedSU3AutHom_ker_le p

/-
**Faithful quotient action theorem**: the quotient homomorphism is
    injective. The quotient `(SU(3) × SU(3)ᵐᵒᵖ) / ℤ₃` acts faithfully
    on the DVT complement.
-/
theorem dvtQuotientStabilizerHom_injective :
    Function.Injective dvtQuotientStabilizerHom := by
  intro x y hxy;
  obtain ⟨p, rfl⟩ : ∃ p : DVTTwoSidedSU3Pair, x = dvtTwoSidedSU3KerCon.mk' p := by
    induction x using Quotient.inductionOn' ; aesop;
  obtain ⟨q, rfl⟩ : ∃ q : DVTTwoSidedSU3Pair, y = dvtTwoSidedSU3KerCon.mk' q := by
    induction y using Quotient.inductionOn' ; aesop;
  simp_all +decide only [Con.coe_mk', Con.eq];
  have h_eq : dvtTwoSidedSU3AutHom p = dvtTwoSidedSU3AutHom q := by
    convert hxy using 1;
  exact dvtTwoSidedSU3AutHom_ker_eq ▸ h_eq

/-! ## Identity fiber is Z₃ (repackaged) -/

/-
The identity fiber of the full automorphism homomorphism (before
    quotienting) is exactly the central `ℤ₃` scalar: if `(A, Bᵐᵒᵖ)` acts
    as the identity automorphism, then `A = z • I` and `B = z⁻¹ • I` for
    some cube root of unity `z`.
-/
theorem dvtQuotientStabilizerHom_identityFiber_z3
    (x : DVTTwoSidedSU3Pair)
    (hx : dvtTwoSidedSU3AutHom x = 1) :
    ∃ z : DVTZ3CentralScalar,
      (x.1.unit : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
      (x.2.unop.unit : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  convert dvtTwoSidedSU3_identityFiber_z3 x _;
  convert congr_arg ( fun f : AddAut H3OComplement => f.toAddMonoidHom ) hx using 1

/-! ## Bundled stabilizer package -/

/-- The bundled DVT two-sided stabilizer moonshot package. -/
structure DVTTwoSidedStabilizerPackage where
  /-- Group homomorphism from the SU(3) pair to complement automorphisms. -/
  pairToAut : DVTTwoSidedSU3Pair →* AddAut H3OComplement
  /-- Quotient homomorphism to complement automorphisms. -/
  quotientToAut : DVTTwoSidedSU3Quotient →* AddAut H3OComplement
  /-- The quotient homomorphism is injective (faithful action). -/
  quotientToAut_injective : Function.Injective quotientToAut
  /-- The identity fiber of the pair homomorphism is the central Z₃. -/
  identityFiber_z3 :
    ∀ x : DVTTwoSidedSU3Pair, pairToAut x = 1 →
      ∃ z : DVTZ3CentralScalar,
        (x.1.unit : Matrix (Fin 3) (Fin 3) ℂ) =
          (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
        (x.2.unop.unit : Matrix (Fin 3) (Fin 3) ℂ) =
          (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ)

/-- The DVT two-sided stabilizer package, witnessing the faithful quotient
    action of `(SU(3) × SU(3)ᵐᵒᵖ) / ℤ₃` on the DVT complement. -/
noncomputable def dvtTwoSidedStabilizerPackage :
    DVTTwoSidedStabilizerPackage where
  pairToAut := dvtTwoSidedSU3AutHom
  quotientToAut := dvtQuotientStabilizerHom
  quotientToAut_injective := dvtQuotientStabilizerHom_injective
  identityFiber_z3 := dvtQuotientStabilizerHom_identityFiber_z3
end PhysicsSM.Algebra.Jordan.DVTAction
