import PhysicsSM.Draft.NullEdge.GateC1.TetraOperatorWeylProjectors
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexEndIntegrality

/-!
# Gate C2: the free tetrahedral chiral OPERATOR index is a well-defined integer

This Draft module connects the C1 flagship (the real-space operator `sign(Hfree)`)
to the C2 index integrality (`OverlapIndexEndIntegrality`), closing the C1<->C2
loop at the operator level.  It bundles `signHfree` and the chirality `Gamma5op`
as finite `ℂ`-linear ENDOMORPHISMS of the field space and instantiates
`overlapIndexEnd_isInteger`, so the operator overlap index of the free tetrahedral
chiral operator is a well-defined integer.

The first pieces are the (reusable) linearity of `signHfree`.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace FlagshipOperatorIndex

open PhysicsSM.Draft.NullEdge.GateC1.TetraFiniteTorusEqual
open PhysicsSM.Draft.NullEdge.GateC1.TetraCharactersEqual
open PhysicsSM.Draft.NullEdge.GateC1.TetraScalarWilsonSymbol
open PhysicsSM.Draft.NullEdge.GateC1.TetraQMatrixSquareExact
open PhysicsSM.Draft.NullEdge.GateC1.TetraSymbolOverlapGW
open PhysicsSM.Draft.NullEdge.GateC1.TetraPhaseTrigEqual
open PhysicsSM.Draft.NullEdge.GateC1.TetraFourierInverse
open PhysicsSM.Draft.NullEdge.GateC1.TetraFreeOperator
open PhysicsSM.Draft.NullEdge.GateC1.TetraOperatorOverlapGW
open PhysicsSM.Draft.NullEdge.GateC1.TetraOperatorWeylProjectors

variable (N : ℕ) [NeZero N]
variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- `signHfree` distributes over field addition (Fourier transport). -/
theorem signHfree_add (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi Phi : SiteN N → Spin → ℂ) :
    signHfree N gamma5 D a r rho (Psi + Phi)
      = signHfree N gamma5 D a r rho Psi + signHfree N gamma5 D a r rho Phi := by
  apply Function.LeftInverse.injective (fourierUnitaryInv_fourierUnitary N)
  funext m
  rw [fourierUnitary_signHfree, fourierUnitary_piAdd, Matrix.mulVec_add,
    fourierUnitary_piAdd, fourierUnitary_signHfree, fourierUnitary_signHfree]

