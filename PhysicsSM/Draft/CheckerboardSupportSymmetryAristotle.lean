import Mathlib
import PhysicsSM.Spinor.Checkerboard

/-!
# Draft.CheckerboardSupportSymmetryAristotle

Aristotle handoff (wave 2): support, parity, symmetry, and massless-limit
lemmas for the finite 1+1D Feynman checkerboard path sum of the trusted
module `PhysicsSM.Spinor.Checkerboard`.

## Mathematical intent

The structural lemmas that make the checkerboard kernel a *causal* lattice
kernel (research program
`Sources/Luminal_Motion_Checkerboard_Research_Program.md`, WP1):

1. **light-cone support**: `n` steps of speed `1` cannot move farther than
   `n`, so the path sum vanishes outside the discrete light cone;
2. **parity support**: each step changes the position by `+-1`, so the
   displacement has the parity of `n`;
3. **translation invariance**: the kernel depends only on the displacement;
4. **reflection symmetry**: flipping all directions and reflecting space is
   a symmetry of the path sum;
5. **massless limit**: at `mu = 0` only the cornerless straight null line
   survives -- the checkerboard statement that a massless particle moves at
   the speed of light forever.

Together with the recursion package
(`PhysicsSM.Draft.CheckerboardSpinorRecursionAristotle`, proved in wave 1)
these are the remaining trusted-tier facts needed before the kernel closed
form is assembled.

## Conventions

A history is a `List Direction` of future steps; the incoming direction is
carried separately, and the corner between the incoming direction and the
first step is weighted (see the trusted module docstring).  `Direction.step`
is `+1` for `right`, `-1` for `left`; `Direction.flip` exchanges them.

## Proof guidance

- All targets should follow by induction on `n` (generalizing the start
  data) from the trusted first-step decomposition `pathSum_succ` and the
  base lemmas `pathSum_zero_same` / `pathSum_zero_ne_pos`; alternatively
  the last-step recursion of the wave-1 file may be re-proved locally if
  needed (do not import the other draft, keep this file standing alone on
  the trusted module).
- For the support lemmas, the inductive step shrinks the discrete cone by
  one unit; `omega` should close the integer-arithmetic side conditions.
- For `pathSum_massless`, note `turnWeight (0 : S) d e` is `1` if `e = d`
  and `0` otherwise, so only the straight history contributes; the endpoint
  of the straight history is `x + n * d.step`.

Do not change any definition of `PhysicsSM.Spinor.Checkerboard`.  Helper
lemmas are welcome.  The final state should contain no placeholder proof
commands, no new assumptions, and no forbidden declarations.

This is draft code: the statements below contain documented handoff holes
and must not be imported from trusted code until they are eliminated.
-/

namespace PhysicsSM.Draft.CheckerboardSupportSymmetry

open PhysicsSM.Spinor.Checkerboard
open PhysicsSM.Spinor.Checkerboard.Direction

variable {S : Type*}

/-! ## Helper lemmas -/

/-- Flipping both directions preserves the corner weight. -/
theorem turnWeight_flip_flip [Semiring S] (mu : S) (a b : Direction) :
    turnWeight mu a.flip b.flip = turnWeight mu a b := by
  cases a <;> cases b <;> rfl

/-- At `mu = 0` the corner weight is the indicator of going straight. -/
theorem turnWeight_zero [Semiring S] (d e : Direction) :
    turnWeight (0 : S) d e = if e = d then 1 else 0 := by
  cases d <;> cases e <;> simp [turnWeight]

/-! ## Target 1: light-cone support -/

/-- **Light-cone support.**  The path sum vanishes outside the discrete
light cone `|y - x| <= n`. -/
theorem pathSum_eq_zero_of_lt_natAbs [Semiring S] (mu : S) (x : Int)
    (d : Direction) (n : Nat) (y : Int) (e : Direction)
    (h : n < (y - x).natAbs) :
    pathSum mu x d n y e = 0 := by
  induction' n with n ih generalizing x d y e <;> simp_all +decide [ pathSum_succ ];
  · exact pathSum_zero_ne_pos mu ( by aesop );
  · grind +suggestions

