import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge

noncomputable section

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge

open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation

set_option maxHeartbeats 3000000

private lemma responseDetFinFour
    (matrix : Matrix (Fin 4) (Fin 4) Real) :
    matrix.det =
      matrix 0 0 * (matrix 1 1 * matrix 2 2 * matrix 3 3 -
        matrix 1 1 * matrix 2 3 * matrix 3 2 -
        matrix 1 2 * matrix 2 1 * matrix 3 3 +
        matrix 1 2 * matrix 2 3 * matrix 3 1 +
        matrix 1 3 * matrix 2 1 * matrix 3 2 -
        matrix 1 3 * matrix 2 2 * matrix 3 1) -
      matrix 0 1 * (matrix 1 0 * matrix 2 2 * matrix 3 3 -
        matrix 1 0 * matrix 2 3 * matrix 3 2 -
        matrix 1 2 * matrix 2 0 * matrix 3 3 +
        matrix 1 2 * matrix 2 3 * matrix 3 0 +
        matrix 1 3 * matrix 2 0 * matrix 3 2 -
        matrix 1 3 * matrix 2 2 * matrix 3 0) +
      matrix 0 2 * (matrix 1 0 * matrix 2 1 * matrix 3 3 -
        matrix 1 0 * matrix 2 3 * matrix 3 1 -
        matrix 1 1 * matrix 2 0 * matrix 3 3 +
        matrix 1 1 * matrix 2 3 * matrix 3 0 +
        matrix 1 3 * matrix 2 0 * matrix 3 1 -
        matrix 1 3 * matrix 2 1 * matrix 3 0) -
      matrix 0 3 * (matrix 1 0 * matrix 2 1 * matrix 3 2 -
        matrix 1 0 * matrix 2 2 * matrix 3 1 -
        matrix 1 1 * matrix 2 0 * matrix 3 2 +
        matrix 1 1 * matrix 2 2 * matrix 3 0 +
        matrix 1 2 * matrix 2 0 * matrix 3 1 -
        matrix 1 2 * matrix 2 1 * matrix 3 0) := by
  rw [Matrix.det_succ_row_zero]
  simp +decide [Fin.sum_univ_four, Matrix.det_fin_three, Fin.succAbove]
  ring

private def responseAuxiliaryMatrix
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (a b i j : Fin 4) : Matrix (Fin 4) (Fin 4) Real :=
  ![inverseCoframe a, inverseCoframe b,
    fun k => if k = i then 1 else 0,
    fun k => if k = j then 1 else 0]

private lemma responseAuxiliaryMatrix_det
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (a b i j : Fin 4) :
    (responseAuxiliaryMatrix inverseCoframe a b i j).det =
      Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbol i j k l *
            inverseCoframe a k * inverseCoframe b l)) := by
  unfold responseAuxiliaryMatrix spacetimeAlternatingSymbol
  rw [responseDetFinFour]
  fin_cases i <;> fin_cases j <;>
    simp +decide [Fin.sum_univ_four] <;> ring!

private lemma responseAuxiliaryMatrix_mul_det
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1) (a b i j : Fin 4) :
    (responseAuxiliaryMatrix inverseCoframe a b i j * coframe).det =
      (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          spacetimeAlternatingSymbol c d a b *
            (coframe i c * coframe j d -
              coframe i d * coframe j c))) := by
  unfold responseAuxiliaryMatrix
  simp +decide [Fin.sum_univ_four, spacetimeAlternatingSymbol]
  rw [← Matrix.det_mul]
  convert responseDetFinFour _ using 1
  simp +decide [Matrix.mul_apply, Fin.sum_univ_succ]
  have hEntry : forall r c : Fin 4,
      inverseCoframe r 0 * coframe 0 c +
        (inverseCoframe r 1 * coframe 1 c +
          (inverseCoframe r 2 * coframe 2 c +
            inverseCoframe r 3 * coframe 3 c)) =
        if r = c then 1 else 0 := by
    intro r c
    have h := congrFun (congrFun hLeft r) c
    simp_all +decide [Matrix.mul_apply, Fin.sum_univ_four]
    simpa only [← add_assoc, Matrix.one_apply] using h
  simp +decide [hEntry]
  fin_cases a <;> fin_cases b <;> simp +decide <;> ring

private lemma responseAlternatingWedge
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b i j : Fin 4) :
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbol c d a b *
          (coframe i c * coframe j d -
            coframe i d * coframe j c))) =
      Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          spacetimeAlternatingSymbol c d a b *
            coframe i c * coframe j d)) := by
  fin_cases a <;> fin_cases b <;>
    simp [spacetimeAlternatingSymbol, Fin.sum_univ_four] <;> ring

