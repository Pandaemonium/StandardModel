import PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
import PhysicsSM.Draft.NullEdge.SL2CLorentzAction

/-!
# Lorentz-derived bivector Krein convention

The periodic link/face Palatini controls require a six-component curvature
fiber.  This module removes the arbitrary part of the preceding split-six
control by deriving that fiber and its indefinite pairing from the project's
mostly-minus Minkowski metric.

The ordered bivector basis is

`(e1 wedge e2, e1 wedge e3, e2 wedge e3,
  e0 wedge e1, e0 wedge e2, e0 wedge e3)`.

Thus the three spatial rotation planes come first and have positive norm,
while the three time-space boost planes come last and have negative norm.  The
induced determinant pairing

`<a wedge b, c wedge d> = <a,c><b,d> - <a,d><b,c>`

is proved to be exactly the diagonal `(3,3)` fundamental symmetry already
used by `FinitePeriodicKreinLinkAdjoint`.

For a four-vector matrix `L`, `wedgeTwoTransport L` is its exterior-square
action in this ordered basis.  A finite Binet identity then proves that every
`eta`-Lorentz `L` preserves the derived bivector pairing.  In particular, the
concrete `SL(2,C)` action already soldered to null edges induces a valid
six-component Krein transport.

## Scope and provenance

This is a finite representation-theoretic identity, not yet a nonlinear
Palatini variation.  It fixes the physical rotation/boost ordering and the
fundamental symmetry, but does not derive a face field from `e wedge e`, assign
dual-cell volumes, or prove that stationary link transport is Levi-Civita.
The induced bilinear form on an exterior square and its invariance under an
orthogonal action are standard `[import]`; the convention bridge to the
null-edge modules and guarded finite implementation are `[orig]`.  Claim
label: finite identity.
-/

namespace PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge

open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.SL2CLorentzAction

/-! ## Ordered bivector basis and induced metric -/

/-- First spacetime index in the ordered rotation-then-boost bivector basis.
-/
def bivectorFirst : Fin 6 -> Fin 4 :=
  ![1, 1, 2, 0, 0, 0]

/-- Second spacetime index in the ordered rotation-then-boost bivector basis.
-/
def bivectorSecond : Fin 6 -> Fin 4 :=
  ![2, 3, 3, 1, 2, 3]

/-- The metric induced on the ordered bivector basis by the mostly-minus
spacetime metric. -/
def spacetimeBivectorMetric : Matrix (Fin 6) (Fin 6) Real :=
  fun i j =>
    MinkowskiConvention.eta (bivectorFirst i) (bivectorFirst j) *
        MinkowskiConvention.eta (bivectorSecond i) (bivectorSecond j) -
      MinkowskiConvention.eta (bivectorFirst i) (bivectorSecond j) *
        MinkowskiConvention.eta (bivectorSecond i) (bivectorFirst j)

/-- In the rotation-then-boost basis, the spacetime-induced bivector metric is
exactly the split-six matrix: rotations are positive and boosts negative. -/
theorem spacetimeBivectorMetric_eq_splitSixMatrix :
    spacetimeBivectorMetric = splitSixMatrix := by
  unfold spacetimeBivectorMetric
  rw [MinkowskiConvention.eta_diagonal]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [bivectorFirst, bivectorSecond, splitSixMatrix, splitSixSign]

/-- The physical rotation/boost ordering therefore supplies a concrete
fundamental symmetry on the six-component bivector fiber. -/
def lorentzBivectorFundamentalSymmetry : FundamentalSymmetry 6 where
  matrix := spacetimeBivectorMetric
  involutive := by
    rw [spacetimeBivectorMetric_eq_splitSixMatrix]
    exact splitSixFundamentalSymmetry.involutive
  selfAdjoint := by
    rw [spacetimeBivectorMetric_eq_splitSixMatrix]
    exact splitSixFundamentalSymmetry.selfAdjoint

/-- The derived fundamental symmetry agrees definitionally, at matrix level,
with the split-six control. -/
theorem lorentzBivectorFundamentalSymmetry_matrix :
    lorentzBivectorFundamentalSymmetry.matrix = splitSixMatrix := by
  exact spacetimeBivectorMetric_eq_splitSixMatrix

/-! ## Exterior-square Lorentz transport -/

