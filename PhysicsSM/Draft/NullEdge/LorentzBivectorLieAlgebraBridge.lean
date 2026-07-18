import PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge

/-!
# Lorentz bivectors as infinitesimal connection matrices

The finite link/face Palatini layer carries its face field in the ordered
six-component bivector basis

`(12, 13, 23, 01, 02, 03)`.

An exact nonlinear plaquette holonomy, however, is matrix-valued.  Before those
objects can be paired, the six bivector coordinates must be identified with
the six-dimensional Lorentz Lie algebra inside `4 x 4` matrices.  This module
performs that convention-sensitive identification.

For a contravariant antisymmetric bivector `B`, let `F(B)` be its antisymmetric
matrix and define

`hat(B) = F(B) eta`.

Thus one internal index is lowered using the mostly-minus metric.  The result
obeys `hat(B)^T eta + eta hat(B) = 0`.  The coordinate map is a left inverse,
and the normalized trace pairing satisfies

`-1/2 tr(hat(B) hat(C)) = <B,C>_J`,

where `J = diag(+,+,+,-,-,-)` is exactly the Lorentz-derived Krein metric used
by the periodic link variation.

## Scope and provenance

These are finite Lie-algebra and representation identities.  They make the
future nonlinear Palatini contraction type-correct, but do not yet prove that
a group-valued plaquette tangent lies in this Lorentz image or that the
connection equation selects Levi-Civita transport.  The bivector/Lorentz-
algebra identification and trace pairing are standard `[import]`; the explicit
ordering and bridge to the null-edge Krein modules are `[orig]`.  Claim label:
finite identity.
-/

namespace PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge

open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge

/-- Antisymmetric contravariant matrix of a bivector in the ordered
rotation-then-boost coordinate convention. -/
def bivectorMatrix (bivector : Fiber 6) : Matrix (Fin 4) (Fin 4) Real :=
  !![0, bivector 3, bivector 4, bivector 5;
     -bivector 3, 0, bivector 0, bivector 1;
     -bivector 4, -bivector 0, 0, bivector 2;
     -bivector 5, -bivector 1, -bivector 2, 0]

/-- The displayed bivector matrix is antisymmetric. -/
theorem bivectorMatrix_transpose (bivector : Fiber 6) :
    (bivectorMatrix bivector).transpose = -bivectorMatrix bivector := by
  ext mu nu
  fin_cases mu <;> fin_cases nu <;> simp [bivectorMatrix]

/-- Lower the second bivector index with the mostly-minus metric.  The result
is the corresponding infinitesimal Lorentz generator. -/
def lorentzGenerator (bivector : Fiber 6) : Matrix (Fin 4) (Fin 4) Real :=
  bivectorMatrix bivector * MinkowskiConvention.eta

/-- Matrix form of the mostly-minus Lorentz Lie-algebra condition. -/
def IsLorentzLieAlgebra (generator : Matrix (Fin 4) (Fin 4) Real) : Prop :=
  generator.transpose * MinkowskiConvention.eta +
      MinkowskiConvention.eta * generator = 0

/-- Every six-component bivector gives an infinitesimal Lorentz generator. -/
theorem lorentzGenerator_mem (bivector : Fiber 6) :
    IsLorentzLieAlgebra (lorentzGenerator bivector) := by
  unfold IsLorentzLieAlgebra
  ext mu nu
  fin_cases mu <;> fin_cases nu <;>
    simp [lorentzGenerator, bivectorMatrix,
      MinkowskiConvention.eta, Matrix.mul_apply, Matrix.transpose_apply,
      Fin.sum_univ_four]

/-- Exterior-square coordinate transport is exactly conjugation of the raw
contravariant antisymmetric bivector matrix by `L` and `L^T`. -/
theorem bivectorMatrix_transportApply_wedgeTwoTransport
    (L : Matrix (Fin 4) (Fin 4) Real) (bivector : Fiber 6) :
    bivectorMatrix
        (transportApply (wedgeTwoTransport L) bivector) =
      L * bivectorMatrix bivector * L.transpose := by
  ext mu nu
  fin_cases mu <;> fin_cases nu <;>
    simp [bivectorMatrix, transportApply, wedgeTwoTransport,
      bivectorFirst, bivectorSecond, Matrix.mul_apply,
      Matrix.transpose_apply, Fin.sum_univ_six, Fin.sum_univ_four] <;>
    ring

/-- For an eta-Lorentz four-vector transport, the induced bivector generator
intertwines the defining four-vector representation. -/
theorem lorentzGenerator_transportApply_wedgeTwoTransport_mul
    (L : Matrix (Fin 4) (Fin 4) Real) (hL : IsEtaLorentz L)
    (bivector : Fiber 6) :
    lorentzGenerator (transportApply (wedgeTwoTransport L) bivector) * L =
      L * lorentzGenerator bivector := by
  rw [lorentzGenerator,
    bivectorMatrix_transportApply_wedgeTwoTransport]
  unfold lorentzGenerator
  calc
    (L * bivectorMatrix bivector * L.transpose) *
          MinkowskiConvention.eta * L =
        L * bivectorMatrix bivector *
          (L.transpose * MinkowskiConvention.eta * L) := by
            simp [Matrix.mul_assoc]
    _ = L * bivectorMatrix bivector * MinkowskiConvention.eta := by
      rw [hL]
    _ = L * (bivectorMatrix bivector * MinkowskiConvention.eta) := by
      simp [Matrix.mul_assoc]

