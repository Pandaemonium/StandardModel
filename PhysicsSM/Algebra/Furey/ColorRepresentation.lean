import Mathlib
import PhysicsSM.Algebra.Furey.OperatorAlgebra

/-!
# Algebra.Furey.ColorRepresentation

This module packages the Furey color operators as a representation API on the
minimal left ideal `J`.  It builds on the finite operator-algebra facts in
`PhysicsSM.Algebra.Furey.OperatorAlgebra` without changing any signs or
non-associative conventions.

## Contents

- `ColorGen`: a finite index type for the eight SU(3) color generators
  (six off-diagonal ladder operators and two diagonal Cartan elements).
- `ColorGen.toEnd`: the map sending each generator to its complex-linear
  endomorphism of `ComplexOctonion`.
- **Bracket table**: commutator identities `[Eᵢⱼ, Eⱼᵢ] = −Hᵢⱼ` and
  `[E₁₂, E₂₃] = T₁₃` etc., repackaged from `OperatorAlgebra`.
- **Diagonal–root commutators**: `[H₁₂, T₁₂] = −2 T₁₂` and analogues,
  forming the Cartan–Chevalley weight table.
- Basis action tables for `H₂₃_op` and `H₁₃_op`.

## Critical convention

All operator compositions use the non-associative convention:
  `(Lmul a).comp (Lmul b)` means `x ↦ a * (b * x)`
Signs are inherited from `OperatorAlgebra.lean` and are not modified.

Source: Furey, arXiv:1806.00612.
Provenance: clean-room formalization building on kernel-checked operator
tables in `OperatorAlgebra.lean` and `OperatorRepresentations.lean`.

All theorems in this file are trusted finite-coordinate computations.
-/

namespace PhysicsSM.Algebra.Furey.MinimalLeftIdeal

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Furey.LadderOperators

/-!
## Basis-action tables for the diagonal operators H₂₃ and H₁₃

These are derived from the number-operator tables already proved in
`OperatorRepresentations.lean`.  Each theorem is a direct consequence of
`H23_op = N2_op − N3_op` and `H13_op = N1_op − N3_op`.

### H₂₃ eigenvalue table

| State | N₂ | N₃ | H₂₃ = N₂ − N₃ |
|-------|----|----|----------------|
| omega |  1 |  1 |       0        |
| v1    |  1 |  1 |       0        |
| v2    |  0 |  1 |      −1        |
| v3    |  1 |  0 |      +1        |
| v4    |  0 |  1 |      −1        |
| v5    |  1 |  0 |      +1        |
| v6    |  0 |  0 |       0        |
| nu    |  0 |  0 |       0        |

### H₁₃ eigenvalue table

| State | N₁ | N₃ | H₁₃ = N₁ − N₃ |
|-------|----|----|----------------|
| omega |  1 |  1 |       0        |
| v1    |  0 |  1 |      −1        |
| v2    |  1 |  1 |       0        |
| v3    |  1 |  0 |      +1        |
| v4    |  0 |  1 |      −1        |
| v5    |  0 |  0 |       0        |
| v6    |  1 |  0 |      +1        |
| nu    |  0 |  0 |       0        |
-/

-- ============================================================================
-- H23_op = N2_op - N3_op basis actions
-- ============================================================================

theorem H23_op_omega : H23_op omega = 0 := by
  simp [H23_op, N2_op_omega, N3_op_omega]

theorem H23_op_v1 : H23_op v1 = 0 := by
  simp [H23_op, N2_op_v1, N3_op_v1]

/-- `H₂₃(v₂) = −v₂`: mode 2 is empty, mode 3 is occupied. -/
theorem H23_op_v2 : H23_op v2 = (-1 : Complex) • v2 := by
  simp [H23_op, N2_op_v2, N3_op_v2]

/-- `H₂₃(v₃) = v₃`: mode 2 is occupied, mode 3 is empty. -/
theorem H23_op_v3 : H23_op v3 = (1 : Complex) • v3 := by
  simp [H23_op, N2_op_v3, N3_op_v3]

/-- `H₂₃(v₄) = −v₄`: anti-down sector mirrors anti-up signs. -/
theorem H23_op_v4 : H23_op v4 = (-1 : Complex) • v4 := by
  simp [H23_op, N2_op_v4, N3_op_v4]

/-- `H₂₃(v₅) = v₅`: anti-down sector mirrors anti-up signs. -/
theorem H23_op_v5 : H23_op v5 = (1 : Complex) • v5 := by
  simp [H23_op, N2_op_v5, N3_op_v5]