/-- Exterior-square action of a four-vector transport matrix in the ordered
rotation-then-boost basis. -/
def wedgeTwoTransport (L : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 6) (Fin 6) Real :=
  fun i j =>
    L (bivectorFirst i) (bivectorFirst j) *
        L (bivectorSecond i) (bivectorSecond j) -
      L (bivectorFirst i) (bivectorSecond j) *
        L (bivectorSecond i) (bivectorFirst j)

/-- Minkowski pairing of two columns of a four-vector transport matrix. -/
def minkowskiColumnPair (L : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Real :=
  MinkowskiConvention.mink (fun mu => L mu a) (fun mu => L mu b)

/-- Eta-orthogonality says exactly that the Minkowski pairing of columns is
the corresponding eta entry. -/
theorem minkowskiColumnPair_eq_eta
    (L : Matrix (Fin 4) (Fin 4) Real) (hL : IsEtaLorentz L)
    (a b : Fin 4) :
    minkowskiColumnPair L a b = MinkowskiConvention.eta a b := by
  have hab := congrFun (congrFun hL a) b
  simpa [IsEtaLorentz, minkowskiColumnPair, MinkowskiConvention.mink,
    Matrix.mul_apply, Matrix.transpose_apply, dotProduct,
    MinkowskiConvention.eta, Fin.sum_univ_four] using hab

/-- Split-sign contraction of two columns of the exterior-square transport.
-/
def wedgeTwoColumnPair (L : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 6) : Real :=
  Finset.sum Finset.univ (fun i =>
    splitSixSign i * wedgeTwoTransport L i a * wedgeTwoTransport L i b)

/-- The exterior-square contraction is the determinant of the four-vector
column pairings.  This is the finite six-coordinate Binet identity. -/
theorem wedgeTwoColumnPair_binet
    (L : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 6) :
    wedgeTwoColumnPair L a b =
      minkowskiColumnPair L (bivectorFirst a) (bivectorFirst b) *
          minkowskiColumnPair L (bivectorSecond a) (bivectorSecond b) -
        minkowskiColumnPair L (bivectorFirst a) (bivectorSecond b) *
          minkowskiColumnPair L (bivectorSecond a) (bivectorFirst b) := by
  fin_cases a <;> fin_cases b <;>
    simp [wedgeTwoColumnPair, wedgeTwoTransport, splitSixSign,
      bivectorFirst, bivectorSecond, minkowskiColumnPair,
      MinkowskiConvention.mink, MinkowskiConvention.eta, dotProduct,
      Fin.sum_univ_six, Fin.sum_univ_four] <;>
    ring

/-- Matrix multiplication by the diagonal split-six metric is the explicit
split-sign column contraction. -/
theorem wedgeTwo_gram_entry
    (L : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 6) :
    ((wedgeTwoTransport L).transpose * splitSixMatrix * wedgeTwoTransport L)
        a b = wedgeTwoColumnPair L a b := by
  simp [Matrix.mul_apply, splitSixMatrix, Matrix.diagonal_apply,
    wedgeTwoColumnPair, Matrix.transpose_apply]
  apply Finset.sum_congr rfl
  intro i _
  ring

/-- Every eta-Lorentz four-vector transport induces a split-orthogonal
six-component bivector transport. -/
theorem wedgeTwoTransport_preserves_splitSix
    (L : Matrix (Fin 4) (Fin 4) Real) (hL : IsEtaLorentz L) :
    (wedgeTwoTransport L).transpose * splitSixMatrix * wedgeTwoTransport L =
      splitSixMatrix := by
  ext a b
  rw [wedgeTwo_gram_entry, wedgeTwoColumnPair_binet]
  rw [minkowskiColumnPair_eq_eta L hL,
    minkowskiColumnPair_eq_eta L hL,
    minkowskiColumnPair_eq_eta L hL,
    minkowskiColumnPair_eq_eta L hL]
  change spacetimeBivectorMetric a b = splitSixMatrix a b
  exact congrFun (congrFun spacetimeBivectorMetric_eq_splitSixMatrix a) b

/-- The split-six metric is involutive as a matrix. -/
theorem splitSixMatrix_mul_self :
    splitSixMatrix * splitSixMatrix =
      (1 : Matrix (Fin 6) (Fin 6) Real) := by
  apply Matrix.mulVec_injective
  funext field
  rw [← Matrix.mulVec_mulVec, Matrix.one_mulVec]
  exact splitSixFundamentalSymmetry.involutive field

/-- Matrix of the adjoint selected by the Lorentz-derived bivector pairing.
-/
def splitSixAdjointMatrix (U : Matrix (Fin 6) (Fin 6) Real) :
    Matrix (Fin 6) (Fin 6) Real :=
  splitSixMatrix * U.transpose * splitSixMatrix

/-- A split-orthogonal transport has the split-six adjoint as a left inverse.
-/
theorem splitSixAdjointMatrix_mul_of_preserves
    (U : Matrix (Fin 6) (Fin 6) Real)
    (hU : U.transpose * splitSixMatrix * U = splitSixMatrix) :
    splitSixAdjointMatrix U * U = 1 := by
  unfold splitSixAdjointMatrix
  calc
    splitSixMatrix * U.transpose * splitSixMatrix * U =
        splitSixMatrix * (U.transpose * splitSixMatrix * U) := by
      simp [Matrix.mul_assoc]
    _ = splitSixMatrix * splitSixMatrix := by rw [hU]
    _ = 1 := splitSixMatrix_mul_self

/-- The explicit transport action is Mathlib matrix-vector multiplication.
-/
theorem transportApply_eq_mulVec
    (U : Matrix (Fin 6) (Fin 6) Real) (field : Fiber 6) :
    transportApply U field = Matrix.mulVec U field := by
  rfl

/-- The explicit Euclidean adjoint action is multiplication by the matrix
transpose. -/
theorem transportAdjointApply_eq_transpose_mulVec
    (U : Matrix (Fin 6) (Fin 6) Real) (field : Fiber 6) :
    transportAdjointApply U field = Matrix.mulVec U.transpose field := by
  rfl

/-- For a split-orthogonal six-component transport, the Krein adjoint in the
periodic link module is an actual inverse action. -/
theorem kreinAdjointApply_leftInverse_of_preserves_splitSix
    (U : Matrix (Fin 6) (Fin 6) Real)
    (hU : U.transpose * splitSixMatrix * U = splitSixMatrix)
    (field : Fiber 6) :
    kreinAdjointApply lorentzBivectorFundamentalSymmetry U
        (transportApply U field) = field := by
  rw [transportApply_eq_mulVec]
  unfold kreinAdjointApply
  rw [lorentzBivectorFundamentalSymmetry_matrix]
  rw [transportApply_eq_mulVec, transportAdjointApply_eq_transpose_mulVec,
    transportApply_eq_mulVec]
  simp only [Matrix.mulVec_mulVec]
  rw [← Matrix.mul_assoc U.transpose splitSixMatrix U, hU,
    splitSixMatrix_mul_self, Matrix.one_mulVec]

/-- Consequently, every exterior-square Lorentz transport uses inverse
parallel transport in the Krein backward adjoint. -/
theorem wedgeTwoTransport_kreinAdjoint_leftInverse
    (L : Matrix (Fin 4) (Fin 4) Real) (hL : IsEtaLorentz L)
    (field : Fiber 6) :
    kreinAdjointApply lorentzBivectorFundamentalSymmetry (wedgeTwoTransport L)
        (transportApply (wedgeTwoTransport L) field) = field := by
  exact kreinAdjointApply_leftInverse_of_preserves_splitSix
    (wedgeTwoTransport L) (wedgeTwoTransport_preserves_splitSix L hL) field

/-- The exterior-square action of the concrete null-edge `SL(2,C)` Lorentz
matrix preserves the derived six-component fundamental symmetry. -/
theorem wedgeTwoTransport_sl2_preserves_splitSix
    (A : PhysicsSM.Draft.NullEdge.SL2CCentralSign.SL2C) :
    (wedgeTwoTransport (sl2LorentzMatrix A)).transpose * splitSixMatrix *
        wedgeTwoTransport (sl2LorentzMatrix A) = splitSixMatrix := by
  exact wedgeTwoTransport_preserves_splitSix (sl2LorentzMatrix A)
    (sl2LorentzMatrix_isEtaLorentz A)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge.spacetimeBivectorMetric_eq_splitSixMatrix' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spacetimeBivectorMetric_eq_splitSixMatrix

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge.wedgeTwoColumnPair_binet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wedgeTwoColumnPair_binet

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge.wedgeTwoTransport_preserves_splitSix' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wedgeTwoTransport_preserves_splitSix

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge.wedgeTwoTransport_kreinAdjoint_leftInverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wedgeTwoTransport_kreinAdjoint_leftInverse

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge.wedgeTwoTransport_sl2_preserves_splitSix' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wedgeTwoTransport_sl2_preserves_splitSix

end PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