/-- Recover ordered bivector coordinates after raising the lowered generator
index with `eta`. -/
def lorentzGeneratorCoordinates
    (generator : Matrix (Fin 4) (Fin 4) Real) : Fiber 6 :=
  fun component =>
    (generator *
        (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) Real))
      (bivectorFirst component) (bivectorSecond component)

/-- Coordinate recovery is exact on every generated Lorentz matrix. -/
theorem lorentzGeneratorCoordinates_lorentzGenerator
    (bivector : Fiber 6) :
    lorentzGeneratorCoordinates (lorentzGenerator bivector) = bivector := by
  funext component
  fin_cases component <;>
    simp [lorentzGeneratorCoordinates, lorentzGenerator, bivectorMatrix,
      MinkowskiConvention.eta, Matrix.mul_apply, bivectorFirst,
      bivectorSecond, Fin.sum_univ_four]

/-- The Lorentz-generator map is injective. -/
theorem lorentzGenerator_injective : Function.Injective lorentzGenerator := by
  intro left right hGenerator
  rw [<- lorentzGeneratorCoordinates_lorentzGenerator left,
    <- lorentzGeneratorCoordinates_lorentzGenerator right, hGenerator]

/-- Every matrix satisfying the Lorentz Lie-algebra condition is reconstructed
from its six ordered bivector coordinates. -/
theorem lorentzGenerator_lorentzGeneratorCoordinates
    (generator : Matrix (Fin 4) (Fin 4) Real)
    (hGenerator : IsLorentzLieAlgebra generator) :
    lorentzGenerator (lorentzGeneratorCoordinates generator) = generator := by
  unfold IsLorentzLieAlgebra at hGenerator
  ext mu nu
  have hEntry := congrFun (congrFun hGenerator mu) nu
  fin_cases mu <;> fin_cases nu <;>
    simp [lorentzGeneratorCoordinates, lorentzGenerator, bivectorMatrix,
      MinkowskiConvention.eta, Matrix.mul_apply, Matrix.transpose_apply,
      Matrix.vecMul, dotProduct, bivectorFirst, bivectorSecond,
      Fin.sum_univ_four] at hEntry ⊢ <;>
    linarith

/-- The ordered six-component bivector fiber is exactly equivalent to the
matrix Lorentz Lie algebra in the fixed mostly-minus convention. -/
def lorentzGeneratorEquiv :
    Fiber 6 ≃
      { generator : Matrix (Fin 4) (Fin 4) Real //
        IsLorentzLieAlgebra generator } where
  toFun bivector := ⟨lorentzGenerator bivector, lorentzGenerator_mem bivector⟩
  invFun generator := lorentzGeneratorCoordinates generator.1
  left_inv := lorentzGeneratorCoordinates_lorentzGenerator
  right_inv generator := Subtype.ext
    (lorentzGenerator_lorentzGeneratorCoordinates generator.1 generator.2)

/-- The trace pairing of two generated matrices is exactly minus twice the
physical Lorentz-bivector Krein pairing. -/
theorem trace_lorentzGenerator_mul
    (left right : Fiber 6) :
    Matrix.trace (lorentzGenerator left * lorentzGenerator right) =
      -2 * kreinPair lorentzBivectorFundamentalSymmetry left right := by
  unfold kreinPair
  rw [lorentzBivectorFundamentalSymmetry_matrix]
  simp [Matrix.trace, Matrix.diag, lorentzGenerator, bivectorMatrix,
    MinkowskiConvention.eta, Matrix.mul_apply, Fin.sum_univ_four,
    fiberPair, transportApply, splitSixMatrix,
    Matrix.diagonal_apply, splitSixSign, Fin.sum_univ_six]
  ring

/-- Equivalently, the normalized matrix trace is the physical Palatini
bivector pairing. -/
theorem normalizedTracePair_eq_kreinPair
    (left right : Fiber 6) :
    -(1 / 2 : Real) *
        Matrix.trace (lorentzGenerator left * lorentzGenerator right) =
      kreinPair lorentzBivectorFundamentalSymmetry left right := by
  rw [trace_lorentzGenerator_mul]
  ring

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge.lorentzGenerator_mem' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lorentzGenerator_mem

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge.lorentzGenerator_transportApply_wedgeTwoTransport_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lorentzGenerator_transportApply_wedgeTwoTransport_mul

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge.lorentzGeneratorCoordinates_lorentzGenerator' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lorentzGeneratorCoordinates_lorentzGenerator

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge.lorentzGenerator_lorentzGeneratorCoordinates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lorentzGenerator_lorentzGeneratorCoordinates

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge.normalizedTracePair_eq_kreinPair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalizedTracePair_eq_kreinPair

end PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