theorem H23_op_v6 : H23_op v6 = 0 := by
  simp [H23_op, N2_op_v6, N3_op_v6]

theorem H23_op_nu : H23_op nu = 0 := by
  simp [H23_op, N2_op_nu, N3_op_nu]

-- ============================================================================
-- H13_op = N1_op - N3_op basis actions
-- ============================================================================

theorem H13_op_omega : H13_op omega = 0 := by
  simp [H13_op, N1_op_omega, N3_op_omega]

/-- `H₁₃(v₁) = −v₁`: mode 1 is empty, mode 3 is occupied. -/
theorem H13_op_v1 : H13_op v1 = (-1 : Complex) • v1 := by
  simp [H13_op, N1_op_v1, N3_op_v1]

/-- `H₁₃(v₂) = 0`: both modes 1 and 3 are occupied. -/
theorem H13_op_v2 : H13_op v2 = 0 := by
  simp [H13_op, N1_op_v2, N3_op_v2]

/-- `H₁₃(v₃) = v₃`: mode 1 is occupied, mode 3 is empty. -/
theorem H13_op_v3 : H13_op v3 = (1 : Complex) • v3 := by
  simp [H13_op, N1_op_v3, N3_op_v3]

/-- `H₁₃(v₄) = −v₄`: anti-down sector mirrors anti-up signs. -/
theorem H13_op_v4 : H13_op v4 = (-1 : Complex) • v4 := by
  simp [H13_op, N1_op_v4, N3_op_v4]

theorem H13_op_v5 : H13_op v5 = 0 := by
  simp [H13_op, N1_op_v5, N3_op_v5]

/-- `H₁₃(v₆) = v₆`: mode 1 is occupied, mode 3 is empty. -/
theorem H13_op_v6 : H13_op v6 = (1 : Complex) • v6 := by
  simp [H13_op, N1_op_v6, N3_op_v6]

theorem H13_op_nu : H13_op nu = 0 := by
  simp [H13_op, N1_op_nu, N3_op_nu]

/-!
## Color generator index type

The eight generators of the SU(3) color algebra in the Chevalley basis:
six off-diagonal root vectors and two Cartan elements.
-/

/-- The eight generators of the color SU(3) Lie algebra acting on `J`.

- `E12`, `E21`, `E13`, `E31`, `E23`, `E32`: off-diagonal root vectors
  (ladder operators that change color).
- `H12`, `H23`: diagonal Cartan elements (number-operator differences).
-/
inductive ColorGen where
  | E12 | E21 | E13 | E31 | E23 | E32 | H12 | H23
  deriving DecidableEq, Fintype

/--
Map each color generator to its complex-linear endomorphism of
`ComplexOctonion`.

Convention: the off-diagonal generators are the `Tij_op` ladder operators
and the diagonal generators are `H12_op = N1_op − N2_op` and
`H23_op = N2_op − N3_op`, exactly as defined in `OperatorAlgebra.lean`.
No signs are adjusted.
-/
noncomputable def ColorGen.toEnd :
    ColorGen → (ComplexOctonion →ₗ[Complex] ComplexOctonion)
  | .E12 => T12_op
  | .E21 => T21_op
  | .E13 => T13_op
  | .E31 => T31_op
  | .E23 => T23_op
  | .E32 => T32_op
  | .H12 => H12_op
  | .H23 => H23_op

/-!
## Bracket table — off-diagonal commutators

These theorems repackage the commutator identities already proved in
`OperatorAlgebra.lean` using the `ColorGen.toEnd` API.
-/

/-- `[E₁₂, E₂₁] = −H₁₂` on `J`. -/
theorem color_bracket_E12_E21 :
    EqOnJ (opComm ColorGen.E12.toEnd ColorGen.E21.toEnd)
      (-H12_op) :=
  comm_T12_T21_eq_neg_H12

/-- `[E₁₃, E₃₁] = −H₁₃` on `J`. -/
theorem color_bracket_E13_E31 :
    EqOnJ (opComm ColorGen.E13.toEnd ColorGen.E31.toEnd)
      (-H13_op) :=
  comm_T13_T31_eq_neg_H13

/-- `[E₂₃, E₃₂] = −H₂₃` on `J`. -/
theorem color_bracket_E23_E32 :
    EqOnJ (opComm ColorGen.E23.toEnd ColorGen.E32.toEnd)
      (-H23_op) :=
  comm_T23_T32_eq_neg_H23

/-- `[E₁₂, E₂₃] = T₁₃` on `J` (Serre relation). -/
theorem color_bracket_E12_E23 :
    EqOnJ (opComm ColorGen.E12.toEnd ColorGen.E23.toEnd)
      T13_op :=
  comm_T12_T23_eq_T13

