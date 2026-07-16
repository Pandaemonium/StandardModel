import Mathlib

/-!
# Schedule-indexed transport telescope

This module isolates the noncommutative algebra missing from constant-frame
holonomy results. A path stores the next frame and a bare operator written in
the current frame. Dressing a step as `gNext * s * gCurrent^-1` telescopes to
the final frame, the ordered bare product, and the inverse initial frame.

This is a theorem about passive schedule-local frame covariance. It does not by
itself construct an active link cocycle, change a physical transport invariant,
remove a Weyl partner, or prove a bulk-boundary correspondence. The explicit
noncommutative witness only certifies that varying endpoints and product order
are load-bearing in the algebraic statement.

Provenance: Aristotle task `11c39c15-83b4-4c03-87eb-25dafbc6b2b9`, adapted
to the project namespace after direct Lean replay. The witness uses
`SL(2, Z/5Z)` and kernel-reduced finite equalities.
-/

namespace PhysicsSM.Draft.NullEdge.ScheduleIndexedTransportCore

variable {G : Type*} [Group G]

/-- Ordered bare product, with later path entries acting on the left. -/
def bareProduct : List (G × G) -> G
  | [] => 1
  | (_, s) :: rest => bareProduct rest * s

/-- Final frame of the path, or the initial frame for an empty path. -/
def endFrame (g0 : G) : List (G × G) -> G
  | [] => g0
  | (g1, _) :: rest => endFrame g1 rest

/-- Ordered product of dressed steps `g_(j+1) * s_j * g_j^-1`. -/
def dressedProduct (g0 : G) : List (G × G) -> G
  | [] => 1
  | (g1, s) :: rest => dressedProduct g1 rest * (g1 * s * g0⁻¹)

/-- Exact varying-frame telescope, including both endpoint factors. -/
theorem dressedProduct_telescope (g0 : G) (path : List (G × G)) :
    dressedProduct g0 path = endFrame g0 path * bareProduct path * g0⁻¹ := by
  induction path generalizing g0 with
  | nil => simp [dressedProduct, endFrame, bareProduct]
  | cons p ps ih =>
      obtain ⟨g1, s⟩ := p
      simp only [dressedProduct, endFrame, bareProduct, ih g1]
      group

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

/-! ## Explicit nonidentity varying-frame witness -/

section Witness

open Matrix

/-- Concrete noncommutative matrix group used by the witness. -/
abbrev SL2 := Matrix.SpecialLinearGroup (Fin 2) (ZMod 5)

/-- First explicit nonidentity generator. -/
def wa : SL2 := ⟨!![1, 1; 0, 1], by decide⟩

/-- Second explicit nonidentity generator. -/
def wb : SL2 := ⟨!![1, 0; 1, 1], by decide⟩

/-- Third frame, distinct from the initial frame. -/
def wc : SL2 := wa * wb

theorem wa_ne_one : wa ≠ 1 := by
  intro h
  have hv := congrArg Subtype.val h
  revert hv
  decide

theorem wb_ne_one : wb ≠ 1 := by
  intro h
  have hv := congrArg Subtype.val h
  revert hv
  decide

/-- The generators do not commute, so bare-operator order is meaningful. -/
theorem wa_wb_noncomm : wa * wb ≠ wb * wa := by
  intro h
  have hv := congrArg Subtype.val h
  revert hv
  decide

/-- A noncyclic path with frames `wb`, then `wc`, and bare operators `wa`,
then `wb`. -/
def witnessPath : List (SL2 × SL2) := [(wb, wa), (wc, wb)]

/-- The final frame differs from the initial frame. -/
theorem witness_endFrame_ne : endFrame wa witnessPath ≠ wa := by
  have h : endFrame wa witnessPath = wc := by
    simp [endFrame, witnessPath]
  rw [h]
  intro hce
  have hmul : wa * wb = wa := hce
  have hb : wb = 1 := by
    have hc := congrArg (fun g => wa⁻¹ * g) hmul
    simpa [wc, mul_assoc] using hc
  exact wb_ne_one hb

/-- The varying-frame telescope evaluates explicitly on the witness path. -/
theorem witness_telescope :
    dressedProduct wa witnessPath = wc * wb := by
  rw [dressedProduct_telescope]
  have hend : endFrame wa witnessPath = wc := by
    simp [endFrame, witnessPath]
  have hbare : bareProduct witnessPath = wb * wa := by
    simp [bareProduct, witnessPath]
  rw [hend, hbare]
  group

/-- Both endpoint factors are load-bearing: the witness is not the naive
constant-frame conjugation by its initial frame. -/
theorem witness_not_conjugation :
    dressedProduct wa witnessPath ≠ wa * bareProduct witnessPath * wa⁻¹ := by
  have hbare : bareProduct witnessPath = wb * wa := by
    simp [bareProduct, witnessPath]
  rw [witness_telescope, hbare]
  intro h
  apply wb_ne_one
  have h2 : wa * wb * wb = wa * wb := by
    have hc : wc = wa * wb := rfl
    calc
      wa * wb * wb = wc * wb := by rw [hc]
      _ = wa * (wb * wa) * wa⁻¹ := h
      _ = wa * wb := by group
  have hc := congrArg (fun g => (wa * wb)⁻¹ * g) h2
  simpa [mul_assoc] using hc

end Witness

end PhysicsSM.Draft.NullEdge.ScheduleIndexedTransportCore

/-! ## Build-enforced assumption-footprint guards -/

open PhysicsSM.Draft.NullEdge.ScheduleIndexedTransportCore in
/-- info: 'PhysicsSM.Draft.NullEdge.ScheduleIndexedTransportCore.dressedProduct_telescope' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in #print axioms dressedProduct_telescope

open PhysicsSM.Draft.NullEdge.ScheduleIndexedTransportCore in
/-- info: 'PhysicsSM.Draft.NullEdge.ScheduleIndexedTransportCore.dressedProduct_cycle_of_commutes' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in #print axioms dressedProduct_cycle_of_commutes

open PhysicsSM.Draft.NullEdge.ScheduleIndexedTransportCore in
/-- info: 'PhysicsSM.Draft.NullEdge.ScheduleIndexedTransportCore.witness_not_conjugation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms witness_not_conjugation