/-- `signHfree` commutes with scalar multiplication (Fourier transport). -/
theorem signHfree_smul (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (c : ℂ)
    (Psi : SiteN N → Spin → ℂ) :
    signHfree N gamma5 D a r rho (c • Psi)
      = c • signHfree N gamma5 D a r rho Psi := by
  apply Function.LeftInverse.injective (fourierUnitaryInv_fourierUnitary N)
  funext m
  rw [fourierUnitary_signHfree, fourierUnitary_piSmul, Matrix.mulVec_smul,
    fourierUnitary_piSmul, fourierUnitary_signHfree]

/-- `sign(Hfree)` bundled as a finite `ℂ`-linear endomorphism of the field space. -/
def signHfreeL (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) :
    Module.End ℂ (SiteN N → Spin → ℂ) where
  toFun := signHfree N gamma5 D a r rho
  map_add' := signHfree_add N gamma5 D a r rho
  map_smul' := signHfree_smul N gamma5 D a r rho

/-- The bundled operator sign is an involution in the endomorphism ring
(`signHfreeL * signHfreeL = 1`), from the function-level `signHfree_involutive`. -/
theorem signHfreeL_mul_self (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgH : star gamma5 = gamma5)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (hpos : ∀ m : MomN N, 0 < sqCoeff D a r rho (kOfMom N m)) :
    signHfreeL N gamma5 D a r rho * signHfreeL N gamma5 D a r rho = 1 := by
  apply LinearMap.ext
  intro Psi
  exact signHfree_involutive N gamma5 D a r rho hgU hgH hanti hpos Psi

/-! ### The chirality operator `Gamma5op` as a bundled involution -/

theorem matrixFieldAction_add (M : Matrix Spin Spin ℂ)
    (Psi Phi : SiteN N → Spin → ℂ) :
    matrixFieldAction N M (Psi + Phi)
      = matrixFieldAction N M Psi + matrixFieldAction N M Phi := by
  funext x
  simp only [matrixFieldAction, Pi.add_apply, Matrix.mulVec_add]

theorem matrixFieldAction_smul (M : Matrix Spin Spin ℂ) (c : ℂ)
    (Psi : SiteN N → Spin → ℂ) :
    matrixFieldAction N M (c • Psi) = c • matrixFieldAction N M Psi := by
  funext x
  simp only [matrixFieldAction, Pi.smul_apply, Matrix.mulVec_smul]

theorem matrixFieldAction_comp (M1 M2 : Matrix Spin Spin ℂ)
    (Psi : SiteN N → Spin → ℂ) :
    matrixFieldAction N M1 (matrixFieldAction N M2 Psi)
      = matrixFieldAction N (M1 * M2) Psi := by
  funext x
  simp only [matrixFieldAction, Matrix.mulVec_mulVec]

theorem matrixFieldAction_one (Psi : SiteN N → Spin → ℂ) :
    matrixFieldAction N (1 : Matrix Spin Spin ℂ) Psi = Psi := by
  funext x
  simp only [matrixFieldAction, Matrix.one_mulVec]

/-- The chirality `Gamma5 = matrixFieldAction gamma5` bundled as an endomorphism. -/
def Gamma5opL (gamma5 : Matrix Spin Spin ℂ) :
    Module.End ℂ (SiteN N → Spin → ℂ) where
  toFun := matrixFieldAction N gamma5
  map_add' := matrixFieldAction_add N gamma5
  map_smul' := matrixFieldAction_smul N gamma5

/-- The bundled chirality is an involution when `gamma5^2 = 1`. -/
theorem Gamma5opL_mul_self (gamma5 : Matrix Spin Spin ℂ)
    (hg5 : gamma5 * gamma5 = 1) :
    Gamma5opL N gamma5 * Gamma5opL N gamma5 = 1 := by
  apply LinearMap.ext
  intro Psi
  show matrixFieldAction N gamma5 (matrixFieldAction N gamma5 Psi) = Psi
  rw [matrixFieldAction_comp, hg5, matrixFieldAction_one]

/-- **The free tetrahedral chiral OPERATOR index is a well-defined integer.**
Instantiating the endomorphism-level integrality at the bundled chirality
`Gamma5op` and the operator sign `sign(Hfree)`: the operator overlap index of the
free tetrahedral chiral operator (`(1/2)(Tr Gamma5op - Tr sign(Hfree))`) is an
integer.  This closes the C1<->C2 loop at the operator level. -/
theorem flagship_operatorIndex_isInteger
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgH : star gamma5 = gamma5)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (hpos : ∀ m : MomN N, 0 < sqCoeff D a r rho (kOfMom N m)) :
    ∃ k : ℤ, OverlapIndexEndIntegrality.overlapIndexEnd
        (Gamma5opL N gamma5) (signHfreeL N gamma5 D a r rho) = (k : ℂ) := by
  have hg5 : gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ) := by
    nth_rewrite 1 [← hgH]; exact hgU
  exact OverlapIndexEndIntegrality.overlapIndexEnd_isInteger
    (Gamma5opL N gamma5) (signHfreeL N gamma5 D a r rho)
    (Gamma5opL_mul_self N gamma5 hg5)
    (signHfreeL_mul_self N gamma5 D a r rho hgU hgH hanti hpos)

end FlagshipOperatorIndex
end GateC2
end NullEdge
end Draft
end PhysicsSM
