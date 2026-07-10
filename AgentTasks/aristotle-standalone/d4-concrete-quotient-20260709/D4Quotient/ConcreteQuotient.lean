import Mathlib

open scoped BigOperators

namespace D4ConcreteQuotient

abbrev Coord := Fin 4 → ℤ
abbrev Label := Fin 3 → ZMod 2

/-- Coordinates in the standard simple-root basis of the `D4` lattice. -/
def d4Embed : Coord →+ Coord where
  toFun c := ![c 0, -c 0 + c 1, -c 1 + c 2 + c 3, -c 2 + c 3]
  map_zero' := by ext i; fin_cases i <;> simp
  map_add' := by
    intro a b
    ext i
    fin_cases i <;> simp <;> ring

/-- The Hadamard tetrahedral sublattice in `D4` simple-root coordinates.
Its matrix has Smith normal form `diag(1,2,2,2)` and determinant `-8`. -/
def lhCoord : Coord →+ Coord where
  toFun a :=
    ![a 0 + a 1 + a 2 + a 3,
      2 * a 0 + 2 * a 1,
      a 0 + a 1 + a 2 - a 3,
      2 * a 0]
  map_zero' := by ext i; fin_cases i <;> simp
  map_add' := by
    intro a b
    ext i
    fin_cases i <;> simp <;> ring

/-- Three parity labels complementary to the mod-two Hadamard image. -/
def quotientLabel : Coord →+ Label where
  toFun c := ![(c 1 : ZMod 2), (c 3 : ZMod 2), (c 0 + c 2 : ZMod 2)]
  map_zero' := by ext i; fin_cases i <;> simp
  map_add' := by
    intro a b
    ext i
    fin_cases i <;> simp <;> ring

/-- Physical Hadamard combination of the four future-null body diagonals. -/
def hadamardPhysical : Coord →+ Coord where
  toFun a :=
    ![a 0 + a 1 + a 2 + a 3,
      a 0 + a 1 - a 2 - a 3,
      a 0 - a 1 + a 2 - a 3,
      a 0 - a 1 - a 2 + a 3]
  map_zero' := by ext i; fin_cases i <;> simp
  map_add' := by
    intro a b
    ext i
    fin_cases i <;> simp <;> ring

/-- The simple-root embedding sends `lhCoord` to the Hadamard lattice. -/
theorem d4Embed_lhCoord (a : Coord) :
    d4Embed (lhCoord a) = hadamardPhysical a := by
  sorry

/-- The simple-root coordinate embedding is injective. -/
theorem d4Embed_injective : Function.Injective d4Embed := by
  sorry

/-- Its image is exactly the conventional even-coordinate-sum `D4` lattice. -/
theorem d4Embed_range_iff_even_sum (x : Coord) :
    x ∈ Set.range d4Embed ↔ Even (∑ i, x i) := by
  sorry

/-- The Hadamard coordinate map is injective. -/
theorem lhCoord_injective : Function.Injective lhCoord := by
  sorry

/-- Every Hadamard-lattice point has trivial quotient label. -/
theorem quotientLabel_lhCoord_zero (a : Coord) :
    quotientLabel (lhCoord a) = 0 := by
  sorry

/-- The three parity labels are all realized. -/
theorem quotientLabel_surjective : Function.Surjective quotientLabel := by
  sorry

/-- The kernel of the parity label is exactly the Hadamard image. -/
theorem quotientLabel_eq_zero_iff (c : Coord) :
    quotientLabel c = 0 ↔ ∃ a : Coord, lhCoord a = c := by
  sorry

/-- The Hadamard sublattice as an additive subgroup of `D4` coordinates. -/
def LH : AddSubgroup Coord := quotientLabel.ker

/-- The image of the explicit Hadamard matrix equals `LH`. -/
theorem lhCoord_range_eq_LH : AddSubgroup.map lhCoord ⊤ = LH := by
  sorry

/-- Concrete quotient theorem: `D4 / L_H` is `(Z/2)^3`. -/
noncomputable def d4QuotientEquiv : (Coord ⧸ LH) ≃+ Label := by
  sorry

/-- The concrete quotient has exactly eight elements. -/
theorem d4Quotient_card_eight : Nat.card (Coord ⧸ LH) = 8 := by
  sorry

/-- Compact verdict exposing the physical embedding and concrete quotient. -/
theorem d4_concrete_quotient_verdict :
    Function.Injective d4Embed
      ∧ (∀ x : Coord, x ∈ Set.range d4Embed ↔ Even (∑ i, x i))
      ∧ Function.Injective lhCoord
      ∧ AddSubgroup.map lhCoord ⊤ = LH
      ∧ Nat.card (Coord ⧸ LH) = 8 := by
  sorry

end D4ConcreteQuotient
