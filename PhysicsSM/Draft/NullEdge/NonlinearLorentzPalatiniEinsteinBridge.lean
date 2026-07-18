import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction

noncomputable section

/-!
# Einstein normalization bridge for the nonlinear Lorentz Palatini action

This module fixes the local density and scalar-curvature contractions used to
connect the exact nonlinear holonomy action to the finite Einstein endpoint.
It proves the normalization-sensitive arbitrary-coframe determinant identity
and the following exact consequences in the live algebra:

1. the extracted-curvature action is the sum of site-local Palatini densities;
2. every local density is `-det(e)` times its inverse-coframe scalar
   contraction, without requiring face antisymmetry;
3. the concrete nonlinear action is therefore the corresponding
   determinant-weighted scalar-curvature sum;
4. its ordinary coframe response is the sum of the corresponding site-local
   density responses against that same extracted curvature;
5. contracting the displayed coframe-index Einstein coefficient with the
   coframe gives exactly `2 Ric^d_c - delta^d_c R`;
6. at the identity coframe, the actual project Hodge matrix, Krein signs, and
   ordered bivector convention give exactly
   `PalatiniDensity(1,F) = -ScalarCurvature(1,F)`.

The determinant statement holds for every ordered curvature field; no face
antisymmetry is needed for this normalization anchor.  The successor module
`NonlinearLorentzPalatiniEinsteinResponse` proves the full coframe
first-variation Einstein identity.

## Scope and provenance

These are exact finite identities.  The scalar contraction is defined from
the inverse coframe and the antisymmetric internal matrix represented by the
six curvature coordinates.  The module does not yet prove the full
coframe first-variation Einstein identity internally; its named successor
does.  The combined finite route still does not identify the extracted field
with continuum Riemann curvature or derive Levi-Civita selection.  The tetradic contraction is
standard `[import]`; its project-basis normalization and exact-holonomy
composition are `[orig/comp]`.  Claim label: finite identity.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction

/-- Explicit six-coordinate form of the project Lorentz-bivector Krein
pairing. -/
theorem kreinPair_lorentzBivector_eq_explicit
    (left right : Fiber 6) :
    kreinPair lorentzBivectorFundamentalSymmetry left right =
      left 0 * right 0 + left 1 * right 1 + left 2 * right 2 -
        left 3 * right 3 - left 4 * right 4 - left 5 * right 5 := by
  unfold kreinPair fiberPair transportApply
  rw [lorentzBivectorFundamentalSymmetry_matrix]
  simp [splitSixMatrix, splitSixSign, Matrix.diagonal_apply,
    Fin.sum_univ_six]
  ring

private theorem alternatingCoframeWedge_twoProduct
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b i j : Fin 4) :
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbol c d a b *
          (coframe i c * coframe j d - coframe i d * coframe j c))) =
      Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          spacetimeAlternatingSymbol c d a b *
            coframe i c * coframe j d)) := by
  fin_cases a <;> fin_cases b <;>
    simp [spacetimeAlternatingSymbol, Fin.sum_univ_four] <;> ring

private def palatiniSelectedRowIndex (i j p q : Fin 4) : Fin 4 -> Fin 4
  | 0 => i
  | 1 => j
  | 2 => p
  | 3 => q

private def palatiniRowSelector
    (i j p q : Fin 4) : Matrix (Fin 4) (Fin 4) Real :=
  fun r s => if palatiniSelectedRowIndex i j p q r = s then 1 else 0

private theorem palatiniRowSelector_mul_apply
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (i j p q r c : Fin 4) :
    (palatiniRowSelector i j p q * coframe) r c =
      coframe (palatiniSelectedRowIndex i j p q r) c := by
  simp [palatiniRowSelector, Matrix.mul_apply]

private theorem palatiniDetFinFour
    (matrix : Matrix (Fin 4) (Fin 4) Real) :
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

