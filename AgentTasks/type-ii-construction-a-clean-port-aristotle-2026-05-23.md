# Type II Construction A clean package port - 2026-05-23

Status: complete and integrated.

Purpose: port the already-proved general Type II Construction A theorem from
the legacy/draft namespace into the clean `CodeLatticeE8` publication package.

## Background

The older Aristotle job
`0b21f2ce-dbc5-4c71-82a7-e10caf4938e0` completed the general theorem in:

```text
PhysicsSM/Draft/ConstructionATypeIIAristotle.lean
```

That file is useful source material, but it is not reviewer-facing: it imports
`PhysicsSM.*`, uses legacy names such as `constructionA`, and lives in the
draft namespace.

The clean package already has the coding-theory and integral Construction A
pieces:

```text
CodeLatticeE8/Code/Binary.lean
CodeLatticeE8/Code/Dual.lean
CodeLatticeE8/ConstructionA/Basic.lean
CodeLatticeE8/ConstructionA/Norm.lean
CodeLatticeE8/ConstructionA/Even.lean
```

In particular, `CodeLatticeE8.ConstructionA.sqNorm_dvd_four_of_doublyEven`
already proves the integral evenness half for arbitrary doubly-even binary
codes.

## Requested output

Create a polished clean package module:

```text
CodeLatticeE8/ConstructionA/TypeII.lean
```

The file should import only `CodeLatticeE8.*` modules and Mathlib.  It must not
import `PhysicsSM.*`.

The goal is to port the strongest useful theorem cluster from the legacy proof,
renamed and documented in the clean package style.  A good target cluster is:

```lean
namespace CodeLatticeE8.ConstructionA

open CodeLatticeE8.Code

def intDot {n : Nat} (x y : Fin n -> Int) : Int := ...

theorem intDot_cast_zmod_two_eq_binaryDot_reduce {n : Nat}
    (x y : Fin n -> Int) :
    ((intDot x y : Int) : ZMod 2) =
      binaryDot (reduceModTwo x) (reduceModTwo y)

def binaryLift {n : Nat} (v : BinaryVector n) : Fin n -> Int := ...

theorem reduceModTwo_binaryLift {n : Nat} (v : BinaryVector n) :
    reduceModTwo (binaryLift v) = v

theorem binaryLift_mem_lattice {n : Nat} (C : BinaryLinearCode n)
    {v : BinaryVector n} (hv : v ∈ C) :
    binaryLift v ∈ lattice C

def scaledDualInt {n : Nat}
    (C : BinaryLinearCode n) : AddSubgroup (Fin n -> Int) := ...

theorem scaledDualInt_eq_lattice_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    scaledDualInt C = lattice C

theorem typeII_integer_package {n : Nat}
    (C : BinaryLinearCode n) (hC : IsTypeII C) :
    (forall z : Fin n -> Int, z ∈ lattice C ->
      exists k : Int, sqNorm z = 4 * k) /\
    scaledDualInt C = lattice C

noncomputable def scaledRealLinearMap (n : Nat) :
    (Fin n -> Int) →ₗ[Int] (Fin n -> Real) := ...

noncomputable def scaledReal {n : Nat}
    (C : BinaryLinearCode n) : Submodule Int (Fin n -> Real) := ...

noncomputable def realDot {n : Nat} (x y : Fin n -> Real) : Real := ...

noncomputable def scaledRealDual {n : Nat}
    (C : BinaryLinearCode n) : Set (Fin n -> Real) := ...

theorem scaledReal_even_of_doublyEven {n : Nat}
    (C : BinaryLinearCode n) (hC : IsDoublyEven C) :
    forall x : Fin n -> Real, x ∈ scaledReal C ->
      exists k : Int, realDot x x = (2 * k : Real)

theorem scaledRealDual_eq_self_of_selfDual {n : Nat}
    (C : BinaryLinearCode n) (hC : IsSelfDual C) :
    scaledRealDual C = (scaledReal C : Set (Fin n -> Real))

end CodeLatticeE8.ConstructionA
```

The names above are suggestions.  Prefer names that fit the existing clean
package style if a different spelling is clearer.

## Style and trust constraints

- No `sorry`, `admit`, `axiom`, or `unsafe`.
- Do not weaken the theorem statements merely to make the port easier.
- Keep the module reviewer-friendly: include a module docstring and concise
  theorem docstrings explaining the normalization.
- Avoid job/provenance names in declarations.
- Do not make `CodeLatticeE8` depend on `PhysicsSM`.
- If the full real bridge is too large, produce the strongest sorry-free
  integral theorem cluster and explain the remaining real-scaling gap in this
  task note or a separate handoff comment.  Do not add sorries to
  `CodeLatticeE8`.

## Verification target

At minimum, the resulting file should pass:

```text
lake build CodeLatticeE8.ConstructionA.TypeII
```

If the root import is updated, also run:

```text
lake build CodeLatticeE8
```

## Local verification before submission

These commands passed before the job was submitted:

```text
lake build PhysicsSM.Draft.ConstructionATypeIIAristotle
lake build CodeLatticeE8
```

## Submission package

```text
AgentTasks/aristotle-submit/type-ii-construction-a-clean-port-20260523-project
```

Prepared with:

```text
powershell -ExecutionPolicy Bypass -File Scripts/prepare_aristotle_submission.ps1 -JobName type-ii-construction-a-clean-port-20260523 -TaskNote AgentTasks/type-ii-construction-a-clean-port-aristotle-2026-05-23.md -ExtraPath "CodeLatticeE8,CodeLatticeE8.lean,CodeLatticeE8SPL.lean,CodeLatticeE8Draft.lean" -CheckPath "PhysicsSM/Draft/ConstructionATypeIIAristotle.lean,CodeLatticeE8/ConstructionA/Even.lean,CodeLatticeE8/Code/Dual.lean"
```

## Submitted job

| Job | Aristotle ID | Status at submission check |
|-----|--------------|----------------------------|
| Type II Construction A clean package port | `df2b5ccf-23e3-42dc-988b-db4c6f8639b6` | complete |

Submission confirmed with:

```text
aristotle list
```

## Integration result

Status: integrated on 2026-05-23.

Result fetched with:

```text
aristotle result df2b5ccf-23e3-42dc-988b-db4c6f8639b6 --destination AgentTasks\aristotle-output\type-ii-construction-a-clean-port-20260523
```

The Aristotle result archive was extracted to:

```text
AgentTasks\aristotle-output\type-ii-construction-a-clean-port-20260523-extracted
```

Integrated file:

```text
CodeLatticeE8/ConstructionA/TypeII.lean
```

The new clean package declarations include:

```lean
CodeLatticeE8.ConstructionA.typeII_integer_package
CodeLatticeE8.ConstructionA.scaledReal_even_of_doublyEven
CodeLatticeE8.ConstructionA.scaledRealDual_eq_self_of_selfDual
```

The theorem index, publication theorem map, trust report, and manuscript were
updated to cite the new clean-package Type II theorem instead of describing it
as future work.

Verification after integration:

```text
lake build CodeLatticeE8.ConstructionA.TypeII
lake build CodeLatticeE8
cd CodeLatticeE8Standalone; lake build CodeLatticeE8
lake build
```

An axiom audit for `typeII_integer_package`,
`scaledReal_even_of_doublyEven`, and `scaledRealDual_eq_self_of_selfDual`
reported only `[propext, Classical.choice, Quot.sound]`.
