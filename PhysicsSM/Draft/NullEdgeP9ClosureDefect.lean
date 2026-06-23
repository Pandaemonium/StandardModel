import Mathlib.Tactic

/-!
# P9 closure-defect criterion

The squared closure defect vanishes exactly when each closure component
vanishes. This is the scalar finite guardrail for treating closure violation as
a visible source candidate.
-/

namespace PhysicsSM.Draft.NullEdgeP9ClosureDefect

def closureDefectSq (cx cy cz : Real) : Real :=
  cx ^ 2 + cy ^ 2 + cz ^ 2

theorem closureDefectSq_zero_iff_closed
    (cx cy cz : Real) :
    closureDefectSq cx cy cz = 0 <-> cx = 0 ∧ cy = 0 ∧ cz = 0 := by
  unfold closureDefectSq
  constructor
  · intro h
    refine ⟨?_, ?_, ?_⟩ <;>
      nlinarith [sq_nonneg cx, sq_nonneg cy, sq_nonneg cz]
  · rintro ⟨hx, hy, hz⟩
    subst hx
    subst hy
    subst hz
    ring

end PhysicsSM.Draft.NullEdgeP9ClosureDefect
