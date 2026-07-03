import PhysicsSM.Draft.NullEdge.GateC1.TetraFreeOperator
import PhysicsSM.Draft.NullEdge.GateC1.TetraSymbolHermitian

/-!
# Gate C1: real-space self-adjointness of the free operator `Hfree`

This Draft module completes the Gate C1 self-adjointness rung: the real-space
finite/free operator `Hfree` on the equal-side tetrahedral torus is self-adjoint
with respect to the finite field inner product, provided the chirality `gamma5`
is Hermitian and anticommutes with the kinetic slash `Q`.

It supplies the two pieces the C1 gap semantic red-team (Aristotle `ffed1801`,
finding 5b) flagged as missing:

* a **sesquilinear field inner product** `fieldInner` and its **inner-product
  Parseval** `fourierUnitary_inner_siteN` (the sesquilinear analogue of
  `TetraCharactersEqual.fourierUnitary_l2NormSq_siteN`), proved by mirroring the
  norm-Parseval chain with a distinct right slot; and
* the **per-block adjoint move** lifting the momentum-symbol Hermiticity
  `TetraSymbolHermitian.H_symbol_hermitian` to real space.

Combined with `TetraFreeOperator.fourierUnitary_Hfree_trig` (Fourier
diagonalization of `Hfree`), self-adjointness follows: the Fourier transform is
an inner-product isometry, `Hfree` acts blockwise by the Hermitian symbols
`H(k_m)`, and Hermiticity transports back.

Together with `TetraFreeOperatorGapEqualN.tetraFreeOperator_gap_equalN` (the
coercive gap, under its unitary `gamma5` hypothesis), this gives the two
standing prerequisites for the overlap `sign(Hfree)` / Ginsparg-Wilson release:
a self-adjoint, gapped free operator.

## Status and claim scope

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem**.  Regulator-level per `docs/NERD_ROADMAP.md`.
The self-adjointness upgrades the earlier *coercive* inverse-propagator gap to a
genuine self-adjoint operator; the spectral-gap reading of the coercive bound is
now unambiguous when the gap theorem's unitary `gamma5` hypothesis is combined
with the Hermiticity and anticommutation hypotheses assumed here.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraFreeOperatorSelfAdjoint

open scoped BigOperators
open TetraFiniteTorusEqual
open TetraCharactersEqual
open TetraScalarWilsonSymbol
open TetraQMatrixSquareExact
open TetraPhaseTrigEqual
open TetraFreeOperator
open TetraSymbolHermitian
open FiniteFourierParseval

variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- Finite field inner product on spinor fields over the site torus:
`<Psi, Phi> = sum_x sum_s conj (Psi x s) * (Phi x s)`. -/
def fieldInner (N : ℕ) [NeZero N] (Psi Phi : SiteN N → Spin → ℂ) : ℂ :=
  ∑ x : SiteN N, ∑ s : Spin, star (Psi x s) * Phi x s

/-- Block-sum inner product on momentum-space fields:
`sum_m sum_s conj (phi m s) * (psi m s)`. -/
def blockInner (N : ℕ) [NeZero N] (phi psi : MomN N → Spin → ℂ) : ℂ :=
  ∑ m : MomN N, ∑ s : Spin, star (phi m s) * psi m s

/-- **Sesquilinear rectangular bridge.** If `A^* A = coeff I` then the finite
inner product transported through `A` is scaled by `coeff`.  This is the
distinct-slot generalization of
`FiniteFourierParseval.l2NormSq_mulVec_of_star_mul_eq_smul_one_rect`, proved by
the same `vecMul`/`dotProduct` calc keeping the right argument `w` distinct. -/
theorem dotProduct_mulVec_of_star_mul_eq_smul_one_rect
    {rows cols : Type*} [Fintype rows] [Fintype cols] [DecidableEq cols]
    (A : Matrix rows cols ℂ) (coeff : ℂ)
    (hA : Matrix.conjTranspose A * A = coeff • (1 : Matrix cols cols ℂ))
    (v w : cols → ℂ) :
    star (A.mulVec v) ⬝ᵥ A.mulVec w = coeff * (star v ⬝ᵥ w) := by
  calc
    star (A.mulVec v) ⬝ᵥ A.mulVec w
        = Matrix.vecMul (star v) (Matrix.conjTranspose A) ⬝ᵥ A.mulVec w := by
          rw [Matrix.star_mulVec]
    _ = Matrix.vecMul (Matrix.vecMul (star v) (Matrix.conjTranspose A)) A ⬝ᵥ w := by
          rw [Matrix.dotProduct_mulVec]
    _ = Matrix.vecMul (star v) (Matrix.conjTranspose A * A) ⬝ᵥ w := by
          rw [Matrix.vecMul_vecMul]
    _ = Matrix.vecMul (star v) (coeff • (1 : Matrix cols cols ℂ)) ⬝ᵥ w := by
          rw [hA]
    _ = coeff * (star v ⬝ᵥ w) := by
          simp [Matrix.vecMul_smul, Matrix.vecMul_one, smul_dotProduct,
            smul_eq_mul]