theorem det_mul_inverse_pair_experiment
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (a b i j : Fin 4) :
    coframe.det *
        (inverseCoframe a i * inverseCoframe b j -
          inverseCoframe a j * inverseCoframe b i) =
      (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          Finset.sum Finset.univ (fun k =>
            Finset.sum Finset.univ (fun l =>
              spacetimeAlternatingSymbol a b c d *
                spacetimeAlternatingSymbol i j k l *
                coframe k c * coframe l d)))) := by
  have hInner : forall k l : Fin 4,
      Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          spacetimeAlternatingSymbol a b c d *
            coframe k c * coframe l d)) =
        coframe.det * Finset.sum Finset.univ (fun p =>
          Finset.sum Finset.univ (fun q =>
            spacetimeAlternatingSymbol k l p q *
              inverseCoframe a p * inverseCoframe b q)) := by
    intro k l
    have h := alternating_coframe_two_minor
      coframe inverseCoframe hLeft a b k l
    rw [responseAlternatingWedge] at h
    have hSymbol : forall c d : Fin 4,
        spacetimeAlternatingSymbol c d a b =
          spacetimeAlternatingSymbol a b c d := by
      intro c d
      unfold spacetimeAlternatingSymbol
      ring
    simpa only [hSymbol] using h
  have hInversePair :
      inverseCoframe a i * inverseCoframe b j -
          inverseCoframe a j * inverseCoframe b i =
        (1 / 2 : Real) * Finset.sum Finset.univ (fun k =>
          Finset.sum Finset.univ (fun l =>
            spacetimeAlternatingSymbol i j k l *
              Finset.sum Finset.univ (fun p =>
                Finset.sum Finset.univ (fun q =>
                  spacetimeAlternatingSymbol k l p q *
                    inverseCoframe a p * inverseCoframe b q)))) := by
    fin_cases i <;> fin_cases j <;>
      simp +decide [spacetimeAlternatingSymbol, Fin.sum_univ_four] <;> ring
  rw [hInversePair]
  calc
    coframe.det *
          ((1 / 2 : Real) * Finset.sum Finset.univ (fun k =>
            Finset.sum Finset.univ (fun l =>
              spacetimeAlternatingSymbol i j k l *
                Finset.sum Finset.univ (fun p =>
                  Finset.sum Finset.univ (fun q =>
                    spacetimeAlternatingSymbol k l p q *
                      inverseCoframe a p * inverseCoframe b q))))) =
        (1 / 2 : Real) *
          (coframe.det * Finset.sum Finset.univ (fun k =>
            Finset.sum Finset.univ (fun l =>
              spacetimeAlternatingSymbol i j k l *
                Finset.sum Finset.univ (fun p =>
                  Finset.sum Finset.univ (fun q =>
                    spacetimeAlternatingSymbol k l p q *
                      inverseCoframe a p * inverseCoframe b q))))) := by ring
    _ = _ := by
      congr 1
      calc
        coframe.det * Finset.sum Finset.univ (fun k =>
              Finset.sum Finset.univ (fun l =>
                spacetimeAlternatingSymbol i j k l *
                  Finset.sum Finset.univ (fun p =>
                    Finset.sum Finset.univ (fun q =>
                      spacetimeAlternatingSymbol k l p q *
                        inverseCoframe a p * inverseCoframe b q)))) =
            Finset.sum Finset.univ (fun k =>
              Finset.sum Finset.univ (fun l =>
                coframe.det *
                  (spacetimeAlternatingSymbol i j k l *
                    Finset.sum Finset.univ (fun p =>
                      Finset.sum Finset.univ (fun q =>
                        spacetimeAlternatingSymbol k l p q *
                          inverseCoframe a p * inverseCoframe b q))))) := by
            simp only [Finset.mul_sum]
        _ = Finset.sum Finset.univ (fun k =>
              Finset.sum Finset.univ (fun l =>
                spacetimeAlternatingSymbol i j k l *
                  Finset.sum Finset.univ (fun c =>
                    Finset.sum Finset.univ (fun d =>
                      spacetimeAlternatingSymbol a b c d *
                        coframe k c * coframe l d)))) := by
            apply Finset.sum_congr rfl
            intro k _
            apply Finset.sum_congr rfl
            intro l _
            rw [hInner k l]
            ring
        _ = Finset.sum Finset.univ (fun k =>
              Finset.sum Finset.univ (fun l =>
                Finset.sum Finset.univ (fun c =>
                  Finset.sum Finset.univ (fun d =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                        coframe k c * coframe l d)))) := by
            apply Finset.sum_congr rfl
            intro k _
            apply Finset.sum_congr rfl
            intro l _
            simp only [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro c _
            apply Finset.sum_congr rfl
            intro d _
            ring
        _ = Finset.sum Finset.univ (fun k =>
              Finset.sum Finset.univ (fun c =>
                Finset.sum Finset.univ (fun l =>
                  Finset.sum Finset.univ (fun d =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                        coframe k c * coframe l d)))) := by
            apply Finset.sum_congr rfl
            intro k _
            rw [Finset.sum_comm]
        _ = Finset.sum Finset.univ (fun c =>
              Finset.sum Finset.univ (fun k =>
                Finset.sum Finset.univ (fun l =>
                  Finset.sum Finset.univ (fun d =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                        coframe k c * coframe l d)))) := by
            rw [Finset.sum_comm]
        _ = Finset.sum Finset.univ (fun c =>
              Finset.sum Finset.univ (fun k =>
                Finset.sum Finset.univ (fun d =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                        coframe k c * coframe l d)))) := by
            apply Finset.sum_congr rfl
            intro c _
            apply Finset.sum_congr rfl
            intro k _
            rw [Finset.sum_comm]
        _ = _ := by
            apply Finset.sum_congr rfl
            intro c _
            rw [Finset.sum_comm]

