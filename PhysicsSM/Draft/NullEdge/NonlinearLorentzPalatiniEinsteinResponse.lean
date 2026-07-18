import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge

noncomputable section

/-!
# Exact coframe response of the nonlinear Lorentz Palatini density

This module closes the local algebraic response gate left by
`NonlinearLorentzPalatiniEinsteinBridge`.  For an invertible coframe and a
curvature face antisymmetric in its two spacetime directions, it proves that
the ordinary coframe first response is the oriented determinant times the
coframe-index mixed Einstein coefficient paired with the arbitrary coframe
variation.

The proof factors through the exterior-square action of elementary coframe
column operations.  The determinant trace gives the scalar-curvature term;
the two cofactor insertions agree by face antisymmetry and give twice the mixed
Ricci term.  These are exact finite identities.  They do not identify the
extracted plaquette field with continuum Riemann curvature, derive
Levi-Civita selection, or supply dual-cell volume weights.  Claim label:
finite identity.  The tetradic response formula is standard `[import]`; its
normalization in the project bivector/Hodge/Krein convention is `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge

open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler

set_option maxHeartbeats 3000000

namespace ResponseProof

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

theorem det_mul_inverse_pair
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
theorem palatiniDensityFirstVariation_eq_epsilon
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

theorem det_mul_inverse_bivectorContraction
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

theorem det_mul_inverse_bivectorContraction_eq_epsilon
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
  rw [det_mul_inverse_bivectorContraction]
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
          rw [det_mul_inverse_pair
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

def responseSpacetimeCoframeMinor
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b k l : Fin 4) : Real :=
  Finset.sum Finset.univ (fun c =>
    Finset.sum Finset.univ (fun d =>
      spacetimeAlternatingSymbol a b c d *
        coframe k c * coframe l d))

def responseSpacetimeCoframeMinorFirstVariation
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

theorem spacetimeCoframeMinor_swap
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b k l : Fin 4) :
    responseSpacetimeCoframeMinor coframe b a k l =
      -responseSpacetimeCoframeMinor coframe a b k l := by
  unfold responseSpacetimeCoframeMinor
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro c _
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro d _
  rw [responseAlternatingSymbol_swap_first a b c d]
  ring

set_option maxHeartbeats 3000000 in
theorem spacetimeCoframeMinorFirstVariation_mul_single
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b c d k l : Fin 4) :
    responseSpacetimeCoframeMinorFirstVariation coframe
        (coframe * Matrix.single c d 1) a b k l =
      (if c = d then responseSpacetimeCoframeMinor coframe a b k l else 0) -
        (if a = c then responseSpacetimeCoframeMinor coframe d b k l else 0) -
        (if b = c then responseSpacetimeCoframeMinor coframe a d k l else 0) := by
  fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
    simp +decide [responseSpacetimeCoframeMinorFirstVariation,
      responseSpacetimeCoframeMinor, Matrix.mul_apply,
      Matrix.single_apply, spacetimeAlternatingSymbol, Fin.sum_univ_four] <;>
    ring

def responseCoframeBivectorCofactor
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) : Real :=
  (1 / 4 : Real) * Finset.sum Finset.univ (fun i =>
    Finset.sum Finset.univ (fun j =>
      Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbol i j k l *
            responseSpacetimeCoframeMinor coframe a b k l *
            bivectorMatrix curvature i j))))

def responseCoframeBivectorCofactorFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) : Real :=
  (1 / 4 : Real) * Finset.sum Finset.univ (fun i =>
    Finset.sum Finset.univ (fun j =>
      Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbol i j k l *
            responseSpacetimeCoframeMinorFirstVariation
              coframe variation a b k l *
            bivectorMatrix curvature i j))))

theorem coframeBivectorCofactor_swap
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    responseCoframeBivectorCofactor coframe curvature b a =
      -responseCoframeBivectorCofactor coframe curvature a b := by
  unfold responseCoframeBivectorCofactor
  simp_rw [spacetimeCoframeMinor_swap coframe a b]
  simp only [mul_neg, neg_mul, Finset.sum_neg_distrib]

theorem coframeBivectorCofactor_neg
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    responseCoframeBivectorCofactor coframe
        (fun component => -curvature component) a b =
      -responseCoframeBivectorCofactor coframe curvature a b := by
  have hMatrix :
      bivectorMatrix (fun component => -curvature component) =
        -bivectorMatrix curvature := by
    ext i j
    fin_cases i <;> fin_cases j <;> simp [bivectorMatrix]
  unfold responseCoframeBivectorCofactor
  rw [hMatrix]
  simp only [Matrix.neg_apply, mul_neg, Finset.sum_neg_distrib]

theorem coframeBivectorCofactorFirstVariation_mul_single
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b c d : Fin 4) :
    responseCoframeBivectorCofactorFirstVariation coframe
        (coframe * Matrix.single c d 1) curvature a b =
      (if c = d then
        responseCoframeBivectorCofactor coframe curvature a b else 0) -
        (if a = c then
          responseCoframeBivectorCofactor coframe curvature d b else 0) -
        (if b = c then
          responseCoframeBivectorCofactor coframe curvature a d else 0) := by
  unfold responseCoframeBivectorCofactorFirstVariation
    responseCoframeBivectorCofactor
  simp_rw [spacetimeCoframeMinorFirstVariation_mul_single]
  by_cases hcd : c = d
  · subst d
    by_cases hac : a = c <;> by_cases hbc : b = c <;>
      simp_all [Finset.sum_sub_distrib, Finset.mul_sum, Finset.sum_mul] <;> ring
  · have hSwap := spacetimeCoframeMinor_swap coframe d c
    by_cases hac : a = c <;> by_cases hbc : b = c <;>
      simp_all [Finset.sum_sub_distrib, Finset.mul_sum, Finset.sum_mul, hSwap] <;>
      ring

set_option maxHeartbeats 3000000 in
theorem coframeBivectorCofactorFirstVariation_eq_expanded
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    responseCoframeBivectorCofactorFirstVariation
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
    simp +decide [responseCoframeBivectorCofactorFirstVariation,
      responseSpacetimeCoframeMinorFirstVariation,
      spacetimeAlternatingSymbol, Fin.sum_univ_four] <;>
    ring

set_option maxHeartbeats 3000000 in
theorem coframeBivectorCofactor_eq_expanded
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    responseCoframeBivectorCofactor coframe curvature a b =
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
    simp +decide [responseCoframeBivectorCofactor,
      responseSpacetimeCoframeMinor,
      spacetimeAlternatingSymbol, Fin.sum_univ_four] <;>
    ring

theorem coframeBivectorCofactor_eq_det_mul_inverseContraction
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (hLeft : inverseCoframe * coframe = 1)
    (a b : Fin 4) :
    responseCoframeBivectorCofactor coframe curvature a b =
      coframe.det * Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun j =>
          inverseCoframe a i * inverseCoframe b j *
            bivectorMatrix curvature i j)) := by
  rw [coframeBivectorCofactor_eq_expanded]
  exact (det_mul_inverse_bivectorContraction_eq_epsilon
    coframe inverseCoframe curvature hLeft a b).symm

theorem palatiniDensityFirstVariation_eq_neg_sum_cofactorFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    palatiniDensityFirstVariation coframe variation curvature =
      -Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          responseCoframeBivectorCofactorFirstVariation
            coframe variation (curvature a b) a b)) := by
  rw [palatiniDensityFirstVariation_eq_epsilon]
  rw [Finset.mul_sum, ← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro a _
  rw [Finset.mul_sum, ← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro b _
  rw [coframeBivectorCofactorFirstVariation_eq_expanded]
  ring

set_option maxHeartbeats 3000000 in
set_option maxRecDepth 10000 in
theorem palatiniDensityFirstVariation_mul_single_eq_cofactorEinstein
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component)
    (c d : Fin 4) :
    palatiniDensityFirstVariation coframe
        (coframe * Matrix.single c d 1) curvature =
      2 * Finset.sum Finset.univ (fun b =>
        responseCoframeBivectorCofactor coframe
          (curvature c b) d b) -
        (if c = d then
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun b =>
              responseCoframeBivectorCofactor coframe
                (curvature a b) a b))
         else 0) := by
  rw [palatiniDensityFirstVariation_eq_neg_sum_cofactorFirstVariation]
  simp_rw [coframeBivectorCofactorFirstVariation_mul_single]
  have hFace : forall a,
      curvature a c = fun component => -curvature c a component := by
    intro a
    exact hAntisymmetric c a
  have hSecondRicci :
      Finset.sum Finset.univ (fun a =>
          responseCoframeBivectorCofactor coframe
            (curvature a c) a d) =
        Finset.sum Finset.univ (fun b =>
          responseCoframeBivectorCofactor coframe
            (curvature c b) d b) := by
    apply Finset.sum_congr rfl
    intro a _
    calc
      responseCoframeBivectorCofactor coframe
          (curvature a c) a d =
        responseCoframeBivectorCofactor coframe
          (fun component => -curvature c a component) a d := by
            rw [hFace a]
      _ = -responseCoframeBivectorCofactor coframe
          (curvature c a) a d := by
            rw [coframeBivectorCofactor_neg]
      _ = responseCoframeBivectorCofactor coframe
          (curvature c a) d a := by
            exact (coframeBivectorCofactor_swap
              coframe (curvature c a) a d).symm
  have hTraceSum :
      Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            if c = d then
              responseCoframeBivectorCofactor coframe
                (curvature a b) a b
            else 0)) =
        if c = d then
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun b =>
              responseCoframeBivectorCofactor coframe
                (curvature a b) a b))
        else 0 := by
    by_cases hcd : c = d <;> simp [hcd]
  have hFirstRicciSum :
      Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            if a = c then
              responseCoframeBivectorCofactor coframe
                (curvature a b) d b
            else 0)) =
        Finset.sum Finset.univ (fun b =>
          responseCoframeBivectorCofactor coframe
            (curvature c b) d b) := by
    simp
  have hSecondRicciSum :
      Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            if b = c then
              responseCoframeBivectorCofactor coframe
                (curvature a b) a d
            else 0)) =
        Finset.sum Finset.univ (fun a =>
          responseCoframeBivectorCofactor coframe
            (curvature a c) a d) := by
    simp
  simp only [Finset.sum_sub_distrib]
  rw [hTraceSum, hFirstRicciSum, hSecondRicciSum, hSecondRicci]
  ring

theorem palatiniDensityFirstVariation_mul_single_eq_det_coefficient
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
  rw [palatiniDensityFirstVariation_mul_single_eq_cofactorEinstein
    coframe curvature hAntisymmetric c d]
  simp_rw [coframeBivectorCofactor_eq_det_mul_inverseContraction
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

theorem palatiniDensityFirstVariation_add
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

theorem palatiniDensityFirstVariation_smul
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

def responsePalatiniDensityGeneratorLinearMap
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    Matrix (Fin 4) (Fin 4) Real →ₗ[Real] Real where
  toFun := fun generator =>
    palatiniDensityFirstVariation coframe (coframe * generator) curvature
  map_add' := by
    intro left right
    rw [Matrix.mul_add,
      palatiniDensityFirstVariation_add]
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
    rw [hMul, palatiniDensityFirstVariation_smul]
    rfl

theorem palatiniDensityFirstVariation_mul_eq_coordinateSum
    (coframe generator : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    palatiniDensityFirstVariation coframe (coframe * generator) curvature =
      Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          palatiniDensityFirstVariation coframe
              (coframe * Matrix.single c d 1) curvature *
            generator c d)) := by
  let responseMap :=
    responsePalatiniDensityGeneratorLinearMap coframe curvature
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

theorem palatiniDensityFirstVariation_mul_core
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
  rw [palatiniDensityFirstVariation_mul_eq_coordinateSum]
  simp_rw [palatiniDensityFirstVariation_mul_single_eq_det_coefficient
    coframe inverseCoframe curvature hLeft hAntisymmetric]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro c _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro d _
  ring

theorem palatiniDensityFirstVariation_eq_det_mul_mixedEinstein_of_function_antisymmetric
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
  rw [palatiniDensityFirstVariation_mul_core
    coframe inverseCoframe (inverseCoframe * variation)
      curvature hLeft hAntisymmetric]
  congr 1
  simp +decide [Matrix.mul_apply, Finset.mul_sum _ _ _,
    Finset.sum_mul, mul_assoc, mul_left_comm,
    Finset.sum_sub_distrib, sub_mul, mul_sub]
  unfold mixedEinsteinCoframeCoefficient inverseCoframeScalarCurvature
  simp +decide [Finset.mul_sum _ _ _, Finset.sum_mul,
    mul_assoc, mul_left_comm, sub_mul, Finset.sum_sub_distrib]
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
    · simp +decide [mul_comm]

end ResponseProof

/-- The exact first response of the ordered Palatini density is the oriented
coframe determinant times the coframe-index mixed Einstein coefficient paired
with the arbitrary coframe variation.  Face antisymmetry is the only curvature
symmetry used by this local algebraic identity. -/
theorem palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (coframe inverseCoframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hLeft : inverseCoframe * coframe = 1)
    (hAntisymmetric : forall a b component,
      curvature a b component = -curvature b a component) :
    palatiniDensityFirstVariation coframe variation curvature =
      coframe.det * Finset.sum Finset.univ (fun internal =>
        Finset.sum Finset.univ (fun direction =>
          mixedEinsteinCoframeCoefficient inverseCoframe curvature
            internal direction * variation internal direction)) := by
  apply ResponseProof.palatiniDensityFirstVariation_eq_det_mul_mixedEinstein_of_function_antisymmetric
    coframe inverseCoframe variation curvature hLeft
  intro a b
  funext component
  exact hAntisymmetric b a component

/-- Each of the sixteen local tetrad Euler coefficients of the concrete
nonlinear plaquette action is the oriented coframe determinant times the
corresponding mixed Einstein coframe coefficient of the extracted curvature. -/
theorem nonlinearCoframeEulerCoefficient_eq_det_mul_mixedEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1)
    (site : Site) (internal direction : Fin 4) :
    nonlinearCoframeEulerCoefficient shift connection coframe site
        internal direction =
      (coframe site).det *
        mixedEinsteinCoframeCoefficient (inverseCoframe site)
          (extractedPlaquetteCurvature shift connection site)
          internal direction := by
  change nonlinearCoframeLocalEulerFunctional
      shift connection coframe site (Matrix.single internal direction 1) = _
  rw [nonlinearCoframeLocalEulerFunctional_eq_palatiniDensityFirstVariation]
  rw [palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (hLeft := hLeft site)]
  · congr 1
    fin_cases internal <;> fin_cases direction <;>
      simp +decide [Fin.sum_univ_four, Matrix.single_apply]
  · exact extractedPlaquetteCurvature_isAntisymmetric
      shift connection site

/-- At one site, vanishing of all sixteen tetrad Euler coefficients is
equivalent to the determinant-free mixed vacuum Einstein equations for the
extracted curvature. -/
theorem nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1)
    (site : Site) :
    (forall internal direction,
      nonlinearCoframeEulerCoefficient shift connection coframe site
        internal direction = 0) ↔
    (forall coframeDirection raisedDirection,
      2 * mixedRicciCurvature (inverseCoframe site)
          (extractedPlaquetteCurvature shift connection site)
          coframeDirection raisedDirection -
        (1 : Matrix (Fin 4) (Fin 4) Real)
            raisedDirection coframeDirection *
          inverseCoframeScalarCurvature (inverseCoframe site)
            (extractedPlaquetteCurvature shift connection site) = 0) := by
  have hRight : coframe site * inverseCoframe site = 1 :=
    mul_eq_one_comm.2 (hLeft site)
  have hDet : (coframe site).det ≠ 0 :=
    Matrix.det_ne_zero_of_left_inverse (hLeft site)
  calc
    (forall internal direction,
        nonlinearCoframeEulerCoefficient shift connection coframe site
          internal direction = 0) ↔
        (forall internal direction,
          mixedEinsteinCoframeCoefficient (inverseCoframe site)
            (extractedPlaquetteCurvature shift connection site)
            internal direction = 0) := by
          constructor
          · intro hEuler internal direction
            have h := hEuler internal direction
            rw [nonlinearCoframeEulerCoefficient_eq_det_mul_mixedEinstein
              shift connection coframe inverseCoframe hLeft] at h
            exact (mul_eq_zero.mp h).resolve_left hDet
          · intro hEinstein internal direction
            rw [nonlinearCoframeEulerCoefficient_eq_det_mul_mixedEinstein
              shift connection coframe inverseCoframe hLeft,
              hEinstein internal direction, mul_zero]
    _ ↔ _ := mixedEinsteinCoframeCoefficient_vanish_iff
      (coframe site) (inverseCoframe site)
      (extractedPlaquetteCurvature shift connection site)
      (hLeft site) hRight

/-- Formal coframe stationarity of the concrete nonlinear plaquette action is
exactly the pointwise finite mixed vacuum Einstein system. -/
theorem nonlinearCoframePlaquetteCoframeStationary_iff_mixedEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1) :
    NonlinearCoframePlaquetteCoframeStationary shift connection coframe ↔
      forall site coframeDirection raisedDirection,
        2 * mixedRicciCurvature (inverseCoframe site)
            (extractedPlaquetteCurvature shift connection site)
            coframeDirection raisedDirection -
          (1 : Matrix (Fin 4) (Fin 4) Real)
              raisedDirection coframeDirection *
            inverseCoframeScalarCurvature (inverseCoframe site)
              (extractedPlaquetteCurvature shift connection site) = 0 := by
  rw [nonlinearCoframePlaquetteCoframeStationary_iff_coefficients]
  constructor
  · intro hEuler site
    exact (nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein
      shift connection coframe inverseCoframe hLeft site).mp (hEuler site)
  · intro hEinstein site
    exact (nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein
      shift connection coframe inverseCoframe hLeft site).mpr
        (hEinstein site)

/-- Joint stationarity is exactly the six-component link Euler system together
with the pointwise finite mixed vacuum Einstein equations.  This theorem does
not identify the link equation with Levi-Civita selection. -/
theorem nonlinearCoframePlaquetteJointStationary_iff_linkEuler_and_mixedEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1) :
    NonlinearCoframePlaquetteJointStationary shift connection coframe ↔
      (forall site direction component,
        nonlinearLinkEulerCoefficient shift connection coframe site direction
          component = 0) ∧
      (forall site coframeDirection raisedDirection,
        2 * mixedRicciCurvature (inverseCoframe site)
            (extractedPlaquetteCurvature shift connection site)
            coframeDirection raisedDirection -
          (1 : Matrix (Fin 4) (Fin 4) Real)
              raisedDirection coframeDirection *
            inverseCoframeScalarCurvature (inverseCoframe site)
              (extractedPlaquetteCurvature shift connection site) = 0) := by
  rw [nonlinearCoframePlaquetteJointStationary_iff_coefficients]
  exact and_congr Iff.rfl
    (by
      constructor
      · intro hEuler site
        exact (nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein
          shift connection coframe inverseCoframe hLeft site).mp (hEuler site)
      · intro hEinstein site
        exact (nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein
          shift connection coframe inverseCoframe hLeft site).mpr
            (hEinstein site))

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.palatiniDensityFirstVariation_eq_det_mul_mixedEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms palatiniDensityFirstVariation_eq_det_mul_mixedEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.nonlinearCoframePlaquetteJointStationary_iff_linkEuler_and_mixedEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteJointStationary_iff_linkEuler_and_mixedEinstein

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