private theorem palatiniRowSelector_det (i j p q : Fin 4) :
    (palatiniRowSelector i j p q).det =
      spacetimeAlternatingSymbol i j p q := by
  by_cases hij : i = j
  · subst j
    rw [Matrix.det_zero_of_row_eq (by decide : (0 : Fin 4) ≠ 1) (by
      funext s
      simp [palatiniRowSelector, palatiniSelectedRowIndex])]
    simp [spacetimeAlternatingSymbol]
  by_cases hip : i = p
  · subst p
    rw [Matrix.det_zero_of_row_eq (by decide : (0 : Fin 4) ≠ 2) (by
      funext s
      simp [palatiniRowSelector, palatiniSelectedRowIndex])]
    simp [spacetimeAlternatingSymbol]
  by_cases hiq : i = q
  · subst q
    rw [Matrix.det_zero_of_row_eq (by decide : (0 : Fin 4) ≠ 3) (by
      funext s
      simp [palatiniRowSelector, palatiniSelectedRowIndex])]
    simp [spacetimeAlternatingSymbol]
  by_cases hjp : j = p
  · subst p
    rw [Matrix.det_zero_of_row_eq (by decide : (1 : Fin 4) ≠ 2) (by
      funext s
      simp [palatiniRowSelector, palatiniSelectedRowIndex])]
    simp [spacetimeAlternatingSymbol]
  by_cases hjq : j = q
  · subst q
    rw [Matrix.det_zero_of_row_eq (by decide : (1 : Fin 4) ≠ 3) (by
      funext s
      simp [palatiniRowSelector, palatiniSelectedRowIndex])]
    simp [spacetimeAlternatingSymbol]
  by_cases hpq : p = q
  · subst q
    rw [Matrix.det_zero_of_row_eq (by decide : (2 : Fin 4) ≠ 3) (by
      funext s
      simp [palatiniRowSelector, palatiniSelectedRowIndex])]
    simp [spacetimeAlternatingSymbol]
  fin_cases i <;> fin_cases j <;> fin_cases p <;> fin_cases q
  all_goals simp_all
  all_goals
    simp [palatiniRowSelector, palatiniSelectedRowIndex,
      spacetimeAlternatingSymbol, palatiniDetFinFour]
  all_goals norm_num

private theorem alternatingCoframe_fourProduct
    (coframe : Matrix (Fin 4) (Fin 4) Real) (i j p q : Fin 4) :
    Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            spacetimeAlternatingSymbol c d a b *
              coframe i c * coframe j d * coframe p a * coframe q b)))) =
      coframe.det * spacetimeAlternatingSymbol i j p q := by
  calc
    _ = (palatiniRowSelector i j p q * coframe).det := by
      rw [palatiniDetFinFour]
      simp only [palatiniRowSelector_mul_apply, palatiniSelectedRowIndex]
      simp [spacetimeAlternatingSymbol, Fin.sum_univ_four]
      ring
    _ = (palatiniRowSelector i j p q).det * coframe.det :=
      Matrix.det_mul _ _
    _ = coframe.det * spacetimeAlternatingSymbol i j p q := by
      rw [palatiniRowSelector_det]
      ring

private def palatiniAlternatingMatrix
    (i j : Fin 4) : Matrix (Fin 4) (Fin 4) Real :=
  fun k l => spacetimeAlternatingSymbol i j k l

private def palatiniCoframeMinorMatrix
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (i j : Fin 4) : Matrix (Fin 4) (Fin 4) Real :=
  fun a b => Finset.sum Finset.univ (fun c =>
    Finset.sum Finset.univ (fun d =>
      spacetimeAlternatingSymbol c d a b * coframe i c * coframe j d))

private def palatiniInverseMinorMatrix
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (i j : Fin 4) : Matrix (Fin 4) (Fin 4) Real :=
  inverseCoframe * palatiniAlternatingMatrix i j * inverseCoframe.transpose

private theorem palatiniInverseMinorMatrix_apply
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (i j a b : Fin 4) :
    palatiniInverseMinorMatrix inverseCoframe i j a b =
      Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbol i j k l *
            inverseCoframe a k * inverseCoframe b l)) := by
  simp [palatiniInverseMinorMatrix, palatiniAlternatingMatrix,
    Matrix.mul_apply, Fin.sum_univ_four]
  ring

private theorem palatiniCoframeMinorMatrix_contraction
    (coframe : Matrix (Fin 4) (Fin 4) Real) (i j : Fin 4) :
    coframe * palatiniCoframeMinorMatrix coframe i j * coframe.transpose =
      coframe.det • palatiniAlternatingMatrix i j := by
  ext p q
  rw [show (coframe * palatiniCoframeMinorMatrix coframe i j *
        coframe.transpose) p q =
      Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          coframe p a * palatiniCoframeMinorMatrix coframe i j a b *
            coframe q b)) by
      simp [Matrix.mul_apply, Fin.sum_univ_four]
      ring]
  rw [show Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          coframe p a * palatiniCoframeMinorMatrix coframe i j a b *
            coframe q b)) =
      Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun b =>
              spacetimeAlternatingSymbol c d a b *
                coframe i c * coframe j d * coframe p a * coframe q b)))) by
      simp [palatiniCoframeMinorMatrix, Fin.sum_univ_four]
      ring]
  rw [alternatingCoframe_fourProduct]
  rfl

