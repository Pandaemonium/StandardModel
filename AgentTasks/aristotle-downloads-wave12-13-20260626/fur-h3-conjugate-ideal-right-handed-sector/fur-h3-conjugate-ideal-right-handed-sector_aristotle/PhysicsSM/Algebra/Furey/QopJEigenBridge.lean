import Mathlib
import PhysicsSM.Algebra.Furey.OperatorRepresentations
import PhysicsSM.Algebra.Furey.MinimalLeftIdeal

/-!
# Furey Q_op/J eigenvalue bridge

This trusted module connects a finite rational table `rawQopJ` to the
kernel-checked operator-eigenvalue theorems for the J-sector basis states
in `PhysicsSM.Algebra.Furey.OperatorRepresentations`.

The main result `Q_op_JBasisState_eigen` says that for every J state index
`s : Fin 8`, applying `Q_op` to `JBasisState s` yields the scalar
`rawQopJ s`, lifted to `Complex`, times that basis state.

This is the J-sector counterpart to the existing Jbar bridge in
`PhysicsSM.Algebra.Furey.QopJbarEigenBridge`.

Source notes:
- Cohl Furey, "Charge quantization from a number operator",
  arXiv:1603.04078.
- Cohl Furey, "SU(3)_C x SU(2)_L x U(1)_Y (x U(1)_X) as a symmetry of
  division algebraic ladder operators", arXiv:1806.00612.
- `PhysicsSM.Algebra.Furey.OperatorRepresentations`, for the trusted
  coordinate eigenvalue calculations reused here.

Provenance: integrated from Aristotle job
`9f5a049f-bef5-4b32-abc5-765037d39692`, with local review and provenance
cleanup.

Claim boundary:
- This module proves operator eigenvalues in the project convention.
- It does not claim a full Standard Model generation realization or derive
  the weak-isospin operator.
- Uses the project XOR basis and existing convention notes.

Status: trusted module; all proofs are kernel-checked without placeholder
declarations.
-/

namespace PhysicsSM.Algebra.Furey.QopJEigenBridge

open PhysicsSM.Algebra.Furey.MinimalLeftIdeal
open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Octonion

/-- J-sector state index. -/
abbrev JState := Fin 8

/-- The eight J-sector basis states, indexed by `Fin 8`. -/
noncomputable def JBasisState : JState -> ComplexOctonion
  | 0 => omega
  | 1 => v1
  | 2 => v2
  | 3 => v3
  | 4 => v4
  | 5 => v5
  | 6 => v6
  | 7 => nu

/-- The raw `Q_op` eigenvalue table for the J sector as rational numbers. -/
def rawQopJ (s : JState) : Rat :=
  match s.val with
  | 0 => -1
  | 1 => -2 / 3
  | 2 => -2 / 3
  | 3 => -2 / 3
  | 4 => -1 / 3
  | 5 => -1 / 3
  | 6 => -1 / 3
  | _ => 0

/-- The raw `Q_op` eigenvalue table lifted from `Rat` to `Complex`. -/
def rawQopJComplex (s : JState) : Complex := (rawQopJ s : Complex)

/-- The explicit list of `rawQopJ` values. -/
theorem rawQopJ_values :
    (List.finRange 8).map rawQopJ =
      [-1, -2 / 3, -2 / 3, -2 / 3, -1 / 3, -1 / 3, -1 / 3, 0] := by
  simp [List.finRange, rawQopJ]

/-! ## Per-state corollaries -/

/-- The `Q_op` eigenvalue theorem for J state `0` (`omega`). -/
theorem Q_op_JBasisState_zero :
    MinimalLeftIdeal.Q_op (JBasisState 0) =
      rawQopJComplex 0 • JBasisState 0 := by
  change Q_op omega = rawQopJComplex 0 • omega
  rw [Q_omega]
  simp [rawQopJComplex, rawQopJ]