set_option maxHeartbeats 3000000 in
set_option maxRecDepth 10000 in
theorem palatiniDensityFirstVariation_eq_epsilon_experiment
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    palatiniDensityFirstVariation coframe variation curvature =
      -(1 / 4 : Real) * Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun c =>
            Finset.sum Finset.univ (fun d =>
              Finset.sum Finset.univ (fun i =>
                Finset.sum Finset.univ (fun j =>
                  Finset.sum Finset.univ (fun k =>
                    Finset.sum Finset.univ (fun l =>
                      spacetimeAlternatingSymbol a b c d *
                        spacetimeAlternatingSymbol i j k l *
                        (variation k c * coframe l d +
                          coframe k c * variation l d) *
                        bivectorMatrix (curvature a b) i j)))))))) := by
  unfold palatiniDensityFirstVariation
    complementaryPalatiniFaceWeightFirstVariation
    palatiniFaceWeightFirstVariation coframeWedgeFirstVariation
  simp_rw [kreinPair_lorentzBivector_eq_explicit]
  simp +decide [transportApply, lorentzHodgeStar,
    spacetimeAlternatingSymbol, bivectorMatrix, bivectorFirst,
    bivectorSecond, Fin.sum_univ_six, Fin.sum_univ_four]
  ring

theorem det_mul_inverse_bivectorContraction_experiment
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    coframe.det * Finset.sum Finset.univ (fun i =>
      Finset.sum Finset.univ (fun j =>
        inverseCoframe a i * inverseCoframe b j *
          bivectorMatrix curvature i j)) =
      (1 / 2 : Real) * Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun j =>
          coframe.det *
            (inverseCoframe a i * inverseCoframe b j -
              inverseCoframe a j * inverseCoframe b i) *
            bivectorMatrix curvature i j)) := by
  simp +decide [Fin.sum_univ_four, bivectorMatrix]
  ring

