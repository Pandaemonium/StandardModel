import PhysicsSM.Draft.NullEdge.GateC1.TetraOperatorOverlapGW

/-!
# Gate C1: operator-level Weyl (chirality) projectors from `sign(Hfree)`

This Draft module is the capstone of the free (no-gauge) overlap / Ginsparg-Wilson
chiral release.  Having proved that the real-space operator `signHfree` is a
self-adjoint involution (`TetraOperatorOverlapGW.lean`:
`signHfree_involutive` + `signHfree_selfAdjoint`), we build its spectral
resolution: the two complementary chirality projectors

    weylProjOpPlus  Psi := (1/2) . (Psi + signHfree Psi)
    weylProjOpMinus Psi := (1/2) . (Psi - signHfree Psi)

and prove they behave as the `+1` / `-1` spectral idempotents of the operator
sign.  Concretely:

* `weylProjOp_add`            : `P_+ + P_- = 1`   (they resolve the identity)
* `weylProjOp_sub_eq_signHfree` : `P_+ - P_- = signHfree`
  (the sign operator IS the spectral difference of its eigenprojectors)
* `weylProjOpPlus_idem`, `weylProjOpMinus_idem` : each is idempotent
* `signHfree_weylProjOpPlus`  : `signHfree (P_+ Psi) = P_+ Psi`
  (the image of `P_+` is exactly the `+1` chirality eigenspace of `sign(Hfree)`)

The first two are pure module algebra (no involution hypothesis needed - they hold
for any linear operator).  Idempotency and the eigenspace identity use the
per-momentum involution `signSymbol_sq` transported to real space by the same
Fourier-transport pattern used throughout the operator-level release
(`fourierUnitary` block-diagonalizes each projector into the symbol-level
`weylProjPlus` / `weylProjMinus`, and Fourier injectivity pulls the matrix
identity back).

Together with `signHfree_selfAdjoint` this exhibits the tetrahedral overlap
regulator's chirality operator as a genuine orthogonal spectral decomposition -
the operator-level statement that the construction has chiral (Weyl) fermions.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem**.  Regulator-level per `docs/NERD_ROADMAP.md`
(free, no gauge).  Successor: Gate C2 (gauge backgrounds, index, anomaly).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraOperatorWeylProjectors

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
open TetraOperatorOverlapGW

variable (N : ℕ) [NeZero N]
variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- The normalized finite Fourier transform is `ℂ`-linear in the field: it
commutes with scalar multiplication. -/
theorem fourierUnitary_piSmul (c : ℂ) (Psi : SiteN N → Spin → ℂ) (m : MomN N) :
    fourierUnitary N (c • Psi) m = c • fourierUnitary N Psi m := by
  funext s
  simp only [fourierUnitary, rawFourier, Pi.smul_apply, smul_eq_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro x _
  ring

/-- `Pi.sub` adapter for `fourierUnitary_sub` (defeq to the explicit-lambda form),
so it rewrites `fourierUnitary N (Psi - Phi) m`. -/
theorem fourierUnitary_piSub (Psi Phi : SiteN N → Spin → ℂ) (m : MomN N) :
    fourierUnitary N (Psi - Phi) m =
      fourierUnitary N Psi m - fourierUnitary N Phi m :=
  fourierUnitary_sub N Psi Phi m

/-- The `+` chirality projector `P_+ = (1 + sign(Hfree))/2`. -/
def weylProjOpPlus (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) : SiteN N → Spin → ℂ :=
  (2 : ℂ)⁻¹ • (Psi + signHfree N gamma5 D a r rho Psi)

/-- The `-` chirality projector `P_- = (1 - sign(Hfree))/2`. -/
def weylProjOpMinus (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) : SiteN N → Spin → ℂ :=
  (2 : ℂ)⁻¹ • (Psi - signHfree N gamma5 D a r rho Psi)

/-- `P_+` is block-diagonalized by the Fourier transform into the per-momentum
symbol projector `weylProjPlus (signSymbol k_m)`. -/
theorem fourierUnitary_weylProjOpPlus
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) (m : MomN N) :
    fourierUnitary N (weylProjOpPlus N gamma5 D a r rho Psi) m =
      (weylProjPlus (signSymbol gamma5 D a r rho (kOfMom N m))).mulVec
        (fourierUnitary N Psi m) := by
  unfold weylProjOpPlus weylProjPlus
  rw [fourierUnitary_piSmul, fourierUnitary_piAdd, fourierUnitary_signHfree,
    Matrix.smul_mulVec, Matrix.add_mulVec, Matrix.one_mulVec]

/-- `P_-` is block-diagonalized by the Fourier transform into the per-momentum
symbol projector `weylProjMinus (signSymbol k_m)`. -/
theorem fourierUnitary_weylProjOpMinus
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) (m : MomN N) :
    fourierUnitary N (weylProjOpMinus N gamma5 D a r rho Psi) m =
      (weylProjMinus (signSymbol gamma5 D a r rho (kOfMom N m))).mulVec
        (fourierUnitary N Psi m) := by
  unfold weylProjOpMinus weylProjMinus
  rw [fourierUnitary_piSmul, fourierUnitary_piSub, fourierUnitary_signHfree,
    Matrix.smul_mulVec, Matrix.sub_mulVec, Matrix.one_mulVec]

/-- **The chirality projectors resolve the identity**: `P_+ + P_- = 1`.  Pure
module algebra - holds for any operator, independent of the involution. -/
theorem weylProjOp_add
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) :
    weylProjOpPlus N gamma5 D a r rho Psi
        + weylProjOpMinus N gamma5 D a r rho Psi = Psi := by
  simp only [weylProjOpPlus, weylProjOpMinus]
  set S := signHfree N gamma5 D a r rho Psi
  module

