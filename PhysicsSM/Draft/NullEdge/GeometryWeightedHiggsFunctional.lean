import PhysicsSM.Draft.NullEdge.FiniteMatterWeightVariation

/-!
# Geometry-weighted finite Abelian Higgs functional

This module couples a complex vertex field to a `U(1)` edge connection and
supplied real edge and vertex weights. It proves exact finite gauge covariance,
gauge invariance, positivity under explicit sign hypotheses, frozen-modulus
reduction, and zero cost for a covariantly constant vacuum. It also connects
the functional to `FiniteMatterWeightVariation`, so geometry-weight variation
and its gauge invariance are explicit.

The weights remain arbitrary background data. This module does not derive them
from a graph metric, coframe, or volume measure, and it does not construct a
stress tensor. The one-component Abelian field is a control model, not the full
electroweak Higgs doublet. Its quartic potential is normalized to vanish on the
displayed vacuum; this convention does not solve the vacuum-energy problem.

The five core finite identities were proved by Aristotle in project
`f0ffff98-a4f2-4a0f-b970-a73c0fd4c1f7`, replayed under the pinned toolchain,
and adapted here without statement weakening. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional

open scoped BigOperators
open PhysicsSM.Draft.NullEdge.FiniteMatterWeightVariation

variable {V E : Type*} [Fintype V] [Fintype E]

/-- Gauge-covariant endpoint difference on one directed edge. -/
def covariantDifference
    (s t : E -> V) (phi : V -> Complex) (U : E -> Circle) (e : E) : Complex :=
  (U e : Complex) * phi (t e) - phi (s e)

/-- Local `U(1)` transformation of a vertex field. -/
def gaugeTransformField (g : V -> Circle) (phi : V -> Complex) : V -> Complex :=
  fun x => (g x : Complex) * phi x

/-- Endpoint gauge transformation of a directed-edge connection. -/
def gaugeTransformConnection
    (s t : E -> V) (g : V -> Circle) (U : E -> Circle) : E -> Circle :=
  fun e => g (s e) * U e * (g (t e))⁻¹

/-- Radial quartic potential density for one complex Higgs component. -/
def radialPotentialDensity (lam vacuum : Real) (z : Complex) : Real :=
  lam * (Complex.normSq z - vacuum ^ 2) ^ 2

/-- Finite Higgs functional with supplied edge and vertex weights. The edge
weights may be signed; nonnegativity is a separate theorem with explicit
hypotheses. -/
def weightedHiggsFunctional
    (s t : E -> V) (edgeWeight : E -> Real) (vertexWeight : V -> Real)
    (lam vacuum : Real) (phi : V -> Complex) (U : E -> Circle) : Real :=
  (∑ e, edgeWeight e * Complex.normSq (covariantDifference s t phi U e)) +
    ∑ x, vertexWeight x * radialPotentialDensity lam vacuum (phi x)

/-- First response of the weighted Higgs functional to supplied edge and
vertex geometry-weight responses, with `phi` and `U` held fixed. -/
def higgsWeightResponse
    (s t : E -> V) (edgeResponse : E -> Real) (vertexResponse : V -> Real)
    (lam vacuum : Real) (phi : V -> Complex) (U : E -> Circle) : Real :=
  matterWeightResponse edgeResponse vertexResponse
    (fun e => Complex.normSq (covariantDifference s t phi U e))
    (fun x => radialPotentialDensity lam vacuum (phi x))

omit [Fintype V] [Fintype E] in
/-- The edge difference transforms only at its source endpoint. -/
theorem covariantDifference_gauge_transform
    (s t : E -> V) (phi : V -> Complex) (U : E -> Circle)
    (g : V -> Circle) (e : E) :
    covariantDifference s t (gaugeTransformField g phi)
        (gaugeTransformConnection s t g U) e =
      (g (s e) : Complex) * covariantDifference s t phi U e := by
  unfold covariantDifference gaugeTransformField gaugeTransformConnection
  simp +decide [mul_sub, mul_assoc, mul_left_comm]

/-- Arbitrary fixed real geometry weights preserve local gauge invariance. -/
theorem weightedHiggsFunctional_gauge_invariant
    (s t : E -> V) (edgeWeight : E -> Real) (vertexWeight : V -> Real)
    (lam vacuum : Real) (phi : V -> Complex) (U : E -> Circle)
    (g : V -> Circle) :
    weightedHiggsFunctional s t edgeWeight vertexWeight lam vacuum
        (gaugeTransformField g phi) (gaugeTransformConnection s t g U) =
      weightedHiggsFunctional s t edgeWeight vertexWeight lam vacuum phi U := by
  unfold weightedHiggsFunctional
  congr! 2
  · simp +decide [covariantDifference_gauge_transform, Complex.normSq_mul]
  · simp +decide [gaugeTransformField, radialPotentialDensity,
      Complex.normSq_eq_norm_sq]

/-- Nonnegative geometry weights and quartic coupling give a nonnegative
finite functional. -/
theorem weightedHiggsFunctional_nonneg
    (s t : E -> V) (edgeWeight : E -> Real) (vertexWeight : V -> Real)
    (lam vacuum : Real) (phi : V -> Complex) (U : E -> Circle)
    (hEdge : ∀ e, 0 <= edgeWeight e)
    (hVertex : ∀ x, 0 <= vertexWeight x)
    (hLam : 0 <= lam) :
    0 <= weightedHiggsFunctional s t edgeWeight vertexWeight lam vacuum phi U := by
  exact add_nonneg
    (Finset.sum_nonneg fun e _ =>
      mul_nonneg (hEdge e) (Complex.normSq_nonneg _))
    (Finset.sum_nonneg fun x _ =>
      mul_nonneg (hVertex x) (mul_nonneg hLam (sq_nonneg _)))

