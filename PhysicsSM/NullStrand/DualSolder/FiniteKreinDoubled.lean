import Mathlib

/-!
# Finite Krein API and the retarded/advanced doubled operator

This module provides a **finite Lorentzian audit layer** for a graph (matrix)
operator.  Everything here lives over finite complex matrices `Matrix m m ℂ`
(with `m` a finite index type, e.g. `Fin n`) and is therefore *exact* and
*finitary*.

## Scope and limitation (read this)

The notion proved here is **finite `J`-self-adjointness only**: an operator `A`
is `J`-self-adjoint when its *Krein adjoint* `J Aᴴ J` equals `A`, where `J` is a
*fundamental symmetry* (`J = Jᴴ` and `J * J = 1`).  This is purely the algebraic
core of a Krein-space structure on a finite-dimensional indefinite inner-product
space.

This is **NOT**:
* Hilbert-space self-adjointness,
* continuum essential self-adjointness, or
* any continuum spectral theory.

No claim about spectra, domains, or unbounded operators is made or implied.
The ancilla doubling dimension is the explicit bounded number `2`
(the block `m ⊕ m` direct sum).

## Main contents

* `kreinAdjoint J A := J * Aᴴ * J` and the involution / anti-multiplicative laws.
* `IsJSelfAdjoint J A := kreinAdjoint J A = A`.
* `blockKreinAdjoint`: the Krein adjoint of a `2 × 2` block operator for the
  block fundamental symmetry `J_double = diag J J`.
* `retardedAdvancedDouble J D₊ := [[0, D₊sharp], [D₊, 0]]` with
  `D₊sharp = kreinAdjoint J D₊`.
* `retardedAdvancedDouble_isJSelfAdjoint`: this doubled operator is
  `J_double`-self-adjoint.
* `retardedAdvancedDouble_sq_blockDiag`: its square is block-diagonal,
  `diag (D₊sharp D₊) (D₊ D₊sharp)`.

## Literature anchor (context only; nothing is imported from it)

The supersymmetric / doubled first-order graph Dirac operator and its index are
established (Post, arXiv:0708.3707); the Krein-space fermionic-action framework
is van den Dungen, arXiv:1505.01939.  This file is the finite algebraic core of
that doubling.
-/

namespace PhysicsSM.NullStrand.DualSolder

open Matrix

variable {m : Type*} [Fintype m] [DecidableEq m]

/-- The **Krein adjoint** of a matrix `A` with respect to a fundamental symmetry
`J`: `J * Aᴴ * J`.  When `J = Jᴴ` and `J * J = 1` this is an (anti-multiplicative)
involution; see `kreinAdjoint_involutive` and `kreinAdjoint_mul`. -/
noncomputable def kreinAdjoint (J A : Matrix m m ℂ) : Matrix m m ℂ :=
  J * Aᴴ * J

/-- A matrix is **`J`-self-adjoint** (self-adjoint in the Krein/indefinite inner
product determined by `J`) when it equals its own Krein adjoint. -/
def IsJSelfAdjoint (J A : Matrix m m ℂ) : Prop :=
  kreinAdjoint J A = A

omit [DecidableEq m] in
/-- The Krein adjoint of the zero operator is zero. -/
@[simp] theorem kreinAdjoint_zero (J : Matrix m m ℂ) :
    kreinAdjoint J 0 = 0 := by
  simp [kreinAdjoint]

/-- For a fundamental symmetry (`J = Jᴴ`, `J * J = 1`) the Krein adjoint is an
involution. -/
theorem kreinAdjoint_involutive {J : Matrix m m ℂ}
    (hJ : Jᴴ = J) (hJJ : J * J = 1) (A : Matrix m m ℂ) :
    kreinAdjoint J (kreinAdjoint J A) = A := by
  have hAux : kreinAdjoint J (kreinAdjoint J A) = (J * J) * A * (J * J) := by
    simp only [kreinAdjoint, conjTranspose_mul, conjTranspose_conjTranspose, hJ,
      mul_assoc]
  rw [hAux, hJJ, one_mul, mul_one]

