import Mathlib

namespace D4NullShell

abbrev Vec4 := Fin 4 -> ℤ

def rootsList : List Vec4 := [
  ![1, 1, 0, 0], ![1, -1, 0, 0], ![-1, 1, 0, 0], ![-1, -1, 0, 0],
  ![1, 0, 1, 0], ![1, 0, -1, 0], ![-1, 0, 1, 0], ![-1, 0, -1, 0],
  ![1, 0, 0, 1], ![1, 0, 0, -1], ![-1, 0, 0, 1], ![-1, 0, 0, -1],
  ![0, 1, 1, 0], ![0, 1, -1, 0], ![0, -1, 1, 0], ![0, -1, -1, 0],
  ![0, 1, 0, 1], ![0, 1, 0, -1], ![0, -1, 0, 1], ![0, -1, 0, -1],
  ![0, 0, 1, 1], ![0, 0, 1, -1], ![0, 0, -1, 1], ![0, 0, -1, -1]]

def roots : Finset Vec4 := rootsList.toFinset

def euclideanNormSq (v : Vec4) : ℤ := ∑ i, (v i) ^ 2

def minkowskiSq (v : Vec4) : ℤ :=
  (v 0) ^ 2 - (v 1) ^ 2 - (v 2) ^ 2 - (v 3) ^ 2

def nullRoots : Finset Vec4 := roots.filter (fun v => minkowskiSq v = 0)

theorem d4_root_count : roots.card = 24 := by
  sorry

theorem every_root_has_norm_two :
    ∀ v ∈ roots, euclideanNormSq v = 2 := by
  sorry

/-- Exactly the twelve D4 roots involving the distinguished time coordinate
are Minkowski-null. -/
theorem null_root_count : nullRoots.card = 12 := by
  sorry

/-- Every selected root is a primitive luminal step: unit time magnitude and
unit spatial squared displacement. -/
theorem every_null_root_is_unit_luminal :
    ∀ v ∈ nullRoots,
      |v 0| = 1 ∧ (v 1) ^ 2 + (v 2) ^ 2 + (v 3) ^ 2 = 1 := by
  sorry

theorem null_shell_antipodal :
    ∀ v ∈ nullRoots, (-v) ∈ nullRoots := by
  sorry

/-- Selection is essential: the D4 shell also contains purely spatial roots,
which are spacelike in the displayed Lorentz convention. -/
theorem spacelike_root_control :
    (![0, 1, 1, 0] : Vec4) ∈ roots ∧
      (![0, 1, 1, 0] : Vec4) ∉ nullRoots ∧
      minkowskiSq ![0, 1, 1, 0] = -2 := by
  sorry

end D4NullShell
