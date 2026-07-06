import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity
import PhysicsSM.Draft.NullEdge.GateYM.FusionConvolution
import PhysicsSM.Draft.NullEdge.GateYM.FusionTransferSpectrum

/-!
# Gate YM: character orthogonality + strong-coupling character expansion

The building block of the convergent character/polymer expansion behind the
finite-lattice reflection-positivity construction (freeze document, section 4)
and the Kotecky-Preiss / Fernandez-Procacci convergence machinery.  This is the
FINITE-group entry point flagged in the freeze notes as needing Peter-Weyl:
for a *finite* group the relevant statements are (a) character orthogonality
(Schur's first relation), and (b) the finite Fourier expansion of the Wilson
plaquette weight in the character basis, together with the strong-coupling
domination of the trivial-representation coefficient.

## What is proved here

1. **Finite-group character orthogonality (first relation).** For a finite
   group `G` and simple complex representations `V, W` (`FDRep ℂ G`),
   `(1/|G|) ∑_g χ_V(g) * conj(χ_W(g)) = if V ≅ W then 1 else 0`
   (`char_orthogonality_conj`).  This is the projector form of Schur's lemma;
   it is derived from Mathlib's `FDRep.char_orthonormal` (which *does* supply
   the finite-group Schur orthogonality — no handoff `s o r r y` is needed) plus
   the project's unconditional `character_inv_eq_conj`.
   The abelian / `Z2` case is a special case; an elementary self-contained
   `Z2` finite-Fourier expansion is given separately in `z2_expansion`.

2. **Character expansion of the plaquette Wilson weight.** The class function
   `w(g) = exp(β · Re χ_ρ(g))` has character coefficients
   `c_R(β) = (1/|G|) ∑_g w(g) · conj(χ_R(g))` (`charCoeff`).  We prove the
   coefficients are real (`charCoeff_real`), that the trivial-representation
   coefficient dominates for any character bounded by `1` in modulus — in
   particular for all irreducibles of an abelian group
   (`charCoeff_abs_le_trivCoeff`) — and we give the explicit two-character
   `Z2` expansion with its strong-coupling domination (`z2_expansion`,
   `z2_trivCoeff_dominates`).

3. **Bridge to the fusion lemma.** The fusion scalar
   `∑_g w(g) · χ_R(g⁻¹)` that drives `FusionConvolution.lemma2a_fusion_convolution`
   is exactly `|G| · c_R(β)` (`fusion_scalar_eq_card_mul_charCoeff`); this is
   the character-orthogonality input the one-step fusion lemma rests on.

Claim label: **finite identity / character expansion (draft)**.
No new `axiom`, no `native_decide`, no statement weakening.  The
finite-abelian / `Z2` case is fully closed; the general finite-`G`
orthogonality is closed via Mathlib's rep theory.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace CharacterExpansion

open scoped ComplexConjugate BigOperators Matrix
open CategoryTheory
open Classical

/-! ## Section A. Finite-group character orthogonality (Schur's first relation) -/

section Orthogonality

variable {G : Type} [Group G] [Fintype G]

/-- `(Fintype.card G : ℂ) ≠ 0`, the harmless nondegeneracy behind the `1/|G|`
normalization of character orthogonality. -/
theorem card_ne_zero_complex : (Fintype.card G : ℂ) ≠ 0 := by
  exact_mod_cast Fintype.card_ne_zero

/-- **Character orthogonality, inversion form.** Restatement of Mathlib's
`FDRep.char_orthonormal` with the explicit `(1/|G|)` normalization
`(Fintype.card G : ℂ)⁻¹` in place of `⅟`. -/
theorem char_orthogonality_inv (V W : FDRep ℂ G) [Simple V] [Simple W] :
    (Fintype.card G : ℂ)⁻¹ * ∑ g : G, V.character g * W.character g⁻¹
      = if Nonempty (V ≅ W) then 1 else 0 := by
  haveI : Invertible (Fintype.card G : ℂ) := invertibleOfNonzero card_ne_zero_complex
  have h := FDRep.char_orthonormal V W
  rw [smul_eq_mul, invOf_eq_inv] at h
  exact h

