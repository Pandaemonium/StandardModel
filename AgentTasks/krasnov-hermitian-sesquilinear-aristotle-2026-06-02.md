# Aristotle task: Krasnov Hermitian form is ℂ-sesquilinear

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `41840580-49ce-4bf9-a47c-39155a387b50`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave5-20260602`
**Output**: `AgentTasks/aristotle-output/krasnov-hermitian-sesquilinear-20260602`
**Type**: Krasnov bridge — ℂ-sesquilinearity of the qubit Hermitian form

## Goal

Create a new trusted file:

```text
PhysicsSM/Spinor/KrasnovHermitianSesquilinear.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Spinor.KrasnovQubitHermitian
import PhysicsSM.Spinor.KrasnovComplexModuleInstance
```

and namespace:

```lean
namespace PhysicsSM.Spinor.KrasnovComplexStructure
```

## Mathematical context

The `KrasnovQubitHermitian.lean` module defines `flatHermitian` (a Hermitian
form on the coordinate space `Fin 8 → ℂ`) and `flatNormSq`. The
`KrasnovComplexModuleInstance.lean` module provides `Module ℂ OctonionicQubit`
and the key identification `rightMulE111 q = Complex.I • q`.

The missing piece: prove that `flatHermitian` is **ℂ-sesquilinear**,
meaning it is ℂ-linear in the second argument and ℂ-antilinear (conjugate-
linear) in the first. This is the fundamental property of a complex Hermitian
form, and it bridges the real inner product structure to the ℂ-module structure.

## Existing infrastructure

From `KrasnovQubitHermitian.lean`:

```lean
-- Hermitian form on flattened coordinates:
noncomputable def QubitComplexCoordinates.flatHermitian
    (q r : Fin 8 → ℂ) : ℂ :=
  ∑ k, starRingEnd ℂ (q k) * r k

-- Squared norm:
noncomputable def QubitComplexCoordinates.flatNormSq (q : Fin 8 → ℂ) : ℝ
```

From `KrasnovComplexModuleInstance.lean`:

```lean
-- Already proved:
instance : Module ℂ OctonionicQubit
theorem rightMulE111_eq_I_smul (q : OctonionicQubit) :
    rightMulE111 q = Complex.I • q
```

From `KrasnovQubitComplexCoordinates.lean`:

```lean
-- The flattening map:
noncomputable def QubitComplexCoordinates.flattenQubit :
    OctonionicQubit → (Fin 8 → ℂ)
```

## Target declarations

### Sesquilinearity

```lean
/-- `flatHermitian` is ℂ-linear in the second argument. -/
theorem flatHermitian_linear_right
    (q : Fin 8 → ℂ) (z : ℂ) (r₁ r₂ : Fin 8 → ℂ) :
    flatHermitian q (z • r₁ + r₂) =
      z * flatHermitian q r₁ + flatHermitian q r₂

/-- `flatHermitian` is ℂ-conjugate-linear in the first argument. -/
theorem flatHermitian_antilinear_left
    (z : ℂ) (q : Fin 8 → ℂ) (r : Fin 8 → ℂ) :
    flatHermitian (z • q) r = starRingEnd ℂ z * flatHermitian q r

/-- `flatHermitian` is Hermitian symmetric. -/
theorem flatHermitian_conj_symm (q r : Fin 8 → ℂ) :
    flatHermitian q r = starRingEnd ℂ (flatHermitian r q)

/-- `flatHermitian` is positive semidefinite. -/
theorem flatHermitian_pos_semidef (q : Fin 8 → ℂ) :
    0 ≤ (flatHermitian q q).re ∧ (flatHermitian q q).im = 0
```

### Sesquilinearity on OctonionicQubit via the module structure

Using `flattenQubit` and `Module ℂ OctonionicQubit`:

```lean
/-- `flatHermitian` on OctonionicQubit is ℂ-linear in the second argument. -/
theorem flatHermitian_linear_right_qubit
    (q : OctonionicQubit) (z : ℂ) (r₁ r₂ : OctonionicQubit) :
    flatHermitian (flattenQubit q) (flattenQubit (z • r₁ + r₂)) =
      z * flatHermitian (flattenQubit q) (flattenQubit r₁) +
        flatHermitian (flattenQubit q) (flattenQubit r₂)

/-- `flatHermitian` on OctonionicQubit is conjugate-linear in the first. -/
theorem flatHermitian_antilinear_left_qubit
    (z : ℂ) (q r : OctonionicQubit) :
    flatHermitian (flattenQubit (z • q)) (flattenQubit r) =
      starRingEnd ℂ z * flatHermitian (flattenQubit q) (flattenQubit r)
```

### J preserves the Hermitian form

Using `rightMulE111_eq_I_smul`:

```lean
/-- Right multiplication by e111 (= i •) preserves the Hermitian norm. -/
theorem flatHermitian_J_invariant (q : OctonionicQubit) :
    flatHermitian (flattenQubit (rightMulE111 q)) (flattenQubit (rightMulE111 q)) =
      flatHermitian (flattenQubit q) (flattenQubit q)
```

This follows from: `rightMulE111 q = i • q`, and
`flatHermitian (i • q) (i • q) = conj(i) * i * flatHermitian q q = |i|² * flatHermitian q q = flatHermitian q q`.

### Bundled package

```lean
structure KrasnovHermitianSesquilinearPackage where
  /-- Sesquilinearity: linear in second argument. -/
  linear_right :
    ∀ (q : Fin 8 → ℂ) (z : ℂ) (r₁ r₂ : Fin 8 → ℂ),
      flatHermitian q (z • r₁ + r₂) =
        z * flatHermitian q r₁ + flatHermitian q r₂
  /-- Sesquilinearity: conjugate-linear in first argument. -/
  antilinear_left :
    ∀ (z : ℂ) (q r : Fin 8 → ℂ),
      flatHermitian (z • q) r = starRingEnd ℂ z * flatHermitian q r
  /-- Hermitian symmetry. -/
  conj_symm :
    ∀ (q r : Fin 8 → ℂ),
      flatHermitian q r = starRingEnd ℂ (flatHermitian r q)
  /-- J (= rightMulE111) preserves the norm. -/
  J_norm_preserving :
    ∀ q : OctonionicQubit,
      flatHermitian (flattenQubit (rightMulE111 q)) (flattenQubit (rightMulE111 q)) =
        flatHermitian (flattenQubit q) (flattenQubit q)

noncomputable def krasnovHermitianSesquilinearPackage :
    KrasnovHermitianSesquilinearPackage
```

## Claim boundary

This file proves sesquilinearity and J-invariance of the Krasnov Hermitian
form. It does **not** prove:
- That the isometry group of the form is U(8).
- Any intersection with Spin(9).
- The Standard Model gauge group centralizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- The proofs of `flatHermitian_linear_right` and `flatHermitian_antilinear_left`
  are direct calculations from the definition `∑ k, conj(q k) * r k`.
- Add to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Spinor/KrasnovHermitianSesquilinear.lean
lake build PhysicsSM.Spinor.KrasnovHermitianSesquilinear
```