private theorem palatiniInverseMinorMatrix_contraction
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hRight : coframe * inverseCoframe = 1) (i j : Fin 4) :
    coframe * palatiniInverseMinorMatrix inverseCoframe i j *
        coframe.transpose =
      palatiniAlternatingMatrix i j := by
  unfold palatiniInverseMinorMatrix
  calc
    coframe * (inverseCoframe * palatiniAlternatingMatrix i j *
        inverseCoframe.transpose) * coframe.transpose =
      (coframe * inverseCoframe) * palatiniAlternatingMatrix i j *
        (inverseCoframe.transpose * coframe.transpose) := by
          simp only [Matrix.mul_assoc]
    _ = palatiniAlternatingMatrix i j := by
      rw [← Matrix.transpose_mul, hRight]
      simp

/-- Four-dimensional two-column cofactor identity for a coframe and a
supplied two-sided inverse. -/
theorem alternating_coframe_two_minor
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (a b i j : Fin 4) :
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbol c d a b *
          (coframe i c * coframe j d - coframe i d * coframe j c))) =
      coframe.det * Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbol i j k l *
            inverseCoframe a k * inverseCoframe b l)) := by
  have hRight : coframe * inverseCoframe = 1 := mul_eq_one_comm.2 hLeft
  rw [alternatingCoframeWedge_twoProduct]
  rw [← palatiniInverseMinorMatrix_apply]
  change palatiniCoframeMinorMatrix coframe i j a b =
    (coframe.det • palatiniInverseMinorMatrix inverseCoframe i j) a b
  have hMatrix : palatiniCoframeMinorMatrix coframe i j =
      coframe.det • palatiniInverseMinorMatrix inverseCoframe i j := by
    refine Matrix.mul_right_injective_of_inv
      inverseCoframe coframe hLeft ?_
    have hTranspose :
        coframe.transpose * inverseCoframe.transpose = 1 := by
      rw [← Matrix.transpose_mul, hLeft]
      simp
    refine Matrix.mul_left_injective_of_inv
      coframe.transpose inverseCoframe.transpose hTranspose ?_
    change coframe * palatiniCoframeMinorMatrix coframe i j *
        coframe.transpose =
      coframe * (coframe.det •
        palatiniInverseMinorMatrix inverseCoframe i j) * coframe.transpose
    rw [palatiniCoframeMinorMatrix_contraction]
    rw [Matrix.mul_smul, Matrix.smul_mul]
    rw [palatiniInverseMinorMatrix_contraction
      coframe inverseCoframe hRight]
  exact congrFun (congrFun hMatrix a) b

/-- Site-local ordered complementary-face Palatini density. -/
def palatiniDensity
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      kreinPair lorentzBivectorFundamentalSymmetry
        (complementaryPalatiniFaceWeight coframe a b) (curvature a b)))

/-- Polarized first coframe response of the site-local ordered Palatini
density. -/
def palatiniDensityFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      kreinPair lorentzBivectorFundamentalSymmetry
        (complementaryPalatiniFaceWeightFirstVariation
          coframe variation a b)
        (curvature a b)))

/-- Scalar curvature obtained by contracting an internal curvature face with
two inverse coframes. -/
def inverseCoframeScalarCurvature
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun j =>
          inverseCoframe a i * inverseCoframe b j *
            bivectorMatrix (curvature a b) i j))))

