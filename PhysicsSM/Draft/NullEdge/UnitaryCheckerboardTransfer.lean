import PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower
import PhysicsSM.Draft.NullEdge.UnitaryHistoryComposition

/-!
# Exact unitary checkerboard transfer

The checkerboard transfer becomes two-sided unitary when its straight and turn
coefficients lie on the real unit circle, the turn carries the checkerboard
phase `i`, and the two outgoing phases have unit norm. The same matrix is the
landed path-sum transfer with `mu = i*s/c` and outgoing phases `c*u` whenever
`c` is nonzero. The landed replicated-history theorem then makes every finite
uniform history unitary.

The coefficients and outgoing phases remain supplied. This module does not
derive their values, calibrate `s/c` to an observed mass, or prove a continuum
limit.

Provenance: normalization target selected by Aristotle audits `31c1ac53` and
`629a7aba`; proof completed by Aristotle project
`2df7fa8b-86d2-41bf-95c1-f35dede4807c` and ported to the live checkerboard and
history APIs on 2026-07-10.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.UnitaryCheckerboardTransfer

open PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower
open PhysicsSM.Draft.NullEdge.UnitaryHistoryComposition
open Direction

abbrev Mat2 := Matrix Direction Direction ℂ

/-- Physical normalization of the checkerboard transfer: `c` on straight
steps, `i*s` on turns, and a unit outgoing phase on each row. -/
def physicalTransfer (c s : ℝ) (uL uR : ℂ) : Mat2 :=
  fun finish start => match finish, start with
    | left, left => (c : ℂ) * uL
    | left, right => I * (s : ℂ) * uL
    | right, left => I * (s : ℂ) * uR
    | right, right => (c : ℂ) * uR

def outgoingPhase (uL uR : ℂ) : Mat2 :=
  fun finish start =>
    if finish = start then
      match finish with
      | left => uL
      | right => uR
    else 0

def turnCoin (c s : ℝ) : Mat2 :=
  fun finish start =>
    if finish = start then (c : ℂ) else I * (s : ℂ)

theorem physicalTransfer_factor (c s : ℝ) (uL uR : ℂ) :
    physicalTransfer c s uL uR =
      outgoingPhase uL uR * turnCoin c s := by
  have huniv : (Finset.univ : Finset Direction) = {left, right} := by
    decide
  ext finish start
  fin_cases finish <;> fin_cases start <;>
    simp [physicalTransfer, outgoingPhase, turnCoin,
      Matrix.mul_apply, huniv, mul_comm]

theorem outgoingPhase_unitary (uL uR : ℂ)
    (hL : Complex.normSq uL = 1) (hR : Complex.normSq uR = 1) :
    IsUnitary (outgoingPhase uL uR) := by
  have huniv : (Finset.univ : Finset Direction) = {left, right} := by
    decide
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, huniv, outgoingPhase,
      Complex.ext_iff, Complex.normSq_apply] at hL hR ⊢ <;>
    constructor <;> nlinarith

theorem turnCoin_unitary (c s : ℝ) (hcs : c ^ 2 + s ^ 2 = 1) :
    IsUnitary (turnCoin c s) := by
  have huniv : (Finset.univ : Finset Direction) = {left, right} := by
    decide
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, huniv, turnCoin, Complex.ext_iff] <;>
    ring_nf at hcs ⊢ <;> nlinarith

/-- Imaginary turn amplitude plus unit-modulus outgoing phases gives exact
two-sided unitarity on the normalized circle. -/
theorem physicalTransfer_unitary (c s : ℝ) (uL uR : ℂ)
    (hcs : c ^ 2 + s ^ 2 = 1)
    (hL : Complex.normSq uL = 1) (hR : Complex.normSq uR = 1) :
    IsUnitary (physicalTransfer c s uL uR) := by
  rw [physicalTransfer_factor]
  exact isUnitary_mul (outgoingPhase_unitary uL uR hL hR)
    (turnCoin_unitary c s hcs)

/-- The physical matrix is exactly the landed checkerboard transfer with
`mu=i*s/c` and outgoing phase `c*u`, when `c` is nonzero. -/
theorem physicalTransfer_eq_transfer (c s : ℝ) (uL uR : ℂ)
    (hc : c ≠ 0) :
    physicalTransfer c s uL uR =
      transfer (I * (s : ℂ) / (c : ℂ))
        (fun d => match d with
          | left => (c : ℂ) * uL
          | right => (c : ℂ) * uR) := by
  ext d1 d2
  rcases d1 with (_ | _) <;> rcases d2 with (_ | _) <;>
    simp +decide [transfer, turnWeight, physicalTransfer, hc,
      div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm]

/-- Repeating the physical transfer gives unitary finite-history evolution. -/
theorem physical_transfer_history_unitary (c s : ℝ) (uL uR : ℂ)
    (hcs : c ^ 2 + s ^ 2 = 1)
    (hL : Complex.normSq uL = 1) (hR : Complex.normSq uR = 1)
    (n : ℕ) :
    IsUnitary (HistoryOperatorMonoidalDagger.historyOperator
      (List.replicate n (physicalTransfer c s uL uR))) := by
  exact replicated_history_operator_unitary _ n
    (physicalTransfer_unitary c s uL uR hcs hL hR)

noncomputable def wrongRealTurnTransfer : Mat2 :=
  fun finish start => match finish, start with
    | left, left | right, right => ((3 / 5 : ℝ) : ℂ)
    | left, right | right, left => ((4 / 5 : ℝ) : ℂ)

/-- A nontrivial rational massive unitary and a real-turn nonunitary control. -/
theorem rational_massive_transfer_controls :
    IsUnitary (physicalTransfer (3 / 5) (4 / 5) 1 I) ∧
      physicalTransfer (3 / 5) (4 / 5) 1 I ≠ 1 ∧
      ¬ IsUnitary wrongRealTurnTransfer := by
  constructor
  · apply physicalTransfer_unitary <;> norm_num
  · constructor
    · intro h
      have h00 := congrFun (congrFun h left) left
      norm_num [physicalTransfer] at h00
    · unfold IsUnitary
      norm_num [← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply]
      intro h
      use left, right
      norm_num [Fin.sum_univ_succ, Matrix.one_apply]
      erw [Finset.sum_eq_multiset_sum]
      norm_cast
      erw [Multiset.sum_pair]
      norm_num [Complex.ext_iff, wrongRealTurnTransfer]
      norm_num [Complex.normSq, Complex.div_re, Complex.div_im]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryCheckerboardTransfer.physicalTransfer_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physicalTransfer_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryCheckerboardTransfer.physicalTransfer_eq_transfer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physicalTransfer_eq_transfer

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryCheckerboardTransfer.physical_transfer_history_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physical_transfer_history_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.UnitaryCheckerboardTransfer.rational_massive_transfer_controls' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_massive_transfer_controls

end PhysicsSM.Draft.NullEdge.UnitaryCheckerboardTransfer
