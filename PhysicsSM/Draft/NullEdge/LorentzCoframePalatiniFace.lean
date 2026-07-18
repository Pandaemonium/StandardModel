import PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
import PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation

/-!
# Lorentz-Hodge Palatini face fields from a coframe

This module removes the arbitrary six-component face field from the local
algebraic part of the finite link/face Palatini construction.  For a concrete
coframe matrix `e`, two ordered coframe directions `a,b` determine the internal
bivector `e_a wedge e_b`.  Its Lorentz Hodge dual

`B_ab(e) = star (e_a wedge e_b)`.

is the internal bivector building block.  When `a,b` instead label the actual
curvature plaquette, the four-form `e wedge e wedge F` requires the
complementary coframe directions.  The corresponding curvature-face weight is

`B^dual_ab(e) = (1/2) sum_cd epsilon^(cdab) star(e_c wedge e_d)`.

Keeping these two objects separate prevents the same plaquette label from
being used simultaneously for both factors of the four-form.

The internal metric is mostly-minus, the orientation is `0123`, and the
ordered bivector basis is `(12,13,23,01,02,03)`.  In these conventions the
Hodge star squares to minus the identity on two-forms.  The resulting face
field is antisymmetric in `a,b` and vanishes for repeated directions.

## Scope and provenance

This is an exact finite coframe-to-face construction.  It proves covariance
of both the internal and complementary face fields under proper Lorentz
coframe changes, but it does not yet attach metric dual-cell volumes.  The four-dimensional
Palatini face `star(e wedge e)` and complementary spacetime contraction are
standard `[import]`; the explicit basis, signs, and link to the null-edge
six-component fiber are `[orig]`.  The permutation architecture follows Kur
and Glasser, *Discrete Gravity with Local Lorentz Invariance*,
arXiv:2202.02486, especially Eqs. (15), (16), and (25).  Claim label: finite
identity.
-/

namespace PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace

open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge

/-- Internal bivector coordinates of two ordered coframe columns. -/
def coframeWedge (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber 6 :=
  fun component =>
    coframe (bivectorFirst component) a *
        coframe (bivectorSecond component) b -
      coframe (bivectorFirst component) b *
        coframe (bivectorSecond component) a

/-- Lorentz Hodge star in orientation `0123` and the ordered
`(12,13,23,01,02,03)` basis. -/
def lorentzHodgeStar : Matrix (Fin 6) (Fin 6) Real :=
  !![0, 0, 0, 0, 0, -1;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, -1, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, -1, 0, 0, 0, 0;
     1, 0, 0, 0, 0, 0]

/-- Explicit coordinate display of the already-derived mostly-minus metric on
the ordered bivector basis. -/
def hodgeBivectorMetric : Matrix (Fin 6) (Fin 6) Real :=
  !![1, 0, 0, 0, 0, 0;
     0, 1, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, -1, 0, 0;
     0, 0, 0, 0, -1, 0;
     0, 0, 0, 0, 0, -1]

/-- The explicit Hodge-proof metric is exactly the metric already induced
from the mostly-minus spacetime form. -/
theorem hodgeBivectorMetric_eq_spacetimeBivectorMetric :
    hodgeBivectorMetric = spacetimeBivectorMetric := by
  rw [spacetimeBivectorMetric_eq_splitSixMatrix]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [hodgeBivectorMetric, splitSixMatrix, splitSixSign]

/-- Euclidean complementary-pair involution in the ordered bivector basis.
The Lorentz Hodge star is this complement followed by the derived bivector
metric. -/
def euclideanBivectorComplement : Matrix (Fin 6) (Fin 6) Real :=
  lorentzHodgeStar * hodgeBivectorMetric

/-- Internal Hodge dual of the ordered coframe bivector.  This is the Palatini
`B`-field building block associated with the coframe pair `a,b`; it is not by
itself the coefficient of curvature on the same `(a,b)` plaquette. -/
def palatiniFaceWeight (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber 6 :=
  transportApply lorentzHodgeStar (coframeWedge coframe a b)

/-- Four-dimensional alternating symbol in orientation `0123`.

The normalized Vandermonde formula is exact on `Fin 4`: it is `+1` on
`(0,1,2,3)`, changes sign under an adjacent swap, and vanishes whenever two
indices coincide. -/
noncomputable def spacetimeAlternatingSymbol (a b c d : Fin 4) : Real :=
  (((b : Real) - (a : Real)) * ((c : Real) - (a : Real)) *
      ((d : Real) - (a : Real)) * ((c : Real) - (b : Real)) *
      ((d : Real) - (b : Real)) * ((d : Real) - (c : Real))) / 12

/-- Coefficient of curvature on the ordered plaquette `(a,b)` in the
tetradic Palatini four-form.  The coframe bivector comes from the complementary
directions selected by the spacetime alternating symbol. -/
noncomputable def complementaryPalatiniFaceWeight
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) : Fiber 6 :=
  fun component =>
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbol c d a b *
          palatiniFaceWeight coframe c d component))

