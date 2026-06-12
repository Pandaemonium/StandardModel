# Aristotle task: quunit/qubit/qutrit dictionary for the SM gauge group

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `a65f5986-4e20-4e7a-abb6-d53339e6e80f`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave10-20260601-project`
**Output**:
**Integrated**:
**Type**: Baez quunit/qubit/qutrit expository theorem island

## Goal

Create a precise Lean-facing dictionary for Baez's public-lecture slogan that
`U(1)`, `SU(2)`, and `SU(3)` are related to quunits, qubits, and qutrits.

This should be an expository theorem island connecting:

```text
quunit  = C
qubit   = C^2
qutrit  = C^3
C^5     = C^2 ⊕ C^3
S(U(2) x U(3)) as the determinant-one block group on C^2 ⊕ C^3
(U(1) x SU(2) x SU(3)) / Z6 as the product-cover presentation
```

## Requested file

Create:

```text
PhysicsSM/Gauge/QunitQubitQutritDictionary.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelGroupStructure
import PhysicsSM.Gauge.StandardModelZ6KernelPackage
import PhysicsSM.Gauge.StandardModelUnitZ6Kernel
import PhysicsSM.Gauge.StandardModelCoverageImageSMBlock
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.QunitQubitQutritDictionary
```

Do not edit `PhysicsSM.lean`; Codex will add imports during integration.

## Target declarations

Define the three complex state-space aliases:

```lean
abbrev Qunit := Fin 1 -> Complex
abbrev Qubit := Fin 2 -> Complex
abbrev Qutrit := Fin 3 -> Complex
abbrev QubitPlusQutrit := (Fin 2 ⊕ Fin 3) -> Complex
```

Add the block-sum equivalence:

```lean
noncomputable def qubitPlusQutritEquiv :
    QubitPlusQutrit ≃ₗ[Complex] (Qubit × Qutrit) := ...
```

or, if a linear equivalence is too much, an ordinary equivalence plus
coordinate projection/reconstruction theorems.

Record the unitary matrix dimensions:

```lean
theorem quunit_matrix_eq_scalar
    (M : Matrix (Fin 1) (Fin 1) Complex) :
    M = Matrix.diagonal (fun _ : Fin 1 => M 0 0) := ...
```

Prove block facts linking to the existing SM predicate:

```lean
theorem smBlockPredicate_is_qubit_qutrit_block
    {M : GUTMatrix} :
    SMBlockPredicate M <->
      exists A : Matrix (Fin 2) (Fin 2) Complex,
      exists B : Matrix (Fin 3) (Fin 3) Complex,
        M = Matrix.fromBlocks A 0 0 B /\
        IsUnitary A /\ IsUnitary B /\ A.det * B.det = 1 := ...
```

This theorem may just re-export the definition of `SMBlockPredicate` if that is
already definitional.

Add package fields tying the dictionary to the Z6 scaffold:

```lean
structure QunitQubitQutritDictionaryPackage where
  kernel_card : Fintype.card CoveringKernelElt = 6
  unit_kernel_family : Fin 6 -> UnitCoveringKernelElt
  unit_kernel_maps_to_one :
    forall i : Fin 6,
      unitCoveringTripleImageGroupHom
        ((unit_kernel_family i).toUnitCoveringTriple) = 1
  sm_block_iff :
    forall M : GUTMatrix,
      SMBlockPredicate M <->
        exists A : Matrix (Fin 2) (Fin 2) Complex,
        exists B : Matrix (Fin 3) (Fin 3) Complex,
          M = Matrix.fromBlocks A 0 0 B /\
          IsUnitary A /\ IsUnitary B /\ A.det * B.det = 1

noncomputable def quunitQubitQutritDictionaryPackage :
    QunitQubitQutritDictionaryPackage := ...
```

## Documentation

The module docstring should be careful:

- This is representation geometry and finite-dimensional complex linear algebra.
- It does not claim the Standard Model is a quantum-computing system.
- It explains why the same `C`, `C^2`, and `C^3` spaces behind quunits,
  qubits, and qutrits also underlie the `U(1)`, `SU(2)`, and `SU(3)` gauge
  factors.
- It should cite Baez's public lecture "Standard Model - Part 3: Qubits" and
  the Baez/Huerta `S(U(2) x U(3))` / `Z6` presentation.

## Claim boundary

This is a dictionary and theorem-index module. It should not prove or claim new
physics, compact Lie group quotient topology, or the full DVT stabilizer
theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Prefer wrappers around existing theorems over restating large proofs.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake build PhysicsSM.Gauge.QunitQubitQutritDictionary
```
