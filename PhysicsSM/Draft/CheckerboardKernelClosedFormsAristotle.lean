import PhysicsSM.Draft.CheckerboardCornerPolynomialAristotle
import PhysicsSM.Draft.CheckerboardCornerClosedFormsAristotle

/-!
# Draft.CheckerboardKernelClosedFormsAristotle

Focused Aristotle handoff: combine the corner-count polynomial theorem with
the binomial corner-count closed forms to get endpoint-level closed forms for
the finite checkerboard path sum.

The imported draft files already prove:

- the path sum is a polynomial in the corner weight, with coefficients given
  by fixed-endpoint corner classes;
- the right-incoming corner classes have binomial closed forms.

The target here is the publication-facing kernel statement: for a path from
`0` to displacement `p - q` in `p + q` lightlike steps, starting incoming
right, the directed endpoint path sum is the corresponding finite polynomial
in `mu`.

This is still finite combinatorics.  No continuum limit or analytic
normalization is asserted here.
-/

namespace PhysicsSM.Draft.CheckerboardKernelClosedForms

open PhysicsSM.Spinor.Checkerboard
open PhysicsSM.Spinor.Checkerboard.Direction

variable {S : Type*}

/-- The two imported corner-class definitions are intentionally identical. -/
theorem turnHistories_poly_eq_closed (n : Nat) (startDir : Direction)
    (dx : Int) (finishDir : Direction) (k : Nat) :
    PhysicsSM.Draft.CheckerboardCornerPolynomial.turnHistories
        n startDir dx finishDir k =
      PhysicsSM.Draft.CheckerboardCornerClosedForms.turnHistories
        n startDir dx finishDir k := by
  rfl

/-!
## Aristotle targets

The hypotheses `0 < q` avoid the straight-line boundary case.  The separate
boundary theorem below handles `q = 0`.
-/

/--
Right-to-right endpoint kernel.  Only even corner counts contribute; the
coefficient of `mu^(2*r)` is the number of ways to split the `p` right steps
and `q` left steps into alternating runs.
-/
theorem pathSum_right_right_closed_form [Semiring S] (mu : S)
    (p q : Nat) (hq : 0 < q) :
    pathSum mu 0 Direction.right (p + q)
        ((p : Int) - (q : Int)) Direction.right
      =
        ∑ r ∈ Finset.Icc 1 (p + q),
          ((p.choose r * (q - 1).choose (r - 1) : Nat) : S) * mu ^ (2 * r) := by
  sorry

/--
Right-to-left endpoint kernel.  Only odd corner counts contribute; the
coefficient of `mu^(2*r+1)` is the corresponding alternating-run count.
-/
theorem pathSum_right_left_closed_form [Semiring S] (mu : S)
    (p q : Nat) (hq : 0 < q) :
    pathSum mu 0 Direction.right (p + q)
        ((p : Int) - (q : Int)) Direction.left
      =
        ∑ r ∈ Finset.range (p + 1),
          ((p.choose r * (q - 1).choose r : Nat) : S) * mu ^ (2 * r + 1) := by
  sorry

/--
Straight right-moving boundary case: if there are no left steps, the unique
right-to-right history has weight `1`.
-/
theorem pathSum_right_right_straight [Semiring S] (mu : S) (p : Nat) :
    pathSum mu 0 Direction.right p (p : Int) Direction.right = 1 := by
  sorry

/--
With no left steps, no history can start incoming right and end moving left at
the maximal right endpoint.
-/
theorem pathSum_right_left_straight_zero [Semiring S] (mu : S) (p : Nat) :
    pathSum mu 0 Direction.right p (p : Int) Direction.left = 0 := by
  sorry

end PhysicsSM.Draft.CheckerboardKernelClosedForms
