import PhysicsSM.Gauge.QunitQubitQutritRepresentation
import Mathlib.LinearAlgebra.ExteriorPower.Basis

/-!
# Algebraic covering action on the even five-mode exterior module

The repository already supplies a genuine block-diagonal action of the unit
cover `U(1) x SU(2) x SU(3)` on the five-dimensional weak-plus-color space.
This module packages that action as a complex-linear map, lifts it functorially
to every exterior degree, and combines degrees `0`, `2`, and `4` into the
sixteen-dimensional even exterior module. The resulting action is a monoid
representation, and every trusted unit-level `Z6` covering-kernel element acts
as the identity.

Scope: this proves inclusion of the trusted `Z6` family in the kernel of the
complete even-exterior action. It does not prove the converse kernel
classification, derive the weak/color split from Jordan data, or identify the
module with the corrected Furey left-action module. Those are separate gates.

Provenance: clean-room composition of Mathlib's exterior-power functor with
`PhysicsSM.Gauge.QunitQubitQutritRepresentation`. No compiled evaluator.
-/

noncomputable section

namespace PhysicsSM.Draft.JordanCliffordExteriorCoverAction

open Complex Matrix PhysicsSM.Gauge.StandardModelSubgroup
open PhysicsSM.Gauge.QunitQubitQutritDictionary

/-- The five-dimensional weak-plus-color carrier of the trusted cover action. -/
abbrev GenerationSpace := QubitPlusQutrit

/-- The trusted block action, now packaged as a complex-linear map. -/
def generationActLinear (x : UnitCoveringTriple) :
    GenerationSpace →ₗ[Complex] GenerationSpace where
  toFun := actQubitPlusQutrit x
  map_add' v w := by
    ext i
    cases i <;> simp [actQubitPlusQutrit, Matrix.mulVec, dotProduct, mul_add,
      Finset.sum_add_distrib]
  map_smul' c v := by
    ext i
    cases i <;> simp [actQubitPlusQutrit, Matrix.mulVec, dotProduct,
      Finset.mul_sum, mul_assoc, mul_comm] <;> ring

/-- The identity cover element induces the identity linear map. -/
theorem generationActLinear_one :
    generationActLinear (1 : UnitCoveringTriple) = LinearMap.id := by
  apply LinearMap.ext
  intro v
  exact congrFun actQubitPlusQutrit_one v

/-- Cover multiplication becomes composition of the induced linear maps. -/
theorem generationActLinear_mul (x y : UnitCoveringTriple) :
    generationActLinear (x * y) =
      (generationActLinear x).comp (generationActLinear y) := by
  apply LinearMap.ext
  intro v
  exact congrFun (actQubitPlusQutrit_mul x y) v

/-- Every trusted unit-level covering-kernel element acts identically on the
five-dimensional carrier. -/
theorem generationActLinear_kernel (k : UnitCoveringKernelElt) :
    generationActLinear k.toUnitCoveringTriple = LinearMap.id := by
  apply LinearMap.ext
  intro v
  exact congrFun (kernelElt_actQubitPlusQutrit_eq_id k) v

/-- The induced action on exterior degree `n`. -/
def exteriorAct (n : Nat) (x : UnitCoveringTriple) :
    (⋀[Complex]^n GenerationSpace) →ₗ[Complex]
      (⋀[Complex]^n GenerationSpace) :=
  exteriorPower.map n (generationActLinear x)

/-- Exterior functoriality preserves the identity action. -/
theorem exteriorAct_one (n : Nat) :
    exteriorAct n (1 : UnitCoveringTriple) = LinearMap.id := by
  rw [exteriorAct, generationActLinear_one, exteriorPower.map_id]

/-- Exterior functoriality preserves cover multiplication. -/
theorem exteriorAct_mul (n : Nat) (x y : UnitCoveringTriple) :
    exteriorAct n (x * y) = (exteriorAct n x).comp (exteriorAct n y) := by
  change exteriorPower.map n (generationActLinear (x * y)) =
    (exteriorPower.map n (generationActLinear x)).comp
      (exteriorPower.map n (generationActLinear y))
  rw [generationActLinear_mul, exteriorPower.map_comp]

