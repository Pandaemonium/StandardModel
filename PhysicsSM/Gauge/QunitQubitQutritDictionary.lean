import Mathlib
import PhysicsSM.Gauge.StandardModelGroupStructure
import PhysicsSM.Gauge.StandardModelZ6KernelPackage
import PhysicsSM.Gauge.StandardModelUnitZ6Kernel
import PhysicsSM.Gauge.StandardModelCoverageImageSMBlock

/-!
# Gauge.QunitQubitQutritDictionary

Precise Lean dictionary for Baez's observation that the same complex
vector spaces underlying quunits (ℂ), qubits (ℂ²), and qutrits (ℂ³)
also underlie the three gauge factors U(1), SU(2), and SU(3) of the
Standard Model.

## Overview

| Information-theory name | Vector space | Gauge group acting on it |
|-------------------------|-------------|--------------------------|
| quunit                  | ℂ ≅ ℂ¹     | U(1)                    |
| qubit                   | ℂ²          | SU(2)                   |
| qutrit                  | ℂ³          | SU(3)                   |

The direct sum ℂ² ⊕ ℂ³ ≅ ℂ⁵ hosts the block-diagonal group
S(U(2) × U(3)), whose elements are block matrices `fromBlocks A 0 0 B`
with `A ∈ U(2)`, `B ∈ U(3)`, and `det(A) · det(B) = 1`.

The covering presentation is
  `(U(1) × SU(2) × SU(3)) / ℤ₆  ≅  S(U(2) × U(3))`
where the ℤ₆ kernel is verified by the `StandardModelZ6KernelPackage`
and `StandardModelUnitZ6KernelPackage` modules.

## What this module provides

1. Type aliases `Qunit`, `Qubit`, `Qutrit`, `QubitPlusQutrit`.
2. A linear equivalence `qubitPlusQutritEquiv : QubitPlusQutrit ≃ₗ[ℂ] Qubit × Qutrit`.
3. The scalar-matrix theorem for 1×1 matrices (`quunit_matrix_eq_scalar`).
4. The iff bridge `smBlockPredicate_is_qubit_qutrit_block` connecting
   `SMBlockPredicate` to the qubit/qutrit block decomposition.
5. A bundled `QunitQubitQutritDictionaryPackage` tying together the
   dictionary, the Z₆ kernel cardinality, the unit kernel family, and the
   SM block predicate characterisation.

## What this module does NOT claim

- The Standard Model is not a quantum-computing system; quunits, qubits,
  and qutrits are used here only as dimension labels.
- No compact Lie group topology, smooth manifold structure, or full
  quotient-group isomorphism is claimed.
- No new physics results are proved; this is a dictionary and theorem index.

## References

- Baez, "Standard Model — Part 3: Qubits" (public lecture series).
- Baez–Huerta, "The Algebra of Grand Unified Theories",
  Bull. Amer. Math. Soc. 47 (2010), 483–552.

Status: trusted — no `s o r r y`.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Gauge.QunitQubitQutritDictionary

open Complex Matrix PhysicsSM.Gauge.GUTSquare PhysicsSM.Gauge.StandardModelSubgroup

/-! ## State-space type aliases -/

/-- A **quunit** is a state in ℂ¹. The unitary group acting on this space
is U(1), which is the hypercharge gauge factor of the Standard Model. -/
abbrev Qunit := Fin 1 → ℂ

/-- A **qubit** is a state in ℂ². The special unitary group SU(2) acting
on this space is the weak isospin gauge factor of the Standard Model. -/
abbrev Qubit := Fin 2 → ℂ

/-- A **qutrit** is a state in ℂ³. The special unitary group SU(3) acting
on this space is the colour gauge factor of the Standard Model. -/
abbrev Qutrit := Fin 3 → ℂ

/-- The direct sum ℂ² ⊕ ℂ³, the five-dimensional representation space
on which S(U(2) × U(3)) acts block-diagonally. -/
abbrev QubitPlusQutrit := (Fin 2 ⊕ Fin 3) → ℂ

/-! ## Linear equivalence: ℂ² ⊕ ℂ³ ≃ₗ ℂ² × ℂ³ -/

/-- The canonical linear equivalence between `QubitPlusQutrit` (functions on
`Fin 2 ⊕ Fin 3`) and the product `Qubit × Qutrit` (functions on `Fin 2`
paired with functions on `Fin 3`). -/
noncomputable def qubitPlusQutritEquiv :
    QubitPlusQutrit ≃ₗ[ℂ] (Qubit × Qutrit) :=
  LinearEquiv.sumPiEquivProdPi ℂ (Fin 2) (Fin 3) (fun _ => ℂ)

/-! ## Coordinate projection / reconstruction -/