/-- Orientation contraction of two antisymmetric internal bivectors in the
ordered `(12,13,23,01,02,03)` coordinates.  This is the six-coordinate form
of `(1/4) epsilon_IJKL B^IJ C^KL` with `epsilon_0123 = +1`. -/
def internalAlternatingBivectorPair (left right : Fiber 6) : Real :=
  left 3 * right 2 - left 4 * right 1 + left 5 * right 0 +
    left 0 * right 5 - left 1 * right 4 + left 2 * right 3

/-- Coframe wedge coordinates reverse sign when face orientation reverses. -/
theorem coframeWedge_swap (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) :
    coframeWedge coframe b a =
      fun component => -coframeWedge coframe a b component := by
  funext component
  unfold coframeWedge
  ring

/-- Swapping the last two spacetime indices reverses the alternating symbol.
-/
theorem spacetimeAlternatingSymbol_swap_last (a b c d : Fin 4) :
    spacetimeAlternatingSymbol a b d c =
      -spacetimeAlternatingSymbol a b c d := by
  unfold spacetimeAlternatingSymbol
  ring

/-- Exterior-square transport is exactly the induced action on the ordered
coframe-wedge coordinates. -/
theorem coframeWedge_mul
    (L coframe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    coframeWedge (L * coframe) a b =
      transportApply (wedgeTwoTransport L) (coframeWedge coframe a b) := by
  funext component
  fin_cases component <;>
    simp +decide [coframeWedge, transportApply, wedgeTwoTransport,
      Matrix.mul_apply, bivectorFirst, bivectorSecond, Fin.sum_univ_four,
      Fin.sum_univ_six] <;>
    ring

/-- An eta-Lorentz matrix has the displayed mostly-minus left inverse. -/
lemma etaLorentz_inverse
    (L : Matrix (Fin 4) (Fin 4) Real) (hLorentz : IsEtaLorentz L) :
    (MinkowskiConvention.eta * L.transpose * MinkowskiConvention.eta) * L =
      1 := by
  unfold IsEtaLorentz at hLorentz
  convert congr_arg (MinkowskiConvention.eta * ·) hLorentz using 1
  · norm_num [Matrix.mul_assoc]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [MinkowskiConvention.eta, Matrix.mul_apply,
        Fin.sum_univ_four]
    all_goals repeat erw [Matrix.cons_val_succ']
    all_goals norm_num

/-- For a proper eta-Lorentz matrix, the adjugate is its explicit inverse. -/
lemma properLorentz_adjugate
    (L : Matrix (Fin 4) (Fin 4) Real) (hLorentz : IsEtaLorentz L)
    (hProper : L.det = 1) :
    L.adjugate =
      MinkowskiConvention.eta * L.transpose * MinkowskiConvention.eta := by
  have hLeft := etaLorentz_inverse L hLorentz
  have hRight : L * L.adjugate = 1 := by
    rw [Matrix.mul_adjugate, hProper]
    simp
  calc
    L.adjugate = 1 * L.adjugate := by simp
    _ = ((MinkowskiConvention.eta * L.transpose * MinkowskiConvention.eta) *
          L) * L.adjugate := by rw [hLeft]
    _ = (MinkowskiConvention.eta * L.transpose * MinkowskiConvention.eta) *
          (L * L.adjugate) := by simp [Matrix.mul_assoc]
    _ = (MinkowskiConvention.eta * L.transpose * MinkowskiConvention.eta) *
          1 := by rw [hRight]
    _ = MinkowskiConvention.eta * L.transpose * MinkowskiConvention.eta := by
      simp

/-- The explicit second compound preserves matrix multiplication. -/
lemma wedgeTwoTransport_mul
    (left right : Matrix (Fin 4) (Fin 4) Real) :
    wedgeTwoTransport (left * right) =
      wedgeTwoTransport left * wedgeTwoTransport right := by
  have hExpand :
      forall left right : Matrix (Fin 4) (Fin 4) Real,
        wedgeTwoTransport (left * right) =
          wedgeTwoTransport left * wedgeTwoTransport right := by
    intro left right
    have hComponent :
        forall i j : Fin 6,
          wedgeTwoTransport (left * right) i j =
            (wedgeTwoTransport left * wedgeTwoTransport right) i j := by
      unfold wedgeTwoTransport
      simp +decide [Matrix.mul_apply, Fin.sum_univ_four]
      intro i j
      rw [Fin.sum_univ_six]
      ring!
    exact Matrix.ext hComponent
  exact hExpand left right

/-- The explicit second compound preserves transposition. -/
lemma wedgeTwoTransport_transpose
    (matrix : Matrix (Fin 4) (Fin 4) Real) :
    wedgeTwoTransport matrix.transpose =
      (wedgeTwoTransport matrix).transpose := by
  ext i j
  simp +decide [wedgeTwoTransport]
  ring

/-- The second compound of the spacetime metric is the derived bivector
metric. -/
lemma wedgeTwoTransport_eta :
    wedgeTwoTransport MinkowskiConvention.eta = hodgeBivectorMetric := by
  unfold wedgeTwoTransport hodgeBivectorMetric
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [MinkowskiConvention.eta, bivectorFirst, bivectorSecond]

set_option maxHeartbeats 1000000 in
/-- Jacobi's complementary-minor identity for the explicit second compound.
This is the finite algebraic core of proper-Lorentz Hodge covariance. -/
lemma wedgeTwoTransport_adjugate
    (L : Matrix (Fin 4) (Fin 4) Real) :
    wedgeTwoTransport L.adjugate =
      L.det •
        (euclideanBivectorComplement * (wedgeTwoTransport L).transpose *
          euclideanBivectorComplement) := by
  unfold wedgeTwoTransport euclideanBivectorComplement
  ext i j
  simp +decide [Matrix.mul_apply, Matrix.adjugate_apply,
    Matrix.det_succ_row_zero]
  simp +decide [Fin.sum_univ_succ, Fin.succAbove]
  simp +decide [Matrix.updateRow_apply, bivectorFirst, bivectorSecond,
    lorentzHodgeStar, hodgeBivectorMetric]
  fin_cases j <;> simp +decide [Pi.single_apply] at *
  fin_cases i <;> simp +decide <;> ring!
  all_goals fin_cases i <;> simp +decide <;> ring!

/-- Entrywise proper-Lorentz invariance of the Lorentz Hodge star. -/
lemma properLorentz_hodge_entry
    (L : Matrix (Fin 4) (Fin 4) Real) (hLorentz : IsEtaLorentz L)
    (hProper : L.det = 1) (i j : Fin 6) :
    (wedgeTwoTransport L * lorentzHodgeStar) i j =
      (lorentzHodgeStar * wedgeTwoTransport L) i j := by
  set compound := wedgeTwoTransport L
  set metric := hodgeBivectorMetric
  set complement := euclideanBivectorComplement
  set hodge := lorentzHodgeStar
  have hDerived :
      metric * compound.transpose * metric =
        complement * compound.transpose * complement := by
    convert wedgeTwoTransport_adjugate L using 1
    · rw [properLorentz_adjugate L hLorentz hProper]
      rw [show wedgeTwoTransport
            (MinkowskiConvention.eta * L.transpose *
              MinkowskiConvention.eta) =
            wedgeTwoTransport MinkowskiConvention.eta *
              wedgeTwoTransport L.transpose *
                wedgeTwoTransport MinkowskiConvention.eta by
          rw [wedgeTwoTransport_mul, wedgeTwoTransport_mul]]
      rw [wedgeTwoTransport_transpose, wedgeTwoTransport_eta]
    · simp [hProper, complement, compound]
  have hIdentities :
      metric * metric = 1 ∧ complement * complement = 1 ∧
        complement * metric = hodge := by
    norm_num [metric, complement, hodge, hodgeBivectorMetric,
      euclideanBivectorComplement, lorentzHodgeStar]
    exact Matrix.ext fun row column => by
      fin_cases row <;> fin_cases column <;> rfl
  have hTranspose :
      metric * compound * metric = complement * compound * complement := by
    convert congr_arg Matrix.transpose hDerived using 1 <;>
      simp +decide [Matrix.mul_assoc]
    · rw [show metric.transpose = metric by
        ext row column
        fin_cases row <;> fin_cases column <;> rfl]
    · rw [show complement.transpose = complement by
        simp +zetaDelta at *
        unfold euclideanBivectorComplement
        norm_num [Matrix.transpose_mul]
        unfold hodgeBivectorMetric lorentzHodgeStar
        norm_num [Matrix.transpose]
        ext row column
        fin_cases row <;> fin_cases column <;>
          norm_num [Matrix.mul_apply, Fin.sum_univ_succ]]
  simp_all +decide [<- mul_assoc, <- hIdentities.2.2]
  replace hTranspose := congr_arg (fun matrix => matrix * metric) hTranspose
  simp_all +decide [Matrix.mul_assoc]
  simp_all +decide [<- Matrix.mul_assoc]

/-- The second-compound action of every proper eta-Lorentz matrix commutes
with the Lorentz Hodge star. Orientation-reversing Lorentz matrices are
excluded by the determinant hypothesis. -/
theorem wedgeTwoTransport_commutes_lorentzHodgeStar
    (L : Matrix (Fin 4) (Fin 4) Real) (hLorentz : IsEtaLorentz L)
    (hProper : L.det = 1) :
    wedgeTwoTransport L * lorentzHodgeStar =
      lorentzHodgeStar * wedgeTwoTransport L := by
  ext i j
  exact properLorentz_hodge_entry L hLorentz hProper i j

/-- The internal Hodge-dual coframe wedge transforms covariantly under every
proper eta-Lorentz coframe change. -/
theorem palatiniFaceWeight_mul
    (L coframe : Matrix (Fin 4) (Fin 4) Real)
    (hLorentz : IsEtaLorentz L) (hProper : L.det = 1) (a b : Fin 4) :
    palatiniFaceWeight (L * coframe) a b =
      transportApply (wedgeTwoTransport L)
        (palatiniFaceWeight coframe a b) := by
  unfold palatiniFaceWeight transportApply
  have hCommute :=
    wedgeTwoTransport_commutes_lorentzHodgeStar L hLorentz hProper
  convert congr_arg
      (fun matrix => fun i =>
        Finset.sum Finset.univ
          (fun j => matrix i j * coframeWedge coframe a b j))
      hCommute.symm using 1
  · ext i
    simp +decide [Matrix.mul_apply, Finset.sum_mul]
    ring
    rw [Finset.sum_comm]
    congr
    ext
    rw [coframeWedge_mul]
    simp +decide [mul_assoc]
    ring
    simp +decide [transportApply, Finset.mul_sum, mul_assoc]
  · simp +decide [Matrix.mul_apply, Finset.mul_sum]
    exact funext fun i => by
      rw [Finset.sum_comm]
      exact Finset.sum_congr rfl fun _ _ => by
        rw [Finset.sum_mul]
        exact Finset.sum_congr rfl fun _ _ => by ring

/-- Matrix transport commutes with scaling a finite fiber field. -/
theorem transportApply_scale
    (matrix : Matrix (Fin n) (Fin n) Real) (scalar : Real)
    (field : Fiber n) :
    transportApply matrix (fun component => scalar * field component) =
      fun component => scalar * transportApply matrix field component := by
  funext component
  unfold transportApply
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro fiberComponent _
  ring

/-- Expanded double-sum form of the complementary curvature-face weight. -/
theorem complementaryPalatiniFaceWeight_eq_double_sum
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    complementaryPalatiniFaceWeight coframe a b =
      fun component =>
        Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            ((1 / 2 : Real) * spacetimeAlternatingSymbol c d a b) *
              palatiniFaceWeight coframe c d component)) := by
  funext component
  unfold complementaryPalatiniFaceWeight
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro c _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro d _
  ring