/-- The `Q_op` eigenvalue theorem for J state `1` (`v1`). -/
theorem Q_op_JBasisState_one :
    MinimalLeftIdeal.Q_op (JBasisState 1) =
      rawQopJComplex 1 • JBasisState 1 := by
  change Q_op v1 = rawQopJComplex 1 • v1
  rw [Q_v1]
  simp [rawQopJComplex, rawQopJ]

/-- The `Q_op` eigenvalue theorem for J state `2` (`v2`). -/
theorem Q_op_JBasisState_two :
    MinimalLeftIdeal.Q_op (JBasisState 2) =
      rawQopJComplex 2 • JBasisState 2 := by
  change Q_op v2 = rawQopJComplex 2 • v2
  rw [Q_v2]
  simp [rawQopJComplex, rawQopJ]

/-- The `Q_op` eigenvalue theorem for J state `3` (`v3`). -/
theorem Q_op_JBasisState_three :
    MinimalLeftIdeal.Q_op (JBasisState 3) =
      rawQopJComplex 3 • JBasisState 3 := by
  change Q_op v3 = rawQopJComplex 3 • v3
  rw [Q_v3]
  simp [rawQopJComplex, rawQopJ]

/-- The `Q_op` eigenvalue theorem for J state `4` (`v4`). -/
theorem Q_op_JBasisState_four :
    MinimalLeftIdeal.Q_op (JBasisState 4) =
      rawQopJComplex 4 • JBasisState 4 := by
  change Q_op v4 = rawQopJComplex 4 • v4
  rw [Q_v4]
  simp [rawQopJComplex, rawQopJ]

/-- The `Q_op` eigenvalue theorem for J state `5` (`v5`). -/
theorem Q_op_JBasisState_five :
    MinimalLeftIdeal.Q_op (JBasisState 5) =
      rawQopJComplex 5 • JBasisState 5 := by
  change Q_op v5 = rawQopJComplex 5 • v5
  rw [Q_v5]
  simp [rawQopJComplex, rawQopJ]

/-- The `Q_op` eigenvalue theorem for J state `6` (`v6`). -/
theorem Q_op_JBasisState_six :
    MinimalLeftIdeal.Q_op (JBasisState 6) =
      rawQopJComplex 6 • JBasisState 6 := by
  change Q_op v6 = rawQopJComplex 6 • v6
  rw [Q_v6]
  simp [rawQopJComplex, rawQopJ]

/-- The `Q_op` eigenvalue theorem for J state `7` (`nu`). -/
theorem Q_op_JBasisState_seven :
    MinimalLeftIdeal.Q_op (JBasisState 7) =
      rawQopJComplex 7 • JBasisState 7 := by
  change Q_op nu = rawQopJComplex 7 • nu
  rw [Q_nu]
  simp [rawQopJComplex, rawQopJ]

/-! ## Main all-state theorem -/

set_option maxHeartbeats 1600000 in
-- `fin_cases` on `Fin 8` with heavy `ComplexOctonion` terms needs extra budget.
/--
For every J-sector basis state `s : Fin 8`, the electric charge operator
`Q_op` acts as scalar multiplication by the rational eigenvalue `rawQopJ s`.

This is the J-sector counterpart to
`QopJbarEigenBridge.Q_op_JbarBasisState_eigen`.
-/
theorem Q_op_JBasisState_eigen (s : JState) :
    MinimalLeftIdeal.Q_op (JBasisState s) =
      rawQopJComplex s • JBasisState s := by
  fin_cases s
  · exact Q_op_JBasisState_zero
  · exact Q_op_JBasisState_one
  · exact Q_op_JBasisState_two
  · exact Q_op_JBasisState_three
  · exact Q_op_JBasisState_four
  · exact Q_op_JBasisState_five
  · exact Q_op_JBasisState_six
  · exact Q_op_JBasisState_seven

end PhysicsSM.Algebra.Furey.QopJEigenBridge
