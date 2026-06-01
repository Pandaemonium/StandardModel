import Mathlib
import PhysicsSM.Gauge.StandardModelZ6KernelEquiv

/-!
# Gauge.StandardModelZ6KernelMap

Hypothesis-free wrappers for the covering-map kernel theorem.

## Mathematical context

Every `CoveringKernelElt` has phase satisfying `phase ^ 6 = 1`, so its phase
is automatically nonzero. This module packages that fact and gives simpler
wrappers for the covering-map kernel theorem, removing the manual `phase ≠ 0`
hypothesis from `coveringKernel_maps_to_one`.

## Claim boundary

This is still only the algebraic finite-kernel package. No quotient group,
Lie group, or first-isomorphism theorem is claimed.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.BlockEmbeddings

/-! ## Automatic nonzero phase -/

/--
The phase of a `CoveringKernelElt` is nonzero. This follows from `phase ^ 6 = 1`:
if `phase = 0` then `0 ^ 6 = 1`, which is absurd.
-/
theorem CoveringKernelElt.phase_ne_zero (k : CoveringKernelElt) :
    k.phase ≠ 0 := by
  cases k ; aesop

/-! ## Hypothesis-free covering map theorem -/

/--
Every `CoveringKernelElt` maps to `(1, 1)` under the covering map,
without requiring a manual nonzero hypothesis.
-/
theorem coveringKernel_maps_to_one_auto (k : CoveringKernelElt) :
    coveringMap k.phase k.su2Part k.su3Part = (1, 1) :=
  coveringKernel_maps_to_one k k.phase_ne_zero

/-! ## Six-element enumeration wrappers -/

/--
Each of the six explicit covering kernel elements maps to `(1, 1)`.
-/
theorem sixCoveringKernelElts_maps_to_one (i : Fin 6) :
    coveringMap
      (sixCoveringKernelElts i).phase
      (sixCoveringKernelElts i).su2Part
      (sixCoveringKernelElts i).su3Part = (1, 1) :=
  coveringKernel_maps_to_one_auto (sixCoveringKernelElts i)

/--
Each element via the `Fin 6 ≃ CoveringKernelElt` equivalence maps to `(1, 1)`.
-/
theorem fin6EquivCoveringKernelElt_maps_to_one (i : Fin 6) :
    coveringMap
      (fin6EquivCoveringKernelElt i).phase
      (fin6EquivCoveringKernelElt i).su2Part
      (fin6EquivCoveringKernelElt i).su3Part = (1, 1) :=
  coveringKernel_maps_to_one_auto (fin6EquivCoveringKernelElt i)

/-! ## InSU2U3 wrapper -/

/--
Every `CoveringKernelElt` has its SU(2) and SU(3) parts in `InSU2U3`.
This is a naming wrapper for `coveringKernelElt_inSU2U3` for discoverability.
-/
theorem coveringKernelElt_inSU2U3_auto (k : CoveringKernelElt) :
    InSU2U3 k.su2Part k.su3Part :=
  coveringKernelElt_inSU2U3 k

end PhysicsSM.Gauge.StandardModelSubgroup
