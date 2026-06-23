import Mathlib.Tactic

/-!
# P1 observer-axis two-null split

This standalone target models the observer-relative two-null decomposition in
the `1+1` plane spanned by a timelike observer and the observed spatial momentum
direction. It is the algebraic core of the publication-plan statement that,
after choosing an observer frame and axis, a timelike momentum can be written as
a sum of two null momenta.
-/

namespace NullEdgeP1TwoNullSplit

noncomputable section

structure Vec2 where
  t : Real
  x : Real

def add (u v : Vec2) : Vec2 :=
  { t := u.t + v.t, x := u.x + v.x }

def momentum (E s : Real) : Vec2 :=
  { t := E, x := s }

def minkowskiSq (v : Vec2) : Real :=
  v.t ^ 2 - v.x ^ 2

def kPlus (E s : Real) : Vec2 :=
  { t := (E + s) / 2, x := (E + s) / 2 }

def kMinus (E s : Real) : Vec2 :=
  { t := (E - s) / 2, x := -((E - s) / 2) }

theorem kPlus_null (E s : Real) :
    minkowskiSq (kPlus E s) = 0 := by
  sorry

theorem kMinus_null (E s : Real) :
    minkowskiSq (kMinus E s) = 0 := by
  sorry

theorem kPlus_add_kMinus_eq_momentum (E s : Real) :
    add (kPlus E s) (kMinus E s) = momentum E s := by
  sorry

theorem momentum_massSq_eq_observer_split (E s : Real) :
    minkowskiSq (momentum E s) = E ^ 2 - s ^ 2 := by
  rfl

end

end NullEdgeP1TwoNullSplit