/-- `[E₂₁, E₃₂] = −T₃₁` on `J` (adjoint Serre relation). -/
theorem color_bracket_E21_E32 :
    EqOnJ (opComm ColorGen.E21.toEnd ColorGen.E32.toEnd)
      (-T31_op) :=
  comm_T21_T32_eq_neg_T31

/-!
## Diagonal–root commutators (Cartan–Chevalley weight table)

These are the `[H, E]` commutators that determine how the Cartan elements
weight the root vectors.  The coefficients match the SU(3) Cartan matrix
`[[2, −1], [−1, 2]]` up to the overall sign flip coming from the
number-operator convention `N_k` counting occupied modes.

### Weight table on `J`

| H \ E  | T12 | T21 | T13 | T31 | T23 | T32 |
|--------|-----|-----|-----|-----|-----|-----|
| H12_op | −2  |  2  | −1  |  1  |  1  | −1  |
| H23_op |  1  | −1  | −1  |  1  | −2  |  2  |

The table is anti-symmetric under `Tij ↔ Tji` (exchange of root and
coroot), as expected for an SU(3) representation.
-/

/-- `[H₁₂, T₁₂] = −2 · T₁₂` on `J`. -/
theorem comm_H12_T12 :
    EqOnJ (opComm H12_op T12_op)
      ((-2 : Complex) • T12_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H12_op_omega, H12_op_v1, H12_op_v2, H12_op_v3,
      H12_op_v4, H12_op_v5, H12_op_v6, H12_op_nu,
      T12_op_omega, T12_op_v1, T12_op_v2, T12_op_v3,
      T12_op_v4, T12_op_v5, T12_op_v6, T12_op_nu] <;>
    module

/-- `[H₁₂, T₂₁] = 2 · T₂₁` on `J`. -/
theorem comm_H12_T21 :
    EqOnJ (opComm H12_op T21_op)
      ((2 : Complex) • T21_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H12_op_omega, H12_op_v1, H12_op_v2, H12_op_v3,
      H12_op_v4, H12_op_v5, H12_op_v6, H12_op_nu,
      T21_op_omega, T21_op_v1, T21_op_v2, T21_op_v3,
      T21_op_v4, T21_op_v5, T21_op_v6, T21_op_nu] <;>
    module

/-- `[H₁₂, T₁₃] = −1 · T₁₃` on `J`. -/
theorem comm_H12_T13 :
    EqOnJ (opComm H12_op T13_op)
      ((-1 : Complex) • T13_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H12_op_omega, H12_op_v1, H12_op_v2, H12_op_v3,
      H12_op_v4, H12_op_v5, H12_op_v6, H12_op_nu,
      T13_op_omega, T13_op_v1, T13_op_v2, T13_op_v3,
      T13_op_v4, T13_op_v5, T13_op_v6, T13_op_nu]

/-- `[H₁₂, T₃₁] = 1 · T₃₁` on `J`. -/
theorem comm_H12_T31 :
    EqOnJ (opComm H12_op T31_op)
      ((1 : Complex) • T31_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H12_op_omega, H12_op_v1, H12_op_v2, H12_op_v3,
      H12_op_v4, H12_op_v5, H12_op_v6, H12_op_nu,
      T31_op_omega, T31_op_v1, T31_op_v2, T31_op_v3,
      T31_op_v4, T31_op_v5, T31_op_v6, T31_op_nu]

/-- `[H₁₂, T₂₃] = 1 · T₂₃` on `J`. -/
theorem comm_H12_T23 :
    EqOnJ (opComm H12_op T23_op)
      ((1 : Complex) • T23_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H12_op_omega, H12_op_v1, H12_op_v2, H12_op_v3,
      H12_op_v4, H12_op_v5, H12_op_v6, H12_op_nu,
      T23_op_omega, T23_op_v1, T23_op_v2, T23_op_v3,
      T23_op_v4, T23_op_v5, T23_op_v6, T23_op_nu]

/-- `[H₁₂, T₃₂] = −1 · T₃₂` on `J`. -/
theorem comm_H12_T32 :
    EqOnJ (opComm H12_op T32_op)
      ((-1 : Complex) • T32_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H12_op_omega, H12_op_v1, H12_op_v2, H12_op_v3,
      H12_op_v4, H12_op_v5, H12_op_v6, H12_op_nu,
      T32_op_omega, T32_op_v1, T32_op_v2, T32_op_v3,
      T32_op_v4, T32_op_v5, T32_op_v6, T32_op_nu]