/-- The Krein adjoint is anti-multiplicative: `(A B)ᵃᵈʲ = Bᵃᵈʲ Aᵃᵈʲ`
(needs only `J * J = 1`). -/
theorem kreinAdjoint_mul {J : Matrix m m ℂ} (hJJ : J * J = 1)
    (A B : Matrix m m ℂ) :
    kreinAdjoint J (A * B) = kreinAdjoint J B * kreinAdjoint J A := by
  rw [kreinAdjoint, kreinAdjoint, kreinAdjoint, conjTranspose_mul]
  have h : (J * Bᴴ * J) * (J * Aᴴ * J) = J * (Bᴴ * Aᴴ) * J := by
    calc (J * Bᴴ * J) * (J * Aᴴ * J)
          = J * Bᴴ * (J * J) * Aᴴ * J := by simp only [mul_assoc]
      _ = J * Bᴴ * 1 * Aᴴ * J := by rw [hJJ]
      _ = J * (Bᴴ * Aᴴ) * J := by simp only [mul_one, mul_assoc]
  rw [h]

/-- The block fundamental symmetry `J_double = diag J J` on the doubled space
`m ⊕ m`. -/
noncomputable def Jdouble (J : Matrix m m ℂ) :
    Matrix (m ⊕ m) (m ⊕ m) ℂ :=
  fromBlocks J 0 0 J

omit [DecidableEq m] in
/-- The Krein adjoint of a `2 × 2` block operator with respect to the block
fundamental symmetry `J_double = diag J J` acts blockwise (transposing the
off-diagonal blocks, as an adjoint must). -/
theorem blockKreinAdjoint (J A B C D : Matrix m m ℂ) :
    kreinAdjoint (Jdouble J) (fromBlocks A B C D)
      = fromBlocks (kreinAdjoint J A) (kreinAdjoint J C)
          (kreinAdjoint J B) (kreinAdjoint J D) := by
  simp only [kreinAdjoint, Jdouble, fromBlocks_conjTranspose, fromBlocks_multiply]
  simp only [mul_zero, zero_mul, add_zero, zero_add, mul_assoc]

/-- The **retarded/advanced doubled operator** built from a first-order graph
operator `D₊`.  The lower-left block is `D₊` (retarded) and the upper-right block
is its Krein adjoint `D₋ = D₊ᵃᵈʲ` (advanced):
`[[0, kreinAdjoint J D₊], [D₊, 0]]`. -/
noncomputable def retardedAdvancedDouble (J Dp : Matrix m m ℂ) :
    Matrix (m ⊕ m) (m ⊕ m) ℂ :=
  fromBlocks 0 (kreinAdjoint J Dp) Dp 0

/-- The retarded/advanced doubled operator is `J_double`-self-adjoint
(for a fundamental symmetry `J`). -/
theorem retardedAdvancedDouble_isJSelfAdjoint {J : Matrix m m ℂ}
    (hJ : Jᴴ = J) (hJJ : J * J = 1) (Dp : Matrix m m ℂ) :
    IsJSelfAdjoint (Jdouble J) (retardedAdvancedDouble J Dp) := by
  unfold IsJSelfAdjoint retardedAdvancedDouble
  rw [blockKreinAdjoint, kreinAdjoint_involutive hJ hJJ, kreinAdjoint_zero]

omit [DecidableEq m] in
/-- The square of the retarded/advanced doubled operator is **block-diagonal**:
`diag (D₊ᵃᵈʲ D₊) (D₊ D₊ᵃᵈʲ)`.  These two diagonal blocks are the retarded and
advanced "Laplacians" of the doubled first-order operator. -/
theorem retardedAdvancedDouble_sq_blockDiag (J Dp : Matrix m m ℂ) :
    (retardedAdvancedDouble J Dp) * (retardedAdvancedDouble J Dp)
      = fromBlocks (kreinAdjoint J Dp * Dp) 0 0 (Dp * kreinAdjoint J Dp) := by
  unfold retardedAdvancedDouble
  rw [fromBlocks_multiply]
  simp only [mul_zero, zero_mul, add_zero, zero_add]

end PhysicsSM.NullStrand.DualSolder
