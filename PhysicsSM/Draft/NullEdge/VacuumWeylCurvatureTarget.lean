import PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteEinsteinAudit

noncomputable section

/-!
# A nonzero algebraic vacuum-Weyl target for null-edge refinement

The physical periodic square supplied a nonzero proper eta-Lorentz curvature
refinement, but its static identity-coframe stationarity audit exposed two
defects: the only Ricci-invisible one-face mode violated Riemann pair exchange,
and the exact link equation ruled it out.

This module supplies the next curvature specification.  It constructs a
two-parameter diagonal curvature operator on the six bivector planes.  In the
ordered basis `(12,13,23,01,02,03)`, its diagonal coordinates are

`(-x-y, y, x, x, y, -x-y)`.

The resulting local curvature is nonzero when `x` is nonzero and satisfies:

* antisymmetry in the spacetime face pair;
* exchange symmetry with the internally lowered bivector pair;
* the algebraic first Bianchi identity;
* vanishing identity-coframe mixed Ricci and scalar curvature;
* hence every mixed vacuum Einstein entry vanishes.

The unit choice `(x,y)=(1,0)` is a concrete nonzero algebraic vacuum-Weyl
target.  This is not yet a group-valued plaquette refinement or a stationary
solution.  It is the convention-locked Riemann-sector target that the next
physical varying-coframe construction must realize.

The diagonal trace-free curvature pattern is standard `[import/comp]`; its
translation to the repository's rotation-then-boost coordinates and exact
Lean verification are project-local `[orig/comp]`.  Claim label: finite
identity.
-/

namespace PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget

open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteEinsteinAudit

/-- Six diagonal bivector-plane eigenvalues of the two-parameter vacuum-Weyl
family, in the project ordering `(12,13,23,01,02,03)`. -/
def diagonalVacuumWeylCoordinates (x y : Real) : Fiber 6 :=
  ![-x - y, y, x, x, y, -x - y]

/-- Local curvature whose spacetime face pair and internal bivector pair are
the same ordered plane, with orientation reversal on the opposite face. -/
def diagonalVacuumWeylCurvature
    (x y : Real) : Fin 4 -> Fin 4 -> Fiber 6 :=
  fun a b component =>
    if a = bivectorFirst component /\
        b = bivectorSecond component then
      diagonalVacuumWeylCoordinates x y component
    else if a = bivectorSecond component /\
        b = bivectorFirst component then
      -diagonalVacuumWeylCoordinates x y component
    else 0

/-- Algebraic first Bianchi identity after lowering both internal curvature
indices with eta. -/
def CurvatureFirstBianchi
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) : Prop :=
  forall a b c d,
    loweredBivectorMatrix (curvature a b) c d +
      loweredBivectorMatrix (curvature b c) a d +
      loweredBivectorMatrix (curvature c a) b d = 0

/-- The diagonal family is antisymmetric in its spacetime face pair. -/
theorem diagonalVacuumWeylCurvature_antisymmetric
    (x y : Real) :
    forall a b component,
      diagonalVacuumWeylCurvature x y b a component =
        -diagonalVacuumWeylCurvature x y a b component := by
  intro a b component
  fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [diagonalVacuumWeylCurvature,
      diagonalVacuumWeylCoordinates] <;> ring

set_option maxHeartbeats 3000000 in
/-- The diagonal family has metric-correct exchange symmetry between the
spacetime face pair and the lowered internal bivector pair. -/
theorem diagonalVacuumWeylCurvature_pairExchange
    (x y : Real) :
    CurvaturePairExchangeSymmetric (diagonalVacuumWeylCurvature x y) := by
  intro a b i j
  fin_cases a <;> fin_cases b <;> fin_cases i <;> fin_cases j <;>
    simp +decide [diagonalVacuumWeylCurvature,
      diagonalVacuumWeylCoordinates, bivectorMatrix,
      MinkowskiConvention.eta]

set_option maxHeartbeats 3000000 in
/-- The diagonal family satisfies the algebraic first Bianchi identity. -/
theorem diagonalVacuumWeylCurvature_firstBianchi
    (x y : Real) :
    CurvatureFirstBianchi (diagonalVacuumWeylCurvature x y) := by
  intro a b c d
  fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
    simp +decide [diagonalVacuumWeylCurvature,
      diagonalVacuumWeylCoordinates, bivectorMatrix,
      MinkowskiConvention.eta] <;> ring

set_option maxHeartbeats 3000000 in
/-- Every mixed Ricci component of the diagonal family vanishes at the
identity inverse coframe. -/
theorem diagonalVacuumWeylCurvature_mixedRicci_zero
    (x y : Real) (coframeDirection raisedDirection : Fin 4) :
    mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
        (diagonalVacuumWeylCurvature x y)
        coframeDirection raisedDirection = 0 := by
  fin_cases coframeDirection <;> fin_cases raisedDirection <;>
    simp +decide [mixedRicciCurvature, diagonalVacuumWeylCurvature,
      diagonalVacuumWeylCoordinates, bivectorMatrix,
      bivectorFirst, bivectorSecond, Matrix.one_apply,
      Fin.sum_univ_four]; ring

