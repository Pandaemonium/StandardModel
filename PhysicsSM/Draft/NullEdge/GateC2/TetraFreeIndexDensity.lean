import PhysicsSM.Draft.NullEdge.GateC1.TetraOperatorOverlapGW
import PhysicsSM.Draft.NullEdge.GateC2.TetraFreeIndexZero

/-!
# Gate C2: the free tetrahedral index DENSITY vanishes site-wise

This Draft module builds the first rung of the index-density / anomaly bridge for
the tetrahedral overlap construction: it exhibits the real-space **kernel** of the
operator sign `sign(Hfree)` and proves that the **local index density**

    q(x) := (1/2) . (Tr_spin gamma5 - Tr_spin K(x, x))

vanishes at EVERY site `x` (for traceless chirality, throughout the first Wilson
band).  This is the local sharpening of the global free-index-zero benchmark
(`TetraFreeIndexZero.tetraFreeOverlapIndex_eq_zero`): the free theory carries no
topology not merely in total, but site-by-site.

## Contents

* `signKernel` - the real-space kernel of `signHfree`:
  `K(x,y) = nf^2 . sum_m conj(chi_m(x)) chi_m(y) . signSymbol(k_m)`, and
  `signHfree_apply_eq_kernel_sum` proving `signHfree Psi x = sum_y K(x,y) Psi(y)`.
* `fourierChar_star_mul_self` - pointwise unit modulus of the characters.
* `signKernel_diag` - **translation invariance of the diagonal**:
  `K(x,x) = nf^2 . sum_m signSymbol(k_m)` is independent of `x`.
* `trace_signSymbol_eq_zero` - the per-momentum sign symbol is traceless
  (chirality anticommutation + trace cyclicity + traceless `gamma5`).
* `freeIndexDensity` and `freeIndexDensity_eq_zero` - the local index density
  vanishes at every site.

## Scope honesty

This is the FREE density only.  The interesting object - the payoff of the
anomaly/index-density program - is the gauge-background deformation of `q(x)`
(where the density becomes the topological charge density); that requires the
gauge operator (open C2 frontier) and is NOT attempted here.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (free local index density; regulator-level,
no gauge).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace TetraFreeIndexDensity

open PhysicsSM.Draft.NullEdge.GateC1.TetraFiniteTorusEqual
open PhysicsSM.Draft.NullEdge.GateC1.TetraCharactersEqual
open PhysicsSM.Draft.NullEdge.GateC1.TetraScalarWilsonSymbol
open PhysicsSM.Draft.NullEdge.GateC1.TetraQMatrixSquareExact
open PhysicsSM.Draft.NullEdge.GateC1.TetraSymbolOverlapGW
open PhysicsSM.Draft.NullEdge.GateC1.TetraPhaseTrigEqual
open PhysicsSM.Draft.NullEdge.GateC1.TetraFourierInverse
open PhysicsSM.Draft.NullEdge.GateC1.TetraFreeOperator
open PhysicsSM.Draft.NullEdge.GateC1.TetraOperatorOverlapGW
open PhysicsSM.Draft.NullEdge.GateC2.TetraFreeIndexZero

variable (N : ℕ) [NeZero N]
variable {Spin : Type*} [Fintype Spin] [DecidableEq Spin]

/-- Pointwise unit modulus of the Fourier characters:
`conj(chi_m(x)) . chi_m(x) = 1`. -/
theorem fourierChar_star_mul_self (m : MomN N) (x : SiteN N) :
    star (fourierChar N m x) * fourierChar N m x = 1 := by
  have hneg : star (fourierChar N m x) = fourierChar N m (-x) := by
    rw [AddChar.map_neg_eq_conj, starRingEnd_apply]
  rw [hneg, ← AddChar.map_add_eq_mul, neg_add_cancel, AddChar.map_zero_eq_one]

