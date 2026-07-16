import Mathlib

/-!
# Schedule-indexed transport telescope

This standalone handoff isolates the noncommutative algebra missing from the
constant-frame HNU holonomy result. A path stores, for each step, the next frame
and the bare operator written in the current frame. The dressed step is
`gNext * s * gCurrent^-1`.

The target telescope must retain both endpoint factors. In a cyclic schedule,
it reduces to conjugation by the initial frame. Consequently a central bare
holonomy is invariant under a passive schedule-local frame change with links
transformed consistently.
-/

namespace ScheduleIndexedTransportCore

variable {G : Type*} [Group G]

/-- Ordered bare product, with later path entries acting on the left. -/
def bareProduct : List (G × G) → G
  | [] => 1
  | (_, s) :: rest => bareProduct rest * s

/-- Final frame of the path, or the initial frame for an empty path. -/
def endFrame (g0 : G) : List (G × G) → G
  | [] => g0
  | (g1, _) :: rest => endFrame g1 rest

/-- Ordered product of dressed steps `g_(j+1) * s_j * g_j^-1`. -/
def dressedProduct (g0 : G) : List (G × G) → G
  | [] => 1
  | (g1, s) :: rest => dressedProduct g1 rest * (g1 * s * g0⁻¹)

/-- Exact varying-frame telescope, including both endpoint factors. -/
theorem dressedProduct_telescope (g0 : G) (path : List (G × G)) :
    dressedProduct g0 path = endFrame g0 path * bareProduct path * g0⁻¹ := by
  sorry

/-- A cyclic passive frame change conjugates the bare ordered product. -/
theorem dressedProduct_cycle (g0 : G) (path : List (G × G))
    (hcycle : endFrame g0 path = g0) :
    dressedProduct g0 path = g0 * bareProduct path * g0⁻¹ := by
  rw [dressedProduct_telescope, hcycle]

/-- If the bare holonomy is central, a cyclic passive frame change preserves it. -/
theorem dressedProduct_cycle_of_commutes (g0 z : G) (path : List (G × G))
    (hcycle : endFrame g0 path = g0)
    (hbare : bareProduct path = z)
    (hcentral : g0 * z = z * g0) :
    dressedProduct g0 path = z := by
  rw [dressedProduct_cycle g0 path hcycle, hbare, hcentral]
  simp

end ScheduleIndexedTransportCore
