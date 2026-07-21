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

/-! ## Image and fixed-phase fiber classification -/

/-- The determinant of a positive Gram factor is the squared magnitude of the
factor determinant. -/
theorem det_gram_eq_normSq (M : Mat2) :
    (M * Mᴴ).det = Complex.normSq M.det := by
  convert Matrix.det_mul M Mᴴ using 1
  norm_num [Complex.normSq, Complex.ext_iff]
  ring

/-- Equal positive momentum Grams force equal determinant magnitudes. -/
theorem sameMomentum_forces_det_normSq
    (M0 M : Mat2) (hgram : SameMomentumGram M0 M) :
    Complex.normSq M.det = Complex.normSq M0.det := by
  convert congr_arg Matrix.det hgram.symm using 1
  simp +decide [Complex.normSq_eq_norm_sq, Matrix.det_mul]
  simp +decide [Complex.mul_conj, Complex.normSq_eq_norm_sq]
  norm_cast
  aesop

/-- A diagonal unitary that realizes an arbitrary allowed determinant phase. -/
def phaseUnitary (u : ℂ) : Mat2 := !![u, 0; 0, 1]

theorem phaseUnitary_det (u : ℂ) : (phaseUnitary u).det = u := by
  unfold phaseUnitary
  norm_num [Matrix.det_fin_two]

theorem phaseUnitary_mem_unitary (u : ℂ)
    (hu : Complex.normSq u = 1) :
    phaseUnitary u ∈ Matrix.unitaryGroup (Fin 2) ℂ := by
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp_all +decide [Matrix.mul_apply, Complex.ext_iff]
    · unfold phaseUnitary
      norm_num [Complex.normSq] at *
      ring_nf at *
      aesop
    · unfold phaseUnitary
      norm_num
    · unfold phaseUnitary
      norm_num
    · unfold phaseUnitary
      norm_num
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Complex.ext_iff, Matrix.mul_apply, phaseUnitary]
    exact ⟨by simpa [Complex.normSq_apply] using hu, by ring⟩

theorem det_ne_zero_of_leftInverse
    (M0 L0 : Mat2) (hleft : L0 * M0 = 1) : M0.det ≠ 0 := by
  apply_fun Matrix.det at hleft
  aesop

/-- Every complex phase with the momentum-forced magnitude is realized by an
explicit right-unitary factor change. The right-inverse hypothesis is retained
to match the surrounding two-sided-inverse interface, although the proof only
needs the left inverse. -/
theorem fixedMomentum_phase_realizable
    (M0 L0 : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (z : ℂ)
    (hz : Complex.normSq z = Complex.normSq M0.det) :
    ∃ M : Mat2, SameMomentumGram M0 M ∧ M.det = z := by
  obtain ⟨u, hu⟩ : ∃ u : ℂ, Complex.normSq u = 1 ∧ u * M0.det = z := by
    by_cases h : Matrix.det M0 = 0
    · apply_fun Matrix.det at hleft hright
      aesop
    · refine ⟨z / M0.det, ?_, ?_⟩ <;>
        simp_all +decide [Complex.normSq_eq_norm_sq]
  refine ⟨M0 * phaseUnitary u,
    unitary_right_action_preserves M0 _ (phaseUnitary_mem_unitary _ hu.1), ?_⟩
  simp_all +decide [Matrix.det_mul]
  rw [← hu.2, mul_comm, phaseUnitary_det]

/-- At fixed nondegenerate momentum, determinant phase is free while its
magnitude is fixed. -/
theorem fixedMomentum_phase_iff
    (M0 L0 : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (z : ℂ) :
    (∃ M : Mat2, SameMomentumGram M0 M ∧ M.det = z) ↔
      Complex.normSq z = Complex.normSq M0.det := by
  constructor
  · rintro ⟨M, hM, rfl⟩
    exact sameMomentum_forces_det_normSq M0 M hM
  · exact fixedMomentum_phase_realizable M0 L0 hleft hright z

/-- Once momentum and determinant phase are fixed, the remaining factorization
freedom is the unique right `SU(2)` orbit. -/
theorem fixedMomentum_fixedPhase_fiber
    (M0 L0 M : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (hgram : SameMomentumGram M0 M) (hdet : M.det = M0.det) :
    ∃! U : Mat2,
      U ∈ Matrix.specialUnitaryGroup (Fin 2) ℂ ∧ M = M0 * U :=
  factorization_fiber_special_unitary M0 L0 M hleft hright hgram hdet

def witnessQuarterTurn : Mat2 := !![Complex.I, 0; 0, 1]

noncomputable def witnessPhaseRotated : Mat2 := witnessBase * witnessQuarterTurn

/-- Nondegenerate control: fixed momentum allows a genuine quarter-turn change
of determinant phase. -/
theorem witness_same_momentum_different_phase :
    SameMomentumGram witnessBase witnessPhaseRotated ∧
      witnessPhaseRotated.det = 2 * Complex.I ∧
      witnessBase.det = 2 ∧ witnessPhaseRotated.det ≠ witnessBase.det := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · unfold witnessPhaseRotated witnessBase witnessQuarterTurn
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Complex.ext_iff, Matrix.conjTranspose_apply]
  · norm_num [Complex.ext_iff, Matrix.det_fin_two, witnessBase,
      witnessPhaseRotated]
    norm_num [Matrix.vecMul, witnessQuarterTurn]
  · norm_num [witnessBase]
  · unfold witnessPhaseRotated witnessBase witnessQuarterTurn
    norm_num [Complex.ext_iff]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber.factorization_fiber_special_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms factorization_fiber_special_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber.nontrivial_special_unitary_fiber_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nontrivial_special_unitary_fiber_witness

/-- info: 'PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber.fixedMomentum_phase_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixedMomentum_phase_iff

/-- info: 'PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber.fixedMomentum_fixedPhase_fiber' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixedMomentum_fixedPhase_fiber

/-- info: 'PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber.witness_same_momentum_different_phase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_same_momentum_different_phase

end PhysicsSM.Draft.NullEdge.NullFactorizationSpinFiber
