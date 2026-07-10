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

Provenance: clean-room finite matrix formalization completed by Aristotle
project `ccff7fc8-bba7-4260-a335-25597d622551` during the 2026-07-09 all-mass
run and independently checked under the repository's pinned Lean toolchain.
-/

open scoped Matrix ComplexOrder

namespace PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber

abbrev Mat2 := Matrix (Fin 2) (Fin 2) ℂ

/-- Two factors represent the same positive momentum matrix. -/
def SameMomentumGram (M0 M : Mat2) : Prop :=
  M * Mᴴ = M0 * M0ᴴ

/-
Right multiplication by a unitary matrix preserves the positive momentum
Gram matrix.
-/
theorem unitary_right_action_preserves
    (M0 U : Mat2) (hU : U ∈ Matrix.unitaryGroup (Fin 2) ℂ) :
    SameMomentumGram M0 (M0 * U) := by
  simp_all +decide [ SameMomentumGram, Matrix.mul_assoc ];
  simp_all +decide [ ← Matrix.mul_assoc, Matrix.mem_unitaryGroup_iff ];
  simp_all +decide [ mul_assoc, star ]

/-
**Unitary factorization fiber.**  If `L0` is a two-sided inverse of `M0`,
then every factor of the same positive momentum Gram matrix is `M0 U` for a
unique unitary matrix `U`.
-/
theorem factorization_fiber_unitary
    (M0 L0 M : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (hgram : SameMomentumGram M0 M) :
    ∃! U : Mat2, U ∈ Matrix.unitaryGroup (Fin 2) ℂ ∧ M = M0 * U := by
  refine' ⟨ L0 * M, _, _ ⟩ <;> simp_all +decide;
  · simp_all +decide [ Matrix.mem_unitaryGroup_iff ];
    simp_all +decide [ ← Matrix.mul_assoc, SameMomentumGram ];
    simp_all +decide [ mul_assoc, star ];
    simp_all +decide [ ← Matrix.conjTranspose_mul ];
  · simp_all +decide [ ← Matrix.mul_assoc ]

/-
**Phase-fixed fiber.**  If determinant is fixed as well, the unique
unitary factor lies in `SU(2)`.
-/
theorem factorization_fiber_special_unitary
    (M0 L0 M : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (hgram : SameMomentumGram M0 M) (hdet : M.det = M0.det) :
    ∃! U : Mat2,
      U ∈ Matrix.specialUnitaryGroup (Fin 2) ℂ ∧ M = M0 * U := by
  have hdet0 : M0.det ≠ 0 := by
    intro hzero
    have hdetLeft := congrArg Matrix.det hleft
    rw [Matrix.det_mul, Matrix.det_one, hzero, mul_zero] at hdetLeft
    exact zero_ne_one hdetLeft
  -- Existence: find U := L0 * M. By factorization_fiber_unitary, this U is in unitaryGroup, and since determinant is fixed, U ∈ specialUnitaryGroup.
  have hu_exists : ∃ (U : Mat2), U ∈ Matrix.unitaryGroup (Fin 2) ℂ ∧ M = M0 * U ∧ U.det = 1 := by
    have h_unitary : ∃ U : Mat2, U ∈ Matrix.unitaryGroup (Fin 2) ℂ ∧ M = M0 * U := by
      exact ExistsUnique.exists ( factorization_fiber_unitary M0 L0 M hleft hright hgram )
    obtain ⟨U, hU_unitary, hU⟩ := h_unitary
    use U
    simp_all +decide [ SameMomentumGram ];
  obtain ⟨ U, hU₁, hU₂, hU₃ ⟩ := hu_exists; use U; simp_all +decide [ Matrix.mem_specialUnitaryGroup_iff ] ;
  intro V hV₁ hV₂ hV₃; apply_fun ( fun x => L0 * x ) at hV₃; simp_all +decide [ ← mul_assoc ] ;

/-! ## Explicit nondegenerate `SU(2)` orbit witness -/

def witnessBase : Mat2 := !![2, 0; 0, 1]

noncomputable def witnessInverse : Mat2 := !![(1 / 2 : ℂ), 0; 0, 1]

def witnessRotation : Mat2 := !![0, 1; -1, 0]

noncomputable def witnessFactor : Mat2 := witnessBase * witnessRotation

theorem witness_two_sided_inverse :
    witnessInverse * witnessBase = 1 ∧ witnessBase * witnessInverse = 1 := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;> norm_num [ witnessInverse, witnessBase ]

theorem witness_rotation_special_unitary :
    witnessRotation ∈ Matrix.specialUnitaryGroup (Fin 2) ℂ := by
  constructor;
  · simp +decide [ Matrix.mem_unitaryGroup_iff ];
    unfold witnessRotation; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Matrix.conjTranspose ] ;
  · unfold witnessRotation; norm_num [ Matrix.det_fin_two ] ;

theorem witness_same_momentum :
    SameMomentumGram witnessBase witnessFactor := by
  unfold witnessFactor witnessBase;
  unfold witnessRotation; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Matrix.conjTranspose ] ;

theorem witness_factor_nontrivial : witnessFactor ≠ witnessBase := by
  norm_num [ witnessFactor, witnessBase ];
  norm_num [ ← List.ofFn_inj, witnessRotation ]

/-
A concrete nontrivial point in the determinant-fixed `SU(2)` fiber.
-/
theorem nontrivial_special_unitary_fiber_witness :
    SameMomentumGram witnessBase witnessFactor ∧
      witnessFactor.det = witnessBase.det ∧
      witnessFactor ≠ witnessBase := by
  -- Show that the witness factor is not equal to the witness base by comparing their entries.
  simp [witnessBase, witnessFactor];
  norm_num [ ← List.ofFn_inj, witnessRotation ];
  -- Let's compute the product of the matrix with its conjugate transpose.
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Matrix.conjTranspose ]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber.factorization_fiber_special_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms factorization_fiber_special_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber.nontrivial_special_unitary_fiber_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nontrivial_special_unitary_fiber_witness

end PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber
