import Mathlib

/-!
# Composition-algebra toolkit (Hurwitz program, stage 1 of 3)

Goal of the campaign: Hurwitz's theorem - every finite-dimensional unital
composition algebra over `R` with anisotropic (e.g. positive-definite) norm has
dimension 1, 2, 4, or 8. This file is STAGE 1: the classical identity toolkit
for a unital (NOT necessarily associative) composition algebra, from which the
Cayley-Dickson doubling lemma (stage 2) and the dimension ladder (stage 3)
follow.

Source (clean-room formalization, no code copied): T.A. Springer,
F.D. Veldkamp, "Octonions, Jordan Algebras and Exceptional Groups", Springer
2000, Chapter 1 (Props 1.2.3, 1.3.2 and surrounding lemmas). Also standard in
Schafer, "An Introduction to Nonassociative Algebras", Ch. III.

## Setup and conventions

* `A` is a unital, possibly non-associative, non-commutative ring
  (`NonAssocRing`) that is an `R`-module with bilinear multiplication
  (`SMulCommClass R A A`, `IsScalarTower R A A`), nontrivial.
* `Q : QuadraticForm R A` is multiplicative (`comp`) and anisotropic
  (`anisotropic`). Over `R`, positive-definite implies anisotropic; anisotropic
  is all the algebra needs.
* `polar Q x y = Q (x + y) - Q x - Q y` is Mathlib's FULL polarization (no
  1/2): the bracket `<x,y>` of Springer-Veldkamp satisfies
  `2 <x,y> = polar Q x y`. All identities below are stated in `polar` form,
  which clears denominators; cross-check signs against the source through this
  dictionary before citing.
* Conjugation: `conj Q x = polar Q x 1 • 1 - x` (i.e. `x-bar = 2<x,1> 1 - x`).

## Proof route guidance

Everything follows from `comp` by polarization (in each slot separately),
plus nondegeneracy (`polar_nondegenerate`, derived from `anisotropic`) to
cancel: to prove `u = v`, show `polar Q u y = polar Q v y` for all `y`.
No associativity may be used anywhere - `A` is only `NonAssocRing`.
Suggested order: `Q_one`, `polar_nondegenerate`, `polar_mul_left_comp`,
`polar_mul_right_comp`, `polar_exchange`, `quadratic_identity`, then the
conjugation block, then the adjoint and Kirmse identities.
-/

namespace HurwitzToolkit

set_option maxHeartbeats 1000000

variable {A : Type*} [NonAssocRing A] [Module ℝ A]
  [SMulCommClass ℝ A A] [IsScalarTower ℝ A A] [Nontrivial A]

open QuadraticMap

/-- A multiplicative, anisotropic quadratic form on a unital (possibly
non-associative) real algebra: the composition-algebra axioms. -/
structure IsCompositionForm (Q : QuadraticForm ℝ A) : Prop where
  comp : ∀ x y : A, Q (x * y) = Q x * Q y
  anisotropic : ∀ x : A, Q x = 0 → x = 0

variable (Q : QuadraticForm ℝ A)

/-- Conjugation `x-bar = 2<x,1> 1 - x`, written with the full polarization. -/
noncomputable def conj (x : A) : A := polar Q x 1 • (1 : A) - x

variable {Q}

/--
The identity has unit norm.
-/
theorem Q_one (hQ : IsCompositionForm Q) : Q (1 : A) = 1 := by
  obtain ⟨ x, hx ⟩ := exists_ne ( 0 : A );
  have := hQ.comp x 1;
  exact mul_left_cancel₀ ( show Q x ≠ 0 from fun h => hx <| hQ.anisotropic x h ) ( by simpa [ hx ] using this.symm )

/--
Anisotropy makes the polar form nondegenerate: this is the cancellation
tool for every later identity.
-/
theorem polar_nondegenerate (hQ : IsCompositionForm Q) {x : A}
    (h : ∀ y : A, polar Q x y = 0) : x = 0 := by
  -- By definition of polar, we have $polar Q x x = Q(x + x) - Q(x) - Q(x)$.
  have h_polar : ∀ x : A, polar Q x x = 2 * Q x := by
    have := Q.map_smul 2; simp_all +decide [ two_smul ] ;
    intro x; ring;
  exact hQ.anisotropic x ( by linarith [ h x, h_polar x ] )

