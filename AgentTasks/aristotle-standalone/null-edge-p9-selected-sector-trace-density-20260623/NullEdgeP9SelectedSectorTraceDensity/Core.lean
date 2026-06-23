import Mathlib.Tactic

/-!
# P9 selected-sector trace-density scaffold

This focused file is a finite algebraic target for the P9 source-visibility
program. It formalizes the simplest subextensive readout: if an observer sees
only a selected set of `k` coordinate modes out of `n`, then the coordinate
trace of the corresponding projection is `k`, and the trace density is `k/n`.

Scientific role: this is not yet a causal-diamond theorem. It is the exact
finite algebra behind the P9 gate "area-like visible channel, volume-like cell
count" when a geometry-dependent construction later bounds the selected sector
by boundary size.
-/

noncomputable section

open scoped BigOperators

namespace NullEdgeP9SelectedSectorTraceDensity

abbrev Vec (n : Nat) := Fin n -> Real

/-- Coordinate basis vector. -/
def standardBasis {n : Nat} (i : Fin n) : Vec n :=
  fun j => if j = i then 1 else 0

/-- Naive coordinate trace of an endomorphism on `Fin n -> Real`. -/
def coordinateTrace {n : Nat} (T : Vec n -> Vec n) : Real :=
  Finset.univ.sum fun i : Fin n => T (standardBasis i) i

/-- Number of selected coordinate modes. -/
def selectedCount {n : Nat} (sel : Fin n -> Bool) : Nat :=
  Finset.univ.sum fun i => if sel i then 1 else 0

/-- Projection onto a selected coordinate sector. -/
def selectedProjector {n : Nat} (sel : Fin n -> Bool) (f : Vec n) : Vec n :=
  fun i => if sel i then f i else 0

theorem selectedProjector_basis_diag_mem
    {n : Nat} (sel : Fin n -> Bool) (i : Fin n) (hi : sel i = true) :
    selectedProjector sel (standardBasis i) i = 1 := by
  sorry

theorem selectedProjector_basis_diag_not_mem
    {n : Nat} (sel : Fin n -> Bool) (i : Fin n) (hi : sel i = false) :
    selectedProjector sel (standardBasis i) i = 0 := by
  sorry

/-- The selected-sector projector has coordinate trace equal to sector size. -/
theorem selectedProjector_trace_eq_count
    {n : Nat} (sel : Fin n -> Bool) :
    coordinateTrace (selectedProjector sel) = (selectedCount sel : Real) := by
  sorry

/-- The selected-sector trace density is `card S / n`. -/
theorem selectedProjector_trace_density_eq_count_div
    {n : Nat} [NeZero n] (sel : Fin n -> Bool) :
    coordinateTrace (selectedProjector sel) / (n : Real) =
      (selectedCount sel : Real) / (n : Real) := by
  sorry

/--
If the visible selected sector is bounded by an external boundary count, its
trace density is bounded by boundary size divided by cell count.
-/
theorem selectedProjector_trace_density_le_boundary_div
    {n : Nat} [NeZero n] (sel : Fin n -> Bool) (boundary : Nat)
    (hcard : selectedCount sel <= boundary) :
    coordinateTrace (selectedProjector sel) / (n : Real) <=
      (boundary : Real) / (n : Real) := by
  sorry

end NullEdgeP9SelectedSectorTraceDensity

end