/-- The complementary tetradic Palatini density is exactly minus the
oriented coframe determinant times the inverse-coframe scalar curvature. -/
theorem palatiniDensity_eq_neg_det_mul_inverseCoframeScalarCurvature
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hLeft : inverseCoframe * coframe = 1) :
    palatiniDensity coframe curvature =
      -coframe.det *
        inverseCoframeScalarCurvature inverseCoframe curvature := by
  unfold palatiniDensity complementaryPalatiniFaceWeight
    palatiniFaceWeight inverseCoframeScalarCurvature
  simp_rw [kreinPair_lorentzBivector_eq_explicit]
  have hTwoMinor : forall a b component,
      (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          spacetimeAlternatingSymbol c d a b *
            coframeWedge coframe c d component)) =
        coframe.det * Finset.sum Finset.univ (fun k =>
          Finset.sum Finset.univ (fun l =>
            spacetimeAlternatingSymbol
              (bivectorFirst component) (bivectorSecond component) k l *
              inverseCoframe a k * inverseCoframe b l)) := by
    intro a b component
    apply alternating_coframe_two_minor
      coframe inverseCoframe hLeft
  simp +decide only [transportApply]
  simp +decide [Fin.sum_univ_six, lorentzHodgeStar] at *
  simp +decide only [hTwoMinor, bivectorMatrix]
  simp +decide [Fin.sum_univ_four, bivectorFirst, bivectorSecond,
    spacetimeAlternatingSymbol]
  ring

/-- Mixed Ricci contraction with one plaquette direction left uncontracted
and one direction raised by the inverse coframe. -/
def mixedRicciCurvature
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (coframeDirection raisedDirection : Fin 4) : Real :=
  Finset.sum Finset.univ (fun i =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun j =>
        inverseCoframe raisedDirection i * inverseCoframe b j *
          bivectorMatrix (curvature coframeDirection b) i j)))

/-- Coframe-index form of twice the mixed Ricci contraction minus its scalar
trace. Multiplication by the coframe converts this coefficient to the usual
mixed-index expression `2 Ric^d_c - delta^d_c R`. -/
def mixedEinsteinCoframeCoefficient
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (internal direction : Fin 4) : Real :=
  2 * Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun i =>
      Finset.sum Finset.univ (fun b =>
        Finset.sum Finset.univ (fun j =>
          inverseCoframe a internal *
            (inverseCoframe direction i * inverseCoframe b j *
              bivectorMatrix (curvature a b) i j))))) -
    inverseCoframe direction internal *
      inverseCoframeScalarCurvature inverseCoframe curvature

/-- Entrywise form of the supplied left inverse relation. -/
theorem inverseCoframe_contract_coframe
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1) (a c : Fin 4) :
    Finset.sum Finset.univ (fun internal =>
      inverseCoframe a internal * coframe internal c) =
      (1 : Matrix (Fin 4) (Fin 4) Real) a c := by
  have hEntry := congrFun (congrFun hLeft a) c
  simpa [Matrix.mul_apply] using hEntry