/-- The real-space kernel of the operator sign `sign(Hfree)`:
`K(x,y) = nf^2 . sum_m conj(chi_m(x)) chi_m(y) . signSymbol(k_m)`. -/
def signKernel (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (x y : SiteN N) : Matrix Spin Spin ℂ :=
  ((fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ)) •
    ∑ m : MomN N, (star (fourierChar N m x) * fourierChar N m y) •
      signSymbol gamma5 D a r rho (kOfMom N m)

/-- `signHfree` acts by the kernel: `signHfree Psi x = sum_y K(x,y).mulVec (Psi y)`.
This identifies `signKernel` as the honest position-space integral kernel of the
operator sign. -/
theorem signHfree_apply_eq_kernel_sum (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (Psi : SiteN N → Spin → ℂ) (x : SiteN N) :
    signHfree N gamma5 D a r rho Psi x
      = ∑ y : SiteN N, (signKernel N gamma5 D a r rho x y).mulVec (Psi y) := by
  funext s
  unfold signHfree fourierUnitaryInv fourierUnitary rawFourier signKernel
  simp only [Matrix.mulVec, dotProduct, Matrix.smul_apply, Matrix.sum_apply,
    Finset.sum_apply, smul_eq_mul, Finset.mul_sum]
  -- Reorder the three finite sums so both sides have the same site/spin/momentum
  -- nesting, then discharge the scalar associativity.
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro t _
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro y _
  apply Finset.sum_congr rfl
  intro m _
  ring

/-- **Translation invariance of the kernel diagonal**: `K(x,x)` is the same
matrix at every site, `nf^2 . sum_m signSymbol(k_m)` (the momentum average of the
sign symbols). -/
theorem signKernel_diag (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (x : SiteN N) :
    signKernel N gamma5 D a r rho x x
      = ((fourierNormFactor N : ℂ) * (fourierNormFactor N : ℂ)) •
          ∑ m : MomN N, signSymbol gamma5 D a r rho (kOfMom N m) := by
  unfold signKernel
  congr 1
  apply Finset.sum_congr rfl
  intro m _
  rw [fourierChar_star_mul_self, one_smul]

/-- **The per-momentum sign symbol is traceless** (traceless chirality, from the
chirality anticommutation and trace cyclicity; the Wilson mass term contributes
`mWilson . Tr gamma5 = 0`). -/
theorem trace_signSymbol_eq_zero (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (k : Fin 4 → ℝ)
    (hanti : gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs k)
        + TetraEuclideanSlashData.Q D (sinCoeffs k) * gamma5 = 0)
    (hg5tr : gamma5.trace = 0) :
    (signSymbol gamma5 D a r rho k).trace = 0 := by
  have hgQ : (gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs k)).trace = 0 :=
    trace_gamma5_mul_Q_eq_zero _ _ hanti
  unfold signSymbol
    PhysicsSM.Draft.NullEdge.GateC1.TetraScalarWilsonSymbol.H
    PhysicsSM.Draft.NullEdge.GateC1.TetraScalarWilsonSymbol.K
  simp only [Matrix.mul_smul, Matrix.mul_add, Matrix.mul_one, Matrix.trace_smul,
    Matrix.trace_add, smul_eq_mul, hgQ, hg5tr, mul_zero, add_zero]

/-- The **local index density** of the free tetrahedral overlap at site `x`:
`q(x) = (1/2)(Tr gamma5 - Tr K(x,x))`. -/
def freeIndexDensity (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ) (x : SiteN N) : ℂ :=
  (2 : ℂ)⁻¹ * (gamma5.trace - (signKernel N gamma5 D a r rho x x).trace)

/-- **The free index density vanishes at every site** (traceless chirality,
first Wilson band): the free tetrahedral overlap carries no topology locally, not
merely in total.  First rung of the index-density / anomaly bridge; the gauge
deformation of this density (where it becomes the topological charge density) is
the open C2 frontier. -/
theorem freeIndexDensity_eq_zero (gamma5 : Matrix Spin Spin ℂ)
    (D : TetraEuclideanSlashData Spin) (a r rho : ℝ)
    (hanti : ∀ m : MomN N,
      gamma5 * TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m))
        + TetraEuclideanSlashData.Q D (sinCoeffs (kOfMom N m)) * gamma5 = 0)
    (hg5tr : gamma5.trace = 0) (x : SiteN N) :
    freeIndexDensity N gamma5 D a r rho x = 0 := by
  unfold freeIndexDensity
  rw [signKernel_diag, Matrix.trace_smul, Matrix.trace_sum,
    Finset.sum_eq_zero (fun m _ =>
      trace_signSymbol_eq_zero gamma5 D a r rho (kOfMom N m) (hanti m) hg5tr),
    hg5tr]
  simp

end TetraFreeIndexDensity
end GateC2
end NullEdge
end Draft
end PhysicsSM
