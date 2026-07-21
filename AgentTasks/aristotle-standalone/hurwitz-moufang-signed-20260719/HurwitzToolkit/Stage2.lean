import HurwitzToolkit.Target

/-!
# Hurwitz stage 2: the Cayley-Dickson doubling lemma (SKELETON - not yet submitted)

Prepared 2026-07-18 while stage 1 runs; submit as a follow-up job WITH the
proven stage-1 toolkit. Source: Springer-Veldkamp Ch. 1 (Prop 1.5.1-1.5.3),
clean-room.

Setup: a unital composition algebra `(A, Q)` and a proper unital subalgebra
`S` (a submodule closed under multiplication, containing 1, closed under
conjugation) with an element `a` orthogonal to `S` of nonzero norm. Then the
internal double `S + S a` multiplies by the Cayley-Dickson formula with
parameter `-Q a`.

These statements only use the stage-1 DEFINITIONS (`IsCompositionForm`,
`conj`, Mathlib `QuadraticMap.polar`), so this file typechecks against the
sorried stage-1 file and against the proven one identically.
-/

namespace HurwitzToolkit

variable {A : Type*} [NonAssocRing A] [Module ℝ A]
  [SMulCommClass ℝ A A] [IsScalarTower ℝ A A] [Nontrivial A]

open QuadraticMap

/-- A unital, conjugation-closed, multiplicatively closed submodule: the
doubling substrate. -/
structure IsUnitalSubalgebra (Q : QuadraticForm ℝ A) (S : Submodule ℝ A) : Prop where
  one_mem : (1 : A) ∈ S
  mul_mem : ∀ x ∈ S, ∀ y ∈ S, x * y ∈ S
  conj_mem : ∀ x ∈ S, conj Q x ∈ S

/-- `a` is orthogonal to the submodule `S` (in the polar form). -/
def OrthogonalTo (Q : QuadraticForm ℝ A) (S : Submodule ℝ A) (a : A) : Prop :=
  ∀ x ∈ S, polar Q x a = 0