/-- A fourfold inverse-coframe contraction collapses its internal coframe
index by the supplied left inverse relation. -/
theorem inverseCoframe_contract_fourfoldSum
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (summand : Fin 4 -> Fin 4 -> Fin 4 -> Fin 4 -> Real)
    (hLeft : inverseCoframe * coframe = 1) (c : Fin 4) :
    Finset.sum Finset.univ (fun internal =>
        coframe internal c *
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun i =>
              Finset.sum Finset.univ (fun b =>
                Finset.sum Finset.univ (fun j =>
                  inverseCoframe a internal * summand a i b j))))) =
      Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun j => summand c i b j))) := by
  calc
    _ = Finset.sum Finset.univ (fun internal =>
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun i =>
              Finset.sum Finset.univ (fun b =>
                Finset.sum Finset.univ (fun j =>
                  coframe internal c *
                    (inverseCoframe a internal * summand a i b j)))))) := by
      simp only [Finset.mul_sum]
    _ = Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun b =>
              Finset.sum Finset.univ (fun j =>
                Finset.sum Finset.univ (fun internal =>
                  coframe internal c *
                    (inverseCoframe a internal * summand a i b j)))))) := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro a _
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro i _
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro b _
      rw [Finset.sum_comm]
    _ = Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun b =>
              Finset.sum Finset.univ (fun j =>
                (Finset.sum Finset.univ (fun internal =>
                  inverseCoframe a internal * coframe internal c)) *
                    summand a i b j)))) := by
      apply Finset.sum_congr rfl
      intro a _
      apply Finset.sum_congr rfl
      intro i _
      apply Finset.sum_congr rfl
      intro b _
      apply Finset.sum_congr rfl
      intro j _
      rw [Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro internal _
      ring
    _ = _ := by
      simp_rw [inverseCoframe_contract_coframe
        coframe inverseCoframe hLeft]
      simp [Matrix.one_apply]

/-- Contracting the coframe-index Einstein coefficient with the coframe gives
exactly twice the mixed Ricci contraction minus its scalar trace. -/
theorem coframe_contract_mixedEinsteinCoframeCoefficient
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hLeft : inverseCoframe * coframe = 1)
    (coframeDirection raisedDirection : Fin 4) :
    Finset.sum Finset.univ (fun internal =>
        coframe internal coframeDirection *
          mixedEinsteinCoframeCoefficient inverseCoframe curvature
            internal raisedDirection) =
      2 * mixedRicciCurvature inverseCoframe curvature
          coframeDirection raisedDirection -
        (1 : Matrix (Fin 4) (Fin 4) Real)
            raisedDirection coframeDirection *
          inverseCoframeScalarCurvature inverseCoframe curvature := by
  have hFirst :
      Finset.sum Finset.univ (fun internal =>
        coframe internal coframeDirection *
          (2 * Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun i =>
              Finset.sum Finset.univ (fun b =>
                Finset.sum Finset.univ (fun j =>
                  inverseCoframe a internal *
                    (inverseCoframe raisedDirection i *
                      inverseCoframe b j *
                        bivectorMatrix (curvature a b) i j))))))) =
        2 * mixedRicciCurvature inverseCoframe curvature
          coframeDirection raisedDirection := by
    calc
      _ = 2 * Finset.sum Finset.univ (fun internal =>
          coframe internal coframeDirection *
            Finset.sum Finset.univ (fun a =>
              Finset.sum Finset.univ (fun i =>
                Finset.sum Finset.univ (fun b =>
                  Finset.sum Finset.univ (fun j =>
                    inverseCoframe a internal *
                      (inverseCoframe raisedDirection i *
                        inverseCoframe b j *
                          bivectorMatrix (curvature a b) i j)))))) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro internal _
        ring
      _ = _ := by
        rw [inverseCoframe_contract_fourfoldSum
          coframe inverseCoframe _ hLeft coframeDirection]
        rfl
  have hTrace :
      Finset.sum Finset.univ (fun internal =>
        coframe internal coframeDirection *
          (inverseCoframe raisedDirection internal *
            inverseCoframeScalarCurvature inverseCoframe curvature)) =
        (1 : Matrix (Fin 4) (Fin 4) Real)
            raisedDirection coframeDirection *
          inverseCoframeScalarCurvature inverseCoframe curvature := by
    calc
      _ = (Finset.sum Finset.univ (fun internal =>
          inverseCoframe raisedDirection internal *
            coframe internal coframeDirection)) *
          inverseCoframeScalarCurvature inverseCoframe curvature := by
        rw [Finset.sum_mul]
        apply Finset.sum_congr rfl
        intro internal _
        ring
      _ = _ := by
        rw [inverseCoframe_contract_coframe
          coframe inverseCoframe hLeft]
  unfold mixedEinsteinCoframeCoefficient
  simp_rw [mul_sub]
  rw [Finset.sum_sub_distrib, hFirst, hTrace]

/-- Contracting coframe-coordinate coefficients back through a supplied right
inverse recovers the original internal coefficient. -/
theorem inverseCoframe_contract_coframeCoordinate
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (coefficient : Fin 4 -> Real)
    (hRight : coframe * inverseCoframe = 1) (internal : Fin 4) :
    Finset.sum Finset.univ (fun c =>
        inverseCoframe c internal *
          Finset.sum Finset.univ (fun other =>
            coframe other c * coefficient other)) =
      coefficient internal := by
  have hEntry (other internal : Fin 4) :
      Finset.sum Finset.univ (fun c =>
        coframe other c * inverseCoframe c internal) =
        (1 : Matrix (Fin 4) (Fin 4) Real) other internal := by
    have h := congrFun (congrFun hRight other) internal
    simpa [Matrix.mul_apply] using h
  calc
    _ = Finset.sum Finset.univ (fun other =>
          (Finset.sum Finset.univ (fun c =>
            coframe other c * inverseCoframe c internal)) *
              coefficient other) := by
      simp only [Finset.mul_sum, Finset.sum_mul]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro other _
      apply Finset.sum_congr rfl
      intro c _
      ring
    _ = _ := by
      simp_rw [hEntry]
      simp [Matrix.one_apply]