/-- **The operator sign is the spectral difference of its projectors**:
`P_+ - P_- = sign(Hfree)`.  Pure module algebra.  Together with `weylProjOp_add`
this is the spectral resolution of the involution `signHfree`. -/
theorem weylProjOp_sub_eq_signHfree
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) :
    weylProjOpPlus N gamma5 D a r rho Psi
        - weylProjOpMinus N gamma5 D a r rho Psi
      = signHfree N gamma5 D a r rho Psi := by
  simp only [weylProjOpPlus, weylProjOpMinus]
  set S := signHfree N gamma5 D a r rho Psi
  module

/-- **Idempotency of `P_+`** (from the operator involution `signHfree_involutive`,
via the symbol idempotent `weylProjPlus_idem` transported through the Fourier
isomorphism). -/
theorem weylProjOpPlus_idem
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgH : star gamma5 = gamma5)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (hpos : ∀ m : MomN N, 0 < sqCoeff D a r rho (kOfMom N m))
    (Psi : SiteN N → Spin → ℂ) :
    weylProjOpPlus N gamma5 D a r rho
        (weylProjOpPlus N gamma5 D a r rho Psi)
      = weylProjOpPlus N gamma5 D a r rho Psi := by
  apply Function.LeftInverse.injective (fourierUnitaryInv_fourierUnitary N)
  funext m
  simp only [fourierUnitary_weylProjOpPlus, Matrix.mulVec_mulVec]
  rw [weylProjPlus_idem _
    (signSymbol_sq gamma5 D a r rho (kOfMom N m) hgU hgH (hanti m) (hpos m))]

/-- **Idempotency of `P_-`** (same pattern, via `weylProjMinus_idem`). -/
theorem weylProjOpMinus_idem
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgH : star gamma5 = gamma5)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (hpos : ∀ m : MomN N, 0 < sqCoeff D a r rho (kOfMom N m))
    (Psi : SiteN N → Spin → ℂ) :
    weylProjOpMinus N gamma5 D a r rho
        (weylProjOpMinus N gamma5 D a r rho Psi)
      = weylProjOpMinus N gamma5 D a r rho Psi := by
  apply Function.LeftInverse.injective (fourierUnitaryInv_fourierUnitary N)
  funext m
  simp only [fourierUnitary_weylProjOpMinus, Matrix.mulVec_mulVec]
  rw [weylProjMinus_idem _
    (signSymbol_sq gamma5 D a r rho (kOfMom N m) hgU hgH (hanti m) (hpos m))]

/-- Both chirality projectors are idempotent throughout the first Wilson band
(the operator-level counterpart of `signSymbol_weylProj_idem`). -/
theorem signHfree_weylProjOp_idem
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgH : star gamma5 = gamma5)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (hpos : ∀ m : MomN N, 0 < sqCoeff D a r rho (kOfMom N m))
    (Psi : SiteN N → Spin → ℂ) :
    weylProjOpPlus N gamma5 D a r rho
          (weylProjOpPlus N gamma5 D a r rho Psi)
        = weylProjOpPlus N gamma5 D a r rho Psi
    ∧ weylProjOpMinus N gamma5 D a r rho
          (weylProjOpMinus N gamma5 D a r rho Psi)
        = weylProjOpMinus N gamma5 D a r rho Psi :=
  ⟨weylProjOpPlus_idem N gamma5 D a r rho hgU hgH hanti hpos Psi,
   weylProjOpMinus_idem N gamma5 D a r rho hgU hgH hanti hpos Psi⟩

/-- **The image of `P_+` is the `+1` chirality eigenspace of `sign(Hfree)`**:
`signHfree (P_+ Psi) = P_+ Psi`.  This is the precise operator-level statement
that the tetrahedral overlap regulator carries chiral (Weyl) fermions - the
`+` projector picks out the definite-chirality subspace on which the sign acts
as the identity.  Proved by transporting `eps . weylProjPlus eps = weylProjPlus
eps` (from `eps^2 = 1`) through the Fourier isomorphism. -/
theorem signHfree_weylProjOpPlus
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hgU : star gamma5 * gamma5 = (1 : Matrix Spin Spin ℂ))
    (hgH : star gamma5 = gamma5)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (hpos : ∀ m : MomN N, 0 < sqCoeff D a r rho (kOfMom N m))
    (Psi : SiteN N → Spin → ℂ) :
    signHfree N gamma5 D a r rho (weylProjOpPlus N gamma5 D a r rho Psi)
      = weylProjOpPlus N gamma5 D a r rho Psi := by
  apply Function.LeftInverse.injective (fourierUnitaryInv_fourierUnitary N)
  funext m
  have hmul : signSymbol gamma5 D a r rho (kOfMom N m)
        * weylProjPlus (signSymbol gamma5 D a r rho (kOfMom N m))
      = weylProjPlus (signSymbol gamma5 D a r rho (kOfMom N m)) := by
    unfold weylProjPlus
    rw [Matrix.mul_smul, Matrix.mul_add, Matrix.mul_one,
      signSymbol_sq gamma5 D a r rho (kOfMom N m) hgU hgH (hanti m) (hpos m)]
    congr 1
    abel
  simp only [fourierUnitary_signHfree, fourierUnitary_weylProjOpPlus,
    Matrix.mulVec_mulVec, hmul]

end TetraOperatorWeylProjectors
end GateC1
end NullEdge
end Draft
end PhysicsSM