/-- The complementary curvature-face coefficient transforms covariantly
under every proper eta-Lorentz coframe change. -/
theorem complementaryPalatiniFaceWeight_mul
    (L coframe : Matrix (Fin 4) (Fin 4) Real)
    (hLorentz : IsEtaLorentz L) (hProper : L.det = 1) (a b : Fin 4) :
    complementaryPalatiniFaceWeight (L * coframe) a b =
      transportApply (wedgeTwoTransport L)
        (complementaryPalatiniFaceWeight coframe a b) := by
  rw [complementaryPalatiniFaceWeight_eq_double_sum,
    complementaryPalatiniFaceWeight_eq_double_sum,
    transportApply_sum_fin4]
  funext component
  apply Finset.sum_congr rfl
  intro c _
  rw [transportApply_sum_fin4]
  apply Finset.sum_congr rfl
  intro d _
  rw [transportApply_scale,
    palatiniFaceWeight_mul L coframe hLorentz hProper]

/-- Matrix action commutes with pointwise negation. -/
theorem transportApply_neg
    (matrix : Matrix (Fin n) (Fin n) Real) (field : Fiber n) :
    transportApply matrix (fun component => -field component) =
      fun component => -transportApply matrix field component := by
  funext component
  unfold transportApply
  simp only [mul_neg, Finset.sum_neg_distrib]

