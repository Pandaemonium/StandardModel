import Mathlib
import PhysicsSM.Gauge.StandardModelUnitZ6QuotientGroup
import PhysicsSM.Gauge.StandardModelZ6KernelPackage

/-!
# Gauge.StandardModelUnitZ6Kernel

Unit-level Z₆ kernel elements for the Standard Model covering map.

## Mathematical context

The covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))`
sends `(α, g, h)` to `(α³ · g, α⁻² · h)`. Its kernel consists of
triples `(α, α⁻³ · I₂, α² · I₃)` where `α⁶ = 1`.

This module lifts the six kernel elements to the unit-valued
`UnitCoveringTriple` world and proves they map to the identity under
`unitCoveringTripleImageGroupHom`.

## Main declarations

* `UnitCoveringKernelElt` — a phase `α : Units ℂ` with `(α : ℂ) ^ 6 = 1`.
* `UnitCoveringKernelElt.toUnitCoveringTriple` — the covering triple
  `(α, α⁻³ · I₂, α² · I₃)` with unit-valued components.
* `UnitCoveringKernelElt.image_eq_one` — the image is the identity.
* `sixUnitCoveringKernelElts` — the six explicit kernel elements.
* `sixUnitCoveringKernelElts_image_eq_one` — each maps to identity.
* `sixUnitCoveringKernelElts_injective` — the six elements are distinct.
* `StandardModelUnitZ6KernelPackage` — bundled record of all results.

## Claim boundary

This proves explicit unit-level kernel elements and their identity image.
It does not prove topological quotient structure, smooth Lie group
structure, or that the kernel is exactly these six elements (surjectivity).

Status: trusted theorem package; all proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.BlockEmbeddings

/-! ## Unit-level kernel element -/

/--
A kernel element for the unit-level covering map: a unit phase `α`
satisfying `(α : ℂ) ^ 6 = 1`.
-/
structure UnitCoveringKernelElt where
  /-- The U(1) phase, as a unit of ℂ. -/
  phase : Units ℂ
  /-- The phase is a sixth root of unity. -/
  phase_pow_six : (phase : ℂ) ^ 6 = 1

/-! ## Ext lemma -/

@[ext]
theorem UnitCoveringKernelElt.ext {x y : UnitCoveringKernelElt}
    (h : x.phase = y.phase) : x = y := by
  cases x; cases y; simp_all

/-! ## Conversion to UnitCoveringTriple -/

/--
Convert a unit-level kernel element to a `UnitCoveringTriple`.
The triple is `(α, α⁻³ · I₂, α² · I₃)` where matrix entries use
`matrixScalarUnit`.
-/
noncomputable def UnitCoveringKernelElt.toUnitCoveringTriple
    (k : UnitCoveringKernelElt) : UnitCoveringTriple :=
  { phase := k.phase
    su2Part := matrixScalarUnit (k.phase⁻¹ ^ 3)
    su3Part := matrixScalarUnit (k.phase ^ 2) }

/-! ## Image is identity -/

/--
The image of a unit-level kernel element under `unitCoveringTripleImageGroupHom`
is the identity `(1, 1)`.

The image map sends `(α, g, h)` to `(α³ · g, α⁻² · h)`.
For a kernel element with `g = α⁻³ · I₂` and `h = α² · I₃`, this gives
`(α³ · α⁻³ · I₂, α⁻² · α² · I₃) = (I₂, I₃)`.
-/
theorem UnitCoveringKernelElt.image_eq_one
    (k : UnitCoveringKernelElt) :
    unitCoveringTripleImageGroupHom k.toUnitCoveringTriple = 1 := by
  simp only [unitCoveringTripleImageGroupHom, MonoidHom.coe_mk,
    OneHom.coe_mk]
  simp only [UnitCoveringTriple.image, toUnitCoveringTriple]
  simp only [← matrixScalarUnit_mul]
  have h1 : k.phase ^ 3 * k.phase⁻¹ ^ 3 = 1 := by
    rw [← mul_pow]; simp
  have h2 : k.phase⁻¹ ^ 2 * k.phase ^ 2 = 1 := by
    rw [← mul_pow]; simp
  rw [h1, h2]
  simp

/-! ## Six explicit kernel elements -/

/--
Lift `kernelPhases k` to a unit of ℂ, using the fact that each phase
is nonzero.
-/
noncomputable def kernelPhaseUnit (k : Fin 6) : Units ℂ :=
  Units.mk0 (kernelPhases k) (kernelPhases_ne_zero k)

/--
The six unit-level kernel elements, indexed by `Fin 6`.
-/
noncomputable def sixUnitCoveringKernelElts : Fin 6 → UnitCoveringKernelElt :=
  fun k => ⟨kernelPhaseUnit k, by
    simp only [kernelPhaseUnit, Units.val_mk0]
    exact kernelPhases_pow_six k⟩

/--
Each of the six unit-level kernel elements maps to identity under the
covering image homomorphism.
-/
theorem sixUnitCoveringKernelElts_image_eq_one (i : Fin 6) :
    unitCoveringTripleImageGroupHom
      (sixUnitCoveringKernelElts i).toUnitCoveringTriple = 1 :=
  (sixUnitCoveringKernelElts i).image_eq_one

/--
The six unit-level kernel elements are distinct.
-/
theorem sixUnitCoveringKernelElts_injective :
    Function.Injective sixUnitCoveringKernelElts := by
  intro i j h
  have hph : kernelPhaseUnit i = kernelPhaseUnit j := by
    exact congr_arg UnitCoveringKernelElt.phase h
  have hval : kernelPhases i = kernelPhases j := by
    have := congr_arg Units.val hph
    simp only [kernelPhaseUnit, Units.val_mk0] at this
    exact this
  exact kernelPhases_injective hval

/-! ## Bundled package -/

/--
Bundled record collecting the unit-level Z₆ kernel results.
-/
structure StandardModelUnitZ6KernelPackage where
  /-- The six kernel elements. -/
  kernel_family : Fin 6 → UnitCoveringKernelElt
  /-- Each kernel element maps to identity. -/
  kernel_maps_to_one :
    ∀ i : Fin 6,
      unitCoveringTripleImageGroupHom
        ((kernel_family i).toUnitCoveringTriple) = 1
  /-- The kernel elements are distinct. -/
  kernel_injective :
    Function.Injective kernel_family

/--
The unit-level Z₆ kernel package, instantiated from the proved declarations.
-/
noncomputable def standardModelUnitZ6KernelPackage :
    StandardModelUnitZ6KernelPackage :=
  { kernel_family := sixUnitCoveringKernelElts
    kernel_maps_to_one := sixUnitCoveringKernelElts_image_eq_one
    kernel_injective := sixUnitCoveringKernelElts_injective }

end PhysicsSM.Gauge.StandardModelSubgroup
