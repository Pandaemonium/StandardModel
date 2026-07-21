import PhysicsSM.Draft.NullEdge.FourierGeneratorIdentification
import PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

/-!
# Massive HNU Dirac generator on the Schwartz domain

This module specializes the generic Fourier-generator theorem to the live
four-component HNU Dirac matrices and complex Pluecker mass block. Under
Mathlib's Fourier convention, the position-space derivative coefficient is
`-I/(2*pi)` and the constant mass block transfers unchanged.

This is a generator identification on Schwartz spinors. Together with the
separate changing-lattice capstone it identifies the limiting free equation;
it is not itself a convergence theorem, an operator-closure theorem, or an
interacting field theory.
-/

open scoped BigOperators FourierTransform
open Complex Matrix

set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.HNUMassiveSchwartzPDE

noncomputable section

open PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

abbrev Momentum3 := FourierGeneratorIdentification.V 3
abbrev DiracSpinor := EuclideanSpace Complex (Fin 4)

/-- Continuous target action of the live spatial Dirac matrix. -/
def alphaCLM (j : Fin 3) : DiracSpinor →L[Complex] DiracSpinor :=
  Matrix.toEuclideanCLM (𝕜 := Complex) (alpha j)

/-- Continuous target action of the full complex Pluecker mass block. -/
def massCLM (z : Complex) : DiracSpinor →L[Complex] DiracSpinor :=
  Matrix.toEuclideanCLM (𝕜 := Complex) (mass4 z)

/-- Position-space massive Dirac differential expression in Mathlib's Fourier
normalization. -/
def positionMassiveDirac (z : Complex) :
    SchwartzMap Momentum3 DiracSpinor -> SchwartzMap Momentum3 DiracSpinor :=
  FourierGeneratorIdentification.differentialGenerator alphaCLM (massCLM z)

/-- Momentum-space massive Dirac generator built from the same live matrices. -/
def momentumMassiveDirac (z : Complex) :
    SchwartzMap Momentum3 DiracSpinor -> SchwartzMap Momentum3 DiracSpinor :=
  FourierGeneratorIdentification.momentumGenerator alphaCLM (massCLM z)

/-- The live kinetic matrix is exactly the coordinate-weighted sum of the three
Dirac alpha matrices. -/
theorem kinetic4_eq_sum_alpha (q : Momentum3) :
    kinetic4 q = ∑ j, (q j : Complex) • alpha j := by
  rw [Fin.sum_univ_three]
  rfl

/-- Exact Fourier identification of the position-space massive Dirac
expression with its live momentum-space generator. -/
theorem fourier_positionMassiveDirac (z : Complex)
    (f : SchwartzMap Momentum3 DiracSpinor) :
    𝓕 (positionMassiveDirac z f) = momentumMassiveDirac z (𝓕 f) := by
  exact FourierGeneratorIdentification.fourier_differentialGenerator_eq_momentumGenerator
    alphaCLM (massCLM z) f

/-- Pointwise, the generic momentum generator is the exact live matrix symbol
`kinetic4 q + mass4 z`. -/
theorem momentumMassiveDirac_apply (z : Complex)
    (f : SchwartzMap Momentum3 DiracSpinor) (q : Momentum3) :
    momentumMassiveDirac z f q =
      Matrix.toEuclideanCLM (𝕜 := Complex) (kinetic4 q + mass4 z) (f q) := by
  simp only [momentumMassiveDirac,
    FourierGeneratorIdentification.momentumGenerator]
  rw [kinetic4_eq_sum_alpha, map_add, map_sum]
  simp_rw [map_smul]
  simp [FourierGeneratorIdentification.constantTargetAction_apply,
    FourierGeneratorIdentification.coordinateMultiplier_apply,
    alphaCLM, massCLM]

/-- The specialized symbol retains a nonzero spatial kinetic direction even at
zero mass. -/
theorem massiveSymbol_axis_nonzero :
    kinetic4 (EuclideanSpace.single (0 : Fin 3) (1 : Real)) + mass4 0 ≠ 0 := by
  intro h
  have hentry := congrFun (congrFun h 0) 3
  norm_num [kinetic4, alpha1, alpha2, alpha3, mass4, beta, beta5, gamma5] at hentry
  simp at hentry

end


end PhysicsSM.Draft.NullEdge.HNUMassiveSchwartzPDE

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveSchwartzPDE.fourier_positionMassiveDirac' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveSchwartzPDE.fourier_positionMassiveDirac

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveSchwartzPDE.momentumMassiveDirac_apply' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveSchwartzPDE.momentumMassiveDirac_apply

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveSchwartzPDE.massiveSymbol_axis_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveSchwartzPDE.massiveSymbol_axis_nonzero
