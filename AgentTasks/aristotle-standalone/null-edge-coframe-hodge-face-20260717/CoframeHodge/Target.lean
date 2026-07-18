import Mathlib

/-!
# Coframe-derived Lorentz-Hodge Palatini face target

Focused proof target for the next null-edge gravity bridge. The six-component
basis is ordered as spatial rotation planes followed by time-space boost
planes:

`(12, 13, 23, 01, 02, 03)`.

The mostly-minus metric induces signs `(+,+,+,-,-,-)`. The Lorentz Hodge star
uses orientation `0123` and obeys `star^2 = -1` on two-forms. A Palatini face
weight is defined as `star (e_a wedge e_b)`.

The target theorems ask for covariance of the coframe wedge, commutation of
the Hodge star with the exterior-square action of a proper Lorentz matrix, and
covariance of the resulting face weight. The determinant-one hypothesis is
essential: orientation-reversing Lorentz matrices anticommute with the Hodge
star instead.
-/

namespace CoframeHodge

abbrev Fiber (n : Nat) := Fin n -> Real

def transportApply
    (matrix : Matrix (Fin n) (Fin n) Real) (field : Fiber n) : Fiber n :=
  fun i => Finset.sum Finset.univ (fun j => matrix i j * field j)

def bivectorFirst : Fin 6 -> Fin 4 :=
  ![1, 1, 2, 0, 0, 0]

def bivectorSecond : Fin 6 -> Fin 4 :=
  ![2, 3, 3, 1, 2, 3]

def eta : Matrix (Fin 4) (Fin 4) Real :=
  !![1, 0, 0, 0; 0, -1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

def IsEtaLorentz (L : Matrix (Fin 4) (Fin 4) Real) : Prop :=
  L.transpose * eta * L = eta

def wedgeTwoTransport (L : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 6) (Fin 6) Real :=
  fun i j =>
    L (bivectorFirst i) (bivectorFirst j) *
        L (bivectorSecond i) (bivectorSecond j) -
      L (bivectorFirst i) (bivectorSecond j) *
        L (bivectorSecond i) (bivectorFirst j)

/-- Internal two-form coordinates of the two coframe columns selected by the
ordered face directions `a,b`. -/
def coframeWedge (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber 6 :=
  fun component =>
    coframe (bivectorFirst component) a *
        coframe (bivectorSecond component) b -
      coframe (bivectorFirst component) b *
        coframe (bivectorSecond component) a

/-- Lorentz Hodge star on the ordered two-form basis, with orientation
`e0 wedge e1 wedge e2 wedge e3`. -/
def lorentzHodgeStar : Matrix (Fin 6) (Fin 6) Real :=
  !![0, 0, 0, 0, 0, -1;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, -1, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, -1, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0]

def palatiniFaceWeight (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber 6 :=
  transportApply lorentzHodgeStar (coframeWedge coframe a b)

/-- Coframe wedge coordinates reverse sign when face orientation reverses. -/
theorem coframeWedge_swap (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) :
    coframeWedge coframe b a = fun component => -coframeWedge coframe a b component := by
  funext component
  unfold coframeWedge
  ring

/-- Matrix action commutes with pointwise negation. -/
theorem transportApply_neg
    (matrix : Matrix (Fin n) (Fin n) Real) (field : Fiber n) :
    transportApply matrix (fun component => -field component) =
      fun component => -transportApply matrix field component := by
  funext component
  unfold transportApply
  simp only [mul_neg, Finset.sum_neg_distrib]

/-- The Lorentz Hodge star squares to minus identity on two-forms. -/
theorem lorentzHodgeStar_sq :
    lorentzHodgeStar * lorentzHodgeStar =
      -(1 : Matrix (Fin 6) (Fin 6) Real) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [lorentzHodgeStar, Matrix.mul_apply, Fin.sum_univ_six]

/-- The coframe-derived Palatini face weight is antisymmetric in its ordered
face directions. -/
theorem palatiniFaceWeight_swap
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    palatiniFaceWeight coframe b a =
      fun component => -palatiniFaceWeight coframe a b component := by
  unfold palatiniFaceWeight
  rw [coframeWedge_swap, transportApply_neg]

/-- Repeated face directions give zero Palatini weight. -/
theorem palatiniFaceWeight_self
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a : Fin 4) :
    palatiniFaceWeight coframe a a = 0 := by
  funext component
  unfold palatiniFaceWeight transportApply coframeWedge
  simp

/-- Target 1: exterior-square transport is the induced action on coframe
wedge coordinates. -/
theorem coframeWedge_mul
    (L coframe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    coframeWedge (L * coframe) a b =
      transportApply (wedgeTwoTransport L) (coframeWedge coframe a b) := by
  sorry

/-- Target 2: the Hodge star commutes with every proper eta-Lorentz exterior-
square transport. The determinant gate records orientation preservation. -/
theorem wedgeTwoTransport_commutes_lorentzHodgeStar
    (L : Matrix (Fin 4) (Fin 4) Real) (hLorentz : IsEtaLorentz L)
    (hProper : L.det = 1) :
    wedgeTwoTransport L * lorentzHodgeStar =
      lorentzHodgeStar * wedgeTwoTransport L := by
  sorry

/-- Target 3: the Hodge-dual coframe wedge is a Lorentz-covariant ordered face
field. -/
theorem palatiniFaceWeight_mul
    (L coframe : Matrix (Fin 4) (Fin 4) Real) (hLorentz : IsEtaLorentz L)
    (hProper : L.det = 1) (a b : Fin 4) :
    palatiniFaceWeight (L * coframe) a b =
      transportApply (wedgeTwoTransport L) (palatiniFaceWeight coframe a b) := by
  sorry

end CoframeHodge
