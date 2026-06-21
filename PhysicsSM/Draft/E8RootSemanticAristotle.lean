import PhysicsSM.Draft.E8RootSemanticHelpers

/-!
# Aristotle scaffold: semantic E8 root classification

This draft packages job B from the Hamming/Construction A/E8 strengthening
list.  The current root list is trusted by Lean but many list facts are proved
by finite `n a t i v e _ d e c i d e` checks.  The target here is the semantic
classification:

* type I roots have exactly two nonzero coordinates, each equal to `+2` or `-2`;
* type II roots have all coordinates equal to `+1` or `-1` and coordinate sum
  congruent to `0` modulo `4`.

Together these should characterize `IsE8RootD` and hence `rootList`.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Algebra.Octonion.E8Root

-- IsType1RootD and IsType2RootD are defined in E8RootSemanticHelpers.lean

/-- **Semantic E8 root classification (doubled coordinates).**
An integer vector is an E8 root iff it is either type I (two coordinates ±2, rest 0)
or type II (all coordinates ±1, sum ≡ 0 mod 4).

Proved semantically from the definition of `IsE8RootD` without using
`rootList_complete`, `rootList_complete_arbitrary`, or `mem_rootList_iff_isE8RootD`. -/
theorem isE8RootD_iff_type1_or_type2_structural (v : Fin 8 → Int) :
    IsE8RootD v ↔ IsType1RootD v ∨ IsType2RootD v :=
  ⟨isE8RootD_implies_type1_or_type2 v, type1_or_type2_implies_isE8RootD v⟩

/-- Semantic membership characterization for the explicit root list. -/
theorem mem_rootList_iff_type1_or_type2_structural (v : Fin 8 → Int) :
    v ∈ rootList ↔ IsType1RootD v ∨ IsType2RootD v := by
  rw [mem_rootList_iff_isE8RootD]
  exact isE8RootD_iff_type1_or_type2_structural v

end PhysicsSM.Algebra.Octonion.E8Root
