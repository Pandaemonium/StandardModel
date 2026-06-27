import Mathlib
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.Algebra.Furey.ElectroweakBridge

/-!
# Furey Q_op/Jbar eigenvalue bridge

This trusted module connects the finite rational table
`PhysicsSM.Algebra.Furey.ElectroweakBridge.rawQop` to the kernel-checked
operator-eigenvalue theorems in `PhysicsSM.Algebra.Furey.AnomalyBridge`.

The main result `Q_op_JbarBasisState_eigen` says that for every Jbar state
index `s : Fin 8`, applying `Q_op` to `JbarBasisState s` yields the scalar
`rawQop s`, lifted to `Complex`, times that basis state.

Source notes:
- Cohl Furey, "Charge quantization from a number operator", Phys. Lett. B 742
  (2015), 195.
- `PhysicsSM.Algebra.Furey.AnomalyBridge`, for the trusted coordinate
  eigenvalue calculations reused here.
- `PhysicsSM.Algebra.Furey.ElectroweakBridge`, for the finite rational table.

Provenance: integrated from Aristotle job
`4c9271c4-e53b-43e7-a037-757b825bfc37`, with local review and provenance
cleanup.

Status: trusted module; all proofs are kernel-checked without placeholder
declarations.
-/

namespace PhysicsSM.Algebra.Furey.QopJbarEigenBridge

open PhysicsSM.Algebra.Furey.AnomalyBridge
open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal
open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Octonion

/-- The raw `Q_op` eigenvalue table lifted from `Rat` to `Complex`. -/
def rawQopComplex (s : ElectroweakBridge.JbarState) : Complex :=
  (ElectroweakBridge.rawQop s : Complex)

/-! ## Per-state corollaries -/

/-- The `Q_op` eigenvalue theorem for Jbar state `0`. -/
theorem Q_op_JbarBasisState_zero :
    MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState 0) =
      rawQopComplex 0 • AnomalyBridge.JbarBasisState 0 := by
  change Q_op omega_bar = rawQopComplex 0 • omega_bar
  rw [Q_op_omega_bar]
  simp [rawQopComplex, ElectroweakBridge.rawQop]

/-- The `Q_op` eigenvalue theorem for Jbar state `1`. -/
theorem Q_op_JbarBasisState_one :
    MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState 1) =
      rawQopComplex 1 • AnomalyBridge.JbarBasisState 1 := by
  change Q_op vbar1 = rawQopComplex 1 • vbar1
  rw [Q_op_vbar1]
  simp [rawQopComplex, ElectroweakBridge.rawQop]

/-- The `Q_op` eigenvalue theorem for Jbar state `2`. -/
theorem Q_op_JbarBasisState_two :
    MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState 2) =
      rawQopComplex 2 • AnomalyBridge.JbarBasisState 2 := by
  change Q_op vbar2 = rawQopComplex 2 • vbar2
  rw [Q_op_vbar2]
  simp [rawQopComplex, ElectroweakBridge.rawQop]

/-- The `Q_op` eigenvalue theorem for Jbar state `3`. -/
theorem Q_op_JbarBasisState_three :
    MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState 3) =
      rawQopComplex 3 • AnomalyBridge.JbarBasisState 3 := by
  change Q_op vbar3 = rawQopComplex 3 • vbar3
  rw [Q_op_vbar3]
  simp [rawQopComplex, ElectroweakBridge.rawQop]

/-- The `Q_op` eigenvalue theorem for Jbar state `4`. -/
theorem Q_op_JbarBasisState_four :
    MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState 4) =
      rawQopComplex 4 • AnomalyBridge.JbarBasisState 4 := by
  change Q_op vbar4 = rawQopComplex 4 • vbar4
  rw [Q_op_vbar4]
  simp [rawQopComplex, ElectroweakBridge.rawQop]

/-- The `Q_op` eigenvalue theorem for Jbar state `5`. -/
theorem Q_op_JbarBasisState_five :
    MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState 5) =
      rawQopComplex 5 • AnomalyBridge.JbarBasisState 5 := by
  change Q_op vbar5 = rawQopComplex 5 • vbar5
  rw [Q_op_vbar5]
  simp [rawQopComplex, ElectroweakBridge.rawQop]

/-- The `Q_op` eigenvalue theorem for Jbar state `6`. -/
theorem Q_op_JbarBasisState_six :
    MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState 6) =
      rawQopComplex 6 • AnomalyBridge.JbarBasisState 6 := by
  change Q_op vbar6 = rawQopComplex 6 • vbar6
  rw [Q_op_vbar6]
  simp [rawQopComplex, ElectroweakBridge.rawQop]

/-- The `Q_op` eigenvalue theorem for Jbar state `7`. -/
theorem Q_op_JbarBasisState_seven :
    MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState 7) =
      rawQopComplex 7 • AnomalyBridge.JbarBasisState 7 := by
  change Q_op nu_bar = rawQopComplex 7 • nu_bar
  rw [Q_op_nu_bar]
  simp [rawQopComplex, ElectroweakBridge.rawQop]

/-! ## Main all-state theorem -/

set_option maxHeartbeats 1600000 in
-- `fin_cases` on `Fin 8` with heavy `ComplexOctonion` terms needs extra budget.
/--
The raw `Q_op` eigenvalue table in `ElectroweakBridge` is exactly the one
obtained from the kernel-checked `Q_op` eigenvalue theorems in `AnomalyBridge`.
-/
theorem Q_op_JbarBasisState_eigen (s : ElectroweakBridge.JbarState) :
    MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState s) =
      rawQopComplex s • AnomalyBridge.JbarBasisState s := by
  fin_cases s
  · exact Q_op_JbarBasisState_zero
  · exact Q_op_JbarBasisState_one
  · exact Q_op_JbarBasisState_two
  · exact Q_op_JbarBasisState_three
  · exact Q_op_JbarBasisState_four
  · exact Q_op_JbarBasisState_five
  · exact Q_op_JbarBasisState_six
  · exact Q_op_JbarBasisState_seven

end PhysicsSM.Algebra.Furey.QopJbarEigenBridge
