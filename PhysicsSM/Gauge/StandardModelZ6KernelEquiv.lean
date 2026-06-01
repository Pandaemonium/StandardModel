import Mathlib
import PhysicsSM.Gauge.StandardModelZ6FiniteKernel

/-!
# Gauge.StandardModelZ6KernelEquiv

Equivalence and cardinality packaging for the ℤ₆ kernel of the Standard Model
covering map.

## Mathematical context

The covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))` has
kernel consisting of exactly six elements. The bijection
`sixCoveringKernelElts : Fin 6 → CoveringKernelElt` was proved in
`StandardModelZ6FiniteKernel`. This module packages it as:

1. An explicit `Equiv` from `Fin 6` to `CoveringKernelElt` (and its inverse).
2. A `Fintype` instance on `CoveringKernelElt`.
3. A cardinality theorem: `Fintype.card CoveringKernelElt = 6`.

## Claim boundary

This is finite set/equivalence packaging only. No quotient group, Lie group,
or first-isomorphism theorem is claimed.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.BlockEmbeddings

/-! ## Equivalences -/

/--
Explicit equivalence from `Fin 6` to `CoveringKernelElt`, built from the
bijection `sixCoveringKernelElts`.
-/
noncomputable def fin6EquivCoveringKernelElt :
    Fin 6 ≃ CoveringKernelElt :=
  Equiv.ofBijective sixCoveringKernelElts sixCoveringKernelElts_bijective

/--
The forward direction of the equivalence agrees with `sixCoveringKernelElts`.
-/
theorem fin6EquivCoveringKernelElt_apply (k : Fin 6) :
    fin6EquivCoveringKernelElt k = sixCoveringKernelElts k := by
  rfl

/--
The inverse equivalence: `CoveringKernelElt ≃ Fin 6`.
-/
noncomputable def coveringKernelEltEquivFin6 :
    CoveringKernelElt ≃ Fin 6 :=
  fin6EquivCoveringKernelElt.symm

/-! ## Fintype and cardinality -/

/--
`CoveringKernelElt` is a finite type with exactly 6 elements.
-/
noncomputable instance : Fintype CoveringKernelElt :=
  Fintype.ofEquiv (Fin 6) fin6EquivCoveringKernelElt

/--
The cardinality of `CoveringKernelElt` is 6.
-/
theorem coveringKernelElt_card :
    Fintype.card CoveringKernelElt = 6 := by
  have h := Fintype.card_congr fin6EquivCoveringKernelElt
  simpa using h.symm

/-! ## Roundtrip wrappers -/

/--
Applying `sixCoveringKernelElts` to the inverse of the equivalence recovers
the original kernel element.
-/
theorem coveringKernelElt_eq_sixCoveringKernelElts
    (k : CoveringKernelElt) :
    sixCoveringKernelElts (coveringKernelEltEquivFin6 k) = k := by
  exact Function.surjInv_eq (Function.Bijective.surjective sixCoveringKernelElts_bijective) k

/--
The kernel phase of the inverse index equals the original kernel element's phase.
-/
theorem coveringKernelElt_phase_eq_kernelPhase
    (k : CoveringKernelElt) :
    kernelPhases (coveringKernelEltEquivFin6 k) = k.phase := by
  exact congr_arg CoveringKernelElt.phase
    (coveringKernelElt_eq_sixCoveringKernelElts k)

end PhysicsSM.Gauge.StandardModelSubgroup