/-- With frozen modulus, the radial potential vanishes and the finite
functional reduces exactly to the weighted gauge-invariant link mismatch. -/
theorem weightedHiggsFunctional_frozen_modulus
    (s t : E -> V) (edgeWeight : E -> Real) (vertexWeight : V -> Real)
    (lam vacuum : Real) (sigma : V -> Circle) (U : E -> Circle) :
    weightedHiggsFunctional s t edgeWeight vertexWeight lam vacuum
        (fun x => (vacuum : Complex) * (sigma x : Complex)) U =
      vacuum ^ 2 * ∑ e, edgeWeight e * Complex.normSq
        (((sigma (s e))⁻¹ * U e * sigma (t e) : Circle) - 1 : Complex) := by
  convert Finset.mul_sum _ _ _ using 2
  rotate_left
  rw [Finset.mul_sum _ _ _]
  unfold weightedHiggsFunctional
  simp +decide [radialPotentialDensity, mul_comm, Complex.normSq_eq_norm_sq]
  rw [Finset.mul_sum _ _ _]
  congr
  ext e
  unfold covariantDifference
  ring
  field_simp
  norm_num [mul_assoc, mul_div_assoc, Complex.normSq, Complex.sq_norm]
  ring
  norm_num [Complex.normSq, Complex.sq_norm]
  ring
  norm_num

/-- A covariantly constant frozen-modulus vacuum has exactly zero finite
Higgs cost, independently of the supplied weights. -/
theorem weightedHiggsFunctional_parallel_vacuum_zero
    (s t : E -> V) (edgeWeight : E -> Real) (vertexWeight : V -> Real)
    (lam vacuum : Real) (sigma : V -> Circle) :
    weightedHiggsFunctional s t edgeWeight vertexWeight lam vacuum
        (fun x => (vacuum : Complex) * (sigma x : Complex))
        (fun e => sigma (s e) * (sigma (t e))⁻¹) = 0 := by
  rw [weightedHiggsFunctional_frozen_modulus]
  simp +decide [← mul_assoc]

/-- Pointwise derivatives of the supplied geometry weights differentiate the
complete finite Higgs functional to `higgsWeightResponse`. This still does not
identify the parameter with a metric or coframe component. -/
theorem hasDerivAt_weightedHiggsFunctional_weights
    (s t : E -> V)
    (edgeWeight : Real -> E -> Real) (vertexWeight : Real -> V -> Real)
    (edgeResponse : E -> Real) (vertexResponse : V -> Real)
    (lam vacuum : Real) (phi : V -> Complex) (U : E -> Circle) (q0 : Real)
    (hEdge : ∀ e, HasDerivAt (fun q => edgeWeight q e) (edgeResponse e) q0)
    (hVertex : ∀ x, HasDerivAt (fun q => vertexWeight q x) (vertexResponse x) q0) :
    HasDerivAt
      (fun q => weightedHiggsFunctional s t (edgeWeight q) (vertexWeight q)
        lam vacuum phi U)
      (higgsWeightResponse s t edgeResponse vertexResponse
        lam vacuum phi U)
      q0 := by
  simpa [weightedHiggsFunctional, higgsWeightResponse,
    weightedMatterFunctional] using
    hasDerivAt_weightedMatterFunctional edgeWeight vertexWeight
      (fun e => Complex.normSq (covariantDifference s t phi U e))
      (fun x => radialPotentialDensity lam vacuum (phi x))
      edgeResponse vertexResponse q0 hEdge hVertex

/-- The finite geometry-weight response is gauge invariant for arbitrary
supplied response weights. -/
theorem higgsWeightResponse_gauge_invariant
    (s t : E -> V) (edgeResponse : E -> Real) (vertexResponse : V -> Real)
    (lam vacuum : Real) (phi : V -> Complex) (U : E -> Circle)
    (g : V -> Circle) :
    higgsWeightResponse s t edgeResponse vertexResponse lam vacuum
        (gaugeTransformField g phi) (gaugeTransformConnection s t g U) =
      higgsWeightResponse s t edgeResponse vertexResponse lam vacuum phi U := by
  unfold higgsWeightResponse
  apply matterWeightResponse_congr
  · intro e
    rw [covariantDifference_gauge_transform, Complex.normSq_mul]
    have hg : Complex.normSq (g (s e) : Complex) = 1 := by
      rw [Complex.normSq_eq_norm_sq, Circle.norm_coe]
      norm_num
    rw [hg, one_mul]
  · intro x
    unfold gaugeTransformField radialPotentialDensity
    rw [Complex.normSq_mul]
    have hg : Complex.normSq (g x : Complex) = 1 := by
      rw [Complex.normSq_eq_norm_sq, Circle.norm_coe]
      norm_num
    rw [hg, one_mul]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional.weightedHiggsFunctional_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weightedHiggsFunctional_gauge_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional.weightedHiggsFunctional_frozen_modulus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weightedHiggsFunctional_frozen_modulus

/-- info: 'PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional.hasDerivAt_weightedHiggsFunctional_weights' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_weightedHiggsFunctional_weights

/-- info: 'PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional.higgsWeightResponse_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms higgsWeightResponse_gauge_invariant

end PhysicsSM.Draft.NullEdge.GeometryWeightedHiggsFunctional

end
