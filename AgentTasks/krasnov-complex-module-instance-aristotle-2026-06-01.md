# Aristotle task: Krasnov complex module typeclass instance

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `a361d338-aece-4776-871b-71e726c3754d`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave10-20260601-project`
**Output**:
**Integrated**:
**Type**: Krasnov octonionic-qubit complex vector-space API

## Goal

Upgrade the Krasnov complex-structure theorem island from packaged scalar laws
to actual Lean typeclass instances where feasible.

The current `KrasnovComplexModule.lean` proves that
`complexSmul z q = z.re • q + z.im • rightMulE111 q` satisfies the expected
complex scalar laws, but it does not install `SMul Complex OctonionicQubit`,
`AddCommGroup OctonionicQubit`, or `Module Complex OctonionicQubit`.

## Requested file

Create:

```text
PhysicsSM/Spinor/KrasnovComplexModuleInstance.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Spinor.KrasnovComplexModule
```

Use namespace:

```lean
namespace PhysicsSM.Spinor.KrasnovComplexStructure
```

Do not edit `PhysicsSM.lean`; Codex will add imports during integration.

## Target declarations

If possible, define:

```lean
noncomputable instance : SMul Complex OctonionicQubit where
  smul z q := complexSmul z q
```

If `OctonionicQubit` lacks additive typeclasses, install the componentwise
instances needed for a module:

```lean
instance : AddCommGroup OctonionicQubit := ...
noncomputable instance : Module Complex OctonionicQubit := ...
```

The instance should use the existing theorem names:

- `complexSmul_one`
- `complexSmul_mul`
- `complexSmul_add_left`
- `complexSmul_add_right`
- `complexSmul_zero_left`
- `complexSmul_zero_right`

Add simp wrappers:

```lean
@[simp] theorem complex_smul_def (z : Complex) (q : OctonionicQubit) :
    z • q = complexSmul z q := rfl

theorem rightMulE111_eq_I_smul (q : OctonionicQubit) :
    rightMulE111 q = Complex.I • q := ...
```

Then restate the centralizer theorem using actual scalar notation:

```lean
theorem commutesWithRightMulE111_iff_map_complex_smul
    (T : OctonionicQubit -> OctonionicQubit)
    (hT_lin : IsRealLinear T) :
    CommutesWithRightMulE111 T <->
      forall z : Complex, forall q : OctonionicQubit,
        T (z • q) = z • T q := ...
```

## Package

Add:

```lean
structure KrasnovComplexModuleInstancePackage where
  module_inst : Module Complex OctonionicQubit
  I_smul :
    forall q : OctonionicQubit, rightMulE111 q = Complex.I • q

noncomputable def krasnovComplexModuleInstancePackage :
    KrasnovComplexModuleInstancePackage := ...
```

If installing a global `Module Complex OctonionicQubit` instance conflicts with
existing project instances, use a local wrapper type instead and document that
choice.

## Claim boundary

This is a complex vector-space API for the Krasnov qubit. It does not prove a
Spin(9) representation theorem, a Standard Model centralizer theorem, or a
physical chirality result.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not change `rightMulE111`.
- Do not edit `PhysicsSM.lean`.
- If a global instance creates conflicts, switch to a wrapper type rather than
  forcing the instance.

## Verification

Run:

```bash
lake build PhysicsSM.Spinor.KrasnovComplexModuleInstance
```
