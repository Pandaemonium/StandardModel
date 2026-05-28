import CodeLatticeE8.Octonion.CayleyDickson

/-!
# Coordinate octonion multiplication

This module defines the finite coordinate multiplication associated to the
Cayley-Dickson convention fixed in `CodeLatticeE8.Octonion.CayleyDickson`.

The package deliberately uses coordinate functions rather than an eight-field
structure.  This keeps the multiplication compact and makes the later E8 bridge
read as a finite signed XOR convolution.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.Octonion

/-! ## Coordinates and elementary operations -/

/-- Coordinate vectors in the fixed octonion basis. -/
abbrev Coords (R : Type _) := Fin 8 → R

/-- Integer basis coordinate vector. -/
def basisInt (i : Fin 8) : Coords ℤ :=
  fun k => if k = i then 1 else 0

/-- Integer conjugation in coordinates: the scalar coordinate is fixed and all
seven imaginary coordinates change sign. -/
def conjInt (x : Coords ℤ) : Coords ℤ :=
  fun i => if i = 0 then x i else -x i

/-- Integer squared norm of a coordinate vector. -/
def normSqInt (x : Coords ℤ) : ℤ :=
  ∑ i : Fin 8, x i ^ 2

/-- Integer dot product of coordinate vectors. -/
def dotInt (x y : Coords ℤ) : ℤ :=
  ∑ i : Fin 8, x i * y i

theorem dotInt_self (x : Coords ℤ) : dotInt x x = normSqInt x := by
  simp [dotInt, normSqInt, sq]

theorem normSqInt_nonneg (x : Coords ℤ) : 0 ≤ normSqInt x :=
  Finset.sum_nonneg fun _ _ => sq_nonneg _

/-! ## Cayley-Dickson product -/

/-- Integer-coordinate Cayley-Dickson product.

If `x` and `y` are the integer coefficient vectors of two octonions, then
`mulInt x y` is the integer coefficient vector of their product.  The formula
is the component expansion of the signed XOR table in
`CayleyDickson.sign`. -/
def mulInt (x y : Coords ℤ) : Coords ℤ :=
  ![
    x 0 * y 0 - x 1 * y 1 - x 2 * y 2 - x 3 * y 3 -
      x 4 * y 4 - x 5 * y 5 - x 6 * y 6 - x 7 * y 7,
    x 0 * y 1 + x 1 * y 0 + x 2 * y 3 - x 3 * y 2 +
      x 4 * y 5 - x 5 * y 4 - x 6 * y 7 + x 7 * y 6,
    x 0 * y 2 - x 1 * y 3 + x 2 * y 0 + x 3 * y 1 +
      x 4 * y 6 + x 5 * y 7 - x 6 * y 4 - x 7 * y 5,
    x 0 * y 3 + x 1 * y 2 - x 2 * y 1 + x 3 * y 0 +
      x 4 * y 7 - x 5 * y 6 + x 6 * y 5 - x 7 * y 4,
    x 0 * y 4 - x 1 * y 5 - x 2 * y 6 - x 3 * y 7 +
      x 4 * y 0 + x 5 * y 1 + x 6 * y 2 + x 7 * y 3,
    x 0 * y 5 + x 1 * y 4 - x 2 * y 7 + x 3 * y 6 -
      x 4 * y 1 + x 5 * y 0 - x 6 * y 3 + x 7 * y 2,
    x 0 * y 6 + x 1 * y 7 + x 2 * y 4 - x 3 * y 5 -
      x 4 * y 2 + x 5 * y 3 + x 6 * y 0 - x 7 * y 1,
    x 0 * y 7 - x 1 * y 6 + x 2 * y 5 + x 3 * y 4 -
      x 4 * y 3 - x 5 * y 2 + x 6 * y 1 + x 7 * y 0
  ]

@[simp]
theorem mulInt_zero_left (x : Coords ℤ) :
    mulInt 0 x = 0 := by
  ext k
  fin_cases k <;> simp [mulInt]

@[simp]
theorem mulInt_zero_right (x : Coords ℤ) :
    mulInt x 0 = 0 := by
  ext k
  fin_cases k <;> simp [mulInt]

/-- The Cayley-Dickson coordinate product is multiplicative for the squared
norm.  The proof is an explicit polynomial identity in the eight coordinates
of each factor. -/
theorem normSqInt_mulInt (x y : Coords ℤ) :
    normSqInt (mulInt x y) = normSqInt x * normSqInt y := by
  rw [normSqInt, normSqInt, normSqInt]
  repeat rw [Fin.sum_univ_eight]
  simp [mulInt]
  ring_nf

@[simp]
theorem conjInt_zero : conjInt 0 = 0 := by
  ext i
  simp [conjInt]

end CodeLatticeE8.Octonion