/-- **Raw sesquilinear Parseval** for the equal-side tetrahedral Fourier
transform: `blockInner (rawFourier Psi) (rawFourier Phi)
= card(SiteN) * fieldInner Psi Phi`. -/
theorem rawFourier_inner_siteN (N : ℕ) [NeZero N]
    (Psi Phi : SiteN N → Spin → ℂ) :
    blockInner N (rawFourier N Psi) (rawFourier N Phi) =
      (Fintype.card (SiteN N) : ℂ) * fieldInner N Psi Phi := by
  have hchar :
      Matrix.conjTranspose (characterMatrix (fun m x => fourierChar N m x)) *
          characterMatrix (fun m x => fourierChar N m x) =
        ((Fintype.card (SiteN N) : ℝ) : ℂ) •
          (1 : Matrix (SiteN N) (SiteN N) ℂ) :=
    characterMatrix_star_mul_of_column_orthogonality
      (fun m x => fourierChar N m x) (Fintype.card (SiteN N) : ℝ)
      (by intro x y; simpa using fourierChar_column_orthogonality N x y)
  -- Per spin component, `rawFourier` is `A.mulVec` of the fixed-spin slice.
  have hslice :
      ∀ s : Spin,
        (∑ m : MomN N, star (rawFourier N Psi m s) * rawFourier N Phi m s)
          = ((Fintype.card (SiteN N) : ℝ) : ℂ) *
              (∑ x : SiteN N, star (Psi x s) * Phi x s) := by
    intro s
    have hL :
        star ((characterMatrix (fun m x => fourierChar N m x)).mulVec
              (fun x => Psi x s)) ⬝ᵥ
            (characterMatrix (fun m x => fourierChar N m x)).mulVec
              (fun x => Phi x s)
          = ((Fintype.card (SiteN N) : ℝ) : ℂ) *
              (star (fun x => Psi x s) ⬝ᵥ (fun x => Phi x s)) :=
      dotProduct_mulVec_of_star_mul_eq_smul_one_rect
        (characterMatrix (fun m x => fourierChar N m x))
        ((Fintype.card (SiteN N) : ℝ) : ℂ) hchar
        (fun x => Psi x s) (fun x => Phi x s)
    simpa [Matrix.mulVec, characterMatrix, dotProduct, rawFourier] using hL
  calc
    blockInner N (rawFourier N Psi) (rawFourier N Phi)
        = ∑ s : Spin, ∑ m : MomN N,
            star (rawFourier N Psi m s) * rawFourier N Phi m s := by
          rw [blockInner, Finset.sum_comm]
    _ = ∑ s : Spin, ((Fintype.card (SiteN N) : ℝ) : ℂ) *
            (∑ x : SiteN N, star (Psi x s) * Phi x s) := by
          exact Finset.sum_congr rfl (fun s _ => hslice s)
    _ = (Fintype.card (SiteN N) : ℂ) * fieldInner N Psi Phi := by
          have hfield : fieldInner N Psi Phi
              = ∑ s : Spin, ∑ x : SiteN N, star (Psi x s) * Phi x s := by
            rw [fieldInner, Finset.sum_comm]
          rw [hfield, ← Finset.mul_sum]
          push_cast
          ring

