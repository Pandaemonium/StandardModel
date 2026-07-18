import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
import PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

noncomputable section

/-!
# Proper-Lorentz lift of the periodic vacuum-Weyl null wave

The additive two-site null wave has two internal null-rotation
polarizations.  Their Lorentz generators commute, so exponentiating the link
potential introduces no Baker-Campbell-Hausdorff correction.  Consequently
every exact group plaquette is the exponential of the corresponding additive
null-wave curl.

This module packages those links as a physical action-visible plaquette
refinement.  At every finite scale all links preserve the mostly-minus metric
and have determinant `+1`; in the shrinking-area limit the action-visible
curvature is exactly the nonzero periodic vacuum-Riemann target from
`PeriodicVacuumWeylNullWave`.

The exact trace extractor returns area times the additive curvature with no
higher-order correction.  Hence the identity coframe satisfies every finite
mixed vacuum Einstein equation and is exactly coframe-stationary.  One exact
link Euler coefficient is nevertheless `-2 * area`, proving that the same
static coframe fails connection and joint stationarity at nonzero area.  Thus
a varying coframe is required by the independent-connection sector.

This closes the proper-Lorentz realization and finite coframe-Einstein gates
for the target. It does not construct a jointly stationary varying coframe,
prove Levi-Civita selection, the orthochronous sign, or graph-derived
refinement.  Commuting exponentials are standard `[import]`; the null-wave
specialization, exact extraction, and sector audit are `[orig/comp]`.  Claim
labels: finite identity, finite no-go, and conditional asymptotic theorem.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift

open Filter Topology
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

/-! ## Abelian exponentiation of additive links -/

/-- Exponentials of commuting Lorentz generators turn fiber addition into
group multiplication. -/
theorem exponentialHolonomy_add_of_commute
    (area : Nat -> Real) (left right : Fiber 6) (n : Nat)
    (hCommute : Commute (lorentzGenerator left) (lorentzGenerator right)) :
    exponentialHolonomy area (left + right) n =
      exponentialHolonomy area left n * exponentialHolonomy area right n := by
  apply Units.ext
  change unitMatrix (exponentialHolonomy area (left + right) n) =
    unitMatrix
      (exponentialHolonomy area left n * exponentialHolonomy area right n)
  rw [unitMatrix_mul, exponentialHolonomy, exponentialHolonomy,
    exponentialHolonomy, unitMatrix_matrixExponentialUnit,
    unitMatrix_matrixExponentialUnit, unitMatrix_matrixExponentialUnit,
    lorentzGenerator_add, smul_add]
  exact Matrix.exp_add_of_commute _ _
    ((hCommute.smul_left (area n)).smul_right (area n))

/-- The analytic matrix exponential truncates to its finite Taylor sum when
the supplied matrix power vanishes. -/
theorem matrixExp_eq_sum_range_of_pow_eq_zero
    (matrix : Matrix (Fin 4) (Fin 4) Real) (order : Nat)
    (hPower : matrix ^ order = 0) :
    NormedSpace.exp matrix =
      Finset.sum (Finset.range order) (fun exponent =>
        ((exponent.factorial : Real)⁻¹) • matrix ^ exponent) := by
  rw [NormedSpace.exp_eq_tsum Real]
  apply tsum_eq_sum
  intro exponent hOutside
  have hLe : order <= exponent := by
    exact Nat.le_of_not_gt (fun hLt =>
      hOutside (Finset.mem_range.mpr hLt))
  rw [pow_eq_zero_of_le hLe hPower, smul_zero]

/-- Exponentiate every value of one additive six-component link field. -/
def exponentiatedAdditiveConnection
    {Site : Type*} (area : Nat -> Real) (variation : LinkVariation Site)
    (n : Nat) : LinkConnection Site GL4 :=
  fun site direction => exponentialHolonomy area (variation site direction) n

/-- If all additive link generators commute, exact group plaquettes are the
exponentials of their additive curls. -/
theorem plaquetteUnit_exponentiatedAdditiveConnection
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (area : Nat -> Real) (variation : LinkVariation Site) (n : Nat)
    (hCommute : forall leftSite leftDirection rightSite rightDirection,
      Commute
        (lorentzGenerator (variation leftSite leftDirection))
        (lorentzGenerator (variation rightSite rightDirection)))
    (site : Site) (a b : Fin 4) :
    plaquetteUnit shift
        (exponentiatedAdditiveConnection area variation n) site a b =
      exponentialHolonomy area
        (additivePlaquetteCurl shift variation site a b) n := by
  let leftFirst := variation site a
  let leftSecond := variation (shift a site) b
  let rightFirst := variation site b
  let rightSecond := variation (shift b site) a
  have hLeft : Commute
      (lorentzGenerator leftFirst) (lorentzGenerator leftSecond) :=
    hCommute site a (shift a site) b
  have hRight : Commute
      (lorentzGenerator rightFirst) (lorentzGenerator rightSecond) :=
    hCommute site b (shift b site) a
  have hCross : Commute
      (lorentzGenerator (leftFirst + leftSecond))
      (lorentzGenerator (-(rightFirst + rightSecond))) := by
    rw [lorentzGenerator_add, lorentzGenerator_neg, lorentzGenerator_add]
    exact (((hCommute site a site b).add_left
      (hCommute (shift a site) b site b)).add_right
        ((hCommute site a (shift b site) a).add_left
          (hCommute (shift a site) b (shift b site) a))).neg_right
  rw [show plaquetteUnit shift
        (exponentiatedAdditiveConnection area variation n) site a b =
      (exponentialHolonomy area leftFirst n *
          exponentialHolonomy area leftSecond n) *
        (exponentialHolonomy area rightFirst n *
          exponentialHolonomy area rightSecond n)⁻¹ by rfl]
  rw [<- exponentialHolonomy_add_of_commute area leftFirst leftSecond n hLeft,
    <- exponentialHolonomy_add_of_commute area rightFirst rightSecond n hRight,
    <- exponentialHolonomy_neg,
    <- exponentialHolonomy_add_of_commute area
      (leftFirst + leftSecond) (-(rightFirst + rightSecond)) n hCross]
  congr 1
  funext component
  simp [leftFirst, leftSecond, rightFirst, rightSecond,
    additivePlaquetteCurl]
  ring

/-! ## The null-wave commuting plane -/