/-- Project a `QubitPlusQutrit` vector to its qubit (left) component. -/
def projectQubit (v : QubitPlusQutrit) : Qubit :=
  fun i => v (Sum.inl i)

/-- Project a `QubitPlusQutrit` vector to its qutrit (right) component. -/
def projectQutrit (v : QubitPlusQutrit) : Qutrit :=
  fun i => v (Sum.inr i)

/-- Reconstruct a `QubitPlusQutrit` vector from qubit and qutrit components. -/
def reconstruct (q2 : Qubit) (q3 : Qutrit) : QubitPlusQutrit :=
  Sum.elim q2 q3

/-- Round-trip: project then reconstruct gives back the original vector. -/
theorem reconstruct_project (v : QubitPlusQutrit) :
    reconstruct (projectQubit v) (projectQutrit v) = v := by
  ext (i | i) <;> simp [reconstruct, projectQubit, projectQutrit]

/-- Round-trip: reconstruct then project to qubit gives back the qubit. -/
theorem projectQubit_reconstruct (q2 : Qubit) (q3 : Qutrit) :
    projectQubit (reconstruct q2 q3) = q2 := by
  ext i; simp [reconstruct, projectQubit]

/-- Round-trip: reconstruct then project to qutrit gives back the qutrit. -/
theorem projectQutrit_reconstruct (q2 : Qubit) (q3 : Qutrit) :
    projectQutrit (reconstruct q2 q3) = q3 := by
  ext i; simp [reconstruct, projectQutrit]

/-! ## 1×1 matrix = scalar matrix -/

/-- Any 1×1 complex matrix equals its scalar diagonal.
This reflects the fact that U(1) acts on the quunit space ℂ¹ by
scalar multiplication. -/
theorem quunit_matrix_eq_scalar
    (M : Matrix (Fin 1) (Fin 1) ℂ) :
    M = Matrix.diagonal (fun _ : Fin 1 => M 0 0) := by
  ext i j; fin_cases i; fin_cases j; simp

/-! ## SMBlockPredicate ↔ qubit/qutrit block decomposition -/

/-- `SMBlockPredicate M` is definitionally the qubit/qutrit block
decomposition: there exist a 2×2 unitary matrix `A` and a 3×3 unitary
matrix `B` such that `M = fromBlocks A 0 0 B`, `A` and `B` are unitary,
and `det(A) * det(B) = 1`. This theorem makes the equivalence explicit. -/
theorem smBlockPredicate_is_qubit_qutrit_block
    {M : GUTMatrix} :
    SMBlockPredicate M ↔
      ∃ A : Matrix (Fin 2) (Fin 2) ℂ,
      ∃ B : Matrix (Fin 3) (Fin 3) ℂ,
        M = Matrix.fromBlocks A 0 0 B ∧
        IsUnitary A ∧ IsUnitary B ∧ A.det * B.det = 1 := by
  rfl

/-! ## Bundled dictionary package -/

/-- A bundled record tying the quunit/qubit/qutrit dictionary to the
Z₆ kernel scaffold. -/
structure QunitQubitQutritDictionaryPackage where
  /-- The covering kernel has exactly six elements. -/
  kernel_card : Fintype.card CoveringKernelElt = 6
  /-- The six unit-level kernel elements. -/
  unit_kernel_family : Fin 6 → UnitCoveringKernelElt
  /-- Each unit kernel element maps to the identity under the covering
      image homomorphism. -/
  unit_kernel_maps_to_one :
    ∀ i : Fin 6,
      unitCoveringTripleImageGroupHom
        ((unit_kernel_family i).toUnitCoveringTriple) = 1
  /-- `SMBlockPredicate` is the qubit/qutrit block decomposition. -/
  sm_block_iff :
    ∀ M : GUTMatrix,
      SMBlockPredicate M ↔
        ∃ A : Matrix (Fin 2) (Fin 2) ℂ,
        ∃ B : Matrix (Fin 3) (Fin 3) ℂ,
          M = Matrix.fromBlocks A 0 0 B ∧
          IsUnitary A ∧ IsUnitary B ∧ A.det * B.det = 1

/-- The quunit/qubit/qutrit dictionary package, instantiated from
individually verified project theorems. -/
noncomputable def quunitQubitQutritDictionaryPackage :
    QunitQubitQutritDictionaryPackage where
  kernel_card := standardModelCoveringKernel_card
  unit_kernel_family := sixUnitCoveringKernelElts
  unit_kernel_maps_to_one := sixUnitCoveringKernelElts_image_eq_one
  sm_block_iff := fun _ => smBlockPredicate_is_qubit_qutrit_block

end PhysicsSM.Gauge.QunitQubitQutritDictionary
