import Mathlib

/-!
# Coordinate stabilizer of the upper `2 x 2` matrix block

Clean-room coordinate rung modeled on the first-factor calculation in
Baez--Schwahn, arXiv:2606.15235, Theorem 1. This target is deliberately only a
matrix theorem inside `SU(3)`; it does not claim the intrinsic `F4` theorem or
the identity-component glue.

Provenance: proof synthesized by Aristotle project
`b73917ae-a947-4e50-b8d8-dbd6448518b5`, then compiled and semantically audited
against the pinned repository toolchain on 2026-07-11. The source theorem is
used only as mathematical orientation; this is a clean-room coordinate proof.
-/

noncomputable section

namespace PhysicsSM.Draft.JordanCliffordH2BlockStabilizer

open Matrix Complex

abbrev Mat3 := Matrix (Fin 3) (Fin 3) Complex

/-- Matrices supported in the upper-left `2 x 2` block. -/
def SupportedUpperBlock (X : Mat3) : Prop :=
  forall i j, (i = 2 ∨ j = 2) -> X i j = 0

/-- Conjugation by `U` preserves the upper-left block. -/
def StabilizesUpperBlock (U : Mat3) : Prop :=
  forall X : Mat3, SupportedUpperBlock X ->
    SupportedUpperBlock (U * X * Uᴴ)

/-- The coordinate block-diagonal condition for a `2 + 1` split. -/
def IsBlockDiagonal21 (U : Mat3) : Prop :=
  (forall i : Fin 3, i ≠ 2 -> U i 2 = 0) ∧
    (forall j : Fin 3, j ≠ 2 -> U 2 j = 0)

/-- Exact unitarity, stated on both sides to keep the coordinate proof direct. -/
def IsUnitary3 (U : Mat3) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

/-- Coordinate stabilizer theorem: a unitary `3 x 3` matrix preserves the
upper `2 x 2` matrix block under conjugation iff it is block diagonal for the
`2 + 1` split. -/
theorem stabilizesUpperBlock_iff_blockDiagonal
    (U : Mat3) (hU : IsUnitary3 U) :
    StabilizesUpperBlock U <-> IsBlockDiagonal21 U := by
  constructor
  · intro hStab
    -- Row 2 of `U` is off-diagonal-free: the `(2,2)` entry of the conjugated basis
    -- matrix `U * single a a 1 * Uᴴ` equals `‖U 2 a‖²`, forced to `0` by stability.
    have hrow : ∀ a : Fin 3, a ≠ 2 → U 2 a = 0 := by
      intro a ha
      have hsupp : SupportedUpperBlock (Matrix.single a a (1 : ℂ)) := by
        intro i j hij
        rcases hij with rfl | rfl <;> fin_cases a <;> simp_all
      have hz := hStab _ hsupp 2 2 (Or.inl rfl)
      have hsq : U 2 a * (starRingEnd ℂ) (U 2 a) = 0 := by
        fin_cases a <;>
          simpa [Matrix.mul_apply, Fin.sum_univ_three, Matrix.conjTranspose_apply,
            Matrix.single_apply] using hz
      simpa [mul_comm, Complex.mul_conj, Complex.normSq_eq_zero] using hsq
    refine ⟨fun i hi => ?_, hrow⟩
    -- Column 2 vanishes off the corner, using unitarity `U * Uᴴ = 1`.
    have hcorner : U 2 2 * (starRingEnd ℂ) (U 2 2) = 1 := by
      have h := congr_fun (congr_fun hU.2 2) 2
      simpa [Matrix.mul_apply, Fin.sum_univ_three, Matrix.conjTranspose_apply,
        Matrix.one_apply, hrow 0 (by decide), hrow 1 (by decide)] using h
    have hi2 : U i 2 * (starRingEnd ℂ) (U 2 2) = 0 := by
      have h := congr_fun (congr_fun hU.2 i) 2
      simpa [Matrix.mul_apply, Fin.sum_univ_three, Matrix.conjTranspose_apply,
        Matrix.one_apply, hi, hrow 0 (by decide), hrow 1 (by decide)] using h
    have hne : (starRingEnd ℂ) (U 2 2) ≠ 0 := by
      intro h; rw [h, mul_zero] at hcorner; exact one_ne_zero hcorner.symm
    exact (mul_eq_zero.1 hi2).resolve_right hne
  · intro hBlock X hX i j hij
    obtain ⟨hcol, hrow⟩ := hBlock
    rcases hij with rfl | rfl <;>
      simp [Matrix.mul_apply, Fin.sum_univ_three, Matrix.conjTranspose_apply,
        hrow 0 (by decide), hrow 1 (by decide),
        hX 0 2 (Or.inr rfl), hX 1 2 (Or.inr rfl), hX 2 0 (Or.inl rfl),
        hX 2 1 (Or.inl rfl), hX 2 2 (Or.inl rfl)]