/-- Linear combinations of the two null-wave polarization generators commute
pairwise. -/
theorem nullWavePolarizationPlane_commute
    (leftOne leftTwo rightOne rightTwo : Real) :
    Commute
      (lorentzGenerator
        (leftOne • nullWavePolarizationOne +
          leftTwo • nullWavePolarizationTwo))
      (lorentzGenerator
        (rightOne • nullWavePolarizationOne +
          rightTwo • nullWavePolarizationTwo)) := by
  show lorentzGenerator
        (leftOne • nullWavePolarizationOne +
          leftTwo • nullWavePolarizationTwo) *
      lorentzGenerator
        (rightOne • nullWavePolarizationOne +
          rightTwo • nullWavePolarizationTwo) =
    lorentzGenerator
        (rightOne • nullWavePolarizationOne +
          rightTwo • nullWavePolarizationTwo) *
      lorentzGenerator
        (leftOne • nullWavePolarizationOne +
          leftTwo • nullWavePolarizationTwo)
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [lorentzGenerator, bivectorMatrix, nullWavePolarizationOne,
      nullWavePolarizationTwo, MinkowskiConvention.eta, Matrix.mul_apply,
      Fin.sum_univ_four] <;>
    ring

/-- Every generator in the two-polarization null-wave plane is nilpotent of
order at most three. -/
theorem nullWavePolarizationPlane_generator_cube
    (coefficientOne coefficientTwo : Real) :
    lorentzGenerator
        (coefficientOne • nullWavePolarizationOne +
          coefficientTwo • nullWavePolarizationTwo) ^ 3 = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [pow_succ, lorentzGenerator, bivectorMatrix,
      nullWavePolarizationOne, nullWavePolarizationTwo,
      MinkowskiConvention.eta, Matrix.mul_apply, Fin.sum_univ_four]

set_option maxHeartbeats 3000000 in
/-- The Palatini trace extractor sees an exact linear null-wave coordinate:
the quadratic term in the nilpotent exponential is trace-orthogonal to every
Lorentz generator. -/
theorem orderedHolonomyCurvature_exponential_nullWavePlane
    (area : Nat -> Real) (n : Nat)
    (coefficientOne coefficientTwo : Real) :
    orderedHolonomyCurvature
        (exponentialHolonomy area
          (coefficientOne • nullWavePolarizationOne +
            coefficientTwo • nullWavePolarizationTwo) n) =
      area n •
        (coefficientOne • nullWavePolarizationOne +
          coefficientTwo • nullWavePolarizationTwo) := by
  let polarization : Fiber 6 :=
    coefficientOne • nullWavePolarizationOne +
      coefficientTwo • nullWavePolarizationTwo
  have hCube : (area n • lorentzGenerator polarization) ^ 3 = 0 := by
    rw [smul_pow, nullWavePolarizationPlane_generator_cube, smul_zero]
  have hExponential :
      unitMatrix (exponentialHolonomy area polarization n) =
        Finset.sum (Finset.range 3) (fun exponent =>
          ((exponent.factorial : Real)⁻¹) •
            (area n • lorentzGenerator polarization) ^ exponent) := by
    rw [exponentialHolonomy, unitMatrix_matrixExponentialUnit]
    exact matrixExp_eq_sum_range_of_pow_eq_zero _ 3 hCube
  funext component
  unfold orderedHolonomyCurvature orderedPlaquetteActionTerm
  rw [hExponential]
  fin_cases component <;>
    simp [bivectorCoordinateProbe, polarization,
      splitSixSign, lorentzGenerator, bivectorMatrix,
      nullWavePolarizationOne, nullWavePolarizationTwo,
      MinkowskiConvention.eta, Matrix.trace, Matrix.diag,
      Matrix.mul_apply, Fin.sum_univ_four] <;>
    simp +decide [Finset.sum_range_succ, pow_succ] <;>
    ring

/-- Explicit finite Taylor matrix for one null-wave-plane exponential. -/
def nullWavePlaneExponentialMatrix
    (scale coefficientOne coefficientTwo : Real) :
    Matrix (Fin 4) (Fin 4) Real :=
  Finset.sum (Finset.range 3) (fun exponent =>
    ((exponent.factorial : Real)⁻¹) •
      (scale • lorentzGenerator
        (coefficientOne • nullWavePolarizationOne +
          coefficientTwo • nullWavePolarizationTwo)) ^ exponent)

/-- Forgetting the unit structure of a null-wave-plane exponential gives its
explicit quadratic Taylor matrix. -/
theorem unitMatrix_exponentialHolonomy_nullWavePlane
    (area : Nat -> Real) (n : Nat)
    (coefficientOne coefficientTwo : Real) :
    unitMatrix
        (exponentialHolonomy area
          (coefficientOne • nullWavePolarizationOne +
            coefficientTwo • nullWavePolarizationTwo) n) =
      nullWavePlaneExponentialMatrix
        (area n) coefficientOne coefficientTwo := by
  rw [exponentialHolonomy, unitMatrix_matrixExponentialUnit]
  apply matrixExp_eq_sum_range_of_pow_eq_zero
  rw [smul_pow, nullWavePolarizationPlane_generator_cube, smul_zero]

/-- Inverting a null-wave-plane exponential negates its two coordinates. -/
theorem unitMatrix_inv_exponentialHolonomy_nullWavePlane
    (area : Nat -> Real) (n : Nat)
    (coefficientOne coefficientTwo : Real) :
    unitMatrix
        (exponentialHolonomy area
          (coefficientOne • nullWavePolarizationOne +
            coefficientTwo • nullWavePolarizationTwo) n)⁻¹ =
      nullWavePlaneExponentialMatrix
        (area n) (-coefficientOne) (-coefficientTwo) := by
  rw [<- exponentialHolonomy_neg]
  have hNeg :
      -(coefficientOne • nullWavePolarizationOne +
          coefficientTwo • nullWavePolarizationTwo) =
        (-coefficientOne) • nullWavePolarizationOne +
          (-coefficientTwo) • nullWavePolarizationTwo := by
    funext component
    simp
    ring
  rw [hNeg]
  exact unitMatrix_exponentialHolonomy_nullWavePlane
    area n (-coefficientOne) (-coefficientTwo)

