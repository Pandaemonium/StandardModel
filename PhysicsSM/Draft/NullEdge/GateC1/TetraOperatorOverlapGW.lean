import PhysicsSM.Draft.NullEdge.GateC1.TetraFourierInverse
import PhysicsSM.Draft.NullEdge.GateC1.TetraSymbolOverlapGW
import PhysicsSM.Draft.NullEdge.GateC1.TetraPhaseTrigEqual
import PhysicsSM.Draft.NullEdge.GateC1.TetraFreeOperatorSelfAdjoint

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

This file also proves the operator sign is self-adjoint (`signHfree_selfAdjoint`,
so `sign(Hfree)` is a self-adjoint involution = an orthogonal reflection), builds
the real-space overlap Dirac operator `DovOp = 1 + Gamma5 . signHfree`, and
proves the **operator-level Ginsparg-Wilson relation** (`operator_ginsparg_wilson`)
by the same Fourier-transport pattern (`fourierUnitary_DovOp` block-diagonalizes
`DovOp` into the symbol `Dov`, then the per-momentum `symbol_ginsparg_wilson`
transports back).  This completes the free (no-gauge) overlap/GW chiral release
at the REAL-SPACE OPERATOR level.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem**.  Regulator-level per `docs/NERD_ROADMAP.md`
(free, no gauge). Successor: operator Weyl projectors (immediate from
`signHfree_involutive`), then Gate C2 (gauge backgrounds, index, anomaly).
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
open TetraFreeOperatorSelfAdjoint
open TetraFreeOperator
open OverlapGinspargWilson

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

/-- **The operator sign is self-adjoint** for the finite field inner product:
`fieldInner (signHfree Psi) Phi = fieldInner Psi (signHfree Phi)`.  Mirrors
`Hfree_selfAdjoint`: transform to momentum space (`fourierUnitary_inner_siteN`),
where `signHfree` acts blockwise by the self-adjoint sign symbols
(`signSymbol_star`), and the per-block adjoint move transports back.

Together with `signHfree_involutive`, `signHfree` is a self-adjoint involution -
a genuine orthogonal reflection = the operator `sign(Hfree)`. -/
theorem signHfree_selfAdjoint
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hgH : star gamma5 = gamma5)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (Psi Phi : SiteN N → Spin → ℂ) :
    fieldInner N (signHfree N gamma5 D a r rho Psi) Phi =
      fieldInner N Psi (signHfree N gamma5 D a r rho Phi) := by
  rw [← fourierUnitary_inner_siteN N (signHfree N gamma5 D a r rho Psi) Phi,
      ← fourierUnitary_inner_siteN N Psi (signHfree N gamma5 D a r rho Phi)]
  unfold blockInner
  apply Finset.sum_congr rfl
  intro m _
  have hSsym : star (signSymbol gamma5 D a r rho (kOfMom N m)) =
      signSymbol gamma5 D a r rho (kOfMom N m) :=
    signSymbol_star gamma5 D a r rho (kOfMom N m) hgH (hanti m)
  have hadj :
      star ((signSymbol gamma5 D a r rho (kOfMom N m)).mulVec
          (fourierUnitary N Psi m)) ⬝ᵥ (fourierUnitary N Phi m)
        = star (fourierUnitary N Psi m) ⬝ᵥ
            (signSymbol gamma5 D a r rho (kOfMom N m)).mulVec
              (fourierUnitary N Phi m) := by
    rw [Matrix.star_mulVec, ← Matrix.dotProduct_mulVec,
      ← Matrix.star_eq_conjTranspose, hSsym]
  have hL : (∑ s : Spin,
      star (fourierUnitary N (signHfree N gamma5 D a r rho Psi) m s) *
        fourierUnitary N Phi m s)
      = star ((signSymbol gamma5 D a r rho (kOfMom N m)).mulVec
          (fourierUnitary N Psi m)) ⬝ᵥ (fourierUnitary N Phi m) := by
    rw [fourierUnitary_signHfree]; rfl
  have hR : (∑ s : Spin, star (fourierUnitary N Psi m s) *
      fourierUnitary N (signHfree N gamma5 D a r rho Phi) m s)
      = star (fourierUnitary N Psi m) ⬝ᵥ
          (signSymbol gamma5 D a r rho (kOfMom N m)).mulVec
            (fourierUnitary N Phi m) := by
    rw [fourierUnitary_signHfree]; rfl
  rw [hL, hR, hadj]

