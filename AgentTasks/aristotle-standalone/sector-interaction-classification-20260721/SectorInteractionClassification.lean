import Mathlib

/-!
# Interaction preservation of a declared finite sector

This focused target isolates the algebraic condition needed by the null-edge
`3+1` physical-sector gate.  A diagonal projector records a declared selected
sector.  The goal is to prove that a finite interaction Hamiltonian commutes
with that projector exactly when every selected/complement matrix block
vanishes.  A two-state Pluecker pair-transfer block is retained as the
nondegenerate control: it preserves the declaration exactly when its complex
transfer coefficient is zero.

This is finite matrix algebra.  It does not choose the physical HNU sector,
prove positivity, locality, a continuum limit, or interaction stability for a
particular regulator.
-/

open Matrix
open scoped ComplexConjugate

noncomputable section

namespace SectorInteractionClassification

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Orthogonal coordinate projector onto the states satisfying `selected`. -/
def sectorProjector (selected : n -> Prop) [DecidablePred selected] :
    Matrix n n Complex :=
  Matrix.diagonal fun i => if selected i then 1 else 0

/-- Right multiplication by the sector projector keeps exactly the selected
columns. -/
theorem mul_sectorProjector_apply
    (H : Matrix n n Complex) (selected : n -> Prop) [DecidablePred selected]
    (i j : n) :
    (H * sectorProjector selected) i j =
      if selected j then H i j else 0 := by
  sorry

/-- Left multiplication by the sector projector keeps exactly the selected
rows. -/
theorem sectorProjector_mul_apply
    (H : Matrix n n Complex) (selected : n -> Prop) [DecidablePred selected]
    (i j : n) :
    (sectorProjector selected * H) i j =
      if selected i then H i j else 0 := by
  sorry

/-- Complete finite classification: an interaction commutes with a declared
coordinate-sector projector iff it has no matrix element crossing the
selected/complement boundary in either direction. -/
theorem commutes_sectorProjector_iff
    (H : Matrix n n Complex) (selected : n -> Prop) [DecidablePred selected] :
    H * sectorProjector selected = sectorProjector selected * H <->
      forall i j, (selected i <-> selected j) \/ H i j = 0 := by
  sorry

/-- Once the Hamiltonian is block diagonal, its exact time exponential is
block diagonal as well. -/
theorem exponential_commutes_sectorProjector
    (H : Matrix n n Complex) (selected : n -> Prop) [DecidablePred selected]
    (hH : H * sectorProjector selected = sectorProjector selected * H)
    (t : Real) :
    NormedSpace.exp ((-(t : Complex) * Complex.I) • H) *
        sectorProjector selected =
      sectorProjector selected *
        NormedSpace.exp ((-(t : Complex) * Complex.I) • H) := by
  sorry

abbrev Pair := Fin 2

/-- The selected pair is coordinate zero. -/
def pairSelected (i : Pair) : Prop := i = 0

instance : DecidablePred pairSelected := fun i =>
  if h : i = 0 then isTrue h else isFalse h

/-- Hermitian pair-transfer Hamiltonian. -/
def pairHamiltonian (z : Complex) : Matrix Pair Pair Complex :=
  !![0, star z; z, 0]

/-- A nonzero pair-transfer coefficient necessarily mixes the declared pair
with its complement. -/
theorem pairHamiltonian_commutes_iff (z : Complex) :
    pairHamiltonian z * sectorProjector pairSelected =
        sectorProjector pairSelected * pairHamiltonian z <->
      z = 0 := by
  sorry

/-- Mandatory nondegenerate fixture: the `3+4i` pair interaction fails the
sector-preservation condition. -/
theorem witness_pair_interaction_mixes :
    pairHamiltonian (3 + 4 * Complex.I) * sectorProjector pairSelected !=
      sectorProjector pairSelected * pairHamiltonian (3 + 4 * Complex.I) := by
  sorry

end SectorInteractionClassification

end
