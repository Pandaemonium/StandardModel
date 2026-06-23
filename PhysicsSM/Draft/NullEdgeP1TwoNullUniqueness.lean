import Mathlib.Tactic

/-!
# P1 observer-axis two-null split uniqueness

In the observer-axis `1+1` model, any right-moving null vector plus any
left-moving null vector that sums to `(E, s)` has the canonical coefficients
`(E + s) / 2` and `(E - s) / 2`.
-/

namespace PhysicsSM.Draft.NullEdgeP1TwoNullUniqueness

noncomputable section

structure Vec2 where
  t : Real
  x : Real

def add (u v : Vec2) : Vec2 :=
  { t := u.t + v.t, x := u.x + v.x }

def momentum (E s : Real) : Vec2 :=
  { t := E, x := s }

def rightNull (a : Real) : Vec2 :=
  { t := a, x := a }

def leftNull (b : Real) : Vec2 :=
  { t := b, x := -b }

def kPlus (E s : Real) : Vec2 :=
  rightNull ((E + s) / 2)

def kMinus (E s : Real) : Vec2 :=
  leftNull ((E - s) / 2)

theorem observer_axis_split_coefficients_unique
    (a b E s : Real)
    (h : add (rightNull a) (leftNull b) = momentum E s) :
    And (a = (E + s) / 2) (b = (E - s) / 2) := by
  simp only [add, rightNull, leftNull, momentum, Vec2.mk.injEq] at h
  obtain ⟨h1, h2⟩ := h
  constructor <;> linarith

theorem observer_axis_split_vectors_unique
    (a b E s : Real)
    (h : add (rightNull a) (leftNull b) = momentum E s) :
    And (rightNull a = kPlus E s) (leftNull b = kMinus E s) := by
  obtain ⟨ha, hb⟩ := observer_axis_split_coefficients_unique a b E s h
  constructor
  · simp [kPlus, rightNull, ha]
  · simp [kMinus, leftNull, hb]

end

end PhysicsSM.Draft.NullEdgeP1TwoNullUniqueness
