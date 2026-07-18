import Mathlib

noncomputable section

namespace PalatiniTwoMinor

set_option maxHeartbeats 5000000

def spacetimeAlternatingSymbolExperiment (a b c d : Fin 4) : Real :=
  (((b : Real) - (a : Real)) * ((c : Real) - (a : Real)) *
      ((d : Real) - (a : Real)) * ((c : Real) - (b : Real)) *
      ((d : Real) - (b : Real)) * ((d : Real) - (c : Real))) / 12

lemma alternating_two_product_experiment
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b i j : Fin 4) :
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbolExperiment c d a b *
          (coframe i c * coframe j d - coframe i d * coframe j c))) =
      Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          spacetimeAlternatingSymbolExperiment c d a b *
            coframe i c * coframe j d)) := by
  fin_cases a <;> fin_cases b <;>
    simp [spacetimeAlternatingSymbolExperiment, Fin.sum_univ_four] <;> ring

def selectedRowIndex (i j p q : Fin 4) : Fin 4 -> Fin 4
  | 0 => i
  | 1 => j
  | 2 => p
  | 3 => q

def rowSelector (i j p q : Fin 4) : Matrix (Fin 4) (Fin 4) Real :=
  fun r s => if selectedRowIndex i j p q r = s then 1 else 0

lemma rowSelector_mul_apply (coframe : Matrix (Fin 4) (Fin 4) Real)
    (i j p q r c : Fin 4) :
    (rowSelector i j p q * coframe) r c =
      coframe (selectedRowIndex i j p q r) c := by
  simp [rowSelector, Matrix.mul_apply]

lemma det_fin_four_experiment (matrix : Matrix (Fin 4) (Fin 4) Real) :
    matrix.det =
      matrix 0 0 *
          (matrix 1 1 * matrix 2 2 * matrix 3 3 +
            matrix 1 2 * matrix 2 3 * matrix 3 1 +
            matrix 1 3 * matrix 2 1 * matrix 3 2 -
            matrix 1 3 * matrix 2 2 * matrix 3 1 -
            matrix 1 2 * matrix 2 1 * matrix 3 3 -
            matrix 1 1 * matrix 2 3 * matrix 3 2) -
        matrix 0 1 *
          (matrix 1 0 * matrix 2 2 * matrix 3 3 +
            matrix 1 2 * matrix 2 3 * matrix 3 0 +
            matrix 1 3 * matrix 2 0 * matrix 3 2 -
            matrix 1 3 * matrix 2 2 * matrix 3 0 -
            matrix 1 2 * matrix 2 0 * matrix 3 3 -
            matrix 1 0 * matrix 2 3 * matrix 3 2) +
        matrix 0 2 *
          (matrix 1 0 * matrix 2 1 * matrix 3 3 +
            matrix 1 1 * matrix 2 3 * matrix 3 0 +
            matrix 1 3 * matrix 2 0 * matrix 3 1 -
            matrix 1 3 * matrix 2 1 * matrix 3 0 -
            matrix 1 1 * matrix 2 0 * matrix 3 3 -
            matrix 1 0 * matrix 2 3 * matrix 3 1) -
        matrix 0 3 *
          (matrix 1 0 * matrix 2 1 * matrix 3 2 +
            matrix 1 1 * matrix 2 2 * matrix 3 0 +
            matrix 1 2 * matrix 2 0 * matrix 3 1 -
            matrix 1 2 * matrix 2 1 * matrix 3 0 -
            matrix 1 1 * matrix 2 0 * matrix 3 2 -
            matrix 1 0 * matrix 2 2 * matrix 3 1) := by
  rw [Matrix.det_succ_row_zero, Fin.sum_univ_four]
  simp only [Matrix.det_fin_three, Matrix.submatrix_apply]
  simp [Fin.succAbove, Fin.lt_def]
  ring

lemma rowSelector_det (i j p q : Fin 4) :
    (rowSelector i j p q).det =
      spacetimeAlternatingSymbolExperiment i j p q := by
  by_cases hij : i = j
  · subst j
    rw [Matrix.det_zero_of_row_eq (by decide : (0 : Fin 4) ≠ 1) (by
      funext s
      simp [rowSelector, selectedRowIndex])]
    simp [spacetimeAlternatingSymbolExperiment]
  by_cases hip : i = p
  · subst p
    rw [Matrix.det_zero_of_row_eq (by decide : (0 : Fin 4) ≠ 2) (by
      funext s
      simp [rowSelector, selectedRowIndex])]
    simp [spacetimeAlternatingSymbolExperiment]
  by_cases hiq : i = q
  · subst q
    rw [Matrix.det_zero_of_row_eq (by decide : (0 : Fin 4) ≠ 3) (by
      funext s
      simp [rowSelector, selectedRowIndex])]
    simp [spacetimeAlternatingSymbolExperiment]
  by_cases hjp : j = p
  · subst p
    rw [Matrix.det_zero_of_row_eq (by decide : (1 : Fin 4) ≠ 2) (by
      funext s
      simp [rowSelector, selectedRowIndex])]
    simp [spacetimeAlternatingSymbolExperiment]
  by_cases hjq : j = q
  · subst q
    rw [Matrix.det_zero_of_row_eq (by decide : (1 : Fin 4) ≠ 3) (by
      funext s
      simp [rowSelector, selectedRowIndex])]
    simp [spacetimeAlternatingSymbolExperiment]
  by_cases hpq : p = q
  · subst q
    rw [Matrix.det_zero_of_row_eq (by decide : (2 : Fin 4) ≠ 3) (by
      funext s
      simp [rowSelector, selectedRowIndex])]
    simp [spacetimeAlternatingSymbolExperiment]
  fin_cases i <;> fin_cases j <;> fin_cases p <;> fin_cases q
  all_goals simp_all
  all_goals
    simp [rowSelector, selectedRowIndex, spacetimeAlternatingSymbolExperiment,
      det_fin_four_experiment]
  all_goals norm_num

