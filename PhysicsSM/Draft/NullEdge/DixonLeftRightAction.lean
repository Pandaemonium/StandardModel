import PhysicsSM.Draft.NullEdge.WeakBetaLaddersFromColor

/-!
# The Dixon left/right-action framework (Furey's `x|y` bar operator)

SM-branch spine (items 1-deep chirality mechanism, 2 electroweak, 4-deep triality).
Furey 1806.00612 (page 5) works with LEFT and RIGHT actions of `C(x)O` on itself,
and the `x|y` "bar operator" `(x|y) z = x z y`. The two actions are conceptually
distinct - "the left action induces transitions between chiralities, the right
action between isospin up/down states" - and, crucially, they DO NOT MIX. This is
the algebraic origin of "the weak force is left-handed" (`ChiralityFromActionSplit`
is the finite matrix shadow of this).

This module builds the missing framework: left multiplication `Lmul`, right
multiplication `Rmul`, and the bar operator, and applies it to the item-2 CAR
question. Tonight's kernel-proven finding (`WeakBetaLaddersFromColor.
beta12_left_action_anticommutator`) was that the weak `beta`-ladders FAIL the CAR
under the LEFT action (`{beta_1,beta_2}_left = -1/2 Id`). Furey's isospin `Cl(2)`
is the RIGHT action (page 8: "the right action on Su+Sd induces transitions
between isospin up/down states"), so the CAR must be checked for `Rmul`.

Contains `s o r r y` (the heavy right-action CAR computation is an Aristotle
handoff). Convention guard: XOR octonions; non-associative - parenthesization is
explicit throughout.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.DixonLeftRightAction

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Draft.NullEdge.WeakBetaLaddersFromColor

/-- Left multiplication operator `L_x : z |-> x z`. -/
def Lmul (x z : ComplexOctonion) : ComplexOctonion := x * z

/-- Right multiplication operator `R_y : z |-> z y`. -/
def Rmul (y z : ComplexOctonion) : ComplexOctonion := z * y

/-- Furey's bar operator `(x|y) z = (x z) y` (parenthesization explicit; `C(x)O`
is non-associative so `(x z) y != x (z y)` in general). -/
def bar (x y z : ComplexOctonion) : ComplexOctonion := (x * z) * y

/-- `L_x` and `R_y` are both linear in `z` (they are multiplication, hence
additive); recorded as the additive property on a sum. -/
theorem Lmul_add (x z w : ComplexOctonion) : Lmul x (z + w) = Lmul x z + Lmul x w := by
  unfold Lmul; ext <;> simp [ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

theorem Rmul_add (y z w : ComplexOctonion) : Rmul y (z + w) = Rmul y z + Rmul y w := by
  unfold Rmul; ext <;> simp [ComplexOctonion.mul_re, ComplexOctonion.mul_im] <;> ring

/-- **The bar operator factors as right-then-left multiplication:**
`(x|y) z = R_y (L_x z)`. This is the framework identity linking the three actions. -/
theorem bar_eq_rmul_lmul (x y z : ComplexOctonion) : bar x y z = Rmul y (Lmul x z) := rfl

/-! ## Finding: the action choice does NOT fix the item-2 CAR

A natural hope was that the weak `beta`-ladder CAR, which FAILS under the LEFT
action (`WeakBetaLaddersFromColor.beta12_left_action_anticommutator`:
`{beta_1,beta_2}_left = -1/2 Id`), would hold under the RIGHT action. It does not:
evaluating the right-action anticommutator at `z = 1`,

  `{R_{beta_1}, R_{beta_2}}(1) = (1 . beta_2) . beta_1 + (1 . beta_1) . beta_2
                              = beta_2 beta_1 + beta_1 beta_2 = {beta_1, beta_2}`,

which is the ELEMENT anticommutator, already kernel-proven to be `-1/2` (not `0`)
by `WeakBetaLaddersFromColor.beta12_anticommutator_ne_zero`. So both actions agree
at the identity and both fail the like-CAR.

CORRECTED DIAGNOSIS: the `-1/2 Id` value is a MIXED-anticommutator (`delta`-like)
value, so the current `beta_2 = omega‡ i e_1` is behaving as the DAGGER of
`beta_1`, not as an independent second mode. i.e. the eq-30 reading of `beta_2`
(and/or the units/parenthesization) is off - the fix is a corrected `beta_2`, not
a change of action. This framework (`Lmul, Rmul, bar`) is nonetheless the right
scaffolding for the corrected ladders and for the chirality/isospin split. -/

end PhysicsSM.Draft.NullEdge.DixonLeftRightAction