/-- Multiplication of two null-wave-plane exponentials adds their two
coordinates exactly. -/
theorem exponentialHolonomy_nullWavePlane_mul
    (area : Nat -> Real) (n : Nat)
    (leftOne leftTwo rightOne rightTwo : Real) :
    exponentialHolonomy area
        (leftOne • nullWavePolarizationOne +
          leftTwo • nullWavePolarizationTwo) n *
      exponentialHolonomy area
        (rightOne • nullWavePolarizationOne +
          rightTwo • nullWavePolarizationTwo) n =
    exponentialHolonomy area
      ((leftOne + rightOne) • nullWavePolarizationOne +
        (leftTwo + rightTwo) • nullWavePolarizationTwo) n := by
  rw [<- exponentialHolonomy_add_of_commute area _ _ n
    (nullWavePolarizationPlane_commute _ _ _ _)]
  congr 1
  funext component
  simp
  ring

/-- Matrix of a pure first-polarization exponential. -/
@[simp]
theorem unitMatrix_exponentialHolonomy_smul_polarizationOne
    (area : Nat -> Real) (n : Nat) (coefficient : Real) :
    unitMatrix
        (exponentialHolonomy area
          (coefficient • nullWavePolarizationOne) n) =
      nullWavePlaneExponentialMatrix (area n) coefficient 0 := by
  simpa using unitMatrix_exponentialHolonomy_nullWavePlane
    area n coefficient 0

/-- Matrix inverse of a pure first-polarization exponential. -/
@[simp]
theorem unitMatrix_inv_exponentialHolonomy_smul_polarizationOne
    (area : Nat -> Real) (n : Nat) (coefficient : Real) :
    unitMatrix
        (exponentialHolonomy area
          (coefficient • nullWavePolarizationOne) n)⁻¹ =
      nullWavePlaneExponentialMatrix (area n) (-coefficient) 0 := by
  simpa using unitMatrix_inv_exponentialHolonomy_nullWavePlane
    area n coefficient 0

/-- Matrix of a pure second-polarization exponential. -/
@[simp]
theorem unitMatrix_exponentialHolonomy_smul_polarizationTwo
    (area : Nat -> Real) (n : Nat) (coefficient : Real) :
    unitMatrix
        (exponentialHolonomy area
          (coefficient • nullWavePolarizationTwo) n) =
      nullWavePlaneExponentialMatrix (area n) 0 coefficient := by
  simpa using unitMatrix_exponentialHolonomy_nullWavePlane
    area n 0 coefficient

/-- Matrix inverse of a pure second-polarization exponential. -/
@[simp]
theorem unitMatrix_inv_exponentialHolonomy_smul_polarizationTwo
    (area : Nat -> Real) (n : Nat) (coefficient : Real) :
    unitMatrix
        (exponentialHolonomy area
          (coefficient • nullWavePolarizationTwo) n)⁻¹ =
      nullWavePlaneExponentialMatrix (area n) 0 (-coefficient) := by
  simpa using unitMatrix_inv_exponentialHolonomy_nullWavePlane
    area n 0 coefficient

/-- Products within the first null polarization add their coefficients. -/
@[simp]
theorem exponentialHolonomy_smul_polarizationOne_mul
    (area : Nat -> Real) (n : Nat) (left right : Real) :
    exponentialHolonomy area (left • nullWavePolarizationOne) n *
        exponentialHolonomy area (right • nullWavePolarizationOne) n =
      exponentialHolonomy area
        ((left + right) • nullWavePolarizationOne) n := by
  simpa using exponentialHolonomy_nullWavePlane_mul
    area n left 0 right 0

/-- Products within the second null polarization add their coefficients. -/
@[simp]
theorem exponentialHolonomy_smul_polarizationTwo_mul
    (area : Nat -> Real) (n : Nat) (left right : Real) :
    exponentialHolonomy area (left • nullWavePolarizationTwo) n *
        exponentialHolonomy area (right • nullWavePolarizationTwo) n =
      exponentialHolonomy area
        ((left + right) • nullWavePolarizationTwo) n := by
  simpa using exponentialHolonomy_nullWavePlane_mul
    area n 0 left 0 right

/-- The two commuting polarization exponentials combine into one plane
exponential. -/
@[simp]
theorem exponentialHolonomy_polarizationOne_mul_polarizationTwo
    (area : Nat -> Real) (n : Nat) (first second : Real) :
    exponentialHolonomy area (first • nullWavePolarizationOne) n *
        exponentialHolonomy area (second • nullWavePolarizationTwo) n =
      exponentialHolonomy area
        (first • nullWavePolarizationOne +
          second • nullWavePolarizationTwo) n := by
  simpa using exponentialHolonomy_nullWavePlane_mul
    area n first 0 0 second

/-- Reversing the two commuting polarization factors gives the same plane
exponential. -/
@[simp]
theorem exponentialHolonomy_polarizationTwo_mul_polarizationOne
    (area : Nat -> Real) (n : Nat) (second first : Real) :
    exponentialHolonomy area (second • nullWavePolarizationTwo) n *
        exponentialHolonomy area (first • nullWavePolarizationOne) n =
      exponentialHolonomy area
        (first • nullWavePolarizationOne +
          second • nullWavePolarizationTwo) n := by
  simpa [add_comm] using exponentialHolonomy_nullWavePlane_mul
    area n 0 second first 0

/-- Matrix of the unit first-polarization exponential. -/
@[simp]
theorem unitMatrix_exponentialHolonomy_polarizationOne
    (area : Nat -> Real) (n : Nat) :
    unitMatrix (exponentialHolonomy area nullWavePolarizationOne n) =
      nullWavePlaneExponentialMatrix (area n) 1 0 := by
  simpa using unitMatrix_exponentialHolonomy_smul_polarizationOne
    area n 1

/-- Matrix inverse of the unit first-polarization exponential. -/
@[simp]
theorem unitMatrix_inv_exponentialHolonomy_polarizationOne
    (area : Nat -> Real) (n : Nat) :
    unitMatrix (exponentialHolonomy area nullWavePolarizationOne n)⁻¹ =
      nullWavePlaneExponentialMatrix (area n) (-1) 0 := by
  simpa using unitMatrix_inv_exponentialHolonomy_smul_polarizationOne
    area n 1

/-- Matrix of the unit second-polarization exponential. -/
@[simp]
theorem unitMatrix_exponentialHolonomy_polarizationTwo
    (area : Nat -> Real) (n : Nat) :
    unitMatrix (exponentialHolonomy area nullWavePolarizationTwo n) =
      nullWavePlaneExponentialMatrix (area n) 0 1 := by
  simpa using unitMatrix_exponentialHolonomy_smul_polarizationTwo
    area n 1