lemma alternating_four_product_experiment
    (coframe : Matrix (Fin 4) (Fin 4) Real) (i j p q : Fin 4) :
    Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            spacetimeAlternatingSymbolExperiment c d a b *
              coframe i c * coframe j d * coframe p a * coframe q b)))) =
      coframe.det * spacetimeAlternatingSymbolExperiment i j p q := by
  calc
    _ = (rowSelector i j p q * coframe).det := by
      rw [det_fin_four_experiment]
      simp only [rowSelector_mul_apply, selectedRowIndex]
      simp [spacetimeAlternatingSymbolExperiment, Fin.sum_univ_four]
      ring
    _ = (rowSelector i j p q).det * coframe.det := Matrix.det_mul _ _
    _ = coframe.det * spacetimeAlternatingSymbolExperiment i j p q := by
      rw [rowSelector_det]
      ring

def alternatingMatrix (i j : Fin 4) : Matrix (Fin 4) (Fin 4) Real :=
  fun k l => spacetimeAlternatingSymbolExperiment i j k l

def coframeMinorMatrix (coframe : Matrix (Fin 4) (Fin 4) Real)
    (i j : Fin 4) : Matrix (Fin 4) (Fin 4) Real :=
  fun a b => Finset.sum Finset.univ (fun c =>
    Finset.sum Finset.univ (fun d =>
      spacetimeAlternatingSymbolExperiment c d a b *
        coframe i c * coframe j d))

def inverseMinorMatrix (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (i j : Fin 4) : Matrix (Fin 4) (Fin 4) Real :=
  inverseCoframe * alternatingMatrix i j * inverseCoframe.transpose

lemma inverseMinorMatrix_apply
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real) (i j a b : Fin 4) :
    inverseMinorMatrix inverseCoframe i j a b =
      Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbolExperiment i j k l *
            inverseCoframe a k * inverseCoframe b l)) := by
  simp [inverseMinorMatrix, alternatingMatrix, Matrix.mul_apply,
    Fin.sum_univ_four]
  ring

lemma coframeMinorMatrix_contraction
    (coframe : Matrix (Fin 4) (Fin 4) Real) (i j : Fin 4) :
    coframe * coframeMinorMatrix coframe i j * coframe.transpose =
      coframe.det • alternatingMatrix i j := by
  ext p q
  rw [show (coframe * coframeMinorMatrix coframe i j *
        coframe.transpose) p q =
      Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          coframe p a * coframeMinorMatrix coframe i j a b * coframe q b)) by
      simp [Matrix.mul_apply, Fin.sum_univ_four]
      ring]
  rw [show Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          coframe p a * coframeMinorMatrix coframe i j a b * coframe q b)) =
      Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun b =>
              spacetimeAlternatingSymbolExperiment c d a b *
                coframe i c * coframe j d * coframe p a * coframe q b)))) by
      simp [coframeMinorMatrix, Fin.sum_univ_four]
      ring]
  rw [alternating_four_product_experiment]
  rfl

lemma inverseMinorMatrix_contraction
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hRight : coframe * inverseCoframe = 1) (i j : Fin 4) :
    coframe * inverseMinorMatrix inverseCoframe i j * coframe.transpose =
      alternatingMatrix i j := by
  unfold inverseMinorMatrix
  calc
    coframe * (inverseCoframe * alternatingMatrix i j *
        inverseCoframe.transpose) * coframe.transpose =
      (coframe * inverseCoframe) * alternatingMatrix i j *
        (inverseCoframe.transpose * coframe.transpose) := by
          simp only [Matrix.mul_assoc]
    _ = alternatingMatrix i j := by
      rw [← Matrix.transpose_mul, hRight]
      simp

theorem alternating_coframe_two_minor_experiment
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (a b i j : Fin 4) :
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbolExperiment c d a b *
          (coframe i c * coframe j d - coframe i d * coframe j c))) =
      coframe.det * Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbolExperiment i j k l *
            inverseCoframe a k * inverseCoframe b l)) := by
  rw [alternating_two_product_experiment]
  rw [← inverseMinorMatrix_apply]
  change coframeMinorMatrix coframe i j a b =
    (coframe.det • inverseMinorMatrix inverseCoframe i j) a b
  have hMatrix : coframeMinorMatrix coframe i j =
      coframe.det • inverseMinorMatrix inverseCoframe i j := by
    refine Matrix.mul_right_injective_of_inv
      inverseCoframe coframe hLeft ?_
    have hTranspose :
        coframe.transpose * inverseCoframe.transpose = 1 := by
      rw [← Matrix.transpose_mul, hLeft]
      simp
    refine Matrix.mul_left_injective_of_inv
      coframe.transpose inverseCoframe.transpose hTranspose ?_
    change coframe * coframeMinorMatrix coframe i j * coframe.transpose =
      coframe * (coframe.det • inverseMinorMatrix inverseCoframe i j) *
        coframe.transpose
    rw [coframeMinorMatrix_contraction]
    rw [Matrix.mul_smul, Matrix.smul_mul]
    rw [inverseMinorMatrix_contraction coframe inverseCoframe hRight]
  exact congrFun (congrFun hMatrix a) b

end PalatiniTwoMinor