/-- `[H₂₃, T₂₃] = −2 · T₂₃` on `J`. -/
theorem comm_H23_T23 :
    EqOnJ (opComm H23_op T23_op)
      ((-2 : Complex) • T23_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H23_op_omega, H23_op_v1, H23_op_v2, H23_op_v3,
      H23_op_v4, H23_op_v5, H23_op_v6, H23_op_nu,
      T23_op_omega, T23_op_v1, T23_op_v2, T23_op_v3,
      T23_op_v4, T23_op_v5, T23_op_v6, T23_op_nu] <;>
    module

/-- `[H₂₃, T₃₂] = 2 · T₃₂` on `J`. -/
theorem comm_H23_T32 :
    EqOnJ (opComm H23_op T32_op)
      ((2 : Complex) • T32_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H23_op_omega, H23_op_v1, H23_op_v2, H23_op_v3,
      H23_op_v4, H23_op_v5, H23_op_v6, H23_op_nu,
      T32_op_omega, T32_op_v1, T32_op_v2, T32_op_v3,
      T32_op_v4, T32_op_v5, T32_op_v6, T32_op_nu] <;>
    module

/-- `[H₂₃, T₁₂] = 1 · T₁₂` on `J`. -/
theorem comm_H23_T12 :
    EqOnJ (opComm H23_op T12_op)
      ((1 : Complex) • T12_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H23_op_omega, H23_op_v1, H23_op_v2, H23_op_v3,
      H23_op_v4, H23_op_v5, H23_op_v6, H23_op_nu,
      T12_op_omega, T12_op_v1, T12_op_v2, T12_op_v3,
      T12_op_v4, T12_op_v5, T12_op_v6, T12_op_nu]

/-- `[H₂₃, T₂₁] = −1 · T₂₁` on `J`. -/
theorem comm_H23_T21 :
    EqOnJ (opComm H23_op T21_op)
      ((-1 : Complex) • T21_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H23_op_omega, H23_op_v1, H23_op_v2, H23_op_v3,
      H23_op_v4, H23_op_v5, H23_op_v6, H23_op_nu,
      T21_op_omega, T21_op_v1, T21_op_v2, T21_op_v3,
      T21_op_v4, T21_op_v5, T21_op_v6, T21_op_nu]

/-- `[H₂₃, T₁₃] = −1 · T₁₃` on `J`. -/
theorem comm_H23_T13 :
    EqOnJ (opComm H23_op T13_op)
      ((-1 : Complex) • T13_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H23_op_omega, H23_op_v1, H23_op_v2, H23_op_v3,
      H23_op_v4, H23_op_v5, H23_op_v6, H23_op_nu,
      T13_op_omega, T13_op_v1, T13_op_v2, T13_op_v3,
      T13_op_v4, T13_op_v5, T13_op_v6, T13_op_nu]

/-- `[H₂₃, T₃₁] = 1 · T₃₁` on `J`. -/
theorem comm_H23_T31 :
    EqOnJ (opComm H23_op T31_op)
      ((1 : Complex) • T31_op) := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H23_op_omega, H23_op_v1, H23_op_v2, H23_op_v3,
      H23_op_v4, H23_op_v5, H23_op_v6, H23_op_nu,
      T31_op_omega, T31_op_v1, T31_op_v2, T31_op_v3,
      T31_op_v4, T31_op_v5, T31_op_v6, T31_op_nu]

/-!
## Cartan self-commutators

The diagonal generators commute with each other and with themselves on `J`.
-/

/-- `[H₁₂, H₁₂] = 0` on `J` (trivial self-commutator). -/
theorem comm_H12_H12 :
    EqOnJ (opComm H12_op H12_op) 0 := by
  intro _ _; simp [opComm]

/-- `[H₂₃, H₂₃] = 0` on `J` (trivial self-commutator). -/
theorem comm_H23_H23 :
    EqOnJ (opComm H23_op H23_op) 0 := by
  intro _ _; simp [opComm]

/-- `[H₁₂, H₂₃] = 0` on `J` (Cartan elements commute). -/
theorem comm_H12_H23 :
    EqOnJ (opComm H12_op H23_op) 0 := by
  apply EqOnJ_of_basis; intro i; fin_cases i <;>
    simp [basisState, opComm,
      H12_op_omega, H12_op_v1, H12_op_v2, H12_op_v3,
      H12_op_v4, H12_op_v5, H12_op_v6, H12_op_nu,
      H23_op_omega, H23_op_v1, H23_op_v2, H23_op_v3,
      H23_op_v4, H23_op_v5, H23_op_v6, H23_op_nu]

end PhysicsSM.Algebra.Furey.MinimalLeftIdeal
