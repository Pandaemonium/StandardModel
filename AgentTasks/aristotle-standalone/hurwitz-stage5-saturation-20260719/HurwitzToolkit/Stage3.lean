import HurwitzToolkit.Stage2

/-!
# Stage 3a: orthogonal complement forces associativity (the Hurwitz crux)

**The classical saturation lemma.** If `S` is a unital composition
subalgebra of a composition algebra `(A, Q)` and there exists an
anisotropic element orthogonal to `S`, then `S` is ASSOCIATIVE. This is the
engine of Hurwitz's theorem: the double of an associative-but-not-
commutative algebra is non-associative, and the double of a non-associative
algebra cannot be a composition subalgebra - so the doubling tower
`R -> C-like -> H-like -> O-like` saturates at dimension 8.

Route (classical, e.g. Springer-Veldkamp 1.5 / Conway-Smith ch. 6): for
`x, y, z in S` expand the doubled products `(x + y a)(z + w a)` with the
stage-2 laws; comparing the `a`-components of `((u v) t)`-style products
against `Q`-multiplicativity (or directly: applying `doubling_product` with
suitable choices and using orthogonality/anisotropy of `a` to cancel)
yields `conj`-twisted reassociation identities on `S` that combine with the
stage-1 conjugation involution to give `(x*y)*z = x*(y*z)`.

The TWO Moufang sorries inherited from stage 2 may be used freely if
needed (they are being closed in a parallel job) - but a proof avoiding
them is preferred; report which ingredients you used.
-/

namespace HurwitzToolkit

open QuadraticMap

variable {A : Type*} [NonAssocRing A] [Module ℝ A]
  [SMulCommClass ℝ A A] [IsScalarTower ℝ A A] [Nontrivial A]

/-
Expansion of a quadratic form on a sum with a scaled second term.
-/
lemma quadratic_add_smul_expansion (Q : QuadraticForm ℝ A)
    (u v : A) (r : ℝ) :
    Q (u + r • v) = Q u + r ^ 2 * Q v + r * polar Q u v := by
  have h1 : ∀ x y : A, Q (x + y) = Q x + Q y + polar Q x y := by
    simp +decide [ polar ];
  rw [ h1, Q.map_smul ] ; norm_num;
  exact Or.inl ( by ring )

/-- Norm multiplicativity written in Cayley--Dickson coordinates. -/
lemma doubled_product_norm_equation
    (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (x y z w : A) (hx : x ∈ S) (hy : y ∈ S) (hz : z ∈ S) (hw : w ∈ S) :
    Q (x * z + (-(Q a)) • (conj Q w * y)) +
        Q a * Q (w * x + y * conj Q z) =
      (Q x + Q a * Q y) * (Q z + Q a * Q w) := by
  let p := x * z + (-(Q a)) • (conj Q w * y)
  let q := w * x + y * conj Q z
  have hp : p ∈ S := by
    dsimp [p]
    exact S.add_mem (hS.mul_mem x hx z hz)
      (S.smul_mem (-(Q a)) (hS.mul_mem (conj Q w) (hS.conj_mem w hw) y hy))
  have hq : q ∈ S := by
    dsimp [q]
    exact S.add_mem (hS.mul_mem w hw x hx)
      (hS.mul_mem y hy (conj Q z) (hS.conj_mem z hz))
  have hprod : (x + y * a) * (z + w * a) = p + q * a := by
    simpa [p, q] using doubling_product Q hQ S hS a ha x z w y hx hz hw hy
  calc
    Q p + Q a * Q q = Q (p + q * a) :=
      (doubling_norm Q hQ S hS a ha p q hp hq).symm
    _ = Q ((x + y * a) * (z + w * a)) := congrArg Q hprod.symm
    _ = Q (x + y * a) * Q (z + w * a) := hQ.comp _ _
    _ = (Q x + Q a * Q y) * (Q z + Q a * Q w) := by
      rw [doubling_norm Q hQ S hS a ha x y hx hy,
        doubling_norm Q hQ S hS a ha z w hz hw]

/-
The mixed polar identity obtained by comparing the norm of a doubled
product with multiplicativity.
-/
lemma doubled_mixed_polar_identity
    (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a) (haQ : Q a ≠ 0)
    (x y z w : A) (hx : x ∈ S) (hy : y ∈ S) (hz : z ∈ S) (hw : w ∈ S) :
    polar Q (x * z) (conj Q w * y) =
      polar Q (w * x) (y * conj Q z) := by
  have := @HurwitzToolkit.doubled_product_norm_equation;
  have := @this A _ _ _ _ _ Q hQ S hS a ha;
  have h_expand : Q (x * z + -Q a • (conj Q w * y)) = Q (x * z) + Q a ^ 2 * Q (conj Q w * y) - Q a * polar Q (x * z) (conj Q w * y) ∧ Q (w * x + y * conj Q z) = Q (w * x) + Q (y * conj Q z) + polar Q (w * x) (y * conj Q z) := by
    constructor;
    · convert quadratic_add_smul_expansion Q ( x * z ) ( conj Q w * y ) ( -Q a ) using 1 ; ring;
    · convert quadratic_add_smul_expansion Q ( w * x ) ( y * conj Q z ) 1 using 1 ; simp +decide;
      ring;
  have h_expand : Q (x * z) = Q x * Q z ∧ Q (conj Q w * y) = Q w * Q y ∧ Q (w * x) = Q w * Q x ∧ Q (y * conj Q z) = Q y * Q z := by
    exact ⟨ hQ.comp x z, by rw [ hQ.comp, Q_conj hQ ], hQ.comp w x, by rw [ hQ.comp, Q_conj hQ ] ⟩;
  grind

/-
The mixed polar identity forces the associator of three elements of the
base subalgebra to vanish.
-/
lemma doubled_mixed_polar_implies_associative
    (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (hcross : ∀ x y z w : A, x ∈ S → y ∈ S → z ∈ S → w ∈ S →
      polar Q (x * z) (conj Q w * y) =
        polar Q (w * x) (y * conj Q z))
    (x y z : A) (hx : x ∈ S) (hy : y ∈ S) (hz : z ∈ S) :
    (x * y) * z = x * (y * z) := by
  have hd_mem : (x * y) * z - x * (y * z) ∈ S := by
    exact S.sub_mem ( hS.mul_mem _ ( hS.mul_mem _ hx _ hy ) _ hz ) ( hS.mul_mem _ hx _ ( hS.mul_mem _ hy _ hz ) );
  have hBdd : polar Q ((x * y) * z - x * (y * z)) ((x * y) * z - x * (y * z)) = 0 := by
    grind +suggestions;
  have := hQ.2 ( x * y * z - x * ( y * z ) ) ?_ <;> simp_all +decide [ sub_eq_iff_eq_add ]

/-
**Stage 3a (the Hurwitz crux): an anisotropic orthogonal direction
forces the subalgebra to be associative.**
-/
theorem orthogonal_forces_associative
    (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a) (haQ : Q a ≠ 0)
    (x y z : A) (hx : x ∈ S) (hy : y ∈ S) (hz : z ∈ S) :
    (x * y) * z = x * (y * z) := by
  have := @HurwitzToolkit.doubled_mixed_polar_implies_associative;
  exact this Q hQ S hS ( HurwitzToolkit.doubled_mixed_polar_identity Q hQ S hS a ha haQ ) x y z hx hy hz

end HurwitzToolkit