theorem det_mul_inverse_bivectorContraction_eq_epsilon_experiment
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (hLeft : inverseCoframe * coframe = 1)
    (a b : Fin 4) :
    coframe.det * Finset.sum Finset.univ (fun i =>
      Finset.sum Finset.univ (fun j =>
        inverseCoframe a i * inverseCoframe b j *
          bivectorMatrix curvature i j)) =
      (1 / 4 : Real) * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun j =>
              Finset.sum Finset.univ (fun k =>
                Finset.sum Finset.univ (fun l =>
                  spacetimeAlternatingSymbol a b c d *
                    spacetimeAlternatingSymbol i j k l *
                    coframe k c * coframe l d *
                    bivectorMatrix curvature i j)))))) := by
  rw [det_mul_inverse_bivectorContraction_experiment]
  calc
    (1 / 2 : Real) * Finset.sum Finset.univ (fun i =>
          Finset.sum Finset.univ (fun j =>
            coframe.det *
              (inverseCoframe a i * inverseCoframe b j -
                inverseCoframe a j * inverseCoframe b i) *
              bivectorMatrix curvature i j)) =
        (1 / 2 : Real) * Finset.sum Finset.univ (fun i =>
          Finset.sum Finset.univ (fun j =>
            ((1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
              Finset.sum Finset.univ (fun d =>
                Finset.sum Finset.univ (fun k =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                      coframe k c * coframe l d)))) *
              bivectorMatrix curvature i j))) := by
          congr 1
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          rw [det_mul_inverse_pair_experiment
            coframe inverseCoframe hLeft a b i j]
    _ = (1 / 4 : Real) * Finset.sum Finset.univ (fun i =>
          Finset.sum Finset.univ (fun j =>
            Finset.sum Finset.univ (fun c =>
              Finset.sum Finset.univ (fun d =>
                Finset.sum Finset.univ (fun k =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                      coframe k c * coframe l d *
                      bivectorMatrix curvature i j)))))) := by
          simp only [Finset.mul_sum, Finset.sum_mul]
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          apply Finset.sum_congr rfl
          intro c _
          apply Finset.sum_congr rfl
          intro d _
          apply Finset.sum_congr rfl
          intro k _
          apply Finset.sum_congr rfl
          intro l _
          ring
    _ = (1 / 4 : Real) * Finset.sum Finset.univ (fun i =>
          Finset.sum Finset.univ (fun c =>
            Finset.sum Finset.univ (fun j =>
              Finset.sum Finset.univ (fun d =>
                Finset.sum Finset.univ (fun k =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                      coframe k c * coframe l d *
                      bivectorMatrix curvature i j)))))) := by
          congr 1
          apply Finset.sum_congr rfl
          intro i _
          rw [Finset.sum_comm]
    _ = (1 / 4 : Real) * Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun j =>
              Finset.sum Finset.univ (fun d =>
                Finset.sum Finset.univ (fun k =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                      coframe k c * coframe l d *
                      bivectorMatrix curvature i j)))))) := by
          congr 1
          rw [Finset.sum_comm]
    _ = (1 / 4 : Real) * Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun d =>
              Finset.sum Finset.univ (fun j =>
                Finset.sum Finset.univ (fun k =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                      coframe k c * coframe l d *
                      bivectorMatrix curvature i j)))))) := by
          congr 1
          apply Finset.sum_congr rfl
          intro c _
          apply Finset.sum_congr rfl
          intro i _
          rw [Finset.sum_comm]
    _ = _ := by
          congr 1
          apply Finset.sum_congr rfl
          intro c _
          rw [Finset.sum_comm]

def spacetimeCoframeMinorExperiment
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b k l : Fin 4) : Real :=
  Finset.sum Finset.univ (fun c =>
    Finset.sum Finset.univ (fun d =>
      spacetimeAlternatingSymbol a b c d *
        coframe k c * coframe l d))

def spacetimeCoframeMinorFirstVariationExperiment
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b k l : Fin 4) : Real :=
  Finset.sum Finset.univ (fun c =>
    Finset.sum Finset.univ (fun d =>
      spacetimeAlternatingSymbol a b c d *
        (variation k c * coframe l d +
          coframe k c * variation l d)))

private theorem responseAlternatingSymbol_swap_first
    (a b c d : Fin 4) :
    spacetimeAlternatingSymbol b a c d =
      -spacetimeAlternatingSymbol a b c d := by
  unfold spacetimeAlternatingSymbol
  ring

theorem spacetimeCoframeMinor_swap_experiment
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b k l : Fin 4) :
    spacetimeCoframeMinorExperiment coframe b a k l =
      -spacetimeCoframeMinorExperiment coframe a b k l := by
  unfold spacetimeCoframeMinorExperiment
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro c _
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro d _
  rw [responseAlternatingSymbol_swap_first a b c d]
  ring

set_option maxHeartbeats 3000000 in
theorem spacetimeCoframeMinorFirstVariation_mul_single_experiment
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b c d k l : Fin 4) :
    spacetimeCoframeMinorFirstVariationExperiment coframe
        (coframe * Matrix.single c d 1) a b k l =
      (if c = d then spacetimeCoframeMinorExperiment coframe a b k l else 0) -
        (if a = c then spacetimeCoframeMinorExperiment coframe d b k l else 0) -
        (if b = c then spacetimeCoframeMinorExperiment coframe a d k l else 0) := by
  fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
    simp +decide [spacetimeCoframeMinorFirstVariationExperiment,
      spacetimeCoframeMinorExperiment, Matrix.mul_apply,
      Matrix.single_apply, spacetimeAlternatingSymbol, Fin.sum_univ_four] <;>
    ring

def coframeBivectorCofactorExperiment
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) : Real :=
  (1 / 4 : Real) * Finset.sum Finset.univ (fun i =>
    Finset.sum Finset.univ (fun j =>
      Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbol i j k l *
            spacetimeCoframeMinorExperiment coframe a b k l *
            bivectorMatrix curvature i j))))

def coframeBivectorCofactorFirstVariationExperiment
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) : Real :=
  (1 / 4 : Real) * Finset.sum Finset.univ (fun i =>
    Finset.sum Finset.univ (fun j =>
      Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbol i j k l *
            spacetimeCoframeMinorFirstVariationExperiment
              coframe variation a b k l *
            bivectorMatrix curvature i j))))

