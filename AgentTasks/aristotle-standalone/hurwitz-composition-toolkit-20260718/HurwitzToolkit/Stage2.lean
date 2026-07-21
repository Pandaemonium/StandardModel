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

/-- **Doubling product formula (the crux of Hurwitz).** For `x, y, z, w` in a
unital conjugation-closed subalgebra `S` and `a` orthogonal to `S`:
`(x + y a)(z + w a) = (x z - Q a * (conj w * y)... ` precisely:

  `(x + y*a) * (z + w*a) = (x*z + (-(Q a)) • (conj Q w * y)) + ((w*x + y*conj Q z) * a)`

(Springer-Veldkamp 1.5.3 with lambda = -Q a; conventions per the stage-1
polar/conj normalization - the PROOF must derive, not assume, the placement of
conjugates, using the stage-1 adjoint and exchange identities plus
orthogonality). -/
theorem doubling_product (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (x z w y : A) (hx : x ∈ S) (hz : z ∈ S) (hw : w ∈ S) (hy : y ∈ S) :
    (x + y * a) * (z + w * a)
      = (x * z + (-(Q a)) • (conj Q w * y)) + (w * x + y * conj Q z) * a := by
  sorry

/-- The double is closed under multiplication (immediate corollary shape). -/
theorem doubling_closed (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (u v : A)
    (hu : ∃ x ∈ S, ∃ y ∈ S, u = x + y * a)
    (hv : ∃ z ∈ S, ∃ w ∈ S, v = z + w * a) :
    ∃ p ∈ S, ∃ q ∈ S, u * v = p + q * a := by
  sorry

/-- Norm on the double: `Q (x + y a) = Q x + Q a * Q y` (orthogonal splitting
of the norm; uses the stage-1 adjoints + orthogonality). -/
theorem doubling_norm (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a)
    (x y : A) (hx : x ∈ S) (hy : y ∈ S) :
    Q (x + y * a) = Q x + Q a * Q y := by
  sorry

end HurwitzToolkit
