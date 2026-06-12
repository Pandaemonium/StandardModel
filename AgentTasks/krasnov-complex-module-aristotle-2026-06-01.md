# Aristotle task: OctonionicQubit ℂ-module structure

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `f8464758-386a-4381-a127-84ae40342a61`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave3-20260601`
**Output**: `AgentTasks/aristotle-output/krasnov-complex-module-20260601`
**Type**: Krasnov complex module — formalizing 𝕆² as ℂ⁸

## Goal

Create a new trusted file:

```text
PhysicsSM/Spinor/KrasnovComplexModule.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Spinor.KrasnovComplexCentralizer
```

and namespace:

```lean
namespace PhysicsSM.Spinor.KrasnovComplexStructure
```

Prove that `complexSmul` (already defined in `KrasnovComplexCentralizer.lean`)
gives `OctonionicQubit` the structure of a module over `ℂ`.

## Existing infrastructure

From `KrasnovComplexCentralizer.lean`:

```lean
-- Already defined:
noncomputable def complexSmul (z : ℂ) (q : OctonionicQubit) : OctonionicQubit :=
  z.re • q + z.im • rightMulE111 q
```

From `KrasnovComplexStructure.lean`:

```lean
-- Already proved:
theorem rightMulE111_sq_neg (q : OctonionicQubit) :
    rightMulE111 (rightMulE111 q) = -q
```

`OctonionicQubit` has: `Add`, `Neg`, `Zero`, `SMul ℝ`, and componentwise
`AddCommGroup` structure. The `rightMulE111` map is real-linear (proved in
`KrasnovComplexCentralizer.lean` via `OctonionicQubit_zero_smul` and
`OctonionicQubit_one_smul`).

## Target declarations

### Module laws

Prove the following in order:

```lean
/-- `complexSmul 1 q = q` -/
theorem complexSmul_one (q : OctonionicQubit) :
    complexSmul 1 q = q

/-- `complexSmul (z + w) q = complexSmul z q + complexSmul w q` -/
theorem complexSmul_add_left (z w : ℂ) (q : OctonionicQubit) :
    complexSmul (z + w) q = complexSmul z q + complexSmul w q

/-- `complexSmul z (q + r) = complexSmul z q + complexSmul z r` -/
theorem complexSmul_add_right (z : ℂ) (q r : OctonionicQubit) :
    complexSmul z (q + r) = complexSmul z q + complexSmul z r

/-- `complexSmul (z * w) q = complexSmul z (complexSmul w q)` -/
theorem complexSmul_mul (z w : ℂ) (q : OctonionicQubit) :
    complexSmul (z * w) q = complexSmul z (complexSmul w q)

/-- `complexSmul 0 q = 0` -/
theorem complexSmul_zero_left (q : OctonionicQubit) :
    complexSmul 0 q = 0

/-- `complexSmul z 0 = 0` -/
theorem complexSmul_zero_right (z : ℂ) :
    complexSmul z 0 = 0
```

### Key calculation for `complexSmul_mul`

The key identity needed is:

```text
complexSmul (z * w) q
  = (z * w).re • q + (z * w).im • J(q)
  = (z.re * w.re - z.im * w.im) • q + (z.re * w.im + z.im * w.re) • J(q)

complexSmul z (complexSmul w q)
  = complexSmul z (w.re • q + w.im • J(q))
  = z.re • (w.re • q + w.im • J(q)) + z.im • J(w.re • q + w.im • J(q))
  = (z.re * w.re) • q + (z.re * w.im) • J(q)
    + (z.im * w.re) • J(q) + (z.im * w.im) • J(J(q))
  = (z.re * w.re) • q + (z.re * w.im) • J(q)
    + (z.im * w.re) • J(q) + (z.im * w.im) • (-q)   [using J² = -id]
  = (z.re * w.re - z.im * w.im) • q
    + (z.re * w.im + z.im * w.re) • J(q)
```

These agree. The step uses `rightMulE111_sq_neg`.

### Module instance (optional)

If the module laws typecheck, try to register a `Module ℂ OctonionicQubit`
instance:

```lean
noncomputable instance : SMul ℂ OctonionicQubit := ⟨complexSmul⟩

noncomputable instance : Module ℂ OctonionicQubit where
  smul := complexSmul
  one_smul := complexSmul_one
  mul_smul := complexSmul_mul
  smul_add := complexSmul_add_right
  add_smul := complexSmul_add_left
  smul_zero := complexSmul_zero_right
  zero_smul := complexSmul_zero_left
```

If registering a full `Module` instance causes typeclass conflicts with the
existing `SMul ℝ OctonionicQubit`, package the laws as a structure instead:

```lean
structure KrasnovComplexModulePackage where
  complexSmul_one : ∀ q : OctonionicQubit, complexSmul 1 q = q
  complexSmul_mul : ∀ z w : ℂ, ∀ q : OctonionicQubit,
      complexSmul (z * w) q = complexSmul z (complexSmul w q)
  complexSmul_add_left : ∀ z w : ℂ, ∀ q : OctonionicQubit,
      complexSmul (z + w) q = complexSmul z q + complexSmul w q
  complexSmul_add_right : ∀ z : ℂ, ∀ q r : OctonionicQubit,
      complexSmul z (q + r) = complexSmul z q + complexSmul z r
```

## Claim boundary

This file proves the ℂ-module laws for the Krasnov complex structure. It
does **not** claim an orthonormal basis of ℂ⁸, a representation of
Spin(9), or a Standard Model gauge group identification.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- If the `Module ℂ` instance causes `simp` loops or typeclass conflicts,
  fall back to the bundled package structure.
- Add the new file to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Spinor/KrasnovComplexModule.lean
lake build PhysicsSM.Spinor.KrasnovComplexModule
```