/-- Matrix inverse of the unit second-polarization exponential. -/
@[simp]
theorem unitMatrix_inv_exponentialHolonomy_polarizationTwo
    (area : Nat -> Real) (n : Nat) :
    unitMatrix (exponentialHolonomy area nullWavePolarizationTwo n)⁻¹ =
      nullWavePlaneExponentialMatrix (area n) 0 (-1) := by
  simpa using unitMatrix_inv_exponentialHolonomy_smul_polarizationTwo
    area n 1

/-- Product of the two displayed unit polarization exponentials. -/
@[simp]
theorem exponentialHolonomy_polarizationOne_mul_polarizationTwo_unit
    (area : Nat -> Real) (n : Nat) :
    exponentialHolonomy area nullWavePolarizationOne n *
        exponentialHolonomy area nullWavePolarizationTwo n =
      exponentialHolonomy area
        (nullWavePolarizationOne + nullWavePolarizationTwo) n := by
  simpa using exponentialHolonomy_polarizationOne_mul_polarizationTwo
    area n 1 1

/-- Reverse product of the displayed unit polarization exponentials. -/
@[simp]
theorem exponentialHolonomy_polarizationTwo_mul_polarizationOne_unit
    (area : Nat -> Real) (n : Nat) :
    exponentialHolonomy area nullWavePolarizationTwo n *
        exponentialHolonomy area nullWavePolarizationOne n =
      exponentialHolonomy area
        (nullWavePolarizationOne + nullWavePolarizationTwo) n := by
  simpa using exponentialHolonomy_polarizationTwo_mul_polarizationOne
    area n 1 1

/-- Squaring the first unit polarization exponential doubles its coordinate.
-/
@[simp]
theorem exponentialHolonomy_polarizationOne_sq
    (area : Nat -> Real) (n : Nat) :
    exponentialHolonomy area nullWavePolarizationOne n *
        exponentialHolonomy area nullWavePolarizationOne n =
      exponentialHolonomy area
        ((2 : Real) • nullWavePolarizationOne) n := by
  convert exponentialHolonomy_smul_polarizationOne_mul area n 1 1 using 1 <;>
    norm_num

/-- Squaring the second unit polarization exponential doubles its coordinate.
-/
@[simp]
theorem exponentialHolonomy_polarizationTwo_sq
    (area : Nat -> Real) (n : Nat) :
    exponentialHolonomy area nullWavePolarizationTwo n *
        exponentialHolonomy area nullWavePolarizationTwo n =
      exponentialHolonomy area
        ((2 : Real) • nullWavePolarizationTwo) n := by
  convert exponentialHolonomy_smul_polarizationTwo_mul area n 1 1 using 1 <;>
    norm_num

/-- Matrix of the sum-polarization exponential. -/
@[simp]
theorem unitMatrix_exponentialHolonomy_polarizationSum
    (area : Nat -> Real) (n : Nat) :
    unitMatrix (exponentialHolonomy area
        (nullWavePolarizationOne + nullWavePolarizationTwo) n) =
      nullWavePlaneExponentialMatrix (area n) 1 1 := by
  simpa using unitMatrix_exponentialHolonomy_nullWavePlane area n 1 1

/-- Matrix inverse of the sum-polarization exponential. -/
@[simp]
theorem unitMatrix_inv_exponentialHolonomy_polarizationSum
    (area : Nat -> Real) (n : Nat) :
    unitMatrix (exponentialHolonomy area
        (nullWavePolarizationOne + nullWavePolarizationTwo) n)⁻¹ =
      nullWavePlaneExponentialMatrix (area n) (-1) (-1) := by
  simpa using unitMatrix_inv_exponentialHolonomy_nullWavePlane area n 1 1

/-- Coefficient of the first null rotation in one displayed link. -/
def nullWaveLinkCoefficientOne
    (site : NullWaveSite) (direction : Fin 4) : Real :=
  if direction = 1 then nullWavePotential site else 0

/-- Coefficient of the second null rotation in one displayed link. -/
def nullWaveLinkCoefficientTwo
    (site : NullWaveSite) (direction : Fin 4) : Real :=
  if direction = 2 then nullWavePotential site else 0

/-- Every null-wave additive link lies in the commuting polarization plane.
-/
theorem nullWaveLinkVariation_decompose
    (site : NullWaveSite) (direction : Fin 4) :
    nullWaveLinkVariation site direction =
      nullWaveLinkCoefficientOne site direction • nullWavePolarizationOne +
        nullWaveLinkCoefficientTwo site direction •
          nullWavePolarizationTwo := by
  funext component
  fin_cases direction <;>
    simp [nullWaveLinkVariation, nullWaveLinkCoefficientOne,
      nullWaveLinkCoefficientTwo]

/-- All Lorentz generators appearing in the null-wave link potential commute.
-/
theorem nullWaveLinkGenerators_commute
    (leftSite : NullWaveSite) (leftDirection : Fin 4)
    (rightSite : NullWaveSite) (rightDirection : Fin 4) :
    Commute
      (lorentzGenerator (nullWaveLinkVariation leftSite leftDirection))
      (lorentzGenerator (nullWaveLinkVariation rightSite rightDirection)) := by
  rw [nullWaveLinkVariation_decompose,
    nullWaveLinkVariation_decompose]
  exact nullWavePolarizationPlane_commute _ _ _ _

/-! ## Exact proper-Lorentz null-wave refinement -/

/-- Exponentiated proper-Lorentz link field for the two-site null wave. -/
def nullWaveLorentzConnection
    (area : Nat -> Real) (n : Nat) : LinkConnection NullWaveSite GL4 :=
  exponentiatedAdditiveConnection area nullWaveLinkVariation n

/-- Matrix of any exact null-wave link in the common commuting polarization
plane. -/
theorem unitMatrix_nullWaveLorentzConnection
    (area : Nat -> Real) (n : Nat) (site : NullWaveSite)
    (direction : Fin 4) :
    unitMatrix (nullWaveLorentzConnection area n site direction) =
      nullWavePlaneExponentialMatrix (area n)
        (nullWaveLinkCoefficientOne site direction)
        (nullWaveLinkCoefficientTwo site direction) := by
  unfold nullWaveLorentzConnection exponentiatedAdditiveConnection
  rw [nullWaveLinkVariation_decompose]
  exact unitMatrix_exponentialHolonomy_nullWavePlane area n _ _

