import Mathlib.Tactic

/-!
# P9 selected-sector trace-density scaffold

This module integrates Aristotle project
`28e0de6b-bf59-4e3e-ac0c-4c1a92669e3c`.

Scientific role: this is a finite algebraic guardrail for the P9
source-visibility program. If an observer-visible sector contains only `k`
Boolean-selected coordinate modes inside an `n`-cell finite readout, then the
coordinate trace of the selected-sector projector is `k` and the trace density
is `k / n`. A later geometry theorem can therefore turn a boundary-size bound
on selected modes into an explicit boundary-over-volume readout bound.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9SelectedSectorTraceDensity

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
  simp [selectedProjector, standardBasis, hi]

theorem selectedProjector_basis_diag_not_mem
    {n : Nat} (sel : Fin n -> Bool) (i : Fin n) (hi : sel i = false) :
    selectedProjector sel (standardBasis i) i = 0 := by
  simp [selectedProjector, hi]

/-- The selected-sector projector has coordinate trace equal to sector size. -/
theorem selectedProjector_trace_eq_count
    {n : Nat} (sel : Fin n -> Bool) :
    coordinateTrace (selectedProjector sel) = (selectedCount sel : Real) := by
  unfold coordinateTrace selectedCount
  rw [Nat.cast_sum]
  apply Finset.sum_congr rfl
  intro i _
  by_cases h : sel i = true
  case pos =>
    simp [selectedProjector_basis_diag_mem sel i h, h]
  case neg =>
    simp only [Bool.not_eq_true] at h
    simp [selectedProjector_basis_diag_not_mem sel i h, h]

/-- The selected-sector trace density is `selectedCount sel / n`. -/
theorem selectedProjector_trace_density_eq_count_div
    {n : Nat} [NeZero n] (sel : Fin n -> Bool) :
    coordinateTrace (selectedProjector sel) / (n : Real) =
      (selectedCount sel : Real) / (n : Real) := by
  rw [selectedProjector_trace_eq_count]

/--
If the visible selected sector is bounded by an external boundary count, its
trace density is bounded by boundary size divided by cell count.
-/
theorem selectedProjector_trace_density_le_boundary_div
    {n : Nat} [NeZero n] (sel : Fin n -> Bool) (boundary : Nat)
    (hcard : selectedCount sel <= boundary) :
    coordinateTrace (selectedProjector sel) / (n : Real) <=
      (boundary : Real) / (n : Real) := by
  rw [selectedProjector_trace_eq_count]
  have h : (selectedCount sel : Real) <= (boundary : Real) := Nat.cast_le.mpr hcard
  gcongr

end PhysicsSM.Draft.NullEdgeP9SelectedSectorTraceDensity

end
