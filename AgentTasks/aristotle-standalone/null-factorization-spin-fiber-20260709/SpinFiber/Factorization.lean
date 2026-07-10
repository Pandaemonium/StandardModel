import Mathlib

/-!
# The unitary fiber of a positive momentum factorization

For a complex `2 x 2` factor `M`, the positive matrix `P = M M^H` forgets a
right-unitary degree of freedom.  This file asks for the exact finite theorem:
relative to any chosen invertible factor `M0`, every other factor of the same
`P` is uniquely `M0 U` for a unitary `U`.  If the determinant phase is also
fixed, `U` is special unitary.

This is the algebraic little-group fiber used by massive spinor-helicity.  Its
honest scope is the `U(2)`/`SU(2)` factorization theorem; it does not construct
spin representations, Wigner rotations, or a spin-statistics theorem.

Conventions: matrices act on columns from the left; `M^H` is conjugate
transpose; the group acts on factor columns from the right.
-/

open scoped Matrix ComplexOrder

namespace SpinFiber

abbrev Mat2 := Matrix (Fin 2) (Fin 2) ℂ

/-- Two factors represent the same positive momentum matrix. -/
def SameMomentumGram (M0 M : Mat2) : Prop :=
  M * Mᴴ = M0 * M0ᴴ

/-- Right multiplication by a unitary matrix preserves the positive momentum
Gram matrix. -/
theorem unitary_right_action_preserves
    (M0 U : Mat2) (hU : U ∈ Matrix.unitaryGroup (Fin 2) ℂ) :
    SameMomentumGram M0 (M0 * U) := by
  sorry

/-- **Unitary factorization fiber.**  If `L0` is a two-sided inverse of `M0`,
then every factor of the same positive momentum Gram matrix is `M0 U` for a
unique unitary matrix `U`. -/
theorem factorization_fiber_unitary
    (M0 L0 M : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (hgram : SameMomentumGram M0 M) :
    ∃! U : Mat2, U ∈ Matrix.unitaryGroup (Fin 2) ℂ ∧ M = M0 * U := by
  sorry

/-- **Phase-fixed fiber.**  If determinant is fixed as well, the unique
unitary factor lies in `SU(2)`. -/
theorem factorization_fiber_special_unitary
    (M0 L0 M : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (hdet0 : M0.det ≠ 0)
    (hgram : SameMomentumGram M0 M) (hdet : M.det = M0.det) :
    ∃! U : Mat2,
      U ∈ Matrix.specialUnitaryGroup (Fin 2) ℂ ∧ M = M0 * U := by
  sorry

/-! ## Explicit nondegenerate `SU(2)` orbit witness -/

def witnessBase : Mat2 := !![2, 0; 0, 1]

noncomputable def witnessInverse : Mat2 := !![(1 / 2 : ℂ), 0; 0, 1]

def witnessRotation : Mat2 := !![0, 1; -1, 0]

noncomputable def witnessFactor : Mat2 := witnessBase * witnessRotation

theorem witness_two_sided_inverse :
    witnessInverse * witnessBase = 1 ∧ witnessBase * witnessInverse = 1 := by
  sorry

theorem witness_rotation_special_unitary :
    witnessRotation ∈ Matrix.specialUnitaryGroup (Fin 2) ℂ := by
  sorry

theorem witness_same_momentum :
    SameMomentumGram witnessBase witnessFactor := by
  sorry

theorem witness_factor_nontrivial : witnessFactor ≠ witnessBase := by
  sorry

/-- A concrete nontrivial point in the determinant-fixed `SU(2)` fiber. -/
theorem nontrivial_special_unitary_fiber_witness :
    SameMomentumGram witnessBase witnessFactor ∧
      witnessFactor.det = witnessBase.det ∧
      witnessFactor ≠ witnessBase := by
  sorry

end SpinFiber
