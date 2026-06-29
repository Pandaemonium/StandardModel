import PhysicsSM.Draft.NullEdge.GateC1.TetraPhaseTrigEqual

/-!
# Equal-side tetrahedral free operator glue

This module starts the real-space finite/free operator layer for Gate C1.

The preceding files prove that each primitive transport piece is diagonalized
by the normalized finite Fourier transform.  Here we add the linear algebra
glue needed to assemble those pieces into the Wilson/free operator whose
momentum symbol is the already-checked scalar Wilson symbol in
`TetraScalarWilsonSymbol`.

The first results are deliberately small:

* the normalized finite Fourier transform commutes with constant spin-matrix
  action;
* it is linear over pointwise scalar multiplication and finite sums of fields.

These lemmas are the reusable bridge for the next theorem:
`fourierUnitary_Kfree`, the real-space finite operator intertwining with the
symbol `K`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraFreeOperator

open scoped BigOperators
open TetraFiniteTorusEqual
open TetraCharactersEqual
open TetraPhaseTrigEqual
open TetraScalarWilsonSymbol
open TetraQMatrixSquareExact

variable (N : ℕ) [NeZero N]
variable {Spin : Type*} [Fintype Spin]

/-- Pointwise action of a constant spin matrix on a finite field. -/
def matrixFieldAction (M : Matrix Spin Spin ℂ)
    (Psi : SiteN N -> Spin -> ℂ) : SiteN N -> Spin -> ℂ :=
  fun x => M.mulVec (Psi x)

/-- Pointwise multiplication of a finite field by a complex scalar. -/
def scalarFieldAction (c : ℂ)
    (Psi : SiteN N -> Spin -> ℂ) : SiteN N -> Spin -> ℂ :=
  fun x s => c * Psi x s