/-- For a two-sided inverse coframe, the sixteen coframe-index coefficients
vanish exactly when the sixteen mixed vacuum Einstein combinations vanish. -/
theorem mixedEinsteinCoframeCoefficient_vanish_iff
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1) :
    (forall internal direction,
      mixedEinsteinCoframeCoefficient inverseCoframe curvature
        internal direction = 0) ↔
    (forall coframeDirection raisedDirection,
      2 * mixedRicciCurvature inverseCoframe curvature
          coframeDirection raisedDirection -
        (1 : Matrix (Fin 4) (Fin 4) Real)
            raisedDirection coframeDirection *
          inverseCoframeScalarCurvature inverseCoframe curvature = 0) := by
  constructor
  · intro hCoefficient coframeDirection raisedDirection
    rw [← coframe_contract_mixedEinsteinCoframeCoefficient
      coframe inverseCoframe curvature hLeft]
    simp_rw [hCoefficient]
    simp
  · intro hMixed internal direction
    rw [← inverseCoframe_contract_coframeCoordinate
      coframe inverseCoframe
      (fun other =>
        mixedEinsteinCoframeCoefficient inverseCoframe curvature
          other direction) hRight internal]
    apply Finset.sum_eq_zero
    intro coframeDirection _
    rw [coframe_contract_mixedEinsteinCoframeCoefficient
      coframe inverseCoframe curvature hLeft]
    rw [hMixed coframeDirection direction]
    ring

/-- The exact extracted-curvature action is a sum of site-local Palatini
densities. -/
theorem extractedCurvaturePalatiniAction_eq_sum_palatiniDensity
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    extractedCurvaturePalatiniAction shift connection coframe =
      Finset.sum Finset.univ (fun site =>
        palatiniDensity (coframe site)
          (extractedPlaquetteCurvature shift connection site)) := by
  unfold extractedCurvaturePalatiniAction palatiniDensity
  exact sum_direction_direction_site_cycle _

set_option maxHeartbeats 1000000 in
/-- Each site-local coframe Euler functional is the first variation of that
site's Palatini density against the extracted antisymmetric curvature. -/
theorem nonlinearCoframeLocalEulerFunctional_eq_palatiniDensityFirstVariation
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (probe : Matrix (Fin 4) (Fin 4) Real) :
    nonlinearCoframeLocalEulerFunctional
        shift connection coframe site probe =
      palatiniDensityFirstVariation (coframe site) probe
        (extractedPlaquetteCurvature shift connection site) := by
  unfold nonlinearCoframeLocalEulerFunctional
    palatiniDensityFirstVariation extractedPlaquetteCurvature
    rawPlaquetteCurvature
  simp_rw [orderedPlaquetteActionTerm_eq_kreinPair_curvature]
  have h := orderedKreinSum_antisymmetrize
    (Site := Unit)
    (fun _ a b =>
      complementaryPalatiniFaceWeightFirstVariation
        (coframe site) probe a b)
    (fun _ a b =>
      orderedHolonomyCurvature (plaquetteUnit shift connection site a b))
    (by
      intro _ a b component
      exact congrFun
        (complementaryPalatiniFaceWeightFirstVariation_swap
          (coframe site) probe b a) component)
  simpa using h

/-- The ordinary coframe response of the concrete nonlinear action is a sum
of site-local Palatini-density responses against the same extracted
antisymmetric curvature field used by the action itself. -/
theorem nonlinearCoframePlaquetteCoframeFirstResponse_eq_sum_palatiniDensityFirstVariation
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe variation : CoframeField Site) :
    nonlinearCoframePlaquetteCoframeFirstResponse
        shift connection coframe variation =
      Finset.sum Finset.univ (fun site =>
        palatiniDensityFirstVariation (coframe site) (variation site)
          (extractedPlaquetteCurvature shift connection site)) := by
  unfold nonlinearCoframePlaquetteCoframeFirstResponse
    nonlinearFacePlaquetteAction coframeFaceWeightFirstVariation
    palatiniDensityFirstVariation extractedPlaquetteCurvature
    rawPlaquetteCurvature
  simp_rw [orderedPlaquetteActionTerm_eq_kreinPair_curvature]
  rw [orderedKreinSum_antisymmetrize
    (fun site a b =>
      complementaryPalatiniFaceWeightFirstVariation
        (coframe site) (variation site) a b)
    (fun site a b =>
      orderedHolonomyCurvature (plaquetteUnit shift connection site a b))
    (coframeFaceWeightFirstVariation_isAntisymmetric coframe variation)]
  exact sum_direction_direction_site_cycle _

