import Mathlib
import PhysicsSM.Gauge.StandardModelCoveringMapSurjective
import PhysicsSM.Gauge.StandardModelUnitZ6Kernel

/-!
# Gauge.StandardModelProductCoveringTriple

The true algebraic covering domain `U(1) × SU(2) × SU(3)` for the
Standard Model gauge group covering map.

## Mathematical context

The Standard Model gauge group is `S(U(2) × U(3))`, which is the image of
the covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))`
defined by `(α, g, h) ↦ (α³ · g, α⁻² · h)`.

The existing `UnitCoveringTriple` allows arbitrary invertible matrices as
the SU(2) and SU(3) parts, and `SMCoveringTriple` only constrains the
*product* of the determinants to be one. This module defines the
**restricted product domain** where each matrix part is individually
unitary with determinant one.

## Main declarations

* `SUUnitMatrix` — a unit matrix that is unitary with determinant one.
* `SUUnitMatrix.instGroup` — componentwise group structure.
* `SMProductCoveringTriple` — the true `U(1) × SU(2) × SU(3)` domain.
* `SMProductCoveringTriple.toSMCoveringTriple` — forgetful inclusion.
* `SMProductCoveringTriple.image_satisfiesSMBlock` — image lands in
  `SMBlockPredicate`.
* `SMProductCoveringTriple.instGroup` — group structure.
* `smProductCoveringKernelElt` — the six kernel elements in this domain.
* `smProductCoveringKernelElt_image_eq_one` — each maps to identity.

## Claim boundary

This is algebraic. It does not prove a topological quotient, smooth Lie
group theorem, compactness, or gauge-field dynamics.

Status: trusted theorem package; all proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.GUTSquare PhysicsSM.Gauge.BlockEmbeddings

/-! ## SUUnitMatrix -/

/--
A determinant-one unitary matrix, packaged as a unit of the matrix ring.
This captures membership in `SU(n)` at the algebraic level.
-/
structure SUUnitMatrix (n : Type*) [Fintype n] [DecidableEq n] where
  /-- The underlying unit in the matrix ring. -/
  unit : Units (Matrix n n ℂ)
  /-- The matrix is unitary: `Mᴴ * M = 1`. -/
  unitary : IsUnitary unit.val
  /-- The determinant is one. -/
  det_one : unit.val.det = 1

/-! ### Extensionality -/

@[ext]
theorem SUUnitMatrix.ext {n : Type*} [Fintype n] [DecidableEq n]
    {x y : SUUnitMatrix n}
    (h : x.unit = y.unit) : x = y := by
  cases x; cases y; simp_all

/-! ### Helper: norm of a sixth root of unity is 1 -/

theorem norm_eq_one_of_pow_six_eq_one {z : ℂ} (hz : z ^ 6 = 1) : ‖z‖ = 1 := by
  have hn6 : ‖z‖ ^ 6 = 1 := by rw [← norm_pow, hz, norm_one]
  have hnn : 0 ≤ ‖z‖ := norm_nonneg _
  have hnn3 : 0 ≤ ‖z‖ ^ 3 := by positivity
  have hsq : (‖z‖ ^ 3) ^ 2 = 1 := by ring_nf; linarith
  have h3 : ‖z‖ ^ 3 = 1 := by nlinarith [sq_nonneg (‖z‖ ^ 3 - 1)]
  nlinarith [sq_nonneg (‖z‖ - 1), sq_nonneg (‖z‖ ^ 2 + ‖z‖ + 1)]

/-! ### Inverse unitarity and det helper -/

private theorem isUnitary_units_inv {n : Type*} [Fintype n] [DecidableEq n]
    (u : Units (Matrix n n ℂ)) (hu : IsUnitary u.val) :
    IsUnitary (u⁻¹ : Units (Matrix n n ℂ)).val := by
      unfold IsUnitary at *; simp_all +decide [ Matrix.inv_eq_right_inv ] ;
      rw [ Matrix.inv_eq_left_inv hu ];
      rw [ Matrix.conjTranspose_conjTranspose, ← mul_eq_one_comm, hu ]

private theorem det_units_inv {n : Type*} [Fintype n] [DecidableEq n]
    (u : Units (Matrix n n ℂ)) (hd : u.val.det = 1) :
    (u⁻¹ : Units (Matrix n n ℂ)).val.det = 1 := by
      simp +decide [ Matrix.det_mul, hd ]

/-! ### Group structure -/

instance SUUnitMatrix.instOne {n : Type*} [Fintype n] [DecidableEq n] :
    One (SUUnitMatrix n) where
  one := ⟨1, by unfold IsUnitary; simp, by simp⟩

@[simp] theorem SUUnitMatrix.one_unit {n : Type*} [Fintype n] [DecidableEq n] :
    (1 : SUUnitMatrix n).unit = 1 := rfl

instance SUUnitMatrix.instMul {n : Type*} [Fintype n] [DecidableEq n] :
    Mul (SUUnitMatrix n) where
  mul x y := ⟨x.unit * y.unit,
    isUnitary_mul x.unitary y.unitary,
    by simp [det_mul, x.det_one, y.det_one]⟩

@[simp] theorem SUUnitMatrix.mul_unit {n : Type*} [Fintype n] [DecidableEq n]
    (x y : SUUnitMatrix n) :
    (x * y).unit = x.unit * y.unit := rfl

noncomputable instance SUUnitMatrix.instInv {n : Type*} [Fintype n] [DecidableEq n] :
    Inv (SUUnitMatrix n) where
  inv x := ⟨x.unit⁻¹,
    isUnitary_units_inv x.unit x.unitary,
    det_units_inv x.unit x.det_one⟩

@[simp] theorem SUUnitMatrix.inv_unit {n : Type*} [Fintype n] [DecidableEq n]
    (x : SUUnitMatrix n) :
    x⁻¹.unit = x.unit⁻¹ := rfl

noncomputable instance SUUnitMatrix.instGroup {n : Type*} [Fintype n] [DecidableEq n] :
    Group (SUUnitMatrix n) where
  mul_assoc x y z := by ext; simp [mul_assoc]
  one_mul x := by ext; simp
  mul_one x := by ext; simp
  inv_mul_cancel x := by ext; simp [inv_mul_cancel]

/-! ## SMProductCoveringTriple -/

/--
The true `U(1) × SU(2) × SU(3)` product-covering domain. Each component
is individually constrained: the phase has unit norm, and the matrix parts
are separately unitary with determinant one.
-/
structure SMProductCoveringTriple where
  /-- The U(1) phase, as a unit of ℂ. -/
  phase : Units ℂ
  /-- The phase has unit norm. -/
  phase_norm_one : ‖(phase : ℂ)‖ = 1
  /-- The SU(2) matrix part. -/
  su2Part : SUUnitMatrix (Fin 2)
  /-- The SU(3) matrix part. -/
  su3Part : SUUnitMatrix (Fin 3)

/-! ### Extensionality -/

@[ext]
theorem SMProductCoveringTriple.ext {x y : SMProductCoveringTriple}
    (h1 : x.phase = y.phase)
    (h2 : x.su2Part = y.su2Part)
    (h3 : x.su3Part = y.su3Part) :
    x = y := by
  cases x; cases y; simp_all

/-! ### Group structure -/

instance SMProductCoveringTriple.instOne : One SMProductCoveringTriple where
  one := ⟨1, by simp, 1, 1⟩

@[simp] theorem SMProductCoveringTriple.one_phase :
    (1 : SMProductCoveringTriple).phase = 1 := rfl

@[simp] theorem SMProductCoveringTriple.one_su2Part :
    (1 : SMProductCoveringTriple).su2Part = 1 := rfl

@[simp] theorem SMProductCoveringTriple.one_su3Part :
    (1 : SMProductCoveringTriple).su3Part = 1 := rfl

noncomputable instance SMProductCoveringTriple.instMul :
    Mul SMProductCoveringTriple where
  mul x y := ⟨x.phase * y.phase, by
    rw [Units.val_mul, norm_mul, x.phase_norm_one, y.phase_norm_one, mul_one],
    x.su2Part * y.su2Part,
    x.su3Part * y.su3Part⟩

@[simp] theorem SMProductCoveringTriple.mul_phase (x y : SMProductCoveringTriple) :
    (x * y).phase = x.phase * y.phase := rfl

@[simp] theorem SMProductCoveringTriple.mul_su2Part (x y : SMProductCoveringTriple) :
    (x * y).su2Part = x.su2Part * y.su2Part := rfl

@[simp] theorem SMProductCoveringTriple.mul_su3Part (x y : SMProductCoveringTriple) :
    (x * y).su3Part = x.su3Part * y.su3Part := rfl

noncomputable instance SMProductCoveringTriple.instInv :
    Inv SMProductCoveringTriple where
  inv x := ⟨x.phase⁻¹, by simp [norm_inv, x.phase_norm_one],
    x.su2Part⁻¹, x.su3Part⁻¹⟩

@[simp] theorem SMProductCoveringTriple.inv_phase (x : SMProductCoveringTriple) :
    x⁻¹.phase = x.phase⁻¹ := rfl

@[simp] theorem SMProductCoveringTriple.inv_su2Part (x : SMProductCoveringTriple) :
    x⁻¹.su2Part = x.su2Part⁻¹ := rfl

@[simp] theorem SMProductCoveringTriple.inv_su3Part (x : SMProductCoveringTriple) :
    x⁻¹.su3Part = x.su3Part⁻¹ := rfl

noncomputable instance SMProductCoveringTriple.instGroup :
    Group SMProductCoveringTriple where
  mul_assoc x y z := by ext <;> simp [mul_assoc]
  one_mul x := by ext <;> simp
  mul_one x := by ext <;> simp
  inv_mul_cancel x := by ext <;> simp [inv_mul_cancel]

/-! ## Forgetful inclusion into SMCoveringTriple -/

/--
Forget the individual determinant-one constraints and produce an
`SMCoveringTriple`, which only requires the product of determinants to be one.
-/
noncomputable def SMProductCoveringTriple.toSMCoveringTriple
    (x : SMProductCoveringTriple) : SMCoveringTriple :=
  { toUnitCoveringTriple :=
      { phase := x.phase
        su2Part := x.su2Part.unit
        su3Part := x.su3Part.unit }
    phase_norm_one := x.phase_norm_one
    su2_unitary := x.su2Part.unitary
    su3_unitary := x.su3Part.unitary
    det_product_one := by simp [x.su2Part.det_one, x.su3Part.det_one] }

@[simp] theorem SMProductCoveringTriple.toSMCoveringTriple_phase
    (x : SMProductCoveringTriple) :
    x.toSMCoveringTriple.phase = x.phase := rfl

@[simp] theorem SMProductCoveringTriple.toSMCoveringTriple_su2Part
    (x : SMProductCoveringTriple) :
    x.toSMCoveringTriple.su2Part = x.su2Part.unit := rfl

@[simp] theorem SMProductCoveringTriple.toSMCoveringTriple_su3Part
    (x : SMProductCoveringTriple) :
    x.toSMCoveringTriple.su3Part = x.su3Part.unit := rfl

/-! ## Image satisfies SMBlockPredicate -/

/--
The image of an `SMProductCoveringTriple` under the covering map satisfies
`SMBlockPredicate`.
-/
theorem SMProductCoveringTriple.image_satisfiesSMBlock
    (x : SMProductCoveringTriple) :
    SMBlockPredicate
      (fromBlocks x.toSMCoveringTriple.image.1.val 0 0
        x.toSMCoveringTriple.image.2.val) :=
  smCoveringTriple_image_satisfiesSMBlock x.toSMCoveringTriple

/-! ## Kernel elements in the restricted domain -/

/-
Helper: for a 6th root of unity phase, (phase⁻¹)^3 • I₂ is in SU(2).
-/
noncomputable def kernelSU2Part (k : UnitCoveringKernelElt) :
    SUUnitMatrix (Fin 2) where
  unit := matrixScalarUnit (k.phase⁻¹ ^ 3)
  unitary := by
    convert isUnitary_smul_one _;
    convert matrixScalarUnit_val _;
    · infer_instance;
    · norm_num [ show ‖k.phase.val‖ = 1 from by simpa using norm_eq_one_of_pow_six_eq_one k.phase_pow_six ]
  det_one := by
    simp +zetaDelta at *;
    exact eq_or_eq_neg_of_sq_eq_sq _ _ <| by linear_combination' k.phase_pow_six;

/-
Helper: for a 6th root of unity phase, phase^2 • I₃ is in SU(3).
-/
noncomputable def kernelSU3Part (k : UnitCoveringKernelElt) :
    SUUnitMatrix (Fin 3) where
  unit := matrixScalarUnit (k.phase ^ 2)
  unitary := by
    convert isUnitary_smul_one _;
    convert matrixScalarUnit_val _;
    · infer_instance;
    · simp [norm_eq_one_of_pow_six_eq_one k.phase_pow_six]
  det_one := by
    simp +decide [matrixScalarUnit_val, det_smul];
    linear_combination' k.phase_pow_six

/--
Each of the six unit-level kernel elements lifts to an `SMProductCoveringTriple`.
-/
noncomputable def smProductCoveringKernelElt (i : Fin 6) :
    SMProductCoveringTriple where
  phase := (sixUnitCoveringKernelElts i).phase
  phase_norm_one := norm_eq_one_of_pow_six_eq_one
    (sixUnitCoveringKernelElts i).phase_pow_six
  su2Part := kernelSU2Part (sixUnitCoveringKernelElts i)
  su3Part := kernelSU3Part (sixUnitCoveringKernelElts i)

/--
The forgetful map from a kernel `SMProductCoveringTriple` agrees with the
`UnitCoveringKernelElt.toUnitCoveringTriple` construction.
-/
theorem smProductCoveringKernelElt_toSMCoveringTriple_eq (i : Fin 6) :
    (smProductCoveringKernelElt i).toSMCoveringTriple.toUnitCoveringTriple =
      (sixUnitCoveringKernelElts i).toUnitCoveringTriple := by
  ext <;> simp [smProductCoveringKernelElt, SMProductCoveringTriple.toSMCoveringTriple,
    kernelSU2Part, kernelSU3Part, UnitCoveringKernelElt.toUnitCoveringTriple]

/--
Each kernel `SMProductCoveringTriple` maps to the identity under the
covering image homomorphism.
-/
theorem smProductCoveringKernelElt_image_eq_one (i : Fin 6) :
    unitCoveringTripleImageGroupHom
      (smProductCoveringKernelElt i).toSMCoveringTriple.toUnitCoveringTriple = 1 := by
  rw [smProductCoveringKernelElt_toSMCoveringTriple_eq]
  exact sixUnitCoveringKernelElts_image_eq_one i

/--
The six kernel `SMProductCoveringTriple`s are distinct.
-/
theorem smProductCoveringKernelElt_injective :
    Function.Injective smProductCoveringKernelElt := by
  intro i j h
  have hph : (sixUnitCoveringKernelElts i).phase =
      (sixUnitCoveringKernelElts j).phase :=
    congr_arg SMProductCoveringTriple.phase h
  exact sixUnitCoveringKernelElts_injective (UnitCoveringKernelElt.ext hph)

end PhysicsSM.Gauge.StandardModelSubgroup
