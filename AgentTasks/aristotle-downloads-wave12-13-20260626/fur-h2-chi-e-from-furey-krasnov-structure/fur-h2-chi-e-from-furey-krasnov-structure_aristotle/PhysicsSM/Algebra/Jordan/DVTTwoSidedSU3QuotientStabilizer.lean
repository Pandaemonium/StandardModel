import Mathlib
import PhysicsSM.Algebra.Jordan.DVTTwoSidedActionKernelZ3
import PhysicsSM.Algebra.Jordan.DVTBlockActionMonoid

/-!
# Algebra.Jordan.DVTTwoSidedSU3QuotientStabilizer

Organizes the two-sided `(SU(3) × SU(3)) / ℤ₃` quotient action on the DVT
complement scaffold.

## Main declarations

- `SU3MatrixUnit` — structure bundling a matrix unit with `det = 1`.
- `SU3MatrixUnit.instGroup` — group structure on `SU3MatrixUnit`.
- `DVTTwoSidedSU3Pair` — the product `SU3MatrixUnit × SU3MatrixUnitᵐᵒᵖ`,
  with the second factor using opposite multiplication so that the
  composition law `(A₁ * A₂, B₂ * B₁)` is captured.
- `dvtTwoSidedSU3ActionHom` — monoid homomorphism from `DVTTwoSidedSU3Pair`
  to `AddMonoid.End H3OComplement`.
- `DVTTwoSidedSU3Quotient` — the quotient by the kernel congruence.
- `DVTTwoSidedSU3Quotient.instGroup` — group structure on the quotient.
- `dvtTwoSidedSU3QuotientMulEquivImage` — multiplicative equivalence between
  the quotient and the range of the action homomorphism.
- `dvtTwoSidedSU3_identityFiber_z3` — the identity fiber of the action
  homomorphism is the central `ℤ₃` scalar.

## Claim boundary

This is an algebraic quotient action on the coordinate complement scaffold.
It does not prove the full exceptional Jordan automorphism stabilizer theorem,
topological quotient structure, or any Lie group smoothness result.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O
open Matrix Complex

/-! ### SU3MatrixUnit -/

/-- A matrix unit with determinant one. -/
structure SU3MatrixUnit where
  /-- The underlying matrix unit. -/
  unit : Units (Matrix (Fin 3) (Fin 3) ℂ)
  /-- The determinant-one condition. -/
  det_one : (unit : Matrix (Fin 3) (Fin 3) ℂ).det = 1

namespace SU3MatrixUnit

noncomputable instance : One SU3MatrixUnit where
  one := ⟨1, by simp⟩

noncomputable instance : Mul SU3MatrixUnit where
  mul A B := ⟨A.unit * B.unit, by
    simp only [Units.val_mul, det_mul, A.det_one, B.det_one, one_mul]⟩

noncomputable instance : Inv SU3MatrixUnit where
  inv A := ⟨A.unit⁻¹, by
    simp [Matrix.det_nonsing_inv, Ring.inverse_eq_inv, A.det_one]⟩

@[simp] theorem one_unit : (1 : SU3MatrixUnit).unit = 1 := rfl

@[simp] theorem mul_unit (A B : SU3MatrixUnit) :
    (A * B).unit = A.unit * B.unit := rfl

@[simp] theorem inv_unit (A : SU3MatrixUnit) :
    (A⁻¹).unit = A.unit⁻¹ := rfl

theorem ext {A B : SU3MatrixUnit} (h : A.unit = B.unit) : A = B := by
  cases A; cases B; simp only [mk.injEq] at h ⊢; exact h

noncomputable instance instGroup : Group SU3MatrixUnit where
  mul_assoc a b c := ext (mul_assoc a.unit b.unit c.unit)
  one_mul a := ext (one_mul a.unit)
  mul_one a := ext (mul_one a.unit)
  inv_mul_cancel a := ext (inv_mul_cancel a.unit)

/-- Coercion from `SU3MatrixUnit` to a matrix. -/
noncomputable def toMatrix (A : SU3MatrixUnit) : Matrix (Fin 3) (Fin 3) ℂ :=
  (A.unit : Matrix (Fin 3) (Fin 3) ℂ)

end SU3MatrixUnit

