# Aristotle task: exact Z6 kernel for the true product covering

Date: 2026-06-04

## Goal

Create a trusted Lean module:

```text
PhysicsSM/Gauge/StandardModelProductCoveringTrueZ6Kernel.lean
```

Use the already trusted true product-covering quotient API to prove that the
six explicit kernel elements are exactly the identity fiber of
`smTrueProductCoveringTripleToSMBlockUnits`.

## Context

Relevant modules:

- `PhysicsSM.Gauge.StandardModelProductCoveringTriple`
- `PhysicsSM.Gauge.StandardModelProductCoveringTrueQuotientSMBlock`
- `PhysicsSM.Gauge.StandardModelUnitZ6Kernel`
- `PhysicsSM.Gauge.StandardModelUnitZ6QuotientGroup`

Existing declarations to inspect:

- `SMProductCoveringTriple`
- `smProductCoveringKernelElt : Fin 6 -> SMProductCoveringTriple`
- `smProductCoveringKernelElt_image_eq_one`
- `smProductCoveringKernelElt_injective`
- `smTrueProductCoveringTripleToSMBlockUnits`
- `SMProductCoveringTriple.TrueImageEquivalent`
- `SMTrueProductCoveringQuotient`
- `smTrueProductCoveringQuotientMulEquivSMBlockUnits`

## Target theorems

Prefer these theorem names if they typecheck naturally:

```lean
theorem smProductCoveringKernelElt_trueImage_eq_one (i : Fin 6) :
    smTrueProductCoveringTripleToSMBlockUnits (smProductCoveringKernelElt i) = 1

theorem smTrueProductCoveringTripleToSMBlockUnits_eq_one_iff
    (x : SMProductCoveringTriple) :
    smTrueProductCoveringTripleToSMBlockUnits x = 1 <->
      exists i : Fin 6, x = smProductCoveringKernelElt i
```

If the second theorem is too strong because the existing API only has an image
quotient rather than a literal kernel normal subgroup, prove the strongest
available exact identity-fiber theorem after forwarding through
`x.toSMCoveringTriple.toUnitCoveringTriple`.

## Package

Bundle the result in:

```lean
structure StandardModelTrueProductZ6KernelPackage where
  kernel_family_maps_to_one :
    forall i : Fin 6,
      smTrueProductCoveringTripleToSMBlockUnits (smProductCoveringKernelElt i) = 1
  identity_fiber_exact :
    forall x : SMProductCoveringTriple,
      smTrueProductCoveringTripleToSMBlockUnits x = 1 <->
        exists i : Fin 6, x = smProductCoveringKernelElt i
```

If `identity_fiber_exact` is blocked, include the exact partial theorem in the
package and leave a documented draft/handoff note explaining the missing API.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelProductCoveringTrueZ6Kernel.lean
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave8-20260604`

Job ID: `e3d0328b-2c58-4173-984e-fa64a7832481`

## Result

Status: COMPLETE, integrated 2026-06-04.

Output archive:
`AgentTasks/aristotle-output/e3d0328b-output`

Extracted output:
`AgentTasks/aristotle-output/e3d0328b-output-extracted/paper-wave8-20260604_aristotle`

Integrated module:

```text
PhysicsSM/Gauge/StandardModelProductCoveringTrueZ6Kernel.lean
```

Top-level import added to `PhysicsSM.lean`.

Verification run after integration:

```bash
lake env lean PhysicsSM/Gauge/StandardModelProductCoveringTrueZ6Kernel.lean
```

One minor unused-`simp` warning in Aristotle's output was cleaned during
integration; the targeted check then passed without warnings.