theorem coframeBivectorCofactor_swap_experiment
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    coframeBivectorCofactorExperiment coframe curvature b a =
      -coframeBivectorCofactorExperiment coframe curvature a b := by
  unfold coframeBivectorCofactorExperiment
  simp_rw [spacetimeCoframeMinor_swap_experiment coframe a b]
  simp only [mul_neg, neg_mul, Finset.sum_neg_distrib]

theorem coframeBivectorCofactor_neg_experiment
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    coframeBivectorCofactorExperiment coframe
        (fun component => -curvature component) a b =
      -coframeBivectorCofactorExperiment coframe curvature a b := by
  have hMatrix :
      bivectorMatrix (fun component => -curvature component) =
        -bivectorMatrix curvature := by
    ext i j
    fin_cases i <;> fin_cases j <;> simp [bivectorMatrix]
  unfold coframeBivectorCofactorExperiment
  rw [hMatrix]
  simp only [Matrix.neg_apply, mul_neg, Finset.sum_neg_distrib]

theorem coframeBivectorCofactorFirstVariation_mul_single_experiment
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b c d : Fin 4) :
    coframeBivectorCofactorFirstVariationExperiment coframe
        (coframe * Matrix.single c d 1) curvature a b =
      (if c = d then
        coframeBivectorCofactorExperiment coframe curvature a b else 0) -
        (if a = c then
          coframeBivectorCofactorExperiment coframe curvature d b else 0) -
        (if b = c then
          coframeBivectorCofactorExperiment coframe curvature a d else 0) := by
  unfold coframeBivectorCofactorFirstVariationExperiment
    coframeBivectorCofactorExperiment
  simp_rw [spacetimeCoframeMinorFirstVariation_mul_single_experiment]
  by_cases hcd : c = d
  · subst d
    by_cases hac : a = c <;> by_cases hbc : b = c <;>
      simp_all [Finset.sum_sub_distrib, Finset.mul_sum, Finset.sum_mul] <;> ring
  · have hSwap := spacetimeCoframeMinor_swap_experiment coframe d c
    by_cases hac : a = c <;> by_cases hbc : b = c <;>
      simp_all [Finset.sum_sub_distrib, Finset.mul_sum, Finset.sum_mul, hSwap] <;>
      ring

set_option maxHeartbeats 3000000 in
theorem coframeBivectorCofactorFirstVariation_eq_expanded_experiment
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    coframeBivectorCofactorFirstVariationExperiment
        coframe variation curvature a b =
      (1 / 4 : Real) * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun j =>
              Finset.sum Finset.univ (fun k =>
                Finset.sum Finset.univ (fun l =>
                  spacetimeAlternatingSymbol a b c d *
                    spacetimeAlternatingSymbol i j k l *
                    (variation k c * coframe l d +
                      coframe k c * variation l d) *
                    bivectorMatrix curvature i j)))))) := by
  fin_cases a <;> fin_cases b <;>
    simp +decide [coframeBivectorCofactorFirstVariationExperiment,
      spacetimeCoframeMinorFirstVariationExperiment,
      spacetimeAlternatingSymbol, Fin.sum_univ_four] <;>
    ring

set_option maxHeartbeats 3000000 in
theorem coframeBivectorCofactor_eq_expanded_experiment
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    coframeBivectorCofactorExperiment coframe curvature a b =
      (1 / 4 : Real) * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun j =>
              Finset.sum Finset.univ (fun k =>
                Finset.sum Finset.univ (fun l =>
                  spacetimeAlternatingSymbol a b c d *
                    spacetimeAlternatingSymbol i j k l *
                    coframe k c * coframe l d *
                    bivectorMatrix curvature i j)))))) := by
  fin_cases a <;> fin_cases b <;>
    simp +decide [coframeBivectorCofactorExperiment,
      spacetimeCoframeMinorExperiment,
      spacetimeAlternatingSymbol, Fin.sum_univ_four] <;>
    ring

theorem coframeBivectorCofactor_eq_det_mul_inverseContraction_experiment
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (hLeft : inverseCoframe * coframe = 1)
    (a b : Fin 4) :
    coframeBivectorCofactorExperiment coframe curvature a b =
      coframe.det * Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun j =>
          inverseCoframe a i * inverseCoframe b j *
            bivectorMatrix curvature i j)) := by
  rw [coframeBivectorCofactor_eq_expanded_experiment]
  exact (det_mul_inverse_bivectorContraction_eq_epsilon_experiment
    coframe inverseCoframe curvature hLeft a b).symm