/-- Every trusted unit-level covering-kernel element acts identically in every
exterior degree. -/
theorem exteriorAct_kernel (n : Nat) (k : UnitCoveringKernelElt) :
    exteriorAct n k.toUnitCoveringTriple = LinearMap.id := by
  rw [exteriorAct, generationActLinear_kernel, exteriorPower.map_id]

/-- The even-degree five-mode exterior model: exterior degrees `0`, `2`, and
`4`. Its interpretation as one Weyl chirality is external to this module. -/
abbrev EvenExterior :=
  (⋀[Complex]^0 GenerationSpace) ×
    (⋀[Complex]^2 GenerationSpace) ×
      (⋀[Complex]^4 GenerationSpace)

/-- Componentwise cover action on the complete even exterior module. -/
def evenExteriorAct (x : UnitCoveringTriple) :
    EvenExterior →ₗ[Complex] EvenExterior where
  toFun v := (exteriorAct 0 x v.1, exteriorAct 2 x v.2.1,
    exteriorAct 4 x v.2.2)
  map_add' v w := by
    ext <;> simp
  map_smul' c v := by
    ext <;> simp

/-- The componentwise even-exterior action is unital. -/
theorem evenExteriorAct_one :
    evenExteriorAct (1 : UnitCoveringTriple) = LinearMap.id := by
  apply LinearMap.ext
  intro v
  ext <;> simp [evenExteriorAct, exteriorAct_one]

/-- The componentwise even-exterior action respects cover multiplication. -/
theorem evenExteriorAct_mul (x y : UnitCoveringTriple) :
    evenExteriorAct (x * y) =
      (evenExteriorAct x).comp (evenExteriorAct y) := by
  apply LinearMap.ext
  intro v
  ext <;> simp [evenExteriorAct, exteriorAct_mul]

/-- The algebraic unit cover acts on the complete even exterior module. -/
def evenExteriorRepresentation :
    UnitCoveringTriple →* Module.End Complex EvenExterior where
  toFun := evenExteriorAct
  map_one' := evenExteriorAct_one
  map_mul' := evenExteriorAct_mul

/-- The complete even exterior module has complex dimension sixteen. -/
theorem evenExterior_finrank : Module.finrank Complex EvenExterior = 16 := by
  have hE : Module.finrank Complex GenerationSpace = 5 := by
    simp [GenerationSpace, QubitPlusQutrit]
  simp only [EvenExterior, Module.finrank_prod]
  rw [exteriorPower.finrank_eq, exteriorPower.finrank_eq,
    exteriorPower.finrank_eq, hE]
  norm_num [Nat.choose]

/-- Every trusted unit-level covering-kernel element acts identically on the
complete even exterior module. -/
theorem evenExteriorAct_kernel (k : UnitCoveringKernelElt) :
    evenExteriorAct k.toUnitCoveringTriple = LinearMap.id := by
  apply LinearMap.ext
  intro v
  ext <;> simp [evenExteriorAct, exteriorAct_kernel]

/-- In particular, each of the six explicit standard covering-kernel elements
maps to the identity endomorphism in the even-exterior representation. -/
theorem sixKernelElements_evenExteriorRepresentation_eq_one (i : Fin 6) :
    evenExteriorRepresentation
      (sixUnitCoveringKernelElts i).toUnitCoveringTriple = 1 := by
  change evenExteriorAct
    (sixUnitCoveringKernelElts i).toUnitCoveringTriple = LinearMap.id
  exact evenExteriorAct_kernel (sixUnitCoveringKernelElts i)

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.JordanCliffordExteriorCoverAction.evenExteriorRepresentation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms evenExteriorRepresentation

/-- info: 'PhysicsSM.Draft.JordanCliffordExteriorCoverAction.evenExterior_finrank' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms evenExterior_finrank

/-- info: 'PhysicsSM.Draft.JordanCliffordExteriorCoverAction.sixKernelElements_evenExteriorRepresentation_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sixKernelElements_evenExteriorRepresentation_eq_one

end PhysicsSM.Draft.JordanCliffordExteriorCoverAction