/--
Left composition similarity: `polar (x y) (x z) = Q x * polar y z`.
-/
theorem polar_mul_left_comp (hQ : IsCompositionForm Q) (x y z : A) :
    polar Q (x * y) (x * z) = Q x * polar Q y z := by
  obtain ⟨ comp, anisotropic ⟩ := hQ;
  unfold polar;
  rw [ ← mul_add, comp ] ; ring;
  rw [ comp, comp ]

/--
Right composition similarity: `polar (x z) (y z) = polar x y * Q z`.
-/
theorem polar_mul_right_comp (hQ : IsCompositionForm Q) (x y z : A) :
    polar Q (x * z) (y * z) = polar Q x y * Q z := by
  unfold polar at *;
  rw [ ← add_mul, hQ.comp, hQ.comp, hQ.comp ] ; ring

/--
The full linearization (exchange identity):
`polar (x z) (y w) + polar (x w) (y z) = polar x y * polar z w`.
-/
theorem polar_exchange (hQ : IsCompositionForm Q) (x y z w : A) :
    polar Q (x * z) (y * w) + polar Q (x * w) (y * z)
      = polar Q x y * polar Q z w := by
  obtain ⟨ comp, anisotropic ⟩ := hQ;
  -- Apply the polar_mul_left_comp lemma to expand the left-hand side.
  have h_expand : ∀ x y z w : A, polar Q ((x + y) * z) ((x + y) * w) = Q (x + y) * polar Q z w := by
    intros x y z w
    apply polar_mul_left_comp;
    exact ⟨ comp, anisotropic ⟩;
  convert congr_arg₂ ( · - · ) ( h_expand x y z w ) ( congr_arg₂ ( · + · ) ( h_expand x 0 z w ) ( h_expand 0 y z w ) ) using 1 <;> simp +decide [ *, add_mul, mul_add, polar_add_left, polar_add_right ] ; ring;
  · simp +decide only [polar_comm];
  · unfold polar; ring;

/--
Every element satisfies its quadratic equation
`x^2 - 2<x,1> x + Q x = 0` (in polar form). Note `x * x`, not `x ^ 2`:
`A` is not associative, powers are not assumed.
-/
theorem quadratic_identity (hQ : IsCompositionForm Q) (x : A) :
    x * x - polar Q x 1 • x + Q x • (1 : A) = 0 := by
  refine' polar_nondegenerate hQ _;
  intro y
  have := polar_exchange hQ x 1 x y
  simp_all +decide [polar_comm];
  convert sub_eq_zero.mpr this using 1 ; ring;
  have := polar_mul_left_comp hQ x y 1; simp_all +decide [polar_comm] ;

/--
`x * x-bar = Q x` (scalar).
-/
theorem mul_conj_self (hQ : IsCompositionForm Q) (x : A) :
    x * conj Q x = Q x • (1 : A) := by
  unfold conj;
  simp +decide [ mul_sub, ← mul_smul_comm ];
  convert eq_sub_of_add_eq' ( quadratic_identity hQ x ) |> Eq.symm using 1 ; abel1

/--
`x-bar * x = Q x` (scalar).
-/
theorem conj_mul_self (hQ : IsCompositionForm Q) (x : A) :
    conj Q x * x = Q x • (1 : A) := by
  unfold conj;
  simp +decide [ sub_mul, smul_mul_assoc ];
  rw [ ← eq_comm, ← sub_eq_zero ];
  convert quadratic_identity hQ x using 1 ; abel_nf

/--
Conjugation is an involution.
-/
theorem conj_conj (hQ : IsCompositionForm Q) (x : A) :
    conj Q (conj Q x) = x := by
  unfold conj;
  simp +decide [ sub_eq_add_neg, add_smul, smul_add, smul_sub, sub_smul, polar_smul_left, polar_smul_right, polar_comm, Q_one hQ ];
  module

/--
Conjugation preserves the norm.
-/
theorem Q_conj (hQ : IsCompositionForm Q) (x : A) :
    Q (conj Q x) = Q x := by
  by_cases hx : Q x = 0;
  · obtain rfl := hQ.anisotropic x hx;
    simp +decide [ hx, conj ];
  · have := hQ.comp x ( conj Q x );
    rw [ mul_conj_self ] at this;
    · simp only [QuadraticMap.map_smul, Q_one hQ, smul_eq_mul, mul_one] at this
      exact mul_left_cancel₀ hx this.symm
    · exact hQ