set_option maxHeartbeats 1000000 in
/-- At the identity coframe, the project conventions give exactly the
negative inverse-coframe scalar contraction. -/
theorem palatiniDensity_one
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    palatiniDensity 1 curvature =
      -inverseCoframeScalarCurvature 1 curvature := by
  unfold palatiniDensity inverseCoframeScalarCurvature
  simp +decide [complementaryPalatiniFaceWeight, palatiniFaceWeight,
    spacetimeAlternatingSymbol, coframeWedge, transportApply,
    lorentzHodgeStar, kreinPair,
    lorentzBivectorFundamentalSymmetry_matrix, splitSixMatrix,
    splitSixSign, fiberPair, bivectorMatrix, bivectorFirst, bivectorSecond,
    Matrix.diagonal_apply, Matrix.one_apply,
    Fin.sum_univ_six, Fin.sum_univ_four]
  ring

/-- The coframe field that is the identity matrix at every site. -/
def identityCoframeField (Site : Type*) : CoframeField Site :=
  fun _ => 1

/-- Exact scalar curvature of the extracted plaquette field for a supplied
inverse coframe at one site. -/
def extractedScalarCurvatureAt
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (inverseCoframe : CoframeField Site) (site : Site) : Real :=
  inverseCoframeScalarCurvature (inverseCoframe site)
    (extractedPlaquetteCurvature shift connection site)

/-- For a supplied pointwise left inverse coframe, the concrete
nonlinear plaquette action is exactly the oriented determinant-weighted
scalar-curvature sum, with the project convention's overall minus sign. -/
theorem nonlinearCoframePlaquetteAction_eq_neg_sum_det_mul_extractedScalarCurvature
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1) :
    nonlinearCoframePlaquetteAction shift connection coframe =
      -Finset.sum Finset.univ (fun site =>
        (coframe site).det *
          extractedScalarCurvatureAt
            shift connection inverseCoframe site) := by
  rw [nonlinearCoframePlaquetteAction_eq_extractedCurvaturePalatiniAction,
    extractedCurvaturePalatiniAction_eq_sum_palatiniDensity]
  simp_rw [palatiniDensity_eq_neg_det_mul_inverseCoframeScalarCurvature
    (hLeft := hLeft _)]
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro site _
  unfold extractedScalarCurvatureAt
  ring

/-- On the identity coframe field, the concrete nonlinear action is exactly
minus the sum of the extracted scalar-curvature contractions. -/
theorem nonlinearCoframePlaquetteAction_identityCoframe
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) :
    nonlinearCoframePlaquetteAction shift connection
        (identityCoframeField Site) =
      -Finset.sum Finset.univ (fun site =>
        extractedScalarCurvatureAt shift connection
          (identityCoframeField Site) site) := by
  rw [nonlinearCoframePlaquetteAction_eq_extractedCurvaturePalatiniAction,
    extractedCurvaturePalatiniAction_eq_sum_palatiniDensity]
  simp_rw [identityCoframeField, palatiniDensity_one]
  rw [Finset.sum_neg_distrib]
  rfl

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.alternating_coframe_two_minor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms alternating_coframe_two_minor

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.palatiniDensity_eq_neg_det_mul_inverseCoframeScalarCurvature' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms palatiniDensity_eq_neg_det_mul_inverseCoframeScalarCurvature

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.nonlinearCoframePlaquetteAction_eq_neg_sum_det_mul_extractedScalarCurvature' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteAction_eq_neg_sum_det_mul_extractedScalarCurvature

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.extractedCurvaturePalatiniAction_eq_sum_palatiniDensity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms extractedCurvaturePalatiniAction_eq_sum_palatiniDensity

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.nonlinearCoframeLocalEulerFunctional_eq_palatiniDensityFirstVariation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframeLocalEulerFunctional_eq_palatiniDensityFirstVariation

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.nonlinearCoframePlaquetteCoframeFirstResponse_eq_sum_palatiniDensityFirstVariation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteCoframeFirstResponse_eq_sum_palatiniDensityFirstVariation

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.coframe_contract_mixedEinsteinCoframeCoefficient' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coframe_contract_mixedEinsteinCoframeCoefficient

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.mixedEinsteinCoframeCoefficient_vanish_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mixedEinsteinCoframeCoefficient_vanish_iff

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.palatiniDensity_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms palatiniDensity_one

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.nonlinearCoframePlaquetteAction_identityCoframe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteAction_identityCoframe

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
