import Mathlib
import PhysicsSM.Gauge.StandardModelZ6KernelMap

/-!
# Gauge.StandardModelZ6KernelPackage

Citation-friendly theorem package for the finite ℤ₆ kernel of the Standard
Model covering map.

## Mathematical context

The covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))`,
given by `ι(α, g, h) = (α³ · g, α⁻² · h)`, has kernel isomorphic to ℤ₆.
This module collects the key trusted results into a single discoverable
landing page.

### Results collected here

1. **Cardinality**: `CoveringKernelElt` has exactly 6 elements.
2. **Equivalence**: `CoveringKernelElt ≃ Fin 6` (and vice versa).
3. **Maps to identity**: every kernel element maps to `(1, 1)` under the
   covering map.
4. **InSU2U3**: the SU(2) and SU(3) parts of every kernel element satisfy
   the determinant-one conditions.

## Claim boundary

This package identifies the finite kernel type with six elements and proves
that its elements map to identity under the project covering map. It does
**not** prove a quotient-group isomorphism
`(U(1) × SU(2) × SU(3)) / ℤ₆ ≅ S(U(2) × U(3))`.

Status: trusted theorem package; all proofs are wrappers around existing
verified results.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.BlockEmbeddings

/-! ## Equivalence -/

/--
The covering kernel type `CoveringKernelElt` is equivalent to `Fin 6`.
-/
theorem standardModelCoveringKernel_equiv_fin6 :
    Nonempty (CoveringKernelElt ≃ Fin 6) :=
  ⟨coveringKernelEltEquivFin6⟩

/-! ## Cardinality -/

/--
The covering kernel has exactly six elements.
-/
theorem standardModelCoveringKernel_card :
    Fintype.card CoveringKernelElt = 6 :=
  coveringKernelElt_card

/-! ## Covering-map kernel membership -/

/--
Every `CoveringKernelElt` maps to `(1, 1)` under the covering map.
-/
theorem standardModelCoveringKernel_maps_to_identity
    (k : CoveringKernelElt) :
    coveringMap k.phase k.su2Part k.su3Part = (1, 1) :=
  coveringKernel_maps_to_one_auto k

/--
Every `CoveringKernelElt` has its SU(2) and SU(3) parts satisfying the
determinant-one conditions (`InSU2U3`).
-/
theorem standardModelCoveringKernel_in_SU2_U3
    (k : CoveringKernelElt) :
    InSU2U3 k.su2Part k.su3Part :=
  coveringKernelElt_inSU2U3_auto k

/-! ## Six-element enumeration -/

/--
Each of the six explicit kernel elements maps to `(1, 1)`.
-/
theorem standardModelSixKernelElts_maps_to_identity
    (i : Fin 6) :
    coveringMap
      (sixCoveringKernelElts i).phase
      (sixCoveringKernelElts i).su2Part
      (sixCoveringKernelElts i).su3Part = (1, 1) :=
  sixCoveringKernelElts_maps_to_one i

/-! ## Bundled package -/

/--
A bundled record collecting the key finite-kernel results for the
Standard Model covering map.
-/
structure StandardModelZ6KernelPackage where
  /-- The covering kernel has exactly six elements. -/
  card_six : Fintype.card CoveringKernelElt = 6
  /-- Every kernel element maps to `(1, 1)` under the covering map. -/
  maps_to_identity :
    ∀ k : CoveringKernelElt,
      coveringMap k.phase k.su2Part k.su3Part = (1, 1)
  /-- Every kernel element satisfies the determinant-one conditions. -/
  in_SU2_U3 :
    ∀ k : CoveringKernelElt,
      InSU2U3 k.su2Part k.su3Part

/--
The Standard Model ℤ₆ covering-kernel package, instantiated from the
individually proved theorems.
-/
theorem standardModelZ6KernelPackage :
    StandardModelZ6KernelPackage :=
  { card_six := standardModelCoveringKernel_card
    maps_to_identity := standardModelCoveringKernel_maps_to_identity
    in_SU2_U3 := standardModelCoveringKernel_in_SU2_U3 }

end PhysicsSM.Gauge.StandardModelSubgroup
