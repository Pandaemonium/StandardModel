import Mathlib

noncomputable section

namespace PalatiniCoframeEinstein

set_option maxHeartbeats 3000000

abbrev Fiber6 := Fin 6 -> Real

/-- Ordered internal bivector basis `(12,13,23,01,02,03)`. -/
def bivectorFirst : Fin 6 -> Fin 4
  | 0 => 1 | 1 => 1 | 2 => 2 | 3 => 0 | 4 => 0 | 5 => 0

def bivectorSecond : Fin 6 -> Fin 4
  | 0 => 2 | 1 => 3 | 2 => 3 | 3 => 1 | 4 => 2 | 5 => 3

/-- Internal bivector coordinates of two ordered coframe columns. -/
def coframeWedge (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber6 :=
  fun component =>
    coframe (bivectorFirst component) a *
        coframe (bivectorSecond component) b -
      coframe (bivectorFirst component) b *
        coframe (bivectorSecond component) a

/-- Polarized first response of one coframe wedge. -/
def coframeWedgeFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber6 :=
  fun component =>
    variation (bivectorFirst component) a *
        coframe (bivectorSecond component) b +
      coframe (bivectorFirst component) a *
        variation (bivectorSecond component) b -
      variation (bivectorFirst component) b *
        coframe (bivectorSecond component) a -
      coframe (bivectorFirst component) b *
        variation (bivectorSecond component) a

/-- Lorentz Hodge star in orientation `0123`. -/
def lorentzHodgeStar : Matrix (Fin 6) (Fin 6) Real :=
  !![0, 0, 0, 0, 0, -1;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, -1, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, -1, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0]

def transportApply
    (transport : Matrix (Fin 6) (Fin 6) Real) (field : Fiber6) : Fiber6 :=
  fun i => Finset.sum Finset.univ (fun j => transport i j * field j)

def palatiniFaceWeightFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber6 :=
  transportApply lorentzHodgeStar
    (coframeWedgeFirstVariation coframe variation a b)

/-- Four-dimensional alternating symbol with `epsilon 0 1 2 3 = +1`. -/
def spacetimeAlternatingSymbol (a b c d : Fin 4) : Real :=
  (((b : Real) - (a : Real)) * ((c : Real) - (a : Real)) *
      ((d : Real) - (a : Real)) * ((c : Real) - (b : Real)) *
      ((d : Real) - (b : Real)) * ((d : Real) - (c : Real))) / 12

/-- Polarized first response of the complementary coframe coefficient. -/
def complementaryPalatiniFaceWeightFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber6 :=
  fun component =>
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbol c d a b *
          palatiniFaceWeightFirstVariation coframe variation c d component))

/-- Mostly-minus Krein pairing on ordered bivector coordinates. -/
def kreinPair (left right : Fiber6) : Real :=
  left 0 * right 0 + left 1 * right 1 + left 2 * right 2 -
    left 3 * right 3 - left 4 * right 4 - left 5 * right 5

/-- Antisymmetric internal curvature matrix represented by six coordinates. -/
def curvatureMatrix (curvature : Fiber6) : Matrix (Fin 4) (Fin 4) Real :=
  !![0, curvature 3, curvature 4, curvature 5;
     -curvature 3, 0, curvature 0, curvature 1;
     -curvature 4, -curvature 0, 0, curvature 2;
     -curvature 5, -curvature 1, -curvature 2, 0]

/-- Ordinary first coframe response of the ordered Palatini density. -/
def palatiniDensityFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber6) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      kreinPair
        (complementaryPalatiniFaceWeightFirstVariation
          coframe variation a b)
        (curvature a b)))

/-- Scalar curvature obtained by inverse-coframe contraction of the internal
curvature face. -/
def scalarCurvature
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber6) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun j =>
          inverseCoframe a i * inverseCoframe b j *
            curvatureMatrix (curvature a b) i j))))

/-- Coframe-index form of twice the mixed Ricci tensor minus its scalar
trace. Multiplication by the coframe converts this to
`2 Ric^d_c - delta^d_c R`. -/
def mixedEinsteinCoframeCoefficient
    (inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber6)
    (internal direction : Fin 4) : Real :=
  2 * Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun i =>
      Finset.sum Finset.univ (fun b =>
        Finset.sum Finset.univ (fun j =>
          inverseCoframe a internal * inverseCoframe direction i *
            inverseCoframe b j * curvatureMatrix (curvature a b) i j)))) -
    inverseCoframe direction internal *
      scalarCurvature inverseCoframe curvature

/-- The exact tetrad response of the ordered Palatini density is the
determinant-weighted mixed Einstein coefficient paired with the arbitrary
coframe variation. -/
theorem palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (coframe inverseCoframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber6)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component) :
    palatiniDensityFirstVariation coframe variation curvature =
      coframe.det * Finset.sum Finset.univ (fun internal =>
        Finset.sum Finset.univ (fun direction =>
          mixedEinsteinCoframeCoefficient inverseCoframe curvature
            internal direction * variation internal direction)) := by
  sorry

end PalatiniCoframeEinstein