/-- In Lorentzian four-space the Hodge star squares to minus the identity on
two-forms. -/
theorem lorentzHodgeStar_sq :
    lorentzHodgeStar * lorentzHodgeStar =
      -(1 : Matrix (Fin 6) (Fin 6) Real) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [lorentzHodgeStar, Matrix.mul_apply, Fin.sum_univ_six]

/-- In the project basis, Krein pairing after the Lorentz Hodge star is the
negative internal alternating contraction.  This pins the overall sign that
must be absorbed by the gravitational action convention when it is joined to
matter. -/
theorem kreinPair_lorentzHodgeStar
    (left right : Fiber 6) :
    kreinPair lorentzBivectorFundamentalSymmetry
        (transportApply lorentzHodgeStar left) right =
      -internalAlternatingBivectorPair left right := by
  unfold kreinPair
  rw [lorentzBivectorFundamentalSymmetry_matrix]
  simp [transportApply, fiberPair, lorentzHodgeStar, splitSixMatrix,
    splitSixSign, Fin.sum_univ_six, internalAlternatingBivectorPair]
  ring

/-- The coframe-pair building block therefore has the exact internal-epsilon
pairing, including the project-wide overall minus sign. -/
theorem kreinPair_palatiniFaceWeight
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4)
    (curvature : Fiber 6) :
    kreinPair lorentzBivectorFundamentalSymmetry
        (palatiniFaceWeight coframe a b) curvature =
      -internalAlternatingBivectorPair
        (coframeWedge coframe a b) curvature := by
  unfold palatiniFaceWeight
  exact kreinPair_lorentzHodgeStar _ _