/-- The normalized finite Fourier transform is linear over pointwise scalar
multiplication. -/
theorem fourierUnitary_scalarFieldAction (c : ℂ)
    (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (scalarFieldAction N c Psi) m =
      fun s => c * fourierUnitary N Psi m s := by
  funext s
  unfold fourierUnitary rawFourier scalarFieldAction
  calc
    (fourierNormFactor N : ℂ) *
        (∑ x : SiteN N, fourierChar N m x * (c * Psi x s))
        =
      (fourierNormFactor N : ℂ) *
        (∑ x : SiteN N, c * (fourierChar N m x * Psi x s)) := by
          congr 1
          apply Finset.sum_congr rfl
          intro x _hx
          ring
    _ =
      (fourierNormFactor N : ℂ) *
        (c * ∑ x : SiteN N, fourierChar N m x * Psi x s) := by
          calc
            (fourierNormFactor N : ℂ) *
                (∑ x : SiteN N, c * (fourierChar N m x * Psi x s))
                =
              ∑ x : SiteN N,
                ((fourierNormFactor N : ℂ) * c) *
                  (fourierChar N m x * Psi x s) := by
                  rw [Finset.mul_sum]
                  apply Finset.sum_congr rfl
                  intro x _hx
                  ring
            _ =
              (fourierNormFactor N : ℂ) * c *
                ∑ x : SiteN N, fourierChar N m x * Psi x s := by
                  rw [Finset.mul_sum]
            _ =
              (fourierNormFactor N : ℂ) *
                (c * ∑ x : SiteN N, fourierChar N m x * Psi x s) := by
                  ring
    _ =
      c * ((fourierNormFactor N : ℂ) *
        ∑ x : SiteN N, fourierChar N m x * Psi x s) := by
          ring

/-- The normalized finite Fourier transform distributes over pointwise field
addition. -/
theorem fourierUnitary_add
    (Psi Phi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (fun x s => Psi x s + Phi x s) m =
      fun s => fourierUnitary N Psi m s + fourierUnitary N Phi m s := by
  funext s
  unfold fourierUnitary rawFourier
  simp_rw [mul_add]
  rw [Finset.sum_add_distrib]
  ring

/-- The normalized finite Fourier transform distributes over pointwise field
subtraction. -/
theorem fourierUnitary_sub
    (Psi Phi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (fun x s => Psi x s - Phi x s) m =
      fun s => fourierUnitary N Psi m s - fourierUnitary N Phi m s := by
  funext s
  unfold fourierUnitary rawFourier
  simp_rw [mul_sub]
  rw [Finset.sum_sub_distrib]
  ring

/-- The normalized finite Fourier transform distributes over pointwise finite
sums of fields. -/
theorem fourierUnitary_finset_sum
    {ι : Type*} (S : Finset ι) (F : ι -> SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (fun x s => S.sum (fun i => F i x s)) m =
      fun s => S.sum (fun i => fourierUnitary N (F i) m s) := by
  funext s
  unfold fourierUnitary rawFourier
  calc
    (fourierNormFactor N : ℂ) *
        (∑ x : SiteN N, fourierChar N m x * S.sum (fun i => F i x s))
        =
      (fourierNormFactor N : ℂ) *
        (∑ x : SiteN N, S.sum (fun i => fourierChar N m x * F i x s)) := by
          congr 1
          apply Finset.sum_congr rfl
          intro x _hx
          rw [Finset.mul_sum]
    _ =
      (fourierNormFactor N : ℂ) *
        (S.sum (fun i =>
          ∑ x : SiteN N, fourierChar N m x * F i x s)) := by
          rw [Finset.sum_comm]
    _ =
      S.sum (fun i =>
        (fourierNormFactor N : ℂ) *
          (∑ x : SiteN N, fourierChar N m x * F i x s)) := by
          rw [Finset.mul_sum]

/-- The normalized finite Fourier transform commutes with constant spin-matrix
action. -/
theorem fourierUnitary_matrixFieldAction (M : Matrix Spin Spin ℂ)
    (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (matrixFieldAction N M Psi) m =
      M.mulVec (fourierUnitary N Psi m) := by
  funext s
  unfold fourierUnitary rawFourier matrixFieldAction Matrix.mulVec
  calc
    (fourierNormFactor N : ℂ) *
        (∑ x : SiteN N,
          fourierChar N m x * ∑ s' : Spin, M s s' * Psi x s')
        =
      (fourierNormFactor N : ℂ) *
        (∑ x : SiteN N,
          ∑ s' : Spin, M s s' * (fourierChar N m x * Psi x s')) := by
          congr 1
          apply Finset.sum_congr rfl
          intro x _hx
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro s' _hs'
          ring
    _ =
      (fourierNormFactor N : ℂ) *
        (∑ s' : Spin,
          ∑ x : SiteN N, M s s' * (fourierChar N m x * Psi x s')) := by
          rw [Finset.sum_comm]
    _ =
      ∑ s' : Spin,
        M s s' *
          ((fourierNormFactor N : ℂ) *
            ∑ x : SiteN N, fourierChar N m x * Psi x s') := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro s' _hs'
          rw [← Finset.mul_sum]
          ring

/-- The summed Wilson radial field `sum_A (2 - T_A - T_A^{-1})`. -/
def wilsonRadialField
    (Psi : SiteN N -> Spin -> ℂ) : SiteN N -> Spin -> ℂ :=
  fun x s => ∑ A : Fin 4, wilsonLaplacianField N A Psi x s

/-- The scalar Wilson mass field
`(r/2) sum_A (2 - T_A - T_A^{-1}) - rho`. -/
def scalarWilsonMassField (r rho : ℝ)
    (Psi : SiteN N -> Spin -> ℂ) : SiteN N -> Spin -> ℂ :=
  fun x s =>
    ((r : ℂ) / 2) * wilsonRadialField N Psi x s - (rho : ℂ) * Psi x s

/-- Normalized Fourier diagonalization of the summed Wilson radial field. -/
theorem fourierUnitary_wilsonRadialField_trig
    (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (wilsonRadialField N Psi) m =
      fun s =>
        ∑ A : Fin 4,
          (2 * (1 - (Real.cos ((kOfMom N m) A) : ℂ))) *
            fourierUnitary N Psi m s := by
  unfold wilsonRadialField
  rw [fourierUnitary_finset_sum N Finset.univ
    (fun A => wilsonLaplacianField N A Psi) m]
  funext s
  apply Finset.sum_congr rfl
  intro A _hA
  simpa using
    congrFun (fourierUnitary_wilsonLaplacianField_trig N A Psi m) s

/-- Normalized Fourier diagonalization of the scalar Wilson mass field. -/
theorem fourierUnitary_scalarWilsonMassField_trig (r rho : ℝ)
    (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (scalarWilsonMassField N r rho Psi) m =
      fun s =>
        ((mWilson r rho (kOfMom N m) : ℝ) : ℂ) *
          fourierUnitary N Psi m s := by
  unfold scalarWilsonMassField
  rw [show
      (fun x s =>
        (↑r / 2) * wilsonRadialField N Psi x s - ↑rho * Psi x s) =
        (fun x s =>
          scalarFieldAction N (↑r / 2) (wilsonRadialField N Psi) x s -
            scalarFieldAction N (rho : ℂ) Psi x s) by rfl]
  rw [fourierUnitary_sub]
  rw [fourierUnitary_scalarFieldAction, fourierUnitary_scalarFieldAction]
  rw [fourierUnitary_wilsonRadialField_trig]
  funext s
  unfold mWilson
  simp only [Complex.ofReal_sub, Complex.ofReal_mul, Complex.ofReal_sum,
    Complex.ofReal_one, Complex.ofReal_cos, Finset.mul_sum]
  ring_nf
  congr 1
  calc
    ∑ x : Fin 4,
        (-(↑r * Complex.cos ↑(kOfMom N m x) * fourierUnitary N Psi m s) +
          ↑r * fourierUnitary N Psi m s)
        =
      ∑ x : Fin 4,
        fourierUnitary N Psi m s *
          (↑r - ↑r * Complex.cos ↑(kOfMom N m x)) := by
          apply Finset.sum_congr rfl
          intro x _hx
          ring
    _ =
      fourierUnitary N Psi m s *
        ∑ x : Fin 4, (↑r - ↑r * Complex.cos ↑(kOfMom N m x)) := by
          rw [Finset.mul_sum]

end TetraFreeOperator
end GateC1
end NullEdge
end Draft
end PhysicsSM