/-! ## Target 2: parity support -/

/-- **Parity support.**  After `n` unit steps the displacement has the
parity of `n`, so the path sum vanishes when `y - x + n` is odd. -/
theorem pathSum_eq_zero_of_odd [Semiring S] (mu : S) (x : Int)
    (d : Direction) (n : Nat) (y : Int) (e : Direction)
    (h : ¬ (2 : Int) ∣ (y - x + n)) :
    pathSum mu x d n y e = 0 := by
  induction' n with n ih generalizing x d y e <;> simp_all +decide [ Direction.step_left, Direction.step_right ];
  · grind +suggestions;
  · rw [ pathSum_succ ];
    rw [ ih, ih ] <;> norm_num [ Direction.step_left, Direction.step_right ] <;> omega

/-! ## Target 3: translation invariance -/

/-- **Translation invariance.**  The kernel depends on the endpoints only
through the displacement. -/
theorem pathSum_translate [Semiring S] (mu : S) (x : Int) (d : Direction)
    (n : Nat) (y : Int) (e : Direction) (t : Int) :
    pathSum mu (x + t) d n (y + t) e = pathSum mu x d n y e := by
  induction' n with n ih generalizing x d y e;
  · cases d <;> cases e <;> simp_all +decide [ pathSum ];
  · rw [ pathSum_succ, pathSum_succ ];
    grind +qlia

/-! ## Target 4: reflection symmetry -/

/-- **Spatial reflection.**  Reflecting space (`x -> -x`) and flipping all
directions is a symmetry of the checkerboard. -/
theorem pathSum_reflect [Semiring S] (mu : S) (x : Int) (d : Direction)
    (n : Nat) (y : Int) (e : Direction) :
    pathSum mu (-x) d.flip n (-y) e.flip = pathSum mu x d n y e := by
  induction' n with n ih generalizing x d y e;
  · cases d <;> cases e <;> simp +decide [ pathSum ];
  · cases d <;> cases e <;> simp_all +decide [ pathSum_succ ];
    · have := ih ( x + 1 ) right y left; have := ih ( x + -1 ) left y left; simp_all +decide [ add_comm, add_left_comm, add_assoc ] ;
      rfl;
    · rw [ ← ih, ← ih ] ; ring!;
      convert congr_arg₂ ( · + · ) ( ih ( -1 + x ) left y right ) ( congr_arg ( fun z => turnWeight mu left right * z ) ( ih ( 1 + x ) right y right ) ) using 1 ; ring!;
      rw [ add_comm ] ; aesop;
    · have := ih ( x + 1 ) right y left; have := ih ( x + -1 ) left y left; simp_all +decide [ pathSum_succ ] ;
      simp_all +decide [ add_comm, turnWeight ];
    · convert congr_arg₂ ( · + · ) ( ih ( x + 1 ) right y right ) ( congr_arg ( fun z => turnWeight mu left right * z ) ( ih ( x - 1 ) left y right ) ) using 1 ; ring;
      · congr! 2;
      · simp only [turnWeight, sub_eq_add_neg]; exact add_comm _ _

/-! ## Target 5: the massless limit -/

/-- **Massless limit.**  At `mu = 0` every corner is forbidden, so the
kernel is the indicator of the straight null line: the particle moves at
the speed of light in its initial direction forever. -/
theorem pathSum_massless [Semiring S] (x : Int) (d : Direction) (n : Nat)
    (y : Int) (e : Direction) :
    pathSum (0 : S) x d n y e
      = if y = x + n * d.step ∧ e = d then 1 else 0 := by
  induction' n with n ih generalizing x d y e <;> simp +decide [ *, pathSum_succ ];
  · cases d <;> cases e <;> simp +decide [ pathSum ]; all_goals grind;
  · cases d <;> cases e <;> simp +decide [ Direction.step ] <;> ring;
    · exact fun h => by rfl;
    · exact fun h => rfl

end PhysicsSM.Draft.CheckerboardSupportSymmetry