/-- The coframe-derived Palatini face field is antisymmetric in its ordered
face directions. -/
theorem palatiniFaceWeight_swap
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    palatiniFaceWeight coframe b a =
      fun component => -palatiniFaceWeight coframe a b component := by
  unfold palatiniFaceWeight
  rw [coframeWedge_swap, transportApply_neg]

/-- Pointwise form of ordered antisymmetry for use under finite sums. -/
theorem palatiniFaceWeight_swap_apply
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4)
    (component : Fin 6) :
    palatiniFaceWeight coframe b a component =
      -palatiniFaceWeight coframe a b component := by
  exact congrFun (palatiniFaceWeight_swap coframe a b) component

/-- Reversing the curvature plaquette reverses its complementary Palatini
weight. -/
theorem complementaryPalatiniFaceWeight_swap
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    complementaryPalatiniFaceWeight coframe b a =
      fun component =>
        -complementaryPalatiniFaceWeight coframe a b component := by
  funext component
  unfold complementaryPalatiniFaceWeight
  have hSum :
      Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            spacetimeAlternatingSymbol c d b a *
              palatiniFaceWeight coframe c d component)) =
        -Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            spacetimeAlternatingSymbol c d a b *
              palatiniFaceWeight coframe c d component)) := by
    rw [← Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro c _
    rw [← Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro d _
    rw [spacetimeAlternatingSymbol_swap_last c d a b]
    ring
  rw [hSum]
  ring

/-- For the `01` curvature plaquette, the complementary coframe plane is
`23` with positive `0123` orientation. -/
theorem complementaryPalatiniFaceWeight_zero_one
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    complementaryPalatiniFaceWeight coframe 0 1 =
      palatiniFaceWeight coframe 2 3 := by
  funext component
  unfold complementaryPalatiniFaceWeight
  simp only [Fin.sum_univ_four]
  norm_num [spacetimeAlternatingSymbol]
  rw [palatiniFaceWeight_swap_apply coframe 2 3 component]
  ring

/-- For the `02` curvature plaquette, the complementary coframe plane is
`13` with negative `0123` orientation. -/
theorem complementaryPalatiniFaceWeight_zero_two
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    complementaryPalatiniFaceWeight coframe 0 2 =
      fun component => -palatiniFaceWeight coframe 1 3 component := by
  funext component
  unfold complementaryPalatiniFaceWeight
  simp only [Fin.sum_univ_four]
  norm_num [spacetimeAlternatingSymbol]
  rw [palatiniFaceWeight_swap_apply coframe 1 3 component]
  ring

/-- For the `03` curvature plaquette, the complementary coframe plane is
`12` with positive `0123` orientation. -/
theorem complementaryPalatiniFaceWeight_zero_three
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    complementaryPalatiniFaceWeight coframe 0 3 =
      palatiniFaceWeight coframe 1 2 := by
  funext component
  unfold complementaryPalatiniFaceWeight
  simp only [Fin.sum_univ_four]
  norm_num [spacetimeAlternatingSymbol]
  rw [palatiniFaceWeight_swap_apply coframe 1 2 component]
  ring

/-- For the `12` curvature plaquette, the complementary coframe plane is
`03` with positive `0123` orientation. -/
theorem complementaryPalatiniFaceWeight_one_two
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    complementaryPalatiniFaceWeight coframe 1 2 =
      palatiniFaceWeight coframe 0 3 := by
  funext component
  unfold complementaryPalatiniFaceWeight
  simp only [Fin.sum_univ_four]
  norm_num [spacetimeAlternatingSymbol]
  rw [palatiniFaceWeight_swap_apply coframe 0 3 component]
  ring

/-- For the `13` curvature plaquette, the complementary coframe plane is
`02` with negative `0123` orientation. -/
theorem complementaryPalatiniFaceWeight_one_three
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    complementaryPalatiniFaceWeight coframe 1 3 =
      fun component => -palatiniFaceWeight coframe 0 2 component := by
  funext component
  unfold complementaryPalatiniFaceWeight
  simp only [Fin.sum_univ_four]
  norm_num [spacetimeAlternatingSymbol]
  rw [palatiniFaceWeight_swap_apply coframe 0 2 component]
  ring

/-- For the `23` curvature plaquette, the complementary coframe plane is
`01` with positive `0123` orientation. -/
theorem complementaryPalatiniFaceWeight_two_three
    (coframe : Matrix (Fin 4) (Fin 4) Real) :
    complementaryPalatiniFaceWeight coframe 2 3 =
      palatiniFaceWeight coframe 0 1 := by
  funext component
  unfold complementaryPalatiniFaceWeight
  simp only [Fin.sum_univ_four]
  norm_num [spacetimeAlternatingSymbol]
  rw [palatiniFaceWeight_swap_apply coframe 0 1 component]
  ring

/-- Repeated face directions give the zero Palatini face field. -/
theorem palatiniFaceWeight_self
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a : Fin 4) :
    palatiniFaceWeight coframe a a = 0 := by
  funext component
  unfold palatiniFaceWeight transportApply coframeWedge
  simp

/-- Repeated curvature directions give zero complementary face weight. -/
theorem complementaryPalatiniFaceWeight_self
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a : Fin 4) :
    complementaryPalatiniFaceWeight coframe a a = 0 := by
  funext component
  unfold complementaryPalatiniFaceWeight spacetimeAlternatingSymbol
  simp

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace.lorentzHodgeStar_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lorentzHodgeStar_sq

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace.coframeWedge_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coframeWedge_mul

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace.wedgeTwoTransport_commutes_lorentzHodgeStar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wedgeTwoTransport_commutes_lorentzHodgeStar

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace.palatiniFaceWeight_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms palatiniFaceWeight_mul

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace.complementaryPalatiniFaceWeight_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms complementaryPalatiniFaceWeight_mul

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace.palatiniFaceWeight_swap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms palatiniFaceWeight_swap

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace.complementaryPalatiniFaceWeight_zero_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms complementaryPalatiniFaceWeight_zero_one

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace.complementaryPalatiniFaceWeight_swap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms complementaryPalatiniFaceWeight_swap

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace.kreinPair_palatiniFaceWeight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kreinPair_palatiniFaceWeight

end PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
