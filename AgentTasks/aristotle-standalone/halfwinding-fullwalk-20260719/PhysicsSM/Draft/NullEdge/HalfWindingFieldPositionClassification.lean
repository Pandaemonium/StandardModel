import PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
import PhysicsSM.Draft.NullEdge.PlueckerWindingDerived

/-!
# Four-site winding data do not classify the compression signature

This module exhaustively classifies the 16 nowhere-zero real sign fields on the
four-cycle for the fixed-leg compression used by `ModeInvariantHalfWinding`.
It gives a decisive negative Paper C bridge result:

* two explicit fields have the same derived principal-argument winding `2*pi`;
* the first compression is a nontrivial self-adjoint involution and the second
  is not self-adjoint;
* the second compressed sector has neither a `+1` nor a `-1` mode;
* over the complete family, self-adjointness is equivalent to two walls plus
  the independent positional condition that no reflection-fixed site is a sign
  singleton.

Therefore winding or wall count alone does not determine the compression
signature. The repaired finite bridge carries the wall-position compatibility
as an explicit field-level hypothesis. This is an exhaustive four-site finite
classification, not a general-length, perturbative, topological, or stability
theorem. Most family-wide matrix decisions use documented compiled evaluation;
the two displayed winding equalities are kernel-only at the standard footprint.

Provenance: theorem design and first proof artifact from Aristotle project
`32a89f02-49f4-4198-bc22-93f1316f9aae`; integrated against the live project
definitions and rebuilt under Lean 4.28.0.
-/

noncomputable section

open Matrix
open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification

open ModeInvariantHalfWinding

/-- The 16 nowhere-zero rational sign fields on the four-cycle. -/
def signField (n : Fin 16) : Fin 4 → ℚ := fun i =>
  if n.val.testBit i.val then 3 / 5 else -3 / 5

/-- Number of adjacent sign changes. -/
def wallCount (n : Fin 16) : Nat :=
  (List.finRange 4).countP
    (fun i => n.val.testBit i.val ≠ n.val.testBit ((i.val + 1) % 4))

/-- Whether reflection-fixed site 1 or 3 is isolated between two opposite
neighbours. This positional datum is invisible to the winding integer. -/
def fixedSingleton (n : Fin 16) : Bool :=
  ((n.val.testBit 1 ≠ n.val.testBit 0) &&
      (n.val.testBit 1 ≠ n.val.testBit 2)) ||
    ((n.val.testBit 3 ≠ n.val.testBit 2) &&
      (n.val.testBit 3 ≠ n.val.testBit 0))

/-- The complex field supplied to the live derived-winding map. -/
def fieldC (n : Fin 16) : ZMod 4 → ℂ := fun p =>
  ((signField n p : ℝ) : ℂ)

/-- The walk generated from the sign field. -/
def Wof (n : Fin 16) : Matrix V8 V8 ℚ := walkQ cW (signField n)

/-- Compression onto the reflection-fixed legs. -/
def Mof (n : Fin 16) : Matrix (Fin 4) (Fin 4) ℚ :=
  Bfixᵀ * Wof n * Bfix

/-- The displayed two-wall field has derived total turning `2*pi`. -/
theorem totalTurning_witness :
    PlueckerWindingDerived.totalTurning (fieldC 11) = 2 * Real.pi := by
  unfold PlueckerWindingDerived.totalTurning
  ring
  unfold PlueckerWindingDerived.linkIncrement fieldC
  erw [Fin.sum_univ_four]
  norm_num [Fin.add_def, signField]
  ring
  norm_num [Nat.testBit, Complex.arg]
  ring
  norm_num [Nat.shiftRight_eq_div_pow]
  ring

/-- The counterexample has the same derived total turning `2*pi`. -/
theorem totalTurning_counterexample :
    PlueckerWindingDerived.totalTurning (fieldC 2) = 2 * Real.pi := by
  unfold PlueckerWindingDerived.totalTurning
    PlueckerWindingDerived.linkIncrement fieldC
  erw [Fin.sum_univ_four]
  norm_num [Fin.add_def]
  unfold signField
  norm_num [Nat.testBit]
  ring
  norm_num [Complex.arg]
  norm_num [Nat.shiftRight_eq_div_pow]
  ring