theorem palatiniDensityFirstVariation_eq_neg_sum_cofactorFirstVariation_experiment
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    palatiniDensityFirstVariation coframe variation curvature =
      -Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          coframeBivectorCofactorFirstVariationExperiment
            coframe variation (curvature a b) a b)) := by
  rw [palatiniDensityFirstVariation_eq_epsilon_experiment]
  rw [Finset.mul_sum, ← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro a _
  rw [Finset.mul_sum, ← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro b _
  rw [coframeBivectorCofactorFirstVariation_eq_expanded_experiment]
  ring

set_option maxHeartbeats 3000000 in
set_option maxRecDepth 10000 in
theorem palatiniDensityFirstVariation_mul_single_eq_cofactorEinstein_experiment
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component)
    (c d : Fin 4) :
    palatiniDensityFirstVariation coframe
        (coframe * Matrix.single c d 1) curvature =
      2 * Finset.sum Finset.univ (fun b =>
        coframeBivectorCofactorExperiment coframe
          (curvature c b) d b) -
        (if c = d then
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun b =>
              coframeBivectorCofactorExperiment coframe
                (curvature a b) a b))
         else 0) := by
  rw [palatiniDensityFirstVariation_eq_neg_sum_cofactorFirstVariation_experiment]
  simp_rw [coframeBivectorCofactorFirstVariation_mul_single_experiment]
  have hFace : forall a,
      curvature a c = fun component => -curvature c a component := by
    intro a
    exact hAntisymmetric c a
  have hSecondRicci :
      Finset.sum Finset.univ (fun a =>
          coframeBivectorCofactorExperiment coframe
            (curvature a c) a d) =
        Finset.sum Finset.univ (fun b =>
          coframeBivectorCofactorExperiment coframe
            (curvature c b) d b) := by
    apply Finset.sum_congr rfl
    intro a _
    calc
      coframeBivectorCofactorExperiment coframe
          (curvature a c) a d =
        coframeBivectorCofactorExperiment coframe
          (fun component => -curvature c a component) a d := by
            rw [hFace a]
      _ = -coframeBivectorCofactorExperiment coframe
          (curvature c a) a d := by
            rw [coframeBivectorCofactor_neg_experiment]
      _ = coframeBivectorCofactorExperiment coframe
          (curvature c a) d a := by
            exact (coframeBivectorCofactor_swap_experiment
              coframe (curvature c a) a d).symm
  have hTraceSum :
      Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            if c = d then
              coframeBivectorCofactorExperiment coframe
                (curvature a b) a b
            else 0)) =
        if c = d then
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun b =>
              coframeBivectorCofactorExperiment coframe
                (curvature a b) a b))
        else 0 := by
    by_cases hcd : c = d <;> simp [hcd]
  have hFirstRicciSum :
      Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            if a = c then
              coframeBivectorCofactorExperiment coframe
                (curvature a b) d b
            else 0)) =
        Finset.sum Finset.univ (fun b =>
          coframeBivectorCofactorExperiment coframe
            (curvature c b) d b) := by
    simp
  have hSecondRicciSum :
      Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            if b = c then
              coframeBivectorCofactorExperiment coframe
                (curvature a b) a d
            else 0)) =
        Finset.sum Finset.univ (fun a =>
          coframeBivectorCofactorExperiment coframe
            (curvature a c) a d) := by
    simp
  simp only [Finset.sum_sub_distrib]
  rw [hTraceSum, hFirstRicciSum, hSecondRicciSum, hSecondRicci]
  ring

theorem palatiniDensityFirstVariation_mul_single_eq_det_coefficient_experiment
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hLeft : inverseCoframe * coframe = 1)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component)
    (c d : Fin 4) :
    palatiniDensityFirstVariation coframe
        (coframe * Matrix.single c d 1) curvature =
      coframe.det *
        (2 * Finset.sum Finset.univ (fun i =>
          Finset.sum Finset.univ (fun b =>
            Finset.sum Finset.univ (fun j =>
              inverseCoframe d i * inverseCoframe b j *
                bivectorMatrix (curvature c b) i j))) -
          (if c = d then
            inverseCoframeScalarCurvature inverseCoframe curvature
           else 0)) := by
  rw [palatiniDensityFirstVariation_mul_single_eq_cofactorEinstein_experiment
    coframe curvature hAntisymmetric c d]
  simp_rw [coframeBivectorCofactor_eq_det_mul_inverseContraction_experiment
    coframe inverseCoframe _ hLeft]
  unfold inverseCoframeScalarCurvature
  by_cases hcd : c = d
  · simp only [hcd, if_true]
    simp only [← Finset.mul_sum]
    rw [Finset.sum_comm]
    ring
  · simp only [hcd, if_false]
    simp only [← Finset.mul_sum]
    rw [Finset.sum_comm]
    ring