/-- Matrix inverse of any exact null-wave link, obtained by negating its two
commuting polarization coordinates. -/
theorem unitMatrix_inv_nullWaveLorentzConnection
    (area : Nat -> Real) (n : Nat) (site : NullWaveSite)
    (direction : Fin 4) :
    unitMatrix (nullWaveLorentzConnection area n site direction)⁻¹ =
      nullWavePlaneExponentialMatrix (area n)
        (-nullWaveLinkCoefficientOne site direction)
        (-nullWaveLinkCoefficientTwo site direction) := by
  unfold nullWaveLorentzConnection exponentiatedAdditiveConnection
  rw [nullWaveLinkVariation_decompose]
  exact unitMatrix_inv_exponentialHolonomy_nullWavePlane area n _ _

/-- All links based at the zero-potential site are identities. -/
@[simp]
theorem nullWaveLorentzConnection_zeroSite
    (area : Nat -> Real) (n : Nat) (direction : Fin 4) :
    nullWaveLorentzConnection area n 0 direction = 1 := by
  fin_cases direction <;>
    simp [nullWaveLorentzConnection, exponentiatedAdditiveConnection,
      nullWaveLinkVariation, nullWavePotential, exponentialHolonomy_zero]

/-- The inactive time link at the unit-potential site is the identity. -/
@[simp]
theorem nullWaveLorentzConnection_oneSite_zero
    (area : Nat -> Real) (n : Nat) :
    nullWaveLorentzConnection area n 1 0 = 1 := by
  simp [nullWaveLorentzConnection, exponentiatedAdditiveConnection,
    nullWaveLinkVariation, exponentialHolonomy_zero]

/-- The first transverse link at the unit-potential site. -/
@[simp]
theorem nullWaveLorentzConnection_oneSite_one
    (area : Nat -> Real) (n : Nat) :
    nullWaveLorentzConnection area n 1 1 =
      exponentialHolonomy area nullWavePolarizationOne n := by
  simp [nullWaveLorentzConnection, exponentiatedAdditiveConnection,
    nullWaveLinkVariation, nullWavePotential]

/-- The second transverse link at the unit-potential site. -/
@[simp]
theorem nullWaveLorentzConnection_oneSite_two
    (area : Nat -> Real) (n : Nat) :
    nullWaveLorentzConnection area n 1 2 =
      exponentialHolonomy area nullWavePolarizationTwo n := by
  simp [nullWaveLorentzConnection, exponentiatedAdditiveConnection,
    nullWaveLinkVariation, nullWavePotential]

/-- The inactive longitudinal link at the unit-potential site is identity. -/
@[simp]
theorem nullWaveLorentzConnection_oneSite_three
    (area : Nat -> Real) (n : Nat) :
    nullWaveLorentzConnection area n 1 3 = 1 := by
  simp [nullWaveLorentzConnection, exponentiatedAdditiveConnection,
    nullWaveLinkVariation, exponentialHolonomy_zero]

/-- The displayed additive potential has exactly the null-wave curvature as
its curl. -/
theorem additivePlaquetteCurl_nullWaveLinkVariation
    (site : NullWaveSite) (a b : Fin 4) :
    additivePlaquetteCurl nullWaveShift nullWaveLinkVariation site a b =
      nullWaveCurvature site a b := by
  funext component
  fin_cases site <;> fin_cases a <;> fin_cases b <;>
    simp [additivePlaquetteCurl, nullWaveShift, nullWaveLinkVariation,
      nullWaveCurvature, nullWaveAmplitude, nullWaveFaceOne,
      nullWaveFaceTwo, nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo, toggleFinTwo]

/-- Every exact null-wave plaquette is the exponential of its signed
vacuum-Weyl curvature. -/
theorem nullWavePlaquetteUnit_eq_exponential
    (area : Nat -> Real) (n : Nat) (site : NullWaveSite) (a b : Fin 4) :
    plaquetteUnit nullWaveShift (nullWaveLorentzConnection area n)
        site a b =
      exponentialHolonomy area (nullWaveCurvature site a b) n := by
  rw [nullWaveLorentzConnection,
    plaquetteUnit_exponentiatedAdditiveConnection nullWaveShift area
      nullWaveLinkVariation n nullWaveLinkGenerators_commute]
  congr 1
  exact additivePlaquetteCurl_nullWaveLinkVariation site a b

/-- Every null-wave face lies in the commuting two-polarization plane. -/
theorem nullWaveCurvature_decompose
    (site : NullWaveSite) (a b : Fin 4) :
    nullWaveCurvature site a b =
      (nullWaveAmplitude site * nullWaveFaceOne a b) •
          nullWavePolarizationOne +
        (nullWaveAmplitude site * nullWaveFaceTwo a b) •
          nullWavePolarizationTwo := by
  funext component
  simp [nullWaveCurvature]
  ring

/-- Matrix of any exact null-wave plaquette in the common polarization
plane. -/
theorem unitMatrix_nullWavePlaquetteUnit
    (area : Nat -> Real) (n : Nat) (site : NullWaveSite) (a b : Fin 4) :
    unitMatrix (plaquetteUnit nullWaveShift
        (nullWaveLorentzConnection area n) site a b) =
      nullWavePlaneExponentialMatrix (area n)
        (nullWaveAmplitude site * nullWaveFaceOne a b)
        (nullWaveAmplitude site * nullWaveFaceTwo a b) := by
  rw [nullWavePlaquetteUnit_eq_exponential,
    nullWaveCurvature_decompose]
  exact unitMatrix_exponentialHolonomy_nullWavePlane area n _ _

/-- Matrix inverse of any exact null-wave plaquette. -/
theorem unitMatrix_inv_nullWavePlaquetteUnit
    (area : Nat -> Real) (n : Nat) (site : NullWaveSite) (a b : Fin 4) :
    unitMatrix (plaquetteUnit nullWaveShift
        (nullWaveLorentzConnection area n) site a b)⁻¹ =
      nullWavePlaneExponentialMatrix (area n)
        (-(nullWaveAmplitude site * nullWaveFaceOne a b))
        (-(nullWaveAmplitude site * nullWaveFaceTwo a b)) := by
  rw [nullWavePlaquetteUnit_eq_exponential,
    nullWaveCurvature_decompose]
  exact unitMatrix_inv_exponentialHolonomy_nullWavePlane area n _ _

/-- The raw trace-extracted curvature of each exact plaquette is exactly area
times the additive null-wave curvature, with no higher-order correction. -/
theorem rawPlaquetteCurvature_nullWaveLorentzConnection
    (area : Nat -> Real) (n : Nat) (site : NullWaveSite) (a b : Fin 4) :
    rawPlaquetteCurvature nullWaveShift
        (nullWaveLorentzConnection area n) site a b =
      area n • nullWaveCurvature site a b := by
  unfold rawPlaquetteCurvature
  rw [nullWavePlaquetteUnit_eq_exponential,
    nullWaveCurvature_decompose]
  exact orderedHolonomyCurvature_exponential_nullWavePlane area n _ _

