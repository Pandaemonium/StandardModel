import PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion
import Mathlib.Analysis.Calculus.Taylor

noncomputable section

open scoped Matrix.Norms.Frobenius

/-!
# Automatic quadratic expansions for twice-differentiable curves

This module closes the standard finite-dimensional Taylor bridge deliberately
left open by `SecondOrderCurveExpansion`.  A `C^2` curve in a real normed vector
space has the normalized expansion used by the null-edge Palatini modules, with
quadratic coefficient one half of its second iterated derivative.

For matrix curves, an exact right-inverse identity then forces the inverse
curve's linear and quadratic coefficients.  Thus downstream link calculations
need Taylor data only for the forward curve; inverse-link coefficients are not
independent assumptions.

Claim label: finite-dimensional analytic infrastructure.  Originality tag:
`[comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.SecondOrderCurveTaylor

open Filter Topology Asymptotics
open PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent

namespace QuadraticExpansionAtZero

/-- Taylor's theorem gives the normalized little-o quadratic residual used by
`QuadraticExpansionAtZero`. -/
theorem contDiffTwo_residual_isLittleO
    {E : Type*} [NormedAddCommGroup E] [NormedSpace Real E]
    {curve : Real -> E} (hCurve : ContDiff Real 2 curve) :
    (fun t => curve t -
      (curve 0 + t • deriv curve 0 +
        t ^ 2 • ((1 / 2 : Real) • iteratedDeriv 2 curve 0))) =o[nhds 0]
      (fun t : Real => t ^ 2) := by
  have h := taylor_isLittleO (f := curve) (x₀ := 0) (n := 2)
    (s := Set.univ) convex_univ (Set.mem_univ 0)
    (contDiffOn_univ.mpr hCurve)
  rw [nhdsWithin_univ] at h
  norm_num [taylor_within_apply, iteratedDerivWithin_univ,
    Finset.sum_range_succ, smul_smul, mul_assoc, mul_comm,
    mul_left_comm] at h ⊢
  exact h

/-- Every `C^2` real curve has a canonical normalized quadratic expansion at
zero. -/
def ofContDiffTwo
    {E : Type*} [NormedAddCommGroup E] [NormedSpace Real E]
    {curve : Real -> E} (hCurve : ContDiff Real 2 curve) :
    QuadraticExpansionAtZero curve (curve 0) (deriv curve 0)
      ((1 / 2 : Real) • iteratedDeriv 2 curve 0) :=
  .ofIsLittleO rfl (contDiffTwo_residual_isLittleO hCurve)

/-- The quadratic coefficient of an identically zero vector-valued curve is
zero.  This is the vector-valued coefficient-uniqueness lemma missing from the
scalar Palatini residual specialization. -/
theorem quadratic_eq_zero_of_eq_zero_vector
    {E : Type*} [NormedAddCommGroup E] [NormedSpace Real E]
    {curve : Real -> E} {quadratic : E}
    (hExpansion : QuadraticExpansionAtZero curve 0 0 quadratic)
    (hZero : forall t, curve t = 0) :
    quadratic = 0 := by
  have hCoefficient :
      (fun t => quadratic + hExpansion.remainder t) =ᶠ[nhdsWithin 0 {0}ᶜ]
        (fun _ => 0) := by
    filter_upwards [self_mem_nhdsWithin] with t ht
    have h := hExpansion.expansion t
    rw [hZero t] at h
    simp only [zero_add, smul_zero] at h
    rw [← smul_add] at h
    exact (smul_eq_zero.mp h.symm).resolve_left (pow_ne_zero 2 ht)
  have hRemainderWithin :
      Tendsto hExpansion.remainder (nhdsWithin 0 {0}ᶜ) (nhds 0) :=
    hExpansion.remainder_tendsto.mono_left inf_le_left
  have hToQuadratic :
      Tendsto (fun t => quadratic + hExpansion.remainder t)
        (nhdsWithin 0 {0}ᶜ) (nhds quadratic) := by
    simpa using tendsto_const_nhds.add hRemainderWithin
  have hToZero :
      Tendsto (fun t => quadratic + hExpansion.remainder t)
        (nhdsWithin 0 {0}ᶜ) (nhds 0) :=
    tendsto_const_nhds.congr' hCoefficient.symm
  exact tendsto_nhds_unique hToQuadratic hToZero

/-- The linear coefficient of a normalized expansion is unique. -/
theorem linear_unique
    {E : Type*} [NormedAddCommGroup E] [NormedSpace Real E]
    {curve : Real -> E} {baseLeft linearLeft quadraticLeft : E}
    {baseRight linearRight quadraticRight : E}
    (hLeft : QuadraticExpansionAtZero curve
      baseLeft linearLeft quadraticLeft)
    (hRight : QuadraticExpansionAtZero curve
      baseRight linearRight quadraticRight) :
    linearLeft = linearRight :=
  hLeft.hasDerivAt.unique hRight.hasDerivAt

/-- Once the base and linear coefficients agree, the quadratic coefficient of
a normalized expansion is unique. -/
theorem quadratic_unique
    {E : Type*} [NormedAddCommGroup E] [NormedSpace Real E]
    {curve : Real -> E} {base linear quadraticLeft quadraticRight : E}
    (hLeft : QuadraticExpansionAtZero curve
      base linear quadraticLeft)
    (hRight : QuadraticExpansionAtZero curve
      base linear quadraticRight) :
    quadraticLeft = quadraticRight := by
  have hSub : QuadraticExpansionAtZero
      (fun t => curve t - curve t) 0 0
        (quadraticLeft - quadraticRight) := by
    simpa using hLeft.sub hRight
  have hZero : forall t, curve t - curve t = 0 := by simp
  exact sub_eq_zero.mp
    (quadratic_eq_zero_of_eq_zero_vector hSub hZero)

/-- A `C^2` right-inverse matrix curve has the inverse quadratic expansion
forced by the forward expansion and the exact product identity. -/
def matrixRightInverseOfContDiffTwo
    {forward inverseCurve : Real -> Matrix (Fin 4) (Fin 4) Real}
    {linear quadratic : Matrix (Fin 4) (Fin 4) Real}
    (hForward : QuadraticExpansionAtZero forward 1 linear quadratic)
    (hInverseCurve : ContDiff Real 2 inverseCurve)
    (hRightInverse : forall t, forward t * inverseCurve t = 1) :
    QuadraticExpansionAtZero inverseCurve 1 (-linear)
      (linear * linear - quadratic) := by
  let raw := ofContDiffTwo hInverseCurve
  have hInverseZero : inverseCurve 0 = 1 := by
    have h := hRightInverse 0
    rw [hForward.value_zero] at h
    simpa using h
  let inverseExpansion : QuadraticExpansionAtZero inverseCurve 1
      (deriv inverseCurve 0)
      ((1 / 2 : Real) • iteratedDeriv 2 inverseCurve 0) :=
    raw.congr rfl hInverseZero rfl rfl
  let productExpansion := hForward.matrixMul inverseExpansion
  have hProduct : QuadraticExpansionAtZero (fun _ : Real => 1)
      1
      (deriv inverseCurve 0 + linear)
      ((1 / 2 : Real) • iteratedDeriv 2 inverseCurve 0 + quadratic +
        linear * deriv inverseCurve 0) := by
    apply productExpansion.congr
    · funext t
      exact hRightInverse t
    · simp
    · simp [add_comm]
    · simp
      module
  have hLinearSum : deriv inverseCurve 0 + linear = 0 :=
    linear_unique hProduct
      (.constant (1 : Matrix (Fin 4) (Fin 4) Real))
  have hInverseLinear : deriv inverseCurve 0 = -linear :=
    eq_neg_of_add_eq_zero_left hLinearSum
  let hProductZero : QuadraticExpansionAtZero (fun _ : Real => 1)
      1 0
      ((1 / 2 : Real) • iteratedDeriv 2 inverseCurve 0 + quadratic +
        linear * deriv inverseCurve 0) :=
    hProduct.congr rfl rfl hLinearSum rfl
  have hQuadraticSum :
      (1 / 2 : Real) • iteratedDeriv 2 inverseCurve 0 + quadratic +
          linear * deriv inverseCurve 0 = 0 :=
    quadratic_unique hProductZero
      (.constant (1 : Matrix (Fin 4) (Fin 4) Real))
  have hInverseQuadratic :
      (1 / 2 : Real) • iteratedDeriv 2 inverseCurve 0 =
        linear * linear - quadratic := by
    rw [hInverseLinear] at hQuadraticSum
    simp only [mul_neg] at hQuadraticSum
    have hLinearSquare :
        (1 / 2 : Real) • iteratedDeriv 2 inverseCurve 0 + quadratic =
          linear * linear := by
      simpa using eq_neg_of_add_eq_zero_left hQuadraticSum
    exact eq_sub_of_add_eq hLinearSquare
  exact inverseExpansion.congr rfl rfl hInverseLinear hInverseQuadratic

/-- For a curve of invertible matrices, `C^2` regularity of the underlying
forward matrix curve automatically supplies the forced inverse expansion. -/
def unitInverseOfContDiffTwo
    {curve : Real -> GL4}
    {linear correction : Matrix (Fin 4) (Fin 4) Real}
    (hCurve : ContDiff Real 2 (fun t => unitMatrix (curve t)))
    (hForward : QuadraticExpansionAtZero
      (fun t => unitMatrix (curve t)) 1 linear
      ((1 / 2 : Real) • (linear * linear + correction))) :
    QuadraticExpansionAtZero
      (fun t => unitMatrix (curve t)⁻¹) 1 (-linear)
      ((1 / 2 : Real) • (linear * linear - correction)) := by
  have hInverseCurve :
      ContDiff Real 2 (fun t => unitMatrix (curve t)⁻¹) := by
    rw [contDiff_iff_contDiffAt]
    intro t
    have hAt :=
      (contDiffAt_ringInverse Real (curve t)).comp t hCurve.contDiffAt
    have hFunction :
        (Ring.inverse ∘ fun s => unitMatrix (curve s)) =
          (fun s => unitMatrix (curve s)⁻¹) := by
      funext s
      simpa only [Function.comp_apply, unitMatrix] using
        Ring.inverse_unit (curve s)
    rw [← hFunction]
    exact hAt
  let expansion := matrixRightInverseOfContDiffTwo hForward hInverseCurve
    (fun t => by simp [unitMatrix])
  apply expansion.congr rfl rfl rfl
  module

end QuadraticExpansionAtZero

/-! ## Trust guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SecondOrderCurveTaylor.QuadraticExpansionAtZero.ofContDiffTwo' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms QuadraticExpansionAtZero.ofContDiffTwo

/-- info: 'PhysicsSM.Draft.NullEdge.SecondOrderCurveTaylor.QuadraticExpansionAtZero.matrixRightInverseOfContDiffTwo' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms QuadraticExpansionAtZero.matrixRightInverseOfContDiffTwo

/-- info: 'PhysicsSM.Draft.NullEdge.SecondOrderCurveTaylor.QuadraticExpansionAtZero.unitInverseOfContDiffTwo' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms QuadraticExpansionAtZero.unitInverseOfContDiffTwo

/-- info: 'PhysicsSM.Draft.NullEdge.SecondOrderCurveTaylor.QuadraticExpansionAtZero.quadratic_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms QuadraticExpansionAtZero.quadratic_unique

end PhysicsSM.Draft.NullEdge.SecondOrderCurveTaylor