theorem palatiniDensityFirstVariation_add_experiment
    (coframe left right : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    palatiniDensityFirstVariation coframe (left + right) curvature =
      palatiniDensityFirstVariation coframe left curvature +
        palatiniDensityFirstVariation coframe right curvature := by
  unfold palatiniDensityFirstVariation
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro a _
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro b _
  rw [complementaryPalatiniFaceWeightFirstVariation_add]
  simp_rw [kreinPair_lorentzBivector_eq_explicit]
  simp only [Pi.add_apply]
  ring

theorem palatiniDensityFirstVariation_smul_experiment
    (coframe probe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) (scalar : Real) :
    palatiniDensityFirstVariation coframe (scalar • probe) curvature =
      scalar * palatiniDensityFirstVariation coframe probe curvature := by
  unfold palatiniDensityFirstVariation
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro a _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro b _
  rw [complementaryPalatiniFaceWeightFirstVariation_smul]
  simp_rw [kreinPair_lorentzBivector_eq_explicit]
  simp only [Pi.smul_apply, smul_eq_mul]
  ring

def palatiniDensityGeneratorLinearMapExperiment
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    Matrix (Fin 4) (Fin 4) Real →ₗ[Real] Real where
  toFun := fun generator =>
    palatiniDensityFirstVariation coframe (coframe * generator) curvature
  map_add' := by
    intro left right
    rw [Matrix.mul_add,
      palatiniDensityFirstVariation_add_experiment]
  map_smul' := by
    intro scalar generator
    have hMul : coframe * (scalar • generator) =
        scalar • (coframe * generator) := by
      ext i j
      simp only [Matrix.mul_apply, Matrix.smul_apply, smul_eq_mul]
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro k _
      ring
    rw [hMul, palatiniDensityFirstVariation_smul_experiment]
    rfl

theorem palatiniDensityFirstVariation_mul_eq_coordinateSum_experiment
    (coframe generator : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    palatiniDensityFirstVariation coframe (coframe * generator) curvature =
      Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          palatiniDensityFirstVariation coframe
              (coframe * Matrix.single c d 1) curvature *
            generator c d)) := by
  let responseMap :=
    palatiniDensityGeneratorLinearMapExperiment coframe curvature
  calc
    palatiniDensityFirstVariation coframe (coframe * generator) curvature =
        responseMap generator := rfl
    _ = responseMap (Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            Matrix.single c d (generator c d)))) := by
      rw [← Matrix.matrix_eq_sum_single generator]
    _ = Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            responseMap (Matrix.single c d (generator c d)))) := by
      rw [map_sum]
      apply Finset.sum_congr rfl
      intro c _
      rw [map_sum]
    _ = Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            palatiniDensityFirstVariation coframe
                (coframe * Matrix.single c d 1) curvature *
              generator c d)) := by
      apply Finset.sum_congr rfl
      intro c _
      apply Finset.sum_congr rfl
      intro d _
      have hSingle : Matrix.single c d (generator c d) =
          generator c d • Matrix.single c d (1 : Real) := by
        simp
      rw [hSingle, map_smul]
      change generator c d *
          palatiniDensityFirstVariation coframe
            (coframe * Matrix.single c d 1) curvature = _
      ring

theorem palatiniDensityFirstVariation_mul_core_experiment
    (coframe inverseCoframe generator : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hLeft : inverseCoframe * coframe = 1)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component) :
    palatiniDensityFirstVariation coframe (coframe * generator) curvature =
      coframe.det * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          (2 * Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun b =>
              Finset.sum Finset.univ (fun j =>
                inverseCoframe d i * inverseCoframe b j *
                  bivectorMatrix (curvature c b) i j))) -
            (if c = d then
              inverseCoframeScalarCurvature inverseCoframe curvature
             else 0)) * generator c d)) := by
  rw [palatiniDensityFirstVariation_mul_eq_coordinateSum_experiment]
  simp_rw [palatiniDensityFirstVariation_mul_single_eq_det_coefficient_experiment
    coframe inverseCoframe curvature hLeft hAntisymmetric]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro c _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro d _
  ring

