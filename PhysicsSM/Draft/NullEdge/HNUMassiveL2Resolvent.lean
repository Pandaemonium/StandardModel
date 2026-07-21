import PhysicsSM.Draft.NullEdge.HNUMassiveFibreResolvent
import PhysicsSM.Draft.NullEdge.VariablePointwiseL2Contraction

/-!
# Bounded global L2 resolvents for the massive HNU Dirac multiplier

The explicit finite-fibre inverses of `H(q) - i I` and `H(q) + i I` are
continuous contraction-valued functions of momentum. This module lifts those
families, without choosing point values of `L2` equivalence classes, to bounded
complex-linear operators on momentum-space `L2`. Both global resolvents have
operator norm at most one and retain their expected pointwise formula almost
everywhere.

This is the bounded analytic half of the maximal graph-domain construction.
The remaining unbounded-operator theorem must define the multiplication
operator on its maximal domain and prove that these bounded maps are its
two-sided imaginary resolvents.

Provenance: clean-room composition of `HNUMassiveFibreResolvent` and
`VariablePointwiseL2Contraction`, following the standard direct-integral
resolvent construction for self-adjoint matrix multipliers. Lean 4.28.0.
Claim grade `M`, `[comp]`.
-/

noncomputable section

open Matrix Complex MeasureTheory
open scoped Matrix.Norms.L2Operator

set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.HNUMassiveL2Resolvent

open ChangingCellFourierL2
open HNUMassiveCompactSupportL2Generator
open HNUMassiveContinuumReduction
open HNUMassiveFibreResolvent
open Pluecker3Plus1ComplexMass
open VariablePointwiseL2Contraction
open VariablePointwiseL2Isometry

abbrev FourierMomentum3 := ChangingCellFourierL2.FourierMomentum3
abbrev Spinor := EuclideanSpace Complex (Fin 4)
abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- The explicit inverse of `H(q) - i I`, acting on the Euclidean spinor
fibre. -/
def minusResolventFamily (z : Complex) (q : FourierMomentum3) :
    Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
    (minusShiftInverse z q)

/-- The explicit inverse of `H(q) + i I`, acting on the Euclidean spinor
fibre. -/
def plusResolventFamily (z : Complex) (q : FourierMomentum3) :
    Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)
    (plusShiftInverse z q)

/-- The negative-shift inverse family is continuous in momentum. -/
theorem minusResolventFamily_continuous (z : Complex) :
    Continuous (minusResolventFamily z) := by
  unfold minusResolventFamily
  have hToCLM : Isometry
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)) := by
    apply Isometry.of_dist_eq
    intro A B
    simpa [dist_eq_norm, map_sub] using
      Matrix.l2_opNorm_toEuclideanCLM (A - B)
  apply hToCLM.continuous.comp
  have hcoord : forall i : Fin 3,
      Continuous (fun q : FourierMomentum3 => ((q i : Real) : Complex)) := by
    intro i
    exact Complex.continuous_ofReal.comp
      (PiLp.continuous_apply (p := 2) (β := fun _ : Fin 3 => Real) i)
  have hgen : Continuous
      (fun q : FourierMomentum3 => massiveGenerator z q) := by
    simp only [massiveGenerator_eq_H4]
    unfold H4
    exact ((((hcoord 0).smul continuous_const).add
      ((hcoord 1).smul continuous_const)).add
      ((hcoord 2).smul continuous_const)).add continuous_const
  have hdenom : Continuous
      (fun q : FourierMomentum3 => resolventDenom z q) := by
    unfold resolventDenom massShellSq
    fun_prop
  have hinv : Continuous
      (fun q : FourierMomentum3 =>
        (((resolventDenom z q : Real) : Complex)⁻¹)) := by
    exact (Complex.continuous_ofReal.comp hdenom).inv₀
      (fun q => resolventDenom_ne_zero_complex z q)
  unfold minusShiftInverse
  exact hinv.smul (hgen.add continuous_const)

/-- The positive-shift inverse family is continuous in momentum. -/
theorem plusResolventFamily_continuous (z : Complex) :
    Continuous (plusResolventFamily z) := by
  unfold plusResolventFamily
  have hToCLM : Isometry
      (Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := Complex)) := by
    apply Isometry.of_dist_eq
    intro A B
    simpa [dist_eq_norm, map_sub] using
      Matrix.l2_opNorm_toEuclideanCLM (A - B)
  apply hToCLM.continuous.comp
  have hcoord : forall i : Fin 3,
      Continuous (fun q : FourierMomentum3 => ((q i : Real) : Complex)) := by
    intro i
    exact Complex.continuous_ofReal.comp
      (PiLp.continuous_apply (p := 2) (β := fun _ : Fin 3 => Real) i)
  have hgen : Continuous
      (fun q : FourierMomentum3 => massiveGenerator z q) := by
    simp only [massiveGenerator_eq_H4]
    unfold H4
    exact ((((hcoord 0).smul continuous_const).add
      ((hcoord 1).smul continuous_const)).add
      ((hcoord 2).smul continuous_const)).add continuous_const
  have hdenom : Continuous
      (fun q : FourierMomentum3 => resolventDenom z q) := by
    unfold resolventDenom massShellSq
    fun_prop
  have hinv : Continuous
      (fun q : FourierMomentum3 =>
        (((resolventDenom z q : Real) : Complex)⁻¹)) := by
    exact (Complex.continuous_ofReal.comp hdenom).inv₀
      (fun q => resolventDenom_ne_zero_complex z q)
  unfold plusShiftInverse
  exact hinv.smul (hgen.sub continuous_const)

/-- The negative-shift inverse is a pointwise contraction. -/
theorem minusResolventFamily_contraction (z : Complex)
    (q : FourierMomentum3) (v : Spinor) :
    norm (minusResolventFamily z q v) <= norm v :=
  minusShiftInverse_norm_le z q v

/-- The positive-shift inverse is a pointwise contraction. -/
theorem plusResolventFamily_contraction (z : Complex)
    (q : FourierMomentum3) (v : Spinor) :
    norm (plusResolventFamily z q v) <= norm v :=
  plusShiftInverse_norm_le z q v

/-- The bounded global resolvent of the massive HNU momentum multiplier at
spectral parameter `i`. -/
def minusResolventL2 (z : Complex) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) →L[Complex]
      Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  variablePointwiseL2Contraction (volume : Measure FourierMomentum3)
    (minusResolventFamily z)
    (minusResolventFamily_continuous z).aestronglyMeasurable
    (minusResolventFamily_contraction z)

/-- The bounded global resolvent of the massive HNU momentum multiplier at
spectral parameter `-i`. -/
def plusResolventL2 (z : Complex) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) →L[Complex]
      Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  variablePointwiseL2Contraction (volume : Measure FourierMomentum3)
    (plusResolventFamily z)
    (plusResolventFamily_continuous z).aestronglyMeasurable
    (plusResolventFamily_contraction z)

/-- The global negative-shift resolvent has operator norm at most one. -/
theorem minusResolventL2_norm_le_one (z : Complex) :
    norm (minusResolventL2 z) <= 1 :=
  variablePointwiseL2Contraction_norm_le_one
    (volume : Measure FourierMomentum3) (minusResolventFamily z)
    (minusResolventFamily_continuous z).aestronglyMeasurable
    (minusResolventFamily_contraction z)

/-- The global positive-shift resolvent has operator norm at most one. -/
theorem plusResolventL2_norm_le_one (z : Complex) :
    norm (plusResolventL2 z) <= 1 :=
  variablePointwiseL2Contraction_norm_le_one
    (volume : Measure FourierMomentum3) (plusResolventFamily z)
    (plusResolventFamily_continuous z).aestronglyMeasurable
    (plusResolventFamily_contraction z)

/-- The global negative-shift resolvent retains the explicit fibre formula
almost everywhere. -/
theorem minusResolventL2_coeFn (z : Complex)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    minusResolventL2 z f =ᵐ[volume]
      fun q => minusResolventFamily z q (f q) := by
  exact variablePointwiseL2Contraction_coeFn
    (volume : Measure FourierMomentum3) (minusResolventFamily z)
    (minusResolventFamily_continuous z).aestronglyMeasurable
    (minusResolventFamily_contraction z) f

/-- The global positive-shift resolvent retains the explicit fibre formula
almost everywhere. -/
theorem plusResolventL2_coeFn (z : Complex)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    plusResolventL2 z f =ᵐ[volume]
      fun q => plusResolventFamily z q (f q) := by
  exact variablePointwiseL2Contraction_coeFn
    (volume : Measure FourierMomentum3) (plusResolventFamily z)
    (plusResolventFamily_continuous z).aestronglyMeasurable
    (plusResolventFamily_contraction z) f

end PhysicsSM.Draft.NullEdge.HNUMassiveL2Resolvent

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveL2Resolvent.minusResolventL2_norm_le_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveL2Resolvent.minusResolventL2_norm_le_one

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveL2Resolvent.minusResolventL2_coeFn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveL2Resolvent.minusResolventL2_coeFn