/-- Antisymmetrization leaves the exact area-scaled null-wave field unchanged.
-/
theorem extractedPlaquetteCurvature_nullWaveLorentzConnection
    (area : Nat -> Real) (n : Nat) (site : NullWaveSite) (a b : Fin 4) :
    extractedPlaquetteCurvature nullWaveShift
        (nullWaveLorentzConnection area n) site a b =
      area n • nullWaveCurvature site a b := by
  funext component
  unfold extractedPlaquetteCurvature antisymmetrizeFaceWeight
  rw [rawPlaquetteCurvature_nullWaveLorentzConnection,
    rawPlaquetteCurvature_nullWaveLorentzConnection]
  change (1 / 2 : Real) *
      (area n * nullWaveCurvature site a b component -
        area n * nullWaveCurvature site b a component) =
    area n * nullWaveCurvature site a b component
  rw [nullWaveCurvature_antisymmetric site a b component]
  ring

/-- The exact finite extracted curvature satisfies every identity-coframe
mixed vacuum Einstein equation, not only its shrinking-area limit. -/
theorem nullWaveLorentzConnection_mixedVacuum
    (area : Nat -> Real) (n : Nat) (site : NullWaveSite)
    (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry (1 : Matrix (Fin 4) (Fin 4) Real)
        (extractedPlaquetteCurvature nullWaveShift
          (nullWaveLorentzConnection area n) site)
        coframeDirection raisedDirection = 0 := by
  rw [show extractedPlaquetteCurvature nullWaveShift
      (nullWaveLorentzConnection area n) site =
        area n • nullWaveCurvature site by
    funext a b component
    exact congrFun
      (extractedPlaquetteCurvature_nullWaveLorentzConnection
        area n site a b) component]
  change mixedVacuumEinsteinEntryLinear
      (1 : Matrix (Fin 4) (Fin 4) Real)
      coframeDirection raisedDirection
      (area n • nullWaveCurvature site) = 0
  rw [map_smul]
  change area n * mixedVacuumEinsteinEntry
      (1 : Matrix (Fin 4) (Fin 4) Real)
      (nullWaveCurvature site) coframeDirection raisedDirection = 0
  rw [nullWaveCurvature_mixedVacuum]
  ring

/-- The identity coframe is an exact finite stationary point of the coframe
sector for every scale of the proper-Lorentz null-wave connection. -/
theorem nullWaveLorentzConnection_identityCoframeStationary
    (area : Nat -> Real) (n : Nat) :
    NonlinearCoframePlaquetteCoframeStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (identityCoframeField NullWaveSite) := by
  apply (nonlinearCoframePlaquetteCoframeStationary_iff_mixedEinstein
    nullWaveShift (nullWaveLorentzConnection area n)
    (identityCoframeField NullWaveSite)
    (identityCoframeField NullWaveSite) (by
      intro site
      simp [identityCoframeField])).2
  intro site coframeDirection raisedDirection
  change mixedVacuumEinsteinEntry
      (1 : Matrix (Fin 4) (Fin 4) Real)
      (extractedPlaquetteCurvature nullWaveShift
        (nullWaveLorentzConnection area n) site)
      coframeDirection raisedDirection = 0
  exact nullWaveLorentzConnection_mixedVacuum
    area n site coframeDirection raisedDirection

/-- The component-`1` infinitesimal probe used to audit the direction-`1`
null-wave link equation at the negative-amplitude site. -/
def nullWaveEulerProbe : Fiber 6 := Pi.single 1 (1 : Real)

/-- First of the four native transport sums in the audited link Euler
coefficient. -/
def nullWaveIdentityEulerFirstBranch
    (area : Nat -> Real) (n : Nat) : Real :=
  Finset.sum Finset.univ (fun b =>
    nonlinearWeightedAdjointFaceResponse
      (coframeFaceWeight (identityCoframeField NullWaveSite) 1 1 b)
      (nullWaveLorentzConnection area n 1 1) nullWaveEulerProbe
      (plaquetteUnit nullWaveShift
        (nullWaveLorentzConnection area n) 1 1 b))

/-- Second of the four native transport sums in the audited link Euler
coefficient. -/
def nullWaveIdentityEulerSecondBranch
    (area : Nat -> Real) (n : Nat) : Real :=
  Finset.sum Finset.univ (fun a =>
    let predecessor := (nullWaveShift a).symm 1
    nonlinearWeightedAdjointFaceResponse
      (coframeFaceWeight (identityCoframeField NullWaveSite)
        predecessor a 1)
      (twoStepUnit nullWaveShift (nullWaveLorentzConnection area n)
        predecessor a 1) nullWaveEulerProbe
      (plaquetteUnit nullWaveShift (nullWaveLorentzConnection area n)
        predecessor a 1))

/-- Third of the four native transport sums in the audited link Euler
coefficient. -/
def nullWaveIdentityEulerThirdBranch
    (area : Nat -> Real) (n : Nat) : Real :=
  Finset.sum Finset.univ (fun a =>
    let holonomy := plaquetteUnit nullWaveShift
      (nullWaveLorentzConnection area n) 1 a 1
    nonlinearWeightedAdjointFaceResponse
      (coframeFaceWeight (identityCoframeField NullWaveSite) 1 a 1)
      (holonomy * nullWaveLorentzConnection area n 1 1)
      nullWaveEulerProbe holonomy)

/-- Fourth of the four native transport sums in the audited link Euler
coefficient. -/
def nullWaveIdentityEulerFourthBranch
    (area : Nat -> Real) (n : Nat) : Real :=
  Finset.sum Finset.univ (fun b =>
    let predecessor := (nullWaveShift b).symm 1
    nonlinearWeightedAdjointFaceResponse
      (coframeFaceWeight (identityCoframeField NullWaveSite)
        predecessor 1 b)
      (twoStepUnit nullWaveShift (nullWaveLorentzConnection area n)
        predecessor 1 b) nullWaveEulerProbe
      (plaquetteUnit nullWaveShift (nullWaveLorentzConnection area n)
        predecessor 1 b))

set_option maxHeartbeats 3000000 in
private theorem nullWaveIdentityEulerFirstBranch_eq
    (area : Nat -> Real) (n : Nat) :
    nullWaveIdentityEulerFirstBranch area n = -1 := by
  simp only [nullWaveIdentityEulerFirstBranch, Fin.sum_univ_four,
    nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint]
  simp only [unitMatrix_nullWaveLorentzConnection,
    unitMatrix_inv_nullWaveLorentzConnection,
    unitMatrix_nullWavePlaquetteUnit]
  simp +decide [nullWaveEulerProbe, identityCoframeField,
    coframeFaceWeight, complementaryPalatiniFaceWeight,
    palatiniFaceWeight, coframeWedge, spacetimeAlternatingSymbol,
    lorentzHodgeStar, transportApply, lorentzGenerator, bivectorMatrix,
    nullWaveLinkCoefficientOne, nullWaveLinkCoefficientTwo,
    nullWaveAmplitude, nullWaveFaceOne, nullWaveFaceTwo,
    nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo, nullWavePlaneExponentialMatrix,
    LorentzBivectorKreinBridge.bivectorFirst,
    LorentzBivectorKreinBridge.bivectorSecond,
    MinkowskiConvention.eta, Matrix.trace, Matrix.diag,
    Matrix.mul_apply, Matrix.of_apply, Matrix.one_apply,
    Fin.sum_univ_four, Fin.sum_univ_six,
    Finset.sum_range_succ, pow_succ]
  norm_num
  ring

set_option maxHeartbeats 3000000 in
private theorem nullWaveIdentityEulerSecondBranch_eq
    (area : Nat -> Real) (n : Nat) :
    nullWaveIdentityEulerSecondBranch area n = 1 - area n := by
  simp only [nullWaveIdentityEulerSecondBranch, Fin.sum_univ_four,
    nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint,
    twoStepUnit, twoStepTransport, unitMatrix_mul, mul_inv_rev]
  simp only [unitMatrix_nullWaveLorentzConnection,
    unitMatrix_inv_nullWaveLorentzConnection,
    unitMatrix_nullWavePlaquetteUnit]
  simp +decide [nullWaveEulerProbe, identityCoframeField,
    coframeFaceWeight, complementaryPalatiniFaceWeight,
    palatiniFaceWeight, coframeWedge, spacetimeAlternatingSymbol,
    lorentzHodgeStar, transportApply, lorentzGenerator, bivectorMatrix,
    nullWaveLinkCoefficientOne, nullWaveLinkCoefficientTwo,
    nullWaveAmplitude, nullWaveFaceOne, nullWaveFaceTwo,
    nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo, nullWavePlaneExponentialMatrix,
    LorentzBivectorKreinBridge.bivectorFirst,
    LorentzBivectorKreinBridge.bivectorSecond,
    MinkowskiConvention.eta, Matrix.trace, Matrix.diag,
    Matrix.mul_apply, Matrix.of_apply, Matrix.one_apply,
    Fin.sum_univ_four,
    Fin.sum_univ_six, Finset.sum_range_succ, pow_succ]
  norm_num
  ring

set_option maxHeartbeats 3000000 in
private theorem nullWaveIdentityEulerThirdBranch_eq
    (area : Nat -> Real) (n : Nat) :
    nullWaveIdentityEulerThirdBranch area n = 1 := by
  simp only [nullWaveIdentityEulerThirdBranch, Fin.sum_univ_four,
    nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint,
    unitMatrix_mul, mul_inv_rev]
  simp only [unitMatrix_nullWaveLorentzConnection,
    unitMatrix_inv_nullWaveLorentzConnection,
    unitMatrix_nullWavePlaquetteUnit,
    unitMatrix_inv_nullWavePlaquetteUnit]
  simp +decide [nullWaveEulerProbe, identityCoframeField,
    coframeFaceWeight, complementaryPalatiniFaceWeight,
    palatiniFaceWeight, coframeWedge, spacetimeAlternatingSymbol,
    lorentzHodgeStar, transportApply, lorentzGenerator, bivectorMatrix,
    nullWaveLinkCoefficientOne, nullWaveLinkCoefficientTwo,
    nullWaveAmplitude, nullWaveFaceOne,
    nullWaveFaceTwo, nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo, nullWavePlaneExponentialMatrix,
    LorentzBivectorKreinBridge.bivectorFirst,
    LorentzBivectorKreinBridge.bivectorSecond,
    MinkowskiConvention.eta, Matrix.trace, Matrix.diag,
    Matrix.mul_apply, Matrix.of_apply, Matrix.one_apply,
    Fin.sum_univ_four,
    Fin.sum_univ_six, Finset.sum_range_succ, pow_succ]
  norm_num
  ring

set_option maxHeartbeats 3000000 in
private theorem nullWaveIdentityEulerFourthBranch_eq
    (area : Nat -> Real) (n : Nat) :
    nullWaveIdentityEulerFourthBranch area n = area n - 1 := by
  simp only [nullWaveIdentityEulerFourthBranch, Fin.sum_univ_four,
    nonlinearWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint,
    twoStepUnit, twoStepTransport, unitMatrix_mul, mul_inv_rev]
  simp only [unitMatrix_nullWaveLorentzConnection,
    unitMatrix_inv_nullWaveLorentzConnection,
    unitMatrix_nullWavePlaquetteUnit]
  simp +decide [nullWaveEulerProbe, identityCoframeField,
    coframeFaceWeight, complementaryPalatiniFaceWeight,
    palatiniFaceWeight, coframeWedge, spacetimeAlternatingSymbol,
    lorentzHodgeStar, transportApply, lorentzGenerator, bivectorMatrix,
    nullWaveLinkCoefficientOne, nullWaveLinkCoefficientTwo,
    nullWaveAmplitude, nullWaveFaceOne, nullWaveFaceTwo,
    nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo, nullWavePlaneExponentialMatrix,
    LorentzBivectorKreinBridge.bivectorFirst,
    LorentzBivectorKreinBridge.bivectorSecond,
    MinkowskiConvention.eta, Matrix.trace, Matrix.diag,
    Matrix.mul_apply, Matrix.of_apply, Matrix.one_apply,
    Fin.sum_univ_four,
    Fin.sum_univ_six, Finset.sum_range_succ, pow_succ]
  norm_num
  ring

/-- One exact link Euler coefficient exposes the failure of the static
identity coframe in the independent-connection sector. -/
theorem nullWave_identityCoframe_linkEulerCoefficient
    (area : Nat -> Real) (n : Nat) :
    nonlinearLinkEulerCoefficient nullWaveShift
        (nullWaveLorentzConnection area n)
        (identityCoframeField NullWaveSite) 1 1 1 =
      -2 * area n := by
  change nullWaveIdentityEulerFirstBranch area n +
      nullWaveIdentityEulerSecondBranch area n -
      nullWaveIdentityEulerThirdBranch area n -
      nullWaveIdentityEulerFourthBranch area n = -2 * area n
  rw [nullWaveIdentityEulerFirstBranch_eq,
    nullWaveIdentityEulerSecondBranch_eq,
    nullWaveIdentityEulerThirdBranch_eq,
    nullWaveIdentityEulerFourthBranch_eq]
  ring

/-- At nonzero area, the identity coframe fails the independent-connection
stationarity condition for the exact null-wave links. -/
theorem nullWaveLorentzConnection_identityCoframe_not_connectionStationary
    (area : Nat -> Real) (n : Nat) (hArea : Not (area n = 0)) :
    Not (NonlinearCoframePlaquetteConnectionStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (identityCoframeField NullWaveSite)) := by
  intro hStationary
  have hCoefficient :=
    (nonlinearCoframePlaquetteConnectionStationary_iff_coefficients
      nullWaveShift (nullWaveLorentzConnection area n)
      (identityCoframeField NullWaveSite)).1 hStationary 1 1 1
  rw [nullWave_identityCoframe_linkEulerCoefficient] at hCoefficient
  apply hArea
  linarith

/-- The proper null-wave lift exactly satisfies the finite vacuum Einstein
sector at identity coframe while failing the independent-connection sector
at every nonzero area. -/
theorem nullWaveLorentzConnection_identityCoframe_sectorSplit
    (area : Nat -> Real) (n : Nat) (hArea : Not (area n = 0)) :
    NonlinearCoframePlaquetteCoframeStationary nullWaveShift
        (nullWaveLorentzConnection area n)
        (identityCoframeField NullWaveSite) /\
      Not (NonlinearCoframePlaquetteConnectionStationary nullWaveShift
        (nullWaveLorentzConnection area n)
        (identityCoframeField NullWaveSite)) := by
  exact And.intro
    (nullWaveLorentzConnection_identityCoframeStationary area n)
    (nullWaveLorentzConnection_identityCoframe_not_connectionStationary
      area n hArea)

/-- Consequently, the identity coframe and nonzero-area null-wave connection
are not jointly stationary for the finite Palatini action. -/
theorem nullWaveLorentzConnection_identityCoframe_not_jointStationary
    (area : Nat -> Real) (n : Nat) (hArea : Not (area n = 0)) :
    Not (NonlinearCoframePlaquetteJointStationary nullWaveShift
      (nullWaveLorentzConnection area n)
      (identityCoframeField NullWaveSite)) := by
  intro hJoint
  exact
    (nullWaveLorentzConnection_identityCoframe_not_connectionStationary
      area n hArea) hJoint.1

/-- Every finite null-wave link preserves eta and has determinant `+1`. -/
theorem nullWaveLorentzConnection_isProperEtaLorentz
    (area : Nat -> Real) (n : Nat) (site : NullWaveSite)
    (direction : Fin 4) :
    IsEtaLorentz
        (unitMatrix (nullWaveLorentzConnection area n site direction)) /\
      IsProperLorentz
        (unitMatrix (nullWaveLorentzConnection area n site direction)) := by
  exact exponentialHolonomy_isProperEtaLorentz area
    (nullWaveLinkVariation site direction) n

/-- The exact proper-Lorentz links form an action-visible refinement of the
periodic null-wave vacuum-Riemann target. -/
def physicalNullWavePlaquetteRefinement
    (area : Nat -> Real)
    (hAreaNe : Filter.Eventually (fun n => Not (area n = 0)) atTop)
    (hAreaZero : Tendsto area atTop (nhds 0)) :
    PhysicalActionVisiblePlaquetteRefinement nullWaveShift
      (nullWaveLorentzConnection area) area nullWaveCurvature where
  shifts_commute := nullWaveShift_commute
  firstOrder := by
    intro site a b
    simpa only [nullWavePlaquetteUnit_eq_exponential] using
      exponentialActionVisibleFirstOrderHolonomyLimit area
        (nullWaveCurvature site a b) hAreaNe hAreaZero
  target_antisymmetric := by
    intro site a b component
    exact nullWaveCurvature_antisymmetric site b a component
  link_eta := fun n site direction =>
    (nullWaveLorentzConnection_isProperEtaLorentz
      area n site direction).1
  link_proper := fun n site direction =>
    (nullWaveLorentzConnection_isProperEtaLorentz
      area n site direction).2

/-- The complete periodic null-wave face field is nonzero. -/
theorem nullWaveCurvatureField_ne_zero : Not (nullWaveCurvature = 0) := by
  intro hZero
  exact nullWaveCurvature_ne_zero 0 (congrFun hZero 0)

/-- **Nonflat physical null-wave refinement witness.** The nonzero periodic
vacuum-Riemann target is carried by exact proper eta-Lorentz link and
plaquette holonomies. -/
theorem nonzero_physicalNullWavePlaquetteRefinement :
    And (Not (nullWaveCurvature = 0))
      (Nonempty (PhysicalActionVisiblePlaquetteRefinement nullWaveShift
        (nullWaveLorentzConnection witnessArea) witnessArea
        nullWaveCurvature)) := by
  refine And.intro nullWaveCurvatureField_ne_zero ?_
  exact Nonempty.intro
    (physicalNullWavePlaquetteRefinement witnessArea
      witnessFirstOrderHolonomyLimit.area_ne_zero
      witnessFirstOrderHolonomyLimit.area_tendsto_zero)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift.nullWavePlaquetteUnit_eq_exponential' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWavePlaquetteUnit_eq_exponential

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift.extractedPlaquetteCurvature_nullWaveLorentzConnection' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms extractedPlaquetteCurvature_nullWaveLorentzConnection

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift.nullWaveLorentzConnection_identityCoframeStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveLorentzConnection_identityCoframeStationary

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift.nullWave_identityCoframe_linkEulerCoefficient' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWave_identityCoframe_linkEulerCoefficient

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift.nullWaveLorentzConnection_identityCoframe_sectorSplit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveLorentzConnection_identityCoframe_sectorSplit

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift.physicalNullWavePlaquetteRefinement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physicalNullWavePlaquetteRefinement

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift.nonzero_physicalNullWavePlaquetteRefinement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonzero_physicalNullWavePlaquetteRefinement

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveProperLift
