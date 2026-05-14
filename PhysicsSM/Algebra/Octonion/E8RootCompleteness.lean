import Mathlib
import PhysicsSM.Algebra.Octonion.IntegralOctonion

/-!
# E8 Root List — Arbitrary Integer-Vector Completeness

This module upgrades the finite-range completeness theorem `rootList_complete`
to an arbitrary integer-vector completeness theorem: every `v : Fin 8 → ℤ`
satisfying `IsE8RootD v` belongs to `E8Root.rootList`.

## Strategy

1. `coordinate_abs_le_two_of_normSqD_eq_8` shows that any vector with
   `normSqD v = 8` has all coordinates in `{-2, -1, 0, 1, 2}`.
2. We define `intToFin5` converting an integer with `|z| ≤ 2` to the
   corresponding index in `![-2, -1, 0, 1, 2]`.
3. We verify that the round-trip recovers the original value.
4. We combine with `rootList_complete` to get the arbitrary completeness.
-/

set_option linter.style.nativeDecide false

namespace PhysicsSM.Algebra.Octonion.E8Root

/-- Convert an integer in `[-2, 2]` to the corresponding `Fin 5` index
    into `![-2, -1, 0, 1, 2]`. -/
def intToFin5 (z : ℤ) : Fin 5 :=
  if z = -2 then 0
  else if z = -1 then 1
  else if z = 0 then 2
  else if z = 1 then 3
  else 4  -- z = 2

/-- The value list used in `rootList_complete`. -/
abbrev valList : Fin 5 → ℤ := ![-2, -1, 0, 1, 2]

/-- Round-trip: looking up `intToFin5 z` in the value list recovers `z`,
    provided `|z| ≤ 2`. -/
theorem valList_intToFin5_eq (z : ℤ) (hz : |z| ≤ 2) :
    valList (intToFin5 z) = z := by
  rcases abs_le.mp hz with ⟨h₁, h₂⟩
  interval_cases z <;> trivial

/-- For any `v : Fin 8 → ℤ` with `normSqD v = 8`, expressing `v` through
    `intToFin5` and `valList` recovers the original vector. -/
theorem vector_eq_valList_comp_intToFin5 (v : Fin 8 → ℤ) (hv : normSqD v = 8) :
    (fun i => valList (intToFin5 (v i))) = v :=
  funext fun i => valList_intToFin5_eq _ (coordinate_abs_le_two_of_normSqD_eq_8 v hv i)

/-- **Arbitrary completeness**: every `v : Fin 8 → ℤ` satisfying `IsE8RootD v`
    belongs to `rootList`. -/
theorem rootList_complete_arbitrary (v : Fin 8 → ℤ) (hv : IsE8RootD v) :
    v ∈ rootList := by
  convert rootList_complete (fun i => intToFin5 (v i)) _ using 1
  · exact (vector_eq_valList_comp_intToFin5 v hv.1).symm
  · convert hv using 1
    exact vector_eq_valList_comp_intToFin5 v hv.1

/-- `rootList` enumerates exactly the E8 root predicate `IsE8RootD`. -/
theorem mem_rootList_iff_isE8RootD (v : Fin 8 → ℤ) :
    v ∈ rootList ↔ IsE8RootD v := by
  constructor
  · intro hv
    exact List.forall_iff_forall_mem.mp rootList_all_isE8RootD v hv
  · exact rootList_complete_arbitrary v

end PhysicsSM.Algebra.Octonion.E8Root
