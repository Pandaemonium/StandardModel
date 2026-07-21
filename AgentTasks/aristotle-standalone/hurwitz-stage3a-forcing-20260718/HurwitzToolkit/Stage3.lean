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

variable {A : Type*} [NonAssocRing A] [Module ℝ A]

/-- **Stage 3a (the Hurwitz crux): an anisotropic orthogonal direction
forces the subalgebra to be associative.** -/
theorem orthogonal_forces_associative
    (Q : QuadraticForm ℝ A) (hQ : IsCompositionForm Q)
    (S : Submodule ℝ A) (hS : IsUnitalSubalgebra Q S)
    (a : A) (ha : OrthogonalTo Q S a) (haQ : Q a ≠ 0)
    (x y z : A) (hx : x ∈ S) (hy : y ∈ S) (hz : z ∈ S) :
    (x * y) * z = x * (y * z) := by
  sorry

end HurwitzToolkit
