import Mathlib
import PhysicsSM.Gauge.StandardModelProductCoveringTrueQuotientSMBlock
import PhysicsSM.Gauge.StandardModelZ6FiniteKernel
import PhysicsSM.Gauge.StandardModelZ6Kernel

/-!
# Gauge.StandardModelProductCoveringTrueZ6Kernel

Exact ℤ₆ kernel for the true product-covering map
`smTrueProductCoveringTripleToSMBlockUnits`.

## Mathematical context

The covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))`
sends `(α, g, h)` to `(α³ · g, α⁻² · h)`. Its kernel consists of
triples `(α, α⁻³ · I₂, α² · I₃)` where `α⁶ = 1`.

This module proves that the six explicit kernel elements
`smProductCoveringKernelElt i` are **exactly** the identity fiber of
`smTrueProductCoveringTripleToSMBlockUnits`:

1. Each `smProductCoveringKernelElt i` maps to `1`.
2. If `smTrueProductCoveringTripleToSMBlockUnits x = 1`, then
   `x = smProductCoveringKernelElt i` for some `i : Fin 6`.

## Claim boundary

This is algebraic kernel identification. No topological quotient, smooth
Lie group theorem, compactness, or gauge-field dynamics is claimed.

Status: trusted theorem package; all proofs are complete.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.GUTSquare PhysicsSM.Gauge.BlockEmbeddings

/-! ## Forward: kernel elements map to one -/

/--
Each `smProductCoveringKernelElt i` maps to `1` under
`smTrueProductCoveringTripleToSMBlockUnits`.
-/
theorem smProductCoveringKernelElt_trueImage_eq_one (i : Fin 6) :
    smTrueProductCoveringTripleToSMBlockUnits (smProductCoveringKernelElt i) = 1 := by
  have h_image : (smProductCoveringKernelElt i).toSMCoveringTriple.toUnitCoveringTriple.image = (1, 1) := by
    convert smProductCoveringKernelElt_image_eq_one i using 1;
  unfold smTrueProductCoveringTripleToSMBlockUnits;
  unfold unitOfIsUnitary; aesop;

/-! ## Helper: image-one implies coveringMap is one -/

/-
If `smTrueProductCoveringTripleToSMBlockUnits x = 1`, then the unit-level
image pair equals `(1, 1)`.
-/
private theorem trueImage_eq_one_implies_unitImage_eq_one
    (x : SMProductCoveringTriple)
    (h : smTrueProductCoveringTripleToSMBlockUnits x = 1) :
    x.toSMCoveringTriple.toUnitCoveringTriple.image = (1, 1) := by
  simp_all +decide [smTrueProductCoveringTripleToSMBlockUnits, Subtype.ext_iff, Units.ext_iff];
  ext <;> simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
  · rename_i i j; fin_cases i <;> fin_cases j <;> simp +decide [ * ] ;
  · rename_i i j; fin_cases i <;> fin_cases j <;> simp +decide [ * ] ;

/-
If the unit-level image pair of an `SMProductCoveringTriple` is `(1, 1)`,
then its raw covering map output is `(1, 1)`.
-/
private theorem unitImage_eq_one_implies_coveringMap_eq_one
    (x : SMProductCoveringTriple)
    (h : x.toSMCoveringTriple.toUnitCoveringTriple.image = (1, 1)) :
    coveringMap (x.phase : ℂ) x.su2Part.unit.val x.su3Part.unit.val = (1, 1) := by
  unfold SMProductCoveringTriple.toSMCoveringTriple at h; simp_all +decide [ coveringMap ] ;
  unfold UnitCoveringTriple.image at h; simp_all +decide [ Units.ext_iff ] ;

/-
From covering-map-equals-one and the determinant-one constraints, obtain
a `CoveringKernelElt` matching `x`.
-/
private theorem coveringMap_one_implies_kernelElt
    (x : SMProductCoveringTriple)
    (h : coveringMap (x.phase : ℂ) x.su2Part.unit.val x.su3Part.unit.val = (1, 1)) :
    ∃ k : CoveringKernelElt,
      k.phase = (x.phase : ℂ) ∧
      x.su2Part.unit.val = k.su2Part ∧
      x.su3Part.unit.val = k.su3Part := by
  apply coveringMap_eq_one_of_kernelElt h x.su2Part.det_one x.su3Part.det_one

/-
From a `CoveringKernelElt` matching `x`, produce a `Fin 6` index such that
`x = smProductCoveringKernelElt i`.
-/
private theorem kernelElt_match_implies_smProductCoveringKernelElt
    (x : SMProductCoveringTriple)
    (k : CoveringKernelElt)
    (hph : k.phase = (x.phase : ℂ))
    (hsu2 : x.su2Part.unit.val = k.su2Part)
    (hsu3 : x.su3Part.unit.val = k.su3Part) :
    ∃ i : Fin 6, x = smProductCoveringKernelElt i := by
  -- By `sixCoveringKernelElts_surjective`, k = sixCoveringKernelElts i for some i.
  obtain ⟨i, hi⟩ : ∃ i : Fin 6, k = sixCoveringKernelElts i := by
    obtain ⟨ i, hi ⟩ := sixCoveringKernelElts_surjective k; use i; aesop;
  use i;
  cases x;
  congr;
  · exact Units.ext <| hph.symm.trans <| hi.symm ▸ rfl;
  · ext; simp [kernelSU2Part];
    simp_all +decide [ sixCoveringKernelElts ];
    simp_all +decide [ sixUnitCoveringKernelElts, kernelPhaseUnit ];
    simp_all +decide [ CoveringKernelElt.su2Part ];
  · unfold kernelSU3Part; aesop;

/-! ## Reverse: identity fiber is exactly the kernel family -/

/--
If `smTrueProductCoveringTripleToSMBlockUnits x = 1`, then
`x = smProductCoveringKernelElt i` for some `i : Fin 6`.
-/
theorem smTrueProductCoveringTripleToSMBlockUnits_eq_one_iff
    (x : SMProductCoveringTriple) :
    smTrueProductCoveringTripleToSMBlockUnits x = 1 ↔
      ∃ i : Fin 6, x = smProductCoveringKernelElt i := by
  constructor
  · intro h
    have h1 := trueImage_eq_one_implies_unitImage_eq_one x h
    have h2 := unitImage_eq_one_implies_coveringMap_eq_one x h1
    have h3 := coveringMap_one_implies_kernelElt x h2
    obtain ⟨k, hph, hsu2, hsu3⟩ := h3
    exact kernelElt_match_implies_smProductCoveringKernelElt x k hph hsu2 hsu3
  · rintro ⟨i, rfl⟩
    exact smProductCoveringKernelElt_trueImage_eq_one i

/-! ## Bundled package -/

/--
Bundled record collecting the exact identity-fiber theorem for the
true product-covering map.
-/
structure StandardModelTrueProductZ6KernelPackage where
  /-- Each kernel family element maps to one. -/
  kernel_family_maps_to_one :
    ∀ i : Fin 6,
      smTrueProductCoveringTripleToSMBlockUnits (smProductCoveringKernelElt i) = 1
  /-- The identity fiber is exactly the kernel family. -/
  identity_fiber_exact :
    ∀ x : SMProductCoveringTriple,
      smTrueProductCoveringTripleToSMBlockUnits x = 1 ↔
        ∃ i : Fin 6, x = smProductCoveringKernelElt i

/-- The canonical package. -/
noncomputable def standardModelTrueProductZ6KernelPackage :
    StandardModelTrueProductZ6KernelPackage where
  kernel_family_maps_to_one := smProductCoveringKernelElt_trueImage_eq_one
  identity_fiber_exact := smTrueProductCoveringTripleToSMBlockUnits_eq_one_iff

end PhysicsSM.Gauge.StandardModelSubgroup