set_option maxHeartbeats 3000000 in
/-- The scalar curvature of the diagonal family vanishes at the identity
inverse coframe. -/
theorem diagonalVacuumWeylCurvature_scalar_zero (x y : Real) :
    inverseCoframeScalarCurvature
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (diagonalVacuumWeylCurvature x y) = 0 := by
  simp +decide [inverseCoframeScalarCurvature,
    diagonalVacuumWeylCurvature, diagonalVacuumWeylCoordinates,
    bivectorMatrix, bivectorFirst, bivectorSecond, Matrix.one_apply,
    Fin.sum_univ_four]
  ring

/-- Hence every mixed vacuum Einstein entry vanishes for the diagonal family.
-/
theorem diagonalVacuumWeylCurvature_mixedVacuum
    (x y : Real) (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (diagonalVacuumWeylCurvature x y)
        coframeDirection raisedDirection = 0 := by
  rw [mixedVacuumEinsteinEntry,
    diagonalVacuumWeylCurvature_mixedRicci_zero,
    diagonalVacuumWeylCurvature_scalar_zero]
  ring

/-- A nonzero `x` parameter makes the diagonal curvature field nonzero. -/
theorem diagonalVacuumWeylCurvature_ne_zero_of_x
    {x y : Real} (hX : x ≠ 0) :
    diagonalVacuumWeylCurvature x y ≠ 0 := by
  intro hCurvature
  have hEntry := congrFun
    (congrFun (congrFun hCurvature 0) 1) 3
  apply hX
  simpa +decide [diagonalVacuumWeylCurvature,
    diagonalVacuumWeylCoordinates, bivectorFirst, bivectorSecond] using hEntry

/-- Complete algebraic target specification at the identity coframe. -/
structure IdentityCoframeVacuumRiemannTarget where
  /-- Ordered local curvature field. -/
  curvature : Fin 4 -> Fin 4 -> Fiber 6
  /-- The target is genuinely nonflat. -/
  nonzero : curvature ≠ 0
  /-- Antisymmetry in the spacetime face pair. -/
  face_antisymmetric : forall a b component,
    curvature b a component = -curvature a b component
  /-- Exchange symmetry with the lowered internal pair. -/
  pair_exchange : CurvaturePairExchangeSymmetric curvature
  /-- Algebraic first Bianchi identity. -/
  first_bianchi : CurvatureFirstBianchi curvature
  /-- Vanishing mixed Ricci tensor. -/
  ricci_zero : forall coframeDirection raisedDirection,
    mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real) curvature
      coframeDirection raisedDirection = 0
  /-- Vanishing scalar curvature. -/
  scalar_zero : inverseCoframeScalarCurvature
    (1 : Matrix (Fin 4) (Fin 4) Real) curvature = 0
  /-- Vanishing mixed Einstein tensor. -/
  mixed_vacuum : forall coframeDirection raisedDirection,
    mixedVacuumEinsteinEntry
      (1 : Matrix (Fin 4) (Fin 4) Real) curvature
      coframeDirection raisedDirection = 0

/-- Every diagonal family member with nonzero `x` packages all algebraic
vacuum-Riemann requirements. -/
def diagonalVacuumWeylPackage
    (x y : Real) (hX : x ≠ 0) : IdentityCoframeVacuumRiemannTarget where
  curvature := diagonalVacuumWeylCurvature x y
  nonzero := diagonalVacuumWeylCurvature_ne_zero_of_x hX
  face_antisymmetric := diagonalVacuumWeylCurvature_antisymmetric x y
  pair_exchange := diagonalVacuumWeylCurvature_pairExchange x y
  first_bianchi := diagonalVacuumWeylCurvature_firstBianchi x y
  ricci_zero := diagonalVacuumWeylCurvature_mixedRicci_zero x y
  scalar_zero := diagonalVacuumWeylCurvature_scalar_zero x y
  mixed_vacuum := diagonalVacuumWeylCurvature_mixedVacuum x y

/-- Concrete unit-amplitude nonzero vacuum-Weyl target. -/
def unitVacuumWeylTarget : IdentityCoframeVacuumRiemannTarget :=
  diagonalVacuumWeylPackage 1 0 (by norm_num)

/-- The algebraic target class needed by the next refinement stage is
nonempty. -/
theorem identityCoframeVacuumRiemannTarget_nonempty :
    Nonempty IdentityCoframeVacuumRiemannTarget :=
  ⟨unitVacuumWeylTarget⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget.diagonalVacuumWeylCurvature_pairExchange' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms diagonalVacuumWeylCurvature_pairExchange

/-- info: 'PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget.diagonalVacuumWeylCurvature_mixedVacuum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms diagonalVacuumWeylCurvature_mixedVacuum

/-- info: 'PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget.identityCoframeVacuumRiemannTarget_nonempty' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identityCoframeVacuumRiemannTarget_nonempty

end PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget
