import Mathlib

open Matrix Complex

namespace UnitaryTransfer

inductive Direction where
  | left | right
  deriving DecidableEq, Fintype, Repr

open Direction

abbrev Mat2 := Matrix Direction Direction ℂ

def turnTransfer (mu : ℂ) (phase : Direction -> ℂ) : Mat2 :=
  fun finish start =>
    (if finish = start then 1 else mu) * phase finish

def physicalTransfer (c s : ℝ) (uL uR : ℂ) : Mat2 :=
  fun finish start => match finish, start with
    | left, left => (c : ℂ) * uL
    | left, right => I * (s : ℂ) * uL
    | right, left => I * (s : ℂ) * uR
    | right, right => (c : ℂ) * uR

def IsUnitary (U : Mat2) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

/-- Imaginary turn amplitude plus unit-modulus outgoing phases gives exact
two-sided unitarity on the normalized circle. -/
theorem physicalTransfer_unitary (c s : ℝ) (uL uR : ℂ)
    (hcs : c ^ 2 + s ^ 2 = 1)
    (hL : Complex.normSq uL = 1) (hR : Complex.normSq uR = 1) :
    IsUnitary (physicalTransfer c s uL uR) := by
  sorry

/-- The physical matrix is exactly the checkerboard turn transfer with
`mu=i*s/c` and outgoing phase `c*u`, when `c` is nonzero. -/
theorem physicalTransfer_eq_turnTransfer (c s : ℝ) (uL uR : ℂ)
    (hc : c ≠ 0) :
    physicalTransfer c s uL uR =
      turnTransfer (I * (s : ℂ) / (c : ℂ))
        (fun d => match d with
          | left => (c : ℂ) * uL
          | right => (c : ℂ) * uR) := by
  sorry

noncomputable def historyOperator (h : List Mat2) : Mat2 := h.prod

theorem isUnitary_mul {A B : Mat2}
    (hA : IsUnitary A) (hB : IsUnitary B) : IsUnitary (A * B) := by
  sorry

/-- Repeating the physical transfer gives unitary finite-history evolution. -/
theorem physical_transfer_history_unitary (c s : ℝ) (uL uR : ℂ)
    (hcs : c ^ 2 + s ^ 2 = 1)
    (hL : Complex.normSq uL = 1) (hR : Complex.normSq uR = 1)
    (n : ℕ) :
    IsUnitary (historyOperator
      (List.replicate n (physicalTransfer c s uL uR))) := by
  sorry

noncomputable def wrongRealTurnTransfer : Mat2 :=
  fun finish start => match finish, start with
    | left, left | right, right => ((3 / 5 : ℝ) : ℂ)
    | left, right | right, left => ((4 / 5 : ℝ) : ℂ)

theorem rational_massive_transfer_controls :
    IsUnitary (physicalTransfer (3 / 5) (4 / 5) 1 I) ∧
      physicalTransfer (3 / 5) (4 / 5) 1 I ≠ 1 ∧
      ¬ IsUnitary wrongRealTurnTransfer := by
  sorry

end UnitaryTransfer
