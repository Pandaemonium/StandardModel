import Mathlib

/-!
# Draft.NullEdgeDiracTwoSheetCore

Finite branch-projector algebra forced by a Dirac square root.

If a finite operator `D` satisfies `D^2 = m^2 I`, then the plus and minus
projectors `(1/2)(I plus/minus m^{-1}D)` are complementary idempotents and `D`
acts on them with eigenvalues `+m` and `-m`. This is the algebraic branch
structure behind the two-sheet interpretation in the null-edge program.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeDiracTwoSheetCore

open Matrix Complex

variable {Idx : Type*} [Fintype Idx] [DecidableEq Idx]

/-- The positive branch projector `(1/2)(I + m^{-1}D)`. -/
def plusProjector (D : Matrix Idx Idx Complex) (m : Complex) :
    Matrix Idx Idx Complex :=
  ((2 : Complex)⁻¹) • ((1 : Matrix Idx Idx Complex) + m⁻¹ • D)

/-- The negative branch projector `(1/2)(I - m^{-1}D)`. -/
def minusProjector (D : Matrix Idx Idx Complex) (m : Complex) :
    Matrix Idx Idx Complex :=
  ((2 : Complex)⁻¹) • ((1 : Matrix Idx Idx Complex) - m⁻¹ • D)

omit [Fintype Idx] in
/-- The two branch projectors sum to the identity. -/
theorem plusProjector_add_minusProjector
    (D : Matrix Idx Idx Complex) (m : Complex) :
    plusProjector D m + minusProjector D m =
      (1 : Matrix Idx Idx Complex) := by
  simp only [plusProjector, minusProjector]
  module

omit [Fintype Idx] in
/-- The difference of the branch projectors is the normalized Dirac operator. -/
theorem plusProjector_sub_minusProjector
    (D : Matrix Idx Idx Complex) (m : Complex) :
    plusProjector D m - minusProjector D m = m⁻¹ • D := by
  simp only [plusProjector, minusProjector]
  module

/-- The positive branch projector is idempotent when `D^2 = m^2 I`. -/
theorem plusProjector_idempotent_of_sq
    (D : Matrix Idx Idx Complex) (m : Complex) (hm : m != 0)
    (hD : D * D = (m * m) • (1 : Matrix Idx Idx Complex)) :
    plusProjector D m * plusProjector D m = plusProjector D m := by
  have hm' : m ≠ 0 := bne_iff_ne.mp hm
  simp only [plusProjector]
  rw [Matrix.mul_smul, Matrix.smul_mul, Matrix.add_mul, Matrix.mul_add,
    Matrix.mul_add]
  simp only [Matrix.one_mul, Matrix.mul_one, Matrix.mul_smul, Matrix.smul_mul]
  rw [hD]
  match_scalars <;> field_simp <;> ring

/-- The negative branch projector is idempotent when `D^2 = m^2 I`. -/
theorem minusProjector_idempotent_of_sq
    (D : Matrix Idx Idx Complex) (m : Complex) (hm : m != 0)
    (hD : D * D = (m * m) • (1 : Matrix Idx Idx Complex)) :
    minusProjector D m * minusProjector D m = minusProjector D m := by
  have hm' : m ≠ 0 := bne_iff_ne.mp hm
  simp only [minusProjector]
  rw [Matrix.mul_smul, Matrix.smul_mul, Matrix.sub_mul, Matrix.mul_sub,
    Matrix.mul_sub]
  simp only [Matrix.one_mul, Matrix.mul_one, Matrix.mul_smul, Matrix.smul_mul]
  rw [hD]
  match_scalars <;> field_simp <;> ring

/-- The two branch projectors are orthogonal when `D^2 = m^2 I`. -/
theorem plus_minus_orthogonal_of_sq
    (D : Matrix Idx Idx Complex) (m : Complex) (hm : m != 0)
    (hD : D * D = (m * m) • (1 : Matrix Idx Idx Complex)) :
    plusProjector D m * minusProjector D m = 0 := by
  have hm' : m ≠ 0 := bne_iff_ne.mp hm
  simp only [plusProjector, minusProjector]
  rw [Matrix.mul_smul, Matrix.smul_mul, Matrix.add_mul, Matrix.mul_sub,
    Matrix.mul_sub]
  simp only [Matrix.one_mul, Matrix.mul_one, Matrix.mul_smul, Matrix.smul_mul]
  rw [hD]
  match_scalars <;> field_simp <;> ring

/-- `D` acts on the positive branch with eigenvalue `m`. -/
theorem dirac_acts_on_plusProjector
    (D : Matrix Idx Idx Complex) (m : Complex) (hm : m != 0)
    (hD : D * D = (m * m) • (1 : Matrix Idx Idx Complex)) :
    D * plusProjector D m = m • plusProjector D m := by
  have hm' : m ≠ 0 := bne_iff_ne.mp hm
  simp only [plusProjector]
  rw [Matrix.mul_smul, Matrix.mul_add, Matrix.mul_one, Matrix.mul_smul, hD]
  match_scalars <;> field_simp

/-- `D` acts on the negative branch with eigenvalue `-m`. -/
theorem dirac_acts_on_minusProjector
    (D : Matrix Idx Idx Complex) (m : Complex) (hm : m != 0)
    (hD : D * D = (m * m) • (1 : Matrix Idx Idx Complex)) :
    D * minusProjector D m = (-m) • minusProjector D m := by
  have hm' : m ≠ 0 := bne_iff_ne.mp hm
  simp only [minusProjector]
  rw [Matrix.mul_smul, Matrix.mul_sub, Matrix.mul_one, Matrix.mul_smul, hD]
  match_scalars <;> field_simp

end PhysicsSM.Draft.NullEdgeDiracTwoSheetCore

end