/-- **Normalized sesquilinear Parseval**: the normalized finite Fourier
transform preserves the finite field inner product,
`blockInner (fourierUnitary Psi) (fourierUnitary Phi) = fieldInner Psi Phi`. -/
theorem fourierUnitary_inner_siteN (N : ℕ) [NeZero N]
    (Psi Phi : SiteN N → Spin → ℂ) :
    blockInner N (fourierUnitary N Psi) (fourierUnitary N Phi) =
      fieldInner N Psi Phi := by
  have hraw := rawFourier_inner_siteN N Psi Phi
  have hnf : ((fourierNormFactor N : ℂ)) * (fourierNormFactor N : ℂ) *
      (Fintype.card (SiteN N) : ℂ) = 1 := by
    exact_mod_cast fourierNormFactor_sq_mul_card N
  have hexpand :
      blockInner N (fourierUnitary N Psi) (fourierUnitary N Phi)
        = ((fourierNormFactor N : ℂ)) * (fourierNormFactor N : ℂ) *
            blockInner N (rawFourier N Psi) (rawFourier N Phi) := by
    unfold blockInner fourierUnitary
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro m _
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro s _
    rw [Complex.star_def, map_mul, Complex.conj_ofReal]
    ring
  rw [hexpand, hraw]
  calc
    (fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) *
        ((Fintype.card (SiteN N) : ℂ) * fieldInner N Psi Phi)
        = ((fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ) *
            (Fintype.card (SiteN N) : ℂ)) * fieldInner N Psi Phi := by ring
    _ = fieldInner N Psi Phi := by rw [hnf]; ring

/-- **Real-space self-adjointness of `Hfree`.**

For a Hermitian chirality `gamma5` (`star gamma5 = gamma5`) that anticommutes
with the kinetic slash `Q` at every discrete momentum
(`gamma5 * Q(kOfMom m) + Q(kOfMom m) * gamma5 = 0`), the finite/free operator
`Hfree` is self-adjoint for the finite field inner product:

`fieldInner (Hfree Psi) Phi = fieldInner Psi (Hfree Phi)`.

Proof: the normalized Fourier transform is an inner-product isometry
(`fourierUnitary_inner_siteN`); `Hfree` acts blockwise by the momentum symbols
`H(kOfMom m)` (`fourierUnitary_Hfree_trig`); each symbol is Hermitian
(`H_symbol_hermitian`), so the per-block adjoint move transports Hermiticity
back through the isometry. -/
theorem Hfree_selfAdjoint (N : ℕ) [NeZero N]
    (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hg : star gamma5 = gamma5)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (Psi Phi : SiteN N → Spin → ℂ) :
    fieldInner N (Hfree N gamma5 D a r rho Psi) Phi =
      fieldInner N Psi (Hfree N gamma5 D a r rho Phi) := by
  -- Move both sides to momentum space.
  rw [← fourierUnitary_inner_siteN N (Hfree N gamma5 D a r rho Psi) Phi,
      ← fourierUnitary_inner_siteN N Psi (Hfree N gamma5 D a r rho Phi)]
  unfold blockInner
  apply Finset.sum_congr rfl
  intro m _
  -- Diagonalize Hfree on each side.
  have hHsym : star (H gamma5 D a r rho (kOfMom N m)) = H gamma5 D a r rho (kOfMom N m) :=
    H_symbol_hermitian gamma5 D a r rho (kOfMom N m) hg (hanti m)
  have hdiagL := fourierUnitary_Hfree_trig N gamma5 D a r rho Psi m
  have hdiagR := fourierUnitary_Hfree_trig N gamma5 D a r rho Phi m
  -- Per-block adjoint: <H v, w> = <v, H w> using star H = H.
  have hadj :
      star ((H gamma5 D a r rho (kOfMom N m)).mulVec (fourierUnitary N Psi m)) ⬝ᵥ
          (fourierUnitary N Phi m)
        = star (fourierUnitary N Psi m) ⬝ᵥ
            (H gamma5 D a r rho (kOfMom N m)).mulVec (fourierUnitary N Phi m) := by
    rw [Matrix.star_mulVec, ← Matrix.dotProduct_mulVec,
      ← Matrix.star_eq_conjTranspose, hHsym]
  -- Assemble.
  have hL : (∑ s : Spin, star (fourierUnitary N (Hfree N gamma5 D a r rho Psi) m s) *
      fourierUnitary N Phi m s)
      = star ((H gamma5 D a r rho (kOfMom N m)).mulVec (fourierUnitary N Psi m)) ⬝ᵥ
          (fourierUnitary N Phi m) := by
    rw [hdiagL]; rfl
  have hR : (∑ s : Spin, star (fourierUnitary N Psi m s) *
      fourierUnitary N (Hfree N gamma5 D a r rho Phi) m s)
      = star (fourierUnitary N Psi m) ⬝ᵥ
          (H gamma5 D a r rho (kOfMom N m)).mulVec (fourierUnitary N Phi m) := by
    rw [hdiagR]; rfl
  rw [hL, hR, hadj]

end TetraFreeOperatorSelfAdjoint
end GateC1
end NullEdge
end Draft
end PhysicsSM