/-! ### DVTTwoSidedSU3Pair -/

/-- The two-sided domain for the DVT action. The second factor uses opposite
    multiplication to match the composition law `(A₁ * A₂, B₂ * B₁)`. -/
abbrev DVTTwoSidedSU3Pair := SU3MatrixUnit × (SU3MatrixUnit)ᵐᵒᵖ

/-! ### Action homomorphism -/

-- Heartbeat increase needed for the `map_mul'` unification with opposite group structure.
set_option maxHeartbeats 800000 in
/-- The two-sided action `X ↦ A * X * B` as a monoid homomorphism from
    `DVTTwoSidedSU3Pair` to `AddMonoid.End H3OComplement`. -/
noncomputable def dvtTwoSidedSU3ActionHom :
    DVTTwoSidedSU3Pair →* AddMonoid.End H3OComplement where
  toFun p :=
    h3oComplementTwoSidedAction p.1.toMatrix p.2.unop.toMatrix
  map_one' := by
    simp only [Prod.fst_one, Prod.snd_one, MulOpposite.unop_one,
      SU3MatrixUnit.toMatrix, SU3MatrixUnit.one_unit, Units.val_one]
    exact h3oComplementTwoSidedAction_one_one
  map_mul' p q := by
    have key := h3oComplementTwoSidedAction_mul
      (↑p.1.unit) (↑q.1.unit) (↑p.2.unop.unit) (↑q.2.unop.unit)
    exact AddMonoidHom.ext fun w => congr_fun (congr_arg (↑) key) w

/-! ### Image equivalence -/

/-- Two pairs are image-equivalent if they induce the same action. -/
def DVTTwoSidedSU3Pair.ImageEquivalent
    (x y : DVTTwoSidedSU3Pair) : Prop :=
  dvtTwoSidedSU3ActionHom x = dvtTwoSidedSU3ActionHom y

/-! ### Quotient by the kernel congruence -/

/-- The kernel congruence of the action homomorphism. -/
noncomputable def dvtTwoSidedSU3KerCon : Con DVTTwoSidedSU3Pair :=
  Con.ker dvtTwoSidedSU3ActionHom

/-- The quotient of `DVTTwoSidedSU3Pair` by the kernel congruence.
    Two pairs are identified when they induce the same action. -/
abbrev DVTTwoSidedSU3Quotient := dvtTwoSidedSU3KerCon.Quotient

/-- The quotient `DVTTwoSidedSU3Pair / ker(action)` inherits a group structure. -/
noncomputable instance : Group DVTTwoSidedSU3Quotient :=
  dvtTwoSidedSU3KerCon.group

/-! ### Quotient-to-image equivalence -/

/-- The multiplicative equivalence between the quotient and the image (range)
    of the action homomorphism. -/
noncomputable def dvtTwoSidedSU3QuotientMulEquivImage :
    MulEquiv DVTTwoSidedSU3Quotient
      (MonoidHom.mrange dvtTwoSidedSU3ActionHom) :=
  Con.quotientKerEquivRange dvtTwoSidedSU3ActionHom

/-! ### Identity fiber is Z₃ -/

/-- The identity fiber of the action homomorphism corresponds to the
    central `ℤ₃` scalar: if `(A, Bᵐᵒᵖ)` acts as the identity, then
    `A = z • I` and `B = z⁻¹ • I` for some cube root of unity `z`. -/
theorem dvtTwoSidedSU3_identityFiber_z3
    (x : DVTTwoSidedSU3Pair)
    (hx : dvtTwoSidedSU3ActionHom x = 1) :
    ∃ z : DVTZ3CentralScalar,
      (x.1.unit : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ) ∧
      (x.2.unop.unit : Matrix (Fin 3) (Fin 3) ℂ) =
        (z : ℂ)⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℂ) := by
  have hact : h3oComplementTwoSidedAction
      (x.1.toMatrix) (x.2.unop.toMatrix) =
      AddMonoidHom.id H3OComplement := by
    exact_mod_cast hx
  exact h3oComplementTwoSidedAction_kernel_z3
    x.1.unit x.2.unop.unit hact x.1.det_one x.2.unop.det_one

end PhysicsSM.Algebra.Jordan.DVTAction
