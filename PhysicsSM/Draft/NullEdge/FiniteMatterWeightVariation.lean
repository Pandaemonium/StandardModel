import Mathlib

/-!
# Finite matter response to geometry-weight variation

This module isolates the calculus step between a finite matter functional and
a gravitational source. Matter fields and connections are held fixed while
supplied edge and vertex weights vary along one real parameter. The derivative
is exactly the corresponding weighted sum of the edge and vertex densities.

This is generic variational infrastructure. It does not construct the weights
from a graph metric or coframe, identify the parameter with a metric component,
derive a stress tensor, or prove covariance or conservation. In particular, a
nonzero matter budget can have zero geometry response when the supplied weights
are constant. Claim grade: `M [comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteMatterWeightVariation

open scoped BigOperators

variable {E V : Type*} [Fintype E] [Fintype V]

/-- Finite matter functional with supplied edge and vertex weights. The
densities may later be instantiated by gauge-invariant kinetic and potential
terms. -/
def weightedMatterFunctional
    (edgeWeight : E -> Real) (vertexWeight : V -> Real)
    (edgeDensity : E -> Real) (vertexDensity : V -> Real) : Real :=
  (∑ e, edgeWeight e * edgeDensity e) +
    ∑ x, vertexWeight x * vertexDensity x

/-- Response obtained by replacing each geometry weight with its first
variation while holding the matter densities fixed. -/
def matterWeightResponse
    (edgeResponse : E -> Real) (vertexResponse : V -> Real)
    (edgeDensity : E -> Real) (vertexDensity : V -> Real) : Real :=
  (∑ e, edgeResponse e * edgeDensity e) +
    ∑ x, vertexResponse x * vertexDensity x

/-- Pointwise first variations of all finite geometry weights differentiate
the complete weighted matter functional. -/
theorem hasDerivAt_weightedMatterFunctional
    (edgeWeight : Real -> E -> Real) (vertexWeight : Real -> V -> Real)
    (edgeDensity : E -> Real) (vertexDensity : V -> Real)
    (edgeResponse : E -> Real) (vertexResponse : V -> Real) (q0 : Real)
    (hEdge : ∀ e, HasDerivAt (fun q => edgeWeight q e) (edgeResponse e) q0)
    (hVertex : ∀ x, HasDerivAt (fun q => vertexWeight q x) (vertexResponse x) q0) :
    HasDerivAt
      (fun q => weightedMatterFunctional (edgeWeight q) (vertexWeight q)
        edgeDensity vertexDensity)
      (matterWeightResponse edgeResponse vertexResponse
        edgeDensity vertexDensity)
      q0 := by
  have hEdgeSum : HasDerivAt
      (fun q => ∑ e, edgeWeight q e * edgeDensity e)
      (∑ e, edgeResponse e * edgeDensity e) q0 := by
    simpa using HasDerivAt.fun_sum (u := Finset.univ)
      (fun e _ => (hEdge e).mul_const (edgeDensity e))
  have hVertexSum : HasDerivAt
      (fun q => ∑ x, vertexWeight q x * vertexDensity x)
      (∑ x, vertexResponse x * vertexDensity x) q0 := by
    simpa using HasDerivAt.fun_sum (u := Finset.univ)
      (fun x _ => (hVertex x).mul_const (vertexDensity x))
  simpa [weightedMatterFunctional, matterWeightResponse] using
    hEdgeSum.add hVertexSum

/-- An affine path through the finite geometry weights realizes any supplied
edge and vertex response exactly. -/
theorem hasDerivAt_affineWeightPath
    (baseEdgeWeight edgeResponse : E -> Real)
    (baseVertexWeight vertexResponse : V -> Real)
    (edgeDensity : E -> Real) (vertexDensity : V -> Real) (q0 : Real) :
    HasDerivAt
      (fun q => weightedMatterFunctional
        (fun e => baseEdgeWeight e + q * edgeResponse e)
        (fun x => baseVertexWeight x + q * vertexResponse x)
        edgeDensity vertexDensity)
      (matterWeightResponse edgeResponse vertexResponse
        edgeDensity vertexDensity)
      q0 := by
  apply hasDerivAt_weightedMatterFunctional
  · intro e
    simpa [id_eq] using
      (((hasDerivAt_id q0).mul_const (edgeResponse e)).const_add
        (baseEdgeWeight e))
  · intro x
    simpa [id_eq] using
      (((hasDerivAt_id q0).mul_const (vertexResponse x)).const_add
        (baseVertexWeight x))

/-- If geometry weights do not vary, the geometry response vanishes even when
the matter functional itself is nonzero. -/
theorem hasDerivAt_constantGeometry_zeroResponse
    (edgeWeight : E -> Real) (vertexWeight : V -> Real)
    (edgeDensity : E -> Real) (vertexDensity : V -> Real) (q0 : Real) :
    HasDerivAt
      (fun _ : Real => weightedMatterFunctional edgeWeight vertexWeight
        edgeDensity vertexDensity)
      0 q0 :=
  hasDerivAt_const q0 _

/-- Pointwise equality of held-fixed matter densities gives equality of every
finite geometry-weight response. -/
theorem matterWeightResponse_congr
    (edgeResponse : E -> Real) (vertexResponse : V -> Real)
    (edgeDensity1 edgeDensity2 : E -> Real)
    (vertexDensity1 vertexDensity2 : V -> Real)
    (hEdge : ∀ e, edgeDensity1 e = edgeDensity2 e)
    (hVertex : ∀ x, vertexDensity1 x = vertexDensity2 x) :
    matterWeightResponse edgeResponse vertexResponse
        edgeDensity1 vertexDensity1 =
      matterWeightResponse edgeResponse vertexResponse
        edgeDensity2 vertexDensity2 := by
  simp only [matterWeightResponse]
  congr 1
  · apply Finset.sum_congr rfl
    intro e _
    rw [hEdge e]
  · apply Finset.sum_congr rfl
    intro x _
    rw [hVertex x]

/-- When the edge kinetic density vanishes and the vertex potential density is
one constant, the finite geometry response is that vacuum density times the
total vertex-weight response. -/
theorem constantVacuumEnergy_weightResponse
    (edgeResponse : E -> Real) (vertexResponse : V -> Real)
    (vacuumEnergy : Real) :
    matterWeightResponse edgeResponse vertexResponse
        (fun _ => 0) (fun _ => vacuumEnergy) =
      (∑ x, vertexResponse x) * vacuumEnergy := by
  simp [matterWeightResponse, Finset.sum_mul]

/-- A nonzero constant vacuum density gives a nonzero geometry response
whenever the total vertex-volume response is nonzero. -/
theorem constantVacuumEnergy_nonzeroResponse
    (edgeResponse : E -> Real) (vertexResponse : V -> Real)
    (vacuumEnergy : Real)
    (hVolume : (∑ x, vertexResponse x) ≠ 0)
    (hVacuum : vacuumEnergy ≠ 0) :
    matterWeightResponse edgeResponse vertexResponse
        (fun _ => 0) (fun _ => vacuumEnergy) ≠ 0 := by
  rw [constantVacuumEnergy_weightResponse]
  exact mul_ne_zero hVolume hVacuum

/-- Nonvacuous control: a one-edge functional has value one while every
constant-geometry path through it has zero derivative. Thus a scalar matter
budget cannot be renamed as a gravitational response. -/
theorem nonzeroBudget_zeroConstantGeometryResponse_witness :
    weightedMatterFunctional
        (fun _ : Fin 1 => 1) (fun _ : Fin 1 => 0)
        (fun _ : Fin 1 => 1) (fun _ : Fin 1 => 0) = 1 ∧
      HasDerivAt
        (fun _ : Real => weightedMatterFunctional
          (fun _ : Fin 1 => 1) (fun _ : Fin 1 => 0)
          (fun _ : Fin 1 => 1) (fun _ : Fin 1 => 0))
        0 0 := by
  constructor
  · norm_num [weightedMatterFunctional, Fin.sum_univ_one]
  · exact hasDerivAt_const 0 _

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteMatterWeightVariation.hasDerivAt_weightedMatterFunctional' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_weightedMatterFunctional

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteMatterWeightVariation.hasDerivAt_affineWeightPath' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_affineWeightPath

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteMatterWeightVariation.constantVacuumEnergy_nonzeroResponse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms constantVacuumEnergy_nonzeroResponse

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteMatterWeightVariation.nonzeroBudget_zeroConstantGeometryResponse_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonzeroBudget_zeroConstantGeometryResponse_witness

end PhysicsSM.Draft.NullEdge.FiniteMatterWeightVariation

end
