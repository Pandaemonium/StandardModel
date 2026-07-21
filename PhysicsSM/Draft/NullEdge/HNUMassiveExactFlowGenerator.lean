import PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowMomentumLipschitz

/-!
# Pointwise generator and time group for the live massive HNU flow

This module identifies the real-time generator of the exact four-component
flow used in the massive HNU changing-lattice theorem. The generator is the
actual live matrix `-I * (kinetic4 q + mass4 z)`, including the complex
Pluecker rest block. It also proves the pointwise one-parameter group law.

The statements are finite-dimensional and pointwise in momentum. They do not
define the corresponding unbounded multiplication operator on full `L2`,
choose a graph domain, or prove a position-space operator-closure theorem.
-/

noncomputable section

open Matrix Complex
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowGenerator

open HNUManyStepContinuum
open HNUPlueckerMassiveStay
open HNUMassiveContinuumReduction
open HNUMassiveExactFlowMomentumLipschitz

abbrev LiveMat4 := HNUMassiveContinuumReduction.Mat4
abbrev LiveSpinor := EuclideanSpace Complex (Fin 4)

/-- The skew-Hermitian matrix generating the live exact massive HNU flow at a
fixed momentum. -/
def massiveFibreGenerator (z : Complex) (q : Fin 3 -> Real) : LiveMat4 :=
  (-I : Complex) • massiveGenerator z q

/-- The complex-scalar definition of `massiveEflow` is exactly the usual
real-parameter exponential of `massiveFibreGenerator`. -/
theorem massiveEflow_eq_exp_real (z : Complex) (q : Fin 3 -> Real) (t : Real) :
    massiveEflow z q t = NormedSpace.exp (t • massiveFibreGenerator z q) := by
  rw [massiveEflow, massiveFibreGenerator]
  congr 1
  rw [smul_smul, ← smul_assoc]
  congr 1
  rw [Complex.real_smul]
  ring

/-- Differentiating the exact massive flow gives right multiplication by its
fixed live generator. -/
theorem massiveEflow_hasDerivAt (z : Complex) (q : Fin 3 -> Real) (t : Real) :
    HasDerivAt (fun s : Real => massiveEflow z q s)
      (massiveEflow z q t * massiveFibreGenerator z q) t := by
  have h := hasDerivAt_exp_smul_const (𝕂 := Real)
    (massiveFibreGenerator z q) t
  simpa only [massiveEflow_eq_exp_real] using h

/-- The live exact massive HNU flow is a pointwise time-additive
one-parameter group. -/
theorem massiveEflow_add_time (z : Complex) (q : Fin 3 -> Real) (s t : Real) :
    massiveEflow z q (s + t) =
      massiveEflow z q s * massiveEflow z q t := by
  simp only [massiveEflow_eq_exp_real, add_smul]
  exact Matrix.exp_add_of_commute _ _
    ((Commute.refl (massiveFibreGenerator z q)).smul_left s |>.smul_right t)

/-- At every fixed momentum and spinor, the exact operator orbit has the
advertised live derivative. -/
theorem massiveEflow_apply_hasDerivAt (z : Complex) (q : Fin 3 -> Real)
    (t : Real) (v : LiveSpinor) :
    HasDerivAt
      (fun s : Real =>
        Matrix.toEuclideanCLM (𝕜 := Complex) (massiveEflow z q s) v)
      (Matrix.toEuclideanCLM (𝕜 := Complex)
        (massiveEflow z q t * massiveFibreGenerator z q) v) t := by
  let lin : LiveMat4 →ₗ[Complex] LiveSpinor :=
    { toFun := fun M =>
        Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex) M v
      map_add' := by intro A B; rw [map_add]; rfl
      map_smul' := by intro c A; rw [map_smul]; rfl }
  let L : LiveMat4 →L[Real] LiveSpinor :=
    (LinearMap.toContinuousLinearMap lin).restrictScalars Real
  have h := (L.hasFDerivAt).comp_hasDerivAt t
    (massiveEflow_hasDerivAt z q t)
  change HasDerivAt
    (fun s : Real => L (massiveEflow z q s))
    (L (massiveEflow z q t * massiveFibreGenerator z q)) t
  exact h

/-- The pointwise generator is genuinely active in the pure Pluecker rest
sector; the derivative theorem is not about a constant identity family. -/
theorem massiveFibreGenerator_rest_nonzero :
    massiveFibreGenerator (3 + 4 * I) (fun _ => 0) ≠ 0 := by
  intro h
  have hgenerator : massiveGenerator (3 + 4 * I) (fun _ => 0) = 0 := by
    rcases smul_eq_zero.mp h with hI | hG
    · exfalso
      norm_num at hI
    · exact hG
  have hmass : Pluecker3Plus1ComplexMass.mass4 (3 + 4 * I) = 0 := by
    simpa [massiveGenerator, kinetic4] using hgenerator
  have hz : (3 + 4 * I : Complex) = 0 :=
    (Pluecker3Plus1ComplexMass.mass4_eq_zero_iff (3 + 4 * I)).mp hmass
  have hre := congrArg Complex.re hz
  norm_num at hre

end PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowGenerator

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowGenerator.massiveEflow_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowGenerator.massiveEflow_hasDerivAt

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowGenerator.massiveEflow_add_time' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowGenerator.massiveEflow_add_time

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowGenerator.massiveEflow_apply_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowGenerator.massiveEflow_apply_hasDerivAt

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowGenerator.massiveFibreGenerator_rest_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowGenerator.massiveFibreGenerator_rest_nonzero
