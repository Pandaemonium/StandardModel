import PhysicsSM.Draft.NullEdge.HNUManyStepContinuumLive

/-!
# Pointwise generator of the exact HNU Weyl flow

This module identifies the infinitesimal generator of the exact two-component
continuum flow used in the HNU changing-lattice lane.  At every fixed momentum
`q`, the generator is exactly `-i H_W(q)`, and the induced action on a fixed
Weyl spinor has that derivative at zero time.

The result supplies the continuum equation that the HNU walk is intended to
approach.  It is deliberately pointwise in momentum: it does not yet compose
the changing-cell walk estimate, the ultraviolet-tail argument, or inverse
Fourier transform into a position-space convergence theorem.

Provenance: clean-room specialization of the finite-dimensional matrix
exponential derivative used in `ExactFlowGenerator.lean` to the live HNU Weyl
symbol in `HNUManyStepContinuumLive.lean`, July 20, 2026.  Claim grade `M`,
`[comp]`.
-/

noncomputable section

open Matrix Complex Real
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.HNUExactFlowGenerator

open HNUManyStepContinuum

/-- Two-component complex Weyl spinors for the HNU continuum flow. -/
abbrev WeylSpinor := EuclideanSpace Complex (Fin 2)

/-- The skew-Hermitian matrix generating the exact HNU Weyl flow at momentum
`q`. -/
def fibreGenerator (q : Fin 3 -> Real) : Mat :=
  (-I : Complex) • Hw q

/-- Differentiating the exact HNU continuum flow in real time gives right
multiplication by `-i H_W(q)`. -/
theorem Eflow_hasDerivAt (q : Fin 3 -> Real) (t : Real) :
    HasDerivAt (fun s : Real => Eflow q s)
      (Eflow q t * fibreGenerator q) t := by
  have key : ∀ s : Real, Eflow q s =
      NormedSpace.exp (s • fibreGenerator q) := by
    intro s
    rw [Eflow, fibreGenerator]
    congr 1
    rw [smul_smul, ← smul_assoc]
    congr 1
    rw [Complex.real_smul]
    ring
  have h := hasDerivAt_exp_smul_const (𝕂 := Real) (fibreGenerator q) t
  rw [show (fun s : Real => Eflow q s) =
      (fun u : Real => NormedSpace.exp (u • fibreGenerator q)) from funext key,
      key t]
  exact h

/-- At zero time, the exact HNU multiplier acting on a fixed Weyl spinor has
derivative `-i H_W(q)` acting on that spinor. -/
theorem Eflow_apply_hasDerivAt_zero (q : Fin 3 -> Real) (v : WeylSpinor) :
    HasDerivAt
      (fun t : Real =>
        Matrix.toEuclideanCLM (n := Fin 2) (𝕜 := Complex) (Eflow q t) v)
      (Matrix.toEuclideanCLM (n := Fin 2) (𝕜 := Complex)
        (fibreGenerator q) v) 0 := by
  have h1 := Eflow_hasDerivAt q 0
  let lin : Mat →ₗ[Complex] WeylSpinor :=
    { toFun := fun M =>
        Matrix.toEuclideanCLM (n := Fin 2) (𝕜 := Complex) M v
      map_add' := by intro a b; rw [map_add]; rfl
      map_smul' := by intro c M; rw [map_smul]; rfl }
  let L : Mat →L[Real] WeylSpinor :=
    (LinearMap.toContinuousLinearMap lin).restrictScalars Real
  have hL := (L.hasFDerivAt).comp_hasDerivAt (0 : Real) h1
  have hzero : Eflow q 0 = 1 := by
    simp [Eflow]
  have hval :
      L (Eflow q 0 * fibreGenerator q) =
        Matrix.toEuclideanCLM (n := Fin 2) (𝕜 := Complex)
          (fibreGenerator q) v := by
    rw [hzero, one_mul]
    rfl
  rw [← hval]
  exact hL

/-! ## Boundary and non-degeneracy controls -/

/-- At zero time the exact HNU flow is the identity. -/
theorem Eflow_zero_time (q : Fin 3 -> Real) : Eflow q 0 = 1 := by
  simp [Eflow]

/-- Along the first momentum axis, the generator is exactly `-i sigma_x`. -/
theorem fibreGenerator_axis :
    fibreGenerator ![1, 0, 0] = (-I : Complex) • sx := by
  rw [fibreGenerator, Hw_axis_witness]

/-- The axis generator acts nontrivially on an explicit Weyl spinor, so the
derivative theorem is not a constant-flow tautology. -/
theorem fibreGenerator_axis_action_ne_zero :
    Matrix.toEuclideanCLM (n := Fin 2) (𝕜 := Complex)
        (fibreGenerator ![1, 0, 0])
        (EuclideanSpace.single (0 : Fin 2) (1 : Complex)) ≠ 0 := by
  intro h
  have hcomp := congrArg (fun x : WeylSpinor => x 1) h
  norm_num [fibreGenerator, Hw_axis_witness, sx, Matrix.mulVec] at hcomp

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactFlowGenerator.Eflow_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Eflow_hasDerivAt

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactFlowGenerator.Eflow_apply_hasDerivAt_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Eflow_apply_hasDerivAt_zero

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactFlowGenerator.fibreGenerator_axis_action_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fibreGenerator_axis_action_ne_zero

end PhysicsSM.Draft.NullEdge.HNUExactFlowGenerator