/-
Elements of the base subalgebra move past an orthogonal right multiple
with conjugation.
-/
lemma mul_orthogonal_commute (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (x w : A) (hx : x ∈ S) (hw : w ∈ S) :
    x * (w * a) = (w * a) * conj Q x := by
  -- Let $b = w * a$. First show $polar Q b 1 = 0$.
  set b : A := w * a
  have hb : polar Q b 1 = 0 := by
    convert ha ( conj Q w ) ( hS.conj_mem _ hw ) using 1;
    convert polar_conj_adjoint_left hQ w a 1 using 1;
    rw [ mul_one, polar_comm ];
  -- Since $polar Q x b = 0$, we have $x * b + b * x = polar Q x 1 • b$.
  have h_sum : x * b + b * x = polar Q x 1 • b := by
    have h_sum : polar Q x b = 0 := by
      convert polar_conj_adjoint_left hQ w a x using 1;
      · exact polar_comm _ _ _;
      · convert ha ( conj Q w * x ) _ |> Eq.symm using 1;
        · rw [ polar_comm ];
        · exact hS.mul_mem _ ( hS.conj_mem _ hw ) _ hx;
    have := quadratic_identity hQ ( x + b );
    simp_all +decide [ add_mul, mul_add, sub_eq_iff_eq_add' ];
    have := quadratic_identity hQ x; ( have := quadratic_identity hQ b; simp_all +decide [ add_smul, smul_add, smul_sub, sub_smul ] ; );
    simp_all +decide [ ← eq_sub_iff_add_eq', sub_eq_iff_eq_add, polar ];
    simp_all +decide [ add_smul, smul_add, smul_sub, sub_smul ];
    grind;
  convert eq_sub_of_add_eq h_sum using 1;
  unfold conj; simp +decide [ mul_sub, sub_mul, hb ] ;

/-
Restricted reassociation in the other mixed term.
-/
lemma mul_orthogonal_mul (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (y z : A) (hy : y ∈ S) (hz : z ∈ S) :
    (y * a) * z = (y * conj Q z) * a := by
  have h_ortho : ∀ x ∈ S, polar Q a x = 0 := by
    intro x hx; have := ha x hx; simp_all +decide [ polar_comm ] ;
  have h_eq : ∀ t : A, polar Q (y * a * z) t = polar Q (y * conj Q z * a) t := by
    intro t
    have h_eq : polar Q (y * a * z) t = polar Q (y * a) (t * conj Q z) := by
      convert polar_conj_adjoint_right hQ ( y * a ) z t using 1;
    convert h_eq using 1;
    rw [ polar_conj_adjoint_right ];
    · have h_eq : polar Q (y * conj Q z) (t * conj Q a) + polar Q (y * conj Q a) (t * conj Q z) = polar Q y t * polar Q (conj Q z) (conj Q a) := by
        convert polar_exchange hQ y t ( conj Q z ) ( conj Q a ) using 1;
      have h_eq : polar Q (conj Q z) (conj Q a) = 0 := by
        have h_eq : polar Q (conj Q z) (conj Q a) = polar Q z a := by
          have h_eq : ∀ x y : A, polar Q (conj Q x) (conj Q y) = polar Q x y := by
            intro x y; exact (by
            have := polar_conj_adjoint_right hQ x ( conj Q y ) 1; simp_all +decide [ mul_assoc, conj_mul ] ;
            simp_all +decide [ polar_conj_adjoint_left, polar_conj_adjoint_right, conj_conj ];
            rw [ ← this, polar_comm ]);
          exact h_eq z a;
        exact h_eq.trans ( ha z hz );
      have h_eq : polar Q (y * conj Q a) (t * conj Q z) = -polar Q (y * a) (t * conj Q z) := by
        simp +decide [ conj, h_ortho 1 hS.one_mem ];
      grind;
    · exact hQ;
  have := @polar_nondegenerate A;
  exact sub_eq_zero.mp ( this hQ fun t => by simp +decide [ h_eq t ] )

/-
Restricted reassociation for an orthogonal doubling element.
-/
lemma mul_mul_orthogonal_right (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (x w : A) (hx : x ∈ S) (hw : w ∈ S) :
    x * (w * a) = (w * x) * a := by
  rw [ mul_orthogonal_commute Q hQ S hS a ha x w hx hw ];
  rw [ mul_orthogonal_mul Q hQ S hS a ha ];
  · rw [ conj_conj hQ ];
  · exact hw;
  · exact hS.conj_mem x hx

/-
Right alternativity, derived from Kirmse cancellation and the quadratic
identity (not from associativity).
-/
lemma mul_right_alternative (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (u v : A) : (u * v) * v = u * (v * v) := by
  have h_kirmse : (u * v) * conj Q v = Q v • u := by
    exact?;
  have h_quadratic : v * v = polar Q v 1 • v - Q v • 1 := by
    have := quadratic_identity hQ v;
    grind;
  unfold conj at h_kirmse;
  simp_all +decide [ mul_sub, ← mul_assoc ];
  simp_all +decide [ sub_eq_iff_eq_add, mul_smul_comm ]

/-
Left alternativity, likewise derived without associativity.
-/
lemma mul_left_alternative (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (u v : A) : u * (u * v) = (u * u) * v := by
  have h_kirmse : conj Q u * (u * v) = Q u • v := by
    exact?;
  have h_quad : u * u - polar Q u 1 • u + Q u • (1 : A) = 0 := by
    exact quadratic_identity hQ u;
  simp_all +decide [ sub_eq_iff_eq_add, add_eq_zero_iff_eq_neg, mul_assoc ];
  simp +decide [ add_mul, neg_mul, smul_mul_assoc ];
  simp +decide [ ← mul_assoc, ← h_kirmse, conj ];
  simp +decide [ sub_mul, smul_mul_assoc ]

/-
The associator is skew in its last two variables.
-/
lemma associator_skew_right (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (u v w : A) : (u * v) * w - u * (v * w) =
      -((u * w) * v - u * (w * v)) := by
  have h_assoc : ∀ (u v w : A), (u * v) * w - u * (v * w) = -( (u * w) * v - u * (w * v) ) := by
    intro u v w
    have h := mul_right_alternative Q hQ u (v + w)
    simp_all +decide [ mul_add, add_mul, mul_assoc ];
    have h_assoc : u * v * v = u * (v * v) ∧ u * w * w = u * (w * w) := by
      exact ⟨ mul_right_alternative Q hQ u v, mul_right_alternative Q hQ u w ⟩;
    grind +qlia;
  exact h_assoc u v w

/-
The associator is skew in its first two variables.
-/
lemma associator_skew_left (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (u v w : A) : (u * v) * w - u * (v * w) =
      -((v * u) * w - v * (u * w)) := by
  have := mul_left_alternative Q hQ ( u + v ) w;
  simp_all +decide [ mul_add, add_mul, mul_assoc ];
  have := mul_left_alternative Q hQ u w; have := mul_left_alternative Q hQ v w; simp_all +decide [ mul_assoc, add_assoc, add_left_comm, add_comm ] ;
  grind

/-- The Teichmüller associator identity, valid in every nonassociative ring. -/
lemma teichmueller_identity (x y z t : A) :
    ((x * y) * z) * t - (x * y) * (z * t)
      - ((x * (y * z)) * t - x * ((y * z) * t))
      + ((x * y) * (z * t) - x * (y * (z * t))) =
    x * ((y * z) * t - y * (z * t))
      + ((x * y) * z - x * (y * z)) * t := by
  noncomm_ring

/- Additive form of the linearization of left alternativity. -/
lemma associator_linearized_left (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (x y z : A) :
    ((x * y) * z - x * (y * z)) + ((y * x) * z - y * (x * z)) = 0 := by
  have h := associator_skew_left Q hQ x y z
  rw [h, neg_add_cancel]

/- Additive form of the linearization of right alternativity. -/
lemma associator_linearized_right (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (x y z : A) :
    ((x * y) * z - x * (y * z)) + ((x * z) * y - x * (z * y)) = 0 := by
  have h := associator_skew_right Q hQ x y z
  grind

/-- The degree-four associator identity underlying right Moufang. -/
lemma associator_mul_right (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (x y z : A) :
    ((x * y) * z) * y - (x * y) * (z * y) =
      ((x * (y * z)) * y - x * ((y * z) * y)) := by
  sorry

/-- A right Moufang identity for composition algebras. -/
lemma mul_right_moufang (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (u v w : A) : (u * v) * (w * v) = (u * (v * w)) * v := by
  sorry

/-- Reassociation of two right multiples by the orthogonal element. -/
lemma mul_orthogonal_reassociate (Q : QuadraticForm ℝ A)
    (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (y w : A) (hy : y ∈ S) (hw : w ∈ S) :
    (y * a) * (w * a) = ((conj Q w * y) * a) * a := by
  rw [mul_right_moufang Q hQ]
  have haw : a * w = conj Q w * a := by
    symm
    simpa [conj_conj hQ] using
      mul_orthogonal_commute Q hQ S hS a ha (conj Q w) 1
        (hS.conj_mem w hw) hS.one_mem
  rw [haw]
  rw [mul_mul_orthogonal_right Q hQ S hS a ha y (conj Q w) hy
    (hS.conj_mem w hw)]

/-- The pure orthogonal-product term in the doubling formula. -/
lemma mul_orthogonal_mul_orthogonal (Q : QuadraticForm ℝ A)
    (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (y w : A) (hy : y ∈ S) (hw : w ∈ S) :
    (y * a) * (w * a) = (-(Q a)) • (conj Q w * y) := by
  rw [mul_orthogonal_reassociate Q hQ S hS a ha y w hy hw]
  rw [mul_right_alternative Q hQ]
  have htrace : polar Q a 1 = 0 := by
    simpa [polar_comm] using ha 1 hS.one_mem
  have haa : a * a = -(Q a) • (1 : A) := by
    have h := quadratic_identity hQ a
    rw [htrace, zero_smul, sub_zero] at h
    simpa only [neg_smul] using eq_neg_of_add_eq_zero_left h
  rw [haa]
  simp [mul_smul_comm]

/-
Orthogonality of the two summands of the internal double.
-/
lemma polar_mul_orthogonal (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (x y : A) (hx : x ∈ S) (hy : y ∈ S) :
    polar Q x (y * a) = 0 := by
  convert ha ( conj Q y * x ) _ using 1;
  · have := polar_conj_adjoint_left hQ y a x;
    rw [ ← polar_comm, this, polar_comm ];
  · exact hS.mul_mem _ ( hS.conj_mem _ hy ) _ hx

/-
**Doubling product formula (the crux of Hurwitz).** For `x, y, z, w` in a
unital conjugation-closed subalgebra `S` and `a` orthogonal to `S`:
`(x + y a)(z + w a) = (x z - Q a * (conj w * y)... ` precisely:

  `(x + y*a) * (z + w*a) = (x*z + (-(Q a)) • (conj Q w * y)) + ((w*x + y*conj Q z) * a)`

(Springer-Veldkamp 1.5.3 with lambda = -Q a; conventions per the stage-1
polar/conj normalization - the PROOF must derive, not assume, the placement of
conjugates, using the stage-1 adjoint and exchange identities plus
orthogonality).
-/
theorem doubling_product (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (x z w y : A) (hx : x ∈ S) (hz : z ∈ S) (hw : w ∈ S) (hy : y ∈ S) :
    (x + y * a) * (z + w * a)
      = (x * z + (-(Q a)) • (conj Q w * y)) + (w * x + y * conj Q z) * a := by
  have h1 := mul_mul_orthogonal_right Q hQ S hS a ha x w hx hw; ( have h2 := mul_orthogonal_mul Q hQ S hS a ha y z hy hz; ( have h3 := mul_orthogonal_mul_orthogonal Q hQ S hS a ha y w hy hw; ( ( rw [ add_mul, mul_add, mul_add, add_assoc ] ; simp_all +decide [ mul_assoc, add_assoc, add_comm, add_left_comm ] ; ) ) ) );
  simp +decide only [add_mul, add_assoc]

/-
The double is closed under multiplication (immediate corollary shape).
-/
theorem doubling_closed (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (u v : A)
    (hu : ∃ x ∈ S, ∃ y ∈ S, u = x + y * a)
    (hv : ∃ z ∈ S, ∃ w ∈ S, v = z + w * a) :
    ∃ p ∈ S, ∃ q ∈ S, u * v = p + q * a := by
  rcases hu with ⟨ x, hx, y, hy, rfl ⟩ ; rcases hv with ⟨ z, hz, w, hw, rfl ⟩ ; simp_all +decide [ mul_add, add_mul ] ;
  -- The terms $y * a * z$, $x * (w * a)$, and $y * a * (w * a)$ can be rewritten using the properties of multiplication and the doubling lemma.
  have h_rewrite : y * a * z = (y * conj Q z) * a ∧ x * (w * a) = (w * x) * a ∧ y * a * (w * a) = (-(Q a)) • (conj Q w * y) := by
    exact ⟨ mul_orthogonal_mul Q hQ S hS a ha y z hy hz, mul_mul_orthogonal_right Q hQ S hS a ha x w hx hw, mul_orthogonal_mul_orthogonal Q hQ S hS a ha y w hy hw ⟩;
  refine' ⟨ x * z + -Q a • ( conj Q w * y ), _, y * conj Q z + w * x, _, _ ⟩;
  · exact S.add_mem ( hS.mul_mem _ hx _ hz ) ( S.smul_mem _ ( hS.mul_mem _ ( hS.conj_mem _ hw ) _ hy ) );
  · exact S.add_mem ( hS.mul_mem _ hy _ ( hS.conj_mem _ hz ) ) ( hS.mul_mem _ hw _ hx );
  · simp +decide only [h_rewrite, add_left_comm, add_assoc, add_comm, add_mul]

/-
Norm on the double: `Q (x + y a) = Q x + Q a * Q y` (orthogonal splitting
of the norm; uses the stage-1 adjoints + orthogonality).
-/
theorem doubling_norm (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (x y : A) (hx : x ∈ S) (hy : y ∈ S) :
    Q (x + y * a) = Q x + Q a * Q y := by
  have h_expand : Q (x + y * a) = Q x + Q (y * a) + polar Q x (y * a) := by
    unfold polar; ring;
  rw [ h_expand, hQ.comp, mul_comm ];
  simp +decide [ polar_mul_orthogonal Q hQ S hS a ha x y hx hy ]

end HurwitzToolkit
