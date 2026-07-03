import PhysicsSM.Draft.NullEdge.GateC1.TetraFourierInverse
import PhysicsSM.Draft.NullEdge.GateC1.TetraSymbolOverlapGW
import PhysicsSM.Draft.NullEdge.GateC1.TetraPhaseTrigEqual

/-!
# Gate C1: operator-level overlap sign `sign(Hfree)` and its involution

This Draft module lifts the symbol-level chiral release
(`TetraSymbolOverlapGW.lean`) to a real-space OPERATOR `signHfree`, using the
two-sided finite Fourier isomorphism (`TetraFourierInverse.lean`).

`signHfree` is defined by pulling the per-momentum elementary sign symbols
`signSymbol(k_m) = coeff(k_m)^{-1/2} H(k_m)` back to real space through the
inverse Fourier transform:

    signHfree Psi := fourierUnitaryInv (m |-> signSymbol(k_m) . fourierUnitary Psi m).

Because each symbol is a self-adjoint involution (`signSymbol_sq`) and the
Fourier transform is a two-sided isometry, `signHfree` is the operator sign of
`Hfree`: this file proves it squares to the identity,

    signHfree (signHfree Psi) = Psi,

which is the operator-level counterpart of the elementary symbol involution and
the key property needed to read `signHfree` as `sign(Hfree)` and build the
operator overlap `Dov = 1 + Gamma5 . signHfree`.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem**.  Regulator-level per `docs/NERD_ROADMAP.md`
(free, no gauge). Successor: the operator GW relation for `Dov` (needs the field
chirality `Gamma5 = matrixFieldAction gamma5` and its block action) and the
operator Weyl projectors.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraOperatorOverlapGW

open TetraFiniteTorusEqual
open TetraCharactersEqual
open TetraPhaseTrigEqual
open TetraScalarWilsonSymbol
open TetraQMatrixSquareExact
open TetraSymbolOverlapGW
open TetraFourierInverse

variable (N : ℕ) [NeZero N]
variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- The real-space overlap sign operator `sign(Hfree)`: the inverse Fourier
transform of the per-momentum elementary sign symbols acting on the transform of
`Psi`. -/
def signHfree (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) : SiteN N → Spin → ℂ :=
  fourierUnitaryInv N
    (fun m => (signSymbol gamma5 D a r rho (kOfMom N m)).mulVec
      (fourierUnitary N Psi m))

/-- `signHfree` is block-diagonalized by the Fourier transform into the
per-momentum sign symbols (immediate from the forward-inverse round trip). -/
theorem fourierUnitary_signHfree
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) (m : MomN N) :
    fourierUnitary N (signHfree N gamma5 D a r rho Psi) m =
      (signSymbol gamma5 D a r rho (kOfMom N m)).mulVec
        (fourierUnitary N Psi m) := by
  unfold signHfree
  rw [fourierUnitary_fourierUnitaryInv]

/-- **The operator sign squares to the identity**: `signHfree` is an involution.

This is the operator-level counterpart of the elementary symbol involution
`signSymbol_sq`.  It uses the block diagonalization (`fourierUnitary_signHfree`),
the per-momentum involution (`signSymbol_sq`), and injectivity of the Fourier
transform (its inverse round trip). -/
theorem signHfree_involutive
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgH : star gamma5 = gamma5)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (hpos : ∀ m : MomN N, 0 < sqCoeff D a r rho (kOfMom N m))
    (Psi : SiteN N → Spin → ℂ) :
    signHfree N gamma5 D a r rho (signHfree N gamma5 D a r rho Psi) = Psi := by
  apply Function.LeftInverse.injective (fourierUnitaryInv_fourierUnitary N)
  funext m s
  rw [fourierUnitary_signHfree, fourierUnitary_signHfree, Matrix.mulVec_mulVec,
    signSymbol_sq gamma5 D a r rho (kOfMom N m) hgU hgH (hanti m) (hpos m),
    Matrix.one_mulVec]

end TetraOperatorOverlapGW
end GateC1
end NullEdge
end Draft
end PhysicsSM