theorem palatiniDensityFirstVariation_eq_det_mul_mixedEinstein_experiment
    (coframe inverseCoframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hLeft : inverseCoframe * coframe = 1)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component) :
    palatiniDensityFirstVariation coframe variation curvature =
      coframe.det * Finset.sum Finset.univ (fun internal =>
        Finset.sum Finset.univ (fun direction =>
          mixedEinsteinCoframeCoefficient inverseCoframe curvature
            internal direction * variation internal direction)) := by
  have hRight : coframe * inverseCoframe = 1 := mul_eq_one_comm.2 hLeft
  have hGenerator :
      palatiniDensityFirstVariation coframe variation curvature =
        palatiniDensityFirstVariation coframe
          (coframe * (inverseCoframe * variation)) curvature := by
    rw [← Matrix.mul_assoc, hRight, Matrix.one_mul]
  rw [hGenerator]
  rw [palatiniDensityFirstVariation_mul_core_experiment
    coframe inverseCoframe (inverseCoframe * variation)
      curvature hLeft hAntisymmetric]
  congr 1
  simp +decide [Matrix.mul_apply, Finset.mul_sum _ _ _,
    Finset.sum_mul, mul_assoc, mul_left_comm,
    Finset.sum_add_distrib, Finset.sum_sub_distrib, sub_mul, mul_sub,
    Finset.sum_ite, Finset.filter_eq, Finset.filter_ne]
  unfold mixedEinsteinCoframeCoefficient inverseCoframeScalarCurvature
  simp +decide [Finset.mul_sum _ _ _, Finset.sum_mul,
    mul_assoc, mul_left_comm, mul_sub, sub_mul,
    Finset.sum_add_distrib, Finset.sum_sub_distrib,
    Finset.sum_ite, Finset.filter_eq, Finset.filter_ne]
  refine congrArg₂ _ ?_ ?_
  · simp +decide only [← Finset.sum_product']
    apply Finset.sum_bij
      (fun x _ =>
        (x.2.2.1, x.2.1, x.1, x.2.2.2.1,
          x.2.2.2.2.1, x.2.2.2.2.2))
    · simp +contextual
    · grind
    · simp +zetaDelta at *
    · grind
  · simp +decide only [← Finset.sum_product']
    apply Finset.sum_bij
      (fun x _ =>
        (x.2.1, x.1, x.2.2.1, x.2.2.2.1,
          x.2.2.2.2.1, x.2.2.2.2.2))
    · simp +zetaDelta at *
    · grind
    · simp +zetaDelta at *
    · simp +decide [mul_assoc, mul_comm, mul_left_comm]

set_option maxHeartbeats 1000000 in
set_option maxRecDepth 10000 in
theorem palatiniDensityFirstVariation_one_experiment
    (variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component) :
    palatiniDensityFirstVariation 1 variation curvature =
      Finset.sum Finset.univ (fun internal =>
        Finset.sum Finset.univ (fun direction =>
          mixedEinsteinCoframeCoefficient 1 curvature
            internal direction * variation internal direction)) := by
  have h00 : forall component, curvature 0 0 component = 0 := by
    intro component
    have h := congrFun (hAntisymmetric 0 0) component
    linarith
  have h11 : forall component, curvature 1 1 component = 0 := by
    intro component
    have h := congrFun (hAntisymmetric 1 1) component
    linarith
  have h22 : forall component, curvature 2 2 component = 0 := by
    intro component
    have h := congrFun (hAntisymmetric 2 2) component
    linarith
  have h33 : forall component, curvature 3 3 component = 0 := by
    intro component
    have h := congrFun (hAntisymmetric 3 3) component
    linarith
  have h10 : forall component,
      curvature 1 0 component = -curvature 0 1 component := by
    exact fun component => congrFun (hAntisymmetric 0 1) component
  have h20 : forall component,
      curvature 2 0 component = -curvature 0 2 component := by
    exact fun component => congrFun (hAntisymmetric 0 2) component
  have h30 : forall component,
      curvature 3 0 component = -curvature 0 3 component := by
    exact fun component => congrFun (hAntisymmetric 0 3) component
  have h21 : forall component,
      curvature 2 1 component = -curvature 1 2 component := by
    exact fun component => congrFun (hAntisymmetric 1 2) component
  have h31 : forall component,
      curvature 3 1 component = -curvature 1 3 component := by
    exact fun component => congrFun (hAntisymmetric 1 3) component
  have h32 : forall component,
      curvature 3 2 component = -curvature 2 3 component := by
    exact fun component => congrFun (hAntisymmetric 2 3) component
  unfold palatiniDensityFirstVariation mixedEinsteinCoframeCoefficient
    inverseCoframeScalarCurvature
  simp +decide [complementaryPalatiniFaceWeightFirstVariation,
    palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
    spacetimeAlternatingSymbol, transportApply, lorentzHodgeStar,
    kreinPair_lorentzBivector_eq_explicit, bivectorMatrix,
    bivectorFirst, bivectorSecond, Matrix.mul_apply, Matrix.one_apply,
    Fin.sum_univ_six, Fin.sum_univ_four,
    h00, h11, h22, h33, h10, h20, h30, h21, h31, h32]
  ring

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