/-- **Character orthogonality, conjugate form (Schur's first relation).** For a
finite group `G` and simple complex representations `V, W`,
`(1/|G|) ∑_g χ_V(g) conj(χ_W(g)) = 1` if `V ≅ W` and `0` otherwise.  This is
the finite-group instance of Peter-Weyl orthogonality; the conjugation uses the
project's unconditional `χ(g⁻¹) = conj(χ(g))`. -/
theorem char_orthogonality_conj (V W : FDRep ℂ G) [Simple V] [Simple W] :
    (Fintype.card G : ℂ)⁻¹ * ∑ g : G, V.character g * conj (W.character g)
      = if Nonempty (V ≅ W) then 1 else 0 := by
  rw [← char_orthogonality_inv V W]
  congr 1
  refine Finset.sum_congr rfl fun g _ => ?_
  rw [FusionTransferSpectrum.character_inv_eq_conj W g]

end Orthogonality

/-! ## Section B. Character expansion of the Wilson plaquette weight -/

section Expansion

variable {G : Type} [Group G] [Fintype G] {n : ℕ}

/-- The Wilson plaquette weight as a real class function on the group:
`w(g) = exp(β · Re χ_ρ(g))`, reusing `WilsonWeightPositivity.reChar`. -/
noncomputable def wilsonWeightFun (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (g : G) : ℝ :=
  Real.exp (beta * WilsonWeightPositivity.reChar rho g)

/-- The Wilson weight is nonnegative (an exponential). -/
theorem wilsonWeightFun_nonneg (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (g : G) :
    0 ≤ wilsonWeightFun beta rho g :=
  (Real.exp_pos _).le

/-
The Wilson weight is a class function (invariant under conjugation), because
`reChar` reads a trace.
-/
theorem wilsonWeightFun_conj (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (a g : G) :
    wilsonWeightFun beta rho (a * g * a⁻¹) = wilsonWeightFun beta rho g := by
  -- By definition of $reChar$, we have $reChar rho (a * g * a⁻¹) = (Matrix.trace (rho (a * g * a⁻¹))).re$.
  unfold wilsonWeightFun WilsonWeightPositivity.reChar;
  simp +decide [ hmul, Matrix.trace_mul_comm ( rho a ) ];
  rw [ ← Matrix.trace_mul_comm ] ; simp +decide [ ← hmul, ← hunit ] ;

/-- The Wilson weight, as a complex-valued class function, in the sense of
`FusionConvolution.IsClassFunction`. -/
theorem wilsonWeightFun_isClassFunction (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    FusionConvolution.IsClassFunction
      (fun g => (wilsonWeightFun beta rho g : ℂ)) := by
  intro a g
  show (wilsonWeightFun beta rho (a * g * a⁻¹) : ℂ) = (wilsonWeightFun beta rho g : ℂ)
  rw [wilsonWeightFun_conj beta rho hmul hone hunit a g]

/-- The Wilson weight is inversion-symmetric for a unitary representation. -/
theorem wilsonWeightFun_inv (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (g : G) :
    wilsonWeightFun beta rho g⁻¹ = wilsonWeightFun beta rho g := by
  rw [wilsonWeightFun, wilsonWeightFun,
    WilsonWeightPositivity.reChar_inv_of_unitary rho hmul hone hunit g]

/-- **Character coefficient (finite Fourier on the group).** The coefficient of
`χ_R` in the expansion of the Wilson weight:
`c_R(β) = (1/|G|) ∑_g w(g) · conj(χ_R(g))`. -/
noncomputable def charCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) : ℂ :=
  (Fintype.card G : ℂ)⁻¹ *
    ∑ g : G, (wilsonWeightFun beta rho g : ℂ) * conj (R.character g)

/-- The trivial-representation coefficient
`c_triv(β) = (1/|G|) ∑_g w(g)`, a nonnegative real. -/
noncomputable def trivCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) : ℝ :=
  (Fintype.card G : ℝ)⁻¹ * ∑ g : G, wilsonWeightFun beta rho g

/-
**The character coefficients are real.** `conj(c_R) = c_R`, proved by the
reindexing `g ↦ g⁻¹` together with `w(g⁻¹) = w(g)` and
`χ_R(g⁻¹) = conj(χ_R(g))`.
-/
theorem charCoeff_real (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (R : FDRep ℂ G) :
    conj (charCoeff beta rho R) = charCoeff beta rho R := by
  unfold charCoeff; simp +decide [ mul_comm ] ;
  rw [ ← Equiv.sum_comp ( Equiv.inv G ) ];
  simp +decide [ mul_comm, FusionTransferSpectrum.character_inv_eq_conj ];
  exact Finset.sum_congr rfl fun _ _ => by rw [ wilsonWeightFun_inv beta rho hmul hone hunit ] ;

/-
**Strong-coupling domination (character bounded by one).** If a character
`χ` has `|χ(g)| ≤ 1` for all `g` (as for every irreducible of an ABELIAN group,
whose irreducibles are one-dimensional unitary), then the trivial coefficient
dominates: `|c_R(β)| ≤ c_triv(β)`.  Since `w ≥ 0`, this is the triangle
inequality.  This is the input the strong-coupling character expansion needs.
-/
theorem charCoeff_abs_le_trivCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hbound : ∀ g : G, ‖R.character g‖ ≤ 1) :
    ‖charCoeff beta rho R‖ ≤ trivCoeff beta rho := by
  unfold charCoeff trivCoeff;
  norm_num [ norm_mul, Complex.norm_exp ];
  gcongr;
  refine' le_trans ( norm_sum_le _ _ ) _;
  exact Finset.sum_le_sum fun x _ => by simpa [ abs_of_nonneg ( show 0 ≤ wilsonWeightFun beta rho x from Real.exp_nonneg _ ) ] using mul_le_mul_of_nonneg_left ( hbound x ) ( show 0 ≤ wilsonWeightFun beta rho x from Real.exp_nonneg _ ) ;

end Expansion

/-! ## Section C. Explicit `Z2` two-character expansion and its domination -/

section Z2

/-- The nontrivial character of `Z2 = ZMod 2`: `+1` at `0`, `-1` at `1`. -/
def z2Sign : ZMod 2 → ℂ := fun x => if x = 0 then 1 else -1

/-- `z2Sign` is a group homomorphism `(ZMod 2, +) → (ℂ, ×)`. -/
theorem z2Sign_add (x y : ZMod 2) : z2Sign (x + y) = z2Sign x * z2Sign y := by
  fin_cases x <;> fin_cases y <;> simp [z2Sign] <;> decide

/-- `z2Sign` has modulus one. -/
theorem z2Sign_abs (x : ZMod 2) : ‖z2Sign x‖ = 1 := by
  fin_cases x <;> simp [z2Sign]

/-
**`Z2` finite Fourier expansion (two characters).** Any complex function on
`ZMod 2` is `c0 · 1 + c1 · z2Sign` with `c0 = (1/2) ∑ f` and
`c1 = (1/2) ∑ f(y) z2Sign(y)`.  This is the two-character character expansion
made fully explicit.
-/
theorem z2_expansion (f : ZMod 2 → ℂ) (x : ZMod 2) :
    f x = ((2 : ℂ)⁻¹ * ∑ y : ZMod 2, f y)
        + ((2 : ℂ)⁻¹ * ∑ y : ZMod 2, f y * z2Sign y) * z2Sign x := by
  have h2 : ∀ g : ZMod 2 → ℂ, ∑ y : ZMod 2, g y = g 0 + g 1 := fun g => by
    rw [show (Finset.univ : Finset (ZMod 2)) = {0, 1} from rfl,
      Finset.sum_insert (by decide), Finset.sum_singleton]
  fin_cases x <;> simp only [h2, z2Sign] <;> norm_num <;> ring

/-
**`Z2` strong-coupling domination.** For a nonnegative real weight
`w : ZMod 2 → ℝ`, the trivial (`c0`) coefficient dominates the sign (`c1`)
coefficient in modulus: `|c1| ≤ c0`.
-/
theorem z2_trivCoeff_dominates (w : ZMod 2 → ℝ) (hw : ∀ x, 0 ≤ w x) :
    |(2 : ℝ)⁻¹ * (w 0 - w 1)| ≤ (2 : ℝ)⁻¹ * (w 0 + w 1) := by
  exact abs_le.mpr ⟨ by norm_num; linarith [ hw 0, hw 1 ], by norm_num; linarith [ hw 0, hw 1 ] ⟩

end Z2

/-! ## Section D. Bridge to the fusion convolution lemma -/

section Bridge

variable {G : Type} [Group G] [Fintype G] {n : ℕ}

/-
**Bridge: the fusion scalar is `|G|` times the character coefficient.** The
scalar `∑_g w(g) χ_R(g⁻¹)` driving `FusionConvolution.lemma2a_fusion_convolution`
equals `|G| · c_R(β)`.  Thus the character orthogonality / expansion supplies the
one-step fusion lemma exactly its coefficient input.
-/
theorem fusion_scalar_eq_card_mul_charCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) :
    (∑ g : G, (wilsonWeightFun beta rho g : ℂ) * R.character g⁻¹)
      = (Fintype.card G : ℂ) * charCoeff beta rho R := by
  unfold charCoeff; simp +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul ] ;
  exact Finset.sum_congr rfl fun _ _ => by rw [ FusionTransferSpectrum.character_inv_eq_conj ] ; ring;

/-- **Bridge conclusion.** Plugging the character coefficient into the fusion
lemma: for the Wilson class function `w` and a simple `R`, the oracle-pinned
convolution acts on `χ_R` by the scalar `|G| · c_R(β)`, with the standard
`χ_R(1)` on the left.  This is `lemma2a_fusion_convolution` fed by the character
expansion. -/
theorem fusion_convolution_charCoeff (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (R : FDRep ℂ G) [Simple R] (A : G) :
    R.character 1 *
        (∑ h : G, (wilsonWeightFun beta rho h : ℂ) * R.character (h⁻¹ * A))
      = ((Fintype.card G : ℂ) * charCoeff beta rho R) * R.character A := by
  have hcls := wilsonWeightFun_isClassFunction beta rho hmul hone hunit
  have hfusion := FusionConvolution.lemma2a_fusion_convolution R
    (fun g => (wilsonWeightFun beta rho g : ℂ)) hcls A
  rw [hfusion, fusion_scalar_eq_card_mul_charCoeff beta rho R]

end Bridge

end CharacterExpansion
end GateYM
end NullEdge
end Draft
end PhysicsSM