/-- `Pi.add` adapter for `fourierUnitary_add` (defeq to the explicit-lambda
form), so it rewrites `fourierUnitary N (Psi + Phi) m`. -/
theorem fourierUnitary_piAdd (Psi Phi : SiteN N → Spin → ℂ) (m : MomN N) :
    fourierUnitary N (Psi + Phi) m =
      fourierUnitary N Psi m + fourierUnitary N Phi m :=
  fourierUnitary_add N Psi Phi m

/-- The field chirality operator `Gamma5 = matrixFieldAction gamma5`. -/
def Gamma5op (gamma5 : Matrix Spin Spin ℂ) (Psi : SiteN N → Spin → ℂ) :
    SiteN N → Spin → ℂ :=
  matrixFieldAction N gamma5 Psi

/-- The real-space overlap Dirac operator `Dov = 1 + Gamma5 . signHfree`. -/
def DovOp (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) : SiteN N → Spin → ℂ :=
  Psi + Gamma5op N gamma5 (signHfree N gamma5 D a r rho Psi)

/-- `DovOp` is block-diagonalized by the Fourier transform into the per-momentum
overlap symbols `Dov gamma5 (signSymbol k_m)`. -/
theorem fourierUnitary_DovOp
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) (m : MomN N) :
    fourierUnitary N (DovOp N gamma5 D a r rho Psi) m =
      (Dov gamma5 (signSymbol gamma5 D a r rho (kOfMom N m))).mulVec
        (fourierUnitary N Psi m) := by
  unfold DovOp Gamma5op Dov
  rw [fourierUnitary_piAdd, fourierUnitary_matrixFieldAction,
    fourierUnitary_signHfree, Matrix.mulVec_mulVec, Matrix.add_mulVec,
    Matrix.one_mulVec]

/-- **Operator-level Ginsparg-Wilson relation.**

The real-space overlap Dirac operator `Dov = 1 + Gamma5 . signHfree` satisfies
the Ginsparg-Wilson relation

    Gamma5 (Dov Psi) + Dov (Gamma5 Psi) = Dov (Gamma5 (Dov Psi))

for a Hermitian unitary chirality `gamma5` anticommuting with the kinetic slash,
throughout the first Wilson band.  Proved by transporting to momentum space
(where `DovOp` block-diagonalizes to the symbol `Dov`) and applying the
per-momentum `symbol_ginsparg_wilson`, then Fourier injectivity - the same
pattern as `signHfree_involutive`.  This lifts the symbol-level chiral release
to the real-space operator. -/
theorem operator_ginsparg_wilson
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgH : star gamma5 = gamma5)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (hpos : ∀ m : MomN N, 0 < sqCoeff D a r rho (kOfMom N m))
    (Psi : SiteN N → Spin → ℂ) :
    Gamma5op N gamma5 (DovOp N gamma5 D a r rho Psi)
        + DovOp N gamma5 D a r rho (Gamma5op N gamma5 Psi) =
      DovOp N gamma5 D a r rho
        (Gamma5op N gamma5 (DovOp N gamma5 D a r rho Psi)) := by
  apply Function.LeftInverse.injective (fourierUnitaryInv_fourierUnitary N)
  funext m
  set v := fourierUnitary N Psi m with hv
  set S := Dov gamma5 (signSymbol gamma5 D a r rho (kOfMom N m)) with hS
  have hgw : gamma5 * S + S * gamma5 = S * gamma5 * S :=
    symbol_ginsparg_wilson gamma5 D a r rho (kOfMom N m) hgU hgH (hanti m) (hpos m)
  -- Fourier-transform both sides into symbol mulVec form.
  have hlhs :
      fourierUnitary N (Gamma5op N gamma5 (DovOp N gamma5 D a r rho Psi)
          + DovOp N gamma5 D a r rho (Gamma5op N gamma5 Psi)) m
        = (gamma5 * S + S * gamma5).mulVec v := by
    unfold Gamma5op
    rw [fourierUnitary_piAdd, fourierUnitary_matrixFieldAction, fourierUnitary_DovOp,
      fourierUnitary_DovOp, fourierUnitary_matrixFieldAction, ← hv, ← hS,
      Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, Matrix.add_mulVec]
  have hrhs :
      fourierUnitary N (DovOp N gamma5 D a r rho
          (Gamma5op N gamma5 (DovOp N gamma5 D a r rho Psi))) m
        = (S * gamma5 * S).mulVec v := by
    unfold Gamma5op
    rw [fourierUnitary_DovOp, fourierUnitary_matrixFieldAction, fourierUnitary_DovOp,
      ← hv, ← hS, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec]
  rw [hlhs, hrhs, hgw]

end TetraOperatorOverlapGW
end GateC1
end NullEdge
end Draft
end PhysicsSM