/--
Left-multiplication adjoint: `polar (x y) z = polar y (x-bar z)`.
-/
theorem polar_conj_adjoint_left (hQ : IsCompositionForm Q) (x y z : A) :
    polar Q (x * y) z = polar Q y (conj Q x * z) := by
  have h₁ := polar_exchange hQ x 1 y z;
  simp_all +decide [ mul_sub, sub_mul, polar_comm, conj ];
  exact eq_sub_of_add_eq h₁

/--
Right-multiplication adjoint: `polar (x y) z = polar x (z y-bar)`.
-/
theorem polar_conj_adjoint_right (hQ : IsCompositionForm Q) (x y z : A) :
    polar Q (x * y) z = polar Q x (z * conj Q y) := by
  simp +decide only [conj];
  simp +decide [ mul_sub, sub_mul, mul_smul_comm, smul_mul_assoc ];
  have := polar_exchange hQ x z y 1;
  simp_all +decide [ mul_comm, add_eq_zero_iff_eq_neg ];
  exact eq_sub_of_add_eq this

/--
Conjugation is an anti-automorphism: `(x y)-bar = y-bar x-bar`.
-/
theorem conj_mul (hQ : IsCompositionForm Q) (x y : A) :
    conj Q (x * y) = conj Q y * conj Q x := by
  -- By definition of conjugation, we have:
  have h_conj_def : ∀ z, polar Q z (conj Q (x * y)) = polar Q z (conj Q y * conj Q x) := by
    intro z
    simp [conj];
    have := polar_exchange hQ z ( polar Q y 1 • 1 - y ) ( polar Q x 1 • 1 - x ) 1; simp_all +decide [ mul_sub, sub_mul ] ;
    rw [ show Q 1 = 1 from Q_one hQ ] at this; ring_nf at this ⊢;
    simp_all +decide [mul_comm, mul_left_comm, polar_conj_adjoint_left, polar_conj_adjoint_right];
    have := polar_conj_adjoint_left hQ x y z; have := polar_conj_adjoint_right hQ x y z; simp_all +decide [mul_comm, mul_left_comm] ;
    simp_all +decide [polar_comm, mul_comm, mul_left_comm, conj];
    simp_all +decide [polar_comm, mul_comm, mul_left_comm, add_mul, mul_add, sub_eq_add_neg];
    grobner;
  have h_conj_def : ∀ z, polar Q (conj Q (x * y) - conj Q y * conj Q x) z = 0 := by
    grind +suggestions;
  exact sub_eq_zero.mp ( polar_nondegenerate hQ h_conj_def )

/--
**Kirmse cancellation (left)**: `x-bar (x y) = Q x * y`, with NO
associativity. This is the identity that terminates the Cayley-Dickson ladder
in stage 2.
-/
theorem kirmse_left (hQ : IsCompositionForm Q) (x y : A) :
    conj Q x * (x * y) = Q x • y := by
  apply_fun ( fun z => polar Q z );
  · have h_cancel : ∀ z : A, polar Q (conj Q x * (x * y)) z = polar Q (Q x • y) z := by
      intro z
      have := polar_conj_adjoint_left hQ (conj Q x) (x * y) z
      simp_all +decide [ conj_conj, polar_mul_left_comp ];
    exact funext h_cancel;
  · intro z₁ z₂ h; specialize h; simp_all +decide [ funext_iff ] ;
    exact sub_eq_zero.mp ( polar_nondegenerate hQ fun x => by simpa [ sub_eq_zero ] using sub_eq_zero.mpr ( h x ) )

/--
**Kirmse cancellation (right)**: `(y x) x-bar = Q x * y`.
-/
theorem kirmse_right (hQ : IsCompositionForm Q) (x y : A) :
    (y * x) * conj Q x = Q x • y := by
  -- By nondegeneracy of the polar form, it suffices to show the inner product with every $z$ matches.
  suffices h_inner : ∀ z : A, polar Q (y * x * conj Q x) z = polar Q (Q x • y) z by
    contrapose! h_inner;
    have h_nondeg : ∀ u v : A, (∀ z : A, polar Q u z = polar Q v z) → u = v := by
      intro u v huv
      have h_eq : ∀ z : A, polar Q (u - v) z = 0 := by
        intro z; have := huv ( z - v ) ; have := huv ( -v ) ; simp_all +decide [ sub_eq_iff_eq_add ] ;
      exact sub_eq_zero.mp ( polar_nondegenerate hQ h_eq );
    exact not_forall.mp fun h => h_inner <| h_nondeg _ _ h;
  grind +suggestions

end HurwitzToolkit
