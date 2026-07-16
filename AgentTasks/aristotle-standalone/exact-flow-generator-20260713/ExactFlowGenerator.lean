import PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE

/-!
# Pointwise generator of the exact Dirac momentum flow

This focused target identifies the infinitesimal time generator of the actual
matrix exponential used by the live continuum lane.  It deliberately remains
at one momentum fibre.  In particular, it does not assert an unbounded
generator on the full momentum-space `L2`, choose its domain, transport the
identity through Fourier transform, or prove the position-space Dirac PDE.
-/

noncomputable section

open Matrix Complex
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.ExactFlowGenerator

open ChangingCellFourierL2
open ChangingCellFourierPDE
open ChangingCellScaledLiveWalk
open Compact3Plus1DiracRate

/-- The skew-Hermitian matrix expected to generate the exact time flow at a
fixed momentum. -/
def fibreGenerator (kx ky kz m : Real) : Mat4 :=
  (-I : Complex) • H kx ky kz m

/-- **Immutable generator target.**  Differentiating the exact matrix flow in
real time gives right multiplication by its fixed fibre generator. -/
theorem exactFlow_hasDerivAt (kx ky kz m t : Real) :
    HasDerivAt (fun s : Real => exactFlow kx ky kz m s)
      (exactFlow kx ky kz m t * fibreGenerator kx ky kz m) t := by
  have key : ∀ s : ℝ, exactFlow kx ky kz m s
      = NormedSpace.exp (s • fibreGenerator kx ky kz m) := by
    intro s
    rw [exactFlow, fibreGenerator]
    congr 1
    rw [smul_smul, ← smul_assoc]
    congr 1
    rw [Complex.real_smul]; ring
  have h := hasDerivAt_exp_smul_const (𝕂 := ℝ) (fibreGenerator kx ky kz m) t
  rw [show (fun s : Real => exactFlow kx ky kz m s)
      = (fun u : ℝ => NormedSpace.exp (u • fibreGenerator kx ky kz m)) from funext key,
      key t]
  exact h

/-- At zero time the derivative of the exact multiplier acting on a spinor is
the same matrix generator acting on that spinor. -/
theorem momMult_apply_hasDerivAt_zero (m : Real) (k : FourierMomentum3)
    (v : ChangingCellScaledLiveWalk.Spinor) :
    HasDerivAt (fun t : Real => momMult m t k v)
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
        (fibreGenerator (k 0) (k 1) (k 2) m) v) 0 := by
  have h1 := exactFlow_hasDerivAt (k 0) (k 1) (k 2) m 0
  let lin : Mat4 →ₗ[Complex] Spinor :=
    { toFun := fun M => Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) M v
      map_add' := by intro a b; rw [map_add]; rfl
      map_smul' := by intro c M; rw [map_smul]; rfl }
  let L : Mat4 →L[Real] Spinor :=
    (LinearMap.toContinuousLinearMap lin).restrictScalars Real
  have hL := (L.hasFDerivAt).comp_hasDerivAt (0 : ℝ) h1
  have hzero : exactFlow (k 0) (k 1) (k 2) m 0 = 1 := by
    simp [exactFlow, NormedSpace.exp_zero]
  have hval : L (exactFlow (k 0) (k 1) (k 2) m 0 * fibreGenerator (k 0) (k 1) (k 2) m)
      = Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
          (fibreGenerator (k 0) (k 1) (k 2) m) v := by
    rw [hzero, one_mul]; rfl
  rw [← hval]
  exact hL

/-! ## Scope and non-degeneracy controls -/

/-- The rest-fibre generator contains the supplied nonzero mass coefficient;
the target is not a derivative of a constant identity family. -/
theorem fibreGenerator_rest_four :
    fibreGenerator 0 0 0 4 = (-4 * I : Complex) • beta := by
  simp [fibreGenerator, H, smul_smul]
  rw [mul_comm I 4]

end PhysicsSM.Draft.NullEdge.ExactFlowGenerator