/-- Determinant factorization for the resulting `2 + 1` block. This is the
generic determinant factorization for a block-diagonal matrix; the theorem
does not itself assume unitarity or determinant one. -/
theorem det_eq_upperBlock_det_mul_corner
    (U : Mat3) (hBlock : IsBlockDiagonal21 U) :
    U.det =
      (U.submatrix (Fin.castLE (by omega : 2 ≤ 3))
        (Fin.castLE (by omega : 2 ≤ 3))).det * U 2 2 := by
  simp +decide [ Matrix.det_fin_three, IsBlockDiagonal21 ] at *;
  simp_all +decide [ Fin.forall_fin_succ ];
  simp +decide [ Matrix.det_fin_two, submatrix ] ; ring!

/-- A nonidentity block-diagonal special-unitary witness. -/
def phaseWitness : Mat3 :=
  !![Complex.I, 0, 0; 0, -Complex.I, 0; 0, 0, 1]

theorem phaseWitness_unitary : IsUnitary3 phaseWitness := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;> norm_num [ phaseWitness ];
  all_goals simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ, Matrix.vecMul, dotProduct ]

theorem phaseWitness_det : phaseWitness.det = 1 := by
  unfold phaseWitness; norm_num [ Complex.ext_iff, Matrix.det_fin_three ] ;
  simp +zetaDelta at *

/-- The stabilizing special-unitary witness is genuinely nonidentity. -/
theorem phaseWitness_ne_one : phaseWitness ≠ 1 := by
  intro h
  have h00 := congr_fun (congr_fun h 0) 0
  have him := congrArg Complex.im h00
  norm_num [phaseWitness] at him

theorem phaseWitness_stabilizes : StabilizesUpperBlock phaseWitness :=
  (stabilizesUpperBlock_iff_blockDiagonal phaseWitness phaseWitness_unitary).mpr
    (by constructor <;> intro i hi <;> fin_cases i <;> simp_all [phaseWitness])

/-- A unitary control that swaps one upper-block axis with the complement. -/
def mixingControl : Mat3 :=
  !![1, 0, 0; 0, 0, 1; 0, 1, 0]

theorem mixingControl_unitary : IsUnitary3 mixingControl := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [mixingControl, Matrix.mul_apply, Fin.sum_univ_three, Matrix.conjTranspose_apply]

theorem mixingControl_not_stabilizes :
    Not (StabilizesUpperBlock mixingControl) := by
  intro h
  have hsupp : SupportedUpperBlock (!![0, 0, 0; 0, 1, 0; 0, 0, 0] : Mat3) := by
    intro i j hij
    fin_cases i <;> fin_cases j <;> simp_all
  have hz := h _ hsupp 2 2 (Or.inl rfl)
  simp [mixingControl, Matrix.mul_apply, Fin.sum_univ_three, Matrix.conjTranspose_apply] at hz

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.JordanCliffordH2BlockStabilizer.stabilizesUpperBlock_iff_blockDiagonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms stabilizesUpperBlock_iff_blockDiagonal

/-- info: 'PhysicsSM.Draft.JordanCliffordH2BlockStabilizer.det_eq_upperBlock_det_mul_corner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_eq_upperBlock_det_mul_corner

/-- info: 'PhysicsSM.Draft.JordanCliffordH2BlockStabilizer.phaseWitness_stabilizes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phaseWitness_stabilizes

/-- info: 'PhysicsSM.Draft.JordanCliffordH2BlockStabilizer.mixingControl_not_stabilizes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mixingControl_not_stabilizes

end PhysicsSM.Draft.JordanCliffordH2BlockStabilizer