theorem winding_witness_eq_counterexample :
    PlueckerWindingDerived.totalTurning (fieldC 11) =
      PlueckerWindingDerived.totalTurning (fieldC 2) := by
  rw [totalTurning_witness, totalTurning_counterexample]

/-- Complete finite decision: the compression is self-adjoint exactly for
two-wall fields with no isolated reflection-fixed site. -/
theorem discriminant_bool : ∀ n : Fin 16,
    decide (Mof n = (Mof n)ᵀ) =
      decide (wallCount n = 2 ∧ fixedSingleton n = false) := by
  native_decide

theorem discriminant (n : Fin 16) :
    (Mof n = (Mof n)ᵀ) ↔
      (wallCount n = 2 ∧ fixedSingleton n = false) :=
  decide_eq_decide.mp (discriminant_bool n)

/-- On this finite family, compression self-adjointness is equivalent to the
involution equation. -/
theorem selfadj_iff_involution_bool : ∀ n : Fin 16,
    decide (Mof n = (Mof n)ᵀ) = decide (Mof n * Mof n = 1) := by
  native_decide

theorem selfadj_iff_involution (n : Fin 16) :
    (Mof n = (Mof n)ᵀ) ↔ (Mof n * Mof n = 1) :=
  decide_eq_decide.mp (selfadj_iff_involution_bool n)

/-- Strongest true universal four-site bridge: a nontrivial involution occurs
exactly for two walls with the visible positional compatibility condition. -/
theorem corrected_bridge_bool : ∀ n : Fin 16,
    decide (Mof n * Mof n = 1 ∧ Mof n ≠ 1 ∧ Mof n ≠ -1) =
      decide (wallCount n = 2 ∧ fixedSingleton n = false) := by
  native_decide

theorem corrected_bridge (n : Fin 16) :
    (Mof n * Mof n = 1 ∧ Mof n ≠ 1 ∧ Mof n ≠ -1) ↔
      (wallCount n = 2 ∧ fixedSingleton n = false) :=
  decide_eq_decide.mp (corrected_bridge_bool n)

theorem witness_selfadjoint : Mof 11 = (Mof 11)ᵀ := by
  native_decide

theorem counterexample_not_selfadjoint : Mof 2 ≠ (Mof 2)ᵀ := by
  native_decide

/-- The counterexample has no `-1` mode in the compressed sector. -/
theorem counterexample_sector_no_neg : (Mof 2 + 1).det ≠ 0 := by
  native_decide

/-- The counterexample has no `+1` mode in the compressed sector. -/
theorem counterexample_sector_no_pos : (Mof 2 - 1).det ≠ 0 := by
  native_decide

/-- Exact refutation of the naive winding/wall-count-only bridge. -/
theorem naive_bridge_false :
    ¬ (∀ n : Fin 16, wallCount n = 2 → Mof n = (Mof n)ᵀ) := by
  intro H
  exact absurd (H 2 (by decide)) (by native_decide)

/-- Same wall count and same derived winding, but different compression
signature. -/
theorem winding_blind_to_signature :
    wallCount 11 = wallCount 2
      ∧ Mof 11 = (Mof 11)ᵀ
      ∧ Mof 2 ≠ (Mof 2)ᵀ :=
  ⟨by decide, witness_selfadjoint, counterexample_not_selfadjoint⟩

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification.winding_witness_eq_counterexample' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms winding_witness_eq_counterexample

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification.corrected_bridge' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms corrected_bridge

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification.naive_bridge_false' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms naive_bridge_false

/-- info: 'PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification.winding_blind_to_signature' depends on axioms: [propext, Classical.choice, Lean.ofReduceBool, Lean.trustCompiler, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms winding_blind_to_signature

end PhysicsSM.Draft.NullEdge.HalfWindingFieldPositionClassification
