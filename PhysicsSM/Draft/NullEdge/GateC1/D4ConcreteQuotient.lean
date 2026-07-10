import Mathlib

/-!
# The concrete D4/Hadamard quotient

This module closes the finite-lattice input left conditional by
`D4DisconnectedCopy`.  In standard `D4` simple-root coordinates it constructs
the Hadamard tetrahedral sublattice, an explicit three-bit parity label, and
proves that the label's kernel is exactly the Hadamard image.  The first
isomorphism theorem then gives

```text
D4 / L_H ~= (Z/2Z)^3,
```

so the quotient has exactly eight elements.

The physical-coordinate embedding is included explicitly: its image is the
conventional integer lattice with even coordinate sum, and it sends the
Hadamard coordinate map to the four body-diagonal combinations.

Provenance: Aristotle project `9c0020be-4a4d-4b26-bf07-1acb2a07b4e2`,
reviewed and checked under the pinned Lean 4.28.0 toolchain.  This is a finite
lattice theorem; it does not assert that all D4 roots are causal null steps.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GateC1.D4ConcreteQuotient

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

/-- The Hadamard tetrahedral sublattice in `D4` simple-root coordinates. -/
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
  ext i
  fin_cases i <;> simp [d4Embed, lhCoord, hadamardPhysical] <;> ring

/-- The simple-root coordinate embedding is injective. -/
theorem d4Embed_injective : Function.Injective d4Embed := by
  rw [injective_iff_map_eq_zero]
  intro c hc
  have h0 := congrFun hc 0
  have h1 := congrFun hc 1
  have h2 := congrFun hc 2
  have h3 := congrFun hc 3
  simp [d4Embed] at h0 h1 h2 h3
  ext i
  fin_cases i <;> simp <;> omega

/-- The embedding image is the conventional even-coordinate-sum `D4` lattice. -/
theorem d4Embed_range_iff_even_sum (x : Coord) :
    x ∈ Set.range d4Embed ↔ Even (∑ i, x i) := by
  constructor
  · rintro ⟨c, rfl⟩
    rw [Fin.sum_univ_four]
    refine ⟨c 3, ?_⟩
    simp [d4Embed]
    ring
  · intro h
    obtain ⟨k, hk⟩ := h
    rw [Fin.sum_univ_four] at hk
    refine ⟨![x 0, x 0 + x 1, k - x 3, k], ?_⟩
    ext i
    fin_cases i <;> simp [d4Embed] <;> omega

/-- The Hadamard coordinate map is injective. -/
theorem lhCoord_injective : Function.Injective lhCoord := by
  rw [injective_iff_map_eq_zero]
  intro c hc
  have h0 := congrFun hc 0
  have h1 := congrFun hc 1
  have h2 := congrFun hc 2
  have h3 := congrFun hc 3
  simp [lhCoord] at h0 h1 h2 h3
  ext i
  fin_cases i <;> simp <;> omega

/-- Every Hadamard-lattice point has trivial quotient label. -/
theorem quotientLabel_lhCoord_zero (a : Coord) :
    quotientLabel (lhCoord a) = 0 := by
  ext i
  fin_cases i <;> simp only [quotientLabel, lhCoord, AddMonoidHom.coe_mk,
    ZeroHom.coe_mk, Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val, Pi.zero_apply]
  · rw [ZMod.intCast_zmod_eq_zero_iff_dvd]
    exact ⟨a 0 + a 1, by push_cast; ring⟩
  · rw [ZMod.intCast_zmod_eq_zero_iff_dvd]
    exact ⟨a 0, by push_cast; ring⟩
  · rw [← Int.cast_add, ZMod.intCast_zmod_eq_zero_iff_dvd]
    exact ⟨a 0 + a 1 + a 2, by ring⟩

/-- The three parity labels are all realized. -/
theorem quotientLabel_surjective : Function.Surjective quotientLabel := by
  intro l
  refine ⟨![((l 2).val : ℤ), ((l 0).val : ℤ), 0, ((l 1).val : ℤ)], ?_⟩
  ext i
  fin_cases i <;> simp [quotientLabel]

/-- The parity-label kernel is exactly the Hadamard image. -/
theorem quotientLabel_eq_zero_iff (c : Coord) :
    quotientLabel c = 0 ↔ ∃ a : Coord, lhCoord a = c := by
  constructor
  · intro h
    have h1 := congrFun h 0
    have h2 := congrFun h 1
    have h3 := congrFun h 2
    simp only [quotientLabel, AddMonoidHom.coe_mk, ZeroHom.coe_mk,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val, Pi.zero_apply]
      at h1 h2 h3
    rw [ZMod.intCast_zmod_eq_zero_iff_dvd] at h1 h2
    rw [← Int.cast_add, ZMod.intCast_zmod_eq_zero_iff_dvd] at h3
    obtain ⟨m1, hm1⟩ := h1
    obtain ⟨m3, hm3⟩ := h2
    obtain ⟨s, hs⟩ := h3
    refine ⟨![m3, m1 - m3, s - m1, s - c 2], ?_⟩
    ext i
    fin_cases i <;> simp [lhCoord] <;> push_cast at hm1 hm3 hs ⊢ <;> omega
  · rintro ⟨a, rfl⟩
    exact quotientLabel_lhCoord_zero a

/-- The Hadamard sublattice as an additive subgroup of `D4` coordinates. -/
def LH : AddSubgroup Coord := quotientLabel.ker

/-- The explicit Hadamard matrix image equals `LH`. -/
theorem lhCoord_range_eq_LH : AddSubgroup.map lhCoord ⊤ = LH := by
  ext c
  simp only [AddSubgroup.mem_map, AddSubgroup.mem_top, true_and, LH,
    AddMonoidHom.mem_ker]
  rw [quotientLabel_eq_zero_iff]

/-- Concrete quotient equivalence `D4 / L_H ~= (Z/2)^3`. -/
noncomputable def d4QuotientEquiv : (Coord ⧸ LH) ≃+ Label :=
  QuotientAddGroup.quotientKerEquivOfSurjective quotientLabel
    quotientLabel_surjective

/-- The concrete quotient has exactly eight elements. -/
theorem d4Quotient_card_eight : Nat.card (Coord ⧸ LH) = 8 := by
  rw [Nat.card_congr d4QuotientEquiv.toEquiv, Nat.card_eq_fintype_card]
  decide

/-- Compact verdict exposing the physical embedding and concrete quotient. -/
theorem d4_concrete_quotient_verdict :
    Function.Injective d4Embed
      ∧ (∀ x : Coord, x ∈ Set.range d4Embed ↔ Even (∑ i, x i))
      ∧ Function.Injective lhCoord
      ∧ AddSubgroup.map lhCoord ⊤ = LH
      ∧ Nat.card (Coord ⧸ LH) = 8 :=
  ⟨d4Embed_injective, d4Embed_range_iff_even_sum, lhCoord_injective,
    lhCoord_range_eq_LH, d4Quotient_card_eight⟩

end PhysicsSM.Draft.NullEdge.GateC1.D4ConcreteQuotient

/-! ## Build-enforced axiom-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateC1.D4ConcreteQuotient.d4Quotient_card_eight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateC1.D4ConcreteQuotient.d4Quotient_card_eight

/-- info: 'PhysicsSM.Draft.NullEdge.GateC1.D4ConcreteQuotient.d4_concrete_quotient_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateC1.D4ConcreteQuotient.d4_concrete_quotient_verdict
